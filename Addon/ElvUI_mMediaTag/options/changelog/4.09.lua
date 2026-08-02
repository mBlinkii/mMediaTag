local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[409] = {
	DATE = "TBD",
	FIX = {
		"[Objective Tracker]: Completed objectives kept the normal text color instead of the completed color.",
		"[Objective Tracker]: The skin was only applied once the tracker updated on its own, so after a reload it kept the default look until something changed.",
	},
	NEW = {
		"[Objective Tracker]: Completed quest objectives now show a check icon, like the dungeon objectives.",
	},
}
