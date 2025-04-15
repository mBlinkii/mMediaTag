local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM


mMT.options.args.misc.args.lfg_invite_info.args = {
    enable = {
        order = 1,
        type = "toggle",
        name = function()
            return E.db.mMT.lfg_invite_info.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
        end,
        get = function(info)
            return E.db.mMT.lfg_invite_info.enable
        end,
        set = function(info, value)
            E.db.mMT.lfg_invite_info.enable = value
            mMT:UpdateModule("LFGInviteInfo")
        end,
    },
    demo = {
        order = 2,
        type = "execute",
        name = L["Show Frame"],
        func = function()
            mMT:UpdateModule("LFGInviteInfo", "demo")
        end,
    },
	font = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Font"],
		args = {
			font = {
                type = "select",
                dialogControl = "LSM30_Font",
                order = 1,
                name = L["Font"],
                values = LSM:HashTable("font"),
                disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
                get = function(info)
                    return E.db.mMT.lfg_invite_info.font.font
                end,
                set = function(info, value)
                    E.db.mMT.lfg_invite_info.font.font = value
                    mMT:UpdateModule("LFGInviteInfo")
                end,
            },
            fontflag = {
                type = "select",
                order = 2,
                name = L["Font contour"],
                disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
                get = function(info)
                    return E.db.mMT.lfg_invite_info.font.fontflag
                end,
                set = function(info, value)
                    E.db.mMT.lfg_invite_info.font.fontflag = value
                    mMT:UpdateModule("LFGInviteInfo")
                end,
                values = {
                    NONE = "None",
                    OUTLINE = "Outline",
                    THICKOUTLINE = "Thick",
                    SHADOW = "|cff888888Shadow|r",
                    SHADOWOUTLINE = "|cff888888Shadow|r Outline",
                    SHADOWTHICKOUTLINE = "|cff888888Shadow|r Thick",
                    MONOCHROME = "|cFFAAAAAAMono|r",
                    MONOCHROMEOUTLINE = "|cFFAAAAAAMono|r Outline",
                    MONOCHROMETHICKOUTLINE = "|cFFAAAAAAMono|r Thick",
                },
            },
			font_size = {
				order = 5,
				name = L["Font size, top line"],
				type = "range",
				min = 8,
				max = 64,
				step = 1,
				disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
				get = function(info)
					return E.db.mMT.lfg_invite_info.font.size
				end,
				set = function(info, value)
					E.db.mMT.lfg_invite_info.font.size = value
					mMT:UpdateModule("LFGInviteInfo")
				end,
			},
			font_size2 = {
				order = 6,
				name = L["Font size, bottom line"],
				type = "range",
				min = 8,
				max = 64,
				step = 1,
				disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
				get = function(info)
					return E.db.mMT.lfg_invite_info.font.size2
				end,
				set = function(info, value)
					E.db.mMT.lfg_invite_info.font.size2 = value
					mMT:UpdateModule("LFGInviteInfo")
				end,
			},
		},
	},
    settings = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
            color_line_a = {
				type = "color",
				order = 1,
				name = L["First line color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.lfg_invite_info.colors.line_a)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.lfg_invite_info.colors.line_a = hex
					MEDIA.color.mark = CreateColorFromHexString(hex)
					MEDIA.color.mark.hex = hex
					mMT:UpdateMedia("lfg")
                    mMT:UpdateModule("LFGInviteInfo")
				end,
			},
            color_line_b = {
				type = "color",
				order = 2,
				name = L["Second line color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.lfg_invite_info.colors.line_b)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.lfg_invite_info.colors.line_b = hex
					MEDIA.color.mark = CreateColorFromHexString(hex)
					MEDIA.color.mark.hex = hex
					mMT:UpdateMedia("lfg")
                    mMT:UpdateModule("LFGInviteInfo")
				end,
			},
            color_line_c = {
				type = "color",
				order = 3,
				name = L["Third line color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.lfg_invite_info.colors.line_c)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.lfg_invite_info.colors.line_c = hex
					MEDIA.color.mark = CreateColorFromHexString(hex)
					MEDIA.color.mark.hex = hex
					mMT:UpdateMedia("lfg")
                    mMT:UpdateModule("LFGInviteInfo")
				end,
			},
            delay = {
				order = 4,
				name = L["Fade out delay"],
				type = "range",
				min = 2,
				max = 120,
				step = 1,
				disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
				get = function(info)
					return E.db.mMT.lfg_invite_info.delay
				end,
				set = function(info, value)
					E.db.mMT.lfg_invite_info.delay = value
					mMT:UpdateModule("LFGInviteInfo")
				end,
			},
            style = {
                type = "select",
                order = 5,
                name = L["Style"],
                disabled = function()
					return not E.db.mMT.lfg_invite_info.enable
				end,
                get = function(info)
                    return E.db.mMT.lfg_invite_info.icon
                end,
                set = function(info, value)
                    E.db.mMT.lfg_invite_info.icon = value
                    mMT:UpdateModule("LFGInviteInfo")
                end,
                values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.lfg) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end

                    icons["none"] = L["None"]
					return icons
				end,
            },
        },
    },
}
