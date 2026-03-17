local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.misc.args.details.args = {
	mode = {
		order = 1,
		type = "select",
		name = L["Embedded to Chat"],
		desc = L["Details embeded"],
		get = function()
			return E.db.mMediaTag.details.mode
		end,
		set = function(_, value)
			E.db.mMediaTag.details.mode = value
			mMT:UpdateModule("DetailsEmbedded")
			E:StaticPopup_Show("CONFIG_RL")
		end,
		values = {
			DISABLE = MEDIA.color.red:WrapTextInColorCode(L["Disabled"]),
			LeftChat = L["Left Chat"],
			RightChat = L["Right Chat"],
		},
	},
	embedded_settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Embedded Settings"],
		disabled = function()
			return E.db.mMediaTag.details.mode == "DISABLE"
		end,
		args = {
			windows = {
				order = 1,
				type = "range",
				name = L["Details Windows"],
				desc = L["Details Windows"],
				min = 1,
				max = 4,
				step = 1,
				softMin = 1,
				softMax = 4,
				get = function()
					return E.db.mMediaTag.details.windows
				end,
				set = function(_, value)
					E.db.mMediaTag.details.windows = value
					mMT:UpdateModule("DetailsEmbedded")
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
			spacer1 = {
				order = 2,
				type = "description",
				name = "",
				width = "full",
			},
			toggle = {
				order = 3,
				type = "toggle",
				name = L["Toggle Button"],
				desc = L["Adds a button to show or hide details on click. The button is only visible on mouse over."],
				get = function()
					return E.db.mMediaTag.details.toggle
				end,
				set = function(_, value)
					E.db.mMediaTag.details.toggle = value
					mMT:UpdateModule("DetailsEmbedded")
				end,
			},
		},
	},
}
