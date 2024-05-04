local E, L = unpack(ElvUI)

local LSM = LibStub("LibSharedMedia-3.0")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.cosmetic.args.background.args = {
		healthheader = {
			order = 1,
			type = "group",
			inline = true,
			name = L["BG_CHBG"],
			args = {
				bghealth = {
					order = 2,
					type = "toggle",
					name = L["BG_CHBG"],
					desc = L["BG_TIP_CHBG"],
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
					name = L["BG_BGT"],
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
			name = L["BG_CPBG"],
			args = {
				bgpower = {
					order = 12,
					type = "toggle",
					name = L["BG_CPBG"],
					desc = L["BG_TIP_CPBG"],
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
					name = L["BG_BGT"],
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
			name = L["BG_CCBG"],
			args = {
				bgcastbar = {
					order = 22,
					type = "toggle",
					name = L["BG_CCBG"],
					desc = L["BG_TIP_CCBG"],
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
					name = L["BG_BGT"],
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
