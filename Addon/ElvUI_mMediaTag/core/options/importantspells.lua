local E = unpack(ElvUI)
local L = mMT.Locales

local LSM = LibStub("LibSharedMedia-3.0")

local tinsert = tinsert
local SelectedSpellID = nil
local valuesSpellIDs = {}
local exportText = nil
local importText = ""
local button = "none"
local dummyColor = { r = 1, g = 1, b = 1 }
local filterList = {}

local function UpdateTableSpellIDs(tbl)
	if tbl then
		wipe(valuesSpellIDs)
		for key, _ in pairs(tbl) do
			valuesSpellIDs[key] = key
		end
	end
end

local function UpdateFilterList()
	wipe(filterList)
	for key, _ in pairs(E.db.mMT.importantspells.spells) do
		filterList[key] = key
	end
end

local Selectedfilter = nil

-- local newDBentry = {
-- 	enable = true,
-- 	IDs = {},
-- 	color = { enable = true, a = { r = 1, g = 1, b = 1 }, b = { r = 1, g = 1, b = 1 } },
-- 	sound = { enable = false, file = nil, target = true },
-- 	texture = { enable = false, texture = "ElvUI Blank" },
-- 	icon = {
-- 		enable = false,
-- 		color = { r = 1, g = 1, b = 1 },
-- 		icon = nil,
-- 		size = { auto = true, sizeXY = 32 },
-- 		anchor = { auto = true, point = "CENTER", posX = 0, posY = 0 },
-- 	},
-- }

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.Castbar) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.castbar.args.important.args = {
		toggle_importantspells = {
			order = 1,
			type = "toggle",
			name = L["Enable Important Spells"],
			desc = L["Enable Important Spells module."],
			get = function(info)
				return E.db.mMT.importantspells.enable
			end,
			set = function(info, value)
				E.db.mMT.importantspells.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		header_settings = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
				np = {
					order = 1,
					type = "toggle",
					name = L["Enable on Nameplates"],
					desc = L["Enable this module on Nameplates."],
					get = function(info)
						return E.db.mMT.importantspells.np
					end,
					set = function(info, value)
						E.db.mMT.importantspells.np = value
					end,
				},
				uf = {
					order = 2,
					type = "toggle",
					name = L["Enable on Unitframes"],
					desc = L["Enable this module on Unitframes."],
					get = function(info)
						return E.db.mMT.importantspells.uf
					end,
					set = function(info, value)
						E.db.mMT.importantspells.uf = value
					end,
				},
				gradient = {
					order = 3,
					type = "toggle",
					name = L["Gradient  Mode"],
					desc = L["Enable Gradient colors, this will use the second color."],
					get = function(info)
						return E.db.mMT.importantspells.gradient
					end,
					set = function(info, value)
						E.db.mMT.importantspells.gradient = value
					end,
				},
			},
		},
		header_Filter = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Spell Filters"],
			args = {
				newfilter = {
					order = 1,
					name = L["Filter Name"],
					desc = L["Enter a name for your filter."],
					type = "input",
					width = "smal",
					set = function(info, value)
						if not E.db.mMT.importantspells.spells[value] then
							E.db.mMT.importantspells.spells[value] = {
								enable = true,
								IDs = {},
								functions = {
									color = { enable = true, a = { r = 1, g = 1, b = 1 }, b = { r = 1, g = 1, b = 1 } },
									sound = { enable = false, file = nil, target = true },
									texture = { enable = false, texture = "ElvUI Blank" },
									icon = {
										enable = false,
										color = { r = 1, g = 1, b = 1 },
										icon = nil,
										size = { auto = true, sizeXY = 32 },
										anchor = { auto = true, point = "CENTER", posX = 0, posY = 0 },
									},
								},
							}
						end

						Selectedfilter = value
						SelectedSpellID = nil
						wipe(valuesSpellIDs)
						mMT.Modules.ImportantSpells:Initialize()
					end,
				},
				filterTable = {
					type = "select",
					order = 2,
					name = L["Spell Filters"],
					desc = L["Select the filter to edit."],
					values = function()
						UpdateFilterList()
						return filterList
					end,
					get = function(info)
						return Selectedfilter
					end,
					set = function(info, value)
						Selectedfilter = value
						SelectedSpellID = nil
						wipe(valuesSpellIDs)
					end,
				},
				Deletefilter = {
					type = "select",
					order = 3,
					name = L["Delete filter"],
					desc = L["Select a filter to delete."],
					values = function()
						UpdateFilterList()
						return filterList
					end,
					set = function(info, value)
						if E.db.mMT.importantspells.spells[value] then
							E.db.mMT.importantspells.spells[value] = nil
							Selectedfilter = nil
							SelectedSpellID = nil
							wipe(valuesSpellIDs)
						end

						mMT.Modules.ImportantSpells:Initialize()
					end,
				},
				reset = {
					order = 4,
					type = "execute",
					name = L["Reset"],
					desc = L["Delete all and reset the list."],
					func = function()
						Selectedfilter = nil
						SelectedSpellID = nil
						wipe(valuesSpellIDs)
						wipe(E.db.mMT.importantspells.spells)
						wipe(filterList)
						mMT.Modules.ImportantSpells:Initialize()
					end,
				},
			},
		},
		header_filter_setting = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Spell Settings"],
			disabled = function()
				return not E.db.mMT.importantspells.spells[Selectedfilter]
			end,
			args = {
				header_IDs = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Spell ID"],
					args = {
						id = {
							order = 1,
							name = L["Spell ID"],
							desc = L["Enter a Spell ID it accepts only Numbers."],
							type = "input",
							width = "smal",
							set = function(info, value)
								if mMT:IsNumber(value) then
									if E.db.mMT.importantspells.spells[Selectedfilter] and not E.db.mMT.importantspells.spells[Selectedfilter].IDs[tonumber(value)] then
										E.db.mMT.importantspells.spells[Selectedfilter].IDs[tonumber(value)] = true
									end

									SelectedSpellID = tonumber(value)
									mMT.Modules.ImportantSpells:Initialize()
								else
									mMT:Print(L["!! Error - this is not an ID."])
								end
							end,
						},
						idList = {
							type = "select",
							order = 2,
							name = L["ID list"],
							values = function()
								if Selectedfilter then
									UpdateTableSpellIDs(E.db.mMT.importantspells.spells[Selectedfilter].IDs)
								end
								return valuesSpellIDs
							end,
							get = function(info)
								return SelectedSpellID
							end,
							set = function(info, value)
								SelectedSpellID = tonumber(value)
							end,
						},
						Deletefilter = {
							type = "select",
							order = 3,
							name = L["Delete ID"],
							desc = L["Delete the Spell, enter a ID."],
							values = function()
								if Selectedfilter then
									UpdateTableSpellIDs(E.db.mMT.importantspells.spells[Selectedfilter].IDs)
								end
								return valuesSpellIDs
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter].IDs[tonumber(value)] then
									E.db.mMT.importantspells.spells[Selectedfilter].IDs[tonumber(value)] = nil
									SelectedSpellID = nil
								end

								mMT.Modules.ImportantSpells:Initialize()
							end,
						},
					},
				},
				enable = {
					order = 3,
					type = "toggle",
					name = L["Enable Filter"],
					desc = L["Enable this Filter."],
					get = function(info)
						return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].enable or false
					end,
					set = function(info, value)
						E.db.mMT.importantspells.spells[Selectedfilter].enable = value
					end,
				},
				header_color = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Castbar Color"],
					args = {
						color = {
							order = 1,
							type = "toggle",
							name = L["Change Castbar color"],
							desc = L["Change the Castbar color."],
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.color.enable or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.color.enable = value
								end
							end,
						},
						color_a = {
							type = "color",
							order = 2,
							name = L["Color"] .. " 1",
							desc = L["Main color."],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.color.a or dummyColor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									local t = E.db.mMT.importantspells.spells[Selectedfilter].functions.color.a
									t.r, t.g, t.b = r, g, b
								end
							end,
						},
						color_b = {
							type = "color",
							order = 3,
							name = L["Color"] .. " 2",
							desc = L["This is the gradient color and will only be used if the Gradient mod is enabled."],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.color.b or dummyColor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									local t = E.db.mMT.importantspells.spells[Selectedfilter].functions.color.b
									t.r, t.g, t.b = r, g, b
								end
							end,
						},
					},
				},
				header_texture = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Castbar Texture"],
					args = {
						texture = {
							order = 1,
							type = "toggle",
							name = L["Change Castbar Texture"],
							desc = L["Change the Castbar Texture."],
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.texture.enable or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.texture.enable = value
								end
							end,
						},
						select_texture = {
							order = 2,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Texture"],
							values = LSM:HashTable("statusbar"),
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.texture.texture or nil
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.texture.texture = value
								end
							end,
						},
					},
				},
				header_sound = {
					order = 6,
					type = "group",
					inline = true,
					name = L["Castbar Sound"],
					args = {
						sound = {
							order = 1,
							type = "toggle",
							name = L["Play a Sound"],
							desc = L["Plays a Sound."],
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.sound.enable or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.sound.enable = value
								end
							end,
						},
						target = {
							order = 2,
							type = "toggle",
							name = L["Only if Target"],
							desc = L["Plays a sound only when the unit is your target."],
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.sound.target or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.sound.target = value
								end
							end,
						},
						select_sound = {
							order = 3,
							type = "select",
							dialogControl = "LSM30_Sound",
							name = L["Sound"],
							values = LSM:HashTable("sound"),
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.sound.file or nil
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.sound.file = value
								end
							end,
						},
					},
				},
				header_icon = {
					order = 7,
					type = "group",
					inline = true,
					name = L["Icon Settings"],
					args = {
						toggle_icon = {
							order = 1,
							type = "toggle",
							name = L["Icon"],
							desc = L["Adds an Extra Icon to the Castbar."],
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.enable or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.enable = value
								end
							end,
						},
						select_icon = {
							order = 2,
							type = "select",
							name = L["Icon"],
							desc = L["Select an Icon."],
							get = function(info)
								return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.icon or nil
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.icon = value
								end
							end,
							values = icons,
						},
						color_icon_color = {
							type = "color",
							order = 3,
							name = L["Color"],
							desc = L["Icon color. Note: If you chose a colored icon, set the color to white for the best look."],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.color or dummyColor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								if E.db.mMT.importantspells.spells[Selectedfilter] then
									local t = E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.color
									t.r, t.g, t.b = r, g, b
								end
							end,
						},
						header_size = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Size"],
							args = {
								auto = {
									order = 1,
									type = "toggle",
									name = L["Auto Size"],
									desc = L["Set the icon size according to the height of the castbar."],
									get = function(info)
										return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.size.auto
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[Selectedfilter] then
											E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.size.auto = value
										end
									end,
								},
								range_x = {
									order = 2,
									name = L["Icon Size"],
									desc = L["Icon seize if not Auto size is enabled."],
									type = "range",
									min = 16,
									max = 128,
									step = 2,
									get = function(info)
										return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.size.sizeXY or 0
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[Selectedfilter] then
											E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.size.sizeXY = value
										end
									end,
								},
							},
						},
						header_anchor = {
							order = 4,
							type = "group",
							inline = true,
							name = L["Anchor"],
							args = {
								select_anchor = {
									order = 1,
									type = "select",
									name = L["Extra Icon Anchor"],
									desc = L["Anchor point for the extra Icon."],
									get = function(info)
										return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.point or nil
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[Selectedfilter] then
											E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.point = value
										end
									end,
									values = {
										TOP = "TOP",
										BOTTOM = "BOTTOM",
										LEFT = "LEFT",
										RIGHT = "RIGHT",
										CENTER = "CENTER",
									},
								},
								auto = {
									order = 2,
									type = "toggle",
									name = L["Auto Point"],
									desc = L["Sets the offset according to the anchor."],
									get = function(info)
										return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.auto
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[Selectedfilter] then
											E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.auto = value
										end
									end,
								},
								range_posX = {
									order = 3,
									name = L["X offset"],
									desc = L["Icon offset if not Auto point is enabled."],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									get = function(info)
										return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.posX or 0
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[Selectedfilter] then
											E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.posX = value
										end
									end,
								},
								range_posY = {
									order = 4,
									name = L["Y offset"],
									desc = L["Icon offset if not Auto point is enabled."],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									get = function(info)
										return E.db.mMT.importantspells.spells[Selectedfilter] and E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.posY or 0
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[Selectedfilter] then
											E.db.mMT.importantspells.spells[Selectedfilter].functions.icon.anchor.posY = value
										end
									end,
								},
							},
						},
					},
				},
			},
		},
		header_importexport = {
			order = 8,
			type = "group",
			inline = true,
			name = L["Import/ Export of Spell IDs"],
			args = {
				export_spells = {
					order = 1,
					type = "execute",
					name = L["Export"],
					func = function()
						if next(E.db.mMT.importantspells.spells) then
							exportText = mMT:GetExportText(E.db.mMT.importantspells.spells, "mMTImportantSpellsV2")
							button = exportText and "export" or "none"
						end
					end,
				},
				import = {
					order = 3,
					type = "execute",
					name = L["Import"],
					func = function()
						local profileType, profileData = mMT:GetImportText(importText)
						if profileType == "mMTImportantSpells" then
							mMT:Print(L["You are trying to load an outdated profile, unfortunately this is not possible."])
						elseif profileType == "mMTImportantSpellsV2" then
							E:CopyTable(E.db.mMT.importantspells.spells, profileData)
							mMT.Modules.ImportantSpells:Initialize()
						end
					end,
				},
				text = {
					order = 4,
					name = function()
						-- disable input box button
						E.Options.args.mMT.args.castbar.args.important.args.header_importexport.args.text.disableButton = true
						E.Options.args.mMT.args.castbar.args.important.args.header_importexport.args.text.textChanged = function(text)
							if text ~= importText then
								importText = text
							end
							button = "none"
						end
						return L["Output/ Input"]
					end,
					type = "input",
					width = "full",
					multiline = 10,
					set = function() end,
					get = function()
						if button == "export" and exportText then
							return exportText
						else
							return ""
						end
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
