local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

mMT.options.args.nameplates.args.quest_highlight.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.nameplates.quest.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.nameplates.quest.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.nameplates.quest.enable = value
			mMT:UpdateModule("NP-QuestHighlight")
			if value == false then E:StaticPopup_Show("CONFIG_RL") end
		end,
	},
	health = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Health color"],
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = function()
					return E.db.mMediaTag.nameplates.quest.changeColor and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.quest.changeColor
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.quest.changeColor = value
					mMT:UpdateModule("NP-QuestHighlight")
					if value == false then
						E.db.mMediaTag.nameplates.quest.enable = E.db.mMediaTag.nameplates.quest.changeColor or E.db.mMediaTag.nameplates.quest.changeBorder or E.db.mMediaTag.nameplates.quest.changeTexture
						if E.db.mMediaTag.nameplates.quest.enable == false then E:StaticPopup_Show("CONFIG_RL") end
					end
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.nameplates.quest_color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.nameplates.quest_color = hex
					MEDIA.color.nameplates.quest_color = CreateColorFromHexString(hex)
					MEDIA.color.nameplates.quest_color.hex = hex
					mMT:UpdateModule("NP-QuestHighlight")
				end,
			},
		},
	},
	border = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Border color"],
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = function()
					return E.db.mMediaTag.nameplates.quest.changeBorder and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.quest.changeBorder
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.quest.changeBorder = value
					mMT:UpdateModule("NP-QuestHighlight")
					if value == false then
						E.db.mMediaTag.nameplates.quest.enable = E.db.mMediaTag.nameplates.quest.changeColor or E.db.mMediaTag.nameplates.quest.changeBorder or E.db.mMediaTag.nameplates.quest.changeTexture
						if E.db.mMediaTag.nameplates.quest.enable == false then E:StaticPopup_Show("CONFIG_RL") end
					end
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.nameplates.quest_border_color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.nameplates.quest_border_color = hex
					MEDIA.color.nameplates.quest_border_color = CreateColorFromHexString(hex)
					MEDIA.color.nameplates.quest_border_color.hex = hex
					mMT:UpdateModule("NP-QuestHighlight")
				end,
			},
		},
	},
	texture = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Texture"],
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = function()
					return E.db.mMediaTag.nameplates.quest.changeTexture and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.quest.changeTexture
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.quest.changeTexture = value
					mMT:UpdateModule("NP-QuestHighlight")
					if value == false then
						E.db.mMediaTag.nameplates.quest.enable = E.db.mMediaTag.nameplates.quest.changeColor or E.db.mMediaTag.nameplates.quest.changeBorder or E.db.mMediaTag.nameplates.quest.changeTexture
						if E.db.mMediaTag.nameplates.quest.enable == false then E:StaticPopup_Show("CONFIG_RL") end
					end
				end,
			},
			texture = {
				order = 2,
				type = "select",
				dialogControl = "LSM30_Statusbar",
				name = L["Texture"],
				values = LSM:HashTable("statusbar"),
				get = function(info)
					return E.db.mMediaTag.nameplates.quest.texture
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.quest.texture = value
					mMT:UpdateModule("NP-QuestHighlight")
				end,
			},
		},
	},
}
