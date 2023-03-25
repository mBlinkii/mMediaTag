local mMT, E, L, V, P, G = unpack((select(2, ...)))

local  tinsert =  tinsert
local function configTable()
	E.Options.args.mMT.args.cosmetic.args.tooltip.args = {
        header_tooltip = {
            order = 1,
            type = "header",
            name = L["Tooltip Icon"],
        },
		toggle_tooltip = {
			order = 2,
			type = "toggle",
			name = L["Tooltip Icon"],
			desc = L["Enables or disables Tooltip Icon"],
			get = function(info)
				return E.db.mMT.tooltip.enable
			end,
			set = function(info, value)
				E.db.mMT.tooltip.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		spacer_tooltip = {
			order = 3,
			type = "description",
			name = "\n\n",
		},
		tooltipiconsize = {
			order = 4,
			name = L["Icon size"],
			desc = L["Tooltip Icon size."],
			type = "range",
			min = 16,
			max = 128,
			step = 2,
			get = function(info)
				return E.db.mMT.tooltip.iconsize
			end,
			set = function(info, value)
				E.db.mMT.tooltip.iconsize = value
			end,
		},
	}
end

tinsert(mMT.Config, configTable)