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
local interruptSpellId = nil

_G.mMediaTag_interruptOnCD = false
_G.mMediaTag_interruptinTime = false

local interruptSpellList = {
	-- warrior
	[71] = 6552,
	[72] = 6552,
	[73] = 6552,
	-- paladin
	[65] = nil,
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
	[270] = nil,
	[269] = 116705,
	--DRUID
	[102] = 78675,
	[103] = 106839,
	[104] = 106839,
	[105] = nil,
	--DEMONHUNTER
	[577] = 183752,
	[581] = 183752,
	--EVOKER
	[1467] = 351338,
	[1468] = 351338,
}

_G.mMediaTag_interruptOnCD = function()
	interruptSpellId = interruptSpellList[select(1, GetSpecializationInfo(GetSpecialization()))]
	if interruptSpellId then
		local cdStart = GetSpellCooldown(interruptSpellId)
		if cdStart then
			return true
		else
			return false
		end
	end
end

function mMT:mUpdateKick()
	interruptSpellId = interruptSpellList[select(1, GetSpecializationInfo(GetSpecialization()))]
end

function mMT:mSetupCastbar()
	interruptSpellId = interruptSpellList[select(1, GetSpecializationInfo(GetSpecialization()))]
	local colorKickonCD = E.db[mPlugin].mCastbar.kickcd
	local colorKickonCDb = E.db[mPlugin].mCastbar.kickcdb
	local colorKickinTime = E.db[mPlugin].mCastbar.kickintime
	local colorKickinTimeb = E.db[mPlugin].mCastbar.kickintimeb

	if interruptSpellId then
		hooksecurefunc(NP, "Castbar_CheckInterrupt", function(unit)
			if not unit.notInterruptible then
				if unit.unit == "vehicle" or unit.unit == "player" then
					return
				end

				local interruptCD = nil
				local interruptReadyInTime = false

				if interruptSpellId then
					local cdStart, cdDur = GetSpellCooldown(interruptSpellId)
					local _, statusMax = unit:GetMinMaxValues()
					local value = unit:GetValue()
					interruptCD = (cdStart > 0 and cdDur - (GetTime() - cdStart)) or 0

					if unit.channeling then
						interruptReadyInTime = (interruptCD + 0.5) < value
					else
						interruptReadyInTime = (interruptCD + 0.5) < (statusMax - value)
					end

					if not unit.IntterruptMarker then
						unit.IntterruptMarker = unit:CreateTexture(nil, "overlay")
						unit.IntterruptMarker:SetColorTexture(E.db[mPlugin].mCastbar.readymarker.r, E.db[mPlugin].mCastbar.readymarker.g, E.db[mPlugin].mCastbar.readymarker.b)
					end

					unit.IntterruptMarker:Hide()

					if interruptCD > 0 and interruptReadyInTime then
						local range = (interruptCD / statusMax)
						if range then
							local overlaySize = unit:GetWidth() * range
							unit.IntterruptMarker:SetSize(2, unit:GetHeight())
							unit.IntterruptMarker:SetPoint("left", unit, "left", overlaySize, 0)
							unit.IntterruptMarker:SetVertexColor(1, 1, 1)
							unit.IntterruptMarker:Show()
						end
					else
						unit.IntterruptMarker:Hide()
					end

					if E.db[mPlugin].mCastbar.gardient then
						if interruptCD > 0 and interruptReadyInTime then
							unit:GetStatusBarTexture():SetGradient(
								"HORIZONTAL",
								{ r = colorKickinTime.r, g = colorKickinTime.g, b = colorKickinTime.b, a = 1 },
								{ r = colorKickinTimeb.r, g = colorKickinTimeb.g, b = colorKickinTimeb.b, a = 1 }
							)
						elseif interruptCD > 0 then
							unit:GetStatusBarTexture():SetGradient(
								"HORIZONTAL",
								{ r = colorKickonCD.r, g = colorKickonCD.g, b = colorKickonCD.b, a = 1 },
								{ r = colorKickonCDb.r, g = colorKickonCDb.g, b = colorKickonCDb.b, a = 1 }
							)
						end
					else
						if interruptCD > 0 and interruptReadyInTime then
							unit:SetStatusBarColor(colorKickinTime.r, colorKickinTime.g, colorKickinTime.b)
						elseif interruptCD > 0 then
							unit:SetStatusBarColor(colorKickonCD.r, colorKickonCD.g, colorKickonCD.b)
						end
					end
				end
			end
		end)

		hooksecurefunc(UF, "PostCastStart", function(unit)
			if unit.unit == "vehicle" or unit.unit == "player" then
				return
			end

			local db = unit:GetParent().db
			if not db or not db.castbar then
				return
			end

			local interruptCD = 0
			local interruptReadyInTime = false

			if interruptSpellId then
				local cdStart, cdDur = GetSpellCooldown(interruptSpellId)
				local _, statusMax = unit:GetMinMaxValues()
				local value = unit:GetValue()
				interruptCD = (cdStart > 0 and cdDur - (GetTime() - cdStart)) or 0

				if unit.channeling then
					interruptReadyInTime = (interruptCD + 0.5) < value
				else
					interruptReadyInTime = (interruptCD + 0.5) < (statusMax - value)
				end

				if not unit.IntterruptMarker then
					unit.IntterruptMarker = unit:CreateTexture(nil, "overlay")
					unit.IntterruptMarker:SetColorTexture(E.db[mPlugin].mCastbar.readymarker.r, E.db[mPlugin].mCastbar.readymarker.g, E.db[mPlugin].mCastbar.readymarker.b)
					unit.IntterruptMarker:SetBlendMode("ADD")
				end

				unit.IntterruptMarker:Hide()

				if interruptCD > 0 and interruptReadyInTime then
					local range = (interruptCD / statusMax)
					if range then
						local overlaySize = unit:GetWidth() * range
						unit.IntterruptMarker:SetSize(2, unit:GetHeight())
						unit.IntterruptMarker:SetPoint("left", unit, "left", overlaySize, 0)
						unit.IntterruptMarker:SetVertexColor(1, 1, 1)
						unit.IntterruptMarker:Show()
					end
				else
					unit.IntterruptMarker:Hide()
				end

				if not unit.notInterruptible then
					if E.db[mPlugin].mCastbar.gardient then
						if interruptCD > 0 and interruptReadyInTime then
							unit:GetStatusBarTexture():SetGradient(
								"HORIZONTAL",
								{ r = colorKickinTime.r, g = colorKickinTime.g, b = colorKickinTime.b, a = 1 },
								{ r = colorKickinTimeb.r, g = colorKickinTimeb.g, b = colorKickinTimeb.b, a = 1 }
							)
						elseif interruptCD > 0 then
							unit:GetStatusBarTexture():SetGradient(
								"HORIZONTAL",
								{ r = colorKickonCD.r, g = colorKickonCD.g, b = colorKickonCD.b, a = 1 },
								{ r = colorKickonCDb.r, g = colorKickonCDb.g, b = colorKickonCDb.b, a = 1 }
							)
						end
					else
						if interruptCD > 0 and interruptReadyInTime then
							unit:SetStatusBarColor(colorKickinTime.r, colorKickinTime.g, colorKickinTime.b)
						elseif interruptCD > 0 then
							unit:SetStatusBarColor(colorKickonCD.r, colorKickonCD.g, colorKickonCD.b)
						end
					end
				end
			end
		end)
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
			name = L["Gardient Mode"],
			get = function(info)
				return E.db[mPlugin].mCastbar.gardient
			end,
			set = function(info, value)
				E.db[mPlugin].mCastbar.gardient = value
			end,
		},
		spacer4 = {
			order = 6,
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
			name = L["Gardient color"],
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
		colorkickintime = {
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
		colorkickintimeb = {
			type = "color",
			order = 16,
			name = L["Gardient color"],
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
			order = 11,
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
