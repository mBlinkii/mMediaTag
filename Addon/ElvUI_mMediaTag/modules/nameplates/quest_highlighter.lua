local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-QuestHighlight", { "AceHook-3.0", "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM
local Utils = mMT.NameplateUtils

local pairs = pairs

local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit

local QUEST_STATE = {
	originalKey = "mMT_QuestOriginal",
	colorKey = "mMT_QuestColor",
	textureKey = "mMT_QuestTexture",
	ownerKey = "mMT_QuestOwner",
	activeKey = "mMT_IsQuestHighlighted",
	borderKey = "mMT_QuestBorder",
}

local function ReapplyPriorityHighlights(nameplate)
	local targetModule = M["NP-TargetHighlight"]
	if targetModule then
		targetModule:UpdateTarget(nameplate)
		Utils:UpdateTargetIndicator(nameplate)
	end

	local focusModule = M["NP-FocusHighlight"]
	if focusModule then focusModule:UpdateFocus(nameplate) end
end

local function IsQuestPlate(nameplate)
	local questIcons = nameplate and nameplate.QuestIcons
	return questIcons and questIcons:IsShown() or false
end

local function QuestPostUpdateColor(healthBar, unit, color)
	Utils:HandlePostUpdateColor(healthBar, unit, color, QUEST_STATE, module.quest, QuestPostUpdateColor)
end

local function ApplyStyle(nameplate)
	if UnitIsUnit(nameplate.unit, "target") or UnitIsUnit(nameplate.unit, "focus") then return end

	local cfg = module.quest
	Utils:ApplyHighlightStyle(nameplate, cfg, QUEST_STATE, QuestPostUpdateColor)
end

local function ResetStyle(nameplate)
	Utils:ResetHighlightStyle(nameplate, QUEST_STATE, module.defaultHealthTexture, ReapplyPriorityHighlights)
end

function module:UpdateQuest(nameplate)
	if not (nameplate and nameplate.unit and UnitExists(nameplate.unit)) then return end

	if IsQuestPlate(nameplate) and not UnitIsUnit(nameplate.unit, "target") and not UnitIsUnit(nameplate.unit, "focus") then
		ApplyStyle(nameplate)
	else
		ResetStyle(nameplate)
	end
end

local function HookQuestIcons(nameplate)
	local questIcons = nameplate and nameplate.QuestIcons
	if not (questIcons and not questIcons.mMT_QuestHooked) then return end

	local original = questIcons.PostUpdate
	questIcons.PostUpdate = function(element, ...)
		if original then original(element, ...) end

		local owner = element.__owner
		if owner then module:UpdateQuest(owner) end
	end

	questIcons.mMT_QuestHooked = true
end

local function OnPlateAdded(_, unit)
	local nameplate = Utils:GetPlateByUnit(unit)
	if not nameplate then return end

	HookQuestIcons(nameplate)
	module:UpdateQuest(nameplate)
end

local function OnPlateRemoved(_, unit)
	for nameplate in pairs(NP.Plates) do
		if nameplate.unit == unit then
			ResetStyle(nameplate)
			break
		end
	end
end

local function OnUpdateHealth(_, nameplate)
	local healthBar = Utils:GetHealthBar(nameplate)
	local cfg = module.quest
	if not (healthBar and cfg and healthBar.mMT_IsQuestHighlighted) then return end

	healthBar.PostUpdateColor = QuestPostUpdateColor
	healthBar.mMT_QuestOwner = nameplate
end

local function OnUpdateQuestIcons(_, nameplate)
	HookQuestIcons(nameplate)
	module:UpdateQuest(nameplate)
end

function module:Initialize()
	if not E.private.nameplates.enable then return end
	local db = E.db.mMediaTag.nameplates
	local enabled = db.quest.enable and (db.quest.changeColor or db.quest.changeBorder or db.quest.changeTexture)

	if enabled then
		Utils:Initialize()
		module.quest = {
			enable = db.quest.enable and (db.quest.changeColor or db.quest.changeBorder or db.quest.changeTexture),
			changeColor = db.quest.changeColor,
			changeBorder = db.quest.changeBorder,
			changeTexture = db.quest.changeTexture,
			texture = LSM:Fetch("statusbar", db.quest.texture),
			color = MEDIA.color.nameplates.quest_color,
			borderColor = MEDIA.color.nameplates.quest_border_color,
			ignoreThreat = db.quest.ignoreThreat,
		}
		module.defaultHealthTexture = LSM:Fetch("statusbar", NP.db.statusbar) or E.media.normTex

		if not module.initialized then
			module:SecureHook(NP, "Update_Health", OnUpdateHealth)
			module:SecureHook(NP, "Update_QuestIcons", OnUpdateQuestIcons)
			module.initialized = true
		end

		if not module.eventsRegistered then
			module:RegisterEvent("NAME_PLATE_UNIT_ADDED", OnPlateAdded)
			module:RegisterEvent("NAME_PLATE_UNIT_REMOVED", OnPlateRemoved)
			module.eventsRegistered = true
		end

		for nameplate in pairs(NP.Plates) do
			HookQuestIcons(nameplate)
			module:UpdateQuest(nameplate)
		end
	else
		for nameplate in pairs(NP.Plates) do
			ResetStyle(nameplate)
		end

		if module.eventsRegistered then
			module:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
			module:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
			module.eventsRegistered = nil
		end

		module.quest = nil
		module.defaultHealthTexture = nil
	end
end
