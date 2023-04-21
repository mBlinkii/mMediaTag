local mMT, E, L, V, P, G = unpack((select(2, ...)))

P.mMT = {
	general = { greeting = true },
	tooltip = { enable = false, iconsize = 32, iconzoom = true },
	combattime = { ooctexture = "CI2", ictexture = "CI12" },
	interruptoncd = {
		enable = false,
		gradient = false,
		outofrange = false,
		inactivetime = 0.8,
		readymarkercolor = { r = 0.22, g = 0.86, b = 0.22 },
		oncdcolor = { colora = { r = 0.81, g = 0.02, b = 1 }, colorb = { r = 0.52, g = 0.04, b = 0.72 } },
		intimecolor = { colora = { r = 0, g = 0.78, b = 1 }, colorb = { r = 0, g = 0.46, b = 0.65 } },
		outofrangecolor = { colora = { r = 1, g = 0.48, b = 0 }, colorb = { r = 0.74, g = 0.28, b = 0 } },
	},
	custombackgrounds = {
		enable = false,
		health = { enable = false, texture = "mMediaTag A8" },
		power = { enable = false, texture = "mMediaTag A8" },
		castbar = { enable = false, texture = "mMediaTag A8" },
	},
	customclasscolors = {
		enable = false,
		emediaenable = false,
		colors = {
			HUNTER = { r = 0.67, g = 0.83, b = 0.45 },
			WARLOCK = { r = 0.53, g = 0.53, b = 0.93 },
			PRIEST = { r = 1.00, g = 1.00, b = 1.00 },
			PALADIN = { r = 0.96, g = 0.55, b = 0.73 },
			MAGE = { r = 0.20, g = 0.78, b = 0.92 },
			ROGUE = { r = 1.00, g = 0.96, b = 0.41 },
			DRUID = { r = 1.00, g = 0.49, b = 0.04 },
			SHAMAN = { r = 0.00, g = 0.44, b = 0.87 },
			WARRIOR = { r = 0.78, g = 0.61, b = 0.43 },
			DEATHKNIGHT = { r = 0.77, g = 0.12, b = 0.23 },
			MONK = { r = 0.00, g = 1.00, b = 0.60 },
			DEMONHUNTER = { r = 0.64, g = 0.19, b = 0.79 },
			EVOKER = { r = 0.20, g = 0.58, b = 0.50 },
		},
	},
	datatextcolors = {
		colorhc = {
			b = 0.86,
			g = 0.43,
			hex = "|cff0070dd",
			r = 0,
		},
		colormyth = {
			b = 0.93,
			g = 0.20,
			hex = "|cffa334ee",
			r = 0.63,
		},
		colormythplus = {
			b = 0.24,
			hex = "|cffff033e",
			g = 0.011,
			r = 1,
		},
		colornhc = {
			b = 0,
			g = 1,
			hex = "|cff1eff00",
			r = 0.11,
		},
		colorother = {
			b = 1,
			g = 1,
			hex = "|cffffffff",
			r = 1,
		},
		colortitel = {
			b = 0,
			g = 0.78,
			hex = "|cffffc800",
			r = 1,
		},
		colortip = {
			b = 0.58,
			g = 0.58,
			hex = "|cff969696",
			r = 0.58,
		},
	},
	roll = {
		enable = false,
		colormodenormal = "custom",
		colormodehover = "class",
		colornormal = { r = 1, g = 1, b = 1, a = 0.75 },
		colorhover = { r = 1, g = 1, b = 1, a = 0.75 },
		texture = "RI1",
		size = 16,
	},
	chat = {
		enable = false,
		colormodenormal = "custom",
		colormodehover = "class",
		colornormal = { r = 1, g = 1, b = 1, a = 0.75 },
		colorhover = { r = 1, g = 1, b = 1, a = 0.75 },
		texture = "CI1",
		size = 16,
	},
	mpscore = { keys = {week = 0, affix = "", }, highlight = true, sort = "AFFIX", upgrade = true, icon = "UI7", highlightcolor = {
		b = 0,
		g = 1,
		hex = "|cff1eff00",
		r = 0.11,
	}, }
}

G.mMT = {
	mplusaffix = { affixes = nil, season = nil, reset = false, year = nil },
	keys = {},
}