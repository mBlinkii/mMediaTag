local E, L, V, P, G = unpack(ElvUI)
local LSM = E.Libs.LSM

local tinsert = tinsert
local mFontFlags = {
	NONE = "None",
	OUTLINE = "Outline",
	THICKOUTLINE = "Thick",
	SHADOW = "|cff888888Shadow|r",
	SHADOWOUTLINE = "|cff888888Shadow|r Outline",
	SHADOWTHICKOUTLINE = "|cff888888Shadow|r Thick",
	MONOCHROME = "|cFFAAAAAAMono|r",
	MONOCHROMEOUTLINE = "|cFFAAAAAAMono|r Outline",
	MONOCHROMETHICKOUTLINE = "|cFFAAAAAAMono|r Thick",
}
local positionValues = {
	LEFT = "LEFT",
	RIGHT = "RIGHT",
	CENTER = "CENTER",
	TOP = "TOP",
	TOPLEFT = "TOPLEFT",
	TOPRIGHT = "TOPRIGHT",
	BOTTOM = "BOTTOM",
	BOTTOMLEFT = "BOTTOMLEFT",
	BOTTOMRIGHT = "BOTTOMRIGHT",
}

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.DashIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end
	E.Options.args.mMT.args.cosmetic.args.objectivetracker.args = {
		header_objectivetracker = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Objective Tracker"],
			args = {
				toggle_objectivetracker = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable ObjectiveTracker (Questwatch) Skin."],
					get = function(info)
						return E.db.mMT.objectivetracker.enable
					end,
					set = function(info, value)
						E.db.mMT.objectivetracker.enable = value
						if value == true and E.private.skins.blizzard.objectiveTracker == false then
							E.private.skins.blizzard.objectiveTracker = true
						end
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_simple = {
					order = 2,
					type = "toggle",
					name = L["Simple Skin"],
					desc = L["Adds only a Header bar."],
					disabled = function()
						return not E.db.mMT.objectivetracker.enable
					end,
					get = function(info)
						return E.db.mMT.objectivetracker.simple
					end,
					set = function(info, value)
						E.db.mMT.objectivetracker.simple = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		group_fontold = {
			order = 2,
			type = "group",
			name = L["Font"],
			disabled = function()
				return not (E.db.mMT.objectivetracker.enable and not E.db.mMT.objectivetracker.simple)
			end,
			args = {
				header_font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					args = {
						generalfont = {
							type = "select",
							dialogControl = "LSM30_Font",
							order = 1,
							name = L["Default Font"],
							values = LSM:HashTable("font"),
							get = function(info)
								return E.db.mMT.objectivetracker.font
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font = value
							end,
						},
						generalfontflag = {
							type = "select",
							order = 2,
							name = L["Font contour"],
							values = mFontFlags,
							get = function(info)
								return E.db.mMT.objectivetracker.fontflag
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.fontflag = value
							end,
						},
					},
				},
			},
		},

		group_header = {
			order = 3,
			type = "group",
			name = L["Header"],
			disabled = function()
				return not ((E.db.mMT.objectivetracker.enable and E.db.mMT.objectivetracker.simple) or E.db.mMT.objectivetracker.enable)
			end,
			args = {
				header_font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					disabled = function()
						return E.db.mMT.objectivetracker.simple
					end,
					args = {
						headerfontsize = {
							order = 1,
							name = L["Font Size"],
							type = "range",
							min = 6,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.header.fontsize
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.fontsize = value
							end,
						},
						headerfontcolorstyle = {
							order = 2,
							type = "select",
							name = L["Font color Style"],
							get = function(info)
								return E.db.mMT.objectivetracker.header.fontcolorstyle
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.fontcolorstyle = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						headerfontcolor = {
							type = "color",
							order = 3,
							name = L["Font color"],
							hasAlpha = false,
							disabled = function()
								return (E.db.mMT.objectivetracker.header.fontcolorstyle == "class")
							end,
							get = function(info)
								local t = E.db.mMT.objectivetracker.header.fontcolor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.header.fontcolor
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				header_bar = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Bar"],
					disabled = function()
						return not (E.db.mMT.objectivetracker.simple or E.db.mMT.objectivetracker.enable)
					end,
					args = {
						headerbarstyle = {
							order = 1,
							type = "select",
							name = L["Bar Style"],
							get = function(info)
								return E.db.mMT.objectivetracker.header.barstyle
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.barstyle = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								one = L["One"],
								two = L["Two"],
								onebig = L["One big"],
								twobig = L["Two big"],
								none = L["None"],
							},
						},
						headerbarcolorstyle = {
							order = 2,
							type = "select",
							name = L["Bar color Style"],
							disabled = function()
								return (E.db.mMT.objectivetracker.header.barstyle == "none")
							end,
							get = function(info)
								return E.db.mMT.objectivetracker.header.barcolorstyle
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.barcolorstyle = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						headerbarcolor = {
							type = "color",
							order = 3,
							name = L["Bar color"],
							hasAlpha = false,
							disabled = function()
								return (E.db.mMT.objectivetracker.header.barcolorstyle == "class")
							end,
							get = function(info)
								local t = E.db.mMT.objectivetracker.header.barcolor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.header.barcolor
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						headerbartexture = {
							order = 4,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Bar Texture"],
							values = LSM:HashTable("statusbar"),
							get = function(info)
								return E.db.mMT.objectivetracker.header.texture
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.texture = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						headerbarshadow = {
							order = 5,
							type = "toggle",
							name = L["Bar Shadow"],
							disabled = function()
								return (E.db.mMT.objectivetracker.header.barstyle == "none")
							end,
							get = function(info)
								return E.db.mMT.objectivetracker.header.barshadow
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.barshadow = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						headerbargradient = {
							order = 6,
							type = "toggle",
							name = L["Bar Gradient"],
							disabled = function()
								return (E.db.mMT.objectivetracker.header.barstyle == "none")
							end,
							get = function(info)
								return E.db.mMT.objectivetracker.header.gradient
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.gradient = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						headerbargradientrevers = {
							order = 7,
							type = "toggle",
							name = L["Revers Gradient"],
							disabled = function()
								return (E.db.mMT.objectivetracker.header.barstyle == "none")
							end,
							get = function(info)
								return E.db.mMT.objectivetracker.header.revers
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.revers = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				header_settings = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Settings"],
					disabled = function()
						return E.db.mMT.objectivetracker.simple
					end,
					args = {
						headerquestamount = {
							order = 1,
							type = "select",
							name = L["Show Quest Amount"],
							get = function(info)
								return E.db.mMT.objectivetracker.header.questcount
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.header.questcount = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								none = L["None"],
								left = L["left"],
								right = L["right"],
								colorleft = L["Colorful left"],
								colorright = L["Colorful right"],
							},
						},
					},
				},
			},
		},

		group_title = {
			order = 4,
			type = "group",
			name = L["Title"],
			disabled = function()
				return not (E.db.mMT.objectivetracker.enable and not E.db.mMT.objectivetracker.simple)
			end,
			args = {
				header_font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					args = {
						titlefontsize = {
							order = 1,
							name = L["Font Size"],
							type = "range",
							min = 6,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.title.fontsize
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.title.fontsize = value
							end,
						},
						titlefontcolorstyle = {
							order = 2,
							type = "select",
							name = L["Font color Style"],
							get = function(info)
								return E.db.mMT.objectivetracker.title.fontcolorstyle
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.title.fontcolorstyle = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						titlefontcolor = {
							type = "color",
							order = 3,
							name = L["Font color"],
							hasAlpha = false,
							disabled = function()
								return not E.db.mMT.objectivetracker.title.fontcolorstyle == "class"
							end,
							get = function(info)
								local t = E.db.mMT.objectivetracker.title.fontcolor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.title.fontcolor
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
			},
		},

		group_questtext = {
			order = 5,
			type = "group",
			name = L["Quest Text"],
			disabled = function()
				return not (E.db.mMT.objectivetracker.enable and not E.db.mMT.objectivetracker.simple)
			end,
			args = {
				header_font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					args = {
						textfontsize = {
							order = 1,
							name = L["Font Size"],
							type = "range",
							min = 6,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.text.fontsize
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.text.fontsize = value
							end,
						},
						textfontcolorstyle = {
							order = 2,
							type = "select",
							name = L["Font color Style"],
							get = function(info)
								return E.db.mMT.objectivetracker.text.fontcolorstyle
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.text.fontcolorstyle = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								class = L["Class"],
								custom = L["Custom"],
							},
						},
						textfontcolor = {
							type = "color",
							order = 3,
							name = L["Font color"],
							hasAlpha = false,
							disabled = function()
								return not E.db.mMT.objectivetracker.text.fontcolorstyle == "class"
							end,
							get = function(info)
								local t = E.db.mMT.objectivetracker.text.fontcolor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.text.fontcolor
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				header_color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Color"],
					args = {
						textfontcolorcomplete = {
							type = "color",
							order = 1,
							name = L["Complete Font color"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.text.completecolor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.text.completecolor
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						textfontcolorfailed = {
							type = "color",
							order = 2,
							name = L["Failed Font color"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.text.failedcolor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.text.failedcolor
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						textprogresscolorgood = {
							type = "color",
							order = 3,
							name = L["Good color"],
							hasAlpha = false,
							disabled = function()
								return not E.db.mMT.objectivetracker.text.progresscolor
							end,
							get = function(info)
								local t = E.db.mMT.objectivetracker.text.progresscolorgood
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.text.progresscolorgood
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						textprogresscolortransit = {
							type = "color",
							order = 4,
							name = L["Transit color"],
							hasAlpha = false,
							disabled = function()
								return not E.db.mMT.objectivetracker.text.progresscolor
							end,
							get = function(info)
								local t = E.db.mMT.objectivetracker.text.progresscolortransit
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.text.progresscolortransit
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						textprogresscolorbad = {
							type = "color",
							order = 5,
							name = L["Bad color"],
							hasAlpha = false,
							disabled = function()
								return not E.db.mMT.objectivetracker.text.progresscolor
							end,
							get = function(info)
								local t = E.db.mMT.objectivetracker.text.progresscolorbad
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.text.progresscolorbad
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				header_settings = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Settings"],
					args = {
						textprogresspercent = {
							order = 1,
							type = "toggle",
							name = L["Progress in percent"],
							desc = L["Show Progress in percent"],
							get = function(info)
								return E.db.mMT.objectivetracker.text.progrespercent
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.text.progrespercent = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						textprogresscolor = {
							order = 2,
							type = "toggle",
							name = L["Colorful Progress"],
							desc = L["Colorful Progress"],
							get = function(info)
								return E.db.mMT.objectivetracker.text.progresscolor
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.text.progresscolor = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						textonlyprogresstext = {
							order = 3,
							type = "toggle",
							name = L["Clean Text"],
							desc = L["Shows the Text without []"],
							get = function(info)
								return E.db.mMT.objectivetracker.text.cleantext
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.text.cleantext = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						textbarbackdrop = {
							order = 4,
							type = "toggle",
							name = L["Skin Bar backdrop"],
							get = function(info)
								return E.db.mMT.objectivetracker.text.backdrop
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.text.backdrop = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
			},
		},

		group_dash = {
			order = 6,
			type = "group",
			name = L["Dash"],
			disabled = function()
				return not (E.db.mMT.objectivetracker.enable and not E.db.mMT.objectivetracker.simple)
			end,
			args = {
				header_settings = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Settings"],
					args = {
						dashstyle = {
							order = 1,
							type = "select",
							name = L["Dash Style"],
							get = function(info)
								return E.db.mMT.objectivetracker.dash.style
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.dash.style = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								blizzard = L["Blizzard"],
								icon = L["Icon"],
								custom = L["Custom"],
								none = L["None"],
							},
						},
						dashtexture = {
							order = 2,
							type = "select",
							name = L["Icon"],
							disabled = function()
								return not (E.db.mMT.objectivetracker.dash.style == "icon")
							end,
							get = function(info)
								return E.db.mMT.objectivetracker.dash.texture
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.dash.texture = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = icons,
						},
						dashcustom = {
							order = 3,
							name = L["Custom Dash Symbol"],
							desc = L["Custom Dash Symbol, enter any character you want."],
							type = "input",
							width = "smal",
							disabled = function()
								return not (E.db.mMT.objectivetracker.dash.style == "custom")
							end,
							get = function()
								return E.db.mMT.objectivetracker.dash.customstring
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.dash.customstring = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
			},
		},
		header_settings = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
				header_settings = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Title"],
					args = {
						toggle_questcount = {
							order = 1,
							type = "toggle",
							name = L["Quest Count"],
							get = function(info)
								return E.db.mMT.objectivetracker.settings.questcount
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.settings.questcount = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
			},
		},

		group_font = {
			order = 6,
			type = "group",
			name = L["Font"],
			disabled = function()
				return not (E.db.mMT.objectivetracker.enable and not E.db.mMT.objectivetracker.simple)
			end,
			args = {
				header_font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					args = {
						select_font = {
							type = "select",
							dialogControl = "LSM30_Font",
							order = 1,
							name = L["Default Font"],
							values = LSM:HashTable("font"),
							get = function(info)
								return E.db.mMT.objectivetracker.font.font
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.font = value
							end,
						},
						select_fontflag = {
							type = "select",
							order = 2,
							name = L["Font contour"],
							values = mFontFlags,
							get = function(info)
								return E.db.mMT.objectivetracker.font.fontflag
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.fontflag = value
							end,
						},
						spacer_1 = {
							order = 3,
							type = "description",
							name = "\n\n\n",
						},
						fontsize_header = {
							order = 4,
							name = L["Font Size"] .. " " .. L["Header"],
							type = "range",
							min = 1,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.font.fontsize.header
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.fontsize.header = value
							end,
						},
						spacer_2 = {
							order = 5,
							type = "description",
							name = "\n\n\n",
						},
						fontsize_title = {
							order = 6,
							name = L["Font Size"] .. " " .. L["Title"],
							type = "range",
							min = 1,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.font.fontsize.title
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.fontsize.title = value
							end,
						},
						spacer_3 = {
							order = 7,
							type = "description",
							name = "\n\n\n",
						},
						fontsize_text = {
							order = 8,
							name = L["Font Size"] .. " " .. L["Text"],
							type = "range",
							min = 1,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.font.fontsize.text
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.fontsize.text = value
							end,
						},
					},
				},
				header_settings = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Settings"],
					args = {
						range_highlight = {
							order = 1,
							name = L["Highlight dim Value"],
							type = "range",
							min = 0,
							max = 1,
							step = 0.01,
							get = function(info)
								return E.db.mMT.objectivetracker.font.highlight
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.highlight = value
							end,
						},
					},
				},
				header_fontcolor = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Font Colors"],
					args = {
						color_title = {
							type = "color",
							order = 1,
							name = L["Title"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.title
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.title
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_title = {
							order = 2,
							type = "toggle",
							name = L["Class colored"],
							get = function(info)
								return E.db.mMT.objectivetracker.font.color.title.class
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.color.title.class = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_1 = {
							order = 3,
							type = "description",
							name = "\n\n\n",
						},
						color_header = {
							type = "color",
							order = 4,
							name = L["Header"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.header
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.header
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_header = {
							order = 5,
							type = "toggle",
							name = L["Class colored"],
							get = function(info)
								return E.db.mMT.objectivetracker.font.color.header.class
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.color.header.class = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_2 = {
							order = 6,
							type = "description",
							name = "\n\n\n",
						},
						color_text = {
							type = "color",
							order = 7,
							name = L["Text"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.text
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.text
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_text = {
							order = 8,
							type = "toggle",
							name = L["Class colored"],
							get = function(info)
								return E.db.mMT.objectivetracker.font.color.text.class
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.color.text.class = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_3 = {
							order = 9,
							type = "description",
							name = "\n\n\n",
						},
						color_failed = {
							type = "color",
							order = 10,
							name = L["Failed"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.failed
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.failed
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_4 = {
							order = 11,
							type = "description",
							name = "\n\n\n",
						},
						color_complete = {
							type = "color",
							order = 12,
							name = L["Complete"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.complete
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.complete
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_6 = {
							order = 16,
							type = "description",
							name = "\n\n\n",
						},
						color_good = {
							type = "color",
							order = 17,
							name = L["Progress Good"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.good
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.good
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_7 = {
							order = 18,
							type = "description",
							name = "\n\n\n",
						},
						color_transit = {
							type = "color",
							order = 19,
							name = L["Progress Transit"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.transit
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.transit
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_8 = {
							order = 20,
							type = "description",
							name = "\n\n\n",
						},
						color_bad = {
							type = "color",
							order = 21,
							name = L["Progress bad"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.objectivetracker.font.color.bad
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.font.color.bad
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
			},
		},
		group_bar = {
			order = 6,
			type = "group",
			name = L["Bars"],
			disabled = function()
				return not (E.db.mMT.objectivetracker.enable and not E.db.mMT.objectivetracker.simple)
			end,
			args = {
				header_font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					args = {
						fontsize_bar = {
							order = 1,
							name = L["Font Size"],
							type = "range",
							min = 1,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.bar.fontsize
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bar.fontsize = value
							end,
						},
						select_fontpoint = {
							order = 2,
							type = "select",
							name = L["Anchor Point"],
							get = function(info)
								return E.db.mMT.objectivetracker.bar.fontpoint
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bar.fontpoint = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							values = {
								LEFT = L["LEFT"],
								CENTER = L["CENTER"],
								RIGHT = L["RIGHT"],
							},
						},
					},
				},
				header_bar = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Settings"],
					args = {
						toggle_barbg = {
							order = 1,
							type = "toggle",
							name = L["Transparent Backdrop"],
							get = function(info)
								return E.db.mMT.objectivetracker.bar.transparent
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bar.transparent = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						bar_hight = {
							order = 2,
							name = L["Bar hight"],
							type = "range",
							min = 1,
							max = 128,
							step = 1,
							get = function(info)
								return E.db.mMT.objectivetracker.bar.hight
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bar.hight = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
