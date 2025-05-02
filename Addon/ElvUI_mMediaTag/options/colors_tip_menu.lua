local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.colors.args.tip_menu.args = {
	color_title = {
		order = 1,
		type = "color",
		name = L["Title"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.menu.title)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.menu.title = hex
			COLORS.menu.title = CreateColorFromHexString(hex)
			COLORS.menu.title.hex = hex
		end,
	},
	color_text = {
		order = 2,
		type = "color",
		name = L["Text"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.menu.text)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.menu.text = hex
			COLORS.menu.text = CreateColorFromHexString(hex)
			COLORS.menu.text.hex = hex
		end,
	},
	color_tip = {
		order = 3,
		type = "color",
		name = L["Tip"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.menu.tip)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.menu.tip = hex
			COLORS.menu.tip = CreateColorFromHexString(hex)
			COLORS.menu.tip.hex = hex
		end,
	},
	color_mark = {
		order = 4,
		type = "color",
		name = L["Mark"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.menu.mark)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.menu.mark = hex
			COLORS.menu.mark = CreateColorFromHexString(hex)
			COLORS.menu.mark.hex = hex
		end,
	},
}
