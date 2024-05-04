local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local tinsert = tinsert

local function configTable()
	E.Options.args.mMT.args.datatexts.args.currency.args = {
		header_color = {
			order = 1,
			type = "group",
			inline = true,
			name = L["ALL_COLOR"],
			args = {
				colorstyle_currency = {
					order = 1,
					type = "select",
					name = L["ALL_COLOR_STYLE"],
					get = function(info)
						return E.db.mMT.datatextcurrency.style
					end,
					set = function(info, value)
						E.db.mMT.datatextcurrency.style = value
						DT:LoadDataTexts()
					end,
					values = {
						auto = L["ALL_AUTO"],
						color = L["ALL_COLOR"],
						white = L["ALL_WHITE"],
					},
				},
			},
		},
		header_icon = {
			order = 2,
			type = "group",
			inline = true,
			name = L["CURR_ICON_NAME"],
			args = {
				currency_Icon = {
					order = 1,
					type = "toggle",
					name = L["ALL_ICON"],
					desc = L["ALL_SHOW_ICON"],
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
					desc = L["CURR_SHOW_NAME"],
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
			name = L["CURR_ICON_NAME"],
			args = {
				currency_ShortNumber = {
					order = 1,
					type = "toggle",
					name = L["CURR_SHORT_NUM"],
					desc = L["CURR_SHORT_NUM"],
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
					name = L["CURR_HIDE_ZERO"],
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
					name = L["CURR_BAG_AMOUNT"],
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
					name = L["CUUR_SHOW_MAX"],
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
