local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ElvUIIcons")

local MM = E:GetModule("Minimap")
local UF = E:GetModule("UnitFrames")
local strsub = strsub

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

-- Die "mmt"-Keys landen erst mit dem Plugin-Load in E.Media, ElvUIs Configure-Pass
-- fuer Combat-/Resting-Icon und die Minimap-Mail ist da schon durch und hat auf
-- DEFAULT zurueckgefallen. Deshalb einmal pro Session nachziehen; Arrows brauchen
-- das nicht, die Nameplates entstehen erst zur Laufzeit.
function module:Initialize()
	if module.isEnabled then return end
	module.isEnabled = true

	mMT:ForEachUFFrame(function(frame)
		if frame.unitframeType ~= "player" or not frame.db then return end
		if frame.CombatIndicator then UF:Configure_CombatIndicator(frame) end
		if frame.RestingIndicator then UF:Configure_RestingIndicator(frame) end
	end)

	-- UpdateSettings baut den ganzen Cluster neu, daher nur wenn ein mMT-Mailicon aktiv ist
	local mail = MM.Initialized and MM.db and MM.db.icons.mail.texture
	if mail and strsub(mail, 1, 3) == "mmt" then MM:UpdateSettings() end
end
