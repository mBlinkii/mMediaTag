local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.group.args.premade_filter.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.premade_filter.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return E.db.mMediaTag.premade_filter.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.premade_filter.enable = value
			mMT:UpdateModule("PremadeFilter")
		end,
	},
	settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = function()
			return not E.db.mMediaTag.premade_filter.enable
		end,
		args = {
			leader_score = {
				order = 1,
				type = "toggle",
				name = L["Show Leader Score"],
				desc = L["Shows the Mythic+ score of the group leader in the group finder list."],
				get = function()
					return E.db.mMediaTag.premade_filter.leader_score
				end,
				set = function(_, value)
					E.db.mMediaTag.premade_filter.leader_score = value
					mMT:UpdateModule("PremadeFilter")
				end,
			},
			short_difficulty = {
				order = 2,
				type = "toggle",
				name = L["Short Difficulty"],
				desc = L["Shortens the difficulty behind the dungeon name to M+, M, HC or NHC in its difficulty color."],
				get = function()
					return E.db.mMediaTag.premade_filter.short_difficulty
				end,
				set = function(_, value)
					E.db.mMediaTag.premade_filter.short_difficulty = value
					mMT:UpdateModule("PremadeFilter")
				end,
			},
			applied = {
				order = 3,
				type = "color",
				name = L["Applied Color"],
				hasAlpha = false,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.premade_filter.colors.applied)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.premade_filter.colors.applied = E:RGBToHex(r, g, b, "ff")
					mMT:UpdateModule("PremadeFilter")
				end,
			},
			declined = {
				order = 4,
				type = "color",
				name = L["Declined Color"],
				hasAlpha = false,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.premade_filter.colors.declined)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.premade_filter.colors.declined = E:RGBToHex(r, g, b, "ff")
					mMT:UpdateModule("PremadeFilter")
				end,
			},
			full = {
				order = 5,
				type = "color",
				name = L["Full Color"],
				hasAlpha = false,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.premade_filter.colors.full)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.premade_filter.colors.full = E:RGBToHex(r, g, b, "ff")
					mMT:UpdateModule("PremadeFilter")
				end,
			},
			columns = {
				order = 6,
				type = "select",
				name = L["Dungeon Columns"],
				desc = L["The number of columns of the dungeon list."],
				values = { [2] = "2", [3] = "3", [4] = "4" },
				get = function()
					return E.db.mMediaTag.premade_filter.columns
				end,
				set = function(_, value)
					E.db.mMediaTag.premade_filter.columns = value
					mMT:UpdateModule("PremadeFilter")
				end,
			},
		},
	},
}
