local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("InterruptOnCD", { "AceEvent-3.0" })

local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local IsSpellInRange = C_Spell and C_Spell.IsSpellInRange or IsSpellInRange
local GetSpellCooldownDuration = C_Spell.GetSpellCooldownDuration
local EvalColorBool = C_CurveUtil.EvaluateColorValueFromBoolean

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
	-- hunter
	[253] = 147362,
	[254] = 147362,
	[255] = 187707,
	-- rogue
	[259] = 1766,
	[260] = 1766,
	[261] = 1766,
	-- priest
	[256] = nil,
	[257] = nil,
	[258] = 15487,
	-- deathknight
	[250] = 47528,
	[251] = 47528,
	[252] = 47528,
	-- shaman
	[262] = 57994,
	[263] = 57994,
	[264] = 57994,
	-- mage
	[62] = 2139,
	[63] = 2139,
	[64] = 2139,
	-- warlock
	[265] = 119910,
	[266] = 119914,
	[267] = 119910,
	-- monk
	[268] = 116705,
	[270] = 116705,
	[269] = 116705,
	-- druid
	[102] = 78675,
	[103] = 106839,
	[104] = 106839,
	[105] = 106839,
	-- demonhunter
	[577] = 183752,
	[581] = 183752,
	[1480] = 183752,
	-- evoker
	[1467] = 351338,
	[1468] = 351338,
	[1473] = 351338,
}

local function UpdateInterruptSpell()
	local mySpecialization = select(1, GetSpecializationInfo(GetSpecialization()))

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

local function ApplyCastbarColor(castbar)
	local spellID = module.myInterruptSpell
	if not spellID then return end

	local cdDuration = GetSpellCooldownDuration(spellID)
	if not cdDuration then return end

	local elvuiColor = E.db.nameplates.colors.castColor
	local onCDC  = module.colors.onCD.c

	local iR = EvalColorBool(cdDuration:IsZero(), elvuiColor.r, onCDC.r)
	local iG = EvalColorBool(cdDuration:IsZero(), elvuiColor.g, onCDC.g)
	local iB = EvalColorBool(cdDuration:IsZero(), elvuiColor.b, onCDC.b)

	castbar:SetStatusBarColor(iR, iG, iB)

	-- bg color
	if module.set_bg_color and castbar.bg then
		local m = module.bg_multiplier
		local bgReadyR, bgReadyG, bgReadyB = elvuiColor.r * m, elvuiColor.g * m, elvuiColor.b * m
		local bgOnCDR, bgOnCDG, bgOnCDB = onCDC.r * m, onCDC.g * m, onCDC.b * m
		castbar.bg:SetVertexColor(EvalColorBool(cdDuration:IsZero(), bgReadyR, bgOnCDR), EvalColorBool(cdDuration:IsZero(), bgReadyG, bgOnCDG), EvalColorBool(cdDuration:IsZero(), bgReadyB, bgOnCDB), 1)
	end
end

local function GetOrCreateMarker(castbar)
	if castbar.mMT_InterruptMarker then return castbar.mMT_InterruptMarker end
	local color = module.colors.marker
	local marker = castbar:CreateTexture(nil, "OVERLAY")
	marker:SetDrawLayer("OVERLAY", 4)
	marker:SetBlendMode("ADD")
	marker:SetSize(2, castbar:GetHeight())
	marker:SetColorTexture(color.r, color.g, color.b)
	marker:Hide()
	castbar.mMT_InterruptMarker = marker
	return marker
end

local function GetOrCreatePositioner(castbar)
	if castbar.mMT_CDPositioner then return castbar.mMT_CDPositioner, castbar.mMT_CDClipper end

	local clip = CreateFrame("Frame", nil, castbar)
	clip:SetAllPoints(castbar)
	clip:SetClipsChildren(true)
	clip:SetFrameLevel(castbar:GetFrameLevel() + 1)
	castbar.mMT_CDClipper = clip

	local pos = CreateFrame("StatusBar", nil, clip)
	pos:SetStatusBarTexture(E.media.blankTex)
	pos:GetStatusBarTexture():SetAlpha(0)
	pos:SetMinMaxValues(0, 1)
	pos:SetValue(0)
	castbar.mMT_CDPositioner = pos

	return pos, clip
end

local function CancelTicker(castbar)
	if castbar.mMT_InterruptTicker then
		castbar.mMT_InterruptTicker:Cancel()
		castbar.mMT_InterruptTicker = nil
	end
end

local function ResetOverlay(castbar)
	CancelTicker(castbar)
	if castbar.mMT_InterruptMarker then
		castbar.mMT_InterruptMarker:Hide()
		castbar.mMT_InTime = false
	end
	if castbar.mMT_CDClipper then castbar.mMT_CDClipper:Hide() end
end

