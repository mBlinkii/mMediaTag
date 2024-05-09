local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local LSM = E.Libs.LSM

local tinsert = tinsert
local Selected = nil

local exportText = nil
local importText = ""
local button = "none"

local function GetPanelNames()
	local tmp_List = {}
	for k, v in pairs(DT.RegisteredPanels) do
		tmp_List[k] = k
	end
	return tmp_List
end

local function configTable()
	E.Options.args.mMT.args.cosmetic.args.datapanels.args = {
		toggle_enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.db.mMT.cosmeticbars.enable
			end,
			set = function(info, value)
				E.db.mMT.cosmeticbars.enable = value
				mMT.Modules.CosmeticBars:Initialize()
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		header_panels = {
			order = 2,
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
						return Selected
					end,
					set = function(info, value)
						Selected = value

						if not E.db.mMT.cosmeticbars.bars[value] then
							E.db.mMT.cosmeticbars.bars[value] = {
								bg = { style = "custom", color = { r = 1, g = 1, b = 1, a = 1 } },
								border = { style = "custom", color = { r = 1, g = 1, b = 1 } },
								texture = { enable = false, file = "Solid" },
							}
						end
					end,
				},
				apply = {
					order = 2,
					type = "execute",
					name = L["Apply"],
					func = function()
						E:StaggeredUpdateAll(nil, true)
					end,
				},
				reset = {
					order = 3,
					type = "execute",
					name = L["Reset"],
					desc = L["Delete all Settings"],
					func = function()
						wipe(E.db.mMT.cosmeticbars.bars)
						mMT.Modules.CosmeticBars:Initialize()
					end,
				},
			},
		},
		header_panel_settings = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Settings"],
			disabled = function()
				return not E.db.mMT.cosmeticbars.bars[Selected]
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
								return E.db.mMT.cosmeticbars.bars[Selected] and E.db.mMT.cosmeticbars.bars[Selected].bg.style or "custom"
							end,
							set = function(info, value)
								if E.db.mMT.cosmeticbars.bars[Selected] then
									E.db.mMT.cosmeticbars.bars[Selected].bg.style = value
								end
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
								local t = E.db.mMT.cosmeticbars.bars[Selected] and E.db.mMT.cosmeticbars.bars[Selected].bg.color or { r = 1, g = 1, b = 1, a = 1 }
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b)
								if E.db.mMT.cosmeticbars.bars[Selected] then
									local t = E.db.mMT.cosmeticbars.bars[Selected].bg.color
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
								return E.db.mMT.cosmeticbars.bars[Selected] and E.db.mMT.cosmeticbars.bars[Selected].bg.color.a or 1
							end,
							set = function(info, value)
								if E.db.mMT.cosmeticbars.bars[Selected] then
									E.db.mMT.cosmeticbars.bars[Selected].bg.color.a = value
								end
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
								return E.db.mMT.cosmeticbars.bars[Selected] and E.db.mMT.cosmeticbars.bars[Selected].border.style or "custom"
							end,
							set = function(info, value)
								if E.db.mMT.cosmeticbars.bars[Selected] then
									E.db.mMT.cosmeticbars.bars[Selected].border.style = value
								end
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
							name = L["BG Color"],
							hasAlpha = false,
							get = function(info)
								local t = E.db.mMT.cosmeticbars.bars[Selected] and E.db.mMT.cosmeticbars.bars[Selected].border.color or { r = 1, g = 1, b = 1 }
								return t.r, t.g, t.b
							end,
							set = function(info, r, g, b, a)
								if E.db.mMT.cosmeticbars.bars[Selected] then
									local t = E.db.mMT.cosmeticbars.bars[Selected].border.color
									t.r, t.g, t.b, t.a = r, g, b, a
								end
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
								return E.db.mMT.cosmeticbars.bars[Selected] and E.db.mMT.cosmeticbars.bars[Selected].texture.enable or false
							end,
							set = function(info, value)
								if E.db.mMT.cosmeticbars.bars[Selected] then
									E.db.mMT.cosmeticbars.bars[Selected].texture.enable = value
								end
							end,
						},
						texture = {
							order = 2,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Texture"],
							values = LSM:HashTable("statusbar"),
							get = function(info)
								return E.db.mMT.cosmeticbars.bars[Selected] and E.db.mMT.cosmeticbars.bars[Selected].texture.file or "Solid"
							end,
							set = function(info, value)
								if E.db.mMT.cosmeticbars.bars[Selected] then
									E.db.mMT.cosmeticbars.bars[Selected].texture.file = value
								end
							end,
						},
					},
				},
			},
		},
		header_importexport = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Import/ Export of this Settings"],
			args = {
				export_spells = {
					order = 1,
					type = "execute",
					name = L["Export"],
					func = function()
						if next(E.db.mMT.cosmeticbars.bars) then
							exportText = mMT:GetExportText(E.db.mMT.cosmeticbars.bars, "mMTCosmeticBras")
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
							E:CopyTable(E.db.mMT.cosmeticbars.bars, profileData)
							E:StaticPopup_Show("CONFIG_RL")
						end
					end,
				},
				text = {
					order = 4,
					name = function()
						-- disable input box button
						E.Options.args.mMT.args.cosmetic.args.datapanels.args.header_importexport.args.text.disableButton = true
						E.Options.args.mMT.args.cosmetic.args.datapanels.args.header_importexport.args.text.textChanged = function(text)
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
