local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.tags.args.color.args = {
		header_class = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Class Colors"],
			args = {
				color_rare = {
                    type = "color",
                    order = 1,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.rare.hex ,L["Rare"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.rare
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.rare
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
                color_relite = {
                    type = "color",
                    order = 2,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.relite.hex ,L["Rare Elite"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.relite
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.relite
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
                color_elite = {
                    type = "color",
                    order = 3,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.elite.hex ,L["Elite"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.elite
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.elite
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
                color_boss = {
                    type = "color",
                    order = 3,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.boss.hex ,L["Boss"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.boss
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.boss
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
			},
		},
        header_status = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Status Colors"],
			args = {
                color_afk = {
                    type = "color",
                    order = 1,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.afk.hex ,L["AFK"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.afk
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.afk
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
                color_dnd = {
                    type = "color",
                    order = 2,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.dnd.hex ,L["DND"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.dnd
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.dnd
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
                color_zzz = {
                    type = "color",
                    order = 3,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.zzz.hex ,L["Zzz"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.zzz
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.zzz
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
            },
        },
        header_role = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Role Colors"],
			args = {
                color_tank = {
                    type = "color",
                    order = 1,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.tank.hex ,L["Tank"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.tank
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.tank
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
                color_heal = {
                    type = "color",
                    order = 2,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.heal.hex ,L["Healer"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.heal
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.heal
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
            },
        },
        header_level = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Level Colors"],
			args = {
                color_level = {
                    type = "color",
                    order = 2,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.level.hex ,L["Level ??"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.level
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.level
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
            },
        },
        header_other = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Other Colors"],
			args = {
                color_absorbs = {
                    type = "color",
                    order = 1,
                    name = function()
                        return format("%s%s|r",E.db.mMT.tags.colors.absorbs.hex ,L["Absorbs"])
                    end,
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.mMT.tags.colors.absorbs
                        return t.r, t.g, t.b
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.mMT.tags.colors.absorbs
                        t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
                        mMT:UpdateTagSettings()
                    end,
                },
            },
        },
	}
end

tinsert(mMT.Config, configTable)
