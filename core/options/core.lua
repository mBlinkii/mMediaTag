local mMT, E, L, V, P, G = unpack((select(2, ...)))

local  tinsert =  tinsert

local function configTable()
	E.Options.args.mMT = {
		type = "group",
		name = mMT.Icon .. " " .. mMT.Name,
		order = 6,
		args = {
			logo = {
				type = "description",
				name = "",
				order = 1,
				image = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_logo.tga", 512, 64 end,
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\general.tga",
				childGroups = "tab",
				args = {
					greeting = {
						order = 1,
						type = "group",
						name = L["Welcome text"],
						args = {},
					},
					roll = {
						order = 2,
						type = "group",
						name = L["Roll Button"],
						args = {},
					},
					chat = {
						order = 3,
						type = "group",
						name = L["Chat Button"],
						args = {},
					},
					keystochat = {
						order = 4,
						type = "group",
						name = L["Keyston to Chat"] .. " (!keys)",
						args = {},
					},
					instancedifficulty = {
						order = 5,
						type = "group",
						name = L["Instance Difficulty"],
						args = {},
					},
				},
			},
			datatexts = {
				order = 3,
				type = "group",
				name = L["DatatTexts"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\datatexts.tga",
				childGroups = "tab",
				args = {
					colors = {
						order = 1,
						type = "group",
						name = mMT.Name .. " " .. L["Datatext Colors"],
						args = {},
					},
					combat = {
						order = 2,
						type = "group",
						name = L["Combat Icon and Time"],
						args = {},
					},
					score = {
						order = 3,
						type = "group",
						name = L["M+ Score"],
						args = {},
					},
					teleports = {
						order = 4,
						type = "group",
						name = L["Teleports"],
						args = {},
					},
					profession = {
						order = 5,
						type = "group",
						name = L["Professions"],
						args = {},
					},
					dungeon = {
						order = 6,
						type = "group",
						name = L["Dungeon"],
						args = {},
					},
					gamemenu = {
						order = 7,
						type = "group",
						name = L["Game Menu"],
						args = {},
					},
				},
			},
			tags = {
				order = 4,
				type = "group",
				name = L["Tags"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\tags.tga",
				childGroups = "tab",
				args = {
					color = {
						order = 1,
						type = "group",
						name = L["Colors"],
						args = {},
					},
					icon = {
						order = 2,
						type = "group",
						name = L["Icons"],
						args = {},
					},
				},
			},
			dock = {
				order = 5,
				type = "group",
				name = L["Dock"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\dock.tga",
				childGroups = "tab",
				args = {
				},
			},
			castbar = {
				order = 6,
				type = "group",
				name = L["Castbar"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\castbar.tga",
				childGroups = "tab",
				args = {
				},
			},
			nameplates = {
				order = 7,
				type = "group",
				name = L["Nameplates"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\nameplates.tga",
				childGroups = "tab",
				args = {
					healthmarker = {
						order = 1,
						type = "group",
						name = L["Health markers"],
						args = {},
					},
					executemarker = {
						order = 2,
						type = "group",
						name = L["Execute markers"],
						args = {},
					},
					bordercolor = {
						order = 3,
						type = "group",
						name = L["Border Color"],
						args = {},
					},
				},
			},
			cosmetic = {
				order = 8,
				type = "group",
				name = L["Cosmetic"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\cosmetic.tga",
				childGroups = "tab",
				args = {
					tooltip = {
						order = 1,
						type = "group",
						name = L["Tooltip Icon"],
						args = {},
					},
					background = {
						order = 2,
						type = "group",
						name = L["Custom Unitframe Backgrounds"],
						args = {},
					},
					classcolor = {
						order = 3,
						type = "group",
						name = L["Custom Class colors"],
						args = {},
					},
					roleicons = {
						order = 4,
						type = "group",
						name = L["Role Icons"],
						args = {},
					},
					objectivetracker = {
						order = 5,
						type = "group",
						name = L["Objective Tracker"],
						childGroups = "tab",
						args = {},
					},
					textures = {
						order = 20,
						type = "group",
						name = L["Textures"],
						args = {},
					},
				},
			},
			about = {
				order = 9,
				type = "group",
				name = format("|CFF05E464%s|r", L["About"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\about.tga",
				childGroups = "tab",
				args = {
				},
			},
			setup = {
				order = 10,
				type = "group",
				name = format("|CFF0094FF%s|r", L["Setup"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\setup.tga",
				childGroups = "tab",
				args = {
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)