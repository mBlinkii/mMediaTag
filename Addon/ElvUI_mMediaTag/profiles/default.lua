local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- debug mode
mMT.defaults.debug = {
	disabledAddons = {},
	debugMode = false,
}

mMT.keystones = {}

mMT.affixes = {
	currentAffixes = nil,
	resetTime = 0,
}
