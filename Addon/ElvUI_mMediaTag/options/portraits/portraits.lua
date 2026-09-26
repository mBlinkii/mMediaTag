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

local ringModes = {
	none = L["Disabled"],
	health = L["Health"],
	cast = L["Cast"],
}

local portraitUnits = {
	{ key = "player", name = L["Player"], init = "InitializePlayerPortrait" },
	{ key = "target", name = L["Target"], init = "InitializeTargetPortrait" },
	{ key = "focus", name = L["Focus"], init = "InitializeFocusPortrait" },
	{ key = "pet", name = L["Pet"], init = "InitializePetPortrait" },
	{ key = "targettarget", name = L["Target of Target"], init = "InitializeToTPortrait" },
	{ key = "party", name = L["Party"], init = "InitializePartyPortrait" },
	{ key = "boss", name = L["Boss"], init = "InitializeBossPortrait" },
	{ key = "arena", name = L["Arena"], init = "InitializeArenaPortrait" },
}

local function ringSetting(unit, key)
	return function(info)
		return E.db.mMediaTag.portraits[unit].ring[key]
	end, function(info, value)
		E.db.mMediaTag.portraits[unit].ring[key] = value
		M.Portraits:Initialize()
	end
end

local ringGroups = {
	color_group = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Color"],
		args = {
			color_health = {
				order = 1,
				type = "color",
				name = L["Health"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.misc.ring_health.c)
					return r, g, b
				end,
				set = function(info, r, g, b)
					E.db.mMediaTag.color.portraits.misc.ring_health.c = E:RGBToHex(r, g, b, "ff")
					mMT:UpdateMedia("portraits")
					M.Portraits:Initialize()
				end,
			},
			color_cast = {
				order = 2,
				type = "color",
				name = L["Cast"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.misc.ring_cast.c)
					return r, g, b
				end,
				set = function(info, r, g, b)
					E.db.mMediaTag.color.portraits.misc.ring_cast.c = E:RGBToHex(r, g, b, "ff")
					mMT:UpdateMedia("portraits")
					M.Portraits:Initialize()
				end,
			},
		},
	},
}

for index, unit in ipairs(portraitUnits) do
	local key = unit.key
	local modeGet, modeSet = ringSetting(key, "mode")
	local reverseGet, reverseSet = ringSetting(key, "reverse")
	local invertGet, invertSet = ringSetting(key, "invert")
	local startGet, startSet = ringSetting(key, "start")
	local alphaGet, alphaSet = ringSetting(key, "alpha")
	local baseGet, baseSet = ringSetting(key, "baseAlpha")
	local featherGet, featherSet = ringSetting(key, "feather")

	ringGroups[key .. "_group"] = {
		order = index + 1,
		type = "group",
		name = unit.name,
		args = {
			mode_select = {
				order = 1,
				type = "select",
				name = L["Ring"],
				desc = L["Shows health or the cast as a radial fill on the portrait border."],
				values = ringModes,
				get = modeGet,
				set = function(info, value)
					-- reverse fill is a health idea, on a cast it is just the timer direction
					if value ~= "health" then E.db.mMediaTag.portraits[key].ring.invert = false end
					modeSet(info, value)
				end,
			},
			reverse_toggle = {
				order = 2,
				type = "toggle",
				name = L["Clockwise"],
				desc = L["Fills the ring clockwise, counter-clockwise when disabled."],
				get = reverseGet,
				set = reverseSet,
			},
			invert_toggle = {
				order = 3,
				type = "toggle",
				name = L["Reverse Fill"],
				desc = L["The ring fills with the missing health instead of draining, so it stays empty at full health."],
				disabled = function()
					return E.db.mMediaTag.portraits[key].ring.mode ~= "health"
				end,
				get = invertGet,
				set = invertSet,
			},
			start_range = {
				order = 4,
				type = "range",
				name = L["Start Point"],
				desc = L["Where the fill starts, 0 is the twelve o'clock position."],
				min = 0,
				max = 360,
				step = 1,
				bigStep = 90,
				get = startGet,
				set = startSet,
			},
			alpha_range = {
				order = 5,
				type = "range",
				name = L["Ring Alpha"],
				min = 0,
				max = 1,
				step = 0.01,
				get = alphaGet,
				set = alphaSet,
			},
			base_alpha_range = {
				order = 6,
				type = "range",
				name = L["Border Alpha"],
				desc = L["Opacity of the portrait border below the ring."],
				min = 0,
				max = 1,
				step = 0.01,
				get = baseGet,
				set = baseSet,
			},
			feather_range = {
				order = 7,
				type = "range",
				name = L["Edge Softness"],
				desc = L["Softens the edge of the radial fill."],
				min = 0,
				max = 0.05,
				step = 0.001,
				get = featherGet,
				set = featherSet,
			},
		},
	}
