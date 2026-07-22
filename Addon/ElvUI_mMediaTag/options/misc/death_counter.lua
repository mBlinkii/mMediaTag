local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

mMT.options.args.misc.args.death_counter.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.death_counter.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Shows deaths and lost time in the current Mythic+ run."],
		get = function(info)
			return E.db.mMediaTag.death_counter.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.death_counter.enable = value
			mMT:UpdateModule("DeathCounter")
		end,
	},
	demo = {
		order = 2,
		type = "execute",
		name = L["Show Frame"],
		func = function()
			mMT:UpdateModule("DeathCounter", "demo")
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
					return not E.db.mMediaTag.death_counter.enable
				end,
				get = function(info)
					return E.db.mMediaTag.death_counter.font.font
				end,
				set = function(info, value)
					E.db.mMediaTag.death_counter.font.font = value
					mMT:UpdateModule("DeathCounter")
				end,
			},
			fontFlag = {
				type = "select",
				order = 2,
				name = L["Font contour"],
				disabled = function()
					return not E.db.mMediaTag.death_counter.enable
				end,
				get = function(info)
					return E.db.mMediaTag.death_counter.font.fontFlag
				end,
				set = function(info, value)
					E.db.mMediaTag.death_counter.font.fontFlag = value
					mMT:UpdateModule("DeathCounter")
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
				order = 3,
				name = L["Font size"],
				type = "range",
				min = 8,
				max = 64,
				step = 1,
				disabled = function()
					return not E.db.mMediaTag.death_counter.enable
				end,
				get = function(info)
					return E.db.mMediaTag.death_counter.font.size
				end,
				set = function(info, value)
					E.db.mMediaTag.death_counter.font.size = value
					mMT:UpdateModule("DeathCounter")
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
			background = {
				order = 1,
				type = "toggle",
				name = L["Background"],
				get = function(info)
					return E.db.mMediaTag.death_counter.background
				end,
				set = function(info, value)
					E.db.mMediaTag.death_counter.background = value
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
		},
	},
}
