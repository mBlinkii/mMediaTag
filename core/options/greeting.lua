local mMT, E, L, V, P, G = unpack((select(2, ...)))

local  tinsert =  tinsert
local function configTable()
	E.Options.args.mMT.args.general.args = {
        header_greeting = {
            order = 1,
            type = "header",
            name = L["Welcome text"],
        },
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
	}
end

tinsert(mMT.Config, configTable)