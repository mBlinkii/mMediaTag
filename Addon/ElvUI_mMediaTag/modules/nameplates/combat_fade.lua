local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-CombatFade", { "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")

-- Cache WoW Globals
local pairs = pairs
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local UnitAffectingCombat = UnitAffectingCombat
local UnitCanAttack = UnitCanAttack
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit

local function UpdatePlate(nameplate)
	local unit = nameplate.__unit
	if not unit or nameplate.frameType == "PLAYER" or nameplate == NP.TestFrame then return end

	local alpha, scale = 1, 1
	-- only while you fight, otherwise every enemy would be idle; the target stays fully visible
	if module.isEnabled and module.active and UnitExists(unit) and UnitCanAttack("player", unit) and not UnitIsUnit(unit, "target") and not UnitAffectingCombat(unit) then
		alpha, scale = module.alpha, module.scale
	end

	if nameplate.mMT_CombatFadeAlpha ~= alpha then
		nameplate.mMT_CombatFadeAlpha = alpha
		nameplate:SetAlpha(alpha)
	end

	-- ElvUI scales the plate by threat as well, so only touch the scale when it changes
	if nameplate.mMT_CombatFadeScale ~= scale then
		nameplate.mMT_CombatFadeScale = scale
		nameplate:SetScale(scale)
	end
end

local function RefreshPlates()
	if not NP.Plates then return end

	for nameplate in pairs(NP.Plates) do
		if nameplate:IsShown() then UpdatePlate(nameplate) end
	end
end

local function UpdateAllPlates()
	module.active = module.isEnabled and InCombatLockdown() and (not module.instanceOnly or IsInInstance())

	-- the combat flag of a unit has no reliable event, so poll while fading
	if module.active and not module.ticker then
		module.ticker = C_Timer.NewTicker(0.25, RefreshPlates)
	elseif not module.active and module.ticker then
		module.ticker:Cancel()
		module.ticker = nil
	end

	RefreshPlates()
end

local function OnUnitFlags(_, unit)
	if not (unit and module.active) then return end

	local nameplate = NP.Plates and mMT.NameplateUtils:GetPlateByUnit(unit)
	if nameplate then UpdatePlate(nameplate) end
end

function module:Initialize()
	if not E.private.nameplates.enable then return end

	local db = E.db.mMediaTag.nameplates.combat_fade

	if not db.enable then
		if module.isEnabled then
			module.isEnabled = false
			module:UnregisterAllEvents()
			UpdateAllPlates()
		end
		return
	end

	module.alpha = db.alpha
	module.scale = db.scale
	module.instanceOnly = db.instanceOnly

	if not module.hooked then
		-- runs for every new unit on a plate
		hooksecurefunc(NP, "UpdatePlate", function(_, nameplate)
			if nameplate then UpdatePlate(nameplate) end
		end)
		module.hooked = true
	end

	module:RegisterEvent("UNIT_FLAGS", OnUnitFlags)
	module:RegisterEvent("UNIT_THREAT_LIST_UPDATE", OnUnitFlags)
	module:RegisterEvent("PLAYER_REGEN_DISABLED", UpdateAllPlates)
	module:RegisterEvent("PLAYER_REGEN_ENABLED", UpdateAllPlates)
	module:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateAllPlates)
	module:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateAllPlates)
	module.isEnabled = true

	UpdateAllPlates()
end
