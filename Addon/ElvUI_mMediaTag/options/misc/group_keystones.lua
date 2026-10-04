local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.group.args.keystones.args.group_keystones.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.group_keystones.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.group_keystones.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.group_keystones.enable = value
			mMT:UpdateModule("GroupKeystones")
		end,
	},
	text = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Shows the keystones of your group next to the group finder listing."],
	},
	info = {
		order = 3,
		type = "description",
		fontSize = "medium",
		name = "\n" .. L["The keystones of your group members need Details! or BigWigs."] .. "\n\n",
	},
}
