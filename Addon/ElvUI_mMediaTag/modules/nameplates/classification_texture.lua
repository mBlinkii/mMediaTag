local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-ClassificationTexture", { "AceEvent-3.0", "AceHook-3.0" })

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM
local Utils = mMT.NameplateUtils

-- Cache WoW Globals
local next = next
local pairs = pairs
local wipe = wipe
local IsInInstance = IsInInstance
local UnitClassification = UnitClassification
local UnitHasPowerType = UnitHasPowerType
local UnitIsPlayer = UnitIsPlayer

local POWERTYPE_MANA = Enum.PowerType.Mana or 0
local textures = {}
local active, instanceOnly, inInstance, applies = false, false, false, false

local function SafeValue(value)
	if E:IsSecretValue(value) then return nil end
	return value
end

-- mirrors E:GetClassificationType, which compares its raw API results and would taint on a unit with a hidden identity
local function GetClassification(unit)
	local isPlayer = SafeValue(UnitIsPlayer(unit))
	if isPlayer == nil or isPlayer then return end

	local classification = SafeValue(UnitClassification(unit))
	if not classification then return end

	local hasMana = SafeValue(UnitHasPowerType(unit, POWERTYPE_MANA))
	local _, instanceType = IsInInstance()

	if instanceType == "party" and hasMana then return "caster" end
	if classification == "worldboss" or classification == "rareelite" or classification == "rare" then return classification end

	if classification == "elite" then
		local level = SafeValue(E:UnitEffectiveLevel(unit))
		local maxLevel = E.expansionLevelMax
		if level and maxLevel then
			if level >= (maxLevel + 2) then return "eliteBoss" end
			if level >= (maxLevel + 1) then return "eliteMini" end
		end
	end

	if hasMana then return "caster" end
end

-- handed to Utils so a highlight reset falls back to the classification instead of ElvUI's texture
local function BaseTexture(nameplate)
	if not applies then return end

	local key = nameplate and nameplate.mMT_Classification
	return key and textures[key]
end

local function ApplyPlate(nameplate)
	local healthBar = applies and Utils:GetHealthBar(nameplate)
	if not healthBar or Utils:HasTextureOverride(healthBar) then return end

	local texture = BaseTexture(nameplate)
	if texture then healthBar:SetStatusBarTexture(texture) end
end

local function OnPlateAdded(_, unit)
	if not (active and unit) then return end

	local nameplate = Utils:GetPlateByUnit(unit)
	if not nameplate then return end

	nameplate.mMT_Classification = GetClassification(unit)
	ApplyPlate(nameplate)
end

-- ElvUI repaints every registered bar with the global texture here
local function OnUpdateStatusBars()
	if not (applies and NP.Plates) then return end

	for nameplate in pairs(NP.Plates) do
		ApplyPlate(nameplate)
	end
end

local function RefreshPlates()
	if NP.Plates then
		for nameplate in pairs(NP.Plates) do
			if nameplate.__unit then nameplate.mMT_Classification = active and GetClassification(nameplate.__unit) or nil end
		end
	end

	if applies then
		OnUpdateStatusBars()
	elseif NP.Initialized then
		NP:Update_StatusBars()
	end
end

-- the caster rule depends on the instance type, so a zone change invalidates the cached classifications either way
local function UpdateState()
	local instance = IsInInstance() or false
	local newApplies = active and (not instanceOnly or instance) or false
	if instance == inInstance and newApplies == applies then return end

	inInstance, applies = instance, newApplies
	RefreshPlates()
end

function module:Initialize()
	if not E.private.nameplates.enable then return end

	local db = E.db.mMediaTag.nameplates.classification
	Utils:Initialize()

	wipe(textures)
	if db.enable then
		for key, settings in pairs(db.units) do
			if settings.enable then textures[key] = LSM:Fetch("statusbar", settings.texture) end
		end
	end

	active = next(textures) ~= nil
	instanceOnly = active and db.instanceOnly or false
	inInstance = IsInInstance() or false
	applies = active and (not instanceOnly or inInstance) or false
	Utils.baseTextureProvider = active and BaseTexture or nil

	if active and not module.isEnabled then
		module:RegisterEvent("NAME_PLATE_UNIT_ADDED", OnPlateAdded)
		module:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateState)
		module:RegisterEvent("ZONE_CHANGED_NEW_AREA", UpdateState)
		module:SecureHook(NP, "Update_StatusBars", OnUpdateStatusBars)
		module.isEnabled = true
	elseif not active and module.isEnabled then
		module:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
		module:UnregisterEvent("PLAYER_ENTERING_WORLD")
		module:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		module:UnhookAll()
		module.isEnabled = false
	end

	RefreshPlates()
end
