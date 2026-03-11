local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- system settings
P.db_version = nil

-- general
P.general = {
	greeting_message = true,
}

-- general
P.keystone_to_chat = {
	enable = false,
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
		fontFlag = "OUTLINE",
	},
	colors = {
		line_a = "FFFFBF00",
		line_b = "FF9AA0A5",
		line_c = "FFA335EE",
	},
}

-- difficulty info
P.difficulty_info = {
	enable = false,
	background = false,
	font = {
		font = "PT Sans Narrow",
		size = 12,
		fontFlag = "OUTLINE",
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
		icon = "teleport03",
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
		icon = "prof_e",
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
		repair_threshold = 15,
		color_repair = "FFFA3E3E",
		color_warning = "FFFF7700",
		warning_threshold = 40,
		style = "a",
	},
	dungeon = {
		icon = "lfg04",
		dungeon_name = true,
	},
}

-- portraits
P.portraits = {
	enable = false,
	bg = {
		bgColorShift = 0.5,
		style = "default",
		classBG = false,
	},
	shadow = {
		enable = true,
		alpha = 0.6,
	},
	misc = {
		embellishment = true,
		force_reaction = false,
		force_default = false,
		scale = 0.6,
		class_icon = "none",
		desaturate = false,
		extratop = true,
		rare = "blizz_rare_neutral",
		elite = "blizz_rare_neutral",
		rareelite = "blizz_rare_neutral",
		boss = "blizz_boss_neutral",
		player = "blizz_boss_neutral",
	},
	custom = {
		enable = false,
		extra = false,
		boss = "",
		elite = "",
		extra_mask = "",
		mask = "",
		player = "",
		rare = "",
		rareelite = "",
		shadow = "",
		extra_shadow = "",
		texture = "",
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
		texture = "blizz_round",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
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
		texture = "blizz_round",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
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
		texture = "blizz_round",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
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
		texture = "blizz_round",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
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
		texture = "blizz_round",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
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
		texture = "blizz_round",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
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
		texture = "blizz_round",
		forceExtra = "none",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
	},
	arena = {
		cast = false,
		enable = true,
		extra = false,
		forceExtra = "none",
		level = 20,
		mirror = true,
		point = { point = "LEFT", relativePoint = "RIGHT", x = 0, y = 0 },
		size = 90,
		strata = "AUTO",
		texture = "blizz_round",
		unitcolor = false,
		extra_settings = {
			enable = false,
			size = 90,
			offset = { x = 0, y = 0 },
		},
	},
}

-- Interrupt on CD
P.interrupt_on_cd = {
	enable = false,
	set_bg_color = true,
	bg_multiplier = 0.5,
}

-- tooltip
P.tooltip = {
	enable = false,
	size = 32,
	zoom = true,
}

-- minimap skin
P.minimap_skin = {
	enable = false,
	style = "zigzag",
	cardinal = "none",
	color = "class",
	color_cardinal = "class",
}

-- dock
P.dock = {
	auto_grow = true,
	grow_size = 32,
	tooltip = true,

	class = {
		normal = false,
		hover = true,
		clicked = false,
		notification = false,
	},

	notification = {
		enable = false,
		class = false,
		auto = true,
		size = 16,
		style = "former",
		icon = "forma_04",
	},

	font = {
		font = "PT Sans Narrow",
		custom_font_size = false,
		fontSize = 12,
		fontFlag = "OUTLINE",
		custom_font_color = true,
	},

	store = {
		style = "former",
		icon = "forma_28",
		custom_color = false,
	},

	achievement = {
		style = "former",
		icon = "forma_69",
		custom_color = false,
	},

	bags = {
		style = "former",
		icon = "forma_05",
		custom_color = false,
		text = "none",
		gold = false,
	},

	character = {
		style = "former",
		icon = "forma_51",
		custom_color = false,
		percThreshold = 30,
		text = false,
	},

	collection = {
		style = "former",
		icon = "forma_18",
		custom_color = false,
	},

	durability = {
		style = "former",
		icon = "forma_08",
		custom_color = false,
		percThreshold = 30,
		text = "none",
		mount = 460,
	},

	encounter = {
		style = "former",
		icon = "forma_14",
		custom_color = false,
	},

	friends = {
		style = "former",
		icon = "forma_53",
		custom_color = false,
		text = true,
	},

	guild = {
		style = "former",
		icon = "forma_29",
		custom_color = false,
		text = true,
	},

	lfd = {
		style = "former",
		icon = "forma_02",
		custom_color = false,
		text = true,
		call_to_the_Arms = true,
	},

	mail = {
		style = "former",
		icon = "forma_04",
		custom_color = false,
	},

	menu = {
		style = "former",
		icon = "forma_44",
		custom_color = false,
	},

	professions = {
		style = "former",
		icon = "forma_68",
		custom_color = false,
	},

	quests = {
		style = "former",
		icon = "forma_57",
		custom_color = false,
	},

	spellbook = {
		style = "former",
		icon = "forma_13",
		custom_color = false,
	},

	spec = {
		style = "former",
		icon = "forma_41",
		custom_color = false,
	},

	volume = {
		style = "former",
		icon = "forma_72",
		custom_color = false,
		text = true,
		colored = true,
	},

	calendar = {
		icon = "filled",
		custom_color = false,
	},
}

