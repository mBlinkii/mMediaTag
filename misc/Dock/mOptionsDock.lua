local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local pairs = pairs
local format = format
local tonumber = tonumber
local strjoin = strjoin
local select = select
local mInsert = table.insert

--Variables
local LSM = LibStub("LibSharedMedia-3.0")
local TextureList, mIconsList = nil, nil
local mFontFlags = {
	NONE = L["NONE"],
	OUTLINE = "Outline",
	THICKOUTLINE = "Thick",
	MONOCHROME = "|cffaaaaaaMono|r",
	MONOCHROMEOUTLINE = "|cffaaaaaaMono|r Outline",
	MONOCHROMETHICKOUTLINE = "|cffaaaaaaMono|r Thick",
}
local ExampleDockSettings = { top = false }
local mGuild = L["Guild"]

if E.Retail then
	mGuild = GUILD_AND_COMMUNITIES
end

local function mTextureList()
	if not TextureList then
		local tmpTexture = {}
		for i in pairs(mIconsList) do
			tmpTexture[i] = mIconsList[i].icon
		end
		TextureList = tmpTexture
	end
	return TextureList
end

local function mTGAtoIcon(file, name, i)
	return format("|T%s:16:16:0:0:128:128|t %s - %s", file, name, i)
end

local function SetupDockIconList()
	if not mIconsList then
		local tmpIcon = {}
		local tIndex = 1

		-- Collection
		for i = 1, 19, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\collection\\collection%s.tga", i)
			tmpIcon["Collection" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "Collection", i) }
		end

		-- Other
		for i = 1, 34, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\other\\other%s.tga", i)
			tmpIcon["Other" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "Other", i) }
		end

		-- Quest
		for i = 1, 19, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\quest\\quest%s.tga", i)
			tmpIcon["Quest" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "Quest", i) }
		end

		-- Shop
		for i = 1, 7, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\shop\\shop%s.tga", i)
			tmpIcon["Shop" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "Shop", i) }
		end

		-- Social
		for i = 1, 19, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\social\\social%s.tga", i)
			tmpIcon["Social" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "Social", i) }
		end

		-- FPS
		for i = 1, 3, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\fps%s.tga", i)
			tmpIcon["FPS" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "FPS", i) }
		end

		-- MS
		for i = 1, 3, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\ms%s.tga", i)
			tmpIcon["MS" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "MS", i) }
		end

		-- System
		for i = 1, 45, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\system%s.tga", i)
			tmpIcon["System" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "System", i) }
		end

		-- Toy
		for i = 1, 25, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\toy\\toy%s.tga", i)
			tmpIcon["Toy" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "Toy", i) }
		end

		-- Colored
		for i = 1, 78, 1 do
			local path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\colored\\colored%s.tga", i)
			tmpIcon["Colored" .. i] = { ["file"] = path, ["icon"] = mTGAtoIcon(path, "Colored", i) }
		end

		mIconsList = tmpIcon
	end
end

