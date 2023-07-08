local E, L = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.general.args.afk.args = {
		header_afk = {
			order = 1,
			type = "group",
			inline = true,
			name = L["AFK Screen"],
			args = {
				toggle_afk = {
					order = 2,
					type = "toggle",
					name = L["AFK Screen"],
					get = function(info)
						return E.db.mMT.general.afk
					end,
					set = function(info, value)
						E.db.mMT.general.afk = value
                        E:StaticPopup_Show("CONFIG_RL")
					end,
				},
                toggle_garbage = {
					order = 2,
					type = "toggle",
					name = L["Collect Garbage"],
					get = function(info)
						return E.db.mMT.general.garbage
					end,
					set = function(info, value)
						E.db.mMT.general.garbage = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
