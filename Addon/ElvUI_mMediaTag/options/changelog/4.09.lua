local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[409] = {
	DATE = "12.08.2026",
	IMPORTANT = {
		"[INFO]: This version requires ElvUI 15.19 or newer and will not load correctly on earlier releases.",
		"[INFO]: The BugSack skin is adapted from LuckyoneUI, thanks to Luckyone.",
	},
	FIX = {
		"[Objective-Tracker]: Completed objectives kept the normal text color instead of the completed color.",
		"[Portraits]: Portraits no longer turn solid black while a units model is still loading, for example during quest or item transformations.",
		"[DT-Dungeon]: The tooltip threw an error when no dungeon or raid difficulty had been set.",
		"[Interrupt-On-CD]: The castbar could keep the mMT color after the interrupt was used or after a cast was interrupted or failed, instead of returning to the ElvUI color.",
		"[Important-Casts]: Important casts were not marked on nameplates at all unless the health bar color override was enabled.",
		"[Tags]: The mMT-health:current tag was listed without a description.",
		"[System]: An export string that belongs to another setting was silently ignored on import, now it is rejected with a message in the chat.",
		"[System]: Opening the Great Vault, the Encounter Journal or the weekly affix tooltip threw an error on WoW 12.1.",
		"[Tags]: The role, PvP, faction, class icon and spec icon tags threw an error on units whose identity is hidden in combat, which also stopped the other tags in the same text from updating.",
		"[Portraits]: Class icon portraits threw an error on units whose identity is hidden in combat.",
		"[DT-Score]: The group tooltip threw an error on units whose identity is hidden in combat.",
	},
	UPDATE = {
		"[System]: Updated for WoW 12.1.",
		"[System]: Adapted to the current ElvUI, which reworked its font handling, media updates, module loading and frame templates - fonts, nameplates, the tracker skin, the interrupt spell of the current spec and the datatext panel skin are applied correctly again without a reload.",
		"[DT-Skin]: Export strings use a new format, so strings created by earlier versions can no longer be imported.",
		"[Media-Pack]: Removed the duplicate statusbar textures B17 and N15, they were identical to B11 and N4.",
		"[Media-Pack]: Renamed the chat backgrounds to close a numbering gap, Chat11 and Chat12 now show the images previously named Chat12 and Chat13.",
		"[Media-Pack]: Reduced the addon size by about 2 MB without any visible change to the textures, and packs are no longer registered twice while loading.",
	},
	NEW = {
		"[Auto-Quest]: New Auto Gossip option, selects gossip entries by type - quest label, cinematic, or single option.",
		"[Objective-Tracker]: Completed quest objectives now show a check icon, like the dungeon objectives.",
		"[Media-Pack]: Texture packs can now be enabled and disabled individually, in the mMT options under Media Pack or in the standalone panel that /mmtmp opens, each with a preview.",
		"[Media-Pack]: The Caith UI, MaUIv3 and mMT textures can now be enabled separately as the Misc pack.",
		"[Skins]: New Skins section in the options, collecting skins for other addons.",
		"[Skins]: BugSack now matches ElvUI, with an optional line showing the ElvUI, mMT and WoW versions next to the page counter.",
		"[Skins]: Auctionator now matches ElvUI on the Shopping, Selling, Cancelling and Auctionator tabs, including result lists, the item bag and the dialogs.",
		"[Prey-Hunt]: New module showing the current hunt stage as text on the prey icon, as 1/4, 1/4 (25%) or 25%.",
		"[Prey-Hunt]: Prey targets you have already defeated can be colored in the target list of the hunt gossip.",
		"[Addon-Manager]: New module that adds a bar below the Blizzard addon list, where you can save your enabled addons as named profiles, switch between them and filter the list.",
	},
}
