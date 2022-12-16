local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)

local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")

local addon, ns = ...


local mInsert = table.insert

local function CustomHealthBackdrop(unitframe, framename, r, g, b)
	if unitframe.backdropTex then
		unitframe.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db[mPlugin].mCustomBackdrop.health.texture))
		unitframe.backdropTex:ClearAllPoints()
		local statusBarOrientation = unitframe:GetOrientation()
		if statusBarOrientation == 'VERTICAL' then
			unitframe.backdropTex:Point('TOPLEFT')
			unitframe.backdropTex:Point('BOTTOMLEFT')
			unitframe.backdropTex:Point('BOTTOMRIGHT')

		else
			unitframe.backdropTex:Point('TOPLEFT')
			unitframe.backdropTex:Point('BOTTOMLEFT')
			unitframe.backdropTex:Point('BOTTOMRIGHT')
		end
	end
end

local function CustomPowerBackdrop(powerframe)
	if powerframe.backdropTex then
		powerframe.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db[mPlugin].mCustomBackdrop.power.texture))
		powerframe.backdropTex:ClearAllPoints()
		local statusBarOrientation = powerframe:GetOrientation()
		if statusBarOrientation == 'VERTICAL' then
			powerframe.backdropTex:Point('TOPLEFT')
			powerframe.backdropTex:Point('BOTTOMLEFT')
			powerframe.backdropTex:Point('BOTTOMRIGHT')

		else
			powerframe.backdropTex:Point('TOPLEFT')
			powerframe.backdropTex:Point('BOTTOMLEFT')
			powerframe.backdropTex:Point('BOTTOMRIGHT')
		end
	end
end

local function CustomCastbarBackdrop(castbarframe, frame, r, g, b)
	if castbarframe.backdropTex then
		castbarframe.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db[mPlugin].mCustomBackdrop.castbar.texture))
		castbarframe.backdropTex:ClearAllPoints()
		local statusBarOrientation = castbarframe:GetOrientation()
		if statusBarOrientation == 'VERTICAL' then
			castbarframe.backdropTex:Point('TOPLEFT')
			castbarframe.backdropTex:Point('BOTTOMLEFT')
			castbarframe.backdropTex:Point('BOTTOMRIGHT')

		else
			castbarframe.backdropTex:Point('TOPLEFT')
			castbarframe.backdropTex:Point('BOTTOMLEFT')
			castbarframe.backdropTex:Point('BOTTOMRIGHT')
		end
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