end

local function UnitGroup(unit, order)
	local key = unit.key
	local function update()
		M.Portraits[unit.init](M.Portraits)
	end

	local group = {
		order = order,
		type = "group",
		name = unit.name,
		args = {
			enable_toggle = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable the Unit Portrait."],
				get = function(info)
					return E.db.mMediaTag.portraits[key].enable
				end,
				set = function(info, value)
					E.db.mMediaTag.portraits[key].enable = value

					update()
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
							return E.db.mMediaTag.portraits[key].texture
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].texture = value
							update()
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
							return E.db.mMediaTag.portraits[key].size
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].size = value

							if not E.db.mMediaTag.portraits[key].extra_settings.enable then E.db.mMediaTag.portraits[key].extra_settings.size = value end
							update()
						end,
					},
					cast_toggle = {
						order = 3,
						type = "toggle",
						name = L["Cast Icon"],
						desc = L["Enable Cast Icons."],
						get = function(info)
							return E.db.mMediaTag.portraits[key].cast
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].cast = value
							update()
						end,
					},
					extra_toggle = {
						order = 4,
						type = "toggle",
						name = L["Enable Extra Texture"],
						desc = L["Shows the Extra Texture (rare/elite) for the Unit Portrait."],
						get = function(info)
							return E.db.mMediaTag.portraits[key].extra
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].extra = value
							update()
						end,
					},
					unitcolor_toggle = {
						order = 5,
						type = "toggle",
						name = L["Unitcolor for Extra"],
						desc = L["Use the unit color for the Extra (Rare/Elite) Texture."],
						get = function(info)
							return E.db.mMediaTag.portraits[key].unitcolor
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].unitcolor = value
							update()
						end,
					},
					force_extra_toggle = {
						order = 6,
						type = "select",
						name = L["Force Extra Texture"],
						desc = L["It will override the default extra texture, but will take care of rare/elite/boss units."],
						get = function(info)
							return E.db.mMediaTag.portraits[key].forceExtra
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].forceExtra = value
							update()
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
							return E.db.mMediaTag.portraits[key].point.relativePoint
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].point.relativePoint = value
							if value == "LEFT" then
								E.db.mMediaTag.portraits[key].point.point = "RIGHT"
								E.db.mMediaTag.portraits[key].mirror = false
							elseif value == "RIGHT" then
								E.db.mMediaTag.portraits[key].point.point = "LEFT"
								E.db.mMediaTag.portraits[key].mirror = true
							elseif value == "TOP" then
								E.db.mMediaTag.portraits[key].point.point = "BOTTOM"
								E.db.mMediaTag.portraits[key].mirror = false
							elseif value == "BOTTOM" then
								E.db.mMediaTag.portraits[key].point.point = "TOP"
								E.db.mMediaTag.portraits[key].mirror = false
							else
								E.db.mMediaTag.portraits[key].point.point = value
								E.db.mMediaTag.portraits[key].mirror = false
							end

							update()
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
							return E.db.mMediaTag.portraits[key].point.x
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].point.x = value
							update()
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
							return E.db.mMediaTag.portraits[key].point.y
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].point.y = value
							update()
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
							return E.db.mMediaTag.portraits[key].strata
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].strata = value
							update()
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
							return E.db.mMediaTag.portraits[key].level
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].level = value
							update()
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
							return E.db.mMediaTag.portraits[key].extra_settings.enable
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].extra_settings.enable = value

							update()
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
							return not E.db.mMediaTag.portraits[key].extra_settings.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits[key].extra_settings.size
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].extra_settings.size = value
							update()
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
							return not E.db.mMediaTag.portraits[key].extra_settings.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits[key].extra_settings.offset.x
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].extra_settings.offset.x = value
							update()
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
							return not E.db.mMediaTag.portraits[key].extra_settings.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits[key].extra_settings.offset.y
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits[key].extra_settings.offset.y = value
							update()
						end,
					},
				},
			},
		},
	}

	if key == "player" then group.args.general_group.args.force_extra_toggle = nil end

	return group
end

