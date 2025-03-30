local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.professions.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			style = {
				order = 1,
				type = "select",
				name = L["Icon Style"],
				get = function(info)
					return E.db.mMT.datatexts.professions.icon
				end,
				set = function(info, value)
					E.db.mMT.datatexts.professions.icon = value
					DT:ForceUpdate_DataText("mMT - Professions")
				end,
				values = function()
					local dt_icons = {
						prof_a = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_a.tga",
						prof_b = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_b.tga",
						prof_c = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_c.tga",
						prof_d = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_d.tga",
						prof_e = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\primary_a.tga",
						prof_f = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\primary_b.tga",
						prof_g = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\secondary_a.tga",
						prof_h = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\secondary_b.tga",
					}

					local values = {}
					for key, icon in pairs(dt_icons) do
						values[key] = E:TextureString(icon, ":14:14")
					end

					values.none = L["None"]
					return values
				end,
			},
            menu_icons = {
                order = 2,
                type = "toggle",
                name = L["Menu Icons"],
                get = function(info)
                    return E.db.mMT.datatexts.professions.menu_icons
                end,
                set = function(info, value)
                    E.db.mMT.datatexts.professions.menu_icons = value
                end,
            },
		},
	},
}
