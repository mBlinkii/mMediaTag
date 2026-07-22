local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AutoQuest", { "AceEvent-3.0" })

-- Cache WoW Globals
local format = format
local ipairs = ipairs
local InCombatLockdown = InCombatLockdown
local AcceptQuest = AcceptQuest
local CompleteQuest = CompleteQuest
local GetQuestReward = GetQuestReward
local GetNumQuestChoices = GetNumQuestChoices
local IsQuestCompletable = IsQuestCompletable
local QuestGetAutoAccept = QuestGetAutoAccept
local IsShiftKeyDown = IsShiftKeyDown
local GetNumActiveQuests = GetNumActiveQuests
local GetNumAvailableQuests = GetNumAvailableQuests
local GetActiveTitle = GetActiveTitle
local SelectActiveQuest = SelectActiveQuest
local SelectAvailableQuest = SelectAvailableQuest
local wipe = wipe

local acceptQueue = {}
local turnInQueue = {}
local processingAccept = false
local processingTurnIn = false

local function ChatMsg(msg)
	mMT:Print(msg)
end

-- shared guard: combat skip (silent) and SHIFT pause (with message)
local function IsPaused(pauseMsg)
	if module.skip_in_combat and InCombatLockdown() then return true end
	if IsShiftKeyDown() then
		if module.chat_message and pauseMsg then ChatMsg(pauseMsg) end
		return true
	end
	return false
end

local function ProcessNextAccept()
	if #acceptQueue == 0 then
		processingAccept = false
		return
	end
	if IsShiftKeyDown() then
		acceptQueue = {}
		processingAccept = false
		if module.chat_message then ChatMsg(L["[AutoQuest] Auto-accept paused (SHIFT held)."]) end
		return
	end
	processingAccept = true
	local entry = table.remove(acceptQueue, 1)
	if C_GossipInfo then C_GossipInfo.SelectAvailableQuest(entry.questID) end
end

local function BuildAcceptQueue()
	if not module.auto_accept then return end
	if IsPaused(L["[AutoQuest] Auto-accept paused (SHIFT held)."]) then return end
	if not C_GossipInfo then return end

	local available = C_GossipInfo.GetAvailableQuests()
	if not available or #available == 0 then return end

	-- rebuild from scratch - GOSSIP_SHOW refires after every accept/turn-in
	-- and appending would create duplicates
	wipe(acceptQueue)
	for _, quest in ipairs(available) do
		table.insert(acceptQueue, { questID = quest.questID, title = quest.title or "" })
	end

	if not processingAccept then ProcessNextAccept() end
end

local function ProcessNextTurnIn()
	if #turnInQueue == 0 then
		processingTurnIn = false
		return
	end
	if IsShiftKeyDown() then
		turnInQueue = {}
		processingTurnIn = false
		if module.chat_message then ChatMsg(L["[AutoQuest] Auto-turn-in paused (SHIFT held)."]) end
		return
	end
	processingTurnIn = true
	local entry = table.remove(turnInQueue, 1)
	if C_GossipInfo then C_GossipInfo.SelectActiveQuest(entry.questID) end
end

local function BuildTurnInQueue()
	if not module.auto_turnin then return end
	if IsPaused(L["[AutoQuest] Auto-turn-in paused (SHIFT held)."]) then return end
	if not C_GossipInfo then return end

	local active = C_GossipInfo.GetActiveQuests()
	if not active or #active == 0 then return end

	-- rebuild from scratch (see BuildAcceptQueue)
	wipe(turnInQueue)
	for _, quest in ipairs(active) do
		if quest.isComplete then table.insert(turnInQueue, { questID = quest.questID, title = quest.title or "" }) end
	end

	if not processingTurnIn then ProcessNextTurnIn() end
end

local function TryAcceptQuest()
	if not module.auto_accept then return end
	if IsPaused(L["[AutoQuest] Auto-accept paused (SHIFT held)."]) then return end

	if QuestFrameAcceptButton and QuestFrameAcceptButton:IsShown() then
		if not QuestGetAutoAccept() then
			local title = GetTitleText and GetTitleText() or ""
			AcceptQuest()
			if module.chat_message then ChatMsg(format(L["[AutoQuest] Quest accepted: %s"], title)) end
		end
	end
