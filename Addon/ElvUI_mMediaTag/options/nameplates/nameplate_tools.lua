local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

mMT.options.args.nameplates.args.misc.args = {
	glow = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Target & Glow color"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Sets automatically your class color for glow and border color on nameplates for the target unit."],
			},
			enable = {
				order = 2,
				type = "toggle",
				name = function()
					return E.db.mMediaTag.nameplates.target_glow_color and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.target_glow_color
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.target_glow_color = value
					mMT:UpdateModule("NP-TargetGlow")
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
