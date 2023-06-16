local E, L = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")

local tinsert = tinsert
local SelectedSpellID = nil
local valuesSpellIDs = {}
local exportText = nil
local importText = ""
local button = "none"
local dummyColor = { r = 1, g = 1, b = 1 }

local function UpdateTableSpellIDs()
	wipe(valuesSpellIDs)
	for key, _ in pairs(E.db.mMT.importantspells.spells) do
		valuesSpellIDs[key] = key
	end
end

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
					name = L["Enable on Nameplate"],
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
					get = function(info)
						return E.db.mMT.importantspells.gradient
					end,
					set = function(info, value)
						E.db.mMT.importantspells.gradient = value
					end,
				},
			},
		},
		header_spells = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Spell IDs"],
			args = {
				id = {
					order = 1,
					name = L["Spell ID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if mMT:IsNumber(value) then
							if E.db.mMT.importantspells.spells[tonumber(value)] then
								SelectedSpellID = tonumber(value)
							else
								tinsert(E.db.mMT.importantspells.spells, value, {
									enable = true,
									color = { enable = true, a = { r = 1, g = 1, b = 1 }, b = { r = 1, g = 1, b = 1 } },
									sound = { enable = false, file = nil },
									texture = { enable = false, texture = nil },
									icon = {
										enable = false,
										color = { r = 1, g = 1, b = 1 },
										icon = nil,
										size = { auto = true, sizeXY = 32},
										anchor = { auto = true, point = "CENTER", posX = 0, posY = 0 },
									},
								})
							end
							mMT:UpdateImportantSpells()
						else
							mMT:Print(L["!! Error - this is not an ID."])
						end
					end,
				},
				IDTable = {
					type = "select",
					order = 2,
					name = L["Spell IDs"],
					values = function()
						UpdateTableSpellIDs()
						return valuesSpellIDs
					end,
					get = function(info)
						return SelectedSpellID
					end,
					set = function(info, value)
						SelectedSpellID = tonumber(value)
					end,
				},
				DeleteID = {
					order = 3,
					name = L["Delete ID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if mMT:IsNumber(value) then
							if E.db.mMT.importantspells.spells[tonumber(value)] then
								E.db.mMT.importantspells.spells[tonumber(value)] = nil
								SelectedSpellID = nil
							end
							mMT:UpdateImportantSpells()
						else
							mMT:Print(L["!! Error - this is not am ID."])
						end
					end,
				},
				reset = {
					order = 4,
					type = "execute",
					name = L["Reset"],
					func = function()
						wipe(E.db.mMT.importantspells.spells)
						wipe(valuesSpellIDs)
						mMT:UpdateImportantSpells()
					end,
				},
			},
		},
		header_spell_setting = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Spell Settings"],
			disabled = function()
				return not E.db.mMT.importantspells.spells[SelectedSpellID]
			end,
			args = {
				header_color = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Castbar Color"],
					args = {
						color = {
							order = 1,
							type = "toggle",
							name = L["Change Castbar color"],
							get = function(info)
								return E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].color.enable
									or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									E.db.mMT.importantspells.spells[SelectedSpellID].color.enable = value
								end
							end,
						},
						color_a = {
							type = "color",
							order = 2,
							name = L["Color"] .. " 1",
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].color.a
									or dummyColor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									local t = E.db.mMT.importantspells.spells[SelectedSpellID].color.a
									t.r, t.g, t.b = r, g, b
								end
							end,
						},
						color_b = {
							type = "color",
							order = 3,
							name = L["Color"] .. " 2",
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].color.b
									or dummyColor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									local t = E.db.mMT.importantspells.spells[SelectedSpellID].color.b
									t.r, t.g, t.b = r, g, b
								end
							end,
						},
					},
				},
				header_texture = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Castbar Texture"],
					args = {
						texture = {
							order = 1,
							type = "toggle",
							name = L["Change Castbar Texture"],
							get = function(info)
								return E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].texture.enable
									or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									E.db.mMT.importantspells.spells[SelectedSpellID].texture.enable = value
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
								return E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].texture.texture
									or nil
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									E.db.mMT.importantspells.spells[SelectedSpellID].texture.texture = value
								end
							end,
						},
					},
				},
				header_sound = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Castbar Sound"],
					args = {
						texture = {
							order = 1,
							type = "toggle",
							name = L["Play a Sound"],
							get = function(info)
								return E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].sound.enable
									or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									E.db.mMT.importantspells.spells[SelectedSpellID].sound.enable = value
								end
							end,
						},
						select_sound = {
							order = 2,
							type = "select",
							dialogControl = "LSM30_Sound",
							name = L["Sound"],
							values = LSM:HashTable("sound"),
							get = function(info)
								return E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].sound.file
									or nil
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									E.db.mMT.importantspells.spells[SelectedSpellID].sound.file = value
								end
							end,
						},
					},
				},
				header_icon = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Icon Settings"],
					args = {
						toggle_icon = {
							order = 1,
							type = "toggle",
							name = L["Icon"],
							get = function(info)
								return E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].icon.enable
									or false
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									E.db.mMT.importantspells.spells[SelectedSpellID].icon.enable = value
								end
							end,
						},
						select_icon = {
							order = 2,
							type = "select",
							name = L["Icon"],
							get = function(info)
								return E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].icon.icon
									or nil
							end,
							set = function(info, value)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									E.db.mMT.importantspells.spells[SelectedSpellID].icon.icon = value
								end
							end,
							values = icons,
						},
						color_icon_color = {
							type = "color",
							order = 3,
							name = L["Color"] .. " 2",
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.importantspells.spells[SelectedSpellID]
										and E.db.mMT.importantspells.spells[SelectedSpellID].icon.color
									or dummyColor
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								if E.db.mMT.importantspells.spells[SelectedSpellID] then
									local t = E.db.mMT.importantspells.spells[SelectedSpellID].icon.color
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
									get = function(info)
										return E.db.mMT.importantspells.spells[SelectedSpellID]
											and E.db.mMT.importantspells.spells[SelectedSpellID].icon.size.auto
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[SelectedSpellID] then
											E.db.mMT.importantspells.spells[SelectedSpellID].icon.size.auto = value
										end
									end,
								},
								range_x = {
									order = 2,
									name = L["Icon size X"],
									type = "range",
									min = 16,
									max = 128,
									step = 2,
									get = function(info)
										return E.db.mMT.importantspells.spells[SelectedSpellID]
												and E.db.mMT.importantspells.spells[SelectedSpellID].icon.size.sizeXY
											or 0
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[SelectedSpellID] then
											E.db.mMT.importantspells.spells[SelectedSpellID].icon.size.sizeXY = value
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
									get = function(info)
										return E.db.mMT.importantspells.spells[SelectedSpellID]
												and E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.point
											or nil
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[SelectedSpellID] then
											E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.point = value
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
									get = function(info)
										return E.db.mMT.importantspells.spells[SelectedSpellID]
											and E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.auto
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[SelectedSpellID] then
											E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.auto = value
										end
									end,
								},
								range_posX = {
									order = 3,
									name = L["Position"] .. " X",
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									get = function(info)
										return E.db.mMT.importantspells.spells[SelectedSpellID]
												and E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.posX
											or 0
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[SelectedSpellID] then
											E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.posX = value
										end
									end,
								},
								range_posY = {
									order = 4,
									name = L["Position"] .. " Y",
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									get = function(info)
										return E.db.mMT.importantspells.spells[SelectedSpellID]
												and E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.posY
											or 0
									end,
									set = function(info, value)
										if E.db.mMT.importantspells.spells[SelectedSpellID] then
											E.db.mMT.importantspells.spells[SelectedSpellID].icon.anchor.posY = value
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
							exportText = mMT:GetExportText(E.db.mMT.importantspells.spells, "mMTImportantSpells")
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
							E:CopyTable(E.db.mMT.importantspells.spells, profileData)
							E:StaticPopup_Show("CONFIG_RL")
						end
					end,
				},
				text = {
					order = 4,
					name = function()
						-- disable input box button
						E.Options.args.mMT.args.castbar.args.important.args.header_importexport.args.text.disableButton =
							true
						E.Options.args.mMT.args.castbar.args.important.args.header_importexport.args.text.textChanged = function(
							text
						)
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
