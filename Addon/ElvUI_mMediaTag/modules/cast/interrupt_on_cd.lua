local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("InterruptOnCD", { "AceEvent-3.0" })

-- Cache WoW Globals
local pairs, ipairs = pairs, ipairs
local CreateFrame = CreateFrame
local CreateColor = CreateColor
local GetTime = GetTime
local UnitCanAttack = UnitCanAttack
local UnitExists = UnitExists
local UnitIsDead = UnitIsDead
local hooksecurefunc = hooksecurefunc
local issecretvalue = issecretvalue
local GetSpellCooldown = C_Spell.GetSpellCooldown
local GetSpellCooldownDuration = C_Spell.GetSpellCooldownDuration
local IsSpellKnownOrInSpellBook = C_SpellBook.IsSpellKnownOrInSpellBook
local FindSpellBookSlotForSpell = C_SpellBook.FindSpellBookSlotForSpell
local GetSpellBookItemCooldownDuration = C_SpellBook.GetSpellBookItemCooldownDuration
local PET_BANK = Enum.SpellBookSpellBank.Pet
local EvalColorBool = C_CurveUtil.EvaluateColorValueFromBoolean
local EvalColor = C_CurveUtil.EvaluateColorFromBoolean
local GetSpecialization = C_SpecializationInfo.GetSpecialization or GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo or GetSpecializationInfo
local IsSpellImportant = C_Spell.IsSpellImportant

local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")
local LCG = LibStub("LibCustomGlow-1.0", true)

local GLOW_KEY = "mMT_InterruptGlow"
local glowColor = {}

-- Interrupt spell IDs per spec (nil = spec has no interrupt)
local INTERRUPT_BY_SPEC = {
	-- Warrior
	[71] = 6552,
	[72] = 6552,
	[73] = 6552,
	-- Paladin
	[65] = 96231,
	[66] = 96231,
	[70] = 96231,
	-- Hunter
	[253] = 147362,
	[254] = 147362,
	[255] = 187707,
	-- Rogue
	[259] = 1766,
	[260] = 1766,
	[261] = 1766,
	-- Priest (Shadow only)
	[256] = nil,
	[257] = nil,
	[258] = 15487,
	-- Death Knight
	[250] = 47528,
	[251] = 47528,
	[252] = 47528,
	-- Shaman
	[262] = 57994,
	[263] = 57994,
	[264] = 57994,
	-- Mage
	[62] = 2139,
	[63] = 2139,
	[64] = 2139,
	-- Warlock: resolved from the active pet, see UpdateInterruptSpell
	-- Monk
	[268] = 116705,
	[269] = 116705,
	[270] = 116705,
	-- Druid
	[102] = 78675,
	[103] = 106839,
	[104] = 106839,
	[105] = 106839,
	-- Demon Hunter
	[577] = 183752,
	[581] = 183752,
	[1480] = 183752,
	-- Evoker
	[1467] = 351338,
	[1468] = 351338,
	[1473] = 351338,
}

-- Spell Lock (Felhunter), Axe Toss (Felguard): cast by the pet, the cooldown lives in the pet spellbook
local WARLOCK_PET_INTERRUPTS = { 19647, 89766 }
-- Spell Lock (Grimoire of Sacrifice), Call Felhunter (PvP talent): own player spells
local WARLOCK_PLAYER_INTERRUPTS = { 132409, 212619 }

local function UpdateWarlockInterrupt()
	for _, id in ipairs(WARLOCK_PET_INTERRUPTS) do
		local slot, bank = FindSpellBookSlotForSpell(id)
		if slot and bank == PET_BANK then
			module.interruptSpellId = id
			module.isPetInterrupt = true
			-- prefer the spell id path (ignores the pet GCD), fall back to the pet spellbook slot if the id is not resolvable
			local info = GetSpellCooldown(id)
			if not (issecretvalue(info) or info ~= nil) then module.petSlot = slot end
			return
		end
	end

	for _, id in ipairs(WARLOCK_PLAYER_INTERRUPTS) do
		if IsSpellKnownOrInSpellBook(id) then
			module.interruptSpellId = id
			return
		end
	end
end

local function UpdateInterruptSpell(event, unit)
	if event == "UNIT_PET" and unit ~= "player" then return end

	module.interruptSpellId = nil
	module.isPetInterrupt = false
	module.petSlot = nil

	if E.myclass == "WARLOCK" then return UpdateWarlockInterrupt() end

	local specIndex = GetSpecialization()
	local specId = specIndex and GetSpecializationInfo(specIndex)
	local spellId = specId and INTERRUPT_BY_SPEC[specId]

	-- skip talent gated interrupts that are not picked
	if spellId and IsSpellKnownOrInSpellBook(spellId) then module.interruptSpellId = spellId end
