local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")
local LSM = E.Libs.LSM

local exportText = nil
local importText = ""
local button = "none"

local defaults = {
	enable = false,
	bg = { style = "custom", color = { r = 1, g = 1, b = 1, a = 1 } },
	border = { style = "custom", color = { r = 1, g = 1, b = 1, a = 1 } },
	texture = { enable = false, file = "Solid" },
}

local selectedPanelName = nil
local selectedPanel = nil

local function GetPanelNames()
	local tmp_List = {}
	for k, v in pairs(DT.RegisteredPanels) do
		tmp_List[k] = k
	end
	return tmp_List
end

mMT.options.args.misc.args.data_panel_skin.args = {
	toggle_enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMT.data_panel_skin.enable and COLORS.green:WrapTextInColorCode(L["Enabled"]) or COLORS.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMT.data_panel_skin.enable
		end,
		set = function(info, value)
			E.db.mMT.data_panel_skin.enable = value
			mMT:UpdateModule("DataPanelSkin")
			--E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	spacer_1 = {
		order = 2,
		type = "description",
		name = "\n",
	},
	info = {
		order = 3,
		type = "description",
		name = COLORS.info:WrapTextInColorCode(
			L["Info: The Skin can be affected by other addons if they add a skin for all windows. To fix the problem, the skin must be deactivated in the other addon. This is not a bug of mMT."]
		),
	},
    spacer = {
		order = 4,
		type = "description",
		name = "\n",
	},
    info2 = {
		order = 5,
		type = "description",
		name = COLORS.info:WrapTextInColorCode(
			L["Info: This Settings will override the ElvUI Data Panel settings."]
		),
	},
    spacer2 = {
		order = 6,
		type = "description",
		name = "\n",
	},
	header_panels = {
		order = 7,
		type = "group",
		inline = true,
		name = L["Panels"],
		args = {
			select_list = {
				type = "select",
				order = 1,
				name = L["Panels"],
				values = function()
					return GetPanelNames()
				end,
				get = function(info)
					return selectedPanelName
				end,
				set = function(info, value)
					selectedPanelName = value
					selectedPanel = {}
					E:CopyTable(selectedPanel, defaults)
					selectedPanel = E:CopyTable(selectedPanel, E.db.mMT.data_panel_skin.panels[value])
				end,
			},
			apply = {
				order = 2,
				type = "execute",
				name = L["Apply"],
				func = function()
					if selectedPanelName and selectedPanel then E.db.mMT.data_panel_skin.panels[selectedPanelName] = selectedPanel end
					mMT:UpdateModule("DataPanelSkin")
					E:UpdateDataTexts()
				end,
			},
			reset = {
				order = 3,
				type = "execute",
				name = L["Reset"],
				desc = L["Delete the actual Settings"],
				func = function()
					wipe(E.db.mMT.data_panel_skin.panels[selectedPanelName])
                    selectedPanel = nil
                    selectedPanelName = nil
					mMT:UpdateModule("DataPanelSkin")
					E:UpdateDataTexts()
				end,
			},
			reset_all = {
				order = 4,
				type = "execute",
				name = L["Reset all"],
				desc = L["Delete all Settings"],
				func = function()
					wipe(E.db.mMT.data_panel_skin.panels)
					mMT:UpdateModule("DataPanelSkin")
					E:UpdateDataTexts()
				end,
			},
		},
	},
	header_panel_settings = {
		order = 8,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = function()
			return not (selectedPanelName and selectedPanel)
		end,
		args = {
			toggle_enable = {
				order = 1,
				type = "toggle",
				name = function()
					return (selectedPanel and selectedPanel.enable) and COLORS.green:WrapTextInColorCode(L["Enabled"]) or COLORS.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return selectedPanel and selectedPanel.enable or false
				end,
				set = function(info, value)
					if selectedPanel then selectedPanel.enable = value end
				end,
			},
			header_panel_settings = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Settings"],
				disabled = function()
					return not (selectedPanel and selectedPanel.enable)
				end,
				args = {
					header_bg = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Background"],
						args = {
							select_Style = {
								type = "select",
								order = 1,
								name = L["Color Style"],
								get = function(info)
									return selectedPanel and selectedPanel.bg.style or "custom"
								end,
								set = function(info, value)
									if selectedPanel then selectedPanel.bg.style = value end
								end,
								values = {
									disabled = L["Disable"],
									class = L["Class"],
									darkclass = L["Dark Class"],
									custom = L["Custom"],
								},
							},
							color = {
								type = "color",
								order = 2,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local t = selectedPanel and selectedPanel.bg.color or { r = 1, g = 1, b = 1, a = 1 }
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									if selectedPanel then
										local t = selectedPanel.bg.color
										t.r, t.g, t.b = r, g, b
									end
								end,
							},
							alpha = {
								order = 3,
								name = L["Alpha"],
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								get = function(info)
									return selectedPanel and selectedPanel.bg.color.a or 1
								end,
								set = function(info, value)
									if selectedPanel then selectedPanel.bg.color.a = value end
								end,
							},
						},
					},
					header_border = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Border"],
						args = {
							select_Style = {
								type = "select",
								order = 1,
								name = L["Color Style"],
								get = function(info)
									return selectedPanel and selectedPanel.border.style or "custom"
								end,
								set = function(info, value)
									if selectedPanel then selectedPanel.border.style = value end
								end,
								values = {
									disabled = L["Disable"],
									class = L["Class"],
									darkclass = L["Dark Class"],
									custom = L["Custom"],
								},
							},
							color = {
								type = "color",
								order = 2,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local t = selectedPanel and selectedPanel.border.color or { r = 1, g = 1, b = 1, a = 1 }
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									if selectedPanel then
										local t = selectedPanel.border.color
										t.r, t.g, t.b = r, g, b
									end
								end,
							},
							alpha = {
								order = 3,
								name = L["Alpha"],
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								get = function(info)
									return selectedPanel and selectedPanel.border.color.a or 1
								end,
								set = function(info, value)
									if selectedPanel then selectedPanel.border.color.a = value end
								end,
							},
						},
					},
					header_texture = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Texture"],
						args = {
							toggle_enable = {
								order = 1,
								type = "toggle",
								name = L["Change Texture"],
								get = function(info)
									return selectedPanel and selectedPanel.texture.enable or false
								end,
								set = function(info, value)
									if selectedPanel then selectedPanel.texture.enable = value end
								end,
							},
							texture = {
								order = 2,
								type = "select",
								dialogControl = "LSM30_Statusbar",
								name = L["Texture"],
								values = LSM:HashTable("statusbar"),
								get = function(info)
									return selectedPanel and selectedPanel.texture.file or "Solid"
								end,
								set = function(info, value)
									if selectedPanel then selectedPanel.texture.file = value end
								end,
							},
						},
					},
				},
			},
		},
	},
	header_importexport = {
		order = 9,
		type = "group",
		inline = true,
		name = L["Import/ Export of this Settings"],
		args = {
			export_spells = {
				order = 1,
				type = "execute",
				name = L["Export"],
				func = function()
					if next(E.db.mMT.data_panel_skin.panels) then
						exportText = mMT:GetExportText(E.db.mMT.data_panel_skin.panels, "mMTCosmeticBras")
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
					if profileType == "mMTCosmeticBras" then
						E:CopyTable(E.db.mMT.data_panel_skin.panels, profileData)
						mMT:UpdateModule("DataPanelSkin")
					end
				end,
			},
			text = {
				order = 4,
				name = function()
					-- disable input box button
					E.Options.args.mMT.args.misc.args.data_panel_skin.args.header_importexport.args.text.disableButton = true
					E.Options.args.mMT.args.misc.args.data_panel_skin.args.header_importexport.args.text.textChanged = function(text)
						if text ~= importText then importText = text end
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