mMT.options.args.unitframes.args.portraits.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.portraits.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.portraits.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.portraits.enable = value
			M.Portraits:Initialize()

			if value == false then E:StaticPopup_Show("CONFIG_RL") end
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
							return E.db.mMediaTag.portraits.misc.scale
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.scale = value
							M.Portraits:Initialize()
						end,
					},
					enable_force_desaturate = {
						order = 2,
						type = "toggle",
						name = L["Desaturate"],
						desc = L["Will always desaturate the portraits."],
						get = function(info)
							return E.db.mMediaTag.portraits.misc.desaturate
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.desaturate = value
							M.Portraits:Initialize()
						end,
					},
					enable_embellishment = {
						order = 3,
						type = "toggle",
						name = L["Embellishment"],
						desc = L["Will show the embellishment on the portraits, if the Style has an embellishment."],
						get = function(info)
							return E.db.mMediaTag.portraits.misc.embellishment
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.embellishment = value
							M.Portraits:Initialize()
						end,
					},
					texture_filter = {
						order = 4,
						type = "select",
						name = L["Texture Filter"],
						desc = L["Filter mode for the portrait textures. Trilinear also samples mipmaps, nearest disables smoothing. The unit portrait itself is not affected."],
						values = {
							LINEAR = L["Default"],
							TRILINEAR = L["Trilinear"],
							NEAREST = L["Nearest"],
						},
						get = function(info)
							return E.db.mMediaTag.portraits.misc.filter
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.filter = value
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
							return E.db.mMediaTag.portraits.shadow.enable
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.shadow.enable = value
							M.Portraits:Initialize()
						end,
					},
					alpha_range = {
						order = 2,
						name = L["Shadow Alpha"],
						type = "range",
						min = 0,
						max = 1,
						step = 0.01,
						get = function(info)
							return E.db.mMediaTag.portraits.shadow.alpha
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.shadow.alpha = value
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
						name = L["Class icon"],
						desc = L["Enable and select a class icon style for the portrait."],
						disabled = function()
							return E.db.mMediaTag.portraits.misc.spec_icon ~= "none"
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.misc.class_icon
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.class_icon = value
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
					spec_icon = {
						order = 2,
						type = "select",
						name = L["Spec icons"],
						desc = L["Enable and select a spec icon style for the portrait."],
						get = function(info)
							return E.db.mMediaTag.portraits.misc.spec_icon
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.spec_icon = value
							M.Portraits:Initialize()
						end,
						values = function()
							local t = {}
							for k, v in pairs(MEDIA.icons.spec.icons.mmt) do
								if type(v) == "table" then t[k] = v.name end
							end
							for k, v in pairs(MEDIA.icons.spec.icons.custom) do
								if type(v) == "table" then t[k] = v.name end
							end
							t.none = "None"
							t.blizzard = "Blizzard"
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
							return E.db.mMediaTag.portraits.bg.style
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.bg.style = value
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
							local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.misc.bg)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMediaTag.color.portraits.misc.bg = hex
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
							return E.db.mMediaTag.portraits.bg.classBG
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.bg.classBG = value
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
							return E.db.mMediaTag.portraits.bg.bgColorShift
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.bg.bgColorShift = value
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
							return E.db.mMediaTag.portraits.custom.enable
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.enable = value
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
							return not E.db.mMediaTag.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.texture
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.texture = value
							M.Portraits:Initialize()
						end,
					},
					mask_input = {
						order = 4,
						name = L["Mask"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMediaTag.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.mask
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.mask = value
							M.Portraits:Initialize()
						end,
					},
					extra_mask_input = {
						order = 5,
						name = L["Extra Mask"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMediaTag.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.extra_mask
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.extra_mask = value
							M.Portraits:Initialize()
						end,
					},
					shadow = {
						order = 6,
						name = L["Shadow"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMediaTag.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.shadow
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.shadow = value
							M.Portraits:Initialize()
						end,
					},
					extra_shadow = {
						order = 7,
						name = L["Extra Shadow"],
						type = "input",
						width = "small",
						disabled = function()
							return not E.db.mMediaTag.portraits.custom.enable
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.extra_shadow
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.extra_shadow = value
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
							return E.db.mMediaTag.portraits.custom.extra
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.extra = value
							M.Portraits:Initialize()
						end,
					},
					rare_input = {
						order = 10,
						name = L["Rare"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMediaTag.portraits.custom.enable and E.db.mMediaTag.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.rare
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.rare = value
							M.Portraits:Initialize()
						end,
					},
					elite_input = {
						order = 11,
						name = L["Elite"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMediaTag.portraits.custom.enable and E.db.mMediaTag.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.elite
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.elite = value
							M.Portraits:Initialize()
						end,
					},
					rareelite_input = {
						order = 12,
						name = L["Rare Elite"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMediaTag.portraits.custom.enable and E.db.mMediaTag.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.rareelite
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.rareelite = value
							M.Portraits:Initialize()
						end,
					},
					boss_input = {
						order = 13,
						name = L["Boss"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMediaTag.portraits.custom.enable and E.db.mMediaTag.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.boss
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.boss = value
							M.Portraits:Initialize()
						end,
					},
					player_input = {
						order = 14,
						name = L["Player"],
						type = "input",
						width = "small",
						disabled = function()
							return not (E.db.mMediaTag.portraits.custom.enable and E.db.mMediaTag.portraits.custom.extra)
						end,
						get = function(info)
							return E.db.mMediaTag.portraits.custom.player
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.custom.player = value
							M.Portraits:Initialize()
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
							return E.db.mMediaTag.portraits.misc.rare
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.rare = value
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
							return E.db.mMediaTag.portraits.misc.elite
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.elite = value
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
							return E.db.mMediaTag.portraits.misc.rareelite
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.rareelite = value
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
							return E.db.mMediaTag.portraits.misc.boss
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.boss = value
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
							return E.db.mMediaTag.portraits.misc.player
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.player = value
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
							return E.db.mMediaTag.portraits.misc.extratop
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.extratop = value
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
					E.db.mMediaTag.color.portraits.class = CopyTable(P.color.portraits.class)
					mMT:UpdateMedia("portraits")
					M.Portraits:Initialize()
				end,
			},
			reset_colors_execute = {
				order = 3,
				type = "execute",
				name = L["Reset all colors"],
				func = function()
					E.db.mMediaTag.color.portraits = CopyTable(P.color.portraits)
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
							return E.db.mMediaTag.portraits.misc.force_default
						end,
						set = function(info, value)
							E.db.mMediaTag.portraits.misc.force_default = value
							M.Portraits:Initialize()
						end,
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.misc.default.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.misc.default.c = hex
									MEDIA.color.portraits.misc.default.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.misc.default.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.misc.death.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.misc.death.c = hex
									MEDIA.color.portraits.misc.death.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.misc.death.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.DEATHKNIGHT.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.DEATHKNIGHT.c = hex
									MEDIA.color.portraits.class.DEATHKNIGHT.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DEATHKNIGHT.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.DEMONHUNTER.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.DEMONHUNTER.c = hex
									MEDIA.color.portraits.class.DEMONHUNTER.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DEMONHUNTER.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.DRUID.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.DRUID.c = hex
									MEDIA.color.portraits.class.DRUID.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.DRUID.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.EVOKER.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.EVOKER.c = hex
									MEDIA.color.portraits.class.EVOKER.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.EVOKER.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.HUNTER.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.HUNTER.c = hex
									MEDIA.color.portraits.class.HUNTER.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.HUNTER.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.MAGE.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.MAGE.c = hex
									MEDIA.color.portraits.class.MAGE.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.MAGE.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.MONK.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.MONK.c = hex
									MEDIA.color.portraits.class.MONK.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.MONK.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.PALADIN.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.PALADIN.c = hex
									MEDIA.color.portraits.class.PALADIN.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.PALADIN.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.PRIEST.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.PRIEST.c = hex
									MEDIA.color.portraits.class.PRIEST.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.PRIEST.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.ROGUE.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.ROGUE.c = hex
									MEDIA.color.portraits.class.ROGUE.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.ROGUE.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.SHAMAN.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.SHAMAN.c = hex
									MEDIA.color.portraits.class.SHAMAN.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.SHAMAN.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.WARLOCK.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.WARLOCK.c = hex
									MEDIA.color.portraits.class.WARLOCK.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.WARLOCK.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.class.WARRIOR.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.class.WARRIOR.c = hex
									MEDIA.color.portraits.class.WARRIOR.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.class.WARRIOR.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.classification.rare.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.classification.rare.c = hex
									MEDIA.color.portraits.classification.rare.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.rare.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.classification.elite.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.classification.elite.c = hex
									MEDIA.color.portraits.classification.elite.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.elite.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.classification.rareelite.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.classification.rareelite.c = hex
									MEDIA.color.portraits.classification.rareelite.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.rareelite.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.classification.boss.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.classification.boss.c = hex
									MEDIA.color.portraits.classification.boss.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.boss.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.classification.player.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.classification.player.c = hex
									MEDIA.color.portraits.classification.player.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.classification.player.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.reaction.enemy.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.reaction.enemy.c = hex
									MEDIA.color.portraits.reaction.enemy.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.enemy.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.reaction.neutral.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.reaction.neutral.c = hex
									MEDIA.color.portraits.reaction.neutral.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.neutral.c.hex = hex
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
									local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.portraits.reaction.friendly.c)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMediaTag.color.portraits.reaction.friendly.c = hex
									MEDIA.color.portraits.reaction.friendly.c = CreateColorFromHexString(hex)
									MEDIA.color.portraits.reaction.friendly.c.hex = hex
								end,
							},
						},
					},
				},
			},
		},
	},
	ring_group = {
		order = 13,
		type = "group",
		name = L["Ring"],
		desc = L["Shows health or the cast as a radial fill on the portrait border."],
		args = ringGroups,
	},
}

for index, unit in ipairs(portraitUnits) do
	mMT.options.args.unitframes.args.portraits.args[unit.key .. "_group"] = UnitGroup(unit, index + 2)
end
