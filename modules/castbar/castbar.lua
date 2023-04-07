local mMT, E, L, V, P, G = unpack((select(2, ...)))
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

local GetSpecializationInfo = GetSpecializationInfo
local GetActiveSpecGroup = GetActiveSpecGroup
local GetSpellCooldown = GetSpellCooldown
local interruptSpellID = nil
local OutOfRange = false

local interruptSpellList = {
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
	--"WARLOCK
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
}
function _G.mMediaTag_interruptOnCD()
	if interruptSpellID then
		local cdStart, _, enabled, _ = GetSpellCooldown(interruptSpellID)
		return (enabled == 0 and true or false) or (E.db.mMT.interruptoncd.outofrange and OutOfRange)
	end
end

function mMT:UpdateInterruptSpell()
	interruptSpellID = interruptSpellList[select(1, GetSpecializationInfo(GetSpecialization()))]
end

local function CreateMarker(castbar)
	castbar.InterruptMarker = castbar:CreateTexture(nil, "overlay")
	castbar.InterruptMarker:SetDrawLayer("overlay", 4)
	castbar.InterruptMarker:SetBlendMode("ADD")
	castbar.InterruptMarker:SetSize(2, castbar:GetHeight())
	castbar.InterruptMarker:SetColorTexture(
		E.db.mMT.interruptoncd.readymarkercolor.r,
		E.db.mMT.interruptoncd.readymarkercolor.g,
		E.db.mMT.interruptoncd.readymarkercolor.b
	)
	castbar.InterruptMarker:Hide()
end
local function InterruptChecker(castbar)
	if castbar.unit == "vehicle" or castbar.unit == "player" then
		return
	end

	if castbar.InterruptMarker then
		castbar.InterruptMarker:Hide()
	end

	if not castbar.notInterruptible and interruptSpellID then
		local interruptCD, interruptReadyInTime = nil, false
		local interruptDur, interruptStart = 0, 0

		local cdStart, cdDur = GetSpellCooldown(interruptSpellID)
		local tmpInterruptCD = (cdStart > 0 and cdDur - (GetTime() - cdStart)) or 0
		if not interruptCD or (tmpInterruptCD < interruptCD) then
			interruptCD = tmpInterruptCD
			interruptDur = cdDur
			interruptStart = cdStart
		end
		local value = castbar:GetValue()

		if castbar.channeling then
			interruptReadyInTime = (interruptCD + 0.5) < value
		else
			interruptReadyInTime = (interruptCD + 0.5) < (castbar.max - value)
		end

		local inactivetime = E.db.mMT.interruptoncd.inactivetime
		local colorInterruptonCD = E.db.mMT.interruptoncd.oncdcolor.colora
		local colorInterruptonCDb = E.db.mMT.interruptoncd.oncdcolor.colorb
		local colorInterruptinTime = E.db.mMT.interruptoncd.intimecolor.colora
		local colorInterruptinTimeb = E.db.mMT.interruptoncd.intimecolor.colorb
		local colorOutOfRange = E.db.mMT.interruptoncd.outofrangecolor.colora
		local colorOutOfRangeB = E.db.mMT.interruptoncd.outofrangecolor.colorb

		if E.db.mMT.interruptoncd.outofrange then
			OutOfRange = IsSpellInRange(GetSpellInfo(interruptSpellID), castbar.unit) == 0
		end

		if E.db.mMT.interruptoncd.outofrange and OutOfRange then
			if E.db.mMT.interruptoncd.gradient then
				castbar:GetStatusBarTexture():SetGradient(
					"HORIZONTAL",
					{ r = colorOutOfRange.r, g = colorOutOfRange.g, b = colorOutOfRange.b, a = 1 },
					{ r = colorOutOfRangeB.r, g = colorOutOfRangeB.g, b = colorOutOfRangeB.b, a = 1 }
				)
			else
				castbar:SetStatusBarColor(colorOutOfRange.r, colorOutOfRange.g, colorOutOfRange.b)
			end
		elseif interruptCD and interruptCD > inactivetime and interruptReadyInTime then
			if not castbar.InterruptMarker then
				CreateMarker(castbar)
			end

			local sparkPosition = (interruptStart + interruptDur - castbar.startTime + 0.5) / castbar.max
			if castbar.channeling or castbar:GetReverseFill() then
				sparkPosition = 1 - sparkPosition
			end

			castbar.InterruptMarker:SetPoint("center", castbar, "left", sparkPosition * castbar:GetWidth(), 0)
			castbar.InterruptMarker:Show()

			if E.db.mMT.interruptoncd.gradient then
				castbar:GetStatusBarTexture():SetGradient(
					"HORIZONTAL",
					{ r = colorInterruptinTime.r, g = colorInterruptinTime.g, b = colorInterruptinTime.b, a = 1 },
					{ r = colorInterruptinTimeb.r, g = colorInterruptinTimeb.g, b = colorInterruptinTimeb.b, a = 1 }
				)
			else
				castbar:SetStatusBarColor(colorInterruptinTime.r, colorInterruptinTime.g, colorInterruptinTime.b)
			end
		elseif interruptCD and interruptCD > inactivetime then
			if E.db.mMT.interruptoncd.gradient then
				castbar:GetStatusBarTexture():SetGradient(
					"HORIZONTAL",
					{ r = colorInterruptonCD.r, g = colorInterruptonCD.g, b = colorInterruptonCD.b, a = 1 },
					{ r = colorInterruptonCDb.r, g = colorInterruptonCDb.g, b = colorInterruptonCDb.b, a = 1 }
				)
			else
				castbar:SetStatusBarColor(colorInterruptonCD.r, colorInterruptonCD.g, colorInterruptonCD.b)
			end
		end
	end
end
function mMT:mSetupCastbar()
	interruptSpellID = interruptSpellList[select(1, GetSpecializationInfo(GetSpecialization()))]
	if interruptSpellID then
		hooksecurefunc(NP, "Castbar_CheckInterrupt", InterruptChecker)
		hooksecurefunc(UF, "PostCastStart", InterruptChecker)
	end
end
