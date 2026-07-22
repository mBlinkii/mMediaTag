local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AutoFriendlyNameplates", { "AceEvent-3.0" })

local GetInstanceInfo = GetInstanceInfo
local GetCVarBool = C_CVar.GetCVarBool
local SetCVar = C_CVar.SetCVar

-- We use nameplateShowFriendlyPlayers (not nameplateShowFriends) because ElvUI
-- manages nameplateShowFriends itself in NP:EnviromentConditionals() (fires on
-- PLAYER_ENTERING_WORLD, ZONE_CHANGED_NEW_AREA, PLAYER_UPDATE_RESTING) and in its
-- combat toggle (PLAYER_REGEN_ENABLED/DISABLED) and would override our value.
-- We still register the same events so our state is reapplied after ElvUI.
local events = {
	"PLAYER_ENTERING_WORLD",
	"ZONE_CHANGED_NEW_AREA",
	"PLAYER_UPDATE_RESTING",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_REGEN_DISABLED",
}

local function UpdateNameplates()
	if not module.db or not module.db.enable then return end

	local _, instanceType = GetInstanceInfo()
	local show = (instanceType == "party" and module.db.dungeon) or (instanceType == "raid" and module.db.raid) or false

	if GetCVarBool("nameplateShowFriendlyPlayers") ~= show then SetCVar("nameplateShowFriendlyPlayers", show and "1" or "0") end
end

function module:Initialize()
	module.db = E.db.mMediaTag.auto_friendly_nameplates

	if not module.db or not module.db.enable then
		module:UnregisterAllEvents()
		return
	end

	for _, event in next, events do
		module:RegisterEvent(event, UpdateNameplates)
	end

	UpdateNameplates()
end
