local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local function Disabled()
	return not E.db.mMediaTag.keystone_teleports.enable
end

local function Update()
	mMT:UpdateModule("KeystoneTeleports")
end

mMT.options.args.group.args.keystones.args.keystone_teleports.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.keystone_teleports.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.keystone_teleports.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.keystone_teleports.enable = value
			Update()
		end,
	},
	demo = {
		order = 2,
		type = "execute",
		name = L["Show Frame"],
		disabled = Disabled,
		func = function()
			mMT:UpdateModule("KeystoneTeleports", "demo")
		end,
	},
	text = {
		order = 3,
		type = "description",
		fontSize = "medium",
		name = L["Click a dungeon to use its teleport. The dungeon of your group finder group is highlighted. The list shows up when you join a group or the group is full, outside of instances, and hides in combat."],
	},
	info = {
		order = 4,
		type = "description",
		fontSize = "medium",
		name = "\n" .. L["The keystones of your group members need Details! or BigWigs."] .. "\n\n",
	},
	settings = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = Disabled,
		args = {
			duration = {
				order = 1,
				type = "range",
				name = L["Hide after (minutes)"],
				desc = L["Hides the list this many minutes after it was shown. 0 keeps it shown."],
				min = 0,
				max = 30,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.duration
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.duration = value
					Update()
				end,
			},
			animation = {
				order = 2,
				type = "toggle",
				name = L["Animation"],
				desc = L["Fades the list in and out. Entering combat always hides it at once."],
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.animation
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.animation = value
					Update()
				end,
			},
		},
	},
	layout = {
		order = 6,
		type = "group",
		inline = true,
		name = L["Layout"],
		disabled = Disabled,
		args = {
			background = {
				order = 1,
				type = "toggle",
				name = L["Background"],
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.background
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.background = value
					Update()
				end,
			},
			title = {
				order = 2,
				type = "toggle",
				name = L["Title"],
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.title
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.title = value
					Update()
				end,
			},
			width = {
				order = 3,
				type = "range",
				name = L["Width"],
				min = 120,
				max = 600,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.width
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.width = value
					Update()
				end,
			},
			spacing = {
				order = 4,
				type = "range",
				name = L["Spacing"],
				min = 0,
				max = 20,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.spacing
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.spacing = value
					Update()
				end,
			},
		},
	},
	icon = {
		order = 7,
		type = "group",
		inline = true,
		name = L["Icon"],
		disabled = Disabled,
		args = {
			size = {
				order = 1,
				type = "range",
				name = L["Icon Size"],
				min = 12,
				max = 64,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.size
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.size = value
					Update()
				end,
			},
		},
	},
	text_group = {
		order = 8,
		type = "group",
		inline = true,
		name = L["Text"],
		disabled = Disabled,
		args = {
			font = {
				order = 1,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				values = LSM:HashTable("font"),
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.text.font
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.text.font = value
					Update()
				end,
			},
			fontFlag = {
				order = 2,
				type = "select",
				name = L["Font contour"],
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.text.fontFlag
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.text.fontFlag = value
					Update()
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
			size = {
				order = 3,
				type = "range",
				name = L["Font size"],
				min = 8,
				max = 32,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.text.size
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.text.size = value
					Update()
				end,
			},
		},
	},
	highlight = {
		order = 9,
		type = "group",
		inline = true,
		name = L["Highlight"],
		disabled = Disabled,
		args = {
			class = {
				order = 1,
				type = "toggle",
				name = L["Class Color"],
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.highlight.class
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.highlight.class = value
					Update()
				end,
			},
			color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return Disabled() or E.db.mMediaTag.keystone_teleports.highlight.class
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.keystone_teleports.highlight.color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					E.db.mMediaTag.keystone_teleports.highlight.color = E:RGBToHex(r, g, b, "ff")
					Update()
				end,
			},
			flash = {
				order = 3,
				type = "toggle",
				name = L["Flash"],
				desc = L["Flashes the dungeon of your group for a few seconds once the group is full."],
				get = function(info)
					return E.db.mMediaTag.keystone_teleports.highlight.flash
				end,
				set = function(info, value)
					E.db.mMediaTag.keystone_teleports.highlight.flash = value
					Update()
				end,
			},
		},
	},
}
