local E, L, V, P, G = unpack(ElvUI)
local LibDeflate = E.Libs.Deflate
local D = E:GetModule("Distributor")

local tinsert = tinsert
local selectedInterruptID = nil
local selectedStunID = nil

local valuesInterruptID = {}
local valuesStunID = {}
local exportText = nil
local importText = ""
local button = "none"
local function UpdateTableInterrupt()
	wipe(valuesInterruptID)
	for key, _ in pairs(E.db.mMT.importantspells.interrupt.ids) do
		valuesInterruptID[key] = key
	end
end

local function UpdateTableStun()
	wipe(valuesStunID)
	for key, _ in pairs(E.db.mMT.importantspells.stun.ids) do
		valuesStunID[key] = key
	end
end
local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.Castbar) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end
	E.Options.args.mMT.args.castbar.args.important.args = {
		header_importantspells = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Important Spells"],
			args = {
				toggle_importantspells_interrupt = {
					order = 1,
					type = "toggle",
					name = L["Enable interruptible Spells"],
					get = function(info)
						return E.db.mMT.importantspells.interrupt.enable
					end,
					set = function(info, value)
						E.db.mMT.importantspells.interrupt.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_importantspells_stun = {
					order = 2,
					type = "toggle",
					name = L["Enable |CFFFF006Cnot|r interruptible Spells"],
					get = function(info)
						return E.db.mMT.importantspells.stun.enable
					end,
					set = function(info, value)
						E.db.mMT.importantspells.stun.enable = value
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
				gradient = {
					order = 1,
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
		header_color_interrupt = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Important interruptible Spells"],
			args = {
				color_interrupta = {
					type = "color",
					order = 1,
					name = L["Color"] .. " 1",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.importantspells.interrupt.colora
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.importantspells.interrupt.colora
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_interruptb = {
					type = "color",
					order = 2,
					name = L["Color"] .. " 2",
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.importantspells.gradient
					end,
					get = function(info)
						local t = E.db.mMT.importantspells.interrupt.colorb
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.importantspells.interrupt.colorb
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
		header_color_stun = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Important |CFFFF006Cnot|r interruptible Spells"],
			args = {

				color_stuna = {
					type = "color",
					order = 1,
					name = L["Color"] .. " 1",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.importantspells.stun.colora
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.importantspells.stun.colora
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_stunb = {
					type = "color",
					order = 2,
					name = L["Color"] .. " 2",
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.importantspells.gradient
					end,
					get = function(info)
						local t = E.db.mMT.importantspells.stun.colorb
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.importantspells.stun.colorb
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
		header_icon = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Icon"],
			args = {
				toggle_icon = {
					order = 1,
					type = "toggle",
					name = L["Enable Extra Icon"],
					get = function(info)
						return E.db.mMT.importantspells.icon.enable
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.enable = value
					end,
				},
				toggle_replace = {
					order = 2,
					type = "toggle",
					name = L["Replace Castbar Icon"],
					get = function(info)
						return E.db.mMT.importantspells.icon.replace
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.replace = value
					end,
				},
				toggle_auto = {
					order = 3,
					type = "toggle",
					name = L["Auto color Icon"],
					get = function(info)
						return E.db.mMT.importantspells.icon.auto
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.auto = value
					end,
				},
				spacer1 = {
					order = 4,
					type = "description",
					name = "\n",
				},
				range_x = {
					order = 5,
					name = L["Extra Icon size X"],
					type = "range",
					min = 16,
					max = 128,
					step = 2,
					get = function(info)
						return E.db.mMT.importantspells.icon.sizeX
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.sizeX = value
					end,
				},
				range_y = {
					order = 6,
					name = L["Extra Icon size Y"],
					type = "range",
					min = 16,
					max = 128,
					step = 2,
					get = function(info)
						return E.db.mMT.importantspells.icon.sizeY
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.sizeY = value
					end,
				},
				spacer2 = {
					order = 7,
					type = "description",
					name = "\n",
				},
				select_interrupt = {
					order = 8,
					type = "select",
					name = L["Interruptible Icon"],
					get = function(info)
						return E.db.mMT.importantspells.icon.interrupt
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.interrupt = value
					end,
					values = icons,
				},
				select_stun = {
					order = 9,
					type = "select",
					name = L["Not Interruptible Icon"],
					get = function(info)
						return E.db.mMT.importantspells.icon.stun
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.stun = value
					end,
					values = icons,
				},
				spacer3 = {
					order = 10,
					type = "description",
					name = "\n",
				},
				select_anchor = {
					order = 11,
					type = "select",
					name = L["Extra Icon Anchor"],
					get = function(info)
						return E.db.mMT.importantspells.icon.anchor
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.anchor = value
					end,
					values = {
						TOP = "TOP",
						BOTTOM = "BOTTOM",
						LEFT = "LEFT",
						RIGHT = "RIGHT",
						CENTER = "CENTER",
					},
				},
				range_posx = {
					order = 12,
					name = L["Position"] .. " X",
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					get = function(info)
						return E.db.mMT.importantspells.icon.posX
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.posX = value
					end,
				},
				range_posy = {
					order = 13,
					name = L["Position"] .. " Y",
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					get = function(info)
						return E.db.mMT.importantspells.icon.posY
					end,
					set = function(info, value)
						E.db.mMT.importantspells.icon.posY = value
					end,
				},
			},
		},
		header_ids_interrupt = {
			order = 6,
			type = "group",
			inline = true,
			name = L["IDs for interruptible Spells"],
			args = {
				customid = {
					order = 1,
					name = L["Spell ID for interruptible Spells"],
					desc = L["Spell ID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if mMT:IsNumber(value) then
							if E.db.mMT.importantspells.interrupt.ids[tonumber(value)] then
								selectedInterruptID = tonumber(value)
							else
								tinsert(E.db.mMT.importantspells.interrupt.ids, value, true)
							end
							mMT:UpdateImportantSpells()
						else
							mMT:Print(L["!! Error - this is not am ID."])
						end
					end,
				},
				idtable = {
					type = "select",
					order = 2,
					name = L["Spell IDs"],
					values = function()
						UpdateTableInterrupt()
						return valuesInterruptID
					end,
					get = function(info)
						return selectedInterruptID
					end,
					set = function(info, value)
						selectedInterruptID = tonumber(value)
					end,
				},
				deleteid = {
					order = 3,
					name = L["Delete ID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if mMT:IsNumber(value) then
							if E.db.mMT.importantspells.interrupt.ids[tonumber(value)] then
								E.db.mMT.importantspells.interrupt.ids[tonumber(value)] = nil
								selectedInterruptID = nil
							end
							mMT:UpdateImportantSpells()
						else
							mMT:Print(L["!! Error - this is not am ID."])
						end
					end,
				},
				deleteall = {
					order = 4,
					type = "execute",
					name = L["Delete all"],
					func = function()
						wipe(E.db.mMT.importantspells.interrupt.ids)
						wipe(valuesInterruptID)
						mMT:UpdateImportantSpells()
					end,
				},
			},
		},
		header_ids_stun = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Spell IDs for |CFFFF006Cnot|r interruptible Spells"],
			args = {
				customid = {
					order = 1,
					name = L["Spell ID for |CFFFF006Cnot|r interruptible Spells"],
					desc = L["Spell ID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if mMT:IsNumber(value) then
							if E.db.mMT.importantspells.stun.ids[tonumber(value)] then
								selectedStunID = tonumber(value)
							else
								tinsert(E.db.mMT.importantspells.stun.ids, value, true)
							end
							mMT:UpdateImportantSpells()
						else
							mMT:Print(L["!! Error - this is not am ID."])
						end
					end,
				},
				idtable = {
					type = "select",
					order = 2,
					name = L["Spell IDs"],
					values = function()
						UpdateTableStun()
						return valuesStunID
					end,
					get = function(info)
						return selectedStunID
					end,
					set = function(info, value)
						selectedStunID = tonumber(value)
					end,
				},
				deleteid = {
					order = 3,
					name = L["Delete ID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if mMT:IsNumber(value) then
							if E.db.mMT.importantspells.stun.ids[tonumber(value)] then
								E.db.mMT.importantspells.stun.ids[tonumber(value)] = nil
								selectedStunID = nil
							end
							mMT:UpdateImportantSpells()
						else
							mMT:Print(L["!! Error - this is not am ID."])
						end
					end,
				},
				deleteall = {
					order = 4,
					type = "execute",
					name = L["Delete all"],
					func = function()
						wipe(E.db.mMT.importantspells.stun.ids)
						wipe(valuesStunID)
						mMT:UpdateImportantSpells()
					end,
				},
			},
		},
		header_importexport = {
			order = 8,
			type = "group",
			inline = true,
			name = L["Import/ Export of Spell IDs"],
			args = {
				export_interrupt = {
					order = 1,
					type = "execute",
					name = L["Export Interrupt Ids"],
					func = function()
						if next(E.db.mMT.importantspells.interrupt.ids) then
							exportText = mMT:GetExportText(E.db.mMT.importantspells.interrupt.ids, "mMTInterrupt")
							button = exportText and "export" or "none"
						end
					end,
				},
				export_stun = {
					order = 2,
					type = "execute",
					name = L["Export Stun IDs"],
					func = function()
						if next(E.db.mMT.importantspells.stun.ids) then
							exportText = mMT:GetExportText(E.db.mMT.importantspells.stun.ids, "mMTStun")
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
						if profileType == "mMTStun" then
							E:CopyTable(E.db.mMT.importantspells.stun.ids, profileData)
						elseif profileType == "mMTInterrupt" then
							E:CopyTable(E.db.mMT.importantspells.interrupt.ids, profileData)
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
