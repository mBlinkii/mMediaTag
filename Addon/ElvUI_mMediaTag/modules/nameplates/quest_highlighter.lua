local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-QuestHighlight", { "AceHook-3.0", "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM
local Utils = mMT.NameplateUtils

local pairs = pairs

local UnitExists = UnitExists

local QUEST_STATE = {
	ownerKey = "mMT_QuestOwner",
	activeKey = "mMT_IsQuestHighlighted",
	borderKey = "mMT_QuestBorder",
	configKey = "mMT_QuestConfig",
}

local function IsQuestPlate(nameplate)
	local questIcons = nameplate and nameplate.QuestIcons
	return questIcons and questIcons:IsShown() or false
end

local function GetEffectiveConfig(nameplate)
	return Utils:GetColorOverrideConfig(module.quest, nameplate, {
		moduleName = "NP-FocusHighlight",
		unitToken = "focus",
		blockedBy = {
			moduleName = "NP-TargetHighlight",
			unitToken = "target",
		},
	})
end

local function ApplyStyle(nameplate, cfg)
	Utils:ApplyHighlightStyle(nameplate, cfg, QUEST_STATE)
end

local function ResetStyle(nameplate)
	Utils:ResetHighlightStyle(nameplate, QUEST_STATE)
end

function module:UpdateQuest(nameplate)
	if not (nameplate and nameplate.unit and UnitExists(nameplate.unit)) then return end

	local cfg = IsQuestPlate(nameplate) and GetEffectiveConfig(nameplate)
	if cfg then
		ApplyStyle(nameplate, cfg)
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
		if owner then Utils:RefreshPlate(owner) end
	end

	questIcons.mMT_QuestHooked = true
end

local function OnPlateAdded(_, unit)
	local nameplate = Utils:GetPlateByUnit(unit)
	if not nameplate then return end

	HookQuestIcons(nameplate)
	Utils:RefreshPlate(nameplate)
end

local function OnPlateRemoved(_, unit)
	for nameplate in pairs(NP.Plates) do
		if nameplate.unit == unit then
			ResetStyle(nameplate)
			break
		end
	end
end

local function OnUpdateQuestIcons(_, nameplate)
	HookQuestIcons(nameplate)
	Utils:RefreshPlate(nameplate)
end

function module:Initialize()
	if not E.private.nameplates.enable then return end
	local db = E.db.mMediaTag.nameplates
	local enabled = db.quest.enable and (db.quest.changeColor or db.quest.changeBorder or db.quest.changeTexture)

	if enabled then
		module.quest = {
			enable = true,
			changeColor = db.quest.changeColor,
			changeBorder = db.quest.changeBorder,
			changeTexture = db.quest.changeTexture,
			texture = LSM:Fetch("statusbar", db.quest.texture),
			color = MEDIA.color.nameplates.quest_color,
			borderColor = MEDIA.color.nameplates.quest_border_color,
			ignoreThreat = db.quest.ignoreThreat,
		}

		if not module.initialized then
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
			Utils:RefreshPlate(nameplate)
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
	end
end
