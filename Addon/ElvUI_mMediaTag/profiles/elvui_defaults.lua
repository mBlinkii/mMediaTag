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
