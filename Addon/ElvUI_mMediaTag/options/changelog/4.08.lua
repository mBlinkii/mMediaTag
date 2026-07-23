local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[408] = {
	DATE = "23.07.2026",
	FIX = {
		"[Difficulty Info]: Fixed anchor position and background rendering.",
		"[Difficulty Info]: Difficulty colors now update immediately when changed in the options.",
		"[Portraits]: Fixed an error that could occur when a class/spec icon has no texture (falls back to the default portrait).",
		"[Portraits]: The previous units portrait is no longer shown briefly after a model, vehicle or portrait change.",
	},
	UPDATE = {
		"[System]: Updated Dungeon and Raid short names for Midnight.",
		"[System]: Added flexible Mythic raid size to the difficulty colors/tags.",
		"[Portraits]: Optimized performance (event handling and color updates).",
		"[Portraits]: Late arriving spec info now also updates the portrait of newly joined party members.",
		"[Tags]: Removed the outdated legacy tags, fully replaced by the current tag module.",
		"[Tags]: Removed the mMT-deathcount tag, replaced by the Death Counter module.",
	},
	NEW = {
		"[Execute Marker]: New Nameplates module - shows a marker on enemy nameplates at your specs execute threshold.",
		"[Objective Tracker]: New module to skin the Objective Tracker.",
		"[Spec Icons]: Added a new \"Clean\" spec icon style.",
	},
}
