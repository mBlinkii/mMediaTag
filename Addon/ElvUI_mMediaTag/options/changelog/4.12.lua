local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[412] = {
	DATE = "TBD",
	FIX = {
		"[DT-Teleports]: The datatext threw an error inside a Mythic+ dungeon, where the group finder hides the data of other groups.",
		"[DT-Score]: The dungeon overview in the tooltip was not sorted, neither by score nor by key level.",
		"[Portraits]: Friendly NPCs inside a dungeon were colored like an enemy and mirrored like a player, because units hide their identity there.",
	},
	UPDATE = {
		"[DT-Score]: The dungeon you are currently in is marked with a pin in your class color in the dungeon overview.",
		"[DT-Teleports]: Two more icon styles for the datatext.",
		"[LFG-Info]: The popup was redesigned, it shows the location, the difficulty and the group name on three lines and drops the parts of the name that were listed twice.",
		"[LFG-Info]: The popup fades in with an animation, either sliding in, scaling up or plain, and the animation can be turned off.",
		"[LFG-Info]: The chat output was shortened to three lines framed by a colored line, instead of the old star border.",
	},
}
