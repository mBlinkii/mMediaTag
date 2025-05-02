local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- system settings
P.db_version = nil

-- general
P.general = {
	greeting_message = true,
}

-- general
P.keystone_to_chat = {
	enable = true,
}

-- data panel skin
P.data_panel_skin = {
	enable = false,
	panels = {},
}

-- dice button
P.dice_button = {
	enable = false,
	color = {
		normal = {
			mode = "custom",
			color = { r = 1, g = 1, b = 1, a = 0.75 },
		},
		hover = {
			mode = "class",
			color = { r = 1, g = 1, b = 1, a = 0.75 },
		},
	},
	texture = "dice05",
	size = 16,
	dice_range_a = 100,
	dice_range_b = 99,
}

-- lfg invite info
P.lfg_invite_info = {
	enable = false,
	delay = 60,
	icon = "none",
	style = "default",
	background = false,
	print = true,
	font = {
		font = "PT Sans Narrow",
		size = 32,
		size2 = 22,
		fontflag = "OUTLINE",
	},
	colors = {
		line_a = "FFFFBF00",
		line_b = "FF9AA0A5",
		line_c = "FFA335EE",
	},
}

-- difficulty info
P.difficulty_info = {
	enable = true,
	background = false,
	font = {
		font = "PT Sans Narrow",
		size = 12,
		fontflag = "OUTLINE",
		justify = "CENTER",
	},
}

-- datatexts
P.datatexts = {
	text = {
		override_text = true,
		text = "FFFFFFFF",
		override_value = false,
		value = "FFFFFFFF",
	},
	score = {
		group_keystones = true,
		show_upgrade = true,
		sort_method = "KEY",
	},
	teleports = {
		icon = "teleport04",
		favorites = {
			enable = false,
			a = { id = "none", kind = "none" },
			b = { id = "none", kind = "none" },
			c = { id = "none", kind = "none" },
			d = { id = "none", kind = "none" },
		},
	},
	individual_professions = {
		icon = "default",
	},
	professions = {
		icon = "prof_a",
		menu_icons = "default",
	},
	menu = {
		icon = "mmt",
		menu_icons = true,
		show_systeminfo = true,
		text_color = "FFFFFFFF",
	},
	tracker = {
		custom = {},
		hide_if_zero = false,
		icon = true,
		name = false,
		short_number = true,
		show_max = false,
		colored = true,
	},
	combat_time = {
		in_combat = "combat_02",
		out_of_combat = "combat_13",
		hide_delay = 5,
	},
	durability_itemLevel = {
		mount = 460,
		warning = true,
		force_withe_text = true,
		repair_threshold = 60,
		color_repair = "FFFA3E3E",
		color_warning = "FFFF7700",
		warning_threshold = 80,
		style = "a",
	},
	dungeon = {
		icon = "lfg04",
		dungeon_name = true,
	},
}

