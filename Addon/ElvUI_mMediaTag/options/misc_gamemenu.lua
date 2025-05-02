local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.misc_gamemenu.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			iconTexture = {
				order = 1,
				type = "select",
				name = L["Icon"],
				get = function(info)
					return E.db.mMT.datatexts.menu.icon
				end,
				set = function(info, value)
					E.db.mMT.datatexts.menu.icon = value
					DT:ForceUpdate_DataText("mMT - Game menu")
				end,
				values = {
                    none = L["None"],
                    mmt = "mMT",
                    colored = L["colored"],
                    white = L["white"]

                },
			},
            menu_icons = {
				order = 2,
				type = "toggle",
				name = L["Show Menu Icons"],
				get = function(info)
					return E.db.mMT.datatexts.menu.menu_icons
				end,
				set = function(info, value)
					E.db.mMT.datatexts.menu.menu_icons = value
				end,
			},
            systeminfo = {
				order = 3,
				type = "toggle",
				name = L["Show Systeminfo"],
				get = function(info)
					return E.db.mMT.datatexts.menu.show_systeminfo
				end,
				set = function(info, value)
					E.db.mMT.datatexts.menu.show_systeminfo = value
				end,
			},
			text_color = {
				order = 4,
				type = "color",
				name = L["Menu Text color"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.menu.text_color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.datatexts.menu.text_color = hex
					COLORS.gm_text_color = CreateColorFromHexString(hex)
					COLORS.gm_text_color.hex = hex
				end,
			},
		},
	},
}