local function OptionsDock()
	SetupDockIconList()

	E.Options.args.mMediaTag.args.mdock.args = {
		dockgeneral = {
			order = 10,
			type = "group",
			name = L["General"],
			args = {
				headerdockgeneralcolor = {
					order = 0,
					type = "header",
					name = L["Color"],
				},
				docknormalstyle = {
					order = 10,
					type = "select",
					name = L["Normal Color Style"],
					get = function(info)
						return E.db[mPlugin].mDock.normal.style
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.normal.style = value
						DT:LoadDataTexts()
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				docknormalcolor = {
					type = "color",
					order = 11,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db[mPlugin].mDock.normal
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.normal
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:LoadDataTexts()
					end,
				},
				dockgeneralspacer1 = {
					order = 19,
					type = "description",
					name = "\n",
				},
				dockhoverstyle = {
					order = 20,
					type = "select",
					name = L["Hover Color Style"],
					get = function(info)
						return E.db[mPlugin].mDock.hover.style
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.hover.style = value
						DT:LoadDataTexts()
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				dockhovercolor = {
					type = "color",
					order = 21,
					name = L["Custom hover Color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db[mPlugin].mDock.hover
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.hover
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:LoadDataTexts()
					end,
				},
				dockgeneralspacer2 = {
					order = 29,
					type = "description",
					name = "\n",
				},
				dockclickstyle = {
					order = 30,
					type = "select",
					name = L["Click Color Style"],
					get = function(info)
						return E.db[mPlugin].mDock.click.style
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.click.style = value
						DT:LoadDataTexts()
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				dockclickcolor = {
					type = "color",
					order = 31,
					name = L["Custom click Color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db[mPlugin].mDock.click
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.click
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:LoadDataTexts()
					end,
				},
				dockgeneralspacer3 = {
					order = 39,
					type = "description",
					name = "\n",
				},
				docknotificationstyle = {
					order = 40,
					type = "select",
					name = L["Nottification Color Style"],
					get = function(info)
						return E.db[mPlugin].mDock.nottification.style
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.nottification.style = value
						DT:LoadDataTexts()
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				docknotificationcolor = {
					type = "color",
					order = 42,
					name = L["Custom nottification Color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db[mPlugin].mDock.nottification
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.nottification
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:LoadDataTexts()
					end,
				},
				headerdockgeneralsettings = {
					order = 50,
					type = "header",
					name = L["Settings"],
				},

				dockgeneraltip = {
					order = 56,
					type = "toggle",
					name = L["Tooltip"],
					get = function(info)
						return E.db[mPlugin].mDock.tip.enable
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.tip.enable = value
					end,
				},
				dockgeneralautogrow = {
					order = 57,
					type = "toggle",
					name = L["Auto Hover growsize"],
					get = function(info)
						return E.db[mPlugin].mDock.autogrow
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.autogrow = value
						DT:LoadDataTexts()
					end,
				},
				dockgeneralgrowsize = {
					order = 58,
					name = L["Hover growsize"],
					type = "range",
					min = 2,
					max = 128,
					step = 2,
					softMin = 2,
					softMax = 128,
					get = function(info)
						return E.db[mPlugin].mDock.growsize
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.growsize = value
						DT:LoadDataTexts()
					end,
					disabled = function()
						return E.db[mPlugin].mDock.autogrow
					end,
				},
				dockgeneralspacer6 = {
					order = 59,
					type = "description",
					name = "\n",
				},
				headerdockgeneralfont = {
					order = 60,
					type = "header",
					name = L["Font"],
				},
				dockgeneralfont = {
					type = "select",
					dialogControl = "LSM30_Font",
					order = 61,
					name = L["Default Font"],
					values = LSM:HashTable("font"),
					get = function(info)
						return E.db[mPlugin].mDock.font
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.font = value
						DT:LoadDataTexts()
					end,
				},
				dockgeneralfontStyle = {
					type = "select",
					order = 62,
					name = L["Font contour"],
					values = mFontFlags,
					get = function(info)
						return E.db[mPlugin].mDock.fontflag
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.fontflag = value
						DT:LoadDataTexts()
					end,
				},
				dockgeneralcustomfontSize = {
					order = 63,
					name = L["Custom Font Size"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.customfontzise
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.customfontzise = value
						DT:LoadDataTexts()
					end,
				},
				dockgeneralfontSize = {
					order = 64,
					name = L["Font Size"],
					type = "range",
					min = 6,
					max = 64,
					step = 1,
					softMin = 8,
					softMax = 32,
					get = function(info)
						return E.db[mPlugin].mDock.fontSize
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.fontSize = value
						DT:LoadDataTexts()
					end,
					disabled = function()
						return not E.db[mPlugin].mDock.customfontzise
					end,
				},
				dockgeneralfontcolor = {
					type = "color",
					order = 65,
					name = L["Custom Font Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].mDock.fontcolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mDock.fontcolor
						t.r, t.g, t.b = r, g, b
						DT:LoadDataTexts()
					end,
				},
			},
		},
		dockachievment = {
			order = 20,
			type = "group",
			name = ACHIEVEMENT_BUTTON,
			args = {
				dockachievmenticon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.achievement.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.achievement.name = value
						E.db[mPlugin].mDock.achievement.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mAchievement")
					end,
					values = mTextureList(),
				},
				achievmenttoggle = {
					order = 2,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.achievement.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.achievement.customcolor = value
						DT:ForceUpdate_DataText("mAchievement")
					end,
				},
				achievmentcolor = {
					type = "color",
					order = 3,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.achievement.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.achievement.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.achievement.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mAchievement")
					end,
				},
			},
		},
		dockblizzardstore = {
			order = 30,
			type = "group",
			name = BLIZZARD_STORE,
			args = {
				dockblizzardstoreicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.blizzardstore.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.blizzardstore.name = value
						E.db[mPlugin].mDock.blizzardstore.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mBlizzardStore")
					end,
					values = mTextureList(),
				},
				blizzardstoretoggle = {
					order = 2,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.blizzardstore.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.blizzardstore.customcolor = value
						DT:ForceUpdate_DataText("mBlizzardStore")
					end,
				},
				blizzardstorecolor = {
					type = "color",
					order = 3,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.blizzardstore.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.blizzardstore.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.blizzardstore.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mBlizzardStore")
					end,
				},
			},
		},
		dockcharcter = {
			order = 40,
			type = "group",
			name = CHARACTER_BUTTON,
			args = {
				dockcharctericon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.character.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.character.name = value
						E.db[mPlugin].mDock.character.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mCharacter")
					end,
					values = mTextureList(),
				},
				dockcharcteroptioncolor = {
					order = 2,
					type = "select",
					name = L["Text Color Styl"],
					get = function(info)
						return E.db[mPlugin].mDock.character.color
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.character.color = value
						DT:ForceUpdate_DataText("mCharacter")
					end,
					values = {
						default = L["Default"],
						custom = L["Custom"],
						elvui = L["ElvUI"],
					},
				},
				dockcharcteroption = {
					order = 3,
					type = "select",
					name = L["Show Text on Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.character.option
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.character.option = value
						DT:ForceUpdate_DataText("mCharacter")
					end,
					values = {
						none = L["NONE"],
						durability = L["Durability"],
						ilvl = L["Itemlevel"],
					},
				},
				charactertoggle = {
					order = 4,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.character.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.character.customcolor = value
						DT:ForceUpdate_DataText("mCharacter")
					end,
				},
				charactercolor = {
					type = "color",
					order = 5,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.character.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.character.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.character.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mCharacter")
					end,
				},
			},
		},
		dockcollection = {
			order = 50,
			type = "group",
			name = COLLECTIONS,
			args = {
				dockcollectionicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.collection.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.collection.name = value
						E.db[mPlugin].mDock.collection.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mCollectionsJourna")
					end,
					values = mTextureList(),
				},
				collectiontoggle = {
					order = 2,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.collection.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.collection.customcolor = value
						DT:ForceUpdate_DataText("mCollectionsJourna")
					end,
				},
				collectioncolor = {
					type = "color",
					order = 3,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.collection.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.collection.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.collection.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mCollectionsJourna")
					end,
				},
			},
		},
		dockencounter = {
			order = 60,
			type = "group",
			name = ENCOUNTER_JOURNAL,
			args = {
				dockencountericon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.encounter.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.encounter.name = value
						E.db[mPlugin].mDock.encounter.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mEncounterJournal")
					end,
					values = mTextureList(),
				},
				encountertoggle = {
					order = 2,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.encounter.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.encounter.customcolor = value
						DT:ForceUpdate_DataText("mEncounterJournal")
					end,
				},
				encountercolor = {
					type = "color",
					order = 3,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.encounter.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.encounter.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.encounter.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mEncounterJournal")
					end,
				},
			},
		},
		dockguild = {
			order = 70,
			type = "group",
			name = mGuild,
			args = {
				dockguildicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.guild.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.guild.name = value
						E.db[mPlugin].mDock.guild.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mGuild")
					end,
					values = mTextureList(),
				},
				dockguildcolor = {
					order = 2,
					type = "select",
					name = L["Text Color Styl"],
					get = function(info)
						return E.db[mPlugin].mDock.guild.color
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.guild.color = value
						DT:ForceUpdate_DataText("mGuild")
					end,
					values = {
						custom = L["Custom"],
						default = L["Default"],
					},
				},
				guildtoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.guild.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.guild.customcolor = value
						DT:ForceUpdate_DataText("mGuild")
					end,
				},
				guildcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.guild.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.guild.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.guild.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mGuild")
					end,
				},
			},
		},
		docklfd = {
			order = 80,
			type = "group",
			name = DUNGEONS_BUTTON,
			args = {
				docklfdicon = {
					order = 10,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.lfd.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.name = value
						E.db[mPlugin].mDock.lfd.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mLFDTool")
					end,
					values = mTextureList(),
				},
				docklfdgreatvault = {
					order = 20,
					type = "toggle",
					name = L["Great Vault"],
					desc = L["Show Greaut Vault infos in the Tooltip and opens the Great Vault"],
					get = function(info)
						return E.db[mPlugin].mDock.lfd.greatvault
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.greatvault = value
					end,
				},
				docklfdaffixes = {
					order = 40,
					type = "toggle",
					name = L["Weekly Affixes"],
					desc = L["Shows the Weekly Affixes."],
					get = function(info)
						return E.db[mPlugin].mDock.lfd.affix
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.affix = value
					end,
				},
				docklfdkeystone = {
					order = 50,
					type = "toggle",
					name = L["Tooltip Keystone"],
					desc = L["Shows your Keystone in the tooltip."],
					get = function(info)
						return E.db[mPlugin].mDock.lfd.keystone
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.keystone = value
					end,
				},
				docklfddifficulty = {
					order = 60,
					type = "toggle",
					name = L["Difficulty Text"],
					get = function(info)
						return E.db[mPlugin].mDock.lfd.difficulty
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.difficulty = value
						DT:ForceUpdate_DataText("mLFDTool")
					end,
				},
				docklfdcta = {
					order = 60,
					type = "toggle",
					name = L["Call To Arms"],
					get = function(info)
						return E.db[mPlugin].mDock.lfd.cta
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.ctm = value
						DT:ForceUpdate_DataText("mLFDTool")
					end,
				},
				docklfdscore = {
					order = 61,
					type = "toggle",
					name = L["Mythic+ Score"],
					get = function(info)
						return E.db[mPlugin].mDock.lfd.score
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.score = value
						DT:ForceUpdate_DataText("mLFDTool")
					end,
				},
				lfdtoggle = {
					order = 61,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.lfd.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.lfd.customcolor = value
						DT:ForceUpdate_DataText("mLFDTool")
					end,
				},
				lfdcolor = {
					type = "color",
					order = 62,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.lfd.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.lfd.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.lfd.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mLFDTool")
					end,
				},
			},
		},
		dockmainmenu = {
			order = 90,
			type = "group",
			name = MAINMENU_BUTTON,
			args = {
				dockmainmenuicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.mainmenu.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.mainmenu.name = value
						E.db[mPlugin].mDock.mainmenu.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mMainMenu")
					end,
					values = mTextureList(),
				},
				dockmainmenucolor = {
					order = 2,
					type = "select",
					name = L["Text Color Styl"],
					get = function(info)
						return E.db[mPlugin].mDock.mainmenu.color
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.mainmenu.color = value
						DT:ForceUpdate_DataText("mMainMenu")
					end,
					values = {
						default = L["Default"],
						elvui = L["ElvUI"],
					},
				},
				dockmainmenuoption = {
					order = 3,
					type = "select",
					name = L["Show Text on Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.mainmenu.option
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.mainmenu.option = value
						if value == "fps" then
							E.db[mPlugin].mDock.mainmenu.text = "FPS"
						else
							E.db[mPlugin].mDock.mainmenu.text = "MS"
						end
						DT:ForceUpdate_DataText("mMainMenu")
					end,
					values = {
						none = L["NONE"],
						fps = L["FPS"],
						ms = L["MS"],
					},
				},
				dockmainmenutext = {
					order = 4,
					name = L["Text"],
					type = "input",
					width = "smal",
					get = function()
						return E.db[mPlugin].mDock.mainmenu.text
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.mainmenu.text = value
						DT:ForceUpdate_DataText("mMainMenu")
					end,
				},
				dockmainmenusound = {
					order = 5,
					type = "toggle",
					name = L["Volume Control"],
					get = function(info)
						return E.db[mPlugin].mDock.mainmenu.sound
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.mainmenu.sound = value
						DT:ForceUpdate_DataText("mMainMenu")
					end,
				},
				mainmenutoggle = {
					order = 6,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.mainmenu.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.mainmenu.customcolor = value
						DT:ForceUpdate_DataText("mMainMenu")
					end,
				},
				mainmenucolor = {
					type = "color",
					order = 7,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.mainmenu.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.mainmenu.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.mainmenu.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mMainMenu")
					end,
				},
			},
		},
		dockquest = {
			order = 100,
			type = "group",
			name = QUESTLOG_BUTTON,
			args = {
				dockquesticon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.quest.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.quest.name = value
						E.db[mPlugin].mDock.quest.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mQuest")
					end,
					values = mTextureList(),
				},
				questtoggle = {
					order = 2,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.quest.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.quest.customcolor = value
						DT:ForceUpdate_DataText("mQuest")
					end,
				},
				questcolor = {
					type = "color",
					order = 3,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.quest.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.quest.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.quest.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mQuest")
					end,
				},
			},
		},
		dockspellbook = {
			order = 110,
			type = "group",
			name = SPELLBOOK_ABILITIES_BUTTON,
			args = {
				dockspellbookicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.spellbook.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.spellbook.name = value
						E.db[mPlugin].mDock.spellbook.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mSpellBook")
					end,
					values = mTextureList(),
				},
				spellbooktoggle = {
					order = 2,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.spellbook.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.spellbook.customcolor = value
						DT:ForceUpdate_DataText("mSpellBook")
					end,
				},
				spellbookcolor = {
					type = "color",
					order = 3,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.spellbook.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.spellbook.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.spellbook.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mSpellBook")
					end,
				},
			},
		},
		docktalent = {
			order = 120,
			type = "group",
			name = TALENTS_BUTTON,
			args = {
				docktalenticon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.talent.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.talent.name = value
						E.db[mPlugin].mDock.talent.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mTalent")
					end,
					values = mTextureList(),
				},
				docktalentrole = {
					order = 2,
					type = "toggle",
					name = L["Show Role if in Group"],
					get = function(info)
						return E.db[mPlugin].mDock.talent.showrole
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.talent.showrole = value
					end,
				},
				talenttoggle = {
					order = 3,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.talent.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.talent.customcolor = value
						DT:ForceUpdate_DataText("mTalent")
					end,
				},
				talentcolor = {
					type = "color",
					order = 4,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.talent.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.talent.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.talent.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mTalent")
					end,
				},
			},
		},
		dockitemlevel = {
			order = 130,
			type = "group",
			name = L["Itemlevel"],
			args = {
				dockitemlevelicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.itemlevel.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.itemlevel.name = value
						E.db[mPlugin].mDock.itemlevel.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mItemLevel")
					end,
					values = mTextureList(),
				},
				dockitemleveltext = {
					order = 2,
					name = L["Text"],
					type = "input",
					width = "smal",
					get = function()
						return E.db[mPlugin].mDock.itemlevel.text
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.itemlevel.text = value
						DT:ForceUpdate_DataText("mItemLevel")
					end,
				},
				dockitemlevelcolor = {
					order = 3,
					type = "select",
					name = L["Text Color Styl"],
					get = function(info)
						return E.db[mPlugin].mDock.itemlevel.color
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.itemlevel.color = value
						DT:ForceUpdate_DataText("mItemLevel")
					end,
					values = {
						default = L["Default"],
						custom = L["Custom"],
						class = L["Class"],
					},
				},
				dockitemlevelonlytext = {
					order = 4,
					type = "toggle",
					name = L["Show only Text"],
					get = function(info)
						return E.db[mPlugin].mDock.itemlevel.onlytext
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.itemlevel.onlytext = value
						DT:ForceUpdate_DataText("mItemLevel")
					end,
				},
				itemleveltoggle = {
					order = 4,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.itemlevel.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.itemlevel.customcolor = value
						DT:ForceUpdate_DataText("mItemLevel")
					end,
				},
				itemlevelcolor = {
					type = "color",
					order = 5,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.itemlevel.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.itemlevel.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.itemlevel.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mItemLevel")
					end,
				},
			},
		},
		dockfriends = {
			order = 140,
			type = "group",
			name = L["Friends"],
			args = {
				dockfriendsicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.friends.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.friends.name = value
						E.db[mPlugin].mDock.friends.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mFriends")
					end,
					values = mTextureList(),
				},
				dockfriendcolor = {
					order = 2,
					type = "select",
					name = L["Text Color Styl"],
					get = function(info)
						return E.db[mPlugin].mDock.friends.color
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.friends.color = value
						DT:ForceUpdate_DataText("mFriends")
					end,
					values = {
						custom = L["Custom"],
						default = L["Default"],
					},
				},
				friendstoggle = {
					order = 4,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.friends.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.friends.customcolor = value
						DT:ForceUpdate_DataText("mFriends")
					end,
				},
				friendslcolor = {
					type = "color",
					order = 5,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.friends.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.friends.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.friends.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mFriends")
					end,
				},
			},
		},
		dockdurability = {
			order = 150,
			type = "group",
			name = L["Durability"],
			args = {
				dockdurabilityicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.durability.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.durability.name = value
						E.db[mPlugin].mDock.durability.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mDurability")
					end,
					values = mTextureList(),
				},
				dockdurabilitycolor = {
					order = 2,
					type = "select",
					name = L["Text Color Styl"],
					get = function(info)
						return E.db[mPlugin].mDock.durability.color
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.durability.color = value
						DT:ForceUpdate_DataText("mDurability")
					end,
					values = {
						default = L["Default"],
						custom = L["Custom"],
						class = L["Class"],
					},
				},
				dockdurabilitytext = {
					order = 3,
					type = "toggle",
					name = L["Show only Text"],
					get = function(info)
						return E.db[mPlugin].mDock.durability.onlytext
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.durability.onlytext = value
						DT:ForceUpdate_DataText("mDurability")
					end,
				},
				durabilitytoggle = {
					order = 4,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.durability.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.durability.customcolor = value
						DT:ForceUpdate_DataText("mDurability")
					end,
				},
				durabilitycolor = {
					type = "color",
					order = 5,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.durability.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.durability.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.durability.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mDurability")
					end,
				},
			},
		},
		dockfpsms = {
			order = 160,
			type = "group",
			name = L["FPS / MS"],
			args = {
				dockfpsmsicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.fpsms.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.fpsms.name = value
						E.db[mPlugin].mDock.fpsms.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mFPSMS")
					end,
					values = mTextureList(),
				},
				dockfpsmscolor = {
					order = 2,
					type = "select",
					name = L["Text Color Styl"],
					get = function(info)
						return E.db[mPlugin].mDock.fpsms.color
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.fpsms.color = value
						DT:ForceUpdate_DataText("mFPSMS")
					end,
					values = {
						default = L["Default"],
						elvui = L["ElvUI"],
					},
				},
				dockfpsmsoption = {
					order = 3,
					type = "select",
					name = L["Show Text on Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.fpsms.option
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.fpsms.option = value
						if value == "fps" then
							E.db[mPlugin].mDock.fpsms.text = "FPS"
						else
							E.db[mPlugin].mDock.fpsms.text = "MS"
						end
						DT:ForceUpdate_DataText("mFPSMS")
					end,
					values = {
						fps = L["FPS"],
						ms = L["MS"],
					},
				},
				dockfpsmstext = {
					order = 4,
					name = L["Text"],
					type = "input",
					width = "smal",
					get = function()
						return E.db[mPlugin].mDock.fpsms.text
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.fpsms.text = value
						DT:ForceUpdate_DataText("mFPSMS")
					end,
				},
				fpsmstoggle = {
					order = 5,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.fpsms.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.fpsms.customcolor = value
						DT:ForceUpdate_DataText("mFPSMS")
					end,
				},
				fpsmscolor = {
					type = "color",
					order = 6,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.fpsms.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.fpsms.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.fpsms.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mFPSMS")
					end,
				},
			},
		},
		dockprofession = {
			order = 170,
			type = "group",
			name = L["Professions"],
			args = {
				dockprofessionicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.profession.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.profession.name = value
						E.db[mPlugin].mDock.profession.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mProfession")
					end,
					values = mTextureList(),
				},
				professiontoggle = {
					order = 5,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.profession.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.profession.customcolor = value
						DT:ForceUpdate_DataText("mProfession")
					end,
				},
				professioncolor = {
					type = "color",
					order = 6,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.profession.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.profession.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.profession.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mProfession")
					end,
				},
			},
		},
		dockcalendar = {
			order = 180,
			type = "group",
			name = L["Calendar"],
			args = {
				dockcalendaricon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.calendar.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.calendar.name = value
						E.db[mPlugin].mDock.calendar.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mCalendar")
					end,
					values = mTextureList(),
				},
				dockcalendaroption = {
					order = 2,
					type = "select",
					name = L["Date Style"],
					get = function(info)
						return E.db[mPlugin].mDock.calendar.option
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.calendar.option = value
						DT:ForceUpdate_DataText("mCalendar")
					end,
					values = {
						none = L["NONE"],
						de = "DE",
						us = "US",
						gb = "GB",
					},
				},
				dockcalendarshowyear = {
					order = 3,
					type = "toggle",
					name = L["Show Year"],
					get = function(info)
						return E.db[mPlugin].mDock.calendar.showyear
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.calendar.showyear = value
						DT:ForceUpdate_DataText("mCalendar")
					end,
				},
				calendardateicon = {
					order = 5,
					name = L["Use Dateicons"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.calendar.dateicon
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.calendar.dateicon = value
						DT:ForceUpdate_DataText("mCalendar")
					end,
				},
				calendartoggle = {
					order = 6,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.calendar.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.calendar.customcolor = value
						DT:ForceUpdate_DataText("mCalendar")
					end,
				},
				calendarcolor = {
					type = "color",
					order = 7,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.calendar.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.calendar.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.calendar.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mCalendar")
					end,
				},
			},
		},
		dockvolume = {
			order = 190,
			type = "group",
			name = L["Volume"],
			args = {
				dockvolumeicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.volume.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.volume.name = value
						E.db[mPlugin].mDock.volume.path = mIconsList[value].file
						DT:ForceUpdate_DataText("mVolume")
					end,
					values = mTextureList(),
				},
				dockvolumetext = {
					order = 2,
					type = "toggle",
					name = L["Show Text"],
					get = function(info)
						return E.db[mPlugin].mDock.volume.showtext
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.volume.showtext = value
						DT:ForceUpdate_DataText("mVolume")
					end,
				},
				volumetoggle = {
					order = 5,
					name = L["Custom color"],
					type = "toggle",
					get = function(info)
						return E.db[mPlugin].mDock.volume.customcolor
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.volume.customcolor = value
						DT:ForceUpdate_DataText("mVolume")
					end,
				},
				volumecolor = {
					type = "color",
					order = 6,
					name = L["Custom Icon Color"],
					hasAlpha = true,
					disabled = function()
						return not E.db[mPlugin].mDock.volume.customcolor
					end,
					get = function(info)
						local t = E.db[mPlugin].mDock.volume.iconcolor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db[mPlugin].mDock.volume.iconcolor
						t.r, t.g, t.b, t.a = r, g, b, a
						DT:ForceUpdate_DataText("mVolume")
					end,
				},
			},
		},
		docknottification = {
			order = 200,
			type = "group",
			name = L["Nottification"],
			args = {
				docknottificationicon = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db[mPlugin].mDock.nottification.name
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.nottification.name = value
						E.db[mPlugin].mDock.nottification.path = mIconsList[value].file
						DT:LoadDataTexts()
					end,
					values = mTextureList(),
				},
				docknottificationiconsize = {
					order = 2,
					name = L["Icon size"],
					type = "range",
					min = 16,
					max = 128,
					step = 2,
					get = function(info)
						return E.db[mPlugin].mDock.nottification.size
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.nottification.size = value
						DT:LoadDataTexts()
					end,
				},
				docknottificationspacer1 = {
					order = 3,
					type = "description",
					name = "\n",
				},
				docknottificationiconflash = {
					order = 4,
					type = "toggle",
					name = L["Icon flash"],
					get = function(info)
						return E.db[mPlugin].mDock.nottification.flash
					end,
					set = function(info, value)
						E.db[mPlugin].mDock.nottification.flash = value
					end,
				},
			},
		},
		dockexample = {
			order = 300,
			type = "group",
			name = format("|CFF58D68D%s|r", L["Creat mDock"]),
			args = {
				examplesdescription = {
					order = 1,
					type = "description",
					name = L["These are just examples of how to create your own dock with ElvUI's custom bars.\n\nTo delete the examples completely, you have to delete the bars in the ElvUI settings. (ElvUI>Datatext>Bars> click on the bar you want to delete, scroll down and click delete).\n\n\nTo create your own bar you have to go to ElvUI under ElvUI>Datatext>Bars Steps 1. enter name press OK and click Add, set the width of the bar depends on how many icons you want to display, the height of the bar is also the size of the icons. Set the number of data text and now you only need to assign the icons to the places, for example 1 = Dock FPS, 2 = Dock Profession and so on.\n\n"],
				},
				examplesheader = {
					order = 2,
					type = "header",
					name = "",
				},
				exampletop = {
					order = 3,
					type = "toggle",
					name = L["Dock on Top"],
					get = function(info)
						return ExampleDockSettings.top
					end,
					set = function(info, value)
						ExampleDockSettings.top = value
					end,
				},
				examplespacer1 = {
					order = 4,
					type = "description",
					name = "\n",
				},
				dockbar1 = {
					order = 11,
					type = "execute",
					name = L["Dockbar mDock Full"],
					func = function()
						mMT:mDockFull(ExampleDockSettings.top, true)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				dockbar2 = {
					order = 21,
					type = "execute",
					name = L["Dockbar mDockMicroBar"],
					func = function()
						mMT:mDockMicroBar(ExampleDockSettings.top, true)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				dockbar3 = {
					order = 31,
					type = "execute",
					name = L["Dockbar mDock Special"],
					func = function()
						mMT:mDockSpezial(ExampleDockSettings.top, true)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				examplespacer2 = {
					order = 40,
					type = "description",
					name = "\n",
				},
				dockbardisable = {
					order = 41,
					type = "execute",
					name = L["Disable All"],
					func = function()
						mMT:mDockFull(ExampleDockSettings.top, false)
						mMT:mDockMicroBar(ExampleDockSettings.top, false)
						mMT:mDockSpezial(ExampleDockSettings.top, false)
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

mInsert(ns.Config, OptionsDock)
