local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-FocusHighlight", { "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM
local Utils = mMT.NameplateUtils

local pairs = pairs

local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local FOCUS_STATE = {
	ownerKey = "mMT_FocusOwner",
	activeKey = "mMT_IsFocusHighlighted",
	borderKey = "mMT_FocusBorder",
	configKey = "mMT_FocusConfig",
}

local function GetCurrentFocusPlate()
	local directPlate = Utils:GetPlateByUnit("focus")
	if directPlate and directPlate.unit and UnitIsUnit(directPlate.unit, "focus") then return directPlate end

	for nameplate in pairs(NP.Plates) do
		if nameplate.unit and UnitIsUnit(nameplate.unit, "focus") then return nameplate end
	end
end

local function GetEffectiveConfig(nameplate)
	return Utils:GetColorOverrideConfig(module.focus, nameplate, {
		moduleName = "NP-TargetHighlight",
		unitToken = "target",
	})
end

local function ApplyStyle(nameplate, cfg)
	Utils:ApplyHighlightStyle(nameplate, cfg, FOCUS_STATE)
end

local function ResetStyle(nameplate)
	Utils:ResetHighlightStyle(nameplate, FOCUS_STATE)
end

function module:UpdateFocus(nameplate)
	if not (nameplate and nameplate.unit and UnitExists(nameplate.unit)) then return end

	local cfg = UnitIsUnit(nameplate.unit, "focus") and GetEffectiveConfig(nameplate)
	if cfg then
		ApplyStyle(nameplate, cfg)
	else
		ResetStyle(nameplate)
	end
end

local function OnFocusChanged()
	local previousPlate = module.currentFocusPlate
	local currentPlate = GetCurrentFocusPlate()
	module.currentFocusPlate = currentPlate

	if previousPlate and previousPlate ~= currentPlate then Utils:RefreshPlate(previousPlate) end

	if currentPlate then Utils:RefreshPlate(currentPlate) end
end

local function OnTargetChanged()
	local focusPlate = GetCurrentFocusPlate()
	module.currentFocusPlate = focusPlate

	if focusPlate then Utils:RefreshPlate(focusPlate) end
end

local function OnPlateAdded(_, unit)
	if not unit then return end
	if not (UnitIsUnit(unit, "focus") or UnitIsUnit(unit, "target")) then return end

	local nameplate = Utils:GetPlateByUnit(unit)
	if not nameplate then return end

	if UnitIsUnit(unit, "focus") then module.currentFocusPlate = nameplate end

	Utils:RefreshPlate(nameplate)
end

local function OnPlateRemoved(_, unit)
	if not module.currentFocusPlate then return end
	if not unit or not UnitIsUnit(unit, "focus") then return end

	ResetStyle(module.currentFocusPlate)
	module.currentFocusPlate = nil
end

function module:Initialize()
	if not E.private.nameplates.enable then return end
	local db = E.db.mMediaTag.nameplates
	local enabled = db.focus.enable and (db.focus.changeColor or db.focus.changeBorder or db.focus.changeTexture)

	if module.currentFocusPlate and module.currentFocusPlate ~= GetCurrentFocusPlate() then
		ResetStyle(module.currentFocusPlate)
		module.currentFocusPlate = nil
	end

	if enabled then
		module.focus = {
			enable = true,
			changeColor = db.focus.changeColor,
			changeBorder = db.focus.changeBorder,
			changeTexture = db.focus.changeTexture,
			texture = LSM:Fetch("statusbar", db.focus.texture),
			color = MEDIA.color.nameplates.focus_color,
			borderColor = MEDIA.color.nameplates.focus_border_color,
			ignoreThreat = db.focus.ignoreThreat,
		}

		if not module.eventsRegistered then
			module:RegisterEvent("PLAYER_FOCUS_CHANGED", OnFocusChanged)
			module:RegisterEvent("PLAYER_TARGET_CHANGED", OnTargetChanged)
			module:RegisterEvent("NAME_PLATE_UNIT_ADDED", OnPlateAdded)
			module:RegisterEvent("NAME_PLATE_UNIT_REMOVED", OnPlateRemoved)
			module.eventsRegistered = true
		end

		OnFocusChanged()
	else
		if module.currentFocusPlate then
			ResetStyle(module.currentFocusPlate)
			module.currentFocusPlate = nil
		end

		if module.eventsRegistered then
			module:UnregisterEvent("PLAYER_FOCUS_CHANGED")
			module:UnregisterEvent("PLAYER_TARGET_CHANGED")
			module:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
			module:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
			module.eventsRegistered = nil
		end

		module.focus = nil
	end
end
