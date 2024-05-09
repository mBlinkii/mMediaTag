local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local tinsert = tinsert

local function configTable()
	E.Options.args.mMT.args.datatexts.args.currency.args = {
		header_color = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Color"],
			args = {
				colorstyle_currency = {
					order = 1,
					type = "select",
					name = L["Color Style"],
					get = function(info)
						return E.db.mMT.datatextcurrency.style
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.style = value
						DT:LoadDataTexts()
					end,
					values = {
						auto = L["Auto"],
						color = L["Color"],
						white = L["White"],
					},
				},
			},
		},
		header_icon = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Icon and Name"],
			args = {
				currency_Icon = {
					order = 1,
					type = "toggle",
					name = L["Icon"],
					desc = L["Show Icon"],
					get = function(info)
						return E.db.mMT.datatextcurrency.icon
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.icon = value
						DT:LoadDataTexts()
					end,
				},
				currency_Name = {
					order = 2,
					type = "toggle",
					name = L["Name"],
					desc = L["Shows Name"],
					get = function(info)
						return E.db.mMT.datatextcurrency.name
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.name = value
						DT:LoadDataTexts()
					end,
				},
			},
		},
		header_settings = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Icon and Name"],
			args = {
				currency_ShortNumber = {
					order = 1,
					type = "toggle",
					name = L["Short Number"],
					desc = L["Short Number"],
					get = function(info)
						return E.db.mMT.datatextcurrency.short
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.short = value
						DT:LoadDataTexts()
					end,
				},
				currency_Hide = {
					order = 2,
					type = "toggle",
					name = L["Hide if Zero"],
					get = function(info)
						return E.db.mMT.datatextcurrency.hide
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.hide = value
						DT:LoadDataTexts()
					end,
				},
				currency_bag = {
					order = 3,
					type = "toggle",
					name = L["Show amount in Bag"],
					get = function(info)
						return E.db.mMT.datatextcurrency.bag
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.bag = value
						DT:LoadDataTexts()
					end,
				},
				currency_max = {
					order = 4,
					type = "toggle",
					name = L["Show Max Count"],
					get = function(info)
						return E.db.mMT.datatextcurrency.max
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.max = value
						DT:LoadDataTexts()
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
