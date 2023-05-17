local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.gamemenu.args = {
		header_gamemenu = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Game Menu"],
			args = {
				toggle_icon = {
					order = 1,
					type = "toggle",
					name = L["Show Datatext Icon"],
					get = function(info)
						return E.db.mMT.gamemenu.icon
					end,
					set = function(info, value)
						E.db.mMT.gamemenu.icon = value
						DT:ForceUpdate_DataText("mGameMenu")
					end,
				},
				toggle_menuicons = {
					order = 2,
					type = "toggle",
					name = L["Icons"],
					desc = L["Displays the icons the menu list."],
					get = function(info)
						return E.db.mMT.gamemenu.menuicons
					end,
					set = function(info, value)
						E.db.mMT.gamemenu.menuicons = value
                        DT:ForceUpdate_DataText("mGameMenu")
					end,
				},
                toggle_menucolor = {
					order = 3,
					type = "toggle",
					name = L["Colored Menulist"],
					get = function(info)
						return E.db.mMT.gamemenu.color
					end,
					set = function(info, value)
						E.db.mMT.gamemenu.color = value
                        DT:ForceUpdate_DataText("mGameMenu")
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
