local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-TargetGlow", { "AceHook-3.0" })

local NP = E:GetModule("NamePlates")

function module:Initialize()
	if not E.private.nameplates.enable then return end
	if not E.db.mMediaTag.nameplates.target_glow_color then return end

	NP.db.colors.glowColor.r = MEDIA.myclass.r
	NP.db.colors.glowColor.g = MEDIA.myclass.g
	NP.db.colors.glowColor.b = MEDIA.myclass.b
end
