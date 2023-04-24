local mMT, E, L, V, P, G = unpack((select(2, ...)))

P.mMT = {
	general = { greeting = true, keystochat = false },
	tooltip = { enable = false, iconsize = 32, iconzoom = true },
	combattime = { ooctexture = "CI2", ictexture = "CI12", hide = 30 },
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
	mpscore = {
		keys = { week = 0, affix = "" },
		highlight = true,
		sort = "AFFIX",
		upgrade = true,
		icon = "UI7",
		highlightcolor = {
			b = 0,
			g = 1,
			hex = "|cff1eff00",
			r = 0.11,
		},
	},
	teleports = { icon = false },
	profession = { icon = false, proficon = true },
	dungeon = { icon = false, texttoname = true, key = true, score = true, affix = true },
	instancedifficulty = {
		enable = false,
		mpe = { color = "|cffff8f00", r = 1, g = 0.56, b = 0, },
		mpf = { color = "|cffff0056", r = 1, g = 0, b = 0.33, },
		hc = { color = "|cff0595ff", b = 1, g = 0.58, r = 0.01, },
		guild = { color = "|cff94ff00", r = 0.58, g = 1, b = 0, },
		tw = { color = "|cff00bfff", r = 0, g = 0.75, b = 1, },
		mpc = { color = "|cff411aff", r = 0.25, g = 0.10, b = 1, },
		nhc = { color = "|cff52ff76", b = 0.46, g = 1, r = 0.32, },
		mpa = { color = "|cff97ffbd", r = 0.59, g = 1, b = 0.74, },
		mpd = { color = "|cffb600ff", r = 0.71, g = 0, b = 1, },
		m = { color = "|cffaf00ff", g = 0, r = 0.68, b = 1.00, },
		name = { color = "|cffffffff", r = 1, g = 1, b = 1, },
		mp = { color = "|cffff8f00", b = 0, g = 0.56, r = 1, },
		mpb = { color = "|cff00ff46", r = 0, g = 1, b = 0.27, },
		lfr = { color = "|cff00ffef", b = 0.93, g = 1, r = 0, },
		tg = { color = "|cff5dffb8", r = 0.36, g = 1, b = 0.72, },
		pvp = { color = "|cffeb0056", r = 0.92, g = 0, b = 0.33, },
	},
	roleicons = {
		enable = false,
		tank = "SHIELD2",
		heal = "HEAL13",
		dd = "BIGSW12",
		customtexture = false,
		customtank = nil,
		customheal = nil,
		customdd = nil,
	},
	nameplate = {
		healthmarker = {
			enable = false,
			indicator = { r = 1, g = 0, b = 0.61 },
			overlay = { r = 0.21, g = 0.33, b = 0.34, a = 0.85 },
			NPCs = {},
			overlaytexture = "mMediaTag P6",
			useDefaults = true,
			inInstance = false,
		},
		executemarker = {
			enable = false,
			indicator = { r = 1, g = 0.2, b = 0.2 },
			auto = true,
			range = 20,
		},
	}
}

G.mMT = {
	mplusaffix = { affixes = nil, season = nil, reset = false, year = nil },
	keys = {},
}
