local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[409] = {
	DATE = "TBD",
	FIX = {
		"[System]: Fonts are applied again after ElvUI changed how a font has to be handed to FontTemplate.",
		"[Objective Tracker]: Completed objectives kept the normal text color instead of the completed color.",
		"[Objective Tracker]: The skin was only applied once the tracker updated on its own, so after a reload it kept the default look until something changed.",
		"[Portraits]: Portraits no longer turn solid black while a units model is still loading, for example during quest or item transformations.",
	},
	UPDATE = {
		"[System]: Adapted to the current ElvUI, which loads plugins after its own initialization and runs its update loops as coroutines.",
	},
	NEW = {
		"[Auto-Quest]: New Auto Gossip option, selects gossip entries by type - quest label, cinematic, or single option.",
		"[Objective Tracker]: Completed quest objectives now show a check icon, like the dungeon objectives.",
	},
}
