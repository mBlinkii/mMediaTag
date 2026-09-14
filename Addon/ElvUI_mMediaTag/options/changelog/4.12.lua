local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[412] = {
	DATE = "14.09.2026",
	IMPORTANT = {
		"[INFO]: The cooldown manager module needs Blizzards cooldown manager, it is turned on under Options > Gameplay Enhancements.",
		"[INFO]: The cooldown manager module is based on the one in TrenchyUI, thanks to Trenchy for the permission.",
	},
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
	NEW = {
		"[Cooldown-Manager]: New module that moves the icons and bars of Blizzards cooldown manager into mMT containers, each display with its own mover, size, spacing, icons per row and growth direction.",
		"[Cooldown-Manager]: Every text on an icon or a bar has its own size, color, class color, position and offset, while the font and its contour are set once for the whole module.",
		"[Cooldown-Manager]: Each display has its own visibility rule, with a delay before it disappears and a fade time that softens both directions.",
		"[Cooldown-Manager]: Icons and bars can glow on a proc or per single spell, as a pixel, autocast, button or proc glow, each with its own color, speed and shape.",
		"[Cooldown-Manager]: While an aura is inside its refresh window it can keep Blizzards pandemic marker in a color of your choice, swap it for a glow or show nothing.",
		"[Cooldown-Manager]: The tracked bars can be given their own texture, width, height, mirrored columns and bar, background and class color, and a single aura can override that color with a right click in Blizzards cooldown manager.",
		"[Cooldown-Manager]: Icons can show their keybind, keep Blizzards border on harmful auras and hide the global cooldown swipe.",
		"[Cooldown-Manager]: An own tracker adds what Blizzard does not offer, your racials, healthstone, healing and combat potions, weyrnstone, belt tinker and trinkets, plus own spells, items and equipment slots.",
		"[Cooldown-Manager]: A demo mode fills every managed display with placeholders that follow your settings live, and settings can be copied from one display to another.",
	},
}
