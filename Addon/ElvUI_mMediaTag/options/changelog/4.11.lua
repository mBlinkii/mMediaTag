local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[411] = {
	DATE = "TBD",
	FIX = {
		"[Skins]: The dropdown menu in the Premade Groups Filter window kept its Blizzard border instead of the ElvUI one.",
		"[Portraits]: Portraits of units whose identity is hidden in combat were colored wrong, players now use their class color and hostile NPCs in dungeons the enemy color again.",
		"[Tags]: The mMT-color tags fell back to the classification color on units whose identity is hidden in combat, players now use their class color again.",
	},
	UPDATE = {
		"[Skins]: The Class Codex skin was removed, the addon is only available bundled with the Icy Veins app.",
		"[Skins]: The BigWigs queue timer bar can be given its own texture.",
		"[Prey-Hunt]: The stage text on the prey icon is hidden once the hunt is complete, and can optionally show Ready in green instead.",
	},
	NEW = {
		"[Skins]: AussyLoot now matches ElvUI, its surfaces, borders and fonts follow your ElvUI settings and the accent color can be the AussyLoot one, the ElvUI value color, your class color or a custom one.",
		"[Portraits]: The portrait border can fill like a ring, showing either the health or the cast of the unit, set up separately for player, target, target of target, focus, pet, party, boss and arena.",
	},
}
