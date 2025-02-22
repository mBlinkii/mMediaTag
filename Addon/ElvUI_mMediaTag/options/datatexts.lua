local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.general.args = {
	text_color = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Text Color"],
		args = {
			override_text_color = {
				order = 1,
				type = "toggle",
				name = L["Override Text Color"],
				get = function(info)
					return E.db.mMT.datatexts.text.override_color
				end,
				set = function(info, value)
					E.db.mMT.datatexts.text.override_color = value
					DT:ForceUpdate_DataText("mMT - Teleports")
					DT:ForceUpdate_DataText("mMT - M+ Score")
				end,
			},
			color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.datatexts.text.override_color
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.text.color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.datatexts.text.color = hex
					MEDIA.color.override = CreateColorFromHexString(hex)
					MEDIA.color.override.hex = hex
					DT:ForceUpdate_DataText("mMT - Teleports")
					DT:ForceUpdate_DataText("mMT - M+ Score")
				end,
			},
		},
	},
	colors = {
		order = 2,
		type = "group",
		inline = true,
		name = L["colors"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["These colors are used for the tooltips of the datatexts."],
			},
			color_title = {
				order = 2,
				type = "color",
				name = L["Title"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.title)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.media.color.title = hex
					MEDIA.color.title = CreateColorFromHexString(hex)
					MEDIA.color.title.hex = hex
				end,
			},
			color_text = {
				order = 3,
				type = "color",
				name = L["Text"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.text)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.media.color.text = hex
					MEDIA.color.text = CreateColorFromHexString(hex)
					MEDIA.color.text.hex = hex
				end,
			},
			color_tip = {
				order = 4,
				type = "color",
				name = L["Tip"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.tip)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.media.color.tip = hex
					MEDIA.color.tip = CreateColorFromHexString(hex)
					MEDIA.color.tip.hex = hex
				end,
			},
			color_mark = {
				order = 5,
				type = "color",
				name = L["Mark"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.mark)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.media.color.mark = hex
					MEDIA.color.mark = CreateColorFromHexString(hex)
					MEDIA.color.mark.hex = hex
				end,
			},
		},
	},
}
