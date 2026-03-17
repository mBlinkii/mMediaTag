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

local acceptQueue = {}
local turnInQueue = {}
local processingAccept = false
local processingTurnIn = false

local function ChatMsg(msg)
	mMT:Print(msg)
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
	if module.skip_in_combat and InCombatLockdown() then return end
	if IsShiftKeyDown() then
		if module.chat_message then ChatMsg(L["[AutoQuest] Auto-accept paused (SHIFT held)."]) end
		return
	end
	if not C_GossipInfo then return end

	local available = C_GossipInfo.GetAvailableQuests()
	if not available or #available == 0 then return end

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
	if module.skip_in_combat and InCombatLockdown() then return end
	if IsShiftKeyDown() then
		if module.chat_message then ChatMsg(L["[AutoQuest] Auto-turn-in paused (SHIFT held)."]) end
		return
	end
	if not C_GossipInfo then return end

	local active = C_GossipInfo.GetActiveQuests()
	if not active or #active == 0 then return end

	for _, quest in ipairs(active) do
		if quest.isComplete then table.insert(turnInQueue, { questID = quest.questID, title = quest.title or "" }) end
	end

	if not processingTurnIn then ProcessNextTurnIn() end
end

local function TryAcceptQuest()
	if not module.auto_accept then return end
	if module.skip_in_combat and InCombatLockdown() then return end
	if IsShiftKeyDown() then
		if module.chat_message then ChatMsg(L["[AutoQuest] Auto-accept paused (SHIFT held)."]) end
		return
	end

	if QuestFrameAcceptButton and QuestFrameAcceptButton:IsShown() then
		if not QuestGetAutoAccept() then
			local title = GetTitleText and GetTitleText() or ""
			AcceptQuest()
			if module.chat_message then ChatMsg(format(L["[AutoQuest] Quest accepted: %s"], title)) end
		end
	end
end

local function TryCompleteTurnIn()
	if not module.auto_turnin then return end
	if module.skip_in_combat and InCombatLockdown() then return end
	if IsShiftKeyDown() then
		if module.chat_message then ChatMsg(L["[AutoQuest] Auto-turn-in paused (SHIFT held)."]) end
		return
	end

	if not (QuestFrameCompleteQuestButton and QuestFrameCompleteQuestButton:IsShown()) then return end
	if not IsQuestCompletable() then return end

	local numChoices = GetNumQuestChoices()
	if numChoices > 1 then
		processingTurnIn = false
		return
	end

	local title = GetTitleText and GetTitleText() or ""
	CompleteQuest()
	if numChoices == 1 then GetQuestReward(1) end
	if module.chat_message then ChatMsg(format(L["[AutoQuest] Quest turned in: %s"], title)) end
end

function module:QUEST_GREETING()
	BuildAcceptQueue()
	BuildTurnInQueue()
end

function module:GOSSIP_SHOW()
	BuildAcceptQueue()
	BuildTurnInQueue()
end

function module:QUEST_DETAIL()
	TryAcceptQuest()
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
	module:RegisterEvent("QUEST_COMPLETE")
	module:RegisterEvent("QUEST_ACCEPTED")
	module:RegisterEvent("QUEST_TURNED_IN")
	module:RegisterEvent("GOSSIP_SHOW")
	module:RegisterEvent("GOSSIP_CLOSED")
end