end

local function IsPetDown()
	return module.isPetInterrupt and (not UnitExists("pet") or UnitIsDead("pet"))
end

local function GetInterruptCooldown()
	if module.petSlot then return GetSpellBookItemCooldownDuration(module.petSlot, PET_BANK) end
	-- true = ignore the GCD, otherwise the kick counts as "on CD" briefly after every keypress
	return GetSpellCooldownDuration(module.interruptSpellId, true)
end

-- secret values can not be compared to nil
local function HasValue(value)
	return issecretvalue(value) or value ~= nil
end

local function HideKickBar(castbar)
	if castbar.mMT_KickBar then castbar.mMT_KickBar:SetAlpha(0) end
end

-- HasExpired, not IsZero: IsZero only reports "no time span stored" and stays false forever once the kick has been used.
local function IsKickReady(cooldown)
	return cooldown == nil or cooldown:HasExpired()
end

local function SetKickSpark(castbar, castStart, cooldown, ready)
	local kickBar = castbar.mMT_KickBar
	if not kickBar then return end

	-- nil = kick ready, hide a marker left over from the last update
	if cooldown == nil then
		kickBar:SetAlpha(0)
		return
	end
	local indicator = kickBar.mMT_Indicator

	if castStart then
		local isChannelOrReverse = castbar.channeling or castbar:GetReverseFill()
		local fillStyle = isChannelOrReverse and Enum.StatusBarFillStyle.Reverse or Enum.StatusBarFillStyle.Standard
		local barAnchor = isChannelOrReverse and "LEFT" or "RIGHT"
		local indicatorAnchor = isChannelOrReverse and "RIGHT" or "LEFT"

		kickBar:SetFillStyle(fillStyle)

		indicator:ClearAllPoints()
		indicator:SetPoint(indicatorAnchor, kickBar:GetStatusBarTexture(), barAnchor)
		indicator:SetSize(2, castbar:GetHeight())

		local c = module.colors.marker
		indicator:SetColorTexture(c.r, c.g, c.b)
	end

	-- elapsed cast time + remaining kick cooldown is time invariant, so re-firing this (target switch, mid-cast nameplate, OnUpdate, pushback) keeps the marker in place.
	local cdRemaining = cooldown:GetRemainingDuration()
	if castbar.startTime and castbar.max and not issecretvalue(castbar.max) and not issecretvalue(cdRemaining) then
		-- numeric path: startTime/max are plain seconds as long as the cast times are not secret.
		kickBar:SetMinMaxValues(0, castbar.max)
		kickBar:SetValue((GetTime() - castbar.startTime) + cdRemaining)
	else
		-- secret fallback: absolute time axis, Min/Max = cast start/end, Value = kick ready.
		local castDuration = castbar:GetTimerDuration()
		if castDuration then
			kickBar:SetMinMaxValues(castDuration:GetStartTime(), castDuration:GetEndTime())
			kickBar:SetValue(cooldown:GetEndTime())
		end
	end

	if castStart then
		local shieldAlpha = 0
		if HasValue(castbar.notInterruptible) then shieldAlpha = EvalColorBool(castbar.notInterruptible, 0, 1) end
		kickBar:SetAlphaFromBoolean(ready, 0, shieldAlpha)
	else
		kickBar:SetAlphaFromBoolean(ready, 0, kickBar:GetAlpha())
	end
end

local function SetCastbarColor(castbar, ready)
	local colors = module.colors
	local color = EvalColor(ready, colors.normal, colors.onCD)

	castbar:SetStatusBarColor(color:GetRGBA())

	if module.set_bg_color and castbar.bg then
		local bgColor = EvalColor(ready, colors.bgReady, colors.bgOnCD)
		castbar.bg:SetVertexColor(bgColor:GetRGBA())
	end
end

-- nested frames multiply their alpha, which ANDs the secret conditions: interruptible > important > kick ready
local function GetGlowHolder(target)
	local holder = target.mMT_InterruptGlow
	if holder then return holder end

	local interruptible = CreateFrame("Frame", nil, target)
	interruptible:SetAllPoints(target)
	interruptible:SetFrameLevel(target:GetFrameLevel() + 5)

	local important = CreateFrame("Frame", nil, interruptible)
	important:SetAllPoints(target)

	local ready = CreateFrame("Frame", nil, important)
	ready:SetAllPoints(target)

	holder = { interruptible = interruptible, important = important, ready = ready }
	target.mMT_InterruptGlow = holder
	return holder
