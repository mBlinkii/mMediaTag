local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("InterruptOnCD", { "AceEvent-3.0" })

local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local IsSpellInRange = C_Spell and C_Spell.IsSpellInRange or IsSpellInRange
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

local spellList = {
	-- warrior
	[71] = 6552,
	[72] = 6552,
	[73] = 6552,
	-- paladin
	[65] = 96231,
	[66] = 96231,
	[70] = 96231,
	--HUNTER
	[253] = 147362,
	[254] = 147362,
	[255] = 187707,
	--ROGUE"
	[259] = 1766,
	[260] = 1766,
	[261] = 1766,
	--PRIEST
	[256] = nil,
	[257] = nil,
	[258] = 15487,
	--DEATHKNIGHT
	[250] = 47528,
	[251] = 47528,
	[252] = 47528,
	--SHAMAN
	[262] = 57994,
	[263] = 57994,
	[264] = 57994,
	--MAGE
	[62] = 2139,
	[63] = 2139,
	[64] = 2139,
	--WARLOCK
	[265] = 119910,
	[266] = 119914,
	[267] = 119910,
	--MONK
	[268] = 116705,
	[270] = 116705,
	[269] = 116705,
	--DRUID
	[102] = 78675,
	[103] = 106839,
	[104] = 106839,
	[105] = 106839,
	--DEMONHUNTER
	[577] = 183752,
	[581] = 183752,
	--EVOKER
	[1467] = 351338,
	[1468] = 351338,
	[1473] = 351338,
}

local function SetCastbarColor(castbar, color)
	-- Set the color of the castbar
	local c = color.c
	local g = color.g

	if not castbar._originalColor then
		local r, g, b = castbar:GetStatusBarTexture():GetVertexColor()
		castbar._originalColor = { r = r, g = g, b = b }
	end

	if module.gradient then
		print("Setting castbar color with gradient") -- debug output
		castbar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = c.r, g = c.g, b = c.b, a = 1 }, { r = g.r, g = g.g, b = g.b, a = 1 })
	else
		print("Setting castbar color without gradient") -- debug output
		castbar:SetStatusBarColor(c.r, c.g, c.b)
	end

	-- Set the color of the castbar background if required
	if module.set_bg_color and castbar.bg then
		-- Originalfarbe des Hintergrunds sichern
		if module.set_bg_color and castbar.bg and not castbar._originalBgColor then
			local r, g, b, a = castbar.bg:GetVertexColor()
			castbar._originalBgColor = { r = r, g = g, b = b, a = a }
		end

		print("Setting castbar background color") -- debug output
		local multiplier = module.bg_multiplier
		castbar.bg:SetVertexColor(c.r * multiplier, c.g * multiplier, c.b * multiplier, 1)
	end
end

local function ResetCastbarColor(castbar)
	if castbar._originalColor then
		local c = castbar._originalColor
		castbar:SetStatusBarColor(c.r, c.g, c.b)
		castbar._originalColor = nil
	end

	-- Hintergrundfarbe zurücksetzen
	if castbar.bg and castbar._originalBgColor then
		local c = castbar._originalBgColor
		castbar.bg:SetVertexColor(c.r, c.g, c.b, c.a)
		castbar._originalBgColor = nil
	end
	-- Optional: Hintergrundfarbe zurücksetzen, falls gewünscht
end

local function CreateMarker(castbar)
	local color = module.colors.marker
	castbar.InterruptMarker = castbar:CreateTexture(nil, "overlay")
	castbar.InterruptMarker:SetDrawLayer("overlay", 4)
	castbar.InterruptMarker:SetBlendMode("ADD")
	castbar.InterruptMarker:SetSize(2, castbar:GetHeight())
	castbar.InterruptMarker:SetColorTexture(color.r, color.g, color.b) -- update on /rl
	castbar.InterruptMarker:Hide()
end

