local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.general.args.greeting.args = {
		header_greeting = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Welcome text"],
			args = {
				toggle_greeting = {
					order = 2,
					type = "toggle",
					name = L["Show Welcome text"],
					get = function(info)
						return E.db.mMT.general.greeting
					end,
					set = function(info, value)
						E.db.mMT.general.greeting = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
