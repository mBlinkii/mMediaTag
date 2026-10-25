local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[418] = {
	DATE = "TBD",
	IMPORTANT = {
		"If you used the nameplate highlights or the summon icon without ever changing their settings, turn them on again.",
	},
	NEW = {
		"[Premade-Filter]: New module that adds a filter panel to the group finder search, with filters for free roles, matching groups, Bloodlust and the Blizzard group filters, region buttons and the dungeons of the season with your best runs and a bar for the number of groups.",
		"[Premade-Filter]: Groups can be sorted by leader score or age, your applications are listed on top and colored for applied, declined and full, and the leader score and a short difficulty can be shown in the list.",
		"[Merchant-Known]: New module that colors vendor items you already know, like learned recipes, and marks gear with an appearance you have not collected.",
		"[Merchant-Grid]: New module that shows 20 vendor items per page in four columns instead of ten in two.",
		"[Merchant-Buy-Max]: New module that adds a Max button to the quantity window of stackable vendor items and buys as many as you can afford.",
		"[NP-CombatFade]: New module that fades, shrinks or hides enemy nameplates of units that are not in combat while you are fighting, optionally only in instances.",
		"[Dispel-Icon]: New module that shows the dispel types of debuffs on friendly unitframes as icons, only the ones you can dispel or all of them, with its own count, size and position for every unitframe.",
		"[Dispel-Icon]: An optional frame highlight colors the border of the health bar or the whole unitframe and can add a glow or a running pixel glow in its own color.",
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
