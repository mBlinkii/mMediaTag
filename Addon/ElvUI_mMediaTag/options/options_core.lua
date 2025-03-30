local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options = {
	name = MEDIA.icon16 .. mMT.Name,
	handler = mMT,
	type = "group",
	--childGroups = "tab",
	args = {
		logo = {
			type = "description",
			name = "",
			order = 1,
			image = function()
				return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo", 512, 64
			end,
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\general",
			childGroups = "tab",
			args = {
				greeting_message = {
					order = 1,
					type = "group",
					name = mMT:AddSettingsIcon(L["Greeting Message"], "greeting_message"),
					childGroups = "tab",
					args = {},
				},
				keystone_to_chat = {
					order = 2,
					type = "group",
					name = mMT:AddSettingsIcon(L["Keystone to Chat"], "keystone_to_chat"),
					childGroups = "tab",
					hidden = function()
						return not E.Retail
					end,
					args = {},
				},
			},
		},
		unitframes = {
			order = 3,
			type = "group",
			name = L["Unitframes"],
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\unitframes",
			childGroups = "tab",
			args = {},
		},
		nameplates = {
			order = 4,
			type = "group",
			name = L["Nameplates"],
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\nameplates",
			childGroups = "tab",
			args = {},
		},
		datatexts = {
			order = 5,
			type = "group",
			name = L["Datatexts"],
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\datatexts",
			childGroups = "tab",
			args = {
				general = {
					order = 1,
					type = "group",
					name = mMT:AddSettingsIcon(L["General"], "general"),
					childGroups = "tab",
					args = {},
				},
				info_score = {
					order = 2,
					type = "group",
					name = mMT:AddSettingsIcon(L["M+ Score"], "score"),
					childGroups = "tab",
					hidden = function()
						return not E.Retail
					end,
					args = {},
				},
				misc_teleports = {
					order = 3,
					type = "group",
					name = mMT:AddSettingsIcon(L["Teleports"], "teleports"),
					childGroups = "tab",
					hidden = function()
						return not E.Retail
					end,
					args = {},
				},
				misc_individual_professions = {
					order = 4,
					type = "group",
					name = mMT:AddSettingsIcon(L["Individual Professions"], "professions"),
					childGroups = "tab",
					args = {},
				},
				misc_professions = {
					order = 5,
					type = "group",
					name = mMT:AddSettingsIcon(L["Professions"], "professions"),
					childGroups = "tab",
					args = {},
				},
				misc_gamemenu = {
					order = 6,
					type = "group",
					name = mMT:AddSettingsIcon(L["Gamemenu"], "gamemenu"),
					childGroups = "tab",
					args = {},
				},
				misc_tracker = {
					order = 7,
					type = "group",
					name = mMT:AddSettingsIcon(L["Tracker"], "shop"),
					childGroups = "tab",
					args = {},
				},
				info_combat_time = {
					order = 8,
					type = "group",
					name = mMT:AddSettingsIcon(L["Combat/Arena Time"], "combat_time"),
					childGroups = "tab",
					args = {},
				},
			},
		},
		dock = {
			order = 6,
			type = "group",
			name = L["Dock"],
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\dock",
			childGroups = "tab",
			args = {},
		},
		tags = {
			order = 7,
			type = "group",
			name = L["TAGs"],
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\tags",
			childGroups = "tab",
			args = {},
		},
		misc = {
			order = 8,
			type = "group",
			name = L["Misc"],
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\misc",
			childGroups = "tab",
			args = {
				data_panel_skin = {
					order = 1,
					type = "group",
					name = mMT:AddSettingsIcon(L["Data Panel Skin"], "data_panel_skin"),
					childGroups = "tab",
					args = {},
				},
				dice_button = {
					order = 2,
					type = "group",
					name = mMT:AddSettingsIcon(L["Dice Button"], "dice_button"),
					childGroups = "tab",
					args = {},
				},
			},
		},
		about = {
			order = 9,
			type = "group",
			name = MEDIA.color.green:WrapTextInColorCode(L["About"]),
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\about",
			childGroups = "tab",
			args = {},
		},
		license = {
			order = 10,
			type = "group",
			name = MEDIA.color.yellow:WrapTextInColorCode(L["License"]),
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\license",
			childGroups = "tab",
			args = {},
		},
		changelog = {
			order = 11,
			type = "group",
			name = MEDIA.color.red:WrapTextInColorCode(L["Changelog"]),
			icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\log",
			childGroups = "select",
			args = {},
		},
	},
}
