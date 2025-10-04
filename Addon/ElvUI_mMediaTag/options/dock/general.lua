local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local LSM = LibStub("LibSharedMedia-3.0")
local DT = E:GetModule("DataTexts")

mMT.options.args.dock.args.general.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			tooltip = {
				order = 1,
				type = "toggle",
				name = L["Tooltip"],
				desc = L["Show a tooltip when you hover over the icon."],
				get = function(info)
					return E.db.mMT.dock.tooltip
				end,
				set = function(info, value)
					E.db.mMT.dock.tooltip = value
				end,
			},
			auto_grow = {
				order = 2,
				type = "toggle",
				name = L["Auto grow"],
				desc = L["Automatically adjust the growth size based on the icon size. When you hover over the icon."],
				get = function(info)
					return E.db.mMT.dock.auto_grow
				end,
				set = function(info, value)
					E.db.mMT.dock.auto_grow = value
				end,
			},
			grow_size = {
				order = 3,
				type = "range",
				name = L["Growth size"],
				desc = L["Set the growth size of the dock icon. This is the distance between the icons."],
				min = 0,
				max = 256,
				step = 1,
				disabled = function()
					return E.db.mMT.dock.auto_grow
				end,
				get = function(info)
					return E.db.mMT.dock.grow_size
				end,
				set = function(info, value)
					E.db.mMT.dock.grow_size = value
				end,
			},
		},
	},
	font = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Font"],
		args = {
			font = {
				order = 1,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				desc = L["Set the font for dock text."],
				values = LSM:HashTable("font"),
				get = function(info)
					return E.db.mMT.dock.font.font
				end,
				set = function(info, value)
					E.db.mMT.dock.font.font = value
					DT:LoadDataTexts()
				end,
			},
			custom_font_size = {
				order = 2,
				type = "toggle",
				name = L["Custom Font Size"],
				desc = L["Use a custom font size for dock text. If disabled, the font size will be set to one third of the icon size."],
				get = function(info)
					return E.db.mMT.dock.font.custom_font_size
				end,
				set = function(info, value)
					E.db.mMT.dock.font.custom_font_size = value
					DT:LoadDataTexts()
				end,
			},
			fontSize = {
				order = 3,
				type = "range",
				name = L["Font Size"],
				desc = L["Set the font size for dock text."],
				min = 6,
				max = 32,
				step = 1,
				disabled = function()
					return not E.db.mMT.dock.font.custom_font_size
				end,
				get = function(info)
					return E.db.mMT.dock.font.fontSize
				end,
				set = function(info, value)
					E.db.mMT.dock.font.fontSize = value
					DT:LoadDataTexts()
				end,
			},
			fontFlag = {
				order = 4,
				type = "select",
				name = L["Font Outline"],
				desc = L["Set the font outline for dock text."],
				get = function(info)
					return E.db.mMT.dock.font.fontFlag
				end,
				set = function(info, value)
					E.db.mMT.dock.font.fontFlag = value
					DT:LoadDataTexts()
				end,
				values = {
					NONE = "None",
					OUTLINE = "Outline",
					THICKOUTLINE = "Thick",
					SHADOW = "|cff888888Shadow|r",
					SHADOWOUTLINE = "|cff888888Shadow|r Outline",
					SHADOWTHICKOUTLINE = "|cff888888Shadow|r Thick",
					MONOCHROME = "|cFFAAAAAAMono|r",
					MONOCHROMEOUTLINE = "|cFFAAAAAAMono|r Outline",
					MONOCHROMETHICKOUTLINE = "|cFFAAAAAAMono|r Thick",
				},
			},
			custom_font_color = {
				order = 5,
				type = "toggle",
				name = L["Custom"],
				desc = L["Use a custom color for dock text. If disabled, the font color will be class colored."],
				get = function(info)
					return E.db.mMT.dock.font.custom_font_color
				end,
				set = function(info, value)
					E.db.mMT.dock.font.custom_font_color = value
					DT:LoadDataTexts()
				end,
			},
			font_color = {
				type = "color",
				order = 6,
				name = L["Font Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.dock.font.custom_font_color
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.color.dock.font)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.color.dock.font = hex
					MEDIA.color.dock.font = CreateColorFromHexString(hex)
					MEDIA.color.dock.font.hex = hex
					DT:LoadDataTexts()
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
			normal = {
				type = "color",
				order = 1,
				name = L["Normal"],
				desc = L["Set the normal color of the icon."],
				hasAlpha = true,
				disabled = function()
					return E.db.mMT.dock.class.normal
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMT.color.dock.normal)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMT.color.dock.normal = hex
					MEDIA.color.dock.normal = CreateColorFromHexString(hex)
					DT:LoadDataTexts()
				end,
			},
			class_normal = {
				order = 2,
				type = "toggle",
				name = L["Class Color"],
				desc = L["Use class color for the icon."],
				get = function(info)
					return E.db.mMT.dock.class.normal
				end,
				set = function(info, value)
					E.db.mMT.dock.class.normal = value
					DT:LoadDataTexts()
				end,
			},
			spacer1 = {
				order = 3,
				type = "description",
				fontSize = "medium",
				name = "\n",
			},
			hover = {
				type = "color",
				order = 4,
				name = L["Hover"],
				desc = L["Set the hover color of the icon."],
				hasAlpha = true,
				disabled = function()
					return E.db.mMT.dock.class.hover
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMT.color.dock.hover)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMT.color.dock.hover = hex
					MEDIA.color.dock.hover = CreateColorFromHexString(hex)
					DT:LoadDataTexts()
				end,
			},
			class_hover = {
				order = 5,
				type = "toggle",
				name = L["Class Color"],
				desc = L["Use class color for the icon."],
				get = function(info)
					return E.db.mMT.dock.class.hover
				end,
				set = function(info, value)
					E.db.mMT.dock.class.hover = value
					DT:LoadDataTexts()
				end,
			},
			spacer2 = {
				order = 6,
				type = "description",
				fontSize = "medium",
				name = "\n",
			},
			clicked = {
				type = "color",
				order = 7,
				name = L["Clicked"],
				desc = L["Set the clicked color of the icon."],
				hasAlpha = true,
				disabled = function()
					return E.db.mMT.dock.class.clicked
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMT.color.dock.clicked)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMT.color.dock.clicked = hex
					MEDIA.color.dock.clicked = CreateColorFromHexString(hex)
					DT:LoadDataTexts()
				end,
			},
			class_clicked = {
				order = 8,
				type = "toggle",
				name = L["Class Color"],
				desc = L["Use class color for the icon."],
				get = function(info)
					return E.db.mMT.dock.class.clicked
				end,
				set = function(info, value)
					E.db.mMT.dock.class.clicked = value
					DT:LoadDataTexts()
				end,
			},
		},
	},
}
