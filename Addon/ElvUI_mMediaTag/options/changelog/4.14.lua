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
	},
	UPDATE = {
		"[DT-Combat-Time]: The combat timer updates its text once per second instead of on every frame.",
		"[DT-Game-Menu]: The memory and CPU tooltip only reads the CPU usage of the top five addons instead of every installed one.",
		"[System]: The portrait unit options and the color handling were rebuilt from shared templates, the options behave exactly as before but are easier to maintain.",
	},
}
