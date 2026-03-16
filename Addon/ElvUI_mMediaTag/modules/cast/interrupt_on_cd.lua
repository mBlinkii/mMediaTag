local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("InterruptOnCD", { "AceEvent-3.0" })

local GetSpellCooldownDuration = C_Spell.GetSpellCooldownDuration
local EvalColorBool = C_CurveUtil.EvaluateColorValueFromBoolean
local EvalColor = C_CurveUtil.EvaluateColorFromBoolean

local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

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
	-- Warlock
	[265] = 119910,
	[266] = 119914,
	[267] = 119910,
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

local function UpdateInterruptSpell()
	local specId = select(1, GetSpecializationInfo(GetSpecialization()))

	if E.myclass == "WARLOCK" then
		for _, spellId in ipairs({ 89766, 212619, 119914 }) do
			if IsPlayerSpell(spellId) then
				INTERRUPT_BY_SPEC[specId] = spellId
				break
			end
		end
	end

	module.interruptSpellId = INTERRUPT_BY_SPEC[specId]
end

local function PostCastFailInterrupted(castbar)
	local c = NP.db.colors.castInterruptedColor
	if c then castbar:SetStatusBarColor(c.r, c.g, c.b) end
	castbar.isInterruptedOrFailed = true
end

local function GetInterruptCooldown()
	local spellId = module.interruptSpellId
	if spellId then return GetSpellCooldownDuration(spellId) end
end

local function SetKickSpark(castbar, castStart, cooldown)
	local unit = castbar.unit or castbar.__owner.unit
	if not (unit and UnitCanAttack("player", unit)) then return end

	local kickBar = castbar.mMT_KickBar
	local indicator = kickBar.mMT_Indicator

	if cooldown == nil then return end

	if castStart then
		local isChannelOrReverse = castbar.channeling or castbar:GetReverseFill()
		local fillStyle = isChannelOrReverse and Enum.StatusBarFillStyle.Reverse or Enum.StatusBarFillStyle.Standard
		local barAnchor = isChannelOrReverse and "LEFT" or "RIGHT"
		local indicatorAnchor = isChannelOrReverse and "RIGHT" or "LEFT"

		kickBar:SetFillStyle(fillStyle)

		indicator:ClearAllPoints()
		indicator:SetPoint(indicatorAnchor, kickBar:GetStatusBarTexture(), barAnchor)

		local totalDuration = castbar:GetTimerDuration():GetTotalDuration()
		kickBar:SetMinMaxValues(0, totalDuration)
		kickBar:SetValue(cooldown:GetRemainingDuration())

		local shieldAlpha = 0
		if castbar.notInterruptible ~= nil then shieldAlpha = EvalColorBool(castbar.notInterruptible, 0, 1) end
		kickBar:SetAlphaFromBoolean(cooldown:IsZero(), 0, shieldAlpha)
	else
		kickBar:SetAlphaFromBoolean(cooldown:IsZero(), 0, kickBar:GetAlpha())
		if castbar.interrupted then kickBar:SetAlpha(0) end
	end
end

local function SetCastbarColor(castbar, cooldown)
	local colors = module.colors

	if castbar.failed or castbar.interrupted or castbar.finished or cooldown == nil then
		local c = colors.normal
		castbar:SetStatusBarColor(c.r, c.g, c.b, c.a)
		return
	end

	local unit = castbar.unit or castbar.__owner.unit
	if not (unit and UnitCanAttack("player", unit)) then return end

	local color = EvalColor(cooldown:IsZero(), colors.normal, colors.onCD)

	castbar:SetStatusBarColor(color:GetRGBA())

	-- bg color
	if module.set_bg_color and castbar.bg then
		local bgColor = EvalColor(cooldown:IsZero(), colors.bgReady, colors.bgOnCD)
		castbar.bg:SetVertexColor(bgColor:GetRGBA())
	end
end

local function UpdateCast(castbar, castStart)
	local cooldown = GetInterruptCooldown()
	SetKickSpark(castbar, castStart, cooldown)
	SetCastbarColor(castbar, cooldown)
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

function PostCastStart(castbar, unit)
	if not (castbar and unit) then return end
	if not (castbar.casting or castbar.channeling) then return end
	if not UnitCanAttack("player", unit) then return end
	if not module.interruptSpellId then return end

	castbar.isInterruptedOrFailed = false
	ConstructKickBar(castbar)
	UpdateCast(castbar, true)

	if not castbar.mMT_PostUpdateFunction then
		castbar:HookScript("OnUpdate", OnUpdate)
		castbar.mMT_PostUpdateFunction = true
	end
end

function module:Initialize()
	if E.db.mMediaTag.interrupt_on_cd.enable then
		if not module.isEnabled then
			module:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateInterruptSpell)
			module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", UpdateInterruptSpell)
			module:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateInterruptSpell)

			hooksecurefunc(NP, "Castbar_PostCastStart", PostCastStart)
			hooksecurefunc(UF, "PostCastStart", PostCastStart)
			hooksecurefunc(NP, "Castbar_PostCastFail", PostCastFailInterrupted)
			hooksecurefunc(NP, "Castbar_PostCastInterrupted", PostCastFailInterrupted)

			module.isEnabled = true
		end

		module.colors = {
			onCD = MEDIA.color.interrupt_on_cd.onCD,
			normal = MEDIA.color.interrupt_on_cd.normal,
			marker = MEDIA.color.interrupt_on_cd.marker,
		}

		module.set_bg_color = E.db.mMediaTag.interrupt_on_cd.set_bg_color
		module.bg_multiplier = E.db.mMediaTag.interrupt_on_cd.bg_multiplier

		if module.set_bg_color then
			local m = module.bg_multiplier
			module.colors.bgReady = CreateColor(module.colors.normal.r * m, module.colors.normal.g * m, module.colors.normal.b * m)
			module.colors.bgOnCD = CreateColor(module.colors.onCD.r * m, module.colors.onCD.g * m, module.colors.onCD.b * m)
		end
	elseif module.isEnabled then
		module:UnregisterAllEvents()
		module.isEnabled = false
	end
end
