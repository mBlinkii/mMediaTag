local E = unpack(ElvUI)
local L = mMT.Locales

local LSM = LibStub("LibSharedMedia-3.0")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.unitframes.args.uftextures.args.textures.args = {
		healthheader = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Custom Health Texture"],
			args = {
				health = {
					order = 1,
					type = "toggle",
					name = L["Custom Health Texture"],
					desc = L["Enable Custom Health Texture"],
					get = function(info)
						return E.db.mMT.customtextures.health.enable
					end,
					set = function(info, value)
						E.db.mMT.customtextures.health.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				healthtexture = {
					order = 2,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Texture"],
					values = LSM:HashTable("statusbar"),
					disabled = function()
						return not E.db.mMT.customtextures.health.enable
					end,
					get = function(info)
						return E.db.mMT.customtextures.health.texture
					end,
					set = function(info, value)
						E.db.mMT.customtextures.health.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		powerheader = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Custom Power Texture"],
			args = {
				power = {
					order = 1,
					type = "toggle",
					name = L["Custom Power Texture"],
					desc = L["Enable Custom Power Texture"],
					get = function(info)
						return E.db.mMT.customtextures.power.enable
					end,
					set = function(info, value)
						E.db.mMT.customtextures.power.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				powertexture = {
					order = 2,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Texture"],
					values = LSM:HashTable("statusbar"),
					disabled = function()
						return not E.db.mMT.customtextures.power.enable
					end,
					get = function(info)
						return E.db.mMT.customtextures.power.texture
					end,
					set = function(info, value)
						E.db.mMT.customtextures.power.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		castbarheader = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Custom Castbar Texture"],
			args = {
				castbar = {
					order = 1,
					type = "toggle",
					name = L["Custom Castbar Texture"],
					desc = L["Enable Custom Castbar Texture"],
					get = function(info)
						return E.db.mMT.customtextures.castbar.enable
					end,
					set = function(info, value)
						E.db.mMT.customtextures.castbar.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				castbartexture = {
					order = 2,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Texture"],
					values = LSM:HashTable("statusbar"),
					disabled = function()
						return not E.db.mMT.customtextures.castbar.enable
					end,
					get = function(info)
						return E.db.mMT.customtextures.castbar.texture
					end,
					set = function(info, value)
						E.db.mMT.customtextures.castbar.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		altpower = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Custom Alternative Power Texture"],
			args = {
				altpower = {
					order = 1,
					type = "toggle",
					name = L["Custom Alternative Power Texture"],
					desc = L["Enable Custom Alternative Power Texture"],
					get = function(info)
						return E.db.mMT.customtextures.altpower.enable
					end,
					set = function(info, value)
						E.db.mMT.customtextures.altpower.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				altpowertexture = {
					order = 2,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Texture"],
					values = LSM:HashTable("statusbar"),
					disabled = function()
						return not E.db.mMT.customtextures.altpower.enable
					end,
					get = function(info)
						return E.db.mMT.customtextures.altpower.texture
					end,
					set = function(info, value)
						E.db.mMT.customtextures.altpower.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
