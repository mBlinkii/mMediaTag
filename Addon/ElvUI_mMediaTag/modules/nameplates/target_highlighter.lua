local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-TargetHighlight", { "AceEvent-3.0" })

local LSM = E.Libs.LSM
local Utils = mMT.NameplateUtils

local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local TARGET_STATE = {
	ownerKey = "mMT_TargetOwner",
	activeKey = "mMT_IsTargetHighlighted",
	borderKey = "mMT_TargetBorder",
}

local function ApplyStyle(nameplate)
	Utils:ApplyHighlightStyle(nameplate, module.target, TARGET_STATE)
end

local function ResetStyle(nameplate)
	Utils:ResetHighlightStyle(nameplate, TARGET_STATE)
end

function module:UpdateTarget(nameplate)
	if not (nameplate and nameplate.unit and UnitExists(nameplate.unit)) then return end

	if UnitIsUnit(nameplate.unit, "target") then
		ApplyStyle(nameplate)
	else
		ResetStyle(nameplate)
	end
end

local function OnTargetChanged()
	local previousPlate = module.currentTargetPlate
	local currentPlate = Utils:GetPlateByUnit("target")

	if previousPlate and previousPlate ~= currentPlate then
		Utils:RefreshPlate(previousPlate)
		Utils:UpdateTargetIndicator(previousPlate)
	end

	module.currentTargetPlate = currentPlate

	if currentPlate then
		Utils:RefreshPlate(currentPlate)
		Utils:UpdateTargetIndicator(currentPlate)
	end
end

local function OnPlateAdded(_, unit)
	if not unit or not UnitIsUnit(unit, "target") then return end

	local nameplate = Utils:GetPlateByUnit(unit)
	module.currentTargetPlate = nameplate

	if nameplate then
		Utils:RefreshPlate(nameplate)
		Utils:UpdateTargetIndicator(nameplate)
	end
end

local function OnPlateRemoved(_, unit)
	if not module.currentTargetPlate then return end
	if not unit or not UnitIsUnit(unit, "target") then return end

	ResetStyle(module.currentTargetPlate)
	Utils:UpdateTargetIndicator(module.currentTargetPlate)
	module.currentTargetPlate = nil
end

function module:Initialize()
	if not E.private.nameplates.enable then return end
	local db = E.db.mMediaTag.nameplates
	local enabled = db.target.enable and (db.target.changeColor or db.target.changeBorder or db.target.changeTexture)

	if module.currentTargetPlate and module.currentTargetPlate ~= Utils:GetPlateByUnit("target") then
		ResetStyle(module.currentTargetPlate)
		Utils:UpdateTargetIndicator(module.currentTargetPlate)
		module.currentTargetPlate = nil
	end

	if enabled then
		module.target = {
			enable = true,
			changeColor = db.target.changeColor,
			changeBorder = db.target.changeBorder,
			changeTexture = db.target.changeTexture,
			texture = LSM:Fetch("statusbar", db.target.texture),
			color = MEDIA.color.nameplates.target_color,
			borderColor = MEDIA.color.nameplates.target_border_color,
			ignoreThreat = db.target.ignoreThreat,
		}

		if not module.eventsRegistered then
			module:RegisterEvent("PLAYER_TARGET_CHANGED", OnTargetChanged)
			module:RegisterEvent("NAME_PLATE_UNIT_ADDED", OnPlateAdded)
			module:RegisterEvent("NAME_PLATE_UNIT_REMOVED", OnPlateRemoved)
			module.eventsRegistered = true
		end

		OnTargetChanged()
	else
		if module.currentTargetPlate then
			ResetStyle(module.currentTargetPlate)
			Utils:UpdateTargetIndicator(module.currentTargetPlate)
			module.currentTargetPlate = nil
		end

		if module.eventsRegistered then
			module:UnregisterEvent("PLAYER_TARGET_CHANGED")
			module:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
			module:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
			module.eventsRegistered = nil
		end

		module.target = nil
	end
end
