local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

mMT.options.args.misc.args.dice_button.args = {
    enable = {
        order = 1,
        type = "toggle",
        name = function()
            return E.db.mMT.dice_button.enable and COLORS.green:WrapTextInColorCode(L["Enabled"]) or COLORS.red:WrapTextInColorCode(L["Disabled"])
        end,
        get = function(info)
            return E.db.mMT.dice_button.enable
        end,
        set = function(info, value)
            E.db.mMT.dice_button.enable = value
            mMT:UpdateModule("DiceButton")
        end,
    },
	header_dice = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Dice Button"],
		args = {
			left_click = {
				order = 1,
				type = "select",
				name = L["Left Click"],
				disabled = function()
					return not E.db.mMT.dice_button.enable
				end,
				get = function(info)
					return E.db.mMT.dice_button.dice_range_a
				end,
				set = function(info, value)
					E.db.mMT.dice_button.dice_range_a = value
					mMT:UpdateModule("DiceButton")
				end,
				values = {
					[10] = "10",
					[25] = "25",
					[50] = "50",
					[75] = "75",
					[99] = "99",
					[100] = "100",
					[200] = "200",
					[1000] = "1000",
				},
			},
			right_click = {
				order = 2,
				type = "select",
				name = L["Right Click"],
				disabled = function()
					return not E.db.mMT.dice_button.enable
				end,
				get = function(info)
					return E.db.mMT.dice_button.dice_range_b
				end,
				set = function(info, value)
					E.db.mMT.dice_button.dice_range_b = value
					mMT:UpdateModule("DiceButton")
				end,
				values = {
					[10] = "10",
					[25] = "25",
					[50] = "50",
					[75] = "75",
					[99] = "99",
					[100] = "100",
					[200] = "200",
					[1000] = "1000",
				},
			},
		},
	},
	header_icon = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Icon"],
		args = {
			icon = {
				order = 4,
				type = "select",
				name = L["Icon"],
				disabled = function()
					return not E.db.mMT.dice_button.enable
				end,
				get = function(info)
					return E.db.mMT.dice_button.texture
				end,
				set = function(info, value)
					E.db.mMT.dice_button.texture = value
					mMT:UpdateModule("DiceButton")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.dice) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
			size = {
				order = 5,
				name = L["Icon Size"],
				type = "range",
				min = 2,
				max = 128,
				step = 2,
				softMin = 2,
				softMax = 128,
				disabled = function()
					return not E.db.mMT.dice_button.enable
				end,
				get = function(info)
					return E.db.mMT.dice_button.size
				end,
				set = function(info, value)
					E.db.mMT.dice_button.size = value
					mMT:UpdateModule("DiceButton")
				end,
			},
		},
	},
	header_color_normal = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Color Normal"],
		args = {
			mode = {
				order = 7,
				type = "select",
				name = L["Color Style"],
				get = function(info)
					return E.db.mMT.dice_button.color.normal.mode
				end,
				set = function(info, value)
					E.db.mMT.dice_button.color.normal.mode = value
					mMT:UpdateModule("DiceButton")
				end,
				disabled = function()
					return not E.db.mMT.dice_button.enable
				end,
				values = {
					class = L["Class"],
					custom = L["Custom"],
				},
			},
			color = {
				type = "color",
				order = 8,
				name = L["Custom color"],
				hasAlpha = true,
				disabled = function()
					return E.db.mMT.dice_button.color.normal.mode == "class"
				end,
				get = function(info)
					local t = E.db.mMT.dice_button.color.normal.color
					return t.r, t.g, t.b, t.a
				end,
				set = function(info, r, g, b, a)
					local t = E.db.mMT.dice_button.color.normal.color
					t.r, t.g, t.b, t.a = r, g, b, a
					mMT:UpdateModule("DiceButton")
				end,
			},
		},
	},
	header_color_hover = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Color Hover"],
		args = {
			mode = {
				order = 10,
				type = "select",
				name = L["Hover Color Style"],
				disabled = function()
					return not E.db.mMT.dice_button.enable
				end,
				get = function(info)
					return E.db.mMT.dice_button.color.hover.mode
				end,
				set = function(info, value)
					E.db.mMT.dice_button.color.hover.mode = value
					mMT:UpdateModule("DiceButton")
				end,
				values = {
					class = L["Class"],
					custom = L["Custom"],
				},
			},
			color = {
				type = "color",
				order = 11,
				name = L["Hover Custom Color"],
				hasAlpha = true,
				disabled = function()
					return E.db.mMT.dice_button.color.hover.mode == "class"
				end,
				get = function(info)
					local t = E.db.mMT.dice_button.color.hover.color
					return t.r, t.g, t.b, t.a
				end,
				set = function(info, r, g, b, a)
					local t = E.db.mMT.dice_button.color.hover.color
					t.r, t.g, t.b, t.a = r, g, b, a
					mMT:UpdateModule("DiceButton")
				end,
			},
		},
	},
}
