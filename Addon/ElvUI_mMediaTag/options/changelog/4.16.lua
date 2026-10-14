local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[416] = {
	DATE = "14.10.2026",
	FIX = {
		"[Cooldown-Manager]: The custom tracker showed no icon for equipment slots and missed spells that replace another one.",
		"[System]: Fixed errors and missing icons with WoW 12.1.5, among them in the profession, tracker, score and dungeon datatexts.",
	},
	UPDATE = {
		"[System]: Updated for WoW 12.1.5.",
		"[System]: Switched to the current Blizzard API, mMT no longer relies on Blizzard's deprecated fallbacks.",
	},
}
