local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

mMT.options.args.general.args.keystone_to_chat.args = {
	text = {
		order = 1,
		type = "description",
		fontSize = "medium",
		name = L["Post your keystone to the chat when someone types !key or !keys into the chat."],
	},
	spacer = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = "\n",
	},
	enable = {
		order = 3,
		type = "toggle",
		name = function()
			return E.db.mMT.keystone_to_chat.enable and COLORS.green:WrapTextInColorCode(L["Enabled"]) or COLORS.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Post your keystone to the chat when someone types !key or !keys into the chat."],
		get = function(info)
			return E.db.mMT.keystone_to_chat.enable
		end,
		set = function(info, value)
			E.db.mMT.keystone_to_chat.enable = value
			mMT:UpdateModule("KeystoneToChat")
		end,
	},
}
