local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local function Disabled()
	return not E.db.mMediaTag.buff_reminder.enable
end

local function Update()
	mMT:UpdateModule("BuffReminder")
end

-- getter and setter for a settings table below buff_reminder, nil is the module table itself
local function Accessors(path)
	local function db()
		return path and E.db.mMediaTag.buff_reminder[path] or E.db.mMediaTag.buff_reminder
	end
	return function(info)
		return db()[info[#info]]
	end, function(info, value)
		db()[info[#info]] = value
		Update()
	end
end

local get, set = Accessors()
local raidGet, raidSet = Accessors("raid_buffs")
local instanceGet, instanceSet = Accessors("instances")
local textGet, textSet = Accessors("text")
local glowGet, glowSet = Accessors("glow")
local entryGet, entrySet = Accessors("entry")

local ZONES = {
	world = L["Open World"],
	party = L["Dungeons"],
	raid = L["Raids"],
	scenario = L["Delves and Scenarios"],
}

-- a dropdown with the zones a check runs in, greyed out while the check is off
local function ZoneSelect(order, name, key, enabled)
	return {
		order = order,
		type = "multiselect",
		dialogControl = "Dropdown",
		name = name,
		values = ZONES,
		disabled = function()
			return Disabled() or not enabled()
		end,
		get = function(_, zone)
			return E.db.mMediaTag.buff_reminder.zones[key][zone]
		end,
		set = function(_, zone, value)
			E.db.mMediaTag.buff_reminder.zones[key][zone] = value
			Update()
		end,
	}
end

local function CheckEnabled(key)
	return function()
		return E.db.mMediaTag.buff_reminder[key]
	end
end

mMT.options.args.group.args.group_tools.args.buff_reminder.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.buff_reminder.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = get,
		set = set,
	},
	demo = {
		order = 2,
		type = "execute",
		name = L["Show Frame"],
		disabled = Disabled,
		func = function()
			mMT:UpdateModule("BuffReminder", "demo")
		end,
	},
	text = {
		order = 3,
		type = "description",
		fontSize = "medium",
		name = L["Shows icons for missing raid buffs, consumables, weapon enchants and class buffs. It only shows out of combat, while auras can be read. Click an icon to use the consumable or cast your own buff. Right click food, flasks and weapon enchants to choose the item, your choice is remembered. Only food, flasks and oils of the current expansion are used."]
			.. "\n\n",
	},
	visibility = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Visibility"],
		disabled = Disabled,
		args = {
			party = {
				order = 1,
				type = "toggle",
				name = L["Dungeons"],
				get = instanceGet,
				set = instanceSet,
			},
			raid = {
				order = 2,
				type = "toggle",
				name = L["Raids"],
				get = instanceGet,
				set = instanceSet,
			},
			scenario = {
				order = 3,
				type = "toggle",
				name = L["Delves and Scenarios"],
				get = instanceGet,
				set = instanceSet,
			},
			world = {
				order = 4,
				type = "toggle",
				name = L["Open World"],
				get = get,
				set = set,
			},
			threshold = {
				order = 5,
				type = "range",
				name = L["Remind before expiring (minutes)"],
				desc = L["Buffs and enchants with less time left count as missing. 0 only reminds when they are gone."],
				min = 0,
				max = 30,
				step = 1,
				get = get,
				set = set,
			},
			animation = {
				order = 6,
				type = "toggle",
				name = L["Animation"],
				desc = L["Fades the reminder in and out. Entering combat always hides it at once."],
				get = get,
				set = set,
			},
			hide_after = {
				order = 7,
				type = "range",
				name = L["Hide after (seconds)"],
				desc = L["Hides the reminder this many seconds after it was shown. It shows again when you enter a dungeon or raid. 0 keeps it shown."],
				min = 0,
				max = 300,
				step = 1,
				bigStep = 5,
				get = get,
				set = set,
			},
		},
	},
	entry = {
		order = 4.2,
		type = "group",
		inline = true,
		name = L["Minimum Duration"],
		disabled = Disabled,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["When you enter a dungeon or raid, everything with less time left shows up and glows until the first pull, so flasks and co last the whole run."],
				get = entryGet,
				set = entrySet,
			},
			duration = {
				order = 2,
				type = "range",
				name = L["Minimum duration (minutes)"],
				min = 5,
				max = 60,
				step = 1,
				disabled = function()
					return Disabled() or not E.db.mMediaTag.buff_reminder.entry.enable
				end,
				get = entryGet,
				set = entrySet,
			},
		},
	},
	glow = {
		order = 4.5,
		type = "group",
		inline = true,
		name = L["Glow"],
		disabled = Disabled,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Lets the icons of buffs and enchants glow that are about to expire."],
				get = glowGet,
				set = glowSet,
			},
			color = {
				order = 2,
				type = "color",
				name = L["Glow Color"],
				hasAlpha = false,
				disabled = function()
					return Disabled() or not E.db.mMediaTag.buff_reminder.glow.enable
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.buff_reminder.glow.color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					E.db.mMediaTag.buff_reminder.glow.color = E:RGBToHex(r, g, b, "ff")
					Update()
				end,
			},
			thickness = {
				order = 3,
				type = "range",
				name = L["Thickness"],
				min = 1,
				max = 6,
				step = 1,
				disabled = function()
					return Disabled() or not E.db.mMediaTag.buff_reminder.glow.enable
				end,
				get = glowGet,
				set = glowSet,
			},
			lines = {
				order = 4,
				type = "range",
				name = L["Lines"],
				min = 1,
				max = 20,
				step = 1,
				disabled = function()
					return Disabled() or not E.db.mMediaTag.buff_reminder.glow.enable
				end,
				get = glowGet,
				set = glowSet,
			},
		},
	},
	checks = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Checks"],
		disabled = Disabled,
		args = {
			raid_buffs = {
				order = 1,
				type = "toggle",
				name = L["Raid Buffs"],
				desc = L["Reminds you of raid buffs that you or a class in your group can cast."],
				get = function(info)
					return E.db.mMediaTag.buff_reminder.raid_buffs.enable
				end,
				set = function(info, value)
					E.db.mMediaTag.buff_reminder.raid_buffs.enable = value
					Update()
				end,
			},
			own = {
				order = 2,
				type = "toggle",
				name = L["Only own raid buff"],
				desc = L["Only reminds you of the raid buff your class can cast."],
				disabled = function()
					return Disabled() or not E.db.mMediaTag.buff_reminder.raid_buffs.enable
				end,
				get = raidGet,
				set = raidSet,
			},
			group = {
				order = 3,
				type = "toggle",
				name = L["Check group members"],
				desc = L["Also reminds you when group members in range are missing your raid buff."],
				disabled = function()
					return Disabled() or not E.db.mMediaTag.buff_reminder.raid_buffs.enable
				end,
				get = raidGet,
				set = raidSet,
			},
			flask = {
				order = 4,
				type = "toggle",
				name = L["Flask"],
				desc = L["Only when you carry a flask."],
				get = get,
				set = set,
			},
			food = {
				order = 5,
				type = "toggle",
				name = L["Food"],
				get = get,
				set = set,
			},
			rune = {
				order = 6,
				type = "toggle",
				name = L["Augment Rune"],
				desc = L["Only when you carry an augment rune."],
				get = get,
				set = set,
			},
			weapon = {
				order = 7,
				type = "toggle",
				name = L["Weapon Enchant"],
				desc = L["Weapon oils, sharpening stones and class imbues on your weapons."],
				get = get,
				set = set,
			},
			class_buffs = {
				order = 8,
				type = "toggle",
				name = L["Class Buffs"],
				desc = L["Rogue poisons, paladin auras, shaman shields and your pet."],
				get = get,
				set = set,
			},
		},
	},
	zones = {
		order = 5.5,
		type = "group",
		inline = true,
		name = L["Zones"],
		disabled = Disabled,
		args = {
			desc = {
				order = 0,
				type = "description",
				name = L["Choose where each check reminds you. The visibility above still decides where the reminder shows at all."],
			},
			raid_buffs = ZoneSelect(1, L["Raid Buffs"], "raid_buffs", function()
				return E.db.mMediaTag.buff_reminder.raid_buffs.enable
			end),
			flask = ZoneSelect(2, L["Flask"], "flask", CheckEnabled("flask")),
			food = ZoneSelect(3, L["Food"], "food", CheckEnabled("food")),
			rune = ZoneSelect(4, L["Augment Rune"], "rune", CheckEnabled("rune")),
			weapon = ZoneSelect(5, L["Weapon Enchant"], "weapon", CheckEnabled("weapon")),
			class_buffs = ZoneSelect(6, L["Class Buffs"], "class_buffs", CheckEnabled("class_buffs")),
		},
	},
	layout = {
		order = 6,
		type = "group",
		inline = true,
		name = L["Layout"],
		disabled = Disabled,
		args = {
			direction = {
				order = 1,
				type = "select",
				name = L["Direction"],
				values = {
					HORIZONTAL = L["Horizontal"],
					VERTICAL = L["Vertical"],
				},
				get = get,
				set = set,
			},
			size = {
				order = 2,
				type = "range",
				name = L["Icon Size"],
				min = 12,
				max = 64,
				step = 1,
				get = get,
				set = set,
			},
			spacing = {
				order = 3,
				type = "range",
				name = L["Spacing"],
				min = 0,
				max = 20,
				step = 1,
				get = get,
				set = set,
			},
		},
	},
	text_group = {
		order = 7,
		type = "group",
		inline = true,
		name = L["Text"],
		disabled = Disabled,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Shows the minutes left or the number of group members missing the buff."],
				get = textGet,
				set = textSet,
			},
			font = {
				order = 2,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				values = LSM:HashTable("font"),
				get = textGet,
				set = textSet,
			},
			fontFlag = {
				order = 3,
				type = "select",
				name = L["Font contour"],
				get = textGet,
				set = textSet,
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
				order = 4,
				type = "range",
				name = L["Font size"],
				min = 8,
				max = 32,
				step = 1,
				get = textGet,
				set = textSet,
			},
			color = {
				order = 5,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.buff_reminder.text.color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					E.db.mMediaTag.buff_reminder.text.color = E:RGBToHex(r, g, b, "ff")
					Update()
				end,
			},
		},
	},
}
