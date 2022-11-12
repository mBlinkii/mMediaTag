local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

--Lua functions
local format = format
local mInsert = table.insert

local function OptionsCore()
	E.Options.args.mMediaTag = {
		order = 10,
		type = "group",
		childGroups = "tab",
		name = ns.mName,
		args = {
			logo = {
				order = 1,
				type = "description",
				name = "",
				fontSize = "medium",
				image = function()
					return "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\logo.tga", 512, 128
				end,
			},
			general = {
				order = 10,
				type = "group",
				name = L["General"],
				args = {
					greetingtextsetting = {
						order = 10,
						type = "group",
						name = L["Greeting text"],
						args = {
							greetingtext = {
								order = 1,
								type = "toggle",
								name = L["Greeting text at start"],
								desc = L["Enables or disables the welcome text, at startup."],
								get = function(info)
									return E.db[mPlugin].mMsg
								end,
								set = function(info, value)
									E.db[mPlugin].mMsg = value
								end,
							},
						},
					},
					nameplatesetting = {
						order = 20,
						type = "group",
						name = L["Nameplate Settings"],
						args = {
							colorednamplates = {
								order = 1,
								type = "toggle",
								name = L["Class colored Namplates"],
								desc = L["Class colored Namplates Hover and Boarder color."],
								get = function(info)
									return E.db[mPlugin].mClassNameplate
								end,
								set = function(info, value)
									E.db[mPlugin].mClassNameplate = value
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
							spacernameplate = {
								order = 2,
								type = "description",
								name = "\n\n\n",
							},
						},
					},
					tooltipsettings = {
						order = 30,
						type = "group",
						name = L["Tooltip"],
						args = {
							tooltipicon = {
								order = 1,
								type = "toggle",
								name = L["Tooltip Icon"],
								desc = L["Enables or disables Tooltip Icon"],
								get = function(info)
									return E.db[mPlugin].mTIcon
								end,
								set = function(info, value)
									E.db[mPlugin].mTIcon = value
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
							spacertooltip = {
								order = 2,
								type = "description",
								name = "\n\n",
							},
							tooltipiconsize = {
								order = 3,
								name = L["Icon size"],
								desc = L["Tooltip Icon size."],
								type = "range",
								min = 16,
								max = 128,
								step = 2,
								get = function(info)
									return E.db[mPlugin].mTIconSize
								end,
								set = function(info, value)
									E.db[mPlugin].mTIconSize = value
								end,
							},
						},
					},
					menusettings = {
						order = 40,
						type = "group",
						name = L["Menu Settings"],
						args = {
							menucolorsetting = {
								order = 1,
								type = "toggle",
								name = L["Class colered hover texture"],
								desc = L["Enables or disables Class colered hover texture."],
								get = function(info)
									return E.db[mPlugin].mClassColorHover
								end,
								set = function(info, value)
									E.db[mPlugin].mClassColorHover = value
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
							spacermenu = {
								order = 2,
								type = "description",
								name = "\n\n",
							},
							menutexture = {
								order = 3,
								type = "select",
								dialogControl = "LSM30_Statusbar",
								name = L["Menu Hover Texture"],
								values = LSM:HashTable("statusbar"),
								get = function(info)
									return E.db[mPlugin].mHoverTexture
								end,
								set = function(info, value)
									E.db[mPlugin].mHoverTexture = value
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
						},
					},
					myticplustools = {
						order = 40,
						type = "group",
						name = L["Mythic plus Tools"],
						args = {},
					},
					healtmarker = {
						order = 50,
						type = "group",
						name = L["Nameplate Healthmarkers"],
						args = {},
					},
					tools = {
						order = 60,
						type = "group",
						name = L["Tools"],
						args = {
							mroll = {
								order = 10,
								type = "group",
								name = L["mRoll"],
								args = {},
							},
							mchatmenu = {
								order = 20,
								type = "group",
								name = L["mChatMenu"],
								args = {},
							},
							mvolumedisplay = {
								order = 30,
								type = "group",
								name = L["mVolumeDisplay"],
								args = {},
							},
						},
					},
				},
			},
			datatext = {
				order = 20,
				type = "group",
				name = L["Datatext"],
				args = {
					datatextgeneral = {
						order = 1,
						type = "group",
						name = L["General"],
						args = {
							datatextgeneralheader = {
								order = 0,
								type = "header",
								name = L["Datatext Options Color (Tooltip)"],
							},
							datatextgeneralcolornhc = {
								type = "color",
								order = 1,
								name = L["Color NHC"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colornhc
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colornhc
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolorhc = {
								type = "color",
								order = 2,
								name = L["Color HC"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colorhc
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colorhc
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolornm = {
								type = "color",
								order = 3,
								name = L["Color Mythic"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colormyth
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colormyth
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolornmp = {
								type = "color",
								order = 3,
								name = L["Color Mythic+"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colormythplus
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colormythplus
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolorother = {
								type = "color",
								order = 4,
								name = L["Color other"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colorother
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colorother
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolortitel = {
								type = "color",
								order = 5,
								name = L["Color Titel"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colortitel
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colortitel
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolortip = {
								type = "color",
								order = 7,
								name = L["Color Tip"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colortip
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colortip
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
						},
					},
					professionsmenusettings = {
						order = 10,
						type = "group",
						name = L["Profession Menu"],
						args = {},
					},
					systemmenusettings = {
						order = 20,
						type = "group",
						name = L["System Menu"],
						args = {},
					},
					dungeonsetting = {
						order = 30,
						type = "group",
						name = L["Dungeon"],
						args = {},
					},
					currencys = {
						order = 40,
						type = "group",
						name = L["Currencys"],
						args = {},
					},
				},
			},
			mdock = {
				order = 30,
				type = "group",
				name = L["mDock"],
				args = {},
			},
			tags = {
				order = 40,
				type = "group",
				name = L["Tags"],
				args = {},
			},
			chatbaground = {
				order = 50,
				type = "group",
				name = L["Chatbaground"],
				args = {},
			},
			cosmetic = {
				order = 60,
				type = "group",
				name = L["Cosmetic"],
				args = {
					rolesymbols = {
						order = 1,
						type = "group",
						name = L["Role Symbols"],
						args = {},
					},
					castbar = {
						order = 2,
						type = "group",
						name = L["Castbar"],
						args = {},
					},
					objectivetracker = {
						order = 3,
						type = "group",
						name = L["ObjectiveTracker Skin"],
						childGroups = "tab",
						args = {},
					},
					custombackdrop = {
						order = 4,
						type = "group",
						name = L["Custom Backdrop Textures"],
						childGroups = "tab",
						args = {},
					},
					customcombaticon = {
						order = 5,
						type = "group",
						name = L["Custom Combaticons"],
						childGroups = "tab",
						args = {},
					},
				},
			},
			about = {
				order = 80,
				type = "group",
				name = L["About"],
				args = {
					headerabout1 = {
						order = 1,
						type = "header",
						name = ns.mName,
					},
					descriptionabout1 = {
						order = 2,
						type = "description",
						name = L["|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r is a plugin for ElvUI with additional Textures, Chatbackgrounds, Tags for the Unitframes, Profession and System menu extensions for the Datatext bars.\n\n\n\n|CFF2ECC71Special features|r\n\n|CFF3498DB -|r 50 Statusbar Texturs\n|CFF3498DB -|r 15 Chatbackgrounds\n|CFF3498DB -|r Datatext Game Menu\n|CFF3498DB -|r Datatext Professions Menu\n|CFF3498DB -|r Datatext Dock Icons to buld your owen Dockbar\n|CFF3498DB -|r Datatext Dungeon Info, Dungeon Name, Affix, Keystone, and Achievements\n|CFF3498DB -|r Tooltip Icon\n|CFF3498DB -|r Automatically display the Namplat boarder and hover effects in the class colors\n|CFF3498DB -|r 25 Tags for ElvUI\n\n\n\n|CFF3498DB©|r |CFF8E44ADCopyright|r |CFF2ECC712021|r |CFF3498DB©|r |CFF2ECC71by|r |CFF3498DBBlinkii|r"],
					},
					spacerabout1 = {
						order = 3,
						type = "description",
						name = "\n\n",
					},
					headerabout = {
						order = 4,
						type = "header",
						name = L["License"],
					},
					licenseabout = {
						order = 5,
						type = "description",
						name = format(
							L["%sAddon:|r\n\nAll contents of this AddOn - ElvUI_mMediaTag especially texts, photographs and graphics, are protected by copyright.\n\n\n%sDock Icons:|r\n\nIcons are from Google - Material Design Icons are available under material.io. The symbols are available under the APACHE LICENSE, VERSION 2.0.\nIcons were resized to 64x64 pixel and the color was changed from black to white."],
							ns.mColor2,
							ns.mColor2
						),
					},
					spacerabout2 = {
						order = 6,
						type = "description",
						name = "\n\n",
					},
					headerabout2 = {
						order = 7,
						type = "header",
						name = L["Thanks for Help and Support"],
					},
					aboutthx = {
						order = 8,
						type = "description",
						name = L["Simpy"],
					},
					headerabout3 = {
						order = 9,
						type = "header",
						name = L["Contact & Git"],
					},
					spacerabout3 = {
						order = 10,
						type = "description",
						name = "\n\n",
					},
					aboutcontact = {
						order = 11,
						type = "execute",
						name = L["Contact"],
						func = function()
							E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "mmediatag@gmx.de")
						end,
					},
					aboutgit = {
						order = 12,
						type = "execute",
						name = L["Git"],
						func = function()
							E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "https://git.tukui.org/Blinkii/mmediatag")
						end,
					},
					aboutchangelog = {
						order = 13,
						type = "execute",
						name = L["Changelog"],
						func = function()
							mMT:Changelog(true)
						end,
					},
				},
			},
		},
	}
end

local function OptionsCoreClassic()
	E.Options.args.mMediaTag = {
		order = 10,
		type = "group",
		childGroups = "tab",
		name = ns.mName,
		args = {
			logo = {
				order = 1,
				type = "description",
				name = "",
				fontSize = "medium",
				image = function()
					return "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\logo.tga", 512, 128
				end,
			},
			general = {
				order = 10,
				type = "group",
				name = L["General"],
				args = {
					greetingtextsetting = {
						order = 10,
						type = "group",
						name = L["Greeting text"],
						args = {
							greetingtext = {
								order = 1,
								type = "toggle",
								name = L["Greeting text at start"],
								desc = L["Enables or disables the welcome text, at startup."],
								get = function(info)
									return E.db[mPlugin].mMsg
								end,
								set = function(info, value)
									E.db[mPlugin].mMsg = value
								end,
							},
						},
					},
					nameplatesetting = {
						order = 20,
						type = "group",
						name = L["Nameplate Settings"],
						args = {
							colorednamplates = {
								order = 1,
								type = "toggle",
								name = L["Class colored Namplates"],
								desc = L["Class colored Namplates Hover and Boarder color."],
								get = function(info)
									return E.db[mPlugin].mClassNameplate
								end,
								set = function(info, value)
									E.db[mPlugin].mClassNameplate = value
									if value == false then
										mMT:mRestoreNameplateSettings()
									else
										mMT:mBackupNameplateSettings()
									end
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
							spacernameplate = {
								order = 2,
								type = "description",
								name = "\n\n\n",
							},
							namplaterset = {
								order = 3,
								type = "execute",
								name = L["Reset Backup"],
								desc = L["Resets Namplate Backups"],
								func = function()
									mMT:mRestoreNameplateSettings()
									E.db[mPlugin].mClassNameplate = false
									E.db[mPlugin].mBackup = false
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
						},
					},
					tooltipsettings = {
						order = 30,
						type = "group",
						name = L["Tooltip"],
						args = {
							tooltipicon = {
								order = 1,
								type = "toggle",
								name = L["Tooltip Icon"],
								desc = L["Enables or disables Tooltip Icon"],
								get = function(info)
									return E.db[mPlugin].mTIcon
								end,
								set = function(info, value)
									E.db[mPlugin].mTIcon = value
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
							spacertooltip = {
								order = 2,
								type = "description",
								name = "\n\n",
							},
							tooltipiconsize = {
								order = 3,
								name = L["Icon size"],
								desc = L["Tooltip Icon size."],
								type = "range",
								min = 16,
								max = 128,
								step = 2,
								get = function(info)
									return E.db[mPlugin].mTIconSize
								end,
								set = function(info, value)
									E.db[mPlugin].mTIconSize = value
								end,
							},
						},
					},
					menusettings = {
						order = 40,
						type = "group",
						name = L["Menu Settings"],
						args = {
							menucolorsetting = {
								order = 1,
								type = "toggle",
								name = L["Class colered hover texture"],
								desc = L["Enables or disables Class colered hover texture."],
								get = function(info)
									return E.db[mPlugin].mClassColorHover
								end,
								set = function(info, value)
									E.db[mPlugin].mClassColorHover = value
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
							spacermenu = {
								order = 2,
								type = "description",
								name = "\n\n",
							},
							menutexture = {
								order = 3,
								type = "select",
								dialogControl = "LSM30_Statusbar",
								name = L["Menu Hover Texture"],
								values = LSM:HashTable("statusbar"),
								get = function(info)
									return E.db[mPlugin].mHoverTexture
								end,
								set = function(info, value)
									E.db[mPlugin].mHoverTexture = value
									E:StaticPopup_Show("CONFIG_RL")
								end,
							},
						},
					},
					tools = {
						order = 60,
						type = "group",
						name = L["Tools"],
						args = {
							mroll = {
								order = 10,
								type = "group",
								name = L["mRoll"],
								args = {},
							},
							mchatmenu = {
								order = 20,
								type = "group",
								name = L["mChatMenu"],
								args = {},
							},
							mvolumedisplay = {
								order = 30,
								type = "group",
								name = L["mVolumeDisplay"],
								args = {},
							},
						},
					},
				},
			},
			datatext = {
				order = 20,
				type = "group",
				name = L["Datatext"],
				args = {
					datatextgeneral = {
						order = 1,
						type = "group",
						name = L["General"],
						args = {
							datatextgeneralheader = {
								order = 0,
								type = "header",
								name = L["Datatext Options Color (Tooltip)"],
							},
							datatextgeneralcolornhc = {
								type = "color",
								order = 1,
								name = L["Color NHC"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colornhc
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colornhc
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolorhc = {
								type = "color",
								order = 2,
								name = L["Color HC"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colorhc
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colorhc
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolornm = {
								type = "color",
								order = 3,
								name = L["Color Mythic"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colormyth
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colormyth
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolornmp = {
								type = "color",
								order = 3,
								name = L["Color Mythic+"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colormythplus
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colormythplus
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolorother = {
								type = "color",
								order = 4,
								name = L["Color other"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colorother
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colorother
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolortitel = {
								type = "color",
								order = 5,
								name = L["Color Titel"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colortitel
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colortitel
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
							datatextgeneralcolortip = {
								type = "color",
								order = 7,
								name = L["Color Tip"],
								desc = L["Custom color for Datatext Tip"],
								hasAlpha = false,
								get = function(info)
									local t = E.db[mPlugin].mDataText.colortip
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									local t = E.db[mPlugin].mDataText.colortip
									t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								end,
							},
						},
					},
					systemmenusettings = {
						order = 20,
						type = "group",
						name = L["System Menu"],
						args = {},
					},
				},
			},
			mdock = {
				order = 30,
				type = "group",
				name = L["mDock"],
				args = {},
			},
			tags = {
				order = 40,
				type = "group",
				name = L["Tags"],
				args = {},
			},
			chatbaground = {
				order = 50,
				type = "group",
				name = L["Chatbaground"],
				args = {},
			},
			cosmetic = {
				order = 60,
				type = "group",
				name = L["Cosmetic"],
				args = {
					customcombaticon = {
						order = 5,
						type = "group",
						name = L["Custom Combaticons"],
						childGroups = "tab",
						args = {},
					},
					rolesymbols = {
						order = 1,
						type = "group",
						name = L["Role Symbols"],
						args = {},
					},
					custombackdrop = {
						order = 4,
						type = "group",
						name = L["Custom Backdrop Textures"],
						childGroups = "tab",
						args = {},
					},
				},
			},
			about = {
				order = 80,
				type = "group",
				name = L["About"],
				args = {
					headerabout1 = {
						order = 1,
						type = "header",
						name = ns.mName,
					},
					descriptionabout1 = {
						order = 2,
						type = "description",
						name = L["|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r is a plugin for ElvUI with additional Textures, Chatbackgrounds, Tags for the Unitframes, Profession and System menu extensions for the Datatext bars.\n\n\n\n|CFF2ECC71Special features|r\n\n|CFF3498DB -|r 50 Statusbar Texturs\n|CFF3498DB -|r 15 Chatbackgrounds\n|CFF3498DB -|r Datatext Game Menu\n|CFF3498DB -|r Datatext Professions Menu\n|CFF3498DB -|r Datatext Dock Icons to buld your owen Dockbar\n|CFF3498DB -|r Datatext Dungeon Info, Dungeon Name, Affix, Keystone, and Achievements\n|CFF3498DB -|r Tooltip Icon\n|CFF3498DB -|r Automatically display the Namplat boarder and hover effects in the class colors\n|CFF3498DB -|r 25 Tags for ElvUI\n\n\n\n|CFF3498DB©|r |CFF8E44ADCopyright|r |CFF2ECC712021|r |CFF3498DB©|r |CFF2ECC71by|r |CFF3498DBBlinkii|r"],
					},
					spacerabout1 = {
						order = 3,
						type = "description",
						name = "\n\n",
					},
					headerabout = {
						order = 4,
						type = "header",
						name = L["License"],
					},
					licenseabout = {
						order = 5,
						type = "description",
						name = format(
							L["%sAddon:|r\n\nAll contents of this AddOn - ElvUI_mMediaTag especially texts, photographs and graphics, are protected by copyright.\n\n\n%sDock Icons:|r\n\nIcons are from Google - Material Design Icons are available under material.io. The symbols are available under the APACHE LICENSE, VERSION 2.0.\nIcons were resized to 64x64 pixel and the color was changed from black to white."],
							ns.mColor2,
							ns.mColor2
						),
					},
					spacerabout2 = {
						order = 6,
						type = "description",
						name = "\n\n",
					},
					headerabout2 = {
						order = 7,
						type = "header",
						name = L["Thanks for Help and Support"],
					},
					aboutthx = {
						order = 8,
						type = "description",
						name = L["Simpy"],
					},
					headerabout3 = {
						order = 9,
						type = "header",
						name = L["Contact & Git"],
					},
					spacerabout3 = {
						order = 10,
						type = "description",
						name = "\n\n",
					},
					aboutcontact = {
						order = 11,
						type = "execute",
						name = L["Contact"],
						func = function()
							E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "mmediatag@gmx.de")
						end,
					},
					aboutgit = {
						order = 12,
						type = "execute",
						name = L["Git"],
						func = function()
							E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "https://git.tukui.org/Blinkii/mmediatag")
						end,
					},
					aboutchangelog = {
						order = 13,
						type = "execute",
						name = L["Changelog"],
						func = function()
							mMT:Changelog(true)
						end,
					},
				},
			},
		},
	}
end

if E.Retail then
	mInsert(ns.Config, OptionsCore)
else
	mInsert(ns.Config, OptionsCoreClassic)
end
