local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[409] = {
	DATE = "TBD",
	FIX = {
		"[System]: Fonts are applied again after ElvUI changed how a font has to be handed to FontTemplate.",
		"[Objective Tracker]: Completed objectives kept the normal text color instead of the completed color.",
		"[Objective Tracker]: The skin was only applied once the tracker updated on its own, so after a reload it kept the default look until something changed.",
		"[Portraits]: Portraits no longer turn solid black while a units model is still loading, for example during quest or item transformations.",
		"[Media-Pack]: A texture pack that had been disabled could not be enabled again in the same session.",
		"[Media-Pack]: The background list offered an entry whose texture file was missing.",
		"[DT-Skin]: The panel skin was reset whenever ElvUI refreshed its frame templates, for example after changing an ElvUI texture or border color.",
	},
	UPDATE = {
		"[System]: Adapted to the current ElvUI, which loads plugins after its own initialization and runs its update loops as coroutines.",
		"[DT-Skin]: Export strings use a new format, so strings created by earlier versions can no longer be imported.",
		"[Media-Pack]: Removed the duplicate statusbar textures B17 and N15, they were identical to B11 and N4.",
		"[Media-Pack]: Renamed the chat backgrounds to close a numbering gap, Chat11 and Chat12 now show the images previously named Chat12 and Chat13.",
		"[Media-Pack]: Texture packs are no longer registered twice while loading.",
		"[Media-Pack]: Reduced the addon size by about 2 MB without any visible change to the textures.",
	},
	NEW = {
		"[Auto-Quest]: New Auto Gossip option, selects gossip entries by type - quest label, cinematic, or single option.",
		"[Objective Tracker]: Completed quest objectives now show a check icon, like the dungeon objectives.",
		"[Media-Pack]: New settings panel under Interface - AddOns with a preview for every texture pack, /mmtmp opens it.",
		"[Media-Pack]: The Caith UI, MaUIv3 and mMT textures can now be enabled separately as the Misc pack.",
		"[Media-Pack]: The texture packs can now be enabled and disabled from the mMT options, under their own Media Pack entry.",
	},
}
