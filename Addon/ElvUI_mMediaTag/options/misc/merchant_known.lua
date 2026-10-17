local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local function Settings()
	return E.db.mMediaTag.merchant_known
end

local function UpdateModule()
	mMT:UpdateModule("MerchantKnown")
end

local function Toggle(order, key, name, desc)
	return {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
		get = function()
			return Settings()[key]
		end,
		set = function(_, value)
			Settings()[key] = value
			UpdateModule()
		end,
	}
end

mMT.options.args.comfort.args.tools.args.merchant_known.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return Settings().enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Colors items at vendors that you already know and marks appearances you have not collected."],
		get = function()
			return Settings().enable
		end,
		set = function(_, value)
			Settings().enable = value
			UpdateModule()
		end,
	},
	settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = function()
			return not Settings().enable
		end,
		args = {
			color = {
				order = 1,
				type = "color",
				name = L["Known Items Color"],
				hasAlpha = false,
				get = function()
					local r, g, b = mMT:HexToRGB(Settings().color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					Settings().color = E:RGBToHex(r, g, b, "ff")
					UpdateModule()
				end,
			},
			appearance = Toggle(2, "appearance", L["Uncollected Appearances"], L["Marks gear at vendors whose appearance you have not collected yet."]),
			appearanceColor = {
				order = 3,
				type = "color",
				name = L["Appearance Color"],
				hasAlpha = false,
				disabled = function()
					return not Settings().appearance
				end,
				get = function()
					local r, g, b = mMT:HexToRGB(Settings().appearanceColor)
					return r, g, b
				end,
				set = function(_, r, g, b)
					Settings().appearanceColor = E:RGBToHex(r, g, b, "ff")
					UpdateModule()
				end,
			},
			border = Toggle(4, "border", L["Border"], L["Colors the border of the item icon."]),
			tint = Toggle(5, "tint", L["Tint Icon and Background"], L["Tints the icon and the name background of the item."]),
		},
	},
}