-- tags
P.tags = {
	classification = {
		rare = "star",
		rareelite = "star",
		elite = "star",
		worldboss = "year_of_goat",
	},
	status = {
		afk = "clock",
		dnd = "unavailable",
		dc = "network_cable",
		dead = "skull2",
		ghost = "ghost",
	},
	misc = {
		tank = "shield9",
		healer = "heal13",
		dps = "bigsword2",
		pvp = "pvp",
		quest = "quest2",
		-- targeting = "brain",
	},
	-- raidtargetmarkers = {
	-- 	[1] = "TM01",
	-- 	[2] = "TM02",
	-- 	[3] = "TM03",
	-- 	[4] = "TM04",
	-- 	[5] = "TM05",
	-- 	[6] = "TM06",
	-- 	[7] = "TM07",
	-- 	[8] = "TM08",
	-- },
}

P.nameplates = {
	target_glow_color = false,
	focus = {
		changeColor = false,
		changeTexture = false,
		ignoreThreat = false,
		texture = "mMediaTag A9",
	},
	target = {
		changeColor = false,
		changeTexture = false,
		ignoreThreat = false,
		texture = "mMediaTag A4",
	},
	quest = {
		changeColor = false,
		changeTexture = false,
		ignoreThreat = false,
		texture = "mMediaTag A1",
	},
}

P.role_icons = {
	enable = false,
	tank = "shield9",
	heal = "heal13",
	dd = "bigsword2",
}

P.phase_icon = {
	enable = false,
	icon = "phase10",
}

P.resurrection_icon = {
	enable = false,
	icon = "resurrection_15",
}

P.ready_check_icon = {
	enable = false,
	ready = "readycheck_10",
	notready = "readycheck_13",
	waiting = "readycheck_35",
}

P.summon_icon = {
	enable = false,
	available = "summon_01",
	accepted = "summon_01",
	rejected = "summon_01",
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
			bg = "FF000000",
		},
		class = {
			DEATHKNIGHT = { c = "FFC41E3A", g = "FF9C182E" },
			DEMONHUNTER = { c = "FFA330C9", g = "FF6F2C91" },
			DRUID = { c = "FFFF7C0A", g = "FF9F5B00" },
			EVOKER = { c = "FF33937F", g = "FF1F6D5B" },
			HUNTER = { c = "FFAAD372", g = "FF7A9A2D" },
			MAGE = { c = "FF3FC7EB", g = "FF2A7F9D" },
			MONK = { c = "FF00FF98", g = "FF009B5B" },
			PALADIN = { c = "FFF48CBA", g = "FFC77399" },
			PRIEST = { c = "FFFFFFFF", g = "FFCDCCCC" },
			ROGUE = { c = "FFFFF468", g = "FFD2CA56" },
			SHAMAN = { c = "FF0070DD", g = "FF005EB8" },
			WARLOCK = { c = "FF8788EE", g = "FF5B5C8A" },
			WARRIOR = { c = "FFC69B6D", g = "FF9B7A57" },
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
			friendly = { c = "FF00FE48", g = "FF00C538" },
			neutral = { c = "FFFFD52E", g = "FFFFC02E" },
		},
	},

	interrupt_on_cd = {
		onCD = "FFA200FF",
		normal = "FF15FF47",
		marker = "FFFFFFFF",
	},

	-- castbar_shield = "FFFFFFFF",

	minimap_skin = { color = "FFFFFFFF", cardinal = "FFFFFFFF" },

	dock = {
		normal = "FFFFFFFF",
		hover = "FFB9B9B9",
		clicked = "FF838383",
		notification = "FF00FF88",
		font = "FFFFFFFF",
		store = "FFFFFFFF",
		achievement = "FFFFFFFF",
		bags = "FFFFFFFF",
		character = "FFFFFFFF",
		collection = "FFFFFFFF",
		durability = "FFFFFFFF",
		encounter = "FFFFFFFF",
		friends = "FFFFFFFF",
		guild = "FFFFFFFF",
		lfd = "FFFFFFFF",
		mail = "FFFFFFFF",
		menu = "FFFFFFFF",
		professions = "FFFFFFFF",
		quests = "FFFFFFFF",
		spellbook = "FFFFFFFF",
		spec = "FFFFFFFF",
		volume = "FFFFFFFF",
		calendar = "FFFFFFFF",
	},

	tags = {
		classification = {
			rare = "FFB300FF",
			rareelite = "FFA100FF",
			elite = "FFFF00E6",
			worldboss = "FFFF2E2E",
		},
		status = {
			afk = "ffffba00",
			dnd = "ffff0050",
			dc = "FF808080",
			dead = "ffff5561",
			ghost = "ff80bfff",
		},
		misc = {
			tank = "FF6CF5FF",
			healer = "FFB5FF54",
			dps = "FFFDBB6E",
			pvp = "FFFD786E",
			quest = "FFFFEE00",
			resting = "FF38FF92",
		},
		-- raidtargetmarkers = {
		-- 	[1] = "FFFFD900",
		-- 	[2] = "FFFF8800",
		-- 	[3] = "FF7700FF",
		-- 	[4] = "FF16BB00",
		-- 	[5] = "FFA5A5A5",
		-- 	[6] = "FF006EFF",
		-- 	[7] = "FFFF1111",
		-- 	[8] = "FFFFFFFF",
		-- },
	},

	nameplates = {
		focus_color = "FF00FFB3",
		target_color = "FFA200FF",
		quest_color = "FFFFA500",
	},

	phase_icon = {
		Phasing = "FF265FFD",
		Sharding = "FF74FA4C",
		WarMode = "FFF73E3E",
		ChromieTime = "FFFFC21A",
		TimerunningHwt = "FFF566D6",
	},

	summon_icon = {
		available = "FFFFFFFF",
		accepted = "FF74FA4C",
		rejected = "FFF73E3E",
	},
}
