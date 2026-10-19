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
	known = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Known Items"],
		disabled = function()
			return not Settings().enable
		end,
		args = {
			known = Toggle(1, "known", L["Enable"], L["Colors items at vendors that you already know."]),
			color = {
				order = 2,
				disabled = function()
					return not Settings().known
				end,
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
		},
	},
	transmog = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Uncollected Appearances"],
		disabled = function()
			return not Settings().enable
		end,
		args = {
			appearance = Toggle(1, "appearance", L["Enable"], L["Marks gear at vendors whose appearance you have not collected yet."]),
			appearanceColor = {
				order = 2,
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
			icon = {
				order = 3,
				type = "toggle",
				name = L["Appearance Icon"],
				desc = L["Shows a transmog icon on gear whose appearance you have not collected yet."],
				disabled = function()
					return not Settings().appearance
				end,
				get = function()
					return Settings().icon
				end,
				set = function(_, value)
					Settings().icon = value
					UpdateModule()
				end,
			},
		},
	},
	display = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Display"],
		disabled = function()
			return not Settings().enable
		end,
		args = {
			border = Toggle(1, "border", L["Border"], L["Colors the border of the item icon."]),
			tint = Toggle(2, "tint", L["Tint Icon and Background"], L["Tints the icon and the name background of the item."]),
		},
	},
}
