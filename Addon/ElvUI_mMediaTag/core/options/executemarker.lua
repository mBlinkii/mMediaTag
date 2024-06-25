local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.nameplates.args.executemarker.args = {
		header_execute = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Execute Marker"],
			args = {
				executemarkers = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Nameplate Execute Marker"],
					get = function(info)
						return E.db.mMT.nameplate.executemarker.enable
					end,
					set = function(info, value)
						E.db.mMT.nameplate.executemarker.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_color = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Color"],
			args = {
				executeindicator = {
					type = "color",
					order = 1,
					name = L["Indicator Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.nameplate.executemarker.indicator
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.nameplate.executemarker.indicator
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
		header_settings = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
				autorange = {
					order = 1,
					type = "toggle",
					name = L["Auto value"],
					desc = L["Execute value based on your Class"],
					get = function(info)
						return E.db.mMT.nameplate.executemarker.auto
					end,
					set = function(info, value)
						E.db.mMT.nameplate.executemarker.auto = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				executerange = {
					order = 2,
					name = L["Execute value HP%"],
					type = "range",
					min = 5,
					max = 95,
					step = 1,
					disabled = function()
						return E.db.mMT.nameplate.executemarker.auto
					end,
					get = function(info)
						return E.db.mMT.nameplate.executemarker.range
					end,
					set = function(info, value)
						E.db.mMT.nameplate.executemarker.range = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
