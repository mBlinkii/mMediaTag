local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local NP = E:GetModule("NamePlates")

mMT.options.args.nameplates.args.nameplate_tools.args = {
	misc = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Target & Glow color"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Sets automatically your class color as the target and glow color on nameplates."],
			},
			enable = {
				order = 2,
				type = "toggle",
				name = function()
					return E.db.mMediaTag.nameplates.target_color and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.target_color
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.target_color = value
					mMT:UpdateModule("NameplateTools")
                    NP:ConfigureAll()
				end,
			},
            elvui_settings = {
				order = 3,
				type = "execute",
				name = L["ElvUI Color Settings"],
                desc = L["Open the ElvUI color settings to adjust the colors used for nameplates."],
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "nameplates", "colorsGroup")
				end,
			},
		},
	},
}
