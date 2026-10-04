local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.interface.args.comfort.args.greeting_message.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.general.greeting_message and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Show a greeting message in the chat when you log in."],
		get = function(info)
			return E.db.mMediaTag.general.greeting_message
		end,
		set = function(info, value)
			E.db.mMediaTag.general.greeting_message = value
			mMT:UpdateModule("GreetingMessage")
		end,
	},
	text = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Show a greeting message in the chat when you log in."],
	},
}
