local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.general.args.general.args = {
		header_elvui= {
			order = 1,
			type = "group",
			inline = true,
			name = L["ElvUI media color"],
			args = {
				toggle_media= {
					order = 2,
					type = "toggle",
					name = L["Auto media color"],
					desc = L["This will automatically change the ElvUI Media color to your class color."],
					get = function(info)
						return E.db.mMT.general.emediaenable
					end,
					set = function(info, value)
						E.db.mMT.general.emediaenable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
