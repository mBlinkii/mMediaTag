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

local function SetTextColors()
	local colorFont = db.font.color
	local normal = colorFont.text.class and mMT.ClassColor or colorFont.text
	local header = colorFont.header.class and mMT.ClassColor or colorFont.header
	local dim = db.font.highlight

	OBJECTIVE_TRACKER_COLOR = {
		["Normal"] = { r = normal.r, g = normal.g, b = normal.b },
		["NormalHighlight"] = { r = normal.r - dim, g = normal.g - dim, b = normal.b - dim },
		["Failed"] = { r = colorFont.failed.r, g = colorFont.failed.g, b = colorFont.failed.b },
		["FailedHighlight"] = { r = colorFont.failed.r - dim, g = colorFont.failed.g - dim, b = colorFont.failed.b - dim },
		["Header"] = { r = header.r, g = header.g, b = header.b },
		["HeaderHighlight"] = { r = header.r - dim, g = header.g - dim, b = header.b - dim },
		["Complete"] = { r = colorFont.complete.r, g = colorFont.complete.g, b = colorFont.complete.b },
		["CompleteHighlight"] = { r = colorFont.complete.r - dim, g = colorFont.complete.g - dim, b = colorFont.complete.b - dim },
		["TimeLeft"] = { r = colorFont.failed.r, g = colorFont.failed.g, b = colorFont.failed.b },
		["TimeLeftHighlight"] = { r = colorFont.failed.r - dim, g = colorFont.failed.g - dim, b = colorFont.failed.b - dim },
	}
	OBJECTIVE_TRACKER_COLOR["Normal"].reverse = OBJECTIVE_TRACKER_COLOR["NormalHighlight"]
	OBJECTIVE_TRACKER_COLOR["NormalHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Normal"]
	OBJECTIVE_TRACKER_COLOR["Failed"].reverse = OBJECTIVE_TRACKER_COLOR["FailedHighlight"]
	OBJECTIVE_TRACKER_COLOR["FailedHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Failed"]
	OBJECTIVE_TRACKER_COLOR["Header"].reverse = OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]
	OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Header"]
	OBJECTIVE_TRACKER_COLOR["TimeLeft"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"]
	OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeft"]
	OBJECTIVE_TRACKER_COLOR["Complete"] = OBJECTIVE_TRACKER_COLOR["CompleteHighlight"]
	OBJECTIVE_TRACKER_COLOR["CompleteHighlight"] = OBJECTIVE_TRACKER_COLOR["Complete"]
end

function module:Initialize()
	db = E.db.mMT.objectivetracker

	SetTextColors()

	if not module.hooked then
		-- Bar Skins
		hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Bonus Objective Progress Bar
		hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: World Quest Progress Bar
		hooksecurefunc(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Quest Progress Bar
		hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Scenario Progress Bar
		hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Campaign Progress Bar
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: Quest Progress Bar
		hooksecurefunc(_G.UI_WIDGET_TRACKER_MODULE, "AddProgressBar", SkinProgressBars) --[Skin]: New DF Quest Progress Bar

		-- Timer Bar Skins
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "AddTimerBar", SkinTimerBars) --[Skin]: Quest Timer Bar
		hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, "AddTimerBar", SkinTimerBars) --[Skin]: Scenario Timer Bar
		hooksecurefunc(_G.ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", SkinTimerBars) --[Skin]: Achievement Timer Bar

		module.hooked = true

		-- local minimize = _G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
		-- minimize:StripTextures(nil, true)
		-- minimize:Size(16)
		-- minimize:SetHighlightTexture(130837, 'ADD') -- Interface/Buttons/UI-PlusButton-Hilight
		-- minimize.tex = minimize:CreateTexture(nil, 'OVERLAY')
		-- minimize.tex:SetTexture(E.Media.Textures.MinusButton)
		-- minimize.tex:SetInside()

		-- for _, header in pairs(headers) do
		-- 	local button = header.MinimizeButton
		-- 	if button then
		-- 		button:GetNormalTexture():SetAlpha(0)
		-- 		button:GetPushedTexture():SetAlpha(0)

		-- 		button.tex = button:CreateTexture(nil, "OVERLAY")
		-- 		button.tex:SetTexture(E.Media.Textures.MinusButton)
		-- 		button.tex:SetInside()

		-- 		hooksecurefunc(button, "SetCollapsed", UpdateMinimizeButton)
		-- 	end
		-- end
	end

	module.needReloadUI = true
	module.loaded = true
end
