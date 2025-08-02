local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.unitframes.args.interrupt_on_cd.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMT.interrupt_on_cd.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMT.interrupt_on_cd.enable
		end,
		set = function(info, value)
			E.db.mMT.interrupt_on_cd.enable = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	settings_group = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			gradient = {
				order = 1,
				type = "toggle",
				name = L["Gradient Mode"],
				desc = L["Enable gradient mode for the castbar color."],
				get = function(info)
					return E.db.mMT.interrupt_on_cd.gradient
				end,
				set = function(info, value)
					E.db.mMT.interrupt_on_cd.gradient = value
					M.InterruptOnCD:Initialize()
				end,
			},
			out_of_range = {
				order = 2,
				type = "toggle",
				name = L["Out of Range"],
				desc = L["Enable out of range color for the castbar."],
				get = function(info)
					return E.db.mMT.interrupt_on_cd.out_of_range
				end,
				set = function(info, value)
					E.db.mMT.interrupt_on_cd.out_of_range = value
					M.InterruptOnCD:Initialize()
				end,
			},
			set_bg_color = {
				order = 3,
				type = "toggle",
				name = L["Change BG color"],
				desc = L["Enable to change the background color of the castbar."],
				get = function(info)
					return E.db.mMT.interrupt_on_cd.set_bg_color
				end,
				set = function(info, value)
					E.db.mMT.interrupt_on_cd.set_bg_color = value
					M.InterruptOnCD:Initialize()
				end,
			},
			bg_multiplier = {
				order = 4,
				name = L["Background Multiplier"],
				desc = L["Set the background color multiplier for the castbar."],
				type = "range",
				min = 0,
				max = 1,
				step = 0.01,
				disabled = function()
					return not E.db.mMT.interrupt_on_cd.set_bg_color
				end,
				get = function(info)
					return E.db.mMT.interrupt_on_cd.bg_multiplier
				end,
				set = function(info, value)
					E.db.mMT.interrupt_on_cd.bg_multiplier = value
					M.InterruptOnCD:Initialize()
				end,
			},
			inactive_time = {
				order = 5,
				name = L["Inactive Time"],
				desc = L["Set the inactive time for the interrupt on CD highlighter."],
				type = "range",
				min = 0,
				max = 1,
				step = 0.01,
				get = function(info)
					return E.db.mMT.interrupt_on_cd.inactive_time
				end,
				set = function(info, value)
					E.db.mMT.interrupt_on_cd.inactive_time = value
					M.InterruptOnCD:Initialize()
				end,
			},
		},
	},
	colors = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Colors"],
		args = {
			on_cd = {
				order = 1,
				type = "group",
				inline = true,
				name = L["On CD"],
				desc = L["The interrupt spell is on Cooldown."],
				args = {
					color_a = {
						type = "color",
						order = 1,
						name = "A",
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.interrupt_on_cd.onCD.c)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.interrupt_on_cd.onCD.c = hex
							MEDIA.color.interrupt_on_cd.onCD.c = CreateColorFromHexString(hex)
							MEDIA.color.interrupt_on_cd.onCD.c.hex = hex
						end,
					},
					color_b = {
						type = "color",
						order = 2,
						name = "B",
						disabled = function()
							return not E.db.mMT.interrupt_on_cd.gradient
						end,
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.interrupt_on_cd.onCD.g)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.interrupt_on_cd.onCD.g = hex
							MEDIA.color.interrupt_on_cd.onCD.g = CreateColorFromHexString(hex)
							MEDIA.color.interrupt_on_cd.onCD.g.hex = hex
						end,
					},
				},
			},
			in_time = {
				order = 2,
				type = "group",
				inline = true,
				name = L["In Time"],
				desc = L["The interrupt spell will be ready to use in time."],
				args = {
					color_a = {
						type = "color",
						order = 1,
						name = "A",
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.interrupt_on_cd.inTime.c)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.interrupt_on_cd.inTime.c = hex
							MEDIA.color.interrupt_on_cd.inTime.c = CreateColorFromHexString(hex)
							MEDIA.color.interrupt_on_cd.inTime.c.hex = hex
						end,
					},
					color_b = {
						type = "color",
						order = 2,
						name = "B",
						disabled = function()
							return not E.db.mMT.interrupt_on_cd.gradient
						end,
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.interrupt_on_cd.inTime.g)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.interrupt_on_cd.inTime.g = hex
							MEDIA.color.interrupt_on_cd.inTime.g = CreateColorFromHexString(hex)
							MEDIA.color.interrupt_on_cd.inTime.g.hex = hex
						end,
					},
				},
			},
			out_of_range = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Out of Range"],
				desc = L["The interrupt spell is out of range."],
				disabled = function()
					return not E.db.mMT.interrupt_on_cd.out_of_range
				end,
				args = {
					color_a = {
						type = "color",
						order = 1,
						name = "A",
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.interrupt_on_cd.outOfRange.c)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.interrupt_on_cd.outOfRange.c = hex
							MEDIA.color.interrupt_on_cd.outOfRange.c = CreateColorFromHexString(hex)
							MEDIA.color.interrupt_on_cd.outOfRange.c.hex = hex
						end,
					},
					color_b = {
						type = "color",
						order = 2,
						name = "B",
						disabled = function()
							return not (E.db.mMT.interrupt_on_cd.gradient or E.db.mMT.interrupt_on_cd.out_of_range)
						end,
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.interrupt_on_cd.outOfRange.g)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.interrupt_on_cd.outOfRange.g = hex
							MEDIA.color.interrupt_on_cd.outOfRange.g = CreateColorFromHexString(hex)
							MEDIA.color.interrupt_on_cd.outOfRange.g.hex = hex
						end,
					},
				},
			},
			marker = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Marker"],
				desc = L["The marker color for in time interrupts."],
				args = {
					color = {
						order = 1,
						type = "color",
						name = L["Color"],
						desc = L["The marker color for in time interrupts."],
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.interrupt_on_cd.marker)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.interrupt_on_cd.marker = hex
							MEDIA.color.interrupt_on_cd.marker = CreateColorFromHexString(hex)
							MEDIA.color.interrupt_on_cd.marker.hex = hex
						end,
					},
				},
			},
		},
	},
}