end

local function StopGlow(target)
	local holder = target and target.mMT_InterruptGlow
	if not (holder and holder.active) then return end

	LCG.PixelGlow_Stop(holder.ready, GLOW_KEY)
	holder.active = false
end

local function StopGlows(castbar)
	if not LCG then return end
	StopGlow(castbar)
	StopGlow(castbar.__owner and castbar.__owner.Health)
end

local function UpdateGlow(target, castbar, castStart, ready)
	if not target then return end
	local glow = module.glow
	local holder = GetGlowHolder(target)

	if castStart then
		local c = module.colors.glow
		glowColor[1], glowColor[2], glowColor[3], glowColor[4] = c.r, c.g, c.b, 1
		LCG.PixelGlow_Start(holder.ready, glowColor, 8, 0.25, nil, 2, 0, 0, nil, GLOW_KEY)
		holder.active = true
	end

	-- the interruptible state can change mid cast, so it is refreshed on every update
	local notInterruptible = castbar.notInterruptible
	if HasValue(notInterruptible) then
		holder.interruptible:SetAlphaFromBoolean(notInterruptible, 0, 1)
	else
		holder.interruptible:SetAlpha(1)
	end

	if glow.important_only then
		holder.important:SetAlphaFromBoolean(castbar.mMT_IsImportant, 1, 0)
	else
		holder.important:SetAlpha(1)
	end

	if glow.ready_only then
		holder.ready:SetAlphaFromBoolean(ready, 1, 0)
	else
		holder.ready:SetAlpha(1)
	end
end

local function UpdateGlows(castbar, castStart, ready)
	local glow = module.glow
	if not (LCG and (glow.castbar or glow.health)) then return end

	if castStart and glow.important_only then
		-- the spell id is secret on restricted units, IsSpellImportant accepts it as is
		local spellID = castbar.spellID
		local isImportant = false
		if HasValue(spellID) then isImportant = IsSpellImportant(spellID) end
		castbar.mMT_IsImportant = isImportant
	end

	if glow.castbar then UpdateGlow(castbar, castbar, castStart, ready) end
	if glow.health then UpdateGlow(castbar.__owner and castbar.__owner.Health, castbar, castStart, ready) end
end

local function UpdateCast(castbar, castStart)
	-- the frame is pooled, so re-check the unit on every update instead of trusting PostCastStart
	local unit = castbar.unit or (castbar.__owner and castbar.__owner.__unit)
	if not (unit and UnitCanAttack("player", unit)) then return StopGlows(castbar) end

	-- interrupt lost since the cast started (pet dismissed, talent change), leave the castbar to ElvUI
	if not module.interruptSpellId then
		StopGlows(castbar)
		return HideKickBar(castbar)
	end

	-- dead or missing pet = no kick available
	if IsPetDown() then
		HideKickBar(castbar)
		SetCastbarColor(castbar, false)
		return UpdateGlows(castbar, castStart, false)
	end

	local cooldown = GetInterruptCooldown()
	local ready = IsKickReady(cooldown)

	SetKickSpark(castbar, castStart, cooldown, ready)
	SetCastbarColor(castbar, ready)
	UpdateGlows(castbar, castStart, ready)
end

local function ConstructKickBar(castbar)
	if castbar.mMT_KickBar then return end -- already built

	local height = castbar:GetHeight()

	local kickBar = CreateFrame("StatusBar", nil, castbar)
	kickBar:SetClipsChildren(true)
	kickBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
	kickBar:GetStatusBarTexture():SetAlpha(0)
	kickBar:ClearAllPoints()
	kickBar:SetAllPoints(castbar)
	kickBar:SetFrameLevel(castbar:GetFrameLevel() + 3)

	local c = module.colors.marker
	local indicator = kickBar:CreateTexture(nil, "overlay")
	indicator:SetColorTexture(c.r, c.g, c.b)
	indicator:SetSize(2, height)

	kickBar.mMT_Indicator = indicator
	castbar.mMT_KickBar = kickBar
end

local function OnUpdate(castbar, elapsed)
	if castbar.isInterruptedOrFailed then return end
	castbar._kickThrottle = (castbar._kickThrottle or 0) + elapsed
	if castbar._kickThrottle < 0.1 then return end -- lower number = more frequent updates
	castbar._kickThrottle = 0
	UpdateCast(castbar, false)
