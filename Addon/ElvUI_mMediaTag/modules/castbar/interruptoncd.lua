local E = unpack(ElvUI)

local module = mMT.Modules.InterruptOnCD
if not module then
	return
end

local GetSpecializationInfo = GetSpecializationInfo
local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local IsSpellInRange = C_Spell and C_Spell.IsSpellInRange or IsSpellInRange
local interruptSpellID = nil

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

function mMT:mMediaTag_interruptOnCD(castbar)
	if interruptSpellID then
		local onCD
		local spellCooldownInfo = GetSpellCooldown(interruptSpellID)
		onCD = spellCooldownInfo.startTime

		return (onCD ~= 0)
	else
		return false
	end
end

function module:Initialize()
	local Specialization = select(1, GetSpecializationInfo(GetSpecialization()))
	-- Check for WARLOCK interrupt
	if E.myclass == "WARLOCK" then
		if IsPlayerSpell(89766) then
			interruptSpellList[Specialization] = 89766 or interruptSpellList[Specialization]
		elseif IsPlayerSpell(212619) then
			interruptSpellList[Specialization] = 212619 or interruptSpellList[Specialization]
		elseif IsPlayerSpell(119914) then
			interruptSpellList[Specialization] = 119914 or interruptSpellList[Specialization]
		end
	end

	interruptSpellID = interruptSpellList[Specialization]
	module.needReloadUI = true
	module.loaded = true
end

local function CreateMarker(castbar)
	castbar.InterruptMarker = castbar:CreateTexture(nil, "overlay")
	castbar.InterruptMarker:SetDrawLayer("overlay", 4)
	castbar.InterruptMarker:SetBlendMode("ADD")
	castbar.InterruptMarker:SetSize(2, castbar:GetHeight())
	castbar.InterruptMarker:SetColorTexture(E.db.mMT.interruptoncd.readymarkercolor.r, E.db.mMT.interruptoncd.readymarkercolor.g, E.db.mMT.interruptoncd.readymarkercolor.b)
	castbar.InterruptMarker:Hide()
end

function module:InterruptChecker(castbar, isUnitFrame)
	if castbar.InterruptMarker then
		castbar.InterruptMarker:Hide()
	end

	if interruptSpellID and not castbar.notInterruptible then
		local interruptCD, interruptReadyInTime = nil, false
		local interruptDur, interruptStart = 0, 0
		local spellCooldownInfo = GetSpellCooldown(interruptSpellID)
		local tmpInterruptCD = (spellCooldownInfo.startTime > 0 and spellCooldownInfo.duration - (GetTime() - spellCooldownInfo.startTime)) or 0

		if not interruptCD or (tmpInterruptCD < interruptCD) then
			interruptCD = tmpInterruptCD
			interruptDur = spellCooldownInfo.duration
			interruptStart = spellCooldownInfo.startTime
		end
		local value = castbar:GetValue()

		if castbar.channeling then
			interruptReadyInTime = (interruptCD + 0.2) < value
		else
			interruptReadyInTime = (interruptCD + 0.2) < (castbar.max - value)
		end

		local inactivetime = E.db.mMT.interruptoncd.inactivetime
		local colorInterruptonCD = E.db.mMT.interruptoncd.oncdcolor.colora
		local colorInterruptonCDb = E.db.mMT.interruptoncd.oncdcolor.colorb
		local colorInterruptinTime = E.db.mMT.interruptoncd.intimecolor.colora
		local colorInterruptinTimeb = E.db.mMT.interruptoncd.intimecolor.colorb
		local colorOutOfRange = E.db.mMT.interruptoncd.outofrangecolor.colora
		local colorOutOfRangeB = E.db.mMT.interruptoncd.outofrangecolor.colorb

		local spellInfo = GetSpellInfo(interruptSpellID)
		local isOutOfRange = E.db.mMT.interruptoncd.outofrange and (spellInfo and IsSpellInRange(spellInfo.name, castbar.unit) == 0) or false

		if interruptCD and interruptCD > inactivetime and interruptReadyInTime then
			if not castbar.InterruptMarker then
				CreateMarker(castbar)
			end

			local sparkPosition = (interruptStart + interruptDur - castbar.startTime + 0.2) / castbar.max
			if castbar.channeling or castbar:GetReverseFill() then
				sparkPosition = 1 - sparkPosition
			end

			castbar.InterruptMarker:SetPoint("center", castbar, "left", sparkPosition * castbar:GetWidth(), 0)
			castbar.InterruptMarker:Show()

			if E.db.mMT.interruptoncd.gradient then
				mMT.Modules.Castbar:SetCastbarColor(castbar, colorInterruptinTime, colorInterruptinTimeb)
			else
				mMT.Modules.Castbar:SetCastbarColor(castbar, colorInterruptinTime)
			end
		elseif interruptCD and interruptCD > inactivetime then
			if E.db.mMT.interruptoncd.gradient then
				mMT.Modules.Castbar:SetCastbarColor(castbar, colorInterruptonCD, colorInterruptonCDb)
			else
				mMT.Modules.Castbar:SetCastbarColor(castbar, colorInterruptonCD)
			end
		elseif isOutOfRange then
			if E.db.mMT.interruptoncd.gradient then
				mMT.Modules.Castbar:SetCastbarColor(castbar, colorOutOfRange, colorOutOfRangeB)
			else
				mMT.Modules.Castbar:SetCastbarColor(castbar, colorOutOfRange)
			end
		end
	end
end