local function PlaceMarker(castbar, unit)
	--if castbar.mMT_InterruptMarker and castbar.mMT_InterruptMarker:IsShown() then return end
	print("PlaceMarker called for", unit)
	local spellID = module.myInterruptSpell
	if not spellID then return end

	local cdDuration = GetSpellCooldownDuration(spellID)
	if not cdDuration then return end

	local notInt = castbar.notInterruptible

	-- isReady=true > 0 (no marker), isReady=false > 1 (show marker )
	local markerAlpha = EvalColorBool(cdDuration:IsZero(), 0, 1)
	-- notInt=true > always 0
	markerAlpha = EvalColorBool(notInt, 0, markerAlpha)

	local castDuration = UnitCastingDuration(unit) or UnitChannelDuration(unit)
	if not castDuration then
		if castbar.mMT_CDClipper then castbar.mMT_CDClipper:SetAlpha(0) end
		return
	end

	local pos, clip = GetOrCreatePositioner(castbar)
	local reverseFill = castbar:GetReverseFill()

	pos:ClearAllPoints()
	pos:SetPoint("TOPLEFT", castbar, "TOPLEFT")
	pos:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT")
	pos:SetReverseFill(reverseFill)
	pos:SetMinMaxValues(0, castDuration:GetTotalDuration())
	pos:SetValue(cdDuration:GetRemainingDuration())
	clip:SetAlpha(markerAlpha)
	clip:Show()

	local marker = GetOrCreateMarker(castbar)
	marker:SetParent(clip)
	local mc = module.colors.marker
	marker:SetColorTexture(mc.r, mc.g, mc.b)
	marker:SetSize(2, castbar:GetHeight())
	marker:ClearAllPoints()
	if reverseFill then
		marker:SetPoint("RIGHT", pos:GetStatusBarTexture(), "LEFT", 0, 0)
	else
		marker:SetPoint("LEFT", pos:GetStatusBarTexture(), "RIGHT", 0, 0)
	end

	-- castbar.mMT_test = {
	-- 	r = EvalColorBool(cdDuration:IsZero(), module.colors.inTime.c.r, module.colors.onCD.c.r),
	-- 	g = EvalColorBool(cdDuration:IsZero(), module.colors.inTime.c.g, module.colors.onCD.c.g),
	-- 	b = EvalColorBool(cdDuration:IsZero(), module.colors.inTime.c.b, module.colors.onCD.c.b),
	-- }
	marker:Show()
end

local function UpdateMarker(castbar)
	if not castbar.mMT_CDClipper then return end
	local spellID = module.myInterruptSpell
	if not spellID then return end

	local cdDuration = GetSpellCooldownDuration(spellID)
	if not cdDuration then return end

	local notInt = castbar.notInterruptible
	local showAlpha = EvalColorBool(cdDuration:IsZero(), 0, 1)
	castbar.mMT_CDClipper:SetAlpha(EvalColorBool(notInt, 0, showAlpha))
	if castbar.mMT_InterruptMarker then castbar.mMT_InterruptMarker:SetAlpha(showAlpha) end
end

local function Update(castbar, unit)
	if not castbar then return end
	if not unit then return end

	ResetOverlay(castbar)

	if not castbar.casting and not castbar.channeling then return end
	if not UnitCanAttack("player", unit) then return end
	if not module.myInterruptSpell then return end

	ApplyCastbarColor(castbar)
	PlaceMarker(castbar, unit)

	castbar.mMT_InterruptTicker = C_Timer.NewTicker(0.1, function()
		if not castbar:IsShown() or not (castbar.casting or castbar.channeling) then
			ResetOverlay(castbar)
			return
		end
		ApplyCastbarColor(castbar)
		UpdateMarker(castbar)
	end)
end

function module:Initialize()
	if E.db.mMediaTag.interrupt_on_cd.enable then
		if not module.isEnabled then
			module:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateInterruptSpell)
			module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", UpdateInterruptSpell)
			module:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateInterruptSpell)

			hooksecurefunc(NP, "Castbar_PostCastStart", Update)
			hooksecurefunc(UF, "PostCastStart", Update)

			module.isEnabled = true
		end

		module.colors = {
			onCD = MEDIA.color.interrupt_on_cd.onCD,
			inTime = MEDIA.color.interrupt_on_cd.inTime,
			outOfRange = MEDIA.color.interrupt_on_cd.outOfRange,
			marker = MEDIA.color.interrupt_on_cd.marker,
		}

		module.inactiveTime = E.db.mMediaTag.interrupt_on_cd.inactive_time
		module.out_of_range = E.db.mMediaTag.interrupt_on_cd.out_of_range
		module.gradient = E.db.mMediaTag.interrupt_on_cd.gradient
		module.set_bg_color = E.db.mMediaTag.interrupt_on_cd.set_bg_color
		module.bg_multiplier = E.db.mMediaTag.interrupt_on_cd.bg_multiplier
	elseif module.isEnabled then
		module:UnregisterAllEvents()
		module.isEnabled = false
	end
end
