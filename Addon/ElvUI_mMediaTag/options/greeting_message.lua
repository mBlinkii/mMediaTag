local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.general.args.greeting_message.args = {
	text = {
		order = 1,
		type = "description",
		fontSize = "medium",
		name = L["Show a greeting message in the chat when you log in."],
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
			return E.db.mMT.greeting_message and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Show a greeting message in the chat when you log in."],
		get = function(info)
			return E.db.mMT.greeting_message
		end,
		set = function(info, value)
			E.db.mMT.greeting_message = value
		end,
	},
}
