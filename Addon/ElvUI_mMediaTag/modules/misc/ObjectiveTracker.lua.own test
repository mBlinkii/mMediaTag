local E = unpack(ElvUI)
local LSM = E.Libs.LSM
local S = E:GetModule("Skins")

local module = mMT.Modules.ObjectiveTracker
local db = nil
if not module then
	return
end

local questList = {
	story = {},
	quests = {},
}

local frame = CreateFrame("Frame", "mMT-QuestListFrame", UIParent)
frame:SetSize(300, 500) -- Setzen Sie die Größe des Fensters
frame:SetPoint("CENTER") -- Positionieren Sie das Fenster in der Mitte des Bildschirms

-- title
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("TOP", 0, -10)
title:SetText("Questliste")

-- scroll frame
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -30)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

-- text frame
local textFrame = CreateFrame("Frame", nil, scrollFrame)
scrollFrame:SetScrollChild(textFrame)
textFrame:SetSize(scrollFrame:GetSize())

-- text
local text = textFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
text:SetPoint("TOPLEFT")
text:SetJustifyH("LEFT")
text:SetJustifyV("TOP")

local function GetRequirements(text)
	local current, required, questText = strmatch(text, "^(%d-)/(%d-) (.+)")
	if not current or not required or not questText then
		questText, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end
	return current, required, questText
end

-- locallocal questOfferPinData =
-- {
-- 	[Enum.QuestClassification.Normal] = 	{ level = 1, atlas = "QuestNormal", },
-- 	[Enum.QuestClassification.Questline] = 	{ level = 1, atlas = "QuestNormal", },
-- 	[Enum.QuestClassification.Recurring] =	{ level = 2, atlas = "UI-QuestPoiRecurring-QuestBang", },
-- 	[Enum.QuestClassification.Meta] = 		{ level = 3, atlas = "quest-wrapper-available", },
-- 	[Enum.QuestClassification.Calling] = 	{ level = 4, atlas = "Quest-DailyCampaign-Available", },
-- 	[Enum.QuestClassification.Campaign] = 	{ level = 5, atlas = "Quest-Campaign-Available", },
-- 	[Enum.QuestClassification.Legendary] =	{ level = 6, atlas = "UI-QuestPoiLegendary-QuestBang", },
-- 	[Enum.QuestClassification.Important] =	{ level = 7, atlas = "importantavailablequesticon", },
-- };

local function SkinText(lineText)
	local current, required, questText = GetRequirements(lineText)

	if current and required and questText then
		if current == required then
			return "|cff40ff6e" .. questText .. "|r"
		else
			local progressPercent = nil

			local colorGood = { r = 0.25, g = 1, b = 0.43, hex = "|cff40ff6e" }
			local colorTransit = { r = 1, g = 0.63, b = 0.05, hex = "|cffffa10d" }
			local colorBad = { r = 0.92, g = 0.46, b = 0.1, hex = "|cffeb751a" }

			if required ~= "1" then
				progressPercent = (tonumber(current) / tonumber(required)) * 100 or 0
				local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
				local colorProgress = E:RGBToHex(r, g, b)
				progressPercent = format("%.f%%", progressPercent)
				return colorProgress .. current .. "/" .. required .. " - " .. progressPercent .. "|r" .. "  " .. questText
			else
				return "|cffeb751a" .. current .. "/" .. required .. "|r  " .. questText
			end
		end
	else
		return lineText
	end
end

