local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

local form = {
	SQ = L["Old"] .. " " .. L["Drop"],
	RO = L["Old"] .. " " .. L["Drop round"],
	CI = L["Old"] .. " " .. L["Circle"],
	PI = L["Old"] .. " " .. L["Pad"],
	RA = L["Old"] .. " " .. L["Diamond"],
	QA = L["Old"] .. " " .. L["Square"],
	MO = L["Old"] .. " " .. L["Moon"],
	SQT = L["Old"] .. " " .. L["Drop flipped"],
	ROT = L["Old"] .. " " .. L["Drop round flipped"],
	TH = L["Old"] .. " " .. L["Thin"],
	circle = L["Circle"],
	diamond = L["Diamond"],
	drop = L["Drop round"],
	dropsharp = L["Drop"],
	dropflipp = L["Drop round flipped"],
	dropsharpflipp = L["Drop flipped"],
	octagon = L["Octagon"],
	pad = L["Pad"],
	pure = L["Pure round"],
	puresharp = L["Pure"],
	shield = L["Shield"],
	square = L["Square"],
	thin = L["Thin"],
}

local style = {
	a = "FLAT",
	b = "SMOOTH",
	c = "METALLIC",
}

local extraStyle = {
	a = L["Style"] .. " A",
	b = L["Style"] .. " B",
	c = L["Style"] .. " C",
	d = L["Style"] .. " D",
	e = L["Style"] .. " E",
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
	for iconStyle, value in pairs(mMT.classIcons) do
		ClassIconStyle[iconStyle] = value.name
	end
end

function BuildCustomTexturesTable()
	for textureStyle, value in pairs(mMT.Media.CustomPortraits) do
		form[textureStyle] = value.name
	end
end

local function configTable()
	local sizeString = ":16:16:0:0:64:64:4:60:4:60"

	BuildIconStylesTable()
	BuildCustomTexturesTable()

	E.Options.args.mMT.args.unitframes.args.portraits.args = {
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
										mMT.Modules.Portraits:Initialize()
										E:StaticPopup_Show("CONFIG_RL")
									end,
									values = ClassIconStyle,
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
						misc = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Misc"],
							args = {
								toggle_classicon = {
									order = 1,
									type = "toggle",
									name = L["Trilinear Filtering"],
									get = function(info)
										return E.db.mMT.portraits.general.trilinear
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.trilinear = value
										mMT.Modules.Portraits:Initialize()
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
							},
						},
					},
				},
				header_style = {
					order = 2,
					type = "group",
					name = L["Textures & Styles"],
					args = {
						header_portrait_texture = {
							order = 1,
							type = "group",
							name = L["Portrait Texture"],
							inline = true,
							args = {
								desc_note = {
									order = 1,
									type = "description",
									name = L["This works only with the mMT Textures for Portraits."],
								},
								select_style = {
									order = 2,
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
									order = 3,
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
							},
						},
						header_rare_texture = {
							order = 2,
							type = "group",
							name = L["Extra Texture Style"],
							inline = true,
							args = {
								desc_note = {
									order = 1,
									type = "description",
									name = L["Info! These styles are only available for the new textures."],
								},
								desc_note2 = {
									order = 2,
									type = "description",
									name = L["This works only with the mMT Textures for Portraits."],
								},
								desc_space = {
									order = 3,
									type = "description",
									name = "\n\n",
								},
								select_style_rare = {
									order = 4,
									type = "select",
									name = L["Rare Texture Style"],
									get = function(info)
										return E.db.mMT.portraits.extra.rare
									end,
									set = function(info, value)
										E.db.mMT.portraits.extra.rare = value
										mMT.Modules.Portraits:Initialize()
									end,
									values = extraStyle,
								},
								select_style_elite = {
									order = 5,
									type = "select",
									name = L["Elite/ Rare Elite Texture Style"],
									get = function(info)
										return E.db.mMT.portraits.extra.elite
									end,
									set = function(info, value)
										E.db.mMT.portraits.extra.elite = value
										mMT.Modules.Portraits:Initialize()
									end,
									values = extraStyle,
								},
								select_style_boss = {
									order = 6,
									type = "select",
									name = L["Boss Texture Style"],
									get = function(info)
										return E.db.mMT.portraits.extra.boss
									end,
									set = function(info, value)
										E.db.mMT.portraits.extra.boss = value
										mMT.Modules.Portraits:Initialize()
									end,
									values = extraStyle,
								},
								toggle_color = {
									order = 7,
									type = "toggle",
									name = L["Use Texture Color"],
									get = function(info)
										return E.db.mMT.portraits.general.usetexturecolor
									end,
									set = function(info, value)
										E.db.mMT.portraits.general.usetexturecolor = value
										mMT.Modules.Portraits:Initialize()
									end,
								},
							},
						},
						header_bgtexture = {
							order = 4,
							type = "group",
							name = L["Background Texture"],
							inline = true,
							args = {
								select_texture = {
									order = 3,
									type = "select",
									name = L["Background Texture"],
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
						custom = {
							order = 5,
							type = "group",
							name = L["Custom Portrait Textures"],
							inline = true,
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
								desc_note1 = {
									order = 4,
									type = "description",
									name = L["If your texture or the cutout for the portrait is not symmetrical in the middle, you need a 2nd mask texture, which must be exactly mirror-inverted. Use the 2nd mask texture for this."],
								},
								main = {
									order = 5,
									type = "group",
									name = L["Main Textures"],
									inline = true,
									args = {
										texture = {
											order = 1,
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
										mask = {
											order = 2,
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
									},
								},
								desc_note2 = {
									order = 6,
									type = "description",
									name = L["Optional textures, these textures are not mandatory, but improve the appearance of the portraits."],
								},
								spacer_texture2 = {
									order = 7,
									type = "description",
									name = "\n\n",
								},
								optional = {
									order = 8,
									type = "group",
									name = L["Optional Textures"],
									inline = true,
									args = {
										border = {
											order = 1,
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
										shadow = {
											order = 2,
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
										inner = {
											order = 3,
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
									},
								},
								rare = {
									order = 9,
									type = "group",
									name = L["Rare Textures"],
									inline = true,
									args = {
										rare = {
											order = 1,
											desc = L["This is the Rare texture for the portraits."],
											name = function()
												if E.db.mMT.portraits.custom.extra and (E.db.mMT.portraits.custom.extra ~= "") then
													return L["Rare"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.extra, sizeString)
												else
													return L["Rare"] .. "  > " .. L["No Texture found"]
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
										rare_border = {
											order = 2,
											desc = L["This is the Border texture for the Rare texture."],
											name = function()
												if E.db.mMT.portraits.custom.extraborder and (E.db.mMT.portraits.custom.extraborder ~= "") then
													return L["Rare - Border"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.extraborder, sizeString)
												else
													return L["Rare - Border"] .. "  > " .. L["No Texture found"]
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
										rare_shadow = {
											order = 3,
											desc = L["This is the shadow texture for the Rare texture."],
											name = function()
												if E.db.mMT.portraits.custom.extrashadow and (E.db.mMT.portraits.custom.extrashadow ~= "") then
													return L["Rare - Shadow"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.extrashadow, sizeString)
												else
													return L["Rare - Shadow"] .. "  > " .. L["No Texture found"]
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
									},
								},
								elite = {
									order = 10,
									type = "group",
									name = L["Elite Textures"],
									inline = true,
									args = {
										elite = {
											order = 1,
											desc = L["This is the Elite texture for the portraits."],
											name = function()
												if E.db.mMT.portraits.custom.elite and (E.db.mMT.portraits.custom.elite ~= "") then
													return L["Elite"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.elite, sizeString)
												else
													return L["Elite"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mMT.portraits.custom.enable
											end,
											get = function(info)
												return E.db.mMT.portraits.custom.elite
											end,
											set = function(info, value)
												E.db.mMT.portraits.custom.elite = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										elite_border = {
											order = 2,
											desc = L["This is the Border texture for the Elite texture."],
											name = function()
												if E.db.mMT.portraits.custom.eliteborder and (E.db.mMT.portraits.custom.eliteborder ~= "") then
													return L["Elite - Border"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.eliteborder, sizeString)
												else
													return L["Elite - Border"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mMT.portraits.custom.enable
											end,
											get = function(info)
												return E.db.mMT.portraits.custom.eliteborder
											end,
											set = function(info, value)
												E.db.mMT.portraits.custom.eliteborder = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										elite_shadow = {
											order = 3,
											desc = L["This is the shadow texture for the Elite texture."],
											name = function()
												if E.db.mMT.portraits.custom.eliteshadow and (E.db.mMT.portraits.custom.eliteshadow ~= "") then
													return L["Elite - Shadow"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.eliteshadow, sizeString)
												else
													return L["Elite - Shadow"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mMT.portraits.custom.enable
											end,
											get = function(info)
												return E.db.mMT.portraits.custom.eliteshadow
											end,
											set = function(info, value)
												E.db.mMT.portraits.custom.eliteshadow = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
								boss = {
									order = 12,
									type = "group",
									name = L["Boss Textures"],
									inline = true,
									args = {
										rare = {
											order = 1,
											desc = L["This is the Boss texture for the portraits."],
											name = function()
												if E.db.mMT.portraits.custom.boss and (E.db.mMT.portraits.custom.boss ~= "") then
													return L["Boss"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.boss, sizeString)
												else
													return L["Boss"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mMT.portraits.custom.enable
											end,
											get = function(info)
												return E.db.mMT.portraits.custom.boss
											end,
											set = function(info, value)
												E.db.mMT.portraits.custom.boss = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										boss_border = {
											order = 2,
											desc = L["This is the Border texture for the Boss texture."],
											name = function()
												if E.db.mMT.portraits.custom.bossborder and (E.db.mMT.portraits.custom.bossborder ~= "") then
													return L["Boss - Border"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.bossborder, sizeString)
												else
													return L["Boss - Border"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mMT.portraits.custom.enable
											end,
											get = function(info)
												return E.db.mMT.portraits.custom.bossborder
											end,
											set = function(info, value)
												E.db.mMT.portraits.custom.bossborder = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										boss_shadow = {
											order = 3,
											desc = L["This is the shadow texture for the Boss texture."],
											name = function()
												if E.db.mMT.portraits.custom.bossshadow and (E.db.mMT.portraits.custom.bossshadow ~= "") then
													return L["Boss - Shadow"] .. "  > " .. E:TextureString(E.db.mMT.portraits.custom.bossshadow, sizeString)
												else
													return L["Boss - Shadow"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mMT.portraits.custom.enable
											end,
											get = function(info)
												return E.db.mMT.portraits.custom.bossshadow
											end,
											set = function(info, value)
												E.db.mMT.portraits.custom.bossshadow = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
								mask_b = {
									order = 13,
									type = "group",
									name = L["Second Mask Texture"],
									inline = true,
									args = {
										maskb = {
											order = 1,
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
						range_octa = {
							order = 7,
							name = L["New Textures"],
							type = "range",
							min = 0,
							max = 10,
							step = 0.1,
							get = function(info)
								return E.db.mMT.portraits.offset.new
							end,
							set = function(info, value)
								E.db.mMT.portraits.offset.new = value
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
									new = 2.5,
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
								return E.db.mMT.portraits.player.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.player.texture = value
								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								mMT.Modules.Portraits:Initialize(true)
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
								return E.db.mMT.portraits.target.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.target.texture = value

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								mMT.Modules.Portraits:Initialize(true)
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
								return E.db.mMT.portraits.targettarget.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.targettarget.texture = value

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								return E.db.mMT.portraits.pet.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.pet.texture = value

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								return E.db.mMT.portraits.focus.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.focus.texture = value

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								mMT.Modules.Portraits:Initialize(true)
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
								return E.db.mMT.portraits.party.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.party.texture = value

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								mMT.Modules.Portraits:Initialize(true)
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
								return E.db.mMT.portraits.boss.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.boss.texture = value

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								mMT.Modules.Portraits:Initialize(true)
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
								return E.db.mMT.portraits.arena.texture
							end,
							set = function(info, value)
								E.db.mMT.portraits.arena.texture = value

								mMT.Modules.Portraits:Initialize()
							end,
							values = form,
						},
						range_size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 16,
							max = 512,
							step = 1,
							softMin = 16,
							softMax = 512,
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
								mMT.Modules.Portraits:Initialize(true)
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
				boss = {
					order = 20,
					type = "group",
					inline = true,
					name = L["BOSS"],
					args = {
						color_a = {
							type = "color",
							order = 1,
							name = "A",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.boss.a
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.boss.a
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						color_b = {
							type = "color",
							order = 2,
							name = "B",
							hasAlpha = true,
							get = function(info)
								local t = E.db.mMT.portraits.colors.boss.b
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mMT.portraits.colors.boss.b
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
					},
				},
				enemy = {
					order = 21,
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
					order = 22,
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
					order = 23,
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
