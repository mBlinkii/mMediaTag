local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local DT = E:GetModule("DataTexts");
local addon, ns = ...

--Lua functions
local mInsert = table.insert

local function OptionsProfession()
	E.Options.args.mMediaTag.args.datatext.args.professionsmenusettings.args = {
		headerprofessions = {
			order = 1,
			type = "header",
			name = L["General"],
		},
		spacerprofessions = {
			order = 2,
			type = "description",
			name = "\n",
		},
		professionshowicon = {
			order = 3,
			type = 'toggle',
			name = L["Show Datatext Icon"],
			get = function(info)
				return E.db[mPlugin].ProfessionMenu.showicon
			end,
			set = function(info, value)
				E.db[mPlugin].ProfessionMenu.showicon = value
				DT:ForceUpdate_DataText("mProfessions")
			end,
		},
		professionicon = {
			order = 4,
			type = 'toggle',
			name = L["Icon"],
			desc = L["Displays the icons for the professions in the menu."],
			get = function(info)
				return E.db[mPlugin].mProfIcon
			end,
			set = function(info, value)
				E.db[mPlugin].mProfIcon = value
			end,
		},
	}
end

local function OptionsSystemMenu()
	E.Options.args.mMediaTag.args.datatext.args.systemmenusettings.args = {
		headersystemmenu = {
			order = 1,
			type = "header",
			name = L["General"],
		},
		systemmmenucolor = {
			order = 3,
			type = 'toggle',
			name = L["Colored System Menu"],
			desc = L["Activates a colored system menu."],
			get = function(info)
				return E.db[mPlugin].mMenuColor
			end,
			set = function(info, value)
				E.db[mPlugin].mMenuColor = value
			end,
		},
		systemmmenushowicon = {
			order = 4,
			type = 'toggle',
			name = L["Show Datatext Icon"],
			get = function(info)
				return E.db[mPlugin].SystemMenu.showicon
			end,
			set = function(info, value)
				E.db[mPlugin].SystemMenu.showicon = value
				DT:ForceUpdate_DataText("mGameMenu")
			end,
		},
		systemmmenutipinstance = {
			order = 5,
			type = 'toggle',
			name = L["Tooltip Instanceinfo"],
			desc = L["Shows Inctance Info and Mythic Plus key tone in tooltip."],
			get = function(info)
				return E.db[mPlugin].InstancInfoToolTip
			end,
			set = function(info, value)
				E.db[mPlugin].InstancInfoToolTip = value
			end,
		},
		spacersystemmmenu = {
			order = 6,
			type = "description",
			name = "\n\n",
		},
		headersystemmmenu2 = {
			order = 7,
			type = "header",
			name = L["Tooltip Mythic Plus"],
		},
		systemmmenuinstancename = {
			order = 8,
			type = 'toggle',
			name = L["Text to Instance Name"],
			desc = L["Display the instance name instead of System Menu."],
			get = function(info)
				return E.db[mPlugin].InstancInfoName
			end,
			set = function(info, value)
				E.db[mPlugin].InstancInfoName = value
			end,
		},
		systemmmenuaffix = {
			order = 9,
			type = 'toggle',
			name = L["Weekly Affixes"],
			desc = L["Shows the Weekly Affixes."],
			get = function(info)
				return E.db[mPlugin].SAffix
			end,
			set = function(info, value)
				E.db[mPlugin].SAffix = value
			end,
		},
		systemmmenukeystone = {
			order = 10,
			type = 'toggle',
			name = L["Tooltip Keystone"],
			desc = L["Shows your Keystone in the tooltip."],
			get = function(info)
				return E.db[mPlugin].SKeystone
			end,
			set = function(info, value)
				E.db[mPlugin].SKeystone = value
			end,
		},
		systemmmenugreatvault = {
			order = 11,
			type = 'toggle',
			name = L["Great Vault"],
			desc = L["Show Greaut Vault infos in the Tooltip and opens the Great Vault"],
			get = function(info)
				return E.db[mPlugin].mSystemMenu.greatvault
			end,
			set = function(info, value)
				E.db[mPlugin].mSystemMenu.greatvault = value
			end,
		},
		systemmenuscore = {
			order = 12,
			type = 'toggle',
			name = L["Mythic+ Score"],
			get = function(info)
				return E.db[mPlugin].SystemMenu.score
			end,
			set = function(info, value)
				E.db[mPlugin].SystemMenu.score = value
			end,
		},
		spacersystemmmenu2 = {
			order = 13,
			type = "description",
			name = "\n\n",
		},
		headersystemmmenu3 = {
			order = 14,
			type = "header",
			name = L["Tooltip Achievement"],
		},
		systemmmenum10 = {
			order = 15,
			type = 'toggle',
			name = L["Mythicscore 1500 Achievement"],
			desc = L["Display the Achievement for Mythic Dungeons."],
			get = function(info)
				return E.db[mPlugin].SAchievement10
			end,
			set = function(info, value)
				E.db[mPlugin].SAchievement10 = value
			end,
		},
		systemmmenum15 = {
			order = 16,
			type = 'toggle',
			name = L["Mythicscore 2000 Achievement"],
			desc = L["Display the Achievement for Mythic Dungeons."],
			get = function(info)
				return E.db[mPlugin].SAchievement15
			end,
			set = function(info, value)
				E.db[mPlugin].SAchievement15 = value
			end,
		},
		systemmmenud = {
			order = 17,
			type = 'toggle',
			name = L["Mythicscore 750 Achievement"],
			desc = L["Display the Achievement for Mythic Dungeons."],
			get = function(info)
				return E.db[mPlugin].SAchievement0
			end,
			set = function(info, value)
				E.db[mPlugin].SAchievement0 = value
			end,
		},
	}
