local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.nameplates.args.auto_friendly_nameplates.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.auto_friendly_nameplates.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Automatically shows friendly nameplates in dungeons and raids and hides them in the open world."],
		get = function()
			return E.db.mMediaTag.auto_friendly_nameplates.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.auto_friendly_nameplates.enable = value
			mMT:UpdateModule("AutoFriendlyNameplates")
		end,
	},
	settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Auto Friendly Nameplates"],
		args = {
			dungeon = {
				order = 1,
				type = "toggle",
				name = L["Dungeons"],
				desc = L["Show friendly nameplates in dungeons."],
				disabled = function()
					return not E.db.mMediaTag.auto_friendly_nameplates.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_friendly_nameplates.dungeon
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_friendly_nameplates.dungeon = value
					mMT:UpdateModule("AutoFriendlyNameplates")
				end,
			},
			raid = {
				order = 2,
				type = "toggle",
				name = L["Raids"],
				desc = L["Show friendly nameplates in raids."],
				disabled = function()
					return not E.db.mMediaTag.auto_friendly_nameplates.enable
				end,
				get = function()
					return E.db.mMediaTag.auto_friendly_nameplates.raid
				end,
				set = function(_, value)
					E.db.mMediaTag.auto_friendly_nameplates.raid = value
					mMT:UpdateModule("AutoFriendlyNameplates")
				end,
			},
		},
	},
}
