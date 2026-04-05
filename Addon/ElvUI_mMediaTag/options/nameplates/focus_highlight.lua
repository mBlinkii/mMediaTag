local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

mMT.options.args.nameplates.args.focus_highlight.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.nameplates.focus.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.nameplates.focus.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.nameplates.focus.enable = value
			mMT:UpdateModule("NP-FocusHighlight")
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
					return E.db.mMediaTag.nameplates.focus.changeColor and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.focus.changeColor
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.focus.changeColor = value
					mMT:UpdateModule("NP-FocusHighlight")
					if value == false then
						E.db.mMediaTag.nameplates.focus.enable = E.db.mMediaTag.nameplates.focus.changeColor or E.db.mMediaTag.nameplates.focus.changeBorder or E.db.mMediaTag.nameplates.focus.changeTexture
						if E.db.mMediaTag.nameplates.focus.enable == false then E:StaticPopup_Show("CONFIG_RL") end
					end
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.nameplates.focus_color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.nameplates.focus_color = hex
					MEDIA.color.nameplates.focus_color = CreateColorFromHexString(hex)
					MEDIA.color.nameplates.focus_color.hex = hex
					mMT:UpdateModule("NP-FocusHighlight")
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
					return E.db.mMediaTag.nameplates.focus.changeBorder and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.focus.changeBorder
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.focus.changeBorder = value
					mMT:UpdateModule("NP-FocusHighlight")
					if value == false then
						E.db.mMediaTag.nameplates.focus.enable = E.db.mMediaTag.nameplates.focus.changeColor or E.db.mMediaTag.nameplates.focus.changeBorder or E.db.mMediaTag.nameplates.focus.changeTexture
						if E.db.mMediaTag.nameplates.focus.enable == false then E:StaticPopup_Show("CONFIG_RL") end
					end
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.nameplates.focus_border_color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.nameplates.focus_border_color = hex
					MEDIA.color.nameplates.focus_border_color = CreateColorFromHexString(hex)
					MEDIA.color.nameplates.focus_border_color.hex = hex
					mMT:UpdateModule("NP-FocusHighlight")
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
					return E.db.mMediaTag.nameplates.focus.changeTexture and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.focus.changeTexture
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.focus.changeTexture = value
					mMT:UpdateModule("NP-FocusHighlight")
					if value == false then
						E.db.mMediaTag.nameplates.focus.enable = E.db.mMediaTag.nameplates.focus.changeColor or E.db.mMediaTag.nameplates.focus.changeBorder or E.db.mMediaTag.nameplates.focus.changeTexture
						if E.db.mMediaTag.nameplates.focus.enable == false then E:StaticPopup_Show("CONFIG_RL") end
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
					return E.db.mMediaTag.nameplates.focus.texture
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.focus.texture = value
					mMT:UpdateModule("NP-FocusHighlight")
				end,
			},
		},
	},
}
