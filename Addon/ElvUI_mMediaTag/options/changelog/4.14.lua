local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[414] = {
	DATE = "TBD",
	FIX = {
		"[DT-Combat-Time]: The combat timer threw an error on every frame when the icon for in or out of combat was set to None.",
		"[Tags]: The mMT-role tags threw an error on units without an assigned role, for example on your own frame while solo.",
		"[Tags]: The mMT-health:current tag used the short number format, it now uses the long one while mMT-health:current:short stays short.",
		"[Datatext]: The menus of the teleports, professions and game menu datatexts created new buttons every time they were opened, so the memory usage kept growing.",
		"[Datatext]: The menus of the teleports, professions and game menu datatexts now close when combat starts, an open teleports menu used to cause blocked action errors.",
		"[Portraits]: The test mode of the boss, arena and party frames threw an error with the Blizzard spec icon style.",
		"[DT-Score]: Your own keystone could throw an error when the game returned no color for its level.",
		"[System]: Mobs far above your level were saved as bosses for good and kept the boss classification on portraits and tags, the saved list is reset once.",
		"[DT-Teleports]: Teleports are used by their ID instead of their name, so items and toys that share a name no longer pick the wrong one.",
		"[System]: The changelog opened again after switching to another profile or character, it now only opens once per new version.",
		"[Localization]: 16 texts of the Objective Tracker options and the two latency lines of the game menu tooltip were shown in English in the German client.",
		"[DT-Teleports]: The highlight of the current dungeon was missing or marked the wrong dungeon after applying to several groups, after listing a new key right after a run and when your own group listed a dungeon.",
	},
	UPDATE = {
		"[DT-Combat-Time]: The combat timer updates its text once per second instead of on every frame.",
		"[DT-Game-Menu]: The memory and CPU tooltip only reads the CPU usage of the top five addons instead of every installed one.",
		"[System]: The portrait unit options and the color handling were rebuilt from shared templates, the options behave exactly as before but are easier to maintain.",
		"[Localization]: Spanish, Mexican Spanish, French, Italian, Brazilian Portuguese, Russian, Korean and Simplified and Traditional Chinese are complete again, around 285 missing texts per language were translated.",
		"[Localization]: Removed about 35 texts that were no longer used anywhere.",
		"[System]: Every build now runs automatic code checks (luacheck and StyLua) first, a cleanup pass removed unused code and brought all files to one formatting.",
		"[DT-Teleports]: The highlight of the current dungeon can be turned off and its color can be changed.",
	},
	NEW = {
		"[DT-Teleports]: Optional highlight of the dungeon of your own keystone in the season list, with its own color.",
	},
}
