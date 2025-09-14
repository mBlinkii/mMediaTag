local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

mMT.options.args.misc.args.difficulty_info.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMT.difficulty_info.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMT.difficulty_info.enable
		end,
		set = function(info, value)
			E.db.mMT.difficulty_info.enable = value
			mMT:UpdateModule("DifficultyInfo")
		end,
	},
	demo = {
		order = 2,
		type = "execute",
		name = L["Show Frame"],
		func = function()
			mMT:UpdateModule("DifficultyInfo", "demo")
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
					return not E.db.mMT.difficulty_info.enable
				end,
				get = function(info)
					return E.db.mMT.difficulty_info.font.font
				end,
				set = function(info, value)
					E.db.mMT.difficulty_info.font.font = value
					mMT:UpdateModule("DifficultyInfo")
				end,
			},
			fontFlag = {
				type = "select",
				order = 2,
				name = L["Font contour"],
				disabled = function()
					return not E.db.mMT.difficulty_info.enable
				end,
				get = function(info)
					return E.db.mMT.difficulty_info.font.fontFlag
				end,
				set = function(info, value)
					E.db.mMT.difficulty_info.font.fontFlag = value
					mMT:UpdateModule("DifficultyInfo")
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
					return not E.db.mMT.difficulty_info.enable
				end,
				get = function(info)
					return E.db.mMT.difficulty_info.font.size
				end,
				set = function(info, value)
					E.db.mMT.difficulty_info.font.size = value
					mMT:UpdateModule("DifficultyInfo")
				end,
			},
            justify = {
                type = "select",
                order = 6,
                name = L["Alignment"],
                disabled = function()
					return not E.db.mMT.difficulty_info.enable
				end,
                get = function(info)
                    return E.db.mMT.difficulty_info.font.justify
                end,
                set = function(info, value)
                    E.db.mMT.difficulty_info.font.justify = value
                    mMT:UpdateModule("DifficultyInfo")
                end,
                values = {
                    LEFT = L["LEFT"],
                    CENTER = L["CENTER"],
                    RIGHT = L["RIGHT"],
                },
            },
		},
	},
	settings = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			background = {
				order = 1,
				type = "toggle",
				name = L["Background"],
				get = function(info)
					return E.db.mMT.difficulty_info.background
				end,
				set = function(info, value)
					E.db.mMT.difficulty_info.background = value
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
			colors = {
				order = 2,
				type = "execute",
				name = L["Colors"],
				desc = L["Change Colors"],
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "colors", "difficulty")
				end,
			},
		},
	},
}