local function InterruptChecker(castbar)
	if castbar.InterruptMarker then castbar.InterruptMarker:Hide() end -- hide marker if it exists

	local spellID = module.myInterruptSpell

	if not spellID then return end -- or castbar.notIncorruptible -- end if no spell or if castbar is not interruptible

	-- cd and time calculations
	local spellCooldownInfo = GetSpellCooldown(spellID)
	local timeNow = GetTime()
	local interruptCD = (spellCooldownInfo.startTime > 0) and (spellCooldownInfo.duration - (timeNow - spellCooldownInfo.startTime)) or 0

	local value = castbar:GetValue()
	local castbarMax = castbar.max or 1
	local interruptReadyInTime = (interruptCD + 0.2) < (castbar.channeling and value or (castbarMax - value))

	local inactiveTime = module.inactiveTime

	-- out of range check
	local isOutOfRange
	if module.out_of_range then
		local spellInfo = GetSpellInfo(spellID)
		isOutOfRange = (spellInfo and IsSpellInRange(spellInfo.name, castbar.unit) == 0) or false
	end

	-- Set the castbar color based on the interrupt state
	if interruptCD > inactiveTime and interruptReadyInTime then
		if not castbar.InterruptMarker then CreateMarker(castbar) end -- create marker if it doesn't exist

		-- marker position calculation and set
		local markerPosition = (spellCooldownInfo.startTime + spellCooldownInfo.duration - castbar.startTime + 0.2) / castbarMax
		if castbar.channeling or castbar:GetReverseFill() then markerPosition = 1 - markerPosition end
		castbar.InterruptMarker:SetPoint("center", castbar, "left", markerPosition * castbar:GetWidth(), 0)
		castbar.InterruptMarker:Show()

		SetCastbarColor(castbar, module.colors.inTime)
	elseif interruptCD > inactiveTime then
		SetCastbarColor(castbar, module.colors.onCD)
	elseif isOutOfRange then
		SetCastbarColor(castbar, module.colors.outOfRange)
	else
		ResetCastbarColor(castbar)
	end
end

local function UpdateInterruptSpell()
	local mySpecialization = select(1, GetSpecializationInfo(GetSpecialization()))

	-- Check for WARLOCK interrupt
	if E.myclass == "WARLOCK" then
		if IsPlayerSpell(89766) then
			spellList[mySpecialization] = 89766 or spellList[mySpecialization]
		elseif IsPlayerSpell(212619) then
			spellList[mySpecialization] = 212619 or spellList[mySpecialization]
		elseif IsPlayerSpell(119914) then
			spellList[mySpecialization] = 119914 or spellList[mySpecialization]
		end
	end

	module.myInterruptSpell = spellList[mySpecialization]
end

local function Castbar_OnUpdate(castbar, elapsed)
	castbar._interruptOnCD_Elapsed = (castbar._interruptOnCD_Elapsed or 0) + elapsed
	if castbar._interruptOnCD_Elapsed > 0.5 then
		InterruptChecker(castbar)
		castbar._interruptOnCD_Elapsed = 0
	end
end

local function update(castbar, ...)
	if not castbar or castbar.unit == "vehicle" or castbar.unit == "player" then return end

	InterruptChecker(castbar)

	if not castbar._interruptOnCD_OnUpdateHooked then
		castbar:HookScript("OnUpdate", Castbar_OnUpdate)
		castbar._interruptOnCD_OnUpdateHooked = true
	end
end

function module:Initialize()
	if E.db.mMT.interrupt_on_cd.enable then
		if not module.isEnabled then
			module:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateInterruptSpell)
			module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", UpdateInterruptSpell)
			module:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateInterruptSpell)

			hooksecurefunc(NP, "Castbar_PostCastStart", update)
			hooksecurefunc(UF, "PostCastStart", update)
			hooksecurefunc(NP, "Castbar_PostCastStart", update)
			--hooksecurefunc(UF, "PostCastUpdate", update)
			module.isEnabled = true
		end

		module.colors = nil
		module.colors = {
			onCD = MEDIA.color.interrupt_on_cd.onCD,
			inTime = MEDIA.color.interrupt_on_cd.inTime,
			outOfRange = MEDIA.color.interrupt_on_cd.outOfRange,
			marker = MEDIA.color.interrupt_on_cd.marker,
		}

		module.inactiveTime = E.db.mMT.interrupt_on_cd.inactive_time
		module.out_of_range = E.db.mMT.interrupt_on_cd.out_of_range
		module.gradient = E.db.mMT.interrupt_on_cd.gradient
		module.set_bg_color = E.db.mMT.interrupt_on_cd.set_bg_color
		module.bg_multiplier = E.db.mMT.interrupt_on_cd.bg_multiplier

		module.loaded = true
	elseif module.isEnabled then
		module:UnregisterAllEvents()
		module.isEnabled = false
	end
end
