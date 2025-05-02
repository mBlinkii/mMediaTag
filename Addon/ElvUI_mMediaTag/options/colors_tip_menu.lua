local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.colors.args.tip_menu.args = {
	color_title = {
		order = 1,
		type = "color",
		name = L["Title"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.color.title)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.color.title = hex
			MEDIA.color.title = CreateColorFromHexString(hex)
			MEDIA.color.title.hex = hex
		end,
	},
	color_text = {
		order = 2,
		type = "color",
		name = L["Text"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.color.text)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.color.text = hex
			MEDIA.color.text = CreateColorFromHexString(hex)
			MEDIA.color.text.hex = hex
		end,
	},
	color_tip = {
		order = 3,
		type = "color",
		name = L["Tip"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.color.tip)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.color.tip = hex
			MEDIA.color.tip = CreateColorFromHexString(hex)
			MEDIA.color.tip.hex = hex
		end,
	},
	color_mark = {
		order = 4,
		type = "color",
		name = L["Mark"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.color.mark)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.color.mark = hex
			MEDIA.color.mark = CreateColorFromHexString(hex)
			MEDIA.color.mark.hex = hex
		end,
	},
}
