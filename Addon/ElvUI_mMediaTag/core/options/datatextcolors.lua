local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.settings.args.colors.args = {
		header_colors = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Datatext Options Color (Tooltip)"],
			args = {
                datatextgeneralcolornhc = {
                    type = "color",
                    order = 1,
                    name = L["Color NHC"],
                    desc = L["Custom color for Datatext Tip"],
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
                    name = L["Color HC"],
                    desc = L["Custom color for Datatext Tip"],
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
                    name = L["Color Mythic"],
                    desc = L["Custom color for Datatext Tip"],
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
                    name = L["Color Mythic+"],
                    desc = L["Custom color for Datatext Tip"],
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
                    name = L["Color other"],
                    desc = L["Custom color for Datatext Tip"],
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
                datatextgeneralcolortitle = {
                    type = "color",
                    order = 5,
                    name = L["Color Title"],
                    desc = L["Custom color for Datatext Tip"],
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.datatextcolors.colortitle
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.datatextcolors.colortitle
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                    end,
                },
                datatextgeneralcolortip = {
                    type = "color",
                    order = 7,
                    name = L["Color Tip"],
                    desc = L["Custom color for Datatext Tip"],
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