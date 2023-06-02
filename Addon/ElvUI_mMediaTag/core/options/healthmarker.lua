local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local tinsert = tinsert
local selectedID = nil
local selected = nil
local filterTabel = {}

local function updateFilterTabel()
	wipe(filterTabel)
	for k, v in pairs(E.db.mMT.nameplate.healthmarker.NPCs) do
		tinsert(filterTabel, k)
	end
end
local function configTable()
	E.Options.args.mMT.args.nameplates.args.healthmarker.args = {
		header_healthmarker = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Health markers"],
			args = {
				toggle_healthmarker = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Nameplate Healthmarker"],
					get = function(info)
						return E.db.mMT.nameplate.healthmarker.enable
					end,
					set = function(info, value)
						E.db.mMT.nameplate.healthmarker.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_colors = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Colors"],
			args = {
				colorindicator = {
					type = "color",
					order = 1,
					name = L["Indicator Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.nameplate.healthmarker.indicator
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.nameplate.healthmarker.indicator
						t.r, t.g, t.b = r, g, b
					end,
				},
				coloroverlay = {
					type = "color",
					order = 2,
					name = L["Overlay Color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db.mMT.nameplate.healthmarker.overlay
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.nameplate.healthmarker.overlay
						t.r, t.g, t.b, t.a = r, g, b, a
					end,
				},
			},
		},
		header_settings = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
				useDefaults = {
					order = 1,
					type = "toggle",
					name = L["Use Default NPC IDs"],
					desc = L["Uses Custom and default NPC IDs"],
					get = function(info)
						return E.db.mMT.nameplate.healthmarker.useDefaults
					end,
					set = function(info, value)
						E.db.mMT.nameplate.healthmarker.useDefaults = value
					end,
				},
				inInstance = {
					order = 2,
					type = "toggle",
					name = L["Load only in Instance"],
					desc = L["Shows the Healthmarkers only in a Instance"],
					get = function(info)
						return E.db.mMT.nameplate.healthmarker.inInstance
					end,
					set = function(info, value)
						E.db.mMT.nameplate.healthmarker.inInstance = value
					end,
				},
				overlaytexture = {
					order = 3,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Overlay Texture"],
					values = LSM:HashTable("statusbar"),
					get = function(info)
						return E.db.mMT.nameplate.healthmarker.overlaytexture
					end,
					set = function(info, value)
						E.db.mMT.nameplate.healthmarker.overlaytexture = value
					end,
				},
			},
		},
		header_ids = {
			order = 4,
			type = "group",
			inline = true,
			name = L["IDs"],
			args = {
				customid = {
					order = 1,
					name = L["Custom NPCID"],
					desc = L["Enter a NPCID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if E.db.mMT.nameplate.healthmarker.NPCs[tonumber(value)] then
							selectedID = tonumber(value)
						else
							selected = nil
							selectedID = nil
							tinsert(E.db.mMT.nameplate.healthmarker.NPCs, value, { 0, 0, 0, 0 })
						end
						updateFilterTabel()
					end,
				},
				idtable = {
					type = "select",
					order = 2,
					name = L["NPC IDS"],
					values = function()
						updateFilterTabel()
						return filterTabel
					end,
					get = function(info)
						updateFilterTabel()
						return selected
					end,
					set = function(info, value)
						selected = value
						selectedID = tonumber(filterTabel[value])
					end,
				},
				deleteid = {
					order = 3,
					name = L["Delete NPCID"],
					type = "input",
					width = "smal",
					set = function(info, value)
						if E.db.mMT.nameplate.healthmarker.NPCs[tonumber(value)] then
							E.db.mMT.nameplate.healthmarker.NPCs[tonumber(value)] = nil
							selectedID = 0
							selected = nil
							updateFilterTabel()
						end
					end,
				},
				deleteall = {
					order = 4,
					type = "execute",
					name = L["Delete all"],
					func = function()
						wipe(E.db.mMT.nameplate.healthmarker.NPCs)
						wipe(filterTabel)
					end,
				},
				header_markers = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Marker Settings"],
					args = {
						mark1 = {
							order = 1,
							name = L["Healthmarker 1"],
							desc = L["0 = disable"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.5,
							disabled = function()
								return not E.db.mMT.nameplate.healthmarker.NPCs[selectedID]
							end,
							get = function()
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									return E.db.mMT.nameplate.healthmarker.NPCs[selectedID][1]
								end
							end,
							set = function(info, value)
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									E.db.mMT.nameplate.healthmarker.NPCs[selectedID][1] = value
									if value == 0 or value == 100 then
										E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] = 0
										E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] = 0
										E.db.mMT.nameplate.healthmarker.NPCs[selectedID][4] = 0
									end
								end
							end,
						},
						mark2 = {
							order = 2,
							name = L["Healthmarker 2"],
							desc = L["0 = disable"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.5,
							disabled = function()
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									if E.db.mMT.nameplate.healthmarker.NPCs[selectedID][1] then
										if
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][1] == 0
											or E.db.mMT.nameplate.healthmarker.NPCs[selectedID][1] == 100
										then
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] = 0
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] = 0
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][4] = 0
											return true
										else
											return false
										end
									else
										return true
									end
								else
									return true
								end
							end,
							get = function()
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									return E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] or 0
								end
							end,
							set = function(info, value)
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									if value > E.db.mMT.nameplate.healthmarker.NPCs[selectedID][1] then
										value = E.db.mMT.nameplate.healthmarker.NPCs[selectedID][1] - 0.5
									end
									E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] = value
									if value == 0 or value == 100 then
										E.db.mMT.nameplate.healthmarker.NPCs[3] = 0
										E.db.mMT.nameplate.healthmarker.NPCs[4] = 0
									end
								end
							end,
						},
						mark3 = {
							order = 3,
							name = L["Healthmarker 3"],
							desc = L["0 = disable"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.5,
							disabled = function()
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									if E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] then
										if
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] == 0
											or E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] == 100
										then
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] = 0
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][4] = 0
											return true
										else
											return false
										end
									else
										return true
									end
								else
									return true
								end
							end,
							get = function()
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									return E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] or 0
								end
							end,
							set = function(info, value)
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									if value > E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] then
										value = E.db.mMT.nameplate.healthmarker.NPCs[selectedID][2] - 0.5
									end
									E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] = value
									if value == 0 or value == 100 then
										E.db.mMT.nameplate.healthmarker.NPCs[selectedID][4] = 0
									end
								end
							end,
						},
						mark4 = {
							order = 4,
							name = L["Healthmarker 4"],
							desc = L["0 = disable"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.5,
							disabled = function()
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									if E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] then
										if
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] == 0
											or E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] == 100
										then
											E.db.mMT.nameplate.healthmarker.NPCs[selectedID][4] = 0
											return true
										else
											return false
										end
									else
										return true
									end
								else
									return true
								end
							end,
							get = function()
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									return E.db.mMT.nameplate.healthmarker.NPCs[selectedID][4] or 0
								end
							end,
							set = function(info, value)
								if E.db.mMT.nameplate.healthmarker.NPCs[selectedID] then
									if value > E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] then
										value = E.db.mMT.nameplate.healthmarker.NPCs[selectedID][3] - 0.5
									end
									E.db.mMT.nameplate.healthmarker.NPCs[selectedID][4] = value
								end
							end,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
