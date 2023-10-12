local E, L = unpack(ElvUI)

local function configTable()
	E.Options.args.mMT.args.castbar.args.general.args = {
		header_castbarshield = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Castbar BG Color"],
			args = {
				toggle_BG = {
					order = 1,
					type = "toggle",
					name = L["Background Color"],
					get = function(info)
						return E.db.mMT.castbar.setBGColor
					end,
					set = function(info, value)
						E.db.mMT.castbar.setBGColor = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				range_multiplier = {
					order = 13,
					name = L["Color Multiplier"],
					type = "range",
					min = 0,
					max = 0.75,
					step = 0.1,
					get = function(info)
						return E.db.mMT.castbar.multiplier
					end,
					set = function(info, value)
						E.db.mMT.castbar.multiplier = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
