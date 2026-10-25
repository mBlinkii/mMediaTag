local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[418] = {
	DATE = "25.10.2026",
	IMPORTANT = {
		"If you used the nameplate highlights or the summon icon without ever changing their settings, turn them on again.",
	},
	NEW = {
		"[Premade-Filter]: New module that adds a filter and sorting panel to the dungeon search of the group finder, with role, Bloodlust, region and dungeon filters, your applications on top and the leader score in the list.",
		"[Merchant]: New modules for the vendor window that color items you already know and mark uncollected appearances, show 20 items per page in four columns and add a Max button to the quantity window.",
		"[NP-CombatFade]: New module that fades, shrinks or hides enemy nameplates of units that are not in combat while you are fighting, optionally only in instances.",
		"[Dispel-Icon]: New module that shows the dispel types of debuffs on friendly unitframes as icons and can optionally highlight the unitframe.",
		"[System]: mMT now runs in WoW Classic Era, TBC Anniversary, Mists of Pandaria Classic and WoW Forever, features a game version does not have are left out and hidden in the settings.",
	},
	UPDATE = {
		"[Cooldown-Manager]: Every module can now be attached to another module or to a frame like the unitframes and their power, class power and cast bars, and can match its width or height to it.",
		"[Cooldown-Manager]: The icons of the custom tracker can be clicked to use the spell, item or equipment slot, and spells show their charges.",
		"[Cooldown-Manager]: The font and font outline are now set for each text instead of once for all.",
		"[Cooldown-Manager]: The settings are sorted into tabs and the modules are switched on and off in General.",
		"[Keystone-Teleports]: The flash of the group dungeon now also adds a glowing border.",
		"[NP-Highlighters]: The target, focus and quest highlights are now turned off by default like every other module.",
	},
	FIX = {
		"[Keystone-Teleports]: The flash could stay on the wrong dungeon when the rows were rearranged.",
		"[Options]: Pages in the settings tree were greyed out although their module or a part of it was turned on.",
		"[Unitframe-Icons]: The summon icon was turned on by default and its icon selection was empty.",
	},
}
