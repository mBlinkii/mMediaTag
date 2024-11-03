local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

local aspectRatios = {
	["3:2"] = "3:2",
	["4:3"] = "4:3",
	["16:8"] = "16:8",
	["16:9"] = "16:9",
	["16:10"] = "16:10",
}

local skins = {
	circle = "circle",
	drop = "drop",
	drop_round = "drop round",
	hexagon = "hexagon",
	octagon = "octagon",
	paralelogram = "paralelogram",
	paralelogram_horizontal = "paralelogram horizontal",
	zickzag = "zickzag",
	antique = "antique",
}

local sizeString = ":16:16:0:0:64:64:4:60:4:60"

local function configTable()
	E.Options.args.mMT.args.cosmetic.args.minimap.args = {
		aspectratio = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Aspect ratio"],
			disabled = function()
				return E.db.mMT.minimapSkin.enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.minimapAspectRatio.enable
					end,
					set = function(info, value)
						E.db.mMT.minimapAspectRatio.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				settings = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Settings"],
					disabled = function()
						return not E.db.mMT.minimapAspectRatio.enable or E.db.mMT.minimapSkin.enable
					end,
					args = {
						desc_note = {
							order = 1,
							type = "description",
							name = L["If the minimap is too close to the edge, a bar may become visible at the top or bottom. This is due to Blizzard’s limitations."],
						},
						aspectratio = {
							order = 2,
							type = "select",
							name = L["Aspect ratio"],
							values = aspectRatios,
							get = function(info)
								return E.db.mMT.minimapAspectRatio.aspectRatio
							end,
							set = function(info, value)
								E.db.mMT.minimapAspectRatio.aspectRatio = value
								mMT.Modules.MinimapAspectRatio:Initialize()
							end,
						},
					},
				},
			},
		},
		skin = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Skin"],
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.minimapSkin.enable
					end,
					set = function(info, value)
						E.db.mMT.minimapSkin.enable = value
						if value then E.db.mMT.minimapAspectRatio.enable = false end
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				settings = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Settings"],
					disabled = function()
						return not E.db.mMT.minimapSkin.enable
					end,
					args = {
						skin = {
							order = 1,
							type = "select",
							name = L["Style"],
							values = skins,
							get = function(info)
								return E.db.mMT.minimapSkin.skin
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.skin = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
						cardinal = {
							order = 2,
							type = "toggle",
							name = L["Cardinal Points"],
							get = function(info)
								return E.db.mMT.minimapSkin.cardinal
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.cardinal = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
						effect = {
							order = 3,
							type = "toggle",
							name = L["Effect"],
							get = function(info)
								return E.db.mMT.minimapSkin.effect
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.effect = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
					},
				},
				color = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return not E.db.mMT.minimapSkin.enable
					end,
					args = {
						texture = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Texture"],
							args = {
								color = {
									order = 1,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.minimapSkin.colors.texture.color
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.minimapSkin.colors.texture.color
										t.r, t.g, t.b, t.a = r, g, b, a
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
								calss = {
									order = 2,
									type = "toggle",
									name = L["Class colored"],
									get = function(info)
										return E.db.mMT.minimapSkin.colors.texture.class
									end,
									set = function(info, value)
										E.db.mMT.minimapSkin.colors.texture.class = value
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
							},
						},
						cardinal = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Cardinal Point"],
							args = {
								color = {
									order = 1,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.minimapSkin.colors.cardinal.color
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.minimapSkin.colors.cardinal.color
										t.r, t.g, t.b, t.a = r, g, b, a
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
								calss = {
									order = 2,
									type = "toggle",
									name = L["Class colored"],
									get = function(info)
										return E.db.mMT.minimapSkin.colors.cardinal.class
									end,
									set = function(info, value)
										E.db.mMT.minimapSkin.colors.cardinal.class = value
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
							},
						},
						extra = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Effect"],
							args = {
								color = {
									order = 1,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.minimapSkin.colors.extra.color
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.minimapSkin.colors.extra.color
										t.r, t.g, t.b, t.a = r, g, b, a
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
								calss = {
									order = 2,
									type = "toggle",
									name = L["Class colored"],
									get = function(info)
										return E.db.mMT.minimapSkin.colors.extra.class
									end,
									set = function(info, value)
										E.db.mMT.minimapSkin.colors.extra.class = value
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
							},
						},
					},
				},
				custom = {
					order = 4,
					type = "group",
					name = L["Custom Textures"],
					inline = true,
					args = {
						toggle_enable = {
							order = 1,
							type = "toggle",
							name = L["Enable Custom Textures"],
							get = function(info)
								return E.db.mMT.minimapSkin.custom.enable
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.custom.enable = value
								mMT.Modules.MinimapSkin:Initialize()
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
							name = L["Info! To achieve an optimal result with the minimap, a texture should be set for the texture and mask.\nThe mask is always required and no minimap will be visible without it.\n\n"],
						},

						texture = {
							order = 4,
							desc = L["Texture"],
							name = function()
								if E.db.mMT.minimapSkin.custom.texture and (E.db.mMT.minimapSkin.custom.texture ~= "") then
									return L["Texture"] .. "  > " .. E:TextureString(E.db.mMT.minimapSkin.custom.texture, sizeString)
								else
									return L["Texture"] .. "  > " .. L["No Texture found"]
								end
							end,
							type = "input",
							width = "smal",
							disabled = function()
								return not E.db.mMT.minimapSkin.custom.enable
							end,
							get = function(info)
								return E.db.mMT.minimapSkin.custom.texture
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.custom.texture = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
						mask = {
							order = 5,
							desc = L["Mask"],
							name = function()
								if E.db.mMT.minimapSkin.custom.mask and (E.db.mMT.minimapSkin.custom.mask ~= "") then
									return L["Mask"] .. "  > " .. E:TextureString(E.db.mMT.minimapSkin.custom.mask, sizeString)
								else
									return L["Mask"] .. "  > " .. L["No Texture found"]
								end
							end,
							type = "input",
							width = "smal",
							disabled = function()
								return not E.db.mMT.minimapSkin.custom.enable
							end,
							get = function(info)
								return E.db.mMT.minimapSkin.custom.mask
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.custom.mask = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
						cardinal = {
							order = 6,
							desc = L["Cardinal Point"],
							name = function()
								if E.db.mMT.minimapSkin.custom.cardinal and (E.db.mMT.minimapSkin.custom.cardinal ~= "") then
									return L["Cardinal Point"] .. "  > " .. E:TextureString(E.db.mMT.minimapSkin.custom.cardinal, sizeString)
								else
									return L["Cardinal Point"] .. "  > " .. L["No Texture found"]
								end
							end,
							type = "input",
							width = "smal",
							disabled = function()
								return not E.db.mMT.minimapSkin.custom.enable
							end,
							get = function(info)
								return E.db.mMT.minimapSkin.custom.cardinal
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.custom.cardinal = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
						effect = {
							order = 7,
							desc = L["Effect"],
							name = function()
								if E.db.mMT.minimapSkin.custom.extra and (E.db.mMT.minimapSkin.custom.extra ~= "") then
									return L["Effect"] .. "  > " .. E:TextureString(E.db.mMT.minimapSkin.custom.extra, sizeString)
								else
									return L["Effect"] .. "  > " .. L["No Texture found"]
								end
							end,
							type = "input",
							width = "smal",
							disabled = function()
								return not E.db.mMT.minimapSkin.custom.enable
							end,
							get = function(info)
								return E.db.mMT.minimapSkin.custom.extra
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.custom.extra = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
