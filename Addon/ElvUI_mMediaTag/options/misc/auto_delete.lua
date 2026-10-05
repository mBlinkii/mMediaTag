local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.interface.args.comfort.args.auto_delete.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.auto_delete.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Fills in the confirmation word automatically when you delete an item."],
		get = function()
			return E.db.mMediaTag.auto_delete.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.auto_delete.enable = value
			mMT:UpdateModule("AutoDelete")
		end,
	},
	text = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Fills in the confirmation word automatically when you delete an item."],
	},
}
