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
				order = 7,
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
			auto_gossip = {
				order = 3,
				type = "toggle",
				name = L["Auto Gossip"],
				desc = L["Automatically clicks gossip options of the types selected below. If more than one option matches, the dialog stays open for you to choose."],
				disabled = function()
					return not E.db.mMediaTag.auto_quest.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.auto_gossip
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.auto_gossip = value
					mMT:UpdateModule("AutoQuest")
				end,
			},
			gossip_quest = {
				order = 4,
				type = "toggle",
				name = L["Quest Options"],
				desc = L["Selects gossip options that are marked with the (Quest) label."],
				disabled = function()
					return not (E.db.mMediaTag.auto_quest.enable and E.db.mMediaTag.auto_quest.auto_gossip)
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.gossip_quest
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.gossip_quest = value
					mMT:UpdateModule("AutoQuest")
				end,
			},
			gossip_movie = {
				order = 5,
				type = "toggle",
				name = L["Cinematic Options"],
				desc = L["Selects gossip options that start a cinematic."],
				disabled = function()
					return not (E.db.mMediaTag.auto_quest.enable and E.db.mMediaTag.auto_quest.auto_gossip)
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.gossip_movie
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.gossip_movie = value
					mMT:UpdateModule("AutoQuest")
				end,
			},
			gossip_single = {
				order = 6,
				type = "toggle",
				name = L["Single Option"],
				desc = L["Selects the option when an NPC offers only a single one. This also triggers on vendors, flight masters and trainers."],
				disabled = function()
					return not (E.db.mMediaTag.auto_quest.enable and E.db.mMediaTag.auto_quest.auto_gossip)
				end,
				get = function()
					return E.db.mMediaTag.auto_quest.gossip_single
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_quest.gossip_single = value
					mMT:UpdateModule("AutoQuest")
				end,
			},
			chat_message = {
				order = 8,
				type = "toggle",
				name = L["Chat Messages"],
				desc = L["Prints a message to chat whenever a quest is auto-accepted or turned in, or a gossip option is selected."],
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
