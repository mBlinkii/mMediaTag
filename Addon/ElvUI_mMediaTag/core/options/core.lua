local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

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
				image = function()
					return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_logo.tga", 512, 64
				end,
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\general.tga",
				childGroups = "tab",
				args = {
					general = {
						order = 1,
						type = "group",
						name = L["General"],
						args = {},
					},
					greeting = {
						order = 2,
						type = "group",
						name = L["Welcome text"],
						args = {},
					},
					roll = {
						order = 3,
						type = "group",
						name = L["Roll Button"],
						args = {},
					},
					keystochat = {
						order = 5,
						type = "group",
						name = L["Keystone to Chat"] .. " (!keys)",
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					instancedifficulty = {
						order = 6,
						type = "group",
						name = L["Instance Difficulty"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					afk = {
						order = 7,
						type = "group",
						name = L["AFK Screen"],
						args = {},
					},
				},
			},
			datatexts = {
				order = 3,
				type = "group",
				name = L["DataTexts"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\datatexts.tga",
				childGroups = "tab",
				args = {
					settings = {
						order = 1,
						type = "group",
						name = L["Datatext Settings"],
						childGroups = "tab",
						args = {
							colors = {
								order = 1,
								type = "group",
								name = L["Datatext Colors"],
								args = {},
							},
							font = {
								order = 1,
								type = "group",
								name = L["Font"],
								args = {},
							},
						},
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
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					teleports = {
						order = 4,
						type = "group",
						name = L["Teleports"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					profession = {
						order = 5,
						type = "group",
						name = L["Professions"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					dungeon = {
						order = 6,
						type = "group",
						name = L["Dungeon"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					gamemenu = {
						order = 7,
						type = "group",
						name = L["Game Menu"],
						args = {},
					},
					currency = {
						order = 7,
						type = "group",
						name = L["Currency"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					firstandsecondprofession = {
						order = 8,
						type = "group",
						name = L["First and Second Profession"],
						args = {},
					},
					durabilityanditemlevel = {
						order = 9,
						type = "group",
						name = L["Durability and Item Level"],
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
				args = {},
			},
			castbar = {
				order = 6,
				type = "group",
				name = L["Castbar"],
				hidden = function()
					return not (E.Retail or E.Cata)
				end,
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\castbar.tga",
				childGroups = "tab",
				args = {
					general = {
						order = 1,
						type = "group",
						name = L["General"],
						args = {},
					},
					interrupt = {
						order = 2,
						type = "group",
						name = L["Interrupt on CD"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					important = {
						order = 3,
						type = "group",
						name = L["Important Spells"],
						args = {},
					},
					shield = {
						order = 4,
						type = "group",
						name = L["Castbar Shield"],
						args = {},
					},
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
						name = L["Healthmarkers"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					executemarker = {
						order = 2,
						type = "group",
						name = L["Execute markers"],
						hidden = function()
							return not E.Retail
						end,
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
					uftextures = {
						order = 2,
						type = "group",
						name = L["Custom Unitframe Textures"],
						childGroups = "tab",
						args = {
							textures = {
								order = 1,
								type = "group",
								name = L["Custom Unitframe Textures"],
								args = {},
							},
							background = {
								order = 2,
								type = "group",
								name = L["Custom Unitframe Backgrounds"],
								args = {},
							},
						},
					},
					roleicons = {
						order = 4,
						type = "group",
						name = L["Role Icons"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					objectivetracker = {
						order = 5,
						type = "group",
						name = L["Objective Tracker"],
						hidden = function()
							return not E.Retail
						end,
						childGroups = "tab",
						args = {},
					},
					unitframeicons = {
						order = 6,
						type = "group",
						name = L["Unitframe Icons"],
						childGroups = "tab",
						args = {},
					},
					portraits = {
						order = 7,
						type = "group",
						name = L["Portraits"],
						childGroups = "tab",
						args = {},
					},
					datapanels = {
						order = 8,
						type = "group",
						name = L["Datapanels"],
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
			misc = {
				order = 9,
				type = "group",
				name = L["Misc"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\misc.tga",
				childGroups = "tab",
				args = {},
			},
			about = {
				order = 10,
				type = "group",
				name = format("|CFF05E464%s|r", L["About"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\about.tga",
				childGroups = "tab",
				args = {},
			},
			license = {
				order = 11,
				type = "group",
				name = format("|CFF0080ff%s|r", L["License"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\license.tga",
				childGroups = "tab",
				args = {},
			},
			changelog = {
				order = 12,
				type = "group",
				name = format("|CFFFF0094%s|r", L["Changelog"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\changelog.tga",
				childGroups = "select",
				args = {},
			},
			dev = {
				order = 20,
				type = "group",
				name = format("|CFF6559F1%s|r", L["DEV Tools"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga",
				childGroups = "tab",
				hidden = function()
					return not mMT.DevMode
				end,
				args = {},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
