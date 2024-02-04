local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.general.args.keystochat.args = {
		header_keystochat = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Keystone to Chat"] .. " (!keys)",
			args = {
				toggle_keystochat = {
					order = 2,
					type = "toggle",
					name = L["Show Keystone to Chat"],
					get = function(info)
						return E.db.mMT.general.keystochat
					end,
					set = function(info, value)
						E.db.mMT.general.keystochat = value
                        E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
