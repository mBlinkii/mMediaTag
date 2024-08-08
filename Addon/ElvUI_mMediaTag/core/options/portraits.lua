local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

local form = {
	SQ = L["Drop"],
	RO = L["Drop round"],
	CI = L["Circle"],
	PI = L["Pad"],
	RA = L["Diamond"],
	QA = L["Square"],
	MO = L["Moon"],
	SQT = L["Drop flipped"],
	ROT = L["Drop round flipped"],
	TH = L["Thin"],
}

local style = {
	flat = "FLAT",
	smooth = "SMOOTH",
	metal = "METALLIC",
}

local ClassIconStyle = {
	BLIZZARD = "Blizzard",
}

local frameStrata = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	TOOLTIP = "TOOLTIP",
	AUTO = "Auto",
}

function BuildIconStylesTable()
	for id, name in pairs(mMT.ElvUI_JiberishIcons.styles) do
		ClassIconStyle[id] = name
	end
end

local function configTable()
	local sizeString = ":16:16:0:0:64:64:4:60:4:60"

	if mMT.ElvUI_JiberishIcons.loaded then
		BuildIconStylesTable()
	end

	E.Options.args.mMT.args.cosmetic.args.portraits.args = {
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
				mMT.Modules.Portraits:Initialize()
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		header_general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				header_general = {
					order = 1,
					type = "group",
					name = L["General"],
					args = {
						class_icons = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Class Icons"],
							args = {
								toggle_classicon = {
									order = 1,
									type = "toggle",
									name = L["Use Class Icons"],
									get = function(info)
										return E.db.mMT.portraits.general.classicons
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.classicons = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								select_classicon_style = {
									order = 2,
									type = "select",
									name = L["Class Icons Style"],
									disabled = function()
										return not E.db.mMT.portraits.general.classicons
									end,
									get = function(info)
										return E.db.mMT.portraits.general.classiconstyle
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.classiconstyle = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
									values = ClassIconStyle,
								},
								select_texture = {
									order = 3,
									type = "select",
									name = L["Background Texture"],
									disabled = function()
										return not E.db.mMT.portraits.general.classicons
									end,
									get = function(info)
										return E.db.mMT.portraits.general.bgstyle
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.bgstyle = value
										mMT.Modules.Portraits:Initialize()
									end,
									values = {
										[1] = L["Style"] .. " 1",
										[2] = L["Style"] .. " 2",
										[3] = L["Style"] .. " 3",
										[4] = L["Style"] .. " 4",
										[5] = L["Style"] .. " 5",
									},
								},
							},
						},
						gradient = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Gradient"],
							args = {
								toggle_gradient = {
									order = 1,
									type = "toggle",
									name = L["Gradient"],
									get = function(info)
										return E.db.mMT.portraits.general.gradient
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.gradient = value
										mMT.Modules.Portraits:Initialize()
									end,
								},
								select_gradient = {
									order = 2,
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
										mMT.Modules.Portraits:Initialize()
									end,
									values = {
										HORIZONTAL = "HORIZONTAL",
										VERTICAL = "VERTICAL",
									},
								},
								spacer_texture1 = {
									order = 3,
									type = "description",
									name = "\n\n",
								},
								toggle_gradien_eltr = {
									order = 4,
									type = "toggle",
									name = L["Use Eltruism colors"],
									get = function(info)
										return E.db.mMT.portraits.general.eltruism
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.eltruism = value
										E.db.mMT.portraits.general.mui = false
										mMT.ElvUI_EltreumUI = mMT:CheckEltruism()
										mMT.Modules.Portraits:Initialize()
									end,
								},
								toggle_gradien_mui = {
									order = 5,
									type = "toggle",
									name = L["Use MerathilisUI colors"],
									get = function(info)
										return E.db.mMT.portraits.general.mui
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.mui = value
										E.db.mMT.portraits.general.eltruism = false
										mMT.ElvUI_MerathilisUI = mMT:CheckMerathilisUI()
										mMT.Modules.Portraits:Initialize()
									end,
								},
							},
						},
					},
				},
				header_style = {
					order = 2,
					type = "group",
					name = L["Texture Style"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Style"],
							get = function(info)
								return E.db.mMT.portraits.general.style
							end,
							set = function(info, value)
								E.db.mMT.portraits.general.style = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = style,
						},
						toggle_corner = {
							order = 2,
							type = "toggle",
							name = L["Enable Corner"],
							get = function(info)
								return E.db.mMT.portraits.general.corner
							end,
							set = function(info, value)
								E.db.mMT.portraits.general.corner = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						custom = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Custom Portrait Textures"],
							args = {
								toggle_enable = {
									order = 1,
									type = "toggle",
									name = L["Enable Custom Textures"],
									get = function(info)
										return E.db.mMT.portraits.custom.enable
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.enable = value
										mMT.Modules.Portraits:Initialize()
									end,
								},
								spacer_texture1 = {
									order = 2,
									type = "description",
									name = "\n\n",
								},
								desc_important = {
									order = 3,
									type = "description",
									name = L["Info! To achieve an optimal result with the portraits, a texture should be set for the texture, border and mask.\nThe mask is always required and no portrait will be visible without it.\n\n"],
								},
								texture = {
									order = 4,
									desc = L["This is the main texture for the portraits."],
									name = function()
										if E.db.mMT.portraits.custom.texture and (E.db.mMT.portraits.custom.texture ~= "") then
											return L["Texture"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.texture, sizeString)
										else
											return L["Texture"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.texture
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.texture = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture2 = {
									order = 5,
									type = "description",
									name = "\n\n",
								},
								extra = {
									order = 6,
									desc = L["This is the Rare & Elite texture for the portraits."],
									name = function()
										if E.db.mMT.portraits.custom.extra and (E.db.mMT.portraits.custom.extra ~= "") then
											return L["Rare & Elite"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.extra, sizeString)
										else
											return L["Rare & Elite"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.extra
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.extra = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture3 = {
									order = 7,
									type = "description",
									name = "\n\n",
								},
								extraborder = {
									order = 8,
									desc = L["This is the Border texture for the Rare & Elite texture."],
									name = function()
										if E.db.mMT.portraits.custom.extraborder and (E.db.mMT.portraits.custom.extraborder ~= "") then
											return L["Rare & Elite - Border"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.extraborder, sizeString)
										else
											return L["Rare & Elite - Border"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.extraborder
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.extraborder = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture4 = {
									order = 9,
									type = "description",
									name = "\n\n",
								},
								extrashadow= {
									order = 10,
									desc = L["This is the shadow texture for the Rare & Elite texture."],
									name = function()
										if E.db.mMT.portraits.custom.extrashadow and (E.db.mMT.portraits.custom.extrashadow ~= "") then
											return L["Rare & Elite - Shadow"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.extrashadow, sizeString)
										else
											return L["Rare & Elite - Shadow"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.extrashadow
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.extrashadow = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture5 = {
									order = 11,
									type = "description",
									name = "\n\n",
								},
								border = {
									order = 12,
									desc = L["This is the Border texture for the portraits."],
									name = function()
										if E.db.mMT.portraits.custom.border and (E.db.mMT.portraits.custom.border ~= "") then
											return L["Border"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.border, sizeString)
										else
											return L["Border"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.border
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.border = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture6 = {
									order = 13,
									type = "description",
									name = "\n\n",
								},
								shadow = {
									order = 14,
									desc = L["This is the shadow texture for the portraits."],
									name = function()
										if E.db.mMT.portraits.custom.shadow and (E.db.mMT.portraits.custom.shadow ~= "") then
											return L["Shadow"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.shadow, sizeString)
										else
											return L["Shadow"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.shadow
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.shadow = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture7 = {
									order = 15,
									type = "description",
									name = "\n\n",
								},
								inner = {
									order = 16,
									desc = L["This is the inner shadow texture for the portraits."],
									name = function()
										if E.db.mMT.portraits.custom.inner and (E.db.mMT.portraits.custom.inner ~= "") then
											return L["Inner Shadow"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.inner, sizeString)
										else
											return L["Inner Shadow"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.inner
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.inner = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture8= {
									order = 17,
									type = "description",
									name = "\n\n",
								},
								mask = {
									order = 18,
									desc = L["This is the Mask texture for the portraits. This texture is used to cut out the portrait of the Unit."],
									name = function()
										if E.db.mMT.portraits.custom.mask and (E.db.mMT.portraits.custom.mask ~= "") then
											return L["Mask"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.mask, sizeString)
										else
											return L["Mask"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.mask
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.mask = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								spacer_texture9= {
									order = 19,
									type = "description",
									name = "\n\n",
								},
								maskb = {
									order = 20,
									desc = L["This is the mirrored Mask texture for the portraits. This texture is used to cut out the portrait of the Unit."],
									name = function()
										if E.db.mMT.portraits.custom.maskb and (E.db.mMT.portraits.custom.maskb ~= "") then
											return L["Mirrored Mask"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.maskb, sizeString)
										elseif E.db.mMT.portraits.custom.mask and (E.db.mMT.portraits.custom.mask ~= "") then
											return L["Mirrored Mask"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.mask, sizeString)
										else
											return L["Mirrored Mask"] .. "  > " .. L["No Texture found"]
										end
									end,
									type = "input",
									width = "smal",
									disabled = function()
										return not E.db.mMT.portraits.custom.enable
									end,
									get = function(info)
										return E.db.mMT.portraits.custom.maskb
									end,
									set = function(info, value)
										E.db.mMT.portraits.custom.maskb = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
							},
						},
					},
				},
				header_offset = {
					order = 3,
					type = "group",
					name = L["Portrait Offset/ Zoom"],
					args = {
						range_sq = {
							order = 1,
							name = L["Drop"],
							type = "range",
							min = 0,
							max = 10,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.SQ
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.SQ = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ro = {
							order = 2,
							name = L["Drop round"],
							type = "range",
							min = 0,
							max = 10,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.RO
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.RO = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ci = {
							order = 3,
							name = L["CIRCLE/ MOON"],
							type = "range",
							min = 0,
							max = 10,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.CI
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.CI = value
								E.db.mMT.portraits.offset.MO = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_pi = {
							order = 4,
							name = L["Pad"],
							type = "range",
							min = 0,
							max = 15,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.PI
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.PI = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ra = {
							order = 5,
							name = L["Diamond"],
							type = "range",
							min = 0,
							max = 10,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.RA
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.RA = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_qa = {
							order = 5,
							name = L["Square"],
							type = "range",
							min = 0,
							max = 20,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.QA
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.QA = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_th = {
							order = 6,
							name = L["Thin"],
							type = "range",
							min = 0,
							max = 10,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.TH
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.TH = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_custom = {
							order = 8,
							name = L["Custom"],
							type = "range",
							min = 0,
							max = 60,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.CUSTOM
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.CUSTOM = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						spacer_1 = {
							order = 20,
							type = "description",
							name = "\n\n",
						},
						reset = {
							order = 40,
							type = "execute",
							name = L["Reset"],
							func = function()
								E.db.mMT.portraits.offset = {
									SQ = 5.5,
									RO = 5.5,
									CI = 5.5,
									PI = 10,
									RA = 6,
									QA = 0,
									MO = 5.5,
									TH = 4,
									CUSTOM = 5.5,
								}
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_player = {
			order = 3,
			type = "group",
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
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.player.flippe and E.db.mMT.portraits.player.texture .. "T" or E.db.mMT.portraits.player.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.player.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.player.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.player.texture = "RO"
								else
									E.db.mMT.portraits.player.texture = value
								end
								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_cast = {
							order = 3,
							type = "toggle",
							name = L["Cast Icon"],
							desc = L["Enable Cast Icons"],
							get = function(info)
								return E.db.mMT.portraits.player.cast
							end,
							set = function(info, value)
								E.db.mMT.portraits.player.cast = value
								mMT.Modules.Portraits:Initialize()
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
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

								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 1,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.player.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.player.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 2,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.player.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.player.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_target = {
			order = 4,
			type = "group",
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
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.target.flippe and E.db.mMT.portraits.target.texture .. "T" or E.db.mMT.portraits.target.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.target.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.target.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.target.texture = "RO"
								else
									E.db.mMT.portraits.target.texture = value
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_extra = {
							order = 3,
							type = "toggle",
							name = L["Enable Rare/Elite Border"],
							get = function(info)
								return E.db.mMT.portraits.target.extraEnable
							end,
							set = function(info, value)
								E.db.mMT.portraits.target.extraEnable = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_cast = {
							order = 4,
							type = "toggle",
							name = L["Cast Icon"],
							desc = L["Enable Cast Icons"],
							get = function(info)
								return E.db.mMT.portraits.target.cast
							end,
							set = function(info, value)
								E.db.mMT.portraits.target.cast = value
								mMT.Modules.Portraits:Initialize()
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
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

								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 9,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.target.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.target.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 10,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.target.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.target.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_targettarget = {
			order = 5,
			type = "group",
			name = L["Target of Target"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Target of Target Portraits"],
					get = function(info)
						return E.db.mMT.portraits.targettarget.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.targettarget.enable = value
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						toggle_extra = {
							order = 1,
							type = "toggle",
							name = L["Enable Rare/Elite Border"],
							get = function(info)
								return E.db.mMT.portraits.targettarget.extraEnable
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.extraEnable = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						select_style = {
							order = 2,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.targettarget.flippe and E.db.mMT.portraits.targettarget.texture .. "T" or E.db.mMT.portraits.targettarget.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.targettarget.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.targettarget.texture = "RO"
								else
									E.db.mMT.portraits.targettarget.texture = value
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
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
								return E.db.mMT.portraits.targettarget.size
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.size = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
							type = "select",
							name = L["Anchor Point"],
							get = function(info)
								return E.db.mMT.portraits.targettarget.relativePoint
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.relativePoint = value
								if value == "LEFT" then
									E.db.mMT.portraits.targettarget.point = "RIGHT"
									E.db.mMT.portraits.targettarget.mirror = false
								elseif value == "RIGHT" then
									E.db.mMT.portraits.targettarget.point = "LEFT"
									E.db.mMT.portraits.targettarget.mirror = true
								else
									E.db.mMT.portraits.targettarget.point = value
									E.db.mMT.portraits.targettarget.mirror = false
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
							name = L["X offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.targettarget.x
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.x = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
							name = L["Y offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.targettarget.y
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.y = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 1,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.targettarget.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 2,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.targettarget.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_pet = {
			order = 6,
			type = "group",
			name = L["Pet"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Pet Portraits"],
					get = function(info)
						return E.db.mMT.portraits.pet.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.pet.enable = value
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.pet.flippe and E.db.mMT.portraits.pet.texture .. "T" or E.db.mMT.portraits.pet.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.pet.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.pet.texture = "RO"
								else
									E.db.mMT.portraits.pet.texture = value
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 256,
							step = 1,
							softMin = 16,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.pet.size
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.size = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
							type = "select",
							name = L["Anchor Point"],
							get = function(info)
								return E.db.mMT.portraits.pet.relativePoint
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.relativePoint = value
								if value == "LEFT" then
									E.db.mMT.portraits.pet.point = "RIGHT"
									E.db.mMT.portraits.pet.mirror = false
								elseif value == "RIGHT" then
									E.db.mMT.portraits.pet.point = "LEFT"
									E.db.mMT.portraits.pet.mirror = true
								else
									E.db.mMT.portraits.pet.point = value
									E.db.mMT.portraits.pet.mirror = false
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
							name = L["X offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.pet.x
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.x = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
							name = L["Y offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.pet.y
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.y = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 1,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.pet.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 2,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.pet.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_focus = {
			order = 7,
			type = "group",
			name = L["Focus"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Focus Portraits"],
					get = function(info)
						return E.db.mMT.portraits.focus.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.focus.enable = value
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.focus.flippe and E.db.mMT.portraits.focus.texture .. "T" or E.db.mMT.portraits.focus.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.focus.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.focus.texture = "RO"
								else
									E.db.mMT.portraits.focus.texture = value
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 256,
							step = 1,
							softMin = 16,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.focus.size
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.size = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_extra = {
							order = 3,
							type = "toggle",
							name = L["Enable Rare/Elite Border"],
							get = function(info)
								return E.db.mMT.portraits.focus.extraEnable
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.extraEnable = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_cast = {
							order = 4,
							type = "toggle",
							name = L["Cast Icon"],
							desc = L["Enable Cast Icons"],
							get = function(info)
								return E.db.mMT.portraits.focus.cast
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.cast = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
							type = "select",
							name = L["Anchor Point"],
							get = function(info)
								return E.db.mMT.portraits.focus.relativePoint
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.relativePoint = value
								if value == "LEFT" then
									E.db.mMT.portraits.focus.point = "RIGHT"
									E.db.mMT.portraits.focus.mirror = false
								elseif value == "RIGHT" then
									E.db.mMT.portraits.focus.point = "LEFT"
									E.db.mMT.portraits.focus.mirror = true
								else
									E.db.mMT.portraits.focus.point = value
									E.db.mMT.portraits.focus.mirror = false
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
							name = L["X offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.focus.x
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.x = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
							name = L["Y offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.focus.y
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.y = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 1,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.focus.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 2,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.focus.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_party = {
			order = 8,
			type = "group",
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
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.party.flippe and E.db.mMT.portraits.party.texture .. "T" or E.db.mMT.portraits.party.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.party.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.party.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.party.texture = "RO"
								else
									E.db.mMT.portraits.party.texture = value
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_cast = {
							order = 3,
							type = "toggle",
							name = L["Cast Icon"],
							desc = L["Enable Cast Icons"],
							get = function(info)
								return E.db.mMT.portraits.party.cast
							end,
							set = function(info, value)
								E.db.mMT.portraits.party.cast = value
								mMT.Modules.Portraits:Initialize()
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
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

								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
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
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 1,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.party.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.party.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 2,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.party.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.party.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_boss = {
			order = 9,
			type = "group",
			name = L["Boss"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Boss Portraits"],
					get = function(info)
						return E.db.mMT.portraits.boss.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.boss.enable = value
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.boss.flippe and E.db.mMT.portraits.boss.texture .. "T" or E.db.mMT.portraits.boss.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.boss.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.boss.texture = "RO"
								else
									E.db.mMT.portraits.boss.texture = value
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 256,
							step = 1,
							softMin = 16,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.boss.size
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.size = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_cast = {
							order = 3,
							type = "toggle",
							name = L["Cast Icon"],
							desc = L["Enable Cast Icons"],
							get = function(info)
								return E.db.mMT.portraits.boss.cast
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.cast = value
								mMT.Modules.Portraits:Initialize()
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
							type = "select",
							name = L["Anchor Point"],
							get = function(info)
								return E.db.mMT.portraits.boss.relativePoint
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.relativePoint = value
								if value == "LEFT" then
									E.db.mMT.portraits.boss.point = "RIGHT"
									E.db.mMT.portraits.boss.mirror = false
								elseif value == "RIGHT" then
									E.db.mMT.portraits.boss.point = "LEFT"
									E.db.mMT.portraits.boss.mirror = true
								else
									E.db.mMT.portraits.boss.point = value
									E.db.mMT.portraits.boss.mirror = false
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
							name = L["X offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.boss.x
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.x = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
							name = L["Y offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.boss.y
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.y = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 1,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.boss.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 2,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.boss.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_arena = {
			order = 10,
			type = "group",
			name = L["Arena"],
			args = {
				toggle_enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Arena Portraits"],
					get = function(info)
						return E.db.mMT.portraits.arena.enable
					end,
					set = function(info, value)
						E.db.mMT.portraits.arena.enable = value
						mMT.Modules.Portraits:Initialize()
					end,
				},
				general = {
					order = 2,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						select_style = {
							order = 1,
							type = "select",
							name = L["Texture Form"],
							get = function(info)
								return E.db.mMT.portraits.arena.flippe and E.db.mMT.portraits.arena.texture .. "T" or E.db.mMT.portraits.arena.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.flippe = (value == "SQT" or value == "ROT")
								if value == "SQT" then
									E.db.mMT.portraits.arena.texture = "SQ"
								elseif value == "ROT" then
									E.db.mMT.portraits.arena.texture = "RO"
								else
									E.db.mMT.portraits.arena.texture = value
								end

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 256,
							step = 1,
							softMin = 16,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.arena.size
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.size = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_cast = {
							order = 3,
							type = "toggle",
							name = L["Cast Icon"],
							desc = L["Enable Cast Icons"],
							get = function(info)
								return E.db.mMT.portraits.arena.cast
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.cast = value
								mMT.Modules.Portraits:Initialize()
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				anchor = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Anchor"],
					args = {
						select_anchor = {
							order = 1,
							type = "select",
							name = L["Anchor Point"],
							get = function(info)
								return E.db.mMT.portraits.arena.relativePoint
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.relativePoint = value
								if value == "LEFT" then
									E.db.mMT.portraits.arena.point = "RIGHT"
									E.db.mMT.portraits.arena.mirror = false
								elseif value == "RIGHT" then
									E.db.mMT.portraits.arena.point = "LEFT"
									E.db.mMT.portraits.arena.mirror = true
								else
									E.db.mMT.portraits.arena.point = value
									E.db.mMT.portraits.arena.mirror = false
								end
								mMT.Modules.Portraits:Initialize()
							end,
							values = {
								LEFT = "LEFT",
								RIGHT = "RIGHT",
								CENTER = "CENTER",
							},
						},
						range_ofsX = {
							order = 2,
							name = L["X offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.arena.x
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.x = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_ofsY = {
							order = 3,
							name = L["Y offset"],
							type = "range",
							min = -256,
							max = 256,
							step = 1,
							softMin = -256,
							softMax = 256,
							get = function(info)
								return E.db.mMT.portraits.arena.y
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.y = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				level = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Frame Level"],
					args = {
						select_strata = {
							order = 1,
							type = "select",
							name = L["Frame Strata"],
							get = function(info)
								return E.db.mMT.portraits.arena.strata
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.strata = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = frameStrata,
						},
						range_level = {
							order = 2,
							name = L["Frame Level"],
							type = "range",
							min = 0,
							max = 1000,
							step = 1,
							softMin = 0,
							softMax = 1000,
							get = function(info)
								return E.db.mMT.portraits.arena.level
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.level = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_shadow = {
			order = 11,
			type = "group",
			name = L["Shadow/ Border"],
			args = {
				shadow = {
					order = 0,
					type = "group",
					inline = true,
					name = L["Shadow"],
					args = {
						toggle_shadow = {
							order = 1,
							type = "toggle",
							name = L["Shadow"],
							desc = L["Enable Shadow"],
							get = function(info)
								return E.db.mMT.portraits.shadow.enable
							end,
							set = function(info, value)
								E.db.mMT.portraits.shadow.enable = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						color_shadow = {
							type = "color",
							order = 2,
							name = L["Shadow Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.shadow.color
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.shadow.color
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				innershadow = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Inner Shadow"],
					args = {
						toggle_inner = {
							order = 4,
							type = "toggle",
							name = L["Inner Shadow"],
							desc = L["Enable Inner Shadow"],
							get = function(info)
								return E.db.mMT.portraits.shadow.inner
							end,
							set = function(info, value)
								E.db.mMT.portraits.shadow.inner = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						color_inner = {
							type = "color",
							order = 5,
							name = L["Inner Shadow Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.shadow.innerColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.shadow.innerColor
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				borders = {
					order = 6,
					type = "group",
					inline = true,
					name = L["Borders"],
					args = {
						toggle_border = {
							order = 7,
							type = "toggle",
							name = L["Border"],
							desc = L["Enable Borders"],
							get = function(info)
								return E.db.mMT.portraits.shadow.border
							end,
							set = function(info, value)
								E.db.mMT.portraits.shadow.border = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						color_border = {
							type = "color",
							order = 8,
							name = L["Border Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.shadow.borderColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.shadow.borderColor
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT.Modules.Portraits:Initialize()
							end,
						},
						color_rareborder = {
							type = "color",
							order = 9,
							name = L["Rare Border Color"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.shadow.borderColorRare
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.shadow.borderColorRare
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
				background = {
					order = 10,
					type = "group",
					inline = true,
					name = L["Background"],
					args = {
						color_background = {
							type = "color",
							order = 11,
							name = L["Background color for Icons"],
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.shadow.background
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.shadow.background
								t.r, t.g, t.b, t.a = r, g, b, a
								mMT.Modules.Portraits:Initialize()
							end,
						},
						toggle_classbg = {
							order = 12,
							type = "toggle",
							name = L["Class colored Background"],
							desc = L["Enable Class colored Background"],
							get = function(info)
								return E.db.mMT.portraits.shadow.classBG
							end,
							set = function(info, value)
								E.db.mMT.portraits.shadow.classBG = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
						range_bgColorShift = {
							order = 14,
							name = L["Background color shift"],
							type = "range",
							min = 0,
							max = 1,
							step = 0.01,
							softMin = 0,
							softMax = 1,
							disabled = function()
								return not E.db.mMT.portraits.shadow.classBG
							end,
							get = function(info)
								return E.db.mMT.portraits.shadow.bgColorShift
							end,
							set = function(info, value)
								E.db.mMT.portraits.shadow.bgColorShift = value
								mMT.Modules.Portraits:Initialize()
							end,
						},
					},
				},
			},
		},
		header_colors = {
			order = 12,
			type = "group",
			name = L["Colors"],
			args = {
				execute_apply = {
					order = 1,
					type = "execute",
					name = L["Apply"],
					func = function()
						mMT.Modules.Portraits:Initialize()
					end,
				},
				toggle_default = {
					order = 2,
					type = "toggle",
					name = L["Use only Default Color"],
					desc = L["Uses for every Unit the Default Color."],
					get = function(info)
						return E.db.mMT.portraits.general.default
					end,
					set = function(info, value)
						E.db.mMT.portraits.general.default = value
						mMT.Modules.Portraits:Initialize()
					end,
				},
				toggle_reaction = {
					order = 2,
					type = "toggle",
					name = L["Force reaction color"],
					desc = L["Forces reaction color for all Units."],
					get = function(info)
						return E.db.mMT.portraits.general.reaction
					end,
					set = function(info, value)
						E.db.mMT.portraits.general.reaction = value
						mMT.Modules.Portraits:Initialize()
					end,
				},
				DEATHKNIGHT = {
					order = 3,
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
					order = 4,
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
					order = 5,
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
					order = 6,
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
					order = 7,
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
					order = 8,
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
					order = 9,
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
					order = 10,
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
					order = 11,
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
					order = 12,
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
					order = 13,
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
					order = 14,
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
					order = 15,
					type = "group",
					inline = true,
					name = L["WARRIOR"],
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
					order = 16,
					type = "group",
					inline = true,
					name = L["DEFAULT"],
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
					order = 17,
					type = "group",
					inline = true,
					name = L["RARE"],
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
				rareelite = {
					order = 18,
					type = "group",
					inline = true,
					name = L["RARE ELITE"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.rareelite.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.rareelite.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.rareelite.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.rareelite.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				elite = {
					order = 19,
					type = "group",
					inline = true,
					name = L["ELITE"],
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
					order = 20,
					type = "group",
					inline = true,
					name = L["ENEMY"],
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
					order = 21,
					type = "group",
					inline = true,
					name = L["NEUTRAL"],
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
					order = 22,
					type = "group",
					inline = true,
					name = L["FRIENDLY"],
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