end

local function OptionsDungeon()
	E.Options.args.mMediaTag.args.datatext.args.dungeonsetting.args = {
		headerdungeon = {
			order = 1,
			type = "header",
			name = L["General"],
		},
		dungeonshowicon = {
			order = 2,
			type = 'toggle',
			name = L["Show Datatext Icon"],
			get = function(info)
				return E.db[mPlugin].Dungeon.showicon
			end,
			set = function(info, value)
				E.db[mPlugin].Dungeon.showicon = value
				DT:ForceUpdate_DataText("mDungeon")
			end,
		},
		dungeontext = {
			order = 3,
			type = 'toggle',
			name = L["Text to Instance Name"],
			desc = L["Display the instance name instead of System Menu."],
			get = function(info)
				return E.db[mPlugin].DInstancInfoName
			end,
			set = function(info, value)
				E.db[mPlugin].DInstancInfoName = value
			end,
		},
		spacerdungeon1 = {
			order = 4,
			type = "description",
			name = "\n\n",
		},
		headerdungeon1 = {
			order = 5,
			type = "header",
			name = L["Tooltip Mythic Plus"],
		},
		dungeonaffix = {
			order = 6,
			type = 'toggle',
			name = L["Weekly Affixes"],
			desc = L["Shows the Weekly Affixes."],
			get = function(info)
				return E.db[mPlugin].DAffix
			end,
			set = function(info, value)
				E.db[mPlugin].DAffix = value
			end,
		},
		dungeonkeaystone = {
			order = 7,
			type = 'toggle',
			name = L["Tooltip Keystone"],
			desc = L["Shows your Keystone in the tooltip."],
			get = function(info)
				return E.db[mPlugin].DKeystone
			end,
			set = function(info, value)
				E.db[mPlugin].DKeystone = value
			end,
		},
		spacerdungeon2 = {
			order = 8,
			type = "description",
			name = "\n\n",
		},
		headerdungeon2 = {
			order = 9,
			type = "header",
			name = L["Tooltip Achievement"],
		},
		dungeonm10 = {
			order = 10,
			type = 'toggle',
			name = L["Mythicscore 1500 Achievement"],
			desc = L["Display the Achievement for Mythic Dungeons."],
			get = function(info)
				return E.db[mPlugin].DAchievement10
			end,
			set = function(info, value)
				E.db[mPlugin].DAchievement10 = value
			end,
		},
		dungeonm15 = {
			order = 11,
			type = 'toggle',
			name = L["Mythicscore 2000 Achievement"],
			desc = L["Display the Achievement for Mythic Dungeons."],
			get = function(info)
				return E.db[mPlugin].DAchievement15
			end,
			set = function(info, value)
				E.db[mPlugin].DAchievement15 = value
			end,
		},
		dungeond = {
			order = 12,
			type = 'toggle',
			name = L["Mythicscore 750 Achievement"],
			desc = L["Display the Achievement for Mythic Dungeons."],
			get = function(info)
				return E.db[mPlugin].DAchievement0
			end,
			set = function(info, value)
				E.db[mPlugin].DAchievement0 = value
			end,
		},
		dungeonscore = {
			order = 13,
			type = 'toggle',
			name = L["Mythic+ Score"],
			get = function(info)
				return E.db[mPlugin].Dungeon.score
			end,
			set = function(info, value)
				E.db[mPlugin].Dungeon.score = value
			end,
		},
	}
end

if MediaTagGameVersion.retail then
	mInsert(ns.Config, OptionsProfession)
	mInsert(ns.Config, OptionsDungeon)
end
mInsert(ns.Config, OptionsSystemMenu)