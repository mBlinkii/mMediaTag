local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ElvUIIcons")

local MM = E:GetModule("Minimap")
local UF = E:GetModule("UnitFrames")
local strsub = strsub

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

-- the "mmt" keys only reach E.Media on plugin load, after ElvUI's Configure pass already fell back to DEFAULT - redo it once per session.
function module:Initialize()
	if module.isEnabled then return end
	module.isEnabled = true

	mMT:ForEachUFFrame(function(frame)
		if frame.unitframeType ~= "player" or not frame.db then return end
		if frame.CombatIndicator then UF:Configure_CombatIndicator(frame) end
		if frame.RestingIndicator then UF:Configure_RestingIndicator(frame) end
	end)

	-- UpdateSettings rebuilds the whole cluster, so only run it when an mMT mail icon is active
	local mail = MM.Initialized and MM.db and MM.db.icons.mail.texture
	if mail and strsub(mail, 1, 3) == "mmt" then MM:UpdateSettings() end
end
