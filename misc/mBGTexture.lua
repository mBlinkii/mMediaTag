local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)

local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")

local addon, ns = ...


local mInsert = table.insert

local function CustomHealthBackdrop(unitframe, frame, r, g, b)
	if unitframe.bg then
		unitframe.bg:SetTexture(LSM:Fetch("statusbar", E.db[mPlugin].mCustomBackdrop.health.texture))
		unitframe.bg.mstyle = true
	end
end

local function CustomPowerBackdrop(powerframe)
	if powerframe.BG then
		powerframe.BG:SetTexture(LSM:Fetch("statusbar", E.db[mPlugin].mCustomBackdrop.power.texture))
		powerframe.BG.mstyle = true
	end
end

local function CustomCastbarBackdrop(castbarframe, frame, r, g, b)
	if castbarframe.bg then
		castbarframe.bg:SetTexture(LSM:Fetch("statusbar", E.db[mPlugin].mCustomBackdrop.castbar.texture))
	end
end

function mMT:StartCustomBackdrop()
	if E.db[mPlugin].mCustomBackdrop.health.enable then
		hooksecurefunc(UF, "PostUpdateHealthColor", CustomHealthBackdrop)
	end

	if E.db[mPlugin].mCustomBackdrop.power.enable then
		hooksecurefunc(UF, "PostUpdatePowerColor", CustomPowerBackdrop)
	end

	if E.db[mPlugin].mCustomBackdrop.castbar.enable then
		hooksecurefunc(UF, "PostCastStart", CustomCastbarBackdrop)
	end
end

local function CustomBackdropOptions()
	E.Options.args.mMediaTag.args.cosmetic.args.custombackdrop.args = {
		healthheader = {
			order = 1,
			type = "header",
			name = L["Custom Health Backdrop"]
		},
		bghealth = {
			order = 2,
			type = "toggle",
			name = L["Custom Health Backdrop"],
			desc = L["Enable Custom Health Backdrop"],
			get = function(info)
				return E.db[mPlugin].mCustomBackdrop.health.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomBackdrop.health.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end
		},
		healthtexture = {
			order = 3,
			type = "select",
			dialogControl = "LSM30_Statusbar",
			name = L["Backdrop Texture"],
			values = LSM:HashTable("statusbar"),
			disabled = function()
				return not E.db[mPlugin].mCustomBackdrop.health.enable
			end,
			get = function(info)
				return E.db[mPlugin].mCustomBackdrop.health.texture
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomBackdrop.health.texture = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		powerheader = {
			order = 11,
			type = "header",
			name = L["Custom Power Backdrop"]
		},
		bgpower = {
			order = 12,
			type = "toggle",
			name = L["Custom Power Backdrop"],
			desc = L["Enable Custom Power Backdrop"],
			get = function(info)
				return E.db[mPlugin].mCustomBackdrop.power.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomBackdrop.power.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end
		},
		powertexture = {
			order = 13,
			type = "select",
			dialogControl = "LSM30_Statusbar",
			name = L["Backdrop Texture"],
			values = LSM:HashTable("statusbar"),
			disabled = function()
				return not E.db[mPlugin].mCustomBackdrop.power.enable
			end,
			get = function(info)
				return E.db[mPlugin].mCustomBackdrop.power.texture
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomBackdrop.power.texture = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		castbarheader = {
			order = 21,
			type = "header",
			name = L["Custom Castbar Backdrop"]
		},
		bgcastbar = {
			order = 22,
			type = "toggle",
			name = L["Custom Castbar Backdrop"],
			desc = L["Enable Custom Castbar Backdrop"],
			get = function(info)
				return E.db[mPlugin].mCustomBackdrop.castbar.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomBackdrop.castbar.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end
		},
		castbartexture = {
			order = 23,
			type = "select",
			dialogControl = "LSM30_Statusbar",
			name = L["Backdrop Texture"],
			values = LSM:HashTable("statusbar"),
			disabled = function()
				return not E.db[mPlugin].mCustomBackdrop.castbar.enable
			end,
			get = function(info)
				return E.db[mPlugin].mCustomBackdrop.castbar.texture
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomBackdrop.castbar.texture = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
	}
end

mInsert(ns.Config, CustomBackdropOptions)