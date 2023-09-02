local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert

local function configTable()
	E.Options.args.mMT.args.cosmetic.args.portraits.args = {
		header_general = {
			order = 1,
			type = "group",
			inline = true,
			name = L["General"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Portraits"],
					get = function(info)
						return E.db.mMT.portraits.general.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.general.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				spacer_1 = {
					order = 2,
					type = "description",
					name = "\n\n",
				},
				toggle_gradient = {
					order = 3,
					type = "toggle",
					name = L["Gradient"],
					get = function(info)
						return E.db.mMT.portraits.general.gradient
					end,
					set = function(info, value)
						E.db.mMT.portraits.general.gradient = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				select_gradient = {
					order = 4,
					type = "select",
					name = L["Gradient Orientation"],
					disabled = function()
						return not E.db.mMT.portraits.general.gradient
					end,
					get = function(info)
						return E.db.mMT.portraits.general.ori
					end,
					set = function(info, value)
						E.db.mMT.portraits.general.ori = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						HORIZONTAL = "HORIZONTAL",
						VERTICAL = "VERTICAL",
					},
				},
			},
		},
		header_player = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Player"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Player Portraits"],
					get = function(info)
						return E.db.mMT.portraits.player.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.player.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				select_style = {
					order = 2,
					type = "select",
					name = L["Style"],
					get = function(info)
						return E.db.mMT.portraits.player.texture
					end,
					set = function(info, value)
						E.db.mMT.portraits.player.texture = value

						if value == "CIRCLE1" or value == "CIRCLE2" or value == "CIRCLE3" or value == "CIRCLE4" or value == "CIRCLE5" or value == "CIRCLE6" then
							E.db.mMT.portraits.player.circle = true
						else
							E.db.mMT.portraits.player.circle = false
						end

						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						SQUARE1 = "FLAT",
						SQUARE2 = "FLAT/SMOOTH",
						SQUARE3 = "FLAT/SHADOW",
						SQUARE4 = "FLAT/SMOTH/SHADOW",
						SQUARE5 = "FLAT/BORDER",
						SQUARE6 = "FLAT/SMOOTH/BORDER",
						ROUND1 = "ROUND",
						ROUND2 = "ROUND/SMOOTH",
						ROUND3 = "ROUND/SHADOW",
						ROUND4 = "ROUND/SMOTH/SHADOW",
						ROUND5 = "ROUND/BORDER",
						ROUND6 = "ROUND/SMOOTH/BORDER",
						CIRCLE1 = "CIRCLE",
						CIRCLE2 = "CIRCLE/SMOOTH",
						CIRCLE3 = "CIRCLE/SHADOW",
						CIRCLE4 = "CIRCLE/SMOTH/SHADOW",
						CIRCLE5 = "CIRCLE/BORDER",
						CIRCLE6 = "CIRCLE/SMOOTH/BORDER",
					},
				},
				range_size = {
					order = 3,
					name = L["Size"],
					type = "range",
					min = 16,
					max = 256,
					step = 1,
					softMin = 16,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.player.size
					end,
					set = function(info, value)
						E.db.mMT.portraits.player.size = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				select_anchor = {
					order = 4,
					type = "select",
					name = L["Anchor Point"],
					get = function(info)
						return E.db.mMT.portraits.player.relativePoint
					end,
					set = function(info, value)
						E.db.mMT.portraits.player.relativePoint = value
						if value == "LEFT" then
							E.db.mMT.portraits.player.point = "RIGHT"
							E.db.mMT.portraits.player.mirror = false
						elseif value == "RIGHT" then
							E.db.mMT.portraits.player.point = "LEFT"
							E.db.mMT.portraits.player.mirror = true
						else
							E.db.mMT.portraits.player.point = value
							E.db.mMT.portraits.player.mirror = false
						end

						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						LEFT = "LEFT",
						RIGHT = "RIGHT",
						CENTER = "CENTER"
					},
				},
				range_ofsX = {
					order = 5,
					name = L["X offset"],
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					softMin = -256,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.player.x
					end,
					set = function(info, value)
						E.db.mMT.portraits.player.x = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				range_ofsY = {
					order = 6,
					name = L["Y offset"],
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					softMin = -256,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.player.y
					end,
					set = function(info, value)
						E.db.mMT.portraits.player.y = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
			},
		},
		header_target = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Target"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Target Portraits"],
					get = function(info)
						return E.db.mMT.portraits.target.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_extra = {
					order = 2,
					type = "toggle",
					name = L["Enable Rare/Elite Border"],
					get = function(info)
						return E.db.mMT.portraits.target.extraEnable
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.extraEnable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				select_style = {
					order = 3,
					type = "select",
					name = L["Style"],
					get = function(info)
						return E.db.mMT.portraits.target.texture
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.texture = value

						if value == "CIRCLE1" or value == "CIRCLE2" or value == "CIRCLE3" or value == "CIRCLE4" or value == "CIRCLE5" or value == "CIRCLE6" then
							E.db.mMT.portraits.target.circle = true
						else
							E.db.mMT.portraits.target.circle = false
						end

						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						SQUARE1 = "FLAT",
						SQUARE2 = "FLAT/SMOOTH",
						SQUARE3 = "FLAT/SHADOW",
						SQUARE4 = "FLAT/SMOTH/SHADOW",
						SQUARE5 = "FLAT/BORDER",
						SQUARE6 = "FLAT/SMOOTH/BORDER",
						ROUND1 = "ROUND",
						ROUND2 = "ROUND/SMOOTH",
						ROUND3 = "ROUND/SHADOW",
						ROUND4 = "ROUND/SMOTH/SHADOW",
						ROUND5 = "ROUND/BORDER",
						ROUND6 = "ROUND/SMOOTH/BORDER",
						CIRCLE1 = "CIRCLE",
						CIRCLE2 = "CIRCLE/SMOOTH",
						CIRCLE3 = "CIRCLE/SHADOW",
						CIRCLE4 = "CIRCLE/SMOTH/SHADOW",
						CIRCLE5 = "CIRCLE/BORDER",
						CIRCLE6 = "CIRCLE/SMOOTH/BORDER",
					},
				},
				select_styleExtra = {
					order = 4,
					type = "select",
					name = L["Rare/ Elite Style"],
					get = function(info)
						return E.db.mMT.portraits.target.extra
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.extra = value

						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						EXTRA1 = "EXTRA",
						EXTRA2 = "EXTRA/SMOOTH",
						EXTRA3 = "EXTRA/SHADOW",
						EXTRA4 = "EXTRA/SMOTH/SHADOW",
						EXTRA5 = "EXTRA/BORDER",
						EXTRA6 = "EXTRA/SMOOTH/BORDER",
					},
				},
				range_size = {
					order = 5,
					name = L["Size"],
					type = "range",
					min = 16,
					max = 256,
					step = 1,
					softMin = 16,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.target.size
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.size = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				select_anchor = {
					order = 6,
					type = "select",
					name = L["Anchor Point"],
					get = function(info)
						return E.db.mMT.portraits.target.relativePoint
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.relativePoint = value
						if value == "LEFT" then
							E.db.mMT.portraits.target.point = "RIGHT"
							E.db.mMT.portraits.target.mirror = false
						elseif value == "RIGHT" then
							E.db.mMT.portraits.target.point = "LEFT"
							E.db.mMT.portraits.target.mirror = true
						else
							E.db.mMT.portraits.target.point = value
							E.db.mMT.portraits.target.mirror = false
						end

						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						LEFT = "LEFT",
						RIGHT = "RIGHT",
						CENTER = "CENTER"
					},
				},
				range_ofsX = {
					order = 7,
					name = L["X offset"],
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					softMin = -256,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.target.x
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.x = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				range_ofsY = {
					order = 8,
					name = L["Y offset"],
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					softMin = -256,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.target.y
					end,
					set = function(info, value)
						E.db.mMT.portraits.target.y = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
			},
		},
		header_party = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Party"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Party Portraits"],
					get = function(info)
						return E.db.mMT.portraits.party.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.party.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				select_style = {
					order = 2,
					type = "select",
					name = L["Style"],
					get = function(info)
						return E.db.mMT.portraits.party.texture
					end,
					set = function(info, value)
						E.db.mMT.portraits.party.texture = value

						if value == "CIRCLE1" or value == "CIRCLE2" or value == "CIRCLE3" or value == "CIRCLE4" or value == "CIRCLE5" or value == "CIRCLE6" then
							E.db.mMT.portraits.party.circle = true
						else
							E.db.mMT.portraits.party.circle = false
						end

						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						SQUARE1 = "FLAT",
						SQUARE2 = "FLAT/SMOOTH",
						SQUARE3 = "FLAT/SHADOW",
						SQUARE4 = "FLAT/SMOTH/SHADOW",
						SQUARE5 = "FLAT/BORDER",
						SQUARE6 = "FLAT/SMOOTH/BORDER",
						ROUND1 = "ROUND",
						ROUND2 = "ROUND/SMOOTH",
						ROUND3 = "ROUND/SHADOW",
						ROUND4 = "ROUND/SMOTH/SHADOW",
						ROUND5 = "ROUND/BORDER",
						ROUND6 = "ROUND/SMOOTH/BORDER",
						CIRCLE1 = "CIRCLE",
						CIRCLE2 = "CIRCLE/SMOOTH",
						CIRCLE3 = "CIRCLE/SHADOW",
						CIRCLE4 = "CIRCLE/SMOTH/SHADOW",
						CIRCLE5 = "CIRCLE/BORDER",
						CIRCLE6 = "CIRCLE/SMOOTH/BORDER",
					},
				},
				range_size = {
					order = 3,
					name = L["Size"],
					type = "range",
					min = 16,
					max = 256,
					step = 1,
					softMin = 16,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.party.size
					end,
					set = function(info, value)
						E.db.mMT.portraits.party.size = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				select_anchor = {
					order = 4,
					type = "select",
					name = L["Anchor Point"],
					get = function(info)
						return E.db.mMT.portraits.party.relativePoint
					end,
					set = function(info, value)
						E.db.mMT.portraits.party.relativePoint = value
						if value == "LEFT" then
							E.db.mMT.portraits.party.point = "RIGHT"
							E.db.mMT.portraits.party.mirror = false
						elseif value == "RIGHT" then
							E.db.mMT.portraits.party.point = "LEFT"
							E.db.mMT.portraits.party.mirror = true
						else
							E.db.mMT.portraits.party.point = value
							E.db.mMT.portraits.party.mirror = false
						end

						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
					values = {
						LEFT = "LEFT",
						RIGHT = "RIGHT",
						CENTER = "CENTER",
					},
				},
				range_ofsX = {
					order = 5,
					name = L["X offset"],
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					softMin = -256,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.party.x
					end,
					set = function(info, value)
						E.db.mMT.portraits.party.x = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				range_ofsY = {
					order = 6,
					name = L["Y offset"],
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					softMin = -256,
					softMax = 256,
					get = function(info)
						return E.db.mMT.portraits.party.y
					end,
					set = function(info, value)
						E.db.mMT.portraits.party.y = value
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
			},
		},
		header_colors = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Colors"],
			args = {
				execute_apply = {
					order = 0,
					type = "execute",
					name = L["Apply"],
					func = function()
						mMT:UpdatePortraitSettings()
						mMT:UpdatePortraits()
					end,
				},
				DEATHKNIGHT = {
					order = 1,
					type = "group",
					inline = true,
					name = L["DEATHKNIGHT"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.DEATHKNIGHT.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.DEATHKNIGHT.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.DEATHKNIGHT.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.DEATHKNIGHT.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				DEMONHUNTER = {
					order = 2,
					type = "group",
					inline = true,
					name = L["DEMONHUNTER"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.DEMONHUNTER.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.DEMONHUNTER.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.DEMONHUNTER.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.DEMONHUNTER.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				DRUID = {
					order = 3,
					type = "group",
					inline = true,
					name = L["DRUID"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.DRUID.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.DRUID.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.DRUID.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.DRUID.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				EVOKER = {
					order = 4,
					type = "group",
					inline = true,
					name = L["EVOKER"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.EVOKER.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.EVOKER.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.EVOKER.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.EVOKER.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				HUNTER = {
					order = 5,
					type = "group",
					inline = true,
					name = L["HUNTER"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.HUNTER.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.HUNTER.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.HUNTER.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.HUNTER.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				MAGE = {
					order = 6,
					type = "group",
					inline = true,
					name = L["MAGE"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.MAGE.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.MAGE.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.MAGE.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.MAGE.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				MONK = {
					order = 7,
					type = "group",
					inline = true,
					name = L["MONK"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.MONK.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.MONK.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.MONK.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.MONK.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				PALADIN = {
					order = 8,
					type = "group",
					inline = true,
					name = L["PALADIN"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.PALADIN.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.PALADIN.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.PALADIN.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.PALADIN.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				PRIEST = {
					order = 9,
					type = "group",
					inline = true,
					name = L["PRIEST"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.PRIEST.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.PRIEST.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.PRIEST.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.PRIEST.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				ROGUE = {
					order = 10,
					type = "group",
					inline = true,
					name = L["ROGUE"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.ROGUE.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.ROGUE.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.ROGUE.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.ROGUE.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				SHAMAN = {
					order = 11,
					type = "group",
					inline = true,
					name = L["SHAMAN"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.SHAMAN.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.SHAMAN.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.SHAMAN.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.SHAMAN.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				WARLOCK = {
					order = 12,
					type = "group",
					inline = true,
					name = L["WARLOCK"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.WARLOCK.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.WARLOCK.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.WARLOCK.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.WARLOCK.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				WARRIOR = {
					order = 13,
					type = "group",
					inline = true,
					name = L["DEMONHUNTER"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.WARRIOR.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.WARRIOR.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.WARRIOR.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.WARRIOR.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				default = {
					order = 14,
					type = "group",
					inline = true,
					name = L["default"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.default.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.default.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.default.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.default.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				rare = {
					order = 15,
					type = "group",
					inline = true,
					name = L["rare"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.rare.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.rare.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.rare.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.rare.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				relite = {
					order = 16,
					type = "group",
					inline = true,
					name = L["relite"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.relite.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.relite.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.relite.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.relite.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				elite = {
					order = 17,
					type = "group",
					inline = true,
					name = L["elite"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.elite.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.elite.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.elite.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.elite.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				enemy = {
					order = 18,
					type = "group",
					inline = true,
					name = L["enemy"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.enemy.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.enemy.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.enemy.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.enemy.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				neutral = {
					order = 19,
					type = "group",
					inline = true,
					name = L["neutral"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.neutral.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.neutral.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.neutral.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.neutral.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				friendly = {
					order = 20,
					type = "group",
					inline = true,
					name = L["friendly"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.friendly.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.friendly.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.friendly.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.friendly.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
