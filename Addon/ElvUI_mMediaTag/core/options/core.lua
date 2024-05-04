local E, _, _, _, _ = unpack(ElvUI)
local L = LibStub("AceLocale-3.0"):GetLocale("mMT")

local tinsert = tinsert

local function configTable()
	E.Options.args.mMT = {
		type = "group",
		name = mMT.Icon .. " " .. mMT.Name,
		order = 6,
		args = {
			logo = {
				type = "description",
				name = "",
				order = 1,
				image = function()
					return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_logo.tga", 512, 64
				end,
			},
			general = {
				order = 2,
				type = "group",
				name = L["ALL_GENERAL"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\general.tga",
				childGroups = "tab",
				args = {
					general = {
						order = 1,
						type = "group",
						name = L["ALL_GENERAL"],
						args = {},
					},
					greeting = {
						order = 2,
						type = "group",
						name = L["WLC_NAME"],
						args = {},
					},
					roll = {
						order = 3,
						type = "group",
						name = L["RB_NAME"],
						args = {},
					},
					chat = {
						order = 4,
						type = "group",
						name = L["CBT_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					keystochat = {
						order = 5,
						type = "group",
						name = L["KSTC_NAME"] .. " (!keys)",
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					instancedifficulty = {
						order = 6,
						type = "group",
						name = L["ID_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					afk = {
						order = 7,
						type = "group",
						name = L["AFK_SCR"],
						args = {},
					},
				},
			},
			datatexts = {
				order = 3,
				type = "group",
				name = L["CORE_DT"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\datatexts.tga",
				childGroups = "tab",
				args = {
					colors = {
						order = 1,
						type = "group",
						name = mMT.Name .. " " .. L["DT_COLOR"],
						args = {},
					},
					combat = {
						order = 2,
						type = "group",
						name = L["CIT_NAME"],
						args = {},
					},
					score = {
						order = 3,
						type = "group",
						name = L["MPS_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					teleports = {
						order = 4,
						type = "group",
						name = L["TP_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					profession = {
						order = 5,
						type = "group",
						name = L["PROF_NAME"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					dungeon = {
						order = 6,
						type = "group",
						name = L["ALL_DUNGEON"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					gamemenu = {
						order = 7,
						type = "group",
						name = L["GM_NAME"],
						args = {},
					},
					currency = {
						order = 7,
						type = "group",
						name = L["CURR_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					firstandsecondprofession = {
						order = 8,
						type = "group",
						name = L["FASPROF_NAME"],
						args = {},
					},
					durabilityanditemlevel = {
						order = 9,
						type = "group",
						name = L["DURILV_NAME"],
						args = {},
					},
				},
			},
			tags = {
				order = 4,
				type = "group",
				name = L["TAG_NAME"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\tags.tga",
				childGroups = "tab",
				args = {
					color = {
						order = 1,
						type = "group",
						name = L["ALL_COLORS"],
						args = {},
					},
					icon = {
						order = 2,
						type = "group",
						name = L["ALL_ICON"],
						args = {},
					},
				},
			},
			dock = {
				order = 5,
				type = "group",
				name = L["DOCK_NAME"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\dock.tga",
				childGroups = "tab",
				args = {},
			},
			castbar = {
				order = 6,
				type = "group",
				name = L["CORE_CB"],
				hidden = function()
					return not (E.Retail or E.Cata)
				end,
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\castbar.tga",
				childGroups = "tab",
				args = {
					general = {
						order = 1,
						type = "group",
						name = L["ALL_GENERAL"],
						args = {},
					},
					interrupt = {
						order = 2,
						type = "group",
						name = L["ICD_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					important = {
						order = 3,
						type = "group",
						name = L["IMPS_NAME"],
						args = {},
					},
					shield = {
						order = 4,
						type = "group",
						name = L["CBS_SHIELD"],
						args = {},
					},
				},
			},
			nameplates = {
				order = 7,
				type = "group",
				name = L["NP_NAME"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\nameplates.tga",
				childGroups = "tab",
				args = {
					healthmarker = {
						order = 1,
						type = "group",
						name = L["HM_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					executemarker = {
						order = 2,
						type = "group",
						name = L["EM_NAME"],
						hidden = function()
							return not E.Retail
						end,
						args = {},
					},
					bordercolor = {
						order = 3,
						type = "group",
						name = L["ALL_BORDER_COLOR"],
						args = {},
					},
				},
			},
			cosmetic = {
				order = 8,
				type = "group",
				name = L["CORE_COSMETICS"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\cosmetic.tga",
				childGroups = "tab",
				args = {
					tooltip = {
						order = 1,
						type = "group",
						name = L["TIP_NAME"],
						args = {},
					},
					background = {
						order = 2,
						type = "group",
						name = L["CORE_CUSTOM_UF_BG"],
						args = {},
					},
					-- classcolor = {
					-- 	order = 3,
					-- 	type = "group",
					-- 	name = L["Custom Class colors"],
					-- 	args = {},
					-- },
					roleicons = {
						order = 4,
						type = "group",
						name = L["RI_NAME"],
						hidden = function()
							return not (E.Retail or E.Cata)
						end,
						args = {},
					},
					objectivetracker = {
						order = 5,
						type = "group",
						name = L["OT_NAME"],
						hidden = function()
							return not E.Retail
						end,
						childGroups = "tab",
						args = {},
					},
					unitframeicons = {
						order = 6,
						type = "group",
						name = L["UFI_NAME"],
						childGroups = "tab",
						args = {},
					},
					portraits = {
						order = 7,
						type = "group",
						name = L["POT_NAME"],
						childGroups = "tab",
						args = {},
					},
					datapanels = {
						order = 8,
						type = "group",
						name = L["DTP_NAME"],
						childGroups = "tab",
						args = {},
					},
					questicons = {
						order = 9,
						type = "group",
						name = L["QI_NAME"],
						childGroups = "tab",
						args = {},
					},
					textures = {
						order = 20,
						type = "group",
						name = L["ALL_TEXTURES"],
						args = {},
					},
				},
			},
			-- misc = {
			-- 	order = 9,
			-- 	type = "group",
			-- 	name = L["Misc"],
			-- 	icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\misc.tga",
			-- 	childGroups = "tab",
			-- 	args = {},
			-- },
			about = {
				order = 10,
				type = "group",
				name = format("|CFF05E464%s|r", L["ABOUT_NAME"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\about.tga",
				childGroups = "tab",
				args = {},
			},
			changelog = {
				order = 11,
				type = "group",
				name = format("|CFFFF0094%s|r", L["ABOUT_CHANGELOG"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\changelog.tga",
				childGroups = "tab",
				args = {},
			},
			dev = {
				order = 20,
				type = "group",
				name = format("|CFF6559F1%s|r", L["CORE_DEV"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga",
				childGroups = "tab",
				hidden = function()
					return not mMT.DevMode
				end,
				args = {},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
