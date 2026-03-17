local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.misc.args.auto_quest.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.auto_quest.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return E.db.mMediaTag.auto_quest.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.auto_quest.enable = value
			mMT:UpdateModule("AutoQuest")
			if not value then E:StaticPopup_Show("CONFIG_RL") end
		end,
	},

	header_settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Auto Quest"],
		args = {
			auto_accept = {
				order = 1,
				type = "toggle",
				name = L["Auto Accept"],
				desc = L["Automatically accepts quest dialogs from NPCs."],
				disabled = function()
					return not E.db.mMediaTag.auto_quest.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.auto_accept
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.auto_accept = value
					mMT:UpdateModule("AutoQuest")
				end,
			},
			auto_turnin = {
				order = 2,
				type = "toggle",
				name = L["Auto Turn-In"],
				desc = L["Automatically turns in completed quests. If the quest has multiple reward choices, the dialog stays open for you to choose."],
				disabled = function()
					return not E.db.mMediaTag.auto_quest.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.auto_turnin
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.auto_turnin = value
					mMT:UpdateModule("AutoQuest")
				end,
			},
			skip_in_combat = {
				order = 3,
				type = "toggle",
				name = L["Skip in Combat"],
				desc = L["Disables auto accept/turn-in while you are in combat."],
				disabled = function()
					return not E.db.mMediaTag.auto_quest.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.skip_in_combat
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.skip_in_combat = value
				end,
			},
			chat_message = {
				order = 4,
				type = "toggle",
				name = L["Chat Messages"],
				desc = L["Prints a message to chat whenever a quest is auto-accepted or turned in."],
				disabled = function()
					return not E.db.mMediaTag.auto_quest.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.chat_message
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.chat_message = value
				end,
			},
		},
	},
}