end

-- QUEST_PROGRESS: the requirements dialog shown before the reward window
-- for some quests - equivalent to clicking "Continue"
local function TryContinueProgress()
	if not module.auto_turnin then return end
	if IsPaused(L["[AutoQuest] Auto-turn-in paused (SHIFT held)."]) then return end

	if IsQuestCompletable() then CompleteQuest() end
end

-- QUEST_COMPLETE: the reward window - take the reward and finish the turn-in
local function TryCompleteTurnIn()
	if not module.auto_turnin then return end
	if IsPaused(L["[AutoQuest] Auto-turn-in paused (SHIFT held)."]) then return end

	local numChoices = GetNumQuestChoices()
	if numChoices > 1 then
		-- multiple reward choices - let the user pick manually
		processingTurnIn = false
		return
	end

	local title = GetTitleText and GetTitleText() or ""
	GetQuestReward(numChoices == 1 and 1 or 0)
	if module.chat_message then ChatMsg(format(L["[AutoQuest] Quest turned in: %s"], title)) end
end

-- The classic greeting frame (QUEST_GREETING) is index-based and does NOT go
-- through C_GossipInfo - its quest lists are only reachable via the global
-- GetNumActiveQuests/GetActiveTitle/Select*Quest(index) API. Only one quest is
-- selected per event: after each turn-in/accept the greeting fires again with
-- updated indices, so the remaining quests are processed one at a time.
function module:QUEST_GREETING()
	if not (module.auto_accept or module.auto_turnin) then return end
	if IsPaused(L["[AutoQuest] Auto-turn-in paused (SHIFT held)."]) then return end

	-- turn-ins first
	if module.auto_turnin then
		for i = 1, (GetNumActiveQuests() or 0) do
			local _, isComplete = GetActiveTitle(i)
			if isComplete then
				SelectActiveQuest(i)
				return
			end
		end
	end

	if module.auto_accept and (GetNumAvailableQuests() or 0) > 0 then SelectAvailableQuest(1) end
end

function module:GOSSIP_SHOW()
	BuildAcceptQueue()
	BuildTurnInQueue()
end

function module:QUEST_DETAIL()
	TryAcceptQuest()
end

function module:QUEST_PROGRESS()
	TryContinueProgress()
end

function module:QUEST_COMPLETE()
	TryCompleteTurnIn()
end

function module:QUEST_ACCEPTED()
	if processingAccept then C_Timer.After(0.05, ProcessNextAccept) end
end

function module:QUEST_TURNED_IN()
	if processingTurnIn then C_Timer.After(0.05, ProcessNextTurnIn) end
end

function module:GOSSIP_CLOSED()
	acceptQueue = {}
	turnInQueue = {}
	processingAccept = false
	processingTurnIn = false
end

function module:Initialize()
	acceptQueue = {}
	turnInQueue = {}
	processingAccept = false
	processingTurnIn = false

	if not E.db.mMediaTag.auto_quest.enable then
		module:UnregisterAllEvents()
		return
	end

	module.auto_accept = E.db.mMediaTag.auto_quest.auto_accept
	module.auto_turnin = E.db.mMediaTag.auto_quest.auto_turnin
	module.skip_in_combat = E.db.mMediaTag.auto_quest.skip_in_combat
	module.chat_message = E.db.mMediaTag.auto_quest.chat_message

	module:RegisterEvent("QUEST_GREETING")
	module:RegisterEvent("QUEST_DETAIL")
	module:RegisterEvent("QUEST_PROGRESS")
	module:RegisterEvent("QUEST_COMPLETE")
	module:RegisterEvent("QUEST_ACCEPTED")
	module:RegisterEvent("QUEST_TURNED_IN")
	module:RegisterEvent("GOSSIP_SHOW")
	module:RegisterEvent("GOSSIP_CLOSED")
end
