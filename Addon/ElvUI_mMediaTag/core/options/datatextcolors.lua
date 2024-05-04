local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.colors.args = {
		header_colors = {
			order = 1,
			type = "group",
			inline = true,
			name = L["DT_SETTINGS_NAME"],
			args = {
                datatextgeneralcolornhc = {
                    type = "color",
                    order = 1,
                    name = L["ALL_COLOR"] .. " NHC",
                    desc = L["DT_TIP_COLOR"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colornhc
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colornhc
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
                datatextgeneralcolorhc = {
                    type = "color",
                    order = 2,
                    name = L["ALL_COLOR"] .. " HC",
                    desc = L["DT_TIP_COLOR"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colorhc
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colorhc
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
                datatextgeneralcolornm = {
                    type = "color",
                    order = 3,
                    name = L["DT_COLOR_MYHTIC"],
                    desc = L["DT_TIP_COLOR"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colormyth
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colormyth
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
                datatextgeneralcolornmp = {
                    type = "color",
                    order = 3,
                    name = L["DT_COLOR_MYHTIC"] .. "+",
                    desc = L["DT_TIP_COLOR"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colormythplus
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colormythplus
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
                datatextgeneralcolorother = {
                    type = "color",
                    order = 4,
                    name = L["DT_COLOR_OTHOR"],
                    desc = L["DT_TIP_COLOR"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colorother
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colorother
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
                datatextgeneralcolortitel = {
                    type = "color",
                    order = 5,
                    name = L["ALL_COLOR"] .. " " .. L["ALL_TITLE"],
                    desc = L["DT_TIP_COLOR"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colortitel
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colortitel
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
                datatextgeneralcolortip = {
                    type = "color",
                    order = 7,
                    name = L["DT_COLOR_TIP"],
                    desc = L["DT_TIP_COLOR"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colortip
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colortip
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
			},
		},
	}
end

tinsert(mMT.Config, configTable)
