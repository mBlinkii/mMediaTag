local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-FocusHighlight", { "AceHook-3.0", "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM
local Utils = mMT.NameplateUtils

local pairs = pairs

local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local FOCUS_STATE = {
	originalKey = "mMT_FocusOriginal",
	colorKey = "mMT_FocusColor",
	textureKey = "mMT_FocusTexture",
	ownerKey = "mMT_FocusOwner",
	activeKey = "mMT_IsFocusHighlighted",
	borderKey = "mMT_FocusBorder",
}

local function ReapplyTarget(nameplate)
	local targetModule = M["NP-TargetHighlight"]
	if not (targetModule and nameplate and nameplate.unit and UnitIsUnit(nameplate.unit, "target")) then return end

	targetModule:UpdateTarget(nameplate)
	Utils:UpdateTargetIndicator(nameplate)
end

local function GetCurrentFocusPlate()
	local directPlate = Utils:GetPlateByUnit("focus")
	if directPlate and directPlate.unit and UnitIsUnit(directPlate.unit, "focus") then return directPlate end

	for nameplate in pairs(NP.Plates) do
		if nameplate.unit and UnitIsUnit(nameplate.unit, "focus") then return nameplate end
	end
end

local function FocusPostUpdateColor(healthBar, unit, color)
	local original = healthBar.mMT_FocusOriginal
	if original and original.postUpdateColor then original.postUpdateColor(healthBar, unit, color) end

	local nameplate = healthBar.mMT_FocusOwner
	local cfg = module.focus
	if not (nameplate and cfg and healthBar.mMT_IsFocusHighlighted) then return end

	Utils:ReapplyCustomStyle(nameplate, healthBar, cfg, FOCUS_STATE)
end

local function ApplyStyle(nameplate)
	if UnitIsUnit(nameplate.unit, "target") then return end

	local cfg = module.focus
	Utils:ApplyHighlightStyle(nameplate, cfg, FOCUS_STATE, FocusPostUpdateColor)
end

local function ResetStyle(nameplate)
	Utils:ResetHighlightStyle(nameplate, FOCUS_STATE, module.defaultHealthTexture, ReapplyTarget)

	local questModule = M["NP-QuestHighlight"]
	if questModule and questModule.quest and questModule.quest.enable then questModule:UpdateQuest(nameplate) end
end

function module:UpdateFocus(nameplate)
	if not (nameplate and nameplate.unit and UnitExists(nameplate.unit)) then return end

	if UnitIsUnit(nameplate.unit, "focus") and not UnitIsUnit(nameplate.unit, "target") then
		ApplyStyle(nameplate)
	else
		ResetStyle(nameplate)
	end
end

local function OnFocusChanged()
	local previousPlate = module.currentFocusPlate
	if previousPlate then ResetStyle(previousPlate) end

	local currentPlate = GetCurrentFocusPlate()
	module.currentFocusPlate = currentPlate

	if currentPlate then module:UpdateFocus(currentPlate) end
end

local function OnTargetChanged()
	local focusPlate = GetCurrentFocusPlate()
	module.currentFocusPlate = focusPlate

	if focusPlate then module:UpdateFocus(focusPlate) end
end

local function OnPlateAdded(_, unit)
	if not unit then return end
	if not (UnitIsUnit(unit, "focus") or UnitIsUnit(unit, "target")) then return end

	local nameplate = Utils:GetPlateByUnit(unit)
	if not nameplate then return end

	if UnitIsUnit(unit, "focus") then module.currentFocusPlate = nameplate end

	module:UpdateFocus(nameplate)
end

local function OnPlateRemoved(_, unit)
	if not module.currentFocusPlate then return end
	if not unit or not UnitIsUnit(unit, "focus") then return end

	ResetStyle(module.currentFocusPlate)
	module.currentFocusPlate = nil
end

local function OnUpdateHealth(_, nameplate)
	if nameplate ~= module.currentFocusPlate then return end

	local healthBar = Utils:GetHealthBar(nameplate)
	local cfg = module.focus
	if not (healthBar and cfg and healthBar.mMT_IsFocusHighlighted) then return end

	healthBar.PostUpdateColor = FocusPostUpdateColor
	healthBar.mMT_FocusOwner = nameplate
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
		Utils:Initialize()

		module.focus = {
			enable = db.focus.enable and (db.focus.changeColor or db.focus.changeBorder or db.focus.changeTexture),
			changeColor = db.focus.changeColor,
			changeBorder = db.focus.changeBorder,
			changeTexture = db.focus.changeTexture,
			texture = LSM:Fetch("statusbar", db.focus.texture),
			color = MEDIA.color.nameplates.focus_color,
			borderColor = MEDIA.color.nameplates.focus_border_color,
			ignoreThreat = db.focus.ignoreThreat,
		}
		module.defaultHealthTexture = LSM:Fetch("statusbar", NP.db.statusbar) or E.media.normTex

		if not module.initialized then
			module:SecureHook(NP, "Update_Health", OnUpdateHealth)
			module.initialized = true
		end

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
		module.defaultHealthTexture = nil
	end
end
