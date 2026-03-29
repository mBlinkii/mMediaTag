local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[402] = {
	DATE = "29.03.2026",
	IMPORTANT = {
		"[INFO]: A completely new update for Midnight, almost everything has been optimized and restructured.",
		"[INFO]: Some modules and features are still missing, but this is a fully functional and working version for Midnight. There will be no version for Classic, where the 3.xx version should still work. I will continue to add more features over time.",
	},
    FIX = {
        "[DT-Professions]: Prevent nil Bug.",
        "[DT-Skin]: Prevent nil Bug.",
        "[DT-Tracker]: Colors does not Update correctly.",
        "[Details-Embedded]: Embedding does not work correctly.",
        "[Keystone-To-Chat]: Prevent Secret value Bug.",
        "[Minimap-Skin]: Bug with Skin Square round.",
        "[Phaseicon]: wrong BG texture.",
        "[TAGS]: Status icon and PvP icon colors does not work.",
        "[Tooltip-Icon]: Add missing Settings for this module.",
        "[Tooltip-Icon]: Prevent bug with secret values."
    },
	UPDATE = {
        "[Details-Embedded]: Fade in/out effect.",
        "[Details-Embedded]: Removed auto hide function.",
        "[LFG-Info]: Update hide function.",
        "[Portraits]: Removed leftover color settings.",
        "[System]: Removed unused colors from the DB."
	},
    NEW = {
        "[Dock]: Dock icon for Housing.",
        "[Portraits]: Texture Pixel.",
        "[TAGS]: A few new icons."
    }
}
