local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.comfort.args.tools.args.merchant_buy_max.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.merchant_buy_max.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Adds a Max button to the quantity window of stackable vendor items that buys as many as you can afford."],
		get = function()
			return E.db.mMediaTag.merchant_buy_max.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.merchant_buy_max.enable = value
			mMT:UpdateModule("MerchantBuyMax")
		end,
	},
	text = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Adds a Max button to the quantity window of stackable vendor items that buys as many as you can afford."],
	},
}
