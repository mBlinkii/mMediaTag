local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[407] = {
	DATE = "12.06.2026",
	FIX = {
		"[Core]: Weekly reset detection now uses the Blizzard API and works reliably in every region and timezone.",
		"[Core]: A faulty module can no longer prevent other modules from initializing.",
		"[Dice Button]: Button now loads reliably on login and reload.",
		"[Difficulty Info]: Fixed event registration, the display now also updates after loading screens.",
		"[Portraits]: Party portraits no longer show wrong portraits when inviting players.",
		"[Portraits]: Fixed an error with extra textures on units without classification media (e.g. normal mobs with unit color or forced reaction).",
		"[Details Embedded]: No longer collapses the chat panel on login/reload - only the embedded chat frames are hidden, datatexts stay visible.",
		"[Role Icons]: Party frame updates are now combat-safe (no secure header rebuild).",
	},
	UPDATE = {
		"[LFG Invite Info]: New look with smooth fade in/out, accent line, divider and clean auto sizing.",
	},
	NEW = {
		"[Death Counter]: New optional module - shows deaths and lost time in the current Mythic+ run next to the minimap (default off).",
		"[LFG Invite Info]: Selectable themes for the popup: Class (accent line), Gold (frame) and Minimal (text only).",
		"[LFG Invite Info]: New option to embed the icon inside the window (requires background).",
	},
}