local function UpdateQuestList()
	local quests = ""
	local watchedQuests = {}
	for i = 1, C_QuestLog.GetNumQuestWatches() do
		local questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i)
		if questID then
			watchedQuests[questID] = true
		end
	end

	local isTC = false
	local isTQ = false

	for i = 1, C_QuestLog.GetNumQuestLogEntries() do
		local info = C_QuestLog.GetInfo(i)
		mMT:DebugPrintTable(info)

		if info then
			--	mMT:DebugPrintTable(info)
			if not info.isHeader then
				if info.questID ~= 0 and info.questClassification == Enum.QuestClassification.Campaign then
					if not isTC then
						quests = quests .. "|cff3fd4f2" .. TRACKER_HEADER_CAMPAIGN_QUESTS .. "|r\n" -- #ffc700
						quests = quests .. "-------------------------\n"
						isTC = true
					end

					questList.story[info.questID] = {}

					local objectives = C_QuestLog.GetQuestObjectives(info.questID)
					if objectives then
						if watchedQuests[info.questID] then
							quests = quests .. "|cffffc700" .. info.title .. "|r\n"
						end

						for line, objective in ipairs(objectives) do
							questList.story[info.questID][line] = {
								title = info.title,
								finished = objective.finished,
								progress = objective.percent,
								text = objective.text,
								watchedQuests = watchedQuests[info.questID],
							}
							if questList.story[info.questID][line].watchedQuests then
								quests = quests .. SkinText(questList.story[info.questID][line].text) .. "\n"
							end
						end

						if watchedQuests[info.questID] then
							quests = quests .. "\n"
						end
					end
				else
					if info.questID ~= 0 then
						if not isTQ then
							quests = quests .. "|cff7e3ff2" .. "QUEST" .. "|r\n"
							quests = quests .. "-------------------------\n"
							isTQ = true
						end

						questList.quests[info.questID] = {}

						local objectives = C_QuestLog.GetQuestObjectives(info.questID)
						if objectives then
							if watchedQuests[info.questID] then
								quests = quests .. "|cffffc700" .. info.title .. "|r\n"
							end

							for line, objective in ipairs(objectives) do
								questList.quests[info.questID][line] = {
									title = info.title,
									finished = objective.finished,
									progress = objective.percent,
									text = objective.text,
									watchedQuests = watchedQuests[info.questID],
								}
								if questList.quests[info.questID][line].watchedQuests then
									quests = quests .. SkinText(questList.quests[info.questID][line].text) .. "\n"
								end
							end

							if watchedQuests[info.questID] then
								quests = quests .. "\n"
							end
						end
					end
				end

				--mMT:DebugPrintTable(questList)
			end
		end
	end

	text:SetText(quests)
end
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:SetScript("OnEvent", UpdateQuestList)


UpdateQuestList()

E:CreateMover(
	frame,
	"mMT-QuestListFrame-Mover",
	"mMT-QuestList",
	nil,
	nil,
	nil,
	"ALL,MMEDIATAG",
	nil,
	"mMT,cosmetic,objectivetracker",
	nil
)

function module:Initialize()
	-- prevent bugs with wrong db entries
	if E.db.mMT.objectivetracker.font and not E.db.mMT.objectivetracker.font.font then
		E.db.mMT.objectivetracker.font = {
			font = "PT Sans Narrow",
			fontflag = "NONE",
			highlight = 0.4,
			color = {
				title = { class = false, r = 1, g = 0.78, b = 0, hex = "|cffffc700" },
				header = { class = false, r = 1, g = 0.78, b = 0, hex = "|cffffc700" },
				text = { class = false, r = 0.87, g = 0.87, b = 0.87, hex = "|cff00ffa4" },
				failed = { r = 1, g = 0.16, b = 0, hex = "|cffff2800" },
				complete = { r = 0, g = 1, b = 0.27, hex = "|cff00ff45" },
				good = { r = 0.25, g = 1, b = 0.43, hex = "|cff40ff6e" },
				bad = { r = 0.92, g = 0.46, b = 0.1, hex = "|cffeb751a" },
				transit = { r = 1, g = 0.63, b = 0.05, hex = "|cffffa10d" },
			},
			fontsize = {
				header = 14,
				title = 12,
				text = 12,
			},
		}
	end

	db = E.db.mMT.objectivetracker
	--SetTextColors()
	if not module.hooked then
		-- this hooked wont run?
		-- QuestObjectiveTrackerMixin
		-- hooksecurefunc(_G.ObjectiveTrackerBlockMixin, "AddObjective", AddObjective)

		--mMT:DebugPrintTable(ObjectiveTrackerBlockMixin)
		-- hooksecurefunc(_G.ObjectiveTrackerBlockMixin, "AddObjective", AddObjective)

		-- if ObjectiveTrackerFrame and ObjectiveTrackerFrame.modules then
		-- 	for _, m in pairs(ObjectiveTrackerFrame.modules) do
		-- 		hooksecurefunc(m, "AddBlock", AddBlock)
		-- 	end
		-- end
	end

	module.needReloadUI = true
	module.loaded = true
end
