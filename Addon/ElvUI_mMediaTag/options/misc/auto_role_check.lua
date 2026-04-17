local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.misc.args.auto_role_check.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.auto_role_check.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return E.db.mMediaTag.auto_role_check.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.auto_role_check.enable = value

			if value then
				mMT:UpdateModule("AutoRoleCheck")
			else
				E:StaticPopup_Show("CONFIG_RL")
			end
		end,
	},
	settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Auto Role Check"],
		args = {
			accept_lfd = {
				order = 1,
				type = "toggle",
				name = L["Auto Accept"],
				desc = L["Automatically accepts the dungeon or raid role check popup."],
				disabled = function()
					return not E.db.mMediaTag.auto_role_check.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_role_check.accept_lfd
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_role_check.accept_lfd = value
				end,
			},
			accept_premade = {
				order = 2,
				type = "toggle",
				name = L["Auto Sign Up"],
				desc = L["Automatically signs up for premade groups when your role is already selected."],
				disabled = function()
					return not E.db.mMediaTag.auto_role_check.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_role_check.accept_premade
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_role_check.accept_premade = value
				end,
			},
		},
	},
}
