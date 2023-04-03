local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")
local addon, ns = ...

local mInsert = table.insert
local GetSpecializationInfo = GetSpecializationInfo
local GetActiveSpecGroup = GetActiveSpecGroup
local GetSpellCooldown = GetSpellCooldown
local interruptSpellID = nil

_G.mMediaTag_interruptOnCD = false
_G.mMediaTag_interruptinTime = false

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

local function isTalentLearned(nodeID)
	local talentConfig = C_ClassTalents.GetActiveConfigID()
	local nodeInfo = talentConfig and nodeID and C_Traits.GetNodeInfo(talentConfig, nodeID)
	return nodeInfo and nodeInfo.entryIDsWithCommittedRanks and nodeInfo.entryIDsWithCommittedRanks[1] and true or false
end
_G.mMediaTag_interruptOnCD = function()
	if interruptSpellID then
		local cdStart = GetSpellCooldown(interruptSpellID)
		if cdStart then
			return true
		else
			return false
		end
	end
end

local function CreateMarker(castbar)
	castbar.InterruptMarker = castbar:CreateTexture(nil, "overlay")
	castbar.InterruptMarker:SetDrawLayer("overlay", 4)
	castbar.InterruptMarker:SetBlendMode("ADD")
	castbar.InterruptMarker:SetSize(2, castbar:GetHeight())
	castbar.InterruptMarker:SetColorTexture(
		E.db[mPlugin].mCastbar.readymarker.r,
		E.db[mPlugin].mCastbar.readymarker.g,
		E.db[mPlugin].mCastbar.readymarker.b
	)
	castbar.InterruptMarker:Hide()
end

local function isSpellOrTalentKnown(spellId)
	if IsSpellKnown(spellId) then
		return true
	elseif isTalentLearned(spellId) then
		return true
	end
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

		local inactivetime = E.db[mPlugin].mCastbar.inactivetime
		local colorInterruptonCD = E.db[mPlugin].mCastbar.kickcd
		local colorInterruptonCDb = E.db[mPlugin].mCastbar.kickcdb
		local colorInterruptinTime = E.db[mPlugin].mCastbar.kickintime
		local colorInterruptinTimeb = E.db[mPlugin].mCastbar.kickintimeb

		if interruptCD and interruptCD > inactivetime and interruptReadyInTime then
			if not castbar.InterruptMarker then
				CreateMarker(castbar)
			end

			local sparkPosition = (interruptStart + interruptDur - castbar.startTime + 0.5) / castbar.max
			if castbar.channeling or castbar:GetReverseFill() then
				sparkPosition = 1 - sparkPosition
			end

			castbar.InterruptMarker:SetPoint("center", castbar, "left", sparkPosition * castbar:GetWidth(), 0)
			castbar.InterruptMarker:Show()

			if E.db[mPlugin].mCastbar.gardient then
				castbar:GetStatusBarTexture():SetGradient(
					"HORIZONTAL",
					{ r = colorInterruptinTime.r, g = colorInterruptinTime.g, b = colorInterruptinTime.b, a = 1 },
					{ r = colorInterruptinTimeb.r, g = colorInterruptinTimeb.g, b = colorInterruptinTimeb.b, a = 1 }
				)
			else
				castbar:SetStatusBarColor(colorInterruptinTime.r, colorInterruptinTime.g, colorInterruptinTime.b)
			end
		elseif interruptCD and interruptCD > inactivetime then
			if E.db[mPlugin].mCastbar.gardient then
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

local function mCastbarOptions()
	E.Options.args.mMediaTag.args.cosmetic.args.castbar.args = {
		cosmetics = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable Interrupt on CD colors for Castbars"],
			get = function(info)
				return E.db[mPlugin].mCastbar.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mCastbar.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		spacer = {
			order = 2,
			type = "description",
			name = "\n\n",
		},
		description = {
			order = 3,
			type = "description",
			name = L["Here you can set the color of the castbar when the own kick is on CD."],
		},
		spacer2 = {
			order = 4,
			type = "description",
			name = "\n\n",
		},
		gardient = {
			order = 5,
			type = "toggle",
			name = L["Gradient  Mode"],
			get = function(info)
				return E.db[mPlugin].mCastbar.gardient
			end,
			set = function(info, value)
				E.db[mPlugin].mCastbar.gardient = value
			end,
		},
		inactivetime = {
			order = 6,
			name = L["Inactivetime"],
			desc = L["do not show when the interrupt cast is ready in x seconds"],
			type = "range",
			min = 0,
			max = 4,
			step = 0.1,
			get = function(info)
				return E.db[mPlugin].mCastbar.inactivetime
			end,
			set = function(info, value)
				E.db[mPlugin].mCastbar.inactivetime = value
			end,
		},
		spacer4 = {
			order = 7,
			type = "description",
			name = "\n\n",
		},
		colorkickcd = {
			type = "color",
			order = 11,
			name = L["Interrupt on CD"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickcd
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickcd
				t.r, t.g, t.b = r, g, b
			end,
		},
		colorkickcdb = {
			type = "color",
			order = 13,
			name = L["Gradient color"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickcdb
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickcdb
				t.r, t.g, t.b = r, g, b
			end,
		},
		spacer3 = {
			order = 14,
			type = "description",
			name = "\n\n",
		},
		colorInterruptinTime = {
			type = "color",
			order = 15,
			name = L["Kick ready in Time"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickintime
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickintime
				t.r, t.g, t.b = r, g, b
			end,
		},
		colorInterruptinTimeb = {
			type = "color",
			order = 16,
			name = L["Gradient color"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickintimeb
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickintimeb
				t.r, t.g, t.b = r, g, b
			end,
		},
		spacer5 = {
			order = 20,
			type = "description",
			name = "\n\n",
		},
		marker = {
			type = "color",
			order = 21,
			name = L["Readymarker"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.readymarker
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.readymarker
				t.r, t.g, t.b = r, g, b
			end,
		},
	}
end

mInsert(ns.Config, mCastbarOptions)
