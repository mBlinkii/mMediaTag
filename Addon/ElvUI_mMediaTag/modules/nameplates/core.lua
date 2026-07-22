local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-HighlightCore", { "AceHook-3.0" })

local NP = E:GetModule("NamePlates")
local Utils = mMT.NameplateUtils

local function OnUpdateHealth(_, nameplate)
	local healthBar = Utils:GetHealthBar(nameplate)
	if not Utils:HasActiveHighlight(healthBar) then return end

	healthBar.PostUpdateColor = Utils.HighlightPostUpdateColor
end

function module:Initialize()
	if not E.private.nameplates.enable then return end
	if not (E.db.mMediaTag.nameplates.target.enable or E.db.mMediaTag.nameplates.focus.enable or E.db.mMediaTag.nameplates.quest.enable) then return end
	Utils:Initialize()

	if not module.initialized then
		module:SecureHook(NP, "Update_Health", OnUpdateHealth)
		module.initialized = true
	end
end
