local mMT, E, L, V, P, G = unpack((select(2, ...)))

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.setup.args = {
		header_greeting = {
			order = 1,
			type = "group",
			inline = true,
			name = L["General"],
			args = {
				header_rollbutton = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Roll Button"],
					args = {
						toggle_rollbutton = {
							order = 1,
							type = "toggle",
							name = L["Roll Button"],
							get = function(info)
								return E.db.mMT.roll.enable
							end,
							set = function(info, value)
								E.db.mMT.roll.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_rollbutton = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "general", "roll")
							end,
						},
					},
				},
				header_chatbutton = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Chat Button"],
					args = {
						toggle_chatbutton = {
							order = 1,
							type = "toggle",
							name = L["Chat Button"],
							get = function(info)
								return E.db.mMT.chat.enable
							end,
							set = function(info, value)
								E.db.mMT.chat.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_chatbutton = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "general", "chat")
							end,
						},
					},
				},
				header_keystochat = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Chat Button"],
					hidden  = function() return not E.Retail end,
					args = {
						toggle_keystochat = {
							order = 1,
							type = "toggle",
							name = L["Keystone to Chat"],
							get = function(info)
								return E.db.mMT.general.keystochat
							end,
							set = function(info, value)
								E.db.mMT.general.keystochat = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_keystochat = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "general", "keystochat")
							end,
						},
					},
				},
				header_instancedifficulty = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Instance Difficulty"],
					hidden  = function() return not E.Retail end,
					args = {
						toggle_instancedifficulty = {
							order = 1,
							type = "toggle",
							name = L["Instance Difficulty"],
							get = function(info)
								return E.db.mMT.instancedifficulty.enable
							end,
							set = function(info, value)
								E.db.mMT.instancedifficulty.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_instancedifficulty = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "general", "instancedifficulty")
							end,
						},
					},
				},
			},
		},
		header_cosmetic = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Cosmetic"],
			args = {
				header_tooltip = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Tooltip Icon"],
					args = {
						toggle_tooltip = {
							order = 1,
							type = "toggle",
							name = L["Tooltip Icon"],
							get = function(info)
								return E.db.mMT.tooltip.enable
							end,
							set = function(info, value)
								E.db.mMT.tooltip.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_tooltip = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "cosmetic", "tooltip")
							end,
						},
					},
				},
				header_background = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Custom Backdrop"],
					args = {
						toggle_background1 = {
							order = 1,
							type = "toggle",
							name = L["Custom Health Backdrop"],
							get = function(info)
								return E.db.mMT.custombackgrounds.health.enable
							end,
							set = function(info, value)
								E.db.mMT.custombackgrounds.health.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_background2 = {
							order = 2,
							type = "toggle",
							name = L["Custom Power Backdrop"],
							get = function(info)
								return E.db.mMT.custombackgrounds.power.enable
							end,
							set = function(info, value)
								E.db.mMT.custombackgrounds.power.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_background3 = {
							order = 3,
							type = "toggle",
							name = L["Custom Castbar Backdrop"],
							get = function(info)
								return E.db.mMT.custombackgrounds.castbar.enable
							end,
							set = function(info, value)
								E.db.mMT.custombackgrounds.castbar.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_background = {
							order = 4,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "cosmetic", "background")
							end,
						},
					},
				},
				header_classcolor = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Custom Class color"],
					args = {
						toggle_classcolor = {
							order = 1,
							type = "toggle",
							name = L["Custom Class color"],
							get = function(info)
								return E.db.mMT.customclasscolors.enable
							end,
							set = function(info, value)
								E.db.mMT.customclasscolors.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_classcolor = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "cosmetic", "classcolor")
							end,
						},
					},
				},
				header_roleicons = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Role Icons"],
					hidden  = function() return not E.Retail end,
					args = {
						toggle_roleicons = {
							order = 1,
							type = "toggle",
							name = L["Role Icons"],
							get = function(info)
								return E.db.mMT.roleicons.enable
							end,
							set = function(info, value)
								E.db.mMT.roleicons.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_roleicons = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "cosmetic", "roleicons")
							end,
						},
					},
				},
				header_objectivetracker = {
					order = 6,
					type = "group",
					inline = true,
					name = L["Objective Tracker"],
					hidden  = function() return not E.Retail end,
					args = {
						toggle_objectivetracker = {
							order = 1,
							type = "toggle",
							name = L["Objective Tracker"],
							get = function(info)
								return E.db.mMT.objectivetracker.enable
							end,
							set = function(info, value)
								E.db.mMT.objectivetracker.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_objectivetracker = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "cosmetic", "objectivetracker")
							end,
						},
					},
				},
				header_unitframeicons = {
					order = 7,
					type = "group",
					inline = true,
					name = L["Unitframeicons Icon"],
					args = {
						toggle_readycheck = {
							order = 1,
							type = "toggle",
							name = L["Ready Check Icon"],
							get = function(info)
								return E.db.mMT.unitframeicons.readycheck.enable
							end,
							set = function(info, value)
								E.db.mMT.unitframeicons.readycheck.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_phase = {
							order = 2,
							type = "toggle",
							name = L["Phase Icon"],
							get = function(info)
								return E.db.mMT.unitframeicons.phase.enable
							end,
							set = function(info, value)
								E.db.mMT.unitframeicons.phase.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_resurrection = {
							order = 3,
							type = "toggle",
							name = L["Resurrection Icon"],
							get = function(info)
								return E.db.mMT.unitframeicons.resurrection.enable
							end,
							set = function(info, value)
								E.db.mMT.unitframeicons.resurrection.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_unitframeicons = {
							order = 4,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "cosmetic", "unitframeicons")
							end,
						},
					},
				},
			},
		},
		header_misc = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Misc"],
			args = {
				header_castbar = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Interrupt on CD"],
					hidden  = function() return not E.Retail end,
					args = {
						toggle_castbar = {
							order = 1,
							type = "toggle",
							name = L["Interrupt on CD"],
							get = function(info)
								return E.db.mMT.interruptoncd.enable
							end,
							set = function(info, value)
								E.db.mMT.interruptoncd.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_castbar = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "castbar")
							end,
						},
					},
				},
				header_executemarker = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Execute Marker"],
					hidden  = function() return not E.Retail end,
					args = {
						toggle_executemarker = {
							order = 1,
							type = "toggle",
							name = L["Execute Marker"],
							get = function(info)
								return E.db.mMT.nameplate.executemarker.enable
							end,
							set = function(info, value)
								E.db.mMT.nameplate.executemarker.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_executemarker = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "nameplates", "executemarker")
							end,
						},
					},
				},
				header_healthmarker = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Health markers"],
					hidden  = function() return not E.Retail end,
					args = {
						toggle_healthmarker = {
							order = 1,
							type = "toggle",
							name = L["Health markers"],
							get = function(info)
								return E.db.mMT.nameplate.healthmarker.enable
							end,
							set = function(info, value)
								E.db.mMT.nameplate.healthmarker.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_healthmarker = {
							order = 2,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "nameplates", "healthmarker")
							end,
						},
					},
				},
				header_bordercolor = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Nameplate Bordercolor"],
					args = {
						toggle_bordercolor = {
							order = 1,
							type = "toggle",
							name = L["Auto color Border"],
							get = function(info)
								return E.db.mMT.nameplate.bordercolor.border
							end,
							set = function(info, value)
								E.db.mMT.nameplate.bordercolor.border = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						toggle_glowcolor = {
							order = 2,
							type = "toggle",
							name = L["Auto color Glow"],
							get = function(info)
								return E.db.mMT.nameplate.bordercolor.glow
							end,
							set = function(info, value)
								E.db.mMT.nameplate.bordercolor.glow = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						execute_healthmarker = {
							order = 3,
							type = "execute",
							name = L["Settings"],
							func = function()
								E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "nameplates", "bordercolor")
							end,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
