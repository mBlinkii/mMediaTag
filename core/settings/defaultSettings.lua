local mMT, E, L, V, P, G = unpack((select(2, ...)))

P["mMT"] = {
	general = { greeting = true },
	tooltip = { enable = false, iconsize = 32, iconzoom = true },
	combattime = { ooctexture = "CI2", ictexture = "CI12" },
	interruptoncd = {
		enable = false,
		gradient = false,
		outofrange = false,
        inactivetime = 0.8,
        readymarkercolor = {r = 0.22, g = 0.86, b = 0.22},
		oncdcolor = { colora = {r = 0.81, g = 0.02, b = 1}, colorb = {r = 0.52, g = 0.04, b = 0.72} },
		intimecolor = { colora = {r = 0, g = 0.78, b = 1}, colorb = {r = 0, g = 0.46, b = 0.65} },
		outofrangecolor = { colora = {r = 1, g = 0.48, b = 0}, colorb = {r = 0.74, g = 0.28, b = 0} },
	},
}