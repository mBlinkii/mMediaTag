local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.comfort.args.tools.args.merchant_grid.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.merchant_grid.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Shows 20 vendor items per page in four columns instead of ten in two."],
		get = function()
			return E.db.mMediaTag.merchant_grid.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.merchant_grid.enable = value
			mMT:UpdateModule("MerchantGrid")
		end,
	},
	text = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Shows 20 vendor items per page in four columns instead of ten in two."],
	},
}
