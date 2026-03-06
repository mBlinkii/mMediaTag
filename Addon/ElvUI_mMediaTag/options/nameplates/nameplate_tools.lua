local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

mMT.options.args.nameplates.args.nameplate_tools.args = {
	glow = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Target & Glow color"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Sets automatically your class color for glow and border color on nameplates for the target unit."],
			},
			enable = {
				order = 2,
				type = "toggle",
				name = function()
					return E.db.mMediaTag.nameplates.target_glow_color and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.target_glow_color
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.target_glow_color = value
					mMT:UpdateModule("NameplateTools")
					NP:ConfigureAll()
				end,
			},
			elvui_settings = {
				order = 3,
				type = "execute",
				name = L["ElvUI Color Settings"],
				desc = L["Open the ElvUI color settings to adjust the colors used for nameplates."],
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "nameplates", "colorsGroup")
				end,
			},
		},
	},
	focus = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Highlight Focus"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Highlight the focus unit on nameplates."],
			},
			color = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Color"],
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
							mMT:UpdateModule("NameplateTools")
							if value == false then E:StaticPopup_Show("CONFIG_RL") end
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
							mMT:UpdateModule("NameplateTools")
						end,
					},
				},
			},
			texture = {
				order = 3,
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
							mMT:UpdateModule("NameplateTools")
							if value == false then E:StaticPopup_Show("CONFIG_RL") end
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
							mMT:UpdateModule("NameplateTools")
						end,
					},
				},
			},
		},
	},
	target = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Highlight Target"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Highlight the target unit on nameplates."],
			},
			color = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Color"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = function()
							return E.db.mMediaTag.nameplates.target.changeColor and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
						end,
						get = function(info)
							return E.db.mMediaTag.nameplates.target.changeColor
						end,
						set = function(info, value)
							E.db.mMediaTag.nameplates.target.changeColor = value
							mMT:UpdateModule("NameplateTools")
							if value == false then E:StaticPopup_Show("CONFIG_RL") end
						end,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.nameplates.target_color)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMediaTag.color.nameplates.target_color = hex
							MEDIA.color.nameplates.target_color = CreateColorFromHexString(hex)
							MEDIA.color.nameplates.target_color.hex = hex
							mMT:UpdateModule("NameplateTools")
						end,
					},
				},
			},
			texture = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Texture"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = function()
							return E.db.mMediaTag.nameplates.target.changeTexture and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
						end,
						get = function(info)
							return E.db.mMediaTag.nameplates.target.changeTexture
						end,
						set = function(info, value)
							E.db.mMediaTag.nameplates.target.changeTexture = value
							mMT:UpdateModule("NameplateTools")
							if value == false then E:StaticPopup_Show("CONFIG_RL") end
						end,
					},
					texture = {
						order = 2,
						type = "select",
						dialogControl = "LSM30_Statusbar",
						name = L["Texture"],
						values = LSM:HashTable("statusbar"),
						get = function(info)
							return E.db.mMediaTag.nameplates.target.texture
						end,
						set = function(info, value)
							E.db.mMediaTag.nameplates.target.texture = value
							mMT:UpdateModule("NameplateTools")
						end,
					},
				},
			},
		},
	},
}
