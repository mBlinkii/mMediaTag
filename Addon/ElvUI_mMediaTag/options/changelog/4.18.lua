local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[418] = {
	DATE = "TBD",
	IMPORTANT = {
		"If you used the nameplate highlights or the summon icon without ever changing their settings, turn them on again.",
	},
	NEW = {
		"[Merchant-Known]: New module that colors vendor items you already know, like learned recipes, and marks gear with an appearance you have not collected.",
		"[Merchant-Grid]: New module that shows 20 vendor items per page in four columns instead of ten in two.",
		"[NP-CombatFade]: New module that fades, shrinks or hides enemy nameplates of units that are not in combat while you are fighting, optionally only in instances.",
		"[System]: mMT now runs in WoW Classic Era, TBC Anniversary, Mists of Pandaria Classic and WoW Forever, features a game version does not have are left out and hidden in the settings.",
	},
	UPDATE = {
		"[Keystone-Teleports]: The flash of the group dungeon now also adds a glowing border.",
		"[NP-Highlighters]: The target, focus and quest highlights are now turned off by default like every other module.",
	},
	FIX = {
		"[Keystone-Teleports]: The flash could stay on the wrong dungeon when the rows were rearranged.",
		"[Options]: Pages in the settings tree were greyed out although their module or a part of it was turned on.",
		"[Unitframe-Icons]: The summon icon was turned on by default and its icon selection was empty.",
	},
}
