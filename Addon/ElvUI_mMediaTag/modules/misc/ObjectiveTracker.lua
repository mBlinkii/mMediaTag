local E = unpack(ElvUI)
local LSM = E.Libs.LSM

local module = mMT.Modules.ObjectiveTracker
local db = E.db.mMT.objectivetracker
if not module then
	return
end

local _G = _G
local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
local ObjectiveTrackerBlocksFrame = _G.ObjectiveTrackerBlocksFrame
local maxNumQuestsCanAccept = min(C_QuestLog.GetMaxNumQuestsCanAccept() + (E.Retail and 10 or 0), 35) -- 20 for ERA, 25 for WotLK, 35 for Retail

local headers = {
	_G.ObjectiveTrackerBlocksFrame.QuestHeader,
	_G.ObjectiveTrackerBlocksFrame.AchievementHeader,
	_G.ObjectiveTrackerBlocksFrame.ScenarioHeader,
	_G.ObjectiveTrackerBlocksFrame.CampaignQuestHeader,
	_G.ObjectiveTrackerBlocksFrame.ProfessionHeader,
	_G.ObjectiveTrackerBlocksFrame.MonthlyActivitiesHeader,
	_G.ObjectiveTrackerBlocksFrame.AdventureHeader,
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header,
	_G.WORLD_QUEST_TRACKER_MODULE.Header,
	_G.ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader,
}

