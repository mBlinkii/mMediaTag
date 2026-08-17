local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[410] = {
	DATE = "TBD",
	IMPORTANT = {
		"[INFO]: Datatext slots that showed a Season 1 crest are empty after this update and need to be assigned again, the Season 2 crests replaced them.",
	},
	FIX = {
		"[Datatext]: The Teleports and Professions datatexts threw an error when WoW returned a protected cooldown value.",
		"[Phaseicon]: The phase icon could taint when WoW returned a protected phase reason.",
		"[System]: Adapted to the current ElvUI, which renamed the unit field on its unit frames and nameplates.",
		"[Portraits]: Party, arena and boss portraits no longer updated after a roster change.",
		"[NP-Highlighters]: The target, focus and quest highlight was not applied to nameplates anymore.",
		"[Interrupt-On-CD]: The kick bar and the castbar color were not applied on nameplates anymore.",
	},
	UPDATE = {
		"[DT-Teleports]: The season list now shows the Midnight Season 2 dungeons, and the missing Midnight dungeon portals were added to the Midnight and dungeon submenus.",
		"[DT-Tracker]: The default currency list is updated for Midnight Season 2, with the Mistcrests, Venomblight Manaflux, Tidal Spark Dust and Nebulous Voidcore.",
		"[Skins]: Auctionator's own confirmation, name and money dialogs now match ElvUI as well.",
		"[Skins]: The Premade Groups Filter checkboxes can be resized and colored, in the ElvUI color, your class color or a custom one, and the PGF button on the group finder is skinned as well.",
		"[Skins]: The Premade Groups Filter window now has a divider below its title, like the BugSack skin.",
		"[System]: The developer commands are only listed in /mmt help while DEV mode is active.",
	},
	NEW = {
		"[Skins]: Class Codex now matches ElvUI, the codex panel, the compendium, every dropdown, the loadout dock and the widget in the talent frame.",
		"[Skins]: BigWigs now matches ElvUI, the keystone window and the timer bar below the dungeon invite, whose color can be the BigWigs one, your class color or a custom one.",
		"[Unitframe-Textures]: New module that sets the statusbar and the background texture per unit frame, separately for player, target, target of target, target of target of target, focus, pet, party, arena and boss.",
		"[Unitframe-Textures]: The castbar, incoming heal, absorb shield, heal absorb and power cost bars can each be given their own texture.",
		"[Unitframe-Textures]: The power bar and the background have their own switch per unit, so a texture change can stay on the health bar alone.",
	},
}
