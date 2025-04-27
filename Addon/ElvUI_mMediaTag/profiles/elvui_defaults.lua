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

-- media
P.media = {
	color = {
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
	},
}
