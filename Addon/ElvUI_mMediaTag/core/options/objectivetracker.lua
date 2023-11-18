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
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_dash = {
					order = 1,
					type = "toggle",
					name = L["Hide Dash"],
					get = function(info)
						return E.db.mMT.objectivetracker.settings.hidedash
					end,
					set = function(info, value)
						E.db.mMT.objectivetracker.settings.hidedash = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		group_font = {
			order = 3,
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
		group_headerbar = {
			order = 4,
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
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mMT.objectivetracker.headerbar.color
								t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
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
							name = L["Gradient Color"],
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
			order = 5,
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
							name = L["Gradient Color"],
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
	}
end

tinsert(mMT.Config, configTable)
