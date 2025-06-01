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
					bg = {
						order = 3,
						type = "select",
						name = L["BG Style"],
						desc = L["Choose the background style for the transparent Class icons."],
						get = function(info)
							return E.db.mMT.portraits.misc.bg
						end,
						set = function(info, value)
							E.db.mMT.portraits.misc.bg = value
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
				},
			},
			custom_textures_group = {
				order = 2,
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
		order = 4,
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
}
