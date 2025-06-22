local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local frameStrata = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	TOOLTIP = "TOOLTIP",
	AUTO = "Auto",
}

mMT.options.args.unitframes.args.portraits.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMT.portraits.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMT.portraits.enable
		end,
		set = function(info, value)
			E.db.mMT.portraits.enable = value
			M.Portraits:Initialize()
		end,
	},
	general_group = {
		order = 2,
		type = "group",
		name = L["General"],
		args = {
			misc_group = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Misc"],
				args = {
					zoom_range = {
						order = 1,
						name = L["Portrait Scale"],
						type = "range",
						min = 0.01,
						max = 2,
						step = 0.01,
						get = function(info)
							return E.db.mMT.portraits.misc.scale
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.scale = value
							M.Portraits:Initialize()
						end,
					},
					enable_force_desaturate = {
						order = 2,
						type = "toggle",
						name = L["Desaturate"],
						desc = L["Will always desaturate the portraits."],
						get = function(info)
							return E.db.mMT.portraits.misc.desaturate
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.desaturate = value
							M.Portraits:Initialize()
						end,
					},
					enable_embellishment = {
						order = 3,
						type = "toggle",
						name = L["Embellishment"],
						desc = L["Will show the embellishment on the portraits, if the Style has an embellishment."],
						get = function(info)
							return E.db.mMT.portraits.misc.embellishment
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.embellishment = value
							M.Portraits:Initialize()
						end,
					},
				},
			},
			shadow_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Shadow"],
				args = {
					enable_shadow = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable the Shadow for the Portraits."],
						get = function(info)
							return E.db.mMT.portraits.shadow.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.shadow.enable = value
							M.Portraits:Initialize()
						end,
					},
					alpha_range = {
						order = 2,
						name = L["Portrait Scale"],
						type = "range",
						min = 0,
						max = 1,
						step = 0.01,
						get = function(info)
							return E.db.mMT.portraits.shadow.alpha
						end,
						set = function(info, value)
							E.db.mMT.portraits.shadow.alpha = value
							M.Portraits:Initialize()
						end,
					},
				},
			},
			icons_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Icons"],
				args = {
					classIcon_select = {
						order = 1,
						type = "select",
						name = "Class icon",
						desc = "Enable and select a class icon style for the portrait.",
						get = function(info)
							return E.db.mMT.portraits.misc.class_icon
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.class_icon = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.icons.class.icons.mmt) do
								if type(v) == "table" then t[k] = v.name end
							end
							for k, v in pairs(MEDIA.icons.class.icons.custom) do
								if type(v) == "table" then t[k] = v.name end
							end
							t.none = "None"
							return t
						end,
					},
				},
			},
			bg_group = {
				order = 4,
				type = "group",
				inline = true,
				name = L["BG"],
				args = {
					bg = {
						order = 1,
						type = "select",
						name = L["BG Style"],
						desc = L["Choose the background style for the transparent Class icons."],
						get = function(info)
							return E.db.mMT.portraits.bg.style
						end,
						set = function(info, value)
							E.db.mMT.portraits.bg.style = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.bg) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					color_background = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.misc.bg)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.portraits.misc.bg = hex
							MEDIA.color.portraits.misc.bg = CreateColorFromHexString(hex)
							MEDIA.color.portraits.misc.bg.hex = hex
							M.Portraits:Initialize()
						end,
					},
					toggle_classbg = {
						order = 3,
						type = "toggle",
						name = L["Class colored"],
						desc = L["Enable Class colored Background"],
						get = function(info)
							return E.db.mMT.portraits.bg.classBG
						end,
						set = function(info, value)
							E.db.mMT.portraits.bg.classBG = value
							M.Portraits:Initialize()
						end,
					},
					range_bgColorShift = {
						order = 4,
						name = L["Background color shift"],
						type = "range",
						min = 0,
						max = 1,
						step = 0.01,
						softMin = 0,
						softMax = 1,
						get = function(info)
							return E.db.mMT.portraits.bg.bgColorShift
						end,
						set = function(info, value)
							E.db.mMT.portraits.bg.bgColorShift = value
							M.Portraits:Initialize()
						end,
					},
				},
			},
			custom_textures_group = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Custom Textures"],
				args = {
					enable_custom_textures_toggle = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable Custom Textures for Portrait."],
						get = function(info)
							return E.db.mMT.portraits.custom.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.enable = value
							M.Portraits:Initialize()
						end,
					},
					description = {
						order = 2,
						type = "description",
						name = L["Put your custom textures in the Addon folder and add the path here (example MyMediaFolder\\MyTexture.tga)."],
					},
					texture_input = {
						order = 3,
						name = L["Texture"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMT.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.texture = value
							M.Portraits:Initialize()
						end,
					},
					mask_input = {
						order = 4,
						name = L["Mask"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMT.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.mask
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.mask = value
							M.Portraits:Initialize()
						end,
					},
					extra_mask_input = {
						order = 5,
						name = L["Extra Mask"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMT.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.extra_mask
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.extra_mask = value
							M.Portraits:Initialize()
						end,
					},
					shadow = {
						order = 6,
						name = L["Shadow"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMT.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.shadow
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.shadow = value
							M.Portraits:Initialize()
						end,
					},
					extra_shadow = {
						order = 7,
						name = L["Extra Shadow"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMT.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.extra_shadow
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.extra_shadow = value
							M.Portraits:Initialize()
						end,
					},
					space_description = {
						order = 8,
						type = "description",
						name = "\n\n",
					},
					enable_custom_extra_toggle = {
						order = 9,
						type = "toggle",
						name = L["Custom Extra Texture"],
						desc = L["Enable Custom extra Textures for Portrait."],
						get = function(info)
							return E.db.mMT.portraits.custom.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.extra = value
							M.Portraits:Initialize()
						end,
					},
					rare_input = {
						order = 10,
						name = L["Rare"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMT.portraits.custom.enable and E.db.mMT.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.rare
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.rare = value
							M.Portraits:Initialize()
						end,
					},
					elite_input = {
						order = 11,
						name = L["Elite"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMT.portraits.custom.enable and E.db.mMT.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.elite
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.elite = value
							M.Portraits:Initialize()
						end,
					},
					rareelite_input = {
						order = 12,
						name = L["Rare Elite"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMT.portraits.custom.enable and E.db.mMT.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.rareelite
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.rareelite = value
							M.Portraits:Initialize()
						end,
					},
					boss_input = {
						order = 13,
						name = L["Boss"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMT.portraits.custom.enable and E.db.mMT.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.boss
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.boss = value
							M.Portraits:Initialize()
						end,
					},
					player_input = {
						order = 14,
						name = L["Player"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMT.portraits.custom.enable and E.db.mMT.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMT.portraits.custom.player
						end,
						set = function(info, value)
							E.db.mMT.portraits.custom.player = value
							M.Portraits:Initialize()
						end,
					},
				},
			},
		},
	},
	player_group = {
		order = 3,
		type = "group",
		name = L["Player"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.player.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.player.enable = value

					M.Portraits:InitializePlayerPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.player.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.texture = value
							M.Portraits:InitializePlayerPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.player.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.size = value

							if not E.db.mMT.portraits.player.extra_settings.enable then E.db.mMT.portraits.player.extra_settings.size = value end
							M.Portraits:InitializePlayerPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.player.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.cast = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.player.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.extra = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.player.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.unitcolor = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.player.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.player.point.point = "RIGHT"
								E.db.mMT.portraits.player.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.player.point.point = "LEFT"
								E.db.mMT.portraits.player.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.player.point.point = "BOTTOM"
								E.db.mMT.portraits.player.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.player.point.point = "TOP"
								E.db.mMT.portraits.player.mirror = false
							else
								E.db.mMT.portraits.player.point.point = value
								E.db.mMT.portraits.player.mirror = false
							end

							M.Portraits:InitializePlayerPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.player.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.point.x = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.player.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.point.y = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.player.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.strata = value
							M.Portraits:InitializePlayerPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.player.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.level = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.player.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.extra_settings.enable = value

							M.Portraits:InitializePlayerPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.player.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.player.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.extra_settings.size = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.player.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.player.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.extra_settings.offset.x = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.player.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.player.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.player.extra_settings.offset.y = value
							M.Portraits:InitializePlayerPortrait()
						end,
					},
				},
			},
		},
	},
	target_group = {
		order = 4,
		type = "group",
		name = L["Target"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.target.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.target.enable = value

					M.Portraits:InitializeTargetPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.target.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.texture = value
							M.Portraits:InitializeTargetPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.target.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.size = value

							if not E.db.mMT.portraits.target.extra_settings.enable then E.db.mMT.portraits.target.extra_settings.size = value end
							M.Portraits:InitializeTargetPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.target.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.cast = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.target.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.extra = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.target.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.unitcolor = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMT.portraits.target.forceExtra
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.forceExtra = value
							M.Portraits:InitializeTargetPortrait()
						end,
						values = {
							none = "None",
							player = "Player",
							rare = "Rare",
							elite = "Elite",
							rareelite = "Rare Elite",
							boss = "Boss",
						},
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.target.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.target.point.point = "RIGHT"
								E.db.mMT.portraits.target.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.target.point.point = "LEFT"
								E.db.mMT.portraits.target.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.target.point.point = "BOTTOM"
								E.db.mMT.portraits.target.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.target.point.point = "TOP"
								E.db.mMT.portraits.target.mirror = false
							else
								E.db.mMT.portraits.target.point.point = value
								E.db.mMT.portraits.target.mirror = false
							end

							M.Portraits:InitializeTargetPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.target.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.point.x = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.target.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.point.y = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.target.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.strata = value
							M.Portraits:InitializeTargetPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.target.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.level = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.target.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.extra_settings.enable = value

							M.Portraits:InitializeTargetPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.target.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.target.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.extra_settings.size = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.target.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.target.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.extra_settings.offset.x = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.target.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.target.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.target.extra_settings.offset.y = value
							M.Portraits:InitializeTargetPortrait()
						end,
					},
				},
			},
		},
	},
	focus_group = {
		order = 5,
		type = "group",
		name = L["Focus"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.focus.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.focus.enable = value

					M.Portraits:InitializeFocusPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.focus.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.texture = value
							M.Portraits:InitializeFocusPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.focus.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.size = value

							if not E.db.mMT.portraits.focus.extra_settings.enable then E.db.mMT.portraits.focus.extra_settings.size = value end
							M.Portraits:InitializeFocusPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.focus.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.cast = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.focus.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.extra = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.focus.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.unitcolor = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMT.portraits.focus.forceExtra
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.forceExtra = value
							M.Portraits:InitializeFocusPortrait()
						end,
						values = {
							none = "None",
							player = "Player",
							rare = "Rare",
							elite = "Elite",
							rareelite = "Rare Elite",
							boss = "Boss",
						},
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.focus.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.focus.point.point = "RIGHT"
								E.db.mMT.portraits.focus.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.focus.point.point = "LEFT"
								E.db.mMT.portraits.focus.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.focus.point.point = "BOTTOM"
								E.db.mMT.portraits.focus.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.focus.point.point = "TOP"
								E.db.mMT.portraits.focus.mirror = false
							else
								E.db.mMT.portraits.focus.point.point = value
								E.db.mMT.portraits.focus.mirror = false
							end

							M.Portraits:InitializeFocusPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.focus.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.point.x = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.focus.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.point.y = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.focus.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.strata = value
							M.Portraits:InitializeFocusPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.focus.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.level = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.focus.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.extra_settings.enable = value

							M.Portraits:InitializeFocusPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.focus.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.focus.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.extra_settings.size = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.focus.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.focus.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.extra_settings.offset.x = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.focus.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.focus.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.focus.extra_settings.offset.y = value
							M.Portraits:InitializeFocusPortrait()
						end,
					},
				},
			},
		},
	},
	pet_group = {
		order = 6,
		type = "group",
		name = L["Pet"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.pet.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.pet.enable = value

					M.Portraits:InitializePetPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.pet.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.texture = value
							M.Portraits:InitializePetPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.pet.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.size = value

							if not E.db.mMT.portraits.pet.extra_settings.enable then E.db.mMT.portraits.pet.extra_settings.size = value end
							M.Portraits:InitializePetPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.pet.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.cast = value
							M.Portraits:InitializePetPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.pet.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.extra = value
							M.Portraits:InitializePetPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.pet.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.unitcolor = value
							M.Portraits:InitializePetPortrait()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMT.portraits.pet.forceExtra
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.forceExtra = value
							M.Portraits:InitializePetPortrait()
						end,
						values = {
							none = "None",
							player = "Player",
							rare = "Rare",
							elite = "Elite",
							rareelite = "Rare Elite",
							boss = "Boss",
						},
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.pet.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.pet.point.point = "RIGHT"
								E.db.mMT.portraits.pet.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.pet.point.point = "LEFT"
								E.db.mMT.portraits.pet.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.pet.point.point = "BOTTOM"
								E.db.mMT.portraits.pet.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.pet.point.point = "TOP"
								E.db.mMT.portraits.pet.mirror = false
							else
								E.db.mMT.portraits.pet.point.point = value
								E.db.mMT.portraits.pet.mirror = false
							end

							M.Portraits:InitializePetPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.pet.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.point.x = value
							M.Portraits:InitializePetPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.pet.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.point.y = value
							M.Portraits:InitializePetPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.pet.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.strata = value
							M.Portraits:InitializePetPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.pet.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.level = value
							M.Portraits:InitializePetPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.pet.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.extra_settings.enable = value

							M.Portraits:InitializePetPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.pet.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.pet.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.extra_settings.size = value
							M.Portraits:InitializePetPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.pet.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.pet.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.extra_settings.offset.x = value
							M.Portraits:InitializePetPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.pet.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.pet.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.pet.extra_settings.offset.y = value
							M.Portraits:InitializePetPortrait()
						end,
					},
				},
			},
		},
	},
	targettarget_group = {
		order = 7,
		type = "group",
		name = L["Target of Target"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.targettarget.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.targettarget.enable = value

					M.Portraits:InitializeToTPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.targettarget.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.texture = value
							M.Portraits:InitializeToTPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.targettarget.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.size = value

							if not E.db.mMT.portraits.targettarget.extra_settings.enable then E.db.mMT.portraits.targettarget.extra_settings.size = value end
							M.Portraits:InitializeToTPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.targettarget.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.cast = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.targettarget.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.extra = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.targettarget.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.unitcolor = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMT.portraits.targettarget.forceExtra
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.forceExtra = value
							M.Portraits:InitializeToTPortrait()
						end,
						values = {
							none = "None",
							player = "Player",
							rare = "Rare",
							elite = "Elite",
							rareelite = "Rare Elite",
							boss = "Boss",
						},
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.targettarget.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.targettarget.point.point = "RIGHT"
								E.db.mMT.portraits.targettarget.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.targettarget.point.point = "LEFT"
								E.db.mMT.portraits.targettarget.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.targettarget.point.point = "BOTTOM"
								E.db.mMT.portraits.targettarget.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.targettarget.point.point = "TOP"
								E.db.mMT.portraits.targettarget.mirror = false
							else
								E.db.mMT.portraits.targettarget.point.point = value
								E.db.mMT.portraits.targettarget.mirror = false
							end

							M.Portraits:InitializeToTPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.targettarget.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.point.x = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.targettarget.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.point.y = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.targettarget.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.strata = value
							M.Portraits:InitializeToTPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.targettarget.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.level = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.targettarget.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.extra_settings.enable = value

							M.Portraits:InitializeToTPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.targettarget.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.targettarget.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.extra_settings.size = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.targettarget.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.targettarget.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.extra_settings.offset.x = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.targettarget.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.targettarget.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.targettarget.extra_settings.offset.y = value
							M.Portraits:InitializeToTPortrait()
						end,
					},
				},
			},
		},
	},
	party_group = {
		order = 8,
		type = "group",
		name = L["Party"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.party.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.party.enable = value

					M.Portraits:InitializePartyPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.party.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.texture = value
							M.Portraits:InitializePartyPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.party.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.size = value

							if not E.db.mMT.portraits.party.extra_settings.enable then E.db.mMT.portraits.party.extra_settings.size = value end
							M.Portraits:InitializePartyPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.party.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.cast = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.party.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.extra = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.party.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.unitcolor = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMT.portraits.party.forceExtra
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.forceExtra = value
							M.Portraits:InitializePartyPortrait()
						end,
						values = {
							none = "None",
							player = "Player",
							rare = "Rare",
							elite = "Elite",
							rareelite = "Rare Elite",
							boss = "Boss",
						},
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.party.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.party.point.point = "RIGHT"
								E.db.mMT.portraits.party.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.party.point.point = "LEFT"
								E.db.mMT.portraits.party.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.party.point.point = "BOTTOM"
								E.db.mMT.portraits.party.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.party.point.point = "TOP"
								E.db.mMT.portraits.party.mirror = false
							else
								E.db.mMT.portraits.party.point.point = value
								E.db.mMT.portraits.party.mirror = false
							end

							M.Portraits:InitializePartyPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.party.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.point.x = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.party.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.point.y = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.party.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.strata = value
							M.Portraits:InitializePartyPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.party.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.level = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.party.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.extra_settings.enable = value

							M.Portraits:InitializePartyPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.party.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.party.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.extra_settings.size = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.party.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.party.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.extra_settings.offset.x = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.party.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.party.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.party.extra_settings.offset.y = value
							M.Portraits:InitializePartyPortrait()
						end,
					},
				},
			},
		},
	},
	boss_group = {
		order = 9,
		type = "group",
		name = L["Boss"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.boss.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.boss.enable = value

					M.Portraits:InitializeBossPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.boss.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.texture = value
							M.Portraits:InitializeBossPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.boss.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.size = value

							if not E.db.mMT.portraits.boss.extra_settings.enable then E.db.mMT.portraits.boss.extra_settings.size = value end
							M.Portraits:InitializeBossPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.boss.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.cast = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.boss.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.extra = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.boss.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.unitcolor = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMT.portraits.boss.forceExtra
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.forceExtra = value
							M.Portraits:InitializeBossPortrait()
						end,
						values = {
							none = "None",
							player = "Player",
							rare = "Rare",
							elite = "Elite",
							rareelite = "Rare Elite",
							boss = "Boss",
						},
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.boss.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.boss.point.point = "RIGHT"
								E.db.mMT.portraits.boss.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.boss.point.point = "LEFT"
								E.db.mMT.portraits.boss.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.boss.point.point = "BOTTOM"
								E.db.mMT.portraits.boss.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.boss.point.point = "TOP"
								E.db.mMT.portraits.boss.mirror = false
							else
								E.db.mMT.portraits.boss.point.point = value
								E.db.mMT.portraits.boss.mirror = false
							end

							M.Portraits:InitializeBossPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.boss.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.point.x = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.boss.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.point.y = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.boss.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.strata = value
							M.Portraits:InitializeBossPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.boss.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.level = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.boss.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.extra_settings.enable = value

							M.Portraits:InitializeBossPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.boss.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.boss.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.extra_settings.size = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.boss.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.boss.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.extra_settings.offset.x = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.boss.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.boss.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.boss.extra_settings.offset.y = value
							M.Portraits:InitializeBossPortrait()
						end,
					},
				},
			},
		},
	},
	arena_group = {
		order = 10,
		type = "group",
		name = L["Arena"],
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMT.portraits.arena.enable
				end,
				set = function(info, value)
					E.db.mMT.portraits.arena.enable = value

					M.Portraits:InitializeArenaPortrait()
				end,
			},
			general_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				args = {
					styles_select = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["Select a portrait texture style."],
						get = function(info)
							return E.db.mMT.portraits.arena.texture
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.texture = value
							M.Portraits:InitializeArenaPortrait()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.textures) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 512,
						step = 1,
						softMin = 16,
						softMax = 512,
						get = function(info)
							return E.db.mMT.portraits.arena.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.size = value

							if not E.db.mMT.portraits.arena.extra_settings.enable then E.db.mMT.portraits.arena.extra_settings.size = value end
							M.Portraits:InitializeArenaPortrait()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = "Enable Cast Icons.",
						get = function(info)
							return E.db.mMT.portraits.arena.cast
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.cast = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.arena.extra
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.extra = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMT.portraits.arena.unitcolor
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.unitcolor = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMT.portraits.arena.forceExtra
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.forceExtra = value
							M.Portraits:InitializeArenaPortrait()
						end,
						values = {
							none = "None",
							player = "Player",
							rare = "Rare",
							elite = "Elite",
							rareelite = "Rare Elite",
							boss = "Boss",
						},
					},
				},
			},
			anchor_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.portraits.arena.point.relativePoint
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.point.relativePoint = value
							if value == "LEFT" then
								E.db.mMT.portraits.arena.point.point = "RIGHT"
								E.db.mMT.portraits.arena.mirror = false
							elseif value == "RIGHT" then
								E.db.mMT.portraits.arena.point.point = "LEFT"
								E.db.mMT.portraits.arena.mirror = true
							elseif value == "TOP" then
								E.db.mMT.portraits.arena.point.point = "BOTTOM"
								E.db.mMT.portraits.arena.mirror = false
							elseif value == "BOTTOM" then
								E.db.mMT.portraits.arena.point.point = "TOP"
								E.db.mMT.portraits.arena.mirror = false
							else
								E.db.mMT.portraits.arena.point.point = value
								E.db.mMT.portraits.arena.mirror = false
							end

							M.Portraits:InitializeArenaPortrait()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					offset_x_range = {
						order = 2,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.arena.point.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.point.x = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
					range_ofsY = {
						order = 3,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						get = function(info)
							return E.db.mMT.portraits.arena.point.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.point.y = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
				},
			},
			level_group = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Frame Level/ Strata"],
				args = {
					strata_select = {
						order = 1,
						type = "select",
						name = L["Frame Strata"],
						get = function(info)
							return E.db.mMT.portraits.arena.strata
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.strata = value
							M.Portraits:InitializeArenaPortrait()
						end,
						values = frameStrata,
					},
					level_range = {
						order = 2,
						name = L["Frame Level"],
						type = "range",
						min = 0,
						max = 1000,
						step = 1,
						softMin = 0,
						softMax = 1000,
						get = function(info)
							return E.db.mMT.portraits.arena.level
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.level = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
				},
			},
			extra = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Extra Settings"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable custom Position and size settings for Extra Texture."],
						get = function(info)
							return E.db.mMT.portraits.arena.extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.extra_settings.enable = value

							M.Portraits:InitializeArenaPortrait()
						end,
					},
					size_range = {
						order = 2,
						name = L["Size"],
						type = "range",
						min = 16,
						max = 1024,
						step = 1,
						softMin = 16,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.arena.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.arena.extra_settings.size
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.extra_settings.size = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
					offset_x_range = {
						order = 3,
						name = L["X offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.arena.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.arena.extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.extra_settings.offset.x = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
					range_ofsY = {
						order = 4,
						name = L["Y offset"],
						type = "range",
						min = -256,
						max = 256,
						step = 1,
						softMin = -1024,
						softMax = 1024,
						disabled = function()
							return not E.db.mMT.portraits.arena.extra_settings.enable
						end,
						get = function(info)
							return E.db.mMT.portraits.arena.extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMT.portraits.arena.extra_settings.offset.y = value
							M.Portraits:InitializeArenaPortrait()
						end,
					},
				},
			},
		},
	},
	extra_group = {
		order = 11,
		type = "group",
		name = L["Extra"],
		desc = L["Texture Style settings for Extra texture (Rare/Elite/Boss/player)."],
		args = {
			texture_group = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Texture Styles"],
				args = {
					rare_select = {
						order = 1,
						type = "select",
						name = L["Rare"],
						desc = L["Select a extra texture style for rare units."],
						get = function(info)
							return E.db.mMT.portraits.misc.rare
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.rare = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.extra) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					elite_select = {
						order = 2,
						type = "select",
						name = L["Elite"],
						desc = L["Select a extra texture style for elite units."],
						get = function(info)
							return E.db.mMT.portraits.misc.elite
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.elite = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.extra) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					rareelite_select = {
						order = 3,
						type = "select",
						name = L["Rare Elite"],
						desc = L["Select a extra texture style for rare elite units."],
						get = function(info)
							return E.db.mMT.portraits.misc.rareelite
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.rareelite = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.extra) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					boss_select = {
						order = 4,
						type = "select",
						name = L["Boss"],
						desc = L["Select a extra texture style for boss units."],
						get = function(info)
							return E.db.mMT.portraits.misc.boss
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.boss = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.extra) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					player_select = {
						order = 5,
						type = "select",
						name = L["Player"],
						desc = L["Select a extra texture style for player."],
						get = function(info)
							return E.db.mMT.portraits.misc.player
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.player = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.portraits.extra) do
								if type(v) == "table" then t[k] = v.name end
							end
							return t
						end,
					},
					description = {
						order = 6,
						type = "description",
						name = L["TIP: If you use the Blizzard textures and change the classification color to white, you will see the extra texture with the original colors."],
					},
				},
			},
			settings_group = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Settings"],
				args = {
					ontop = {
						order = 1,
						type = "toggle",
						name = L["On Top"],
						desc = L["Enable this to show the Extra Texture on top of the Unit Portrait."],
						get = function(info)
							return E.db.mMT.portraits.misc.extratop
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.extratop = value
							M.Portraits:Initialize()
						end,
					},
				},
			},
		},
	},
	color_group = {
		order = 12,
		type = "group",
		name = L["Color"],
		args = {
			apply_execute = {
				order = 1,
				type = "execute",
				name = L["Apply"],
				func = function()
					M.Portraits:Initialize()
				end,
			},
			reset_class_execute = {
				order = 2,
				type = "execute",
				name = L["Reset class colors"],
				func = function()
					E.db.mMT.color.portraits.class = CopyTable(P.color.portraits.class)
					mMT:UpdateMedia("portraits")
					M.Portraits:Initialize()
				end,
			},
			reset_colors_execute = {
				order = 3,
				type = "execute",
				name = L["Reset all colors"],
				func = function()
					E.db.mMT.color.portraits = CopyTable(P.color.portraits)
					mMT:UpdateMedia("portraits")
					M.Portraits:Initialize()
				end,
			},
			settings_group = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Settings"],
				args = {
					default_toggle = {
						order = 1,
						type = "toggle",
						name = L["Use Default color"],
						desc = L["Forces the default color for all texture."],
						get = function(info)
							return E.db.mMT.portraits.misc.force_default
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.force_default = value
							M.Portraits:Initialize()
						end,
					},
					gradient_toggle = {
						order = 2,
						type = "toggle",
						name = L["Gradient"],
						desc = L["Enable gradient colors for the portraits."],
						get = function(info)
							return E.db.mMT.portraits.misc.gradient
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.gradient = value
							M.Portraits:Initialize()
						end,
					},
					gradient_mode_select = {
						order = 3,
						type = "select",
						name = L["Mode"],
						desc = L["Choose the gradient orientation."],
						disabled = function()
							return not E.db.mMT.portraits.misc.gradient
						end,
						get = function(info)
							return E.db.mMT.portraits.misc.gradient_mode
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.gradient_mode = value
							M.Portraits:Initialize()
						end,
						values = {
							VERTICAL = L["Vertical"],
							HORIZONTAL = L["Horizontal"],
						},
					},
				},
			},
			misc_group = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Misc"],
				args = {
					default_group = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Default"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.misc.default.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.misc.default.c = hex
									MEDIA.color.portraits.misc.default.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.misc.default.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								disabled = function()
									return not E.db.mMT.color.portraits.misc.gradient
								end,
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.misc.default.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.misc.default.g = hex
									MEDIA.color.portraits.misc.default.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.misc.default.g.hex = hex
								end,
							},
						},
					},
					death_group = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Death"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.misc.death.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.misc.death.c = hex
									MEDIA.color.portraits.misc.death.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.misc.death.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								disabled = function()
									return not E.db.mMT.color.portraits.misc.gradient
								end,
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.misc.death.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.misc.death.g = hex
									MEDIA.color.portraits.misc.death.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.misc.death.g.hex = hex
								end,
							},
						},
					},
				},
			},
			class_group = {
				order = 6,
				type = "group",
				inline = true,
				name = L["Class"],
				args = {
					DEATHKNIGHT_group = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Death Knight"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.DEATHKNIGHT.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.DEATHKNIGHT.c = hex
									MEDIA.color.portraits.class.DEATHKNIGHT.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DEATHKNIGHT.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								disabled = function()
									return not E.db.mMT.color.portraits.misc.gradient
								end,
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.DEATHKNIGHT.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.DEATHKNIGHT.g = hex
									MEDIA.color.portraits.class.DEATHKNIGHT.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DEATHKNIGHT.g.hex = hex
								end,
							},
						},
					},
					DEMONHUNTER_color = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Demon Hunter"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.DEMONHUNTER.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.DEMONHUNTER.c = hex
									MEDIA.color.portraits.class.DEMONHUNTER.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DEMONHUNTER.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.DEMONHUNTER.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.DEMONHUNTER.g = hex
									MEDIA.color.portraits.class.DEMONHUNTER.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DEMONHUNTER.g.hex = hex
								end,
							},
						},
					},
					DRUID_color = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Druid"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.DRUID.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.DRUID.c = hex
									MEDIA.color.portraits.class.DRUID.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DRUID.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								disabled = function()
									return not E.db.mMT.color.portraits.misc.gradient
								end,
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.DRUID.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.DRUID.g = hex
									MEDIA.color.portraits.class.DRUID.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DRUID.g.hex = hex
								end,
							},
						},
					},
					EVOKER_color = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Evoker"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.EVOKER.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.EVOKER.c = hex
									MEDIA.color.portraits.class.EVOKER.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.EVOKER.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.EVOKER.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.EVOKER.g = hex
									MEDIA.color.portraits.class.EVOKER.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.EVOKER.g.hex = hex
								end,
							},
						},
					},
					HUNTER_color = {
						order = 5,
						type = "group",
						inline = true,
						name = L["Hunter"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.HUNTER.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.HUNTER.c = hex
									MEDIA.color.portraits.class.HUNTER.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.HUNTER.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								disabled = function()
									return not E.db.mMT.color.portraits.misc.gradient
								end,
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.HUNTER.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.HUNTER.g = hex
									MEDIA.color.portraits.class.HUNTER.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.HUNTER.g.hex = hex
								end,
							},
						},
					},
					MAGE_color = {
						order = 6,
						type = "group",
						inline = true,
						name = L["Mage"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.MAGE.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.MAGE.c = hex
									MEDIA.color.portraits.class.MAGE.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.MAGE.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.MAGE.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.MAGE.g = hex
									MEDIA.color.portraits.class.MAGE.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.MAGE.g.hex = hex
								end,
							},
						},
					},
					MONK_color = {
						order = 7,
						type = "group",
						inline = true,
						name = L["Monk"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.MONK.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.MONK.c = hex
									MEDIA.color.portraits.class.MONK.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.MONK.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								disabled = function()
									return not E.db.mMT.color.portraits.misc.gradient
								end,
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.MONK.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.MONK.g = hex
									MEDIA.color.portraits.class.MONK.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.MONK.g.hex = hex
								end,
							},
						},
					},
					PALADIN_color = {
						order = 8,
						type = "group",
						inline = true,
						name = L["Paladin"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.PALADIN.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.PALADIN.c = hex
									MEDIA.color.portraits.class.PALADIN.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.PALADIN.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.PALADIN.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.PALADIN.g = hex
									MEDIA.color.portraits.class.PALADIN.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.PALADIN.g.hex = hex
								end,
							},
						},
					},
					PRIEST_color = {
						order = 9,
						type = "group",
						inline = true,
						name = L["Priest"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.PRIEST.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.PRIEST.c = hex
									MEDIA.color.portraits.class.PRIEST.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.PRIEST.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								disabled = function()
									return not E.db.mMT.color.portraits.misc.gradient
								end,
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.PRIEST.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.PRIEST.g = hex
									MEDIA.color.portraits.class.PRIEST.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.PRIEST.g.hex = hex
								end,
							},
						},
					},
					ROGUE_color = {
						order = 10,
						type = "group",
						inline = true,
						name = L["Rogue"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.ROGUE.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.ROGUE.c = hex
									MEDIA.color.portraits.class.ROGUE.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.ROGUE.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.ROGUE.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.ROGUE.g = hex
									MEDIA.color.portraits.class.ROGUE.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.ROGUE.g.hex = hex
								end,
							},
						},
					},
					SHAMAN_color = {
						order = 11,
						type = "group",
						inline = true,
						name = L["Shaman"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.SHAMAN.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.SHAMAN.c = hex
									MEDIA.color.portraits.class.SHAMAN.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.SHAMAN.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.SHAMAN.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.SHAMAN.g = hex
									MEDIA.color.portraits.class.SHAMAN.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.SHAMAN.g.hex = hex
								end,
							},
						},
					},
					WARLOCK_color = {
						order = 12,
						type = "group",
						inline = true,
						name = L["Warlock"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.WARLOCK.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.WARLOCK.c = hex
									MEDIA.color.portraits.class.WARLOCK.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.WARLOCK.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.WARLOCK.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.WARLOCK.g = hex
									MEDIA.color.portraits.class.WARLOCK.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.WARLOCK.g.hex = hex
								end,
							},
						},
					},
					WARRIOR_color = {
						order = 13,
						type = "group",
						inline = true,
						name = L["Warrior"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.WARRIOR.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.WARRIOR.c = hex
									MEDIA.color.portraits.class.WARRIOR.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.WARRIOR.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.class.WARRIOR.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.class.WARRIOR.g = hex
									MEDIA.color.portraits.class.WARRIOR.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.WARRIOR.g.hex = hex
								end,
							},
						},
					},
				},
			},
			classification_group = {
				order = 7,
				type = "group",
				inline = true,
				name = L["Classification"],
				args = {
					rare_color = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Rare"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.rare.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.rare.c = hex
									MEDIA.color.portraits.classification.rare.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.rare.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.rare.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.rare.g = hex
									MEDIA.color.portraits.classification.rare.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.rare.g.hex = hex
								end,
							},
						},
					},
					elite_color = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Elite"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.elite.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.elite.c = hex
									MEDIA.color.portraits.classification.elite.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.elite.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.elite.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.elite.g = hex
									MEDIA.color.portraits.classification.elite.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.elite.g.hex = hex
								end,
							},
						},
					},
					rareelite_color = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Rare Elite"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.rareelite.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.rareelite.c = hex
									MEDIA.color.portraits.classification.rareelite.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.rareelite.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.rareelite.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.rareelite.g = hex
									MEDIA.color.portraits.classification.rareelite.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.rareelite.g.hex = hex
								end,
							},
						},
					},
					boss_color = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Boss"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.boss.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.boss.c = hex
									MEDIA.color.portraits.classification.boss.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.boss.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.boss.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.boss.g = hex
									MEDIA.color.portraits.classification.boss.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.boss.g.hex = hex
								end,
							},
						},
					},
					player_color = {
						order = 5,
						type = "group",
						inline = true,
						name = L["Player"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.player.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.player.c = hex
									MEDIA.color.portraits.classification.player.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.player.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.classification.player.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.classification.player.g = hex
									MEDIA.color.portraits.classification.player.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.player.g.hex = hex
								end,
							},
						},
					},
				},
			},
			reaction_group = {
				order = 8,
				type = "group",
				inline = true,
				name = L["Reaction"],
				args = {
					enemy_color = {
						order = 5,
						type = "group",
						inline = true,
						name = L["Enemy"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.reaction.enemy.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.reaction.enemy.c = hex
									MEDIA.color.portraits.reaction.enemy.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.enemy.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.reaction.enemy.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.reaction.enemy.g = hex
									MEDIA.color.portraits.reaction.enemy.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.enemy.g.hex = hex
								end,
							},
						},
					},
					neutral_color = {
						order = 6,
						type = "group",
						inline = true,
						name = L["Neutral"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.reaction.neutral.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.reaction.neutral.c = hex
									MEDIA.color.portraits.reaction.neutral.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.neutral.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.reaction.neutral.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.reaction.neutral.g = hex
									MEDIA.color.portraits.reaction.neutral.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.neutral.g.hex = hex
								end,
							},
						},
					},
					friendly_color = {
						order = 7,
						type = "group",
						inline = true,
						name = L["Friendly"],
						args = {
							color_a = {
								type = "color",
								order = 1,
								name = "A",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.reaction.friendly.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.reaction.friendly.c = hex
									MEDIA.color.portraits.reaction.friendly.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.friendly.c.hex = hex
								end,
							},
							color_b = {
								type = "color",
								order = 2,
								name = "B",
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.portraits.reaction.friendly.g)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.portraits.reaction.friendly.g = hex
									MEDIA.color.portraits.reaction.friendly.g = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.friendly.g.hex = hex
								end,
							},
						},
					},
				},
			},
		},
	},
}