end

local function PostCastStart(castbar, unit)
	if not module.isEnabled then return end
	if not (castbar and unit) then return end
	if not (castbar.casting or castbar.channeling) then return end
	if not UnitCanAttack("player", unit) then return end
	if not module.interruptSpellId then
		StopGlows(castbar)
		return HideKickBar(castbar)
	end

	castbar.isInterruptedOrFailed = false
	ConstructKickBar(castbar)
	UpdateCast(castbar, true)

	if not castbar.mMT_PostUpdateFunction then
		castbar:HookScript("OnUpdate", OnUpdate)
		castbar.mMT_PostUpdateFunction = true
	end
end

-- oUF dropped castbar.failed/.interrupted/.finished, so the fail state has to be tracked here; ElvUI already applied its own color before this post-hook.
local function PostCastFailOrInterrupted(castbar)
	castbar.isInterruptedOrFailed = true
	if castbar.mMT_KickBar then castbar.mMT_KickBar:SetAlpha(0) end
	StopGlows(castbar)
end

-- ElvUI snapshots the Post* callbacks onto the castbar at frame construction and oUF only calls element:PostCastStart(), so hooking the NP/UF tables does nothing - hook the instances.
local function HookCastbarInstance(castbar)
	if not castbar or castbar.mMT_CastbarHooked then return end

	if castbar.PostCastStart then hooksecurefunc(castbar, "PostCastStart", PostCastStart) end
	if castbar.PostCastFail then hooksecurefunc(castbar, "PostCastFail", PostCastFailOrInterrupted) end
	if castbar.PostCastInterrupted then hooksecurefunc(castbar, "PostCastInterrupted", PostCastFailOrInterrupted) end
	if castbar.PostCastStop then hooksecurefunc(castbar, "PostCastStop", StopGlows) end
	-- a recycled nameplate hides the castbar without a stop callback, the health bar glow would keep running
	castbar:HookScript("OnHide", StopGlows)

	castbar.mMT_CastbarHooked = true
end

function module:Initialize()
	if E.db.mMediaTag.interrupt_on_cd.enable then
		if not module.isEnabled then
			module:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateInterruptSpell)
			module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", UpdateInterruptSpell)
			module:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateInterruptSpell)
			-- pet summon/dismiss and learned spells change the interrupt (warlock pets, Grimoire of Sacrifice, talents)
			module:RegisterEvent("SPELLS_CHANGED", UpdateInterruptSpell)
			module:RegisterEvent("UNIT_PET", UpdateInterruptSpell)

			-- StylePlate/Configure_Castbar also catch frames created or enabled later.
			hooksecurefunc(NP, "StylePlate", function(_, nameplate)
				if nameplate then HookCastbarInstance(nameplate.Castbar) end
			end)

			hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
				if frame then HookCastbarInstance(frame.Castbar) end
			end)

			if NP.Plates then
				for nameplate in pairs(NP.Plates) do
					HookCastbarInstance(nameplate.Castbar)
				end
			end

			mMT:ForEachUFFrame(function(frame)
				HookCastbarInstance(frame.Castbar)
			end)

			module.isEnabled = true
		end

		-- PLAYER_ENTERING_WORLD has usually fired before the module initializes, so seed the spell here
		UpdateInterruptSpell()

		module.colors = {
			onCD = MEDIA.color.interrupt_on_cd.onCD,
			normal = MEDIA.color.interrupt_on_cd.normal,
			marker = MEDIA.color.interrupt_on_cd.marker,
			glow = MEDIA.color.interrupt_on_cd.glow,
		}

		local db = E.db.mMediaTag.interrupt_on_cd
		module.set_bg_color = db.set_bg_color
		module.bg_multiplier = db.bg_multiplier
		module.glow = {
			castbar = db.glow_castbar,
			health = db.glow_health,
			important_only = db.glow_important_only,
			ready_only = db.glow_ready_only,
		}

		if module.set_bg_color then
			local m = module.bg_multiplier
			module.colors.bgReady = CreateColor(module.colors.normal.r * m, module.colors.normal.g * m, module.colors.normal.b * m, 1)
			module.colors.bgOnCD = CreateColor(module.colors.onCD.r * m, module.colors.onCD.g * m, module.colors.onCD.b * m, 1)
		end
	elseif module.isEnabled then
		module:UnregisterAllEvents()
		module.isEnabled = false
	end
end
