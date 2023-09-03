local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local strjoin = strjoin
local format = format

--Variables
local _G = _G
local UnitXPMax = UnitXPMax
local IsShiftKeyDown = IsShiftKeyDown
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestLogRewardXP = GetQuestLogRewardXP
local SelectQuestLogEntry = SelectQuestLogEntry
local GetQuestLogRewardMoney = GetQuestLogRewardMoney
local BreakUpLargeNumbers = BreakUpLargeNumbers
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local GetNumQuestLogEntries = (C_QuestLog and C_QuestLog.GetNumQuestLogEntries) or GetNumQuestLogEntries
local TRACKER_HEADER_QUESTS = TRACKER_HEADER_QUESTS
local COMPLETE = COMPLETE
local INCOMPLETE = INCOMPLETE
local numEntries, xpToLevel = 0, 0

local Config = {
	name = "mMT_Dock_Quest",
	localizedName = mMT.DockString .. " " .. QUESTLOG_BUTTON,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function GetQuestInfo(questIndex)
	if E.Retail then
		return C_QuestLog_GetInfo(questIndex)
	else
		local info = {}
		info.title, info.level, info.questTag, info.isHeader, info.isCollapsed, info.isComplete, info.frequency, info.questID, info.startEvent, _, info.isOnMap, info.hasLocalPOI, info.isTask, info.isBounty, info.isStory, info.isHidden, info.isScaling = GetQuestLogTitle(questIndex)
		SelectQuestLogEntry(questIndex)

		return info
	end
end

local function UpdateTooltip()
	DT.tooltip:ClearLines()

	local totalMoney, totalXP, completedXP = 0, 0, 0
	local isShiftDown = IsShiftKeyDown()

	DT.tooltip:AddLine(TRACKER_HEADER_QUESTS)
	DT.tooltip:AddLine(" ")

	for questIndex = 1, numEntries do
		local info = GetQuestInfo(questIndex)
		if info and not info.isHidden and not info.isHeader then
			local xp = GetQuestLogRewardXP(info.questID)
			local money = GetQuestLogRewardMoney(info.questID)
			local isComplete = info.isComplete or E.Retail and _G.C_QuestLog.ReadyForTurnIn(info.questID)

			totalMoney = totalMoney + money
			totalXP = totalXP + xp
			completedXP = completedXP + (isComplete and xp or 0)

			DT.tooltip:AddDoubleLine(info.title, isShiftDown and format("%s (%.2f%%)", BreakUpLargeNumbers(xp), (xp / xpToLevel) * 100) or (isComplete and COMPLETE or INCOMPLETE), 1, 1, 1, isComplete and 0.2 or 1, isComplete and 1 or 0.2, 0.2)
		end
	end

	if completedXP > 0 then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine("Completed XP:", format("%s (%.2f%%)", BreakUpLargeNumbers(completedXP), (completedXP / xpToLevel) * 100), nil, nil, nil, 1, 1, 1)
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine("Total Gold:", E:FormatMoney(totalMoney, "SMART"), nil, nil, nil, 1, 1, 1)
	DT.tooltip:AddDoubleLine("Total XP:", format("%s (%.2f%%)", BreakUpLargeNumbers(totalXP), (totalXP / xpToLevel) * 100), nil, nil, nil, 1, 1, 1)
	DT.tooltip:Show()
end

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		UpdateTooltip()
	end

	mMT:Dock_OnEnter(self, Config)
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.quest.icon]
		Config.icon.color = E.db.mMT.dockdatatext.quest.customcolor and E.db.mMT.dockdatatext.quest.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	numEntries, _ = GetNumQuestLogEntries()
	xpToLevel = UnitXPMax("player")
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		_G.ToggleQuestLog()
	end
end

DT:RegisterDatatext(Config.name, Config.category, { "QUEST_ACCEPTED", "QUEST_REMOVED", "QUEST_TURNED_IN", "QUEST_LOG_UPDATE" }, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
