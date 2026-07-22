local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[405] = {
	DATE = "19.04.2026",
	IMPORTANT = {
		"[INFO]: A completely new update for Midnight, almost everything has been optimized and restructured.",
		"[INFO]: Some modules and features are still missing, but this is a fully functional and working version for Midnight. There will be no version for Classic, where the 3.xx version should still work. I will continue to add more features over time.",
	},
	FIX = {
		"[LFG-Info]: Fixed visibility logic for the popup.",
		"[Highlighters]: Fix stack overflow.",
        "[System]: Update guild identification logic to use isGuildParty for consistency across modules.",
	},
	UPDATE = {
		"[System]: Refactor greeting message initialization logic.",
        "[System]: Minor code optimizations.",
        "[DT-Score]: Fallback for Group overview tooltip, uses now Blizzard api ift LOR is not available.",
        "[Details-Embedded]: The tooltip is now moved up so that there is no overlap..",
	},
    NEW = {
        "[Auto-Sing-Up]: Auto Sing Up & Role check accept module.",
        "[Important-Casts]: Can now Highlight the healthbar of the Unit.",
    },
}
