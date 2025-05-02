local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

-- E.Media = {
-- 	Fonts = {},
-- 	Sounds = {},
-- 	Arrows = {},
-- 	MailIcons = {},
-- 	RestIcons = {},
-- 	ChatEmojis = {},
-- 	ChatLogos = {},
-- 	Textures = {},
-- 	CombatIcons = {}
-- }

do
	-- Combat Icons
	for name, path in pairs(MEDIA.icons.combat) do
		E.Media.CombatIcons["mmt" .. name] = path
	end

	-- Mail Icons
	for name, path in pairs(MEDIA.icons.mail) do
		E.Media.MailIcons["mmt" .. name] = path
	end

	-- Resting Icons
	for name, path in pairs(MEDIA.icons.resting) do
		E.Media.RestIcons["mmt" .. name] = path
	end

	-- Arrows
	for name, path in pairs(MEDIA.arrows) do
		E.Media.Arrows["mmt" .. name] = path
	end
end
