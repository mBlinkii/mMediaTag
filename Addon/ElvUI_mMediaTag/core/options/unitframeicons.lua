local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.UnitframeIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end
	E.Options.args.mMT.args.unitframes.args.unitframeicons.args = {
		header_toggles = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
                toggle_readycheck = {
					order = 1,
					type = "toggle",
					name = L["Ready Check"],
					get = function(info)
						return E.db.mMT.unitframeicons.readycheck.enable
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.readycheck.enable = value
					end,
				},
                toggle_phase = {
					order = 2,
					type = "toggle",
					name = L["Phase"],
					get = function(info)
						return E.db.mMT.unitframeicons.phase.enable
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.phase.enable = value
					end,
				},
				toggle_resurrection = {
					order = 3,
					type = "toggle",
					name = L["Resurrection"],
					get = function(info)
						return E.db.mMT.unitframeicons.resurrection.enable
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.resurrection.enable = value
					end,
				},
				toggle_summon = {
					order = 3,
					type = "toggle",
					name = L["Summon"],
					get = function(info)
						return E.db.mMT.unitframeicons.summon.enable
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.summon.enable = value
					end,
				},
            },
		},
		header_readycheck = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Ready Check Icons"],
            disabled = function()
                return not E.db.mMT.unitframeicons.readycheck.enable
            end,
			args = {
				ready = {
					order = 1,
					type = "select",
					name = L["Ready"],
					get = function(info)
						return E.db.mMT.unitframeicons.readycheck.ready
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.readycheck.ready = value
					end,
					values = icons,
				},
				notready = {
					order = 2,
					type = "select",
					name = L["Not Ready"],
					get = function(info)
						return E.db.mMT.unitframeicons.readycheck.notready
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.readycheck.notready = value
					end,
					values = icons,
				},
				waiting = {
					order = 3,
					type = "select",
					name = L["Waiting"],
					get = function(info)
						return E.db.mMT.unitframeicons.readycheck.waiting
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.readycheck.waiting = value
					end,
					values = icons,
				},
			},
		},
		header_phase = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Phase"],
            disabled = function()
                return not E.db.mMT.unitframeicons.phase.enable
            end,
			args = {
				phaseicon = {
					order = 1,
					type = "select",
					name = L["Phase Icon"],
					get = function(info)
						return E.db.mMT.unitframeicons.phase.icon
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.phase.icon = value
					end,
					values = icons,
				},
                changecolors = {
					order = 2,
					type = "toggle",
					name = L["Change Icons Colors"],

					get = function(info)
						return E.db.mMT.unitframeicons.phase.color.enable
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.phase.color.enable = value
					end,
				},
                withe = {
					order = 3,
					type = "toggle",
					name = L["Always withe"],
                    disabled = function()
                        return not E.db.mMT.unitframeicons.phase.color.enable
                    end,
					get = function(info)
						return E.db.mMT.unitframeicons.phase.color.withe
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.phase.color.withe = value
					end,
				},
                color_chromie = {
					type = "color",
					order = 4,
					name = L["Chromie"],
                    disabled = function()
                        return E.db.mMT.unitframeicons.phase.color.withe
                    end,
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.unitframeicons.phase.color.chromie
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.unitframeicons.phase.color.chromie
						t.r, t.g, t.b = r, g, b
					end,
				},
                color_warmode = {
					type = "color",
					order = 5,
					name = L["Warmode"],
                    disabled = function()
                        return E.db.mMT.unitframeicons.phase.color.withe
                    end,
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.unitframeicons.phase.color.warmode
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.unitframeicons.phase.color.warmode
						t.r, t.g, t.b = r, g, b
					end,
				},
                color_sharding = {
					type = "color",
					order = 6,
					name = L["Sharding"],
                    disabled = function()
                        return E.db.mMT.unitframeicons.phase.color.withe
                    end,
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.unitframeicons.phase.color.sharding
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.unitframeicons.phase.color.sharding
						t.r, t.g, t.b = r, g, b
					end,
				},
                color_phasing = {
					type = "color",
					order = 7,
					name = L["Phasing"],
                    disabled = function()
                        return E.db.mMT.unitframeicons.phase.color.withe
                    end,
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.unitframeicons.phase.color.phasing
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.unitframeicons.phase.color.phasing
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
		header_summon = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Summon Icons"],
            disabled = function()
                return not E.db.mMT.unitframeicons.summon.enable
            end,
			args = {
				available = {
					order = 1,
					type = "select",
					name = L["Available"],
					get = function(info)
						return E.db.mMT.unitframeicons.summon.available
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.summon.available = value
					end,
					values = icons,
				},
				rejected = {
					order = 2,
					type = "select",
					name = L["Rejected"],
					get = function(info)
						return E.db.mMT.unitframeicons.summon.rejected
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.summon.rejected = value
					end,
					values = icons,
				},
				accepted = {
					order = 3,
					type = "select",
					name = L["Accepted"],
					get = function(info)
						return E.db.mMT.unitframeicons.summon.accepted
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.summon.accepted = value
					end,
					values = icons,
				},
			},
		},
		header_misc = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Misc"],
			args = {
				ready = {
					order = 1,
					type = "select",
					name = L["Resurrection"],
					disabled = function()
                        return not E.db.mMT.unitframeicons.resurrection.enable
                    end,
					get = function(info)
						return E.db.mMT.unitframeicons.resurrection.icon
					end,
					set = function(info, value)
						E.db.mMT.unitframeicons.resurrection.icon = value
					end,
					values = icons,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
