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
	},
}
