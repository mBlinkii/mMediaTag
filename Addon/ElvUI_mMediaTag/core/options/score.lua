local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.UpgradeIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.datatexts.args.score.args = {
		header_mykey = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Highlight my Keystone"],
			args = {
				toggle_highlight = {
					order = 1,
					type = "toggle",
					name = L["Highlight my Keystone"],
					get = function(info)
						return E.db.mMT.mpscore.highlight
					end,
					set = function(info, value)
						E.db.mMT.mpscore.highlight = value
					end,
				},
				color_highlight = {
                    type = "color",
                    order = 2,
                    name = L["Highlight Color"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.mpscore.highlightcolor
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.mpscore.highlightcolor
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
			},
		},
		header_score = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Sort"],
			args = {
				toggle_sort = {
					order = 1,
					type = "select",
					name = L["Sort Methods"],
					get = function(info)
						return E.db.mMT.mpscore.sort
					end,
					set = function(info, value)
						E.db.mMT.mpscore.sort = value
					end,
					values = {
						AFFIX = "Weekly Affix",
						SCORE = "Weekly Score",
						OVERA = "Overall Score",
					},
				},
			},
		},
		header_icon = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Upgrade"],
			args = {
				toggle_upgrade = {
					order = 1,
					type = "toggle",
					name = L["Show weekly upgrades"],
					get = function(info)
						return E.db.mMT.mpscore.upgrade
					end,
					set = function(info, value)
						E.db.mMT.mpscore.upgrade = value
					end,
				},
				upgrade_cion = {
					order = 2,
					type = "select",
					name = L["Upgrade Icon"],
					get = function(info)
						return E.db.mMT.mpscore.icon
					end,
					set = function(info, value)
						E.db.mMT.mpscore.icon = value
					end,
					values = icons,
				},
			},
		},
		header_settings = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
				toggle_groupkeys = {
					order = 1,
					type = "toggle",
					name = L["Show Groupmember Keys."],
					get = function(info)
						return E.db.mMT.mpscore.groupkeys
					end,
					set = function(info, value)
						E.db.mMT.mpscore.groupkeys = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
