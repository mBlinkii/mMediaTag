local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("NameplateTools")
local NP = E:GetModule("NamePlates")

function module:Initialize()
	if E.db.mMediaTag.nameplates.target_color and E.db["nameplates"]["colors"]["glowColor"] then
		E.db["nameplates"]["colors"]["glowColor"]["r"] = MEDIA.myclass.r
		E.db["nameplates"]["colors"]["glowColor"]["g"] = MEDIA.myclass.g
        E.db["nameplates"]["colors"]["glowColor"]["b"] = MEDIA.myclass.b
	end
    NP:ConfigureAll()
end