-- portraits
P.portraits = {
	misc = {
		force_reaction = false,
		force_default = false,
		rare = "blizz_neutral",
		elite = "blizz_neutral",
		rareelite = "blizz_neutral",
		boss = "blizz_boss_neutral",
		player = "blizz_neutral",
		extratop = true,
		zoom = 0,
		class_icon = "none",
		desaturate = false,
	},
	custom = {
		enable = false,
		extra = false,
		rare = "",
		elite = "",
		rareelite = "",
		boss = "",
		player = "",
		texture = "",
		mask = "",
		extra_mask = "",
	},

	player = {
		cast = false,
		enable = true,
		extra = false,
		level = 20,
		mirror = false,
		point = { point = "RIGHT", relativePoint = "LEFT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
	target = {
		cast = false,
		enable = true,
		extra = true,
		forceExtra = "none",
		level = 20,
		mirror = true,
		point = { point = "LEFT", relativePoint = "RIGHT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
	focus = {
		cast = false,
		enable = true,
		extra = false,
		forceExtra = "none",
		level = 20,
		mirror = true,
		point = { point = "LEFT", relativePoint = "RIGHT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
	targettarget = {
		cast = false,
		enable = true,
		extra = false,
		forceExtra = "none",
		level = 20,
		mirror = true,
		point = { point = "LEFT", relativePoint = "RIGHT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
	pet = {
		cast = false,
		enable = true,
		extra = false,
		forceExtra = "none",
		level = 20,
		mirror = false,
		point = { point = "RIGHT", relativePoint = "LEFT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
	party = {
		cast = false,
		enable = true,
		extra = false,
		forceExtra = "none",
		level = 20,
		mirror = false,
		point = { point = "RIGHT", relativePoint = "LEFT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
	boss = {
		cast = false,
		enable = true,
		extra = true,
		level = 20,
		mirror = true,
		point = { point = "LEFT", relativePoint = "RIGHT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
	arena = {
		cast = false,
		enable = true,
		extra = false,
		level = 20,
		mirror = true,
		point = { point = "LEFT", relativePoint = "RIGHT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz",
		unitcolor = false,
	},
}

-- color
P.color = {
	-- tip/ menu
	title = "FFFFBE19",
	text = "FFFFFFFF",
	tip = "FFB2B2B2",
	mark = "FF38FF92",

	-- difficulty
	N = "FF1EFF00",
	H = "FF0070DD",
	M = "FFA335EE",
	PVP = "FFE6CC80",
	MP = "FFFF8000",
	LFR = "FFBE7FE8",
	TW = "FF00CCFF",
	QUEST = "FFFFBB00",
	SC = "FF00FF8C",
	STORY = "FFE6CC80",
	DELVE = "FF91D900",
	FOLLOWER = "FF00FF8C",
	OTHER = "FF00FFEE",
	GUILD = "FF91D900",

	-- portraits
	portraits = {
		misc = {
			death = { c = "FFF86767", g = "FFEC3535" },
			default = { c = "FFE6CC80", g = "FFDAB033" },
			border = "FF000000",
			extra = "FFFFFFFF",
			shadow = "CD1E1E1E",
			inner = "87282828",
		},
		class = {
			DEATHKNIGHT = { c = "FFC41E3A", g = "FF9C182E" },
			DEMONHUNTER = { c = "FFA330C9", g = "FF6F2C91" },
			DRUID = { c = "FFFF7C0A", g = "FF9F5B00" },
			EVOKER = { c = "FF33937F", 	g = "FF1F6D5B" },
			HUNTER = { c = "FFAAD372", g = "FF7A9A2D" },
			MAGE = { c = "FF3FC7EB", g = "FF2A7F9D" },
			MONK = { c = "FF00FF98", g = "FF009B5B" },
			PALADIN = { c = "FFF48CBA", g = "FFC77399" },
			PRIEST = { c = "FFFFFFFF", g = "FFCDCCCC" },
			ROGUE = { c = "FFFFF468", g = "FFD2CA56" },
			SHAMAN = { c = "FF0070DD", g = "FF005EB8" },
			WARLOCK = { c = "FF8788EE", g = "FF5B5C8A" },
			WARRIOR = { c ="FFC69B6D", g = "FF9B7A57" },
		},
		classification = {
			boss = { c = "FFFF2E2E", g = "FFDA0B0B" },
			elite = { c = "FFFF00E6", g = "FFD001BC" },
			player = { c = "FF00FFEE", g = "FF00C3B6" },
			rare = { c = "FFB300FF", g = "FF9100D0" },
			rareelite = { c = "FFA100FF", g = "FF8500D2" },
		},
		reaction = {
			enemy = { c = "FFFF4848", g = "FFD63A3A" },
			friendly = { c = "FF00FE48", g = "FF00C538"},
			neutral = { c = "FFFFD52E", g = "FFFFC02E" },
		},
	},
}
