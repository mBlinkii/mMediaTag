local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-TargetHighlight", { "AceHook-3.0", "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM
local Utils = mMT.NameplateUtils

local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local TARGET_STATE = {
	originalKey = "mMT_TargetOriginal",
	colorKey = "mMT_TargetColor",
	textureKey = "mMT_TargetTexture",
	ownerKey = "mMT_TargetOwner",
	activeKey = "mMT_IsTargetHighlighted",
	borderKey = "mMT_TargetBorder",
}

local function TargetPostUpdateColor(healthBar, unit, color)
	Utils:HandlePostUpdateColor(healthBar, unit, color, TARGET_STATE, module.target, TargetPostUpdateColor)
end

local function ApplyStyle(nameplate)
	local cfg = module.target
	Utils:ApplyHighlightStyle(nameplate, cfg, TARGET_STATE, TargetPostUpdateColor)
end

local function ResetStyle(nameplate)
	Utils:ResetHighlightStyle(nameplate, TARGET_STATE, module.defaultHealthTexture)

	local questModule = M["NP-QuestHighlight"]
	if questModule and questModule.quest and questModule.quest.enable then questModule:UpdateQuest(nameplate) end
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
		ResetStyle(previousPlate)
		Utils:UpdateTargetIndicator(previousPlate)
	end

	module.currentTargetPlate = currentPlate

	if currentPlate then
		module:UpdateTarget(currentPlate)
		Utils:UpdateTargetIndicator(currentPlate)
	end
end

local function OnPlateAdded(_, unit)
	if not unit or not UnitIsUnit(unit, "target") then return end

	local nameplate = Utils:GetPlateByUnit(unit)
	module.currentTargetPlate = nameplate

	if nameplate then
		module:UpdateTarget(nameplate)
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

local function OnUpdateHealth(_, nameplate)
	if nameplate ~= module.currentTargetPlate then return end

	local healthBar = Utils:GetHealthBar(nameplate)
	local cfg = module.target
	if not (healthBar and cfg and healthBar.mMT_IsTargetHighlighted) then return end

	healthBar.PostUpdateColor = TargetPostUpdateColor
	healthBar.mMT_TargetOwner = nameplate
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
		Utils:Initialize()

		module.target = {
			enable = db.target.enable and (db.target.changeColor or db.target.changeBorder or db.target.changeTexture),
			changeColor = db.target.changeColor,
			changeBorder = db.target.changeBorder,
			changeTexture = db.target.changeTexture,
			texture = LSM:Fetch("statusbar", db.target.texture),
			color = MEDIA.color.nameplates.target_color,
			borderColor = MEDIA.color.nameplates.target_border_color,
			ignoreThreat = db.target.ignoreThreat,
		}
		module.defaultHealthTexture = LSM:Fetch("statusbar", NP.db.statusbar) or E.media.normTex

		if not module.initialized then
			module:SecureHook(NP, "Update_Health", OnUpdateHealth)
			module.initialized = true
		end

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
		module.defaultHealthTexture = nil
	end
end
