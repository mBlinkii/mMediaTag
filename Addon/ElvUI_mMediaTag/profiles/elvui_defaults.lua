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
	title = "FFFFBE19",
	text = "FFFFFFFF",
	tip = "FFB2B2B2",
	mark = "FF38FF92",
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

	portraits = {
		misc = {
			death = { r = 0.5, g = 0.20, b = 0.20, a = 1 },
			default = { r = 1, g = 0.73, b = 0.18, a = 1 },
		},
		class = {
			DEATHKNIGHT = { r = 0.77, g = 0.12, b = 0.23, a = 1 },
			DEMONHUNTER = { r = 0.64, g = 0.19, b = 0.79, a = 1 },
			DRUID = { r = 1.00, g = 0.49, b = 0.04, a = 1 },
			EVOKER = { r = 0.20, g = 0.58, b = 0.50, a = 1 },
			HUNTER = { r = 0.67, g = 0.83, b = 0.45, a = 1 },
			MAGE = { r = 0.25, g = 0.78, b = 0.92, a = 1 },
			MONK = { r = 0.00, g = 1.00, b = 0.60, a = 1 },
			PALADIN = { r = 0.96, g = 0.55, b = 0.73, a = 1 },
			PRIEST = { r = 1, g = 1, b = 1, a = 1 },
			ROGUE = { r = 1.00, g = 0.96, b = 0.41, a = 1 },
			SHAMAN = { r = 0.00, g = 0.44, b = 0.87, a = 1 },
			WARLOCK = { r = 0.53, g = 0.53, b = 0.93, a = 1 },
			WARRIOR = { r = 0.78, g = 0.61, b = 0.43, a = 1 },
		},
		classification = {
			boss = { r = 0.78, g = 0.12, b = 0.12, a = 1 },
			elite = { r = 1, g = 0, b = 0.90, a = 1 },
			player = { r = 0.2, g = 1, b = 0.2, a = 1 },
			rare = { r = 0.70, g = 0, b = 1, a = 1 },
			rareelite = { r = 0.63, g = 0, b = 1, a = 1 },
		},
		reaction = {
			enemy = { r = 0.78, g = 0.12, b = 0.12, a = 1 },
			friendly = { r = 0.17, g = 0.75, b = 0, a = 1 },
			neutral = { r = 1.00, g = 0.70, b = 0, a = 1 },
		},
	},
}
