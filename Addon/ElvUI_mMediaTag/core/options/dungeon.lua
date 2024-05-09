local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.dungeon.args = {
		header_dungeon = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Dungeon"],
			args = {
				toggle_icon = {
					order = 1,
					type = "toggle",
					name = L["Show Datatext Icon"],
					get = function(info)
						return E.db.mMT.dungeon.icon
					end,
					set = function(info, value)
						E.db.mMT.dungeon.icon = value
						DT:ForceUpdate_DataText("mDungeon")
					end,
				},
				toggle_dungeontext = {
                    order = 2,
                    type = "toggle",
                    name = L["Text to Instance Name"],
                    desc = L["Display the instance name instead of Datatext name. Uses the same format as InstanceDifficulty."],
                    get = function(info)
                        return E.db.mMT.dungeon.texttoname
                    end,
                    set = function(info, value)
                        E.db.mMT.dungeon.texttoname = value
                    end,
                },
                toggle_dungeonaffix = {
                    order = 3,
                    type = "toggle",
                    name = L["Weekly Affixes"],
                    desc = L["Shows the Weekly Affixes."],
                    get = function(info)
                        return E.db.mMT.dungeon.affix
                    end,
                    set = function(info, value)
                        E.db.mMT.dungeon.affix = value
                    end,
                },
                toggle_dungeonkeaystone = {
                    order = 4,
                    type = "toggle",
                    name = L["Tooltip Keystone"],
                    desc = L["Shows your Keystone in the tooltip."],
                    get = function(info)
                        return E.db.mMT.dungeon.key
                    end,
                    set = function(info, value)
                        E.db.mMT.dungeon.key = value
                    end,
                },
                toggle_dungeonscore = {
                    order = 5,
                    type = "toggle",
                    name = L["Mythic+ Score"],
                    get = function(info)
                        return E.db.mMT.dungeon.score
                    end,
                    set = function(info, value)
                        E.db.mMT.dungeon.score = value
                    end,
                },
			},
		},
	}
end

tinsert(mMT.Config, configTable)
