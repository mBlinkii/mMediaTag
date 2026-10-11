local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[415] = {
	DATE = "TBD",
	FIX = {
		"[Cooldown-Manager]: Icons had rounded corners and texts were too large, ElvUI's cooldown manager skin is now turned on with the module.",
		"[Cooldown-Manager]: Proc glow was missing on replaced spells and could go out when icons were rearranged.",
		"[Dock]: A reassigned slot kept the dock's icon, texts and button until a reload.",
		"[Dock]: The character dock no longer prints the played time into the chat on every loading screen.",
		"[Dock]: The calendar dock kept the previous day after midnight.",
		"[DT-Teleports]: The dungeon of your group was sometimes not highlighted after signing up or while forming the group.",
		"[DT-Teleports]: Learned dungeon teleports and not yet loaded items or toys were sometimes missing, and Horde mages missed their city teleports.",
		"[Group-Keystones]: Keys of group members could disappear although nothing changed in the group.",
		"[Portraits]: Jiberish Fabled Icons are found again after the addon rename and its new spec icons can be selected.",
		"[Tags]: The skull18 icon showed the skull2 texture.",
	},
	UPDATE = {
		"[Cooldown-Manager]: A fixed width or height now sets the icon size by itself.",
		"[Execute-Marker]: The marker follows the health bar size and fill direction by itself.",
		"[Interrupt-On-CD]: Less work per castbar and the kick marker no longer jumps by a pixel.",
		"[Objective-Tracker]: Hovered entries are highlighted, Initiative Tasks are skinned too and the options are reorganized.",
		"[Options]: Settings menu reorganized into grouped categories with subpages and new icons, a new Comfort category for automations and helpers, shortcut buttons on every category page, a reset button and a short description on every module page, module settings grouped the same way everywhere (Settings, Layout, Icon, Text, Colors), new modules marked as New and all module colors gathered under Colors.",
		"[System]: Removed unused textures, the addon is smaller.",
	},
	NEW = {
		"[Auto-Delete]: New module that fills in the confirmation word when you delete an item, in every client language.",
		"[Interrupt-On-CD]: Adjustable pixel glow thickness.",
		"[Keystone-Teleports]: New module that lists the keystones of your group with a clickable teleport to each dungeon and highlights the dungeon of your group, optionally flashing it once the group is full.",
		"[LFG-Info]: Shows the matching group keystones when you join a M+ group.",
		"[Mail-Helper]: New module for the mailbox that takes only the gold from your mails, shows an inbox overview, keeps opening an overflowing inbox and lists your alts and contacts as recipients.",
		"[Media-Pack]: Support for WoW Forever.",
		"[Objective-Tracker]: Quest titles can be colored by difficulty, progress and timer bars are skinned and the header bar can also be shown under the main header.",
		"[Raid-Marker-Colors]: New module that colors nameplate health bars by raid marker.",
	},
}
