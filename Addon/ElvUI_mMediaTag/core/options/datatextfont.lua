local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.settings.args.font.args = {
		header_font = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Font Settings"],
			args = {
				fontsize = {
					order = 1,
					name = L["Font Size"],
					type = "range",
					min = 1,
					max = 64,
					step = 1,
					softMin = 8,
					softMax = 32,
					get = function(info)
						return E.db.mMT.general.datatextfontsize
					end,
					set = function(info, value)
						E.db.mMT.general.datatextfontsize = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
