local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[402] = {
	DATE = "29.03.2026",
	IMPORTANT = {
		"[INFO]: A completely new update for Midnight, almost everything has been optimized and restructured.",
		"[INFO]: Some modules and features are still missing, but this is a fully functional and working version for Midnight. There will be no version for Classic, where the 3.xx version should still work. I will continue to add more features over time.",
	},
    FIX = {
        "[Portraits]: Prevent nil error with Boss Portraits.",
        "[Portraits]: Load Custom Class icons sooner.",
        "[Portraits]: Cast icons if class icons are enabled."
    },
	UPDATE = {
        "[Portraits]: Update Boss Portraits amount.",
        "[Portraits]: Optimized Settings behavior.",
        "[Portraits]: Death check optimized.",
        "[NP-Highlighters]: Take care of ElvUI changes.",
        "[NP-Highlighters]: Optimized the Highlighters.",
        "[NP-Highlighters]: Add Border color functionality.",
        "[NP-Highlighters]: Separated the config."
	},
    NEW = {
        "[Portraits]: Add Spec icons.",
        "[Important-Casts]: Show Important cast, thx to Trenchy."
    }
}
