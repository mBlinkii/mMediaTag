local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[413] = {
	DATE = "TBD",
	FIX = {
		"[Skins]: The BugSack skin only half covered the redesigned window of BugSack 12.1.2, the portrait and the scroll bar kept their Blizzard look and the header text sat too far to the right.",
		"[Skins]: The version line left of the page counter was missing in the BugSack window since BugSack 12.1.2.",
		"[Interrupt-On-CD]: Spell Lock was not recognized as the interrupt of a warlock, so the kick bar and castbar color stayed off.",
	},
	NEW = {
		"[DT-Time]: New datatext that shows the clock and switches to a combat timer as soon as you enter combat, with its own icon for each of the two states.",
		"[DT-Time]: The combat time keeps running for an adjustable delay after the fight, in an arena it starts with the gate timer and on a boss with the encounter.",
		"[DT-Time]: Time format and tooltip are taken from ElvUI's Time datatext, whose settings can be opened straight from the mMT options.",
	},
}
