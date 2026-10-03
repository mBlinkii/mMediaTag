local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[415] = {
	DATE = "TBD",
	FIX = {
		"[Cooldown-Manager]: The font settings of the buff bars and the count texts were overwritten by ElvUI's cooldown manager skin since its latest skin rework, which made the text too large.",
		"[Dock]: Changing a datatext slot from a dock to another datatext left the dock icon, texts and button on the slot until a reload.",
		"[Dock]: After the volume dock the slot showed no text at all when another datatext was put there without a reload.",
		"[Dock]: The None dock did not remove the click button and the texts of the dock that was on the slot before.",
		"[Dock]: The character dock printed the played time into the chat on every loading screen, it now asks only on login and reload and keeps the chat clean.",
		"[Dock]: The calendar dock kept the date of the previous day after midnight.",
		"[Cooldown-Manager]: The icons kept Blizzard's rounded corners for players with ElvUI's cooldown manager skin turned off (ElvUI's default), the skin is now turned on together with the mMT cooldown manager.",
	},
	UPDATE = {
		"[Interrupt-On-CD]: The cooldown of your interrupt is read once per frame for all castbars instead of once per castbar, and the kick marker no longer jumps by a pixel.",
		"[Execute-Marker]: The marker follows the size and fill direction of the health bar by itself instead of being measured.",
	},
	NEW = {
		"[Important-Casts]: Optional setting that brings enemy nameplates with a running cast in front of the other nameplates, important casts keep their highlight on top.",
		"[Interrupt-On-CD]: The thickness of the pixel glow can be set.",
		"[Raid-Marker-Colors]: New module that colors the health bar of nameplates with a raid marker in the color of that marker, every marker can be turned on and colored on its own (skull and cross are on by default).",
	},
}
