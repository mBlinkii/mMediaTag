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
		anchorCursor = false,
		icon = true,
		iconTexture = "teleport04",
	},
	individual_professions = {
		icon = true,
		iconStyle = "default",
	},
}

-- media
P.media = {
	color = {
		title = "FFFFBE19",
		text = "FFFFFFFF",
		tip = "FFB2B2B2",
		mark = "FF38FF92",
	},
}