local function SetTextColors()
	local mQuestFontColor = E.db.mMT.objectivetracker.text.fontcolor
	local mQuestCompleteFontColor = E.db.mMT.objectivetracker.text.completecolor
	local mQuestFailedFontColor = E.db.mMT.objectivetracker.text.failedcolor
	local mTitelFontColor = E.db.mMT.objectivetracker.title.fontcolor

	if E.db.mMT.objectivetracker.text.fontcolorstyle == "class" then
		mQuestFontColor = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
	end

	if E.db.mMT.objectivetracker.title.fontcolorstyle == "class" then
		mTitelFontColor = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
	end

	OBJECTIVE_TRACKER_COLOR = {
		["Normal"] = { r = mQuestFontColor.r, g = mQuestFontColor.g, b = mQuestFontColor.b },
		["NormalHighlight"] = { r = mQuestFontColor.r + 0.2, g = mQuestFontColor.g + 0.2, b = mQuestFontColor.b + 0.2 },
		["Failed"] = { r = mQuestFailedFontColor.r, g = mQuestFailedFontColor.g, b = mQuestFailedFontColor.b },
		["FailedHighlight"] = {
			r = mQuestFailedFontColor.r + 0.2,
			g = mQuestFailedFontColor.g + 0.2,
			b = mQuestFailedFontColor.b + 0.2,
		},
		["Header"] = { r = mTitelFontColor.r, g = mTitelFontColor.g, b = mTitelFontColor.b },
		["HeaderHighlight"] = { r = mTitelFontColor.r + 0.2, g = mTitelFontColor.g + 0.2, b = mTitelFontColor.b + 0.2 },
		["Complete"] = { r = mQuestCompleteFontColor.r, g = mQuestCompleteFontColor.g, b = mQuestCompleteFontColor.b },
		["TimeLeft"] = { r = DIM_RED_FONT_COLOR.r, g = DIM_RED_FONT_COLOR.g, b = DIM_RED_FONT_COLOR.b },
		["TimeLeftHighlight"] = { r = RED_FONT_COLOR.r, g = RED_FONT_COLOR.g, b = RED_FONT_COLOR.b },
	}
	OBJECTIVE_TRACKER_COLOR["Normal"].reverse = OBJECTIVE_TRACKER_COLOR["NormalHighlight"]
	OBJECTIVE_TRACKER_COLOR["NormalHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Normal"]
	OBJECTIVE_TRACKER_COLOR["Failed"].reverse = OBJECTIVE_TRACKER_COLOR["FailedHighlight"]
	OBJECTIVE_TRACKER_COLOR["FailedHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Failed"]
	OBJECTIVE_TRACKER_COLOR["Header"].reverse = OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]
	OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Header"]
	OBJECTIVE_TRACKER_COLOR["TimeLeft"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"]
	OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeft"]
	OBJECTIVE_TRACKER_COLOR["Complete"] = OBJECTIVE_TRACKER_COLOR["Complete"]
	OBJECTIVE_TRACKER_COLOR["CompleteHighlight"] = OBJECTIVE_TRACKER_COLOR["Complete"]
end

local function SkinProgressBars(_, _, line)
	local progressBar = line and line.ProgressBar
	local bar = progressBar and progressBar.Bar
	if not bar then
		return
	end

	db = E.db.mMT.objectivetracker
	local dbBar = E.db.mMT.objectivetracker.bar
	local label = bar.Label

	bar:Height(dbBar.hight)

	if dbBar.transparent then
		local color = E.db.general.backdropfadecolor
		bar.backdrop:SetBackdropColor(color.r, color.g, color.b, color.a)
	end

	if label then
		label:ClearAllPoints()
		label:SetJustifyH(dbBar.fontpoint)
		label:Point(dbBar.fontpoint, bar, dbBar.fontpoint, dbBar.fontpoint == "LEFT" and 2 or (dbBar.fontpoint == "RIGHT" and -2 or 0), 0)
		label:FontTemplate(nil, dbBar.fontsize, db.fontflag)
	end
end

local function SkinTimerBars(_, _, line)
	local timerBar = line and line.TimerBar
	local bar = timerBar and timerBar.Bar

	if not timerBar.isSkinned then
		bar:Height(18)
		bar:StripTextures()
		bar:CreateBackdrop("Transparent")
		bar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(bar)

		timerBar.isSkinned = true
	end
end

function module:Initialize()
	db = E.db.mMT.objectivetracker

	SetTextColors()

	if not module.hooked then
		hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Bonus Objective Progress Bar
		hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: World Quest Progress Bar
		hooksecurefunc(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Quest Progress Bar
		hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Scenario Progress Bar
		hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Campaign Progress Bar
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Quest Progress Bar
		hooksecurefunc(_G.UI_WIDGET_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: New DF Quest Progress Bar

		module.hooked = true

		-- local minimize = _G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
		-- minimize:StripTextures(nil, true)
		-- minimize:Size(16)
		-- minimize:SetHighlightTexture(130837, 'ADD') -- Interface/Buttons/UI-PlusButton-Hilight
		-- minimize.tex = minimize:CreateTexture(nil, 'OVERLAY')
		-- minimize.tex:SetTexture(E.Media.Textures.MinusButton)
		-- minimize.tex:SetInside()

		-- hooksecurefunc('ObjectiveTracker_Expand',TrackerStateChanged)
		-- hooksecurefunc('ObjectiveTracker_Collapse',TrackerStateChanged)
		-- hooksecurefunc('QuestObjectiveSetupBlockButton_Item', HandleItemButton)
		-- hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, 'AddObjective', HandleItemButton)
		-- hooksecurefunc('BonusObjectiveTrackerProgressBar_SetValue',ColorProgressBars)			--[Color]: Bonus Objective Progress Bar
		-- hooksecurefunc('ObjectiveTrackerProgressBar_SetValue',ColorProgressBars)				--[Color]: Quest Progress Bar
		-- hooksecurefunc('ScenarioTrackerProgressBar_SetValue',ColorProgressBars)					--[Color]: Scenario Progress Bar
		-- hooksecurefunc('QuestObjectiveSetupBlockButton_AddRightButton',PositionFindGroupButton)	--[Move]: The eye & quest item to the left of the eye
		-- hooksecurefunc('ObjectiveTracker_CheckAndHideHeader',SkinOjectiveTrackerHeaders)		--[Skin]: Module Headers
		-- hooksecurefunc('QuestObjectiveSetupBlockButton_FindGroup',SkinFindGroupButton)			--[Skin]: The eye

		-- hooksecurefunc(_G.QUEST_TRACKER_MODULE,'AddTimerBar',SkinTimerBars)						--[Skin]: Quest Timer Bar
		-- hooksecurefunc(_G.SCENARIO_TRACKER_MODULE,'AddTimerBar',SkinTimerBars)					--[Skin]: Scenario Timer Bar
		-- hooksecurefunc(_G.ACHIEVEMENT_TRACKER_MODULE,'AddTimerBar',SkinTimerBars)				--[Skin]: Achievement Timer Bar

		-- for _, header in pairs(headers) do
		-- 	local button = header.MinimizeButton
		-- 	if button then
		-- 		button:GetNormalTexture():SetAlpha(0)
		-- 		button:GetPushedTexture():SetAlpha(0)

		-- 		button.tex = button:CreateTexture(nil, 'OVERLAY')
		-- 		button.tex:SetTexture(E.Media.Textures.MinusButton)
		-- 		button.tex:SetInside()

		-- 		hooksecurefunc(button, 'SetCollapsed', UpdateMinimizeButton)
		-- 	end
		-- end
	end

	module.needReloadUI = true
	module.loaded = true
end
