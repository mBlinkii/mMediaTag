local E, L, V, P, G = unpack(ElvUI)
local tinsert = tinsert
local MC

function CreateConfig_General()
	local config = MC:CreateModuleConfigGroup(L["Misc"], "general", "mMT")

	config.args.greeting = {
		order = 1,
		type = "toggle",
		name = L["Welcome Text"],
		get = function(info)
			return E.global.profileCopy.mMT.general[info[#info]]
		end,
		set = function(info, value)
			E.global.profileCopy.mMT.general[info[#info]] = value
		end,
	}
	config.args.keystochat = {
		order = 2,
		type = "toggle",
		name = L["Keystone to Chat"],
		get = function(info)
			return E.global.profileCopy.mMT.general[info[#info]]
		end,
		set = function(info, value)
			E.global.profileCopy.mMT.general[info[#info]] = value
		end,
	}

	return config
end

function CreateConfig(name, section)
    local config = MC:CreateModuleConfigGroup(name, section, "mMT")

	config.args[section] = {
		order = 1,
		type = "toggle",
		name = name,
		get = function(info)
			return E.global.profileCopy.mMT[section][info[#info]]
		end,
		set = function(info, value)
			E.global.profileCopy.mMT[section][info[#info]] = value
		end,
	}

	return config
end

local function configTable()
	if not E.Options.args.profiles.args.modulecopy then
		return
	end
	MC = E.ModuleCopy
	-- local config = MC:CreateModuleConfigGroup(L["General"], "general", "mMT")

	E.Options.args.profiles.args.modulecopy.args.mMT = {
		order = 80,
		type = "group",
		name = mMT.Name,
		args = {
			general = {
                order = 1,
				type = "group",
				name = L["General"],
				childGroups = "tab",
				args = {
					general = CreateConfig_General(),
					afk = CreateConfig(L["AFK Screen"], "afk"),
					chat = CreateConfig(L["Chat Button"], "chat"),
					instancedifficulty = CreateConfig(L["Instance Difficulty"], "instancedifficulty"),
					roll = CreateConfig(L["Roll Button"], "roll"),
				},
			},
            datatexts = {
                order = 2,
				type = "group",
				name = L["DataTexts"],
				childGroups = "tab",
				args = {
                    datatextcolors = CreateConfig(L["Datatext Colors"], "datatextcolors"),
                    datatextcurrency = CreateConfig(L["Currency"], "datatextcurrency"),
                    combattime = CreateConfig(L["Combat Icon and Time"], "combattime"),
                    mpscore = CreateConfig(L["M+ Score"], "mpscore"),
                    teleports = CreateConfig(L["Teleports"], "teleports"),
                    profession = CreateConfig(L["Professions"], "profession"),
                    dungeon = CreateConfig(L["Dungeon"], "dungeon"),
                    gamemenu = CreateConfig(L["Game Menu"], "gamemenu"),
                    singleProfession = CreateConfig(L["first and second Profession"], "singleProfession"),
                    durabilityIlevel = CreateConfig(L["Durability and Item Level"], "durabilityIlevel"),
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
