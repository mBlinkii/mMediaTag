local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[415] = {
	DATE = "TBD",
	FIX = {
		"[Cooldown-Manager]: Icons had rounded corners and texts were too large, ElvUI's cooldown manager skin is now turned on with the module.",
		"[Cooldown-Manager]: Proc glow was missing on replaced spells and could go out when icons were rearranged.",
		"[Dock]: A reassigned slot kept the dock's icon, texts and button until a reload.",
		"[Dock]: The character dock no longer prints the played time into the chat on every loading screen.",
		"[Dock]: The calendar dock kept the previous day after midnight.",
		"[DT-Teleports]: The current dungeon was sometimes not highlighted after joining a group.",
		"[Portraits]: Jiberish Fabled Icons are found again after the addon rename and its new spec icons can be selected.",
	},
	UPDATE = {
		"[Cooldown-Manager]: A fixed width or height now sets the icon size by itself.",
		"[Execute-Marker]: The marker follows the health bar size and fill direction by itself.",
		"[Interrupt-On-CD]: Less work per castbar and the kick marker no longer jumps by a pixel.",
		"[Options]: Settings menu reorganized into grouped categories with subpages, colored dots instead of icons, shortcut buttons on every category page, the same layout on every page and all module colors gathered under Colors.",
	},
	NEW = {
		"[Auto-Delete]: New module that fills in the confirmation word when you delete an item, in every client language.",
		"[Important-Casts]: Optional setting to bring casting enemy nameplates to the front.",
		"[Interrupt-On-CD]: Adjustable pixel glow thickness.",
		"[LFG-Info]: Shows the dungeon teleport and the matching group keystones when you join a M+ group.",
		"[Media-Pack]: Support for WoW Forever.",
		"[Raid-Marker-Colors]: New module that colors nameplate health bars by raid marker.",
	},
}
