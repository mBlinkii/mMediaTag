local E = unpack(ElvUI)
local L = mMT.Locales

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
					desc = L["Enable ObjectiveTracker Skin."],
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
			},
		},
		header_settings = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Settings"],
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
						mMT.Modules.ObjectiveTracker:Initialize()
					end,
				},
				toggle_dash = {
					order = 2,
					type = "toggle",
					name = L["Hide Dash"],
					get = function(info)
						return E.db.mMT.objectivetracker.settings.hidedash
					end,
					set = function(info, value)
						E.db.mMT.objectivetracker.settings.hidedash = value
						mMT.Modules.ObjectiveTracker:Initialize()
					end,
				},
			},
		},
		background_settings = {
			order = 3,
			type = "group",
			name = L["Background"],
			args = {
				toggle_background = {
					order = 1,
					type = "toggle",
					name = L["Background Skin"],
					get = function(info)
						return E.db.mMT.objectivetracker.bg.enable
					end,
					set = function(info, value)
						E.db.mMT.objectivetracker.bg.enable = value
						mMT.Modules.ObjectiveTracker:Initialize()
					end,
				},
				header_color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Background Color"],
					disabled = function()
						return E.db.mMT.objectivetracker.bg.transparent
					end,
					args = {
						color_bg = {
							type = "color",
							order = 3,
							name = L["Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.objectivetracker.bg.color.bg
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.objectivetracker.bg.color.bg
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT.Modules.ObjectiveTracker:Initialize()
							end,
						},
					},
				},
				header_border = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Border"],
					args = {
						toggle_border = {
							order = 4,
							type = "toggle",
							name = L["Border"],
							get = function(info)
								return E.db.mMT.objectivetracker.bg.border
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bg.border = value
								mMT.Modules.ObjectiveTracker:Initialize()
							end,
						},
						color_border = {
							type = "color",
							order = 5,
							name = L["Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.objectivetracker.bg.color.border
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.objectivetracker.bg.color.border
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT.Modules.ObjectiveTracker:Initialize()
							end,
						},
						toggle_header = {
							order = 2,
							type = "toggle",
							name = L["Class colored"],
							get = function(info)
								return E.db.mMT.objectivetracker.bg.classBorder
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bg.classBorder = value
								mMT.Modules.ObjectiveTracker:Initialize()
							end,
						},
					},
				},
				header_shadow = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Shadow"],
					args = {
						toggle_shadow = {
							order = 2,
							type = "toggle",
							name = L["Shadow"],
							get = function(info)
								return E.db.mMT.objectivetracker.bg.shadow
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bg.shadow = value
								mMT.Modules.ObjectiveTracker:Initialize()
							end,
						},
					},
				},
				header_transparent = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Transparent"],
					args = {
						toggle_shadow = {
							order = 2,
							type = "toggle",
							name = L["Transparent"],
							get = function(info)
								return E.db.mMT.objectivetracker.bg.transparent
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bg.transparent = value
								mMT.Modules.ObjectiveTracker:Initialize()
							end,
						},
					},
				},
			},
		},
		group_font = {
			order = 4,
			type = "group",
			name = L["Font"],
			disabled = function()
				return not E.db.mMT.objectivetracker.enable
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
								E:StaticPopup_Show("CONFIG_RL")
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
								E:StaticPopup_Show("CONFIG_RL")
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
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_hideAll = {
							order = 5,
							type = "toggle",
							name = L["Hide (All Objectives)"],
							get = function(info)
								return E.db.mMT.objectivetracker.settings.hideAll
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.settings.hideAll = value
								mMT.Modules.ObjectiveTracker:Initialize()
							end,
						},
						spacer_2 = {
							order = 6,
							type = "description",
							name = "\n\n\n",
						},
						fontsize_title = {
							order = 7,
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
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_3 = {
							order = 8,
							type = "description",
							name = "\n\n\n",
						},
						fontsize_text = {
							order = 9,
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
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_4 = {
							order = 10,
							type = "description",
							name = "\n\n\n",
						},
						fontsize_time = {
							order = 11,
							name = L["Font Size"] .. " " .. L["M+ Time"],
							type = "range",
							min = 1,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return E.db.mMT.objectivetracker.font.fontsize.time
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.fontsize.time = value
								E:StaticPopup_Show("CONFIG_RL")
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
							max = 2,
							step = 0.01,
							get = function(info)
								return E.db.mMT.objectivetracker.font.highlight
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.font.highlight = value
								E:StaticPopup_Show("CONFIG_RL")
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
						color_header = {
							type = "color",
							order = 1,
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
							order = 2,
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
						spacer_1 = {
							order = 3,
							type = "description",
							name = "\n\n\n",
						},
						color_title = {
							type = "color",
							order = 4,
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
							order = 5,
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
		group_headerbar = {
			order = 5,
			type = "group",
			name = L["Cosmetic Headerbar"],
			disabled = function()
				return not E.db.mMT.objectivetracker.enable
			end,
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.objectivetracker.headerbar.enable
					end,
					set = function(info, value)
						E.db.mMT.objectivetracker.headerbar.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				header_settings = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Settings"],
					args = {
						select_texture = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Texture"],
							values = LSM:HashTable("statusbar"),
							get = function(info)
								return E.db.mMT.objectivetracker.headerbar.texture
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.headerbar.texture = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_1 = {
							order = 2,
							type = "description",
							name = "\n\n\n",
						},
						color_bar = {
							type = "color",
							order = 3,
							name = L["Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.objectivetracker.headerbar.color
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.objectivetracker.headerbar.color
								t.r, t.g, t.b, t.a, t.hex = r, g, b, a, E:RGBToHex(r, g, b)
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_color = {
							order = 4,
							type = "toggle",
							name = L["Class colored"],
							get = function(info)
								return E.db.mMT.objectivetracker.headerbar.class
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.headerbar.class = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer_2 = {
							order = 5,
							type = "description",
							name = "\n\n\n",
						},
						toggle_gradient = {
							order = 6,
							type = "toggle",
							name = L["Gradient"],
							get = function(info)
								return E.db.mMT.objectivetracker.headerbar.gradient
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.headerbar.gradient = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_shadow = {
							order = 7,
							type = "toggle",
							name = L["Shadow"],
							get = function(info)
								return E.db.mMT.objectivetracker.headerbar.shadow
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.headerbar.shadow = value
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
			name = L["Progress Bar"],
			disabled = function()
				return not E.db.mMT.objectivetracker.enable
			end,
			args = {
				header_font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Text"],
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
					name = L["Progress Bars"],
					args = {
						toggle_barbg = {
							order = 1,
							type = "toggle",
							name = L["ElvUI Background Color"],
							get = function(info)
								return E.db.mMT.objectivetracker.bar.elvbg
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bar.elvbg = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_shadow = {
							order = 2,
							type = "toggle",
							name = L["Shadow"],
							get = function(info)
								return E.db.mMT.objectivetracker.bar.shadow
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bar.shadow = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_gradient = {
							order = 3,
							type = "toggle",
							name = L["Gradient"],
							get = function(info)
								return E.db.mMT.objectivetracker.bar.gradient
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.bar.gradient = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						bar_hight = {
							order = 4,
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
		group_dungeon = {
			order = 7,
			type = "group",
			name = L["Dungeon Skin"],
			disabled = function()
				return not E.db.mMT.objectivetracker.enable
			end,
			args = {
				settings = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Settings"],
					args = {
						toggle_dash = {
							order = 1,
							type = "toggle",
							name = L["Hide Dash"],
							get = function(info)
								return E.db.mMT.objectivetracker.dungeon.hidedash
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.dungeon.hidedash = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_shadow = {
							order = 2,
							type = "toggle",
							name = L["Shadow"],
							get = function(info)
								return E.db.mMT.objectivetracker.dungeon.shadow
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.dungeon.shadow = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Mythic+ Colors"],
					args = {
						chest_1 = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Chest"] .. " +1",
							args = {
								color_a = {
									type = "color",
									order = 1,
									name = L["A"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest1.a
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest1.a
										t.r, t.g, t.b, t.a = r, g, b, a
									end,
								},
								color_b = {
									type = "color",
									order = 1,
									name = L["B"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest1.b
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest1.b
										t.r, t.g, t.b, t.a = r, g, b, a
									end,
								},
							},
						},
						chest_2 = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Chest"] .. " +2",
							args = {
								color_a = {
									type = "color",
									order = 1,
									name = L["A"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest2.a
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest2.a
										t.r, t.g, t.b, t.a = r, g, b, a
									end,
								},
								color_b = {
									type = "color",
									order = 1,
									name = L["B"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest2.b
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest2.b
										t.r, t.g, t.b, t.a = r, g, b, a
									end,
								},
							},
						},
						chest_3 = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Chest"] .. " +3",
							args = {
								color_a = {
									type = "color",
									order = 1,
									name = L["A"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest3.a
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest3.a
										t.r, t.g, t.b, t.a = r, g, b, a
									end,
								},
								color_b = {
									type = "color",
									order = 1,
									name = L["B"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest3.b
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.objectivetracker.dungeon.color.chest3.b
										t.r, t.g, t.b, t.a = r, g, b, a
									end,
								},
							},
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
