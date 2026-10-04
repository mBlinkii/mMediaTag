local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.group.args.keystones.args.keystone_to_chat.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.keystone_to_chat.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Post your keystone to the chat when someone types !key or !keys into the chat."],
		get = function(info)
			return E.db.mMediaTag.keystone_to_chat.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.keystone_to_chat.enable = value
			mMT:UpdateModule("KeystoneToChat")
		end,
	},
	text = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Post your keystone to the chat when someone types !key or !keys into the chat."],
	},
}
