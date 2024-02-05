local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local tinsert = tinsert

--Lua functions
local pairs = pairs
local format = format
local tonumber = tonumber
local strjoin = strjoin
local select = select

--Variables
local LSM = LibStub("LibSharedMedia-3.0")
local mFontFlags = {
	NONE = 'None',
	OUTLINE = 'Outline',
	THICKOUTLINE = 'Thick',
	SHADOW = '|cff888888Shadow|r',
	SHADOWOUTLINE = '|cff888888Shadow|r Outline',
	SHADOWTHICKOUTLINE = '|cff888888Shadow|r Thick',
	MONOCHROME = '|cFFAAAAAAMono|r',
	MONOCHROMEOUTLINE = '|cFFAAAAAAMono|r Outline',
	MONOCHROMETHICKOUTLINE = '|cFFAAAAAAMono|r Thick'
}
local ExampleDockSettings = { top = false }
local mGuild = L["Guild"]

if E.Retail then
	mGuild = GUILD_AND_COMMUNITIES
end
local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.DockIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end
	E.Options.args.mMT.args.dock.args = {
		dockgeneral = {
			order = 1,
			type = "group",
			name = L["General"],
			args = {
				headerdockgeneralcolor = {
					order = 1,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						docknormalstyle = {
							order = 1,
							type = "select",
							name = L["Normal Color Style"],
							get = function(info)
								return E.db.mMT.dockdatatext.normal.style
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.normal.style = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						docknormalcolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.dockdatatext.normal
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.normal
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralspacer1 = {
							order = 3,
							type = "description",
							name = "\n",
						},
						dockhoverstyle = {
							order = 4,
							type = "select",
							name = L["Hover Color Style"],
							get = function(info)
								return E.db.mMT.dockdatatext.hover.style
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.hover.style = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						dockhovercolor = {
							type = "color",
							order = 5,
							name = L["Custom hover Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.dockdatatext.hover
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.hover
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralspacer2 = {
							order = 6,
							type = "description",
							name = "\n",
						},
						dockclickstyle = {
							order = 7,
							type = "select",
							name = L["Click Color Style"],
							get = function(info)
								return E.db.mMT.dockdatatext.click.style
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.click.style = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						dockclickcolor = {
							type = "color",
							order = 8,
							name = L["Custom click Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.dockdatatext.click
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.click
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralspacer3 = {
							order = 9,
							type = "description",
							name = "\n",
						},
						docknotificationstyle = {
							order = 10,
							type = "select",
							name = L["Notification Color Style"],
							get = function(info)
								return E.db.mMT.dockdatatext.notification.style
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.notification.style = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						docknotificationcolor = {
							type = "color",
							order = 11,
							name = L["Custom Notification Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.dockdatatext.notification
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.notification
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
					},
				},
				headerdockgeneralsettings = {
					order = 2,
					name = L["Settings"],
					type = "group",
					inline = true,
					args = {

						dockgeneraltip = {
							order = 1,
							type = "toggle",
							name = L["Tooltip"],
							get = function(info)
								return E.db.mMT.dockdatatext.tip.enable
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.tip.enable = value
								mMT:UpdateDockSettings()
							end,
						},
						dockgeneralautogrow = {
							order = 2,
							type = "toggle",
							name = L["Auto Hover grow size"],
							get = function(info)
								return E.db.mMT.dockdatatext.autogrow
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.autogrow = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralgrowsize = {
							order = 3,
							name = L["Hover grow size"],
							type = "range",
							min = 2,
							max = 128,
							step = 2,
							softMin = 2,
							softMax = 128,
							get = function(info)
								return E.db.mMT.dockdatatext.growsize
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.growsize = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
							disabled = function()
								return E.db.mMT.dockdatatext.autogrow
							end,
						},
					},
				},

				headerdockgeneralfont = {
					order = 3,
					name = L["Font"],
					type = "group",
					inline = true,
					args = {
						dockgeneralfont = {
							type = "select",
							dialogControl = "LSM30_Font",
							order = 1,
							name = L["Default Font"],
							values = LSM:HashTable("font"),
							get = function(info)
								return E.db.mMT.dockdatatext.font
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.font = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralfontStyle = {
							type = "select",
							order = 2,
							name = L["Font contour"],
							values = mFontFlags,
							get = function(info)
								return E.db.mMT.dockdatatext.fontflag
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.fontflag = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralspacer3 = {
							order = 3,
							type = "description",
							name = "\n",
						},
						dockgeneralcustomfontSize = {
							order = 4,
							name = L["Custom Font Size"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.customfontzise
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.customfontzise = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralspacer4 = {
							order = 4,
							type = "description",
							name = "\n",
						},
						fontcenter = {
							order = 5,
							name = L["Center Text"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.center
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.center = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralfontSize = {
							order = 6,
							name = L["Font Size"],
							type = "range",
							min = 6,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.dockdatatext.fontSize
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.fontSize = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
							disabled = function()
								return not E.db.mMT.dockdatatext.customfontzise
							end,
						},
						dockgeneralspacer5 = {
							order = 7,
							type = "description",
							name = "\n",
						},
						dockgeneralcustomfontcolor = {
							order = 8,
							name = L["Custom Font color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.customfontcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.customfontcolor = value
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
						dockgeneralfontcolor = {
							type = "color",
							order = 9,
							name = L["Custom Font Color"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.dockdatatext.fontcolor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.dockdatatext.fontcolor
								t.r, t.g, t.b = r, g, b
								mMT:UpdateDockSettings()
								DT:LoadDataTexts()
							end,
						},
					},
				},
			},
		},
		dockachievment = {
			order = 2,
			type = "group",
			name = ACHIEVEMENT_BUTTON,
			hidden = function()
				return not E.Retail
			end,
			args = {
				dockachievmenticon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.achievement.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.achievement.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Achievement")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				achievmenttoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.achievement.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.achievement.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_Achievement")
					end,
				},
				achievmentcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.achievement.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.achievement.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.achievement.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_Achievement")
					end,
				},
			},
		},
		dockblizzardstore = {
			order = 3,
			type = "group",
			name = BLIZZARD_STORE,
			hidden = function()
				return not E.Retail
			end,
			args = {
				dockblizzardstoreicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.blizzardstore.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.blizzardstore.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_BlizzardStore")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				blizzardstoretoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.blizzardstore.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.blizzardstore.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_BlizzardStore")
					end,
				},
				blizzardstorecolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.blizzardstore.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.blizzardstore.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.blizzardstore.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_BlizzardStore")
					end,
				},
			},
		},
		dockcharcter = {
			order = 4,
			type = "group",
			name = CHARACTER_BUTTON,
			args = {
				dockcharctericon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.character.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.character.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Character")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						dockcharcteroption = {
							order = 1,
							type = "select",
							name = L["Show Text on Icon"],
							get = function(info)
								return E.db.mMT.dockdatatext.character.option
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.character.option = value
								DT:ForceUpdate_DataText("mMT_Dock_Character")
							end,
							values = {
								none = L["NONE"],
								durability = L["Durability"],
								ilvl = L["Itemlevel"],
							},
						},
						dockcharcteroptioncolor = {
							order = 2,
							type = "toggle",
							name = L["Colored Text"],
							get = function(info)
								return E.db.mMT.dockdatatext.character.color
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.character.color = value
								DT:ForceUpdate_DataText("mMT_Dock_Character")
							end,
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						charactertoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.character.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.character.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_Character")
							end,
						},
						charactercolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.character.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.character.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.character.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_Character")
							end,
						},
					},
				},
			},
		},
		dockcollection = {
			order = 5,
			type = "group",
			name = COLLECTIONS,
			hidden = function()
				return not E.Retail
			end,
			args = {
				dockcollectionicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.collection.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.collection.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_CollectionsJournal")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				collectiontoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.collection.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.collection.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_CollectionsJournal")
					end,
				},
				collectioncolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.collection.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.collection.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.collection.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_CollectionsJournal")
					end,
				},
			},
		},
		dockencounter = {
			order = 6,
			type = "group",
			name = ENCOUNTER_JOURNAL,
			hidden = function()
				return not E.Retail
			end,
			args = {
				dockencountericon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.encounter.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.encounter.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_EncounterJournal")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				encountertoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.encounter.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.encounter.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_EncounterJournal")
					end,
				},
				encountercolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.encounter.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.encounter.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.encounter.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_EncounterJournal")
					end,
				},
			},
		},
		dockguild = {
			order = 7,
			type = "group",
			name = mGuild,
			args = {
				dockguildicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.guild.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.guild.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Guild")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				guildtoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.guild.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.guild.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_Guild")
					end,
				},
				guildcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.guild.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.guild.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.guild.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_Guild")
					end,
				},
			},
		},
		docklfd = {
			order = 8,
			type = "group",
			name = DUNGEONS_BUTTON,
			hidden = function()
				return not E.Retail
			end,
			args = {
				docklfdicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.lfd.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.lfd.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_LFDTool")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						docklfdgreatvault = {
							order = 1,
							type = "toggle",
							name = L["Great Vault"],
							desc = L["Show Great Vault infos in the Tooltip and opens the Great Vault"],
							get = function(info)
								return E.db.mMT.dockdatatext.lfd.greatvault
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.lfd.greatvault = value
							end,
						},
						docklfdaffixes = {
							order = 2,
							type = "toggle",
							name = L["Weekly Affixes"],
							desc = L["Shows the Weekly Affixes."],
							get = function(info)
								return E.db.mMT.dockdatatext.lfd.affix
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.lfd.affix = value
							end,
						},
						docklfdkeystone = {
							order = 3,
							type = "toggle",
							name = L["Tooltip Keystone"],
							desc = L["Shows your Keystone in the tooltip."],
							get = function(info)
								return E.db.mMT.dockdatatext.lfd.keystone
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.lfd.keystone = value
							end,
						},
						docklfdcta = {
							order = 4,
							type = "toggle",
							name = L["Call To Arms"],
							get = function(info)
								return E.db.mMT.dockdatatext.lfd.cta
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.lfd.ctm = value
								DT:ForceUpdate_DataText("mMT_Dock_LFDTool")
							end,
						},
						docklfdscore = {
							order = 5,
							type = "toggle",
							name = L["Mythic+ Score"],
							get = function(info)
								return E.db.mMT.dockdatatext.lfd.score
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.lfd.score = value
								DT:ForceUpdate_DataText("mMT_Dock_LFDTool")
							end,
						},
						docklfddifficulty = {
							order = 6,
							type = "toggle",
							name = L["Difficulty Text"],
							get = function(info)
								return E.db.mMT.dockdatatext.lfd.difficulty
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.lfd.difficulty = value
								DT:ForceUpdate_DataText("mMT_Dock_LFDTool")
							end,
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						lfdtoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.lfd.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.lfd.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_LFDTool")
							end,
						},
						lfdcolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.lfd.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.lfd.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.lfd.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_LFDTool")
							end,
						},
					},
				},
			},
		},
		dockmainmenu = {
			order = 9,
			type = "group",
			name = MAINMENU_BUTTON,
			args = {
				dockmainmenuicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.mainmenu.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.mainmenu.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_MainMenu")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				mainmenutoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.mainmenu.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.mainmenu.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_MainMenu")
					end,
				},
				mainmenucolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.mainmenu.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.mainmenu.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.mainmenu.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_MainMenu")
					end,
				},
			},
		},
		dockquest = {
			order = 10,
			type = "group",
			name = QUESTLOG_BUTTON,
			args = {
				dockquesticon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.quest.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.quest.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Quest")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				questtoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.quest.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.quest.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_Quest")
					end,
				},
				questcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.quest.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.quest.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.quest.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_Quest")
					end,
				},
			},
		},
		dockspellbook = {
			order = 11,
			type = "group",
			name = SPELLBOOK_ABILITIES_BUTTON,
			args = {
				dockspellbookicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.spellbook.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.spellbook.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_SpellBook")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				spellbooktoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.spellbook.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.spellbook.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_SpellBook")
					end,
				},
				spellbookcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.spellbook.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.spellbook.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.spellbook.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_SpellBook")
					end,
				},
			},
		},
		docktalent = {
			order = 12,
			type = "group",
			name = TALENTS_BUTTON,
			hidden = function()
				return not E.Retail
			end,
			args = {
				docktalenticon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.talent.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.talent.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Talent")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				docktalentrole = {
					order = 3,
					type = "toggle",
					name = L["Show Role if in Group"],
					get = function(info)
						return E.db.mMT.dockdatatext.talent.showrole
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.talent.showrole = value
					end,
				},
				dockspacer1 = {
					order = 4,
					type = "description",
					name = "\n",
				},
				talenttoggle = {
					order = 5,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.talent.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.talent.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_Talent")
					end,
				},
				talentcolor = {
					type = "color",
					order = 6,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.talent.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.talent.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.talent.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_Talent")
					end,
				},
			},
		},
		dockitemlevel = {
			order = 13,
			type = "group",
			name = L["Itemlevel"],
			hidden = function()
				return not E.Retail
			end,
			args = {
				dockitemlevelicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.itemlevel.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.itemlevel.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_ItemLevel")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						dockitemleveltext = {
							order = 1,
							name = L["Text"],
							type = "input",
							width = "smal",
							get = function()
								return E.db.mMT.dockdatatext.itemlevel.text
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.itemlevel.text = value
								DT:ForceUpdate_DataText("mMT_Dock_ItemLevel")
							end,
						},
						dockitemlevelcolor = {
							order = 2,
							type = "toggle",
							name = L["Colored Text"],
							get = function(info)
								return E.db.mMT.dockdatatext.itemlevel.color
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.itemlevel.color = value
								DT:ForceUpdate_DataText("mMT_Dock_ItemLevel")
							end,
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						itemleveltoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.itemlevel.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.itemlevel.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_ItemLevel")
							end,
						},
						itemlevelcolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.itemlevel.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.itemlevel.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.itemlevel.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_ItemLevel")
							end,
						},
					},
				},
			},
		},
		dockfriends = {
			order = 14,
			type = "group",
			name = L["Friends"],
			args = {
				dockfriendsicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.friends.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.friends.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Friends")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				friendstoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.friends.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.friends.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_Friends")
					end,
				},
				friendslcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.friends.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.friends.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.friends.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_Friends")
					end,
				},
			},
		},
		dockdurability = {
			order = 15,
			type = "group",
			name = L["Durability"],
			args = {
				dockdurabilityicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.durability.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.durability.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Durability")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						dockdurabilitycolor = {
							order = 1,
							type = "toggle",
							name = L["Colored Text"],
							get = function(info)
								return E.db.mMT.dockdatatext.durability.color
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.durability.color = value
								DT:ForceUpdate_DataText("mMT_Dock_Durability")
							end,
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						durabilitytoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.durability.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.durability.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_Durability")
							end,
						},
						durabilitycolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.durability.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.durability.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.durability.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_Durability")
							end,
						},
					},
				},
			},
		},
		dockfpsms = {
			order = 16,
			type = "group",
			name = L["FPS / MS"],
			args = {
				dockfpsmsicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.fpsms.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.fpsms.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_FPSMS")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						dockfpsmsoption = {
							order = 1,
							type = "select",
							name = L["Show Text on Icon"],
							get = function(info)
								return E.db.mMT.dockdatatext.fpsms.option
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.fpsms.option = value
								if value == "fps" then
									E.db.mMT.dockdatatext.fpsms.text = "FPS"
								else
									E.db.mMT.dockdatatext.fpsms.text = "MS"
								end
								DT:ForceUpdate_DataText("mMT_Dock_FPSMS")
							end,
							values = {
								fps = L["FPS"],
								ms = L["MS"],
							},
						},
						dockfpsmstext = {
							order = 2,
							name = L["Text"],
							type = "input",
							width = "smal",
							get = function()
								return E.db.mMT.dockdatatext.fpsms.text
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.fpsms.text = value
								DT:ForceUpdate_DataText("mMT_Dock_FPSMS")
							end,
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						fpsmstoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.fpsms.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.fpsms.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_FPSMS")
							end,
						},
						fpsmscolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.fpsms.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.fpsms.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.fpsms.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_FPSMS")
							end,
						},
					},
				},
			},
		},
		dockprofession = {
			order = 17,
			type = "group",
			name = L["Professions"],
			hidden = function()
				return not E.Retail
			end,
			args = {
				dockprofessionicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.profession.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.profession.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Profession")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				professiontoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.profession.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.profession.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_Profession")
					end,
				},
				professioncolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.profession.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.profession.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.profession.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_Profession")
					end,
				},
			},
		},
		dockcalendar = {
			order = 18,
			type = "group",
			name = L["Calendar"],
			args = {
				dockcalendaricon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.calendar.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.calendar.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Calendar")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						dockcalendaroption = {
							order = 1,
							type = "select",
							name = L["Date Style"],
							get = function(info)
								return E.db.mMT.dockdatatext.calendar.option
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.calendar.option = value
								DT:ForceUpdate_DataText("mMT_Dock_Calendar")
							end,
							values = {
								none = L["NONE"],
								de = "DE",
								us = "US",
								gb = "GB",
							},
						},
						dockcalendartext = {
							order = 2,
							type = "toggle",
							name = L["Show Text"],
							get = function(info)
								return E.db.mMT.dockdatatext.calendar.text
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.calendar.text = value
								DT:ForceUpdate_DataText("mMT_Dock_Calendar")
							end,
						},
						dockcalendarshowyear = {
							order = 3,
							type = "toggle",
							name = L["Show Year"],
							get = function(info)
								return E.db.mMT.dockdatatext.calendar.showyear
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.calendar.showyear = value
								DT:ForceUpdate_DataText("mMT_Dock_Calendar")
							end,
						},
						calendardateiconstyle = {
							order = 4,
							type = "select",
							name = L["Date Style"],
							get = function(info)
								return E.db.mMT.dockdatatext.calendar.dateicon
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.calendar.dateicon = value
								DT:ForceUpdate_DataText("mMT_Dock_Calendar")
							end,
							values = { a = "A", b = "B", c = "C", none = L["NONE"] },
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						calendartoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.calendar.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.calendar.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_Calendar")
							end,
						},
						calendarcolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.calendar.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.calendar.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.calendar.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_Calendar")
							end,
						},
					},
				},
			},
		},
		dockvolume = {
			order = 19,
			type = "group",
			name = L["Volume"],
			args = {
				dockvolumeicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.volume.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.volume.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Volume")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						dockvolumetext = {
							order = 1,
							type = "toggle",
							name = L["Show Text"],
							get = function(info)
								return E.db.mMT.dockdatatext.volume.showtext
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.volume.showtext = value
								DT:ForceUpdate_DataText("mMT_Dock_Volume")
							end,
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						volumetoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.volume.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.volume.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_Volume")
							end,
						},
						volumecolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.volume.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.volume.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.volume.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_Volume")
							end,
						},
					},
				},
			},
		},
		dockNotification = {
			order = 20,
			type = "group",
			name = L["Notification"],
			args = {
				dockNotificationicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.notification.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.notification.icon = value
						mMT:UpdateDockSettings()
						DT:LoadDataTexts()
					end,
					values = icons,
				},
				dockNotificationiconsize = {
					order = 2,
					name = L["Icon size"],
					type = "range",
					min = 16,
					max = 128,
					step = 2,
					get = function(info)
						return E.db.mMT.dockdatatext.notification.size
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.notification.size = value
						mMT:UpdateDockSettings()
						DT:LoadDataTexts()
					end,
				},
				dockNotificationiconauto = {
					order = 3,
					type = "toggle",
					name = L["Auto Size"],
					get = function(info)
						return E.db.mMT.dockdatatext.notification.auto
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.notification.auto = value
						mMT:UpdateDockSettings()
						DT:LoadDataTexts()
					end,
				},
				dockNotificationspacer1 = {
					order = 4,
					type = "description",
					name = "\n",
				},
				dockNotificationiconflash = {
					order = 5,
					type = "toggle",
					name = L["Icon flash"],
					get = function(info)
						return E.db.mMT.dockdatatext.notification.flash
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.notification.flash = value
						mMT:UpdateDockSettings()
					end,
				},
			},
		},
		dockbag = {
			order = 22,
			type = "group",
			name = L["Bags"],
			args = {
				dockbagicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.bag.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.bag.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Bags")
					end,
					values = icons,
				},
				settings = {
					order = 2,
					type = "group",
					name = L["Settings"],
					inline = true,
					args = {
						dockbagtext = {
							order = 1,
							type = "select",
							name = L["Text to display"],
							get = function(info)
								return E.db.mMT.dockdatatext.bag.text
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.bag.text = value
								DT:ForceUpdate_DataText("mMT_Dock_Bags")
							end,
							values = {
								[1] = L["Bag - FREE"],
								[2] = L["Bag - USED"],
								[3] = L["Bag - FREE/TOTAL"],
								[4] = L["GOLD"],
								[5] = L["NONE"],
							},
						},
					},
				},
				color = {
					order = 2,
					type = "group",
					name = L["Color"],
					inline = true,
					args = {
						bagtoggle = {
							order = 1,
							name = L["Custom color"],
							type = "toggle",
							get = function(info)
								return E.db.mMT.dockdatatext.bag.customcolor
							end,
							set = function(info, value)
								E.db.mMT.dockdatatext.bag.customcolor = value
								DT:ForceUpdate_DataText("mMT_Dock_Bags")
							end,
						},
						bagcolor = {
							type = "color",
							order = 2,
							name = L["Custom Icon Color"],
							hasAlpha = true,
							disabled = function()
								return not E.db.mMT.dockdatatext.bag.customcolor
							end,
							get = function(info)
								local t = E.db.mMT.dockdatatext.bag.iconcolor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.dockdatatext.bag.iconcolor
								t.r, t.g, t.b, t.a = r, g, b, a
								DT:ForceUpdate_DataText("mMT_Dock_Bags")
							end,
						},
					},
				},
			},
		},
		dockmail = {
			order = 23,
			type = "group",
			name = MAIL_LABEL,
			hidden = function()
				return not E.Retail
			end,
			args = {
				dockmail = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.dockdatatext.mail.icon
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.mail.icon = value
						DT:ForceUpdate_DataText("mMT_Dock_Mail")
					end,
					values = icons,
				},
				dockspacer = {
					order = 2,
					type = "description",
					name = "\n",
				},
				achievmenttoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.dockdatatext.mail.customcolor
					end,
					set = function(info, value)
						E.db.mMT.dockdatatext.mail.customcolor = value
						DT:ForceUpdate_DataText("mMT_Dock_Mail")
					end,
				},
				achievmentcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.dockdatatext.mail.customcolor
					end,
					get = function(info)
						local t = E.db.mMT.dockdatatext.mail.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.dockdatatext.mail.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMT_Dock_Mail")
					end,
				},
			},
		},
		dockexample = {
			order = 300,
			type = "group",
			name = format("|CFF58D68D%s|r", L["Creat mDock"]),
			args = {
				examplesdescription = {
					order = 1,
					type = "description",
					name = L["These are just examples of how to create your own dock with ElvUI's custom bars.\n\n\nTo create your own bar you have to go to ElvUI under ElvUI>Datatext>Bars Steps 1. enter name press OK and click Add, set the width of the bar depends on how many icons you want to display, the height of the bar is also the size of the icons. Set the number of data text and now you only need to assign the icons to the places, for example 1 = Dock FPS, 2 = Dock Profession and so on.\n\n"],
				},
				warningdescription = {
					order = 2,
					type = "description",
					name = L["In Classic, the docks may look different, since not all modules are available in this version. You can customize the docks in the settings of ElvUI."],
				},
				examplesheader = {
					order = 3,
					type = "header",
					name = "",
				},
				exampletop = {
					order = 4,
					type = "toggle",
					name = L["Dock on Top"],
					get = function(info)
						return ExampleDockSettings.top
					end,
					set = function(info, value)
						ExampleDockSettings.top = value
					end,
				},
				examplespacer1 = {
					order = 5,
					type = "description",
					name = "\n",
				},
				dockbar1 = {
					order = 11,
					type = "execute",
					name = L["mMT XIV Like"],
					func = function()
						mMT:Dock_XIVLike(ExampleDockSettings.top)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				dockbar2 = {
					order = 12,
					type = "execute",
					name = L["mMT XIV Like Color"],
					func = function()
						mMT:Dock_XIVLike_Color(ExampleDockSettings.top)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				dockbar3 = {
					order = 13,
					type = "execute",
					name = L["mMT Dock"],
					func = function()
						mMT:Dock_Default(ExampleDockSettings.top)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				dockbar4 = {
					order = 14,
					type = "execute",
					name = L["mMT Extra"],
					func = function()
						mMT:Dock_Extra(ExampleDockSettings.top)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				dockbar6 = {
					order = 15,
					type = "execute",
					name = L["MaUI XIV Like"],
					func = function()
						mMT:Dock_MaUI(ExampleDockSettings.top)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				dockbar5 = {
					order = 15,
					type = "execute",
					name = L["Add XIV Background"],
					func = function()
						mMT:Dock_BG(ExampleDockSettings.top)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				examplespacer2 = {
					order = 40,
					type = "description",
					name = "\n",
				},
				dockbardisable = {
					order = 41,
					type = "execute",
					name = L["Delete All"],
					func = function()
						mMT:DeleteAll()
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				examplespacer3 = {
					order = 50,
					type = "description",
					name = "\n",
				},
				preview = {
					type = "description",
					name = "",
					order = 51,
					image = function()
						return "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\dock.tga", 819, 102
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
