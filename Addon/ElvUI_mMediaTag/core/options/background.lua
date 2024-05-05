local E, L = unpack(ElvUI)

local LSM = LibStub("LibSharedMedia-3.0")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.cosmetic.args.background.args = {
		healthheader = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Custom Health Backdrop"],
			args = {
				bghealth = {
					order = 2,
					type = "toggle",
					name = L["Custom Health Backdrop"],
					desc = L["Enable Custom Health Backdrop"],
					get = function(info)
						return E.db.mMT.custombackgrounds.health.enable
					end,
					set = function(info, value)
						E.db.mMT.custombackgrounds.health.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				healthtexture = {
					order = 3,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Backdrop Texture"],
					values = LSM:HashTable("statusbar"),
					disabled = function()
						return not E.db.mMT.custombackgrounds.health.enable
					end,
					get = function(info)
						return E.db.mMT.custombackgrounds.health.texture
					end,
					set = function(info, value)
						E.db.mMT.custombackgrounds.health.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		powerheader = {
			order = 11,
			type = "group",
			inline = true,
			name = L["Custom Power Backdrop"],
			args = {
				bgpower = {
					order = 12,
					type = "toggle",
					name = L["Custom Power Backdrop"],
					desc = L["Enable Custom Power Backdrop"],
					get = function(info)
						return E.db.mMT.custombackgrounds.power.enable
					end,
					set = function(info, value)
						E.db.mMT.custombackgrounds.power.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				powertexture = {
					order = 13,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Backdrop Texture"],
					values = LSM:HashTable("statusbar"),
					disabled = function()
						return not E.db.mMT.custombackgrounds.power.enable
					end,
					get = function(info)
						return E.db.mMT.custombackgrounds.power.texture
					end,
					set = function(info, value)
						E.db.mMT.custombackgrounds.power.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		castbarheader = {
			order = 21,
			type = "group",
			inline = true,
			name = L["Custom Castbar Backdrop"],
			args = {
				bgcastbar = {
					order = 22,
					type = "toggle",
					name = L["Custom Castbar Backdrop"],
					desc = L["Enable Custom Castbar Backdrop"],
					get = function(info)
						return E.db.mMT.custombackgrounds.castbar.enable
					end,
					set = function(info, value)
						E.db.mMT.custombackgrounds.castbar.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				castbartexture = {
					order = 23,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Backdrop Texture"],
					values = LSM:HashTable("statusbar"),
					disabled = function()
						return not E.db.mMT.custombackgrounds.castbar.enable
					end,
					get = function(info)
						return E.db.mMT.custombackgrounds.castbar.texture
					end,
					set = function(info, value)
						E.db.mMT.custombackgrounds.castbar.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
