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
local TitleText = ObjectiveTrackerBlocksFrame.QuestHeader.Text:GetText()

local colorFont = {}
local color = {}
local dim = 0.2
local fontsize = 12

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
		color = E.db.general.backdropfadecolor
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
		color = E.db.general.backdropfadecolor
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
	colorFont = db.font.color
	dim = db.font.highlight
	local colorNormal = colorFont.text.class and mMT.ClassColor or colorFont.text
	local colorHeader = colorFont.header.class and mMT.ClassColor or colorFont.header

	OBJECTIVE_TRACKER_COLOR = {
		["Normal"] = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b },
		["NormalHighlight"] = { r = colorNormal.r - dim, g = colorNormal.g - dim, b = colorNormal.b - dim },
		["Failed"] = { r = colorFont.failed.r, g = colorFont.failed.g, b = colorFont.failed.b },
		["FailedHighlight"] = { r = colorFont.failed.r - dim, g = colorFont.failed.g - dim, b = colorFont.failed.b - dim },
		["Header"] = { r = colorHeader.r, g = colorHeader.g, b = colorHeader.b },
		["HeaderHighlight"] = { r = colorHeader.r - dim, g = colorHeader.g - dim, b = colorHeader.b - dim },
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
	OBJECTIVE_TRACKER_COLOR["Complete"] = OBJECTIVE_TRACKER_COLOR["Complete"]
	OBJECTIVE_TRACKER_COLOR["CompleteHighlight"] = OBJECTIVE_TRACKER_COLOR["Complete"]
end
local function SetHeaderText(text)
	color = db.font.color.header.class and mMT.ClassColor or db.font.color.header
	fontsize = db.font.fontsize.header

	text:SetFont(LSM:Fetch("font", db.font.font), fontsize, db.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)
	text.SetShadowColor = function() end
end

local function SetLineText(text, completed)
	color = completed and db.font.color.complete or (db.font.color.text.class and mMT.ClassColor or db.font.color.text)
	fontsize = db.font.fontsize.text

	text:SetFont(LSM:Fetch("font", db.font.font), fontsize, db.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)
	text.SetShadowColor = function() end

	-- Text Progress
	if not completed then
		local lineText = text:GetText()
		local current, required, questText = strmatch(lineText, "^(%d-)/(%d-) (.+)")
		if not current or not required or not questText then
			questText, current, required = strmatch(lineText, "(.+): (%d-)/(%d-)$")
		end

		if current and required and questText then
			if current == required then
				-- local doneIcon = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga:16:16:0:0:16:16:0:16:0:16"
				-- doneIcon = doneIcon .. ":" .. tostring(mMT:round(db.font.color.good.r * 255)) .. ":" .. tostring(mMT:round(db.font.color.good.g * 255)) .. ":" .. tostring(mMT:round(db.font.color.good.b * 255)) .. "|t"
				lineText = questText
			else
				local progressPercent = mMT:round((tonumber(current) / tonumber(required)) * 100 or 0)

				local colorGood = db.font.color.good
				local colorTransit = db.font.color.transit
				local colorBad = db.font.color.bad
				local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
				local colorProgress = E:RGBToHex(r, g, b)

				lineText = colorProgress .. current .. "/" .. required .. " - " .. progressPercent .. "%|r" .. "  " .. questText
			end
			text:SetText(lineText)
		end
	end

	text:SetWordWrap(true)

	return text:GetHeight()
end

local function SkinObjective(_, block, objectiveKey, text, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)
	--mMT:Print(objectiveKey, block.currentLine.state)
	if block then
		if block.HeaderText then
			SetHeaderText(block.HeaderText)
		end

		if block.currentLine then
			if block.currentLine.Text then
				local height = SetLineText(block.currentLine.Text, block.currentLine.state or (objectiveKey == "QuestComplete"))
				block.currentLine:SetHeight(height)

				text = block.currentLine.Text:GetText()
				if not (adjustForNoText and text == "") then
					block.height = block.height + height / 3
				end
			end
		end

		--mMT:DebugPrintTable(block.currentLine.Check)
	end

	-- local line = _G.DEFAULT_OBJECTIVE_TRACKER_MODULE:GetLine(block, objectiveKey, lineType)

	-- if line.Text then
	-- 	line.Text:SetFont(LSM:Fetch("font", db.font.font), fontsize.text, db.font.fontflag)
	-- 	line.Text:SetTextColor(colorNormal.r, colorNormal.g, colorNormal.b)
	-- end

	-- -- width
	-- if block.lineWidth ~= line.width then
	-- 	line.Text:SetWidth(block.lineWidth or _G.DEFAULT_OBJECTIVE_TRACKER_MODULE.lineWidth)
	-- 	line.width = block.lineWidth
	-- end

	-- -- dash
	-- if line.Dash then
	-- 	if not dashStyle then
	-- 		dashStyle = OBJECTIVE_DASH_STYLE_SHOW
	-- 	end
	-- 	if line.dashStyle ~= dashStyle then
	-- 		if dashStyle == OBJECTIVE_DASH_STYLE_SHOW then
	-- 			line.Dash:Show()
	-- 			line.Dash:SetText(QUEST_DASH)
	-- 		elseif dashStyle == OBJECTIVE_DASH_STYLE_HIDE then
	-- 			line.Dash:Hide()
	-- 			line.Dash:SetText(QUEST_DASH)
	-- 		elseif dashStyle == OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE then
	-- 			line.Dash:Hide()
	-- 			line.Dash:SetText(nil)
	-- 		else
	-- 			error("Invalid dash style: " .. tostring(dashStyle))
	-- 		end
	-- 		line.dashStyle = dashStyle
	-- 	end
	-- end

	-- -- set the text
	-- local textHeight = self:SetStringText(line.Text, text, useFullHeight, colorStyle, block.isHighlighted)
	-- local height = overrideHeight or textHeight
	-- line:SetHeight(height)

	-- local yOffset

	-- if adjustForNoText and text == "" then
	-- 	-- don't change the height
	-- 	-- move the line up so the next object ends up in the same position as if there had been no line
	-- 	yOffset = height
	-- else
	-- 	block.height = block.height + height + block.module.lineSpacing
	-- 	yOffset = -block.module.lineSpacing
	-- end
	-- -- anchor the line
	-- local anchor = block.currentLine or block.HeaderText
	-- if anchor then
	-- 	line:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, yOffset)
	-- else
	-- 	line:SetPoint("TOPLEFT", 0, yOffset)
	-- end
	-- block.currentLine = line
	-- return line
end
local function ApplySkin(block)
	--mMT:DebugPrintTable(block)
	local title = block.Header and block.Header.Text

	-- Header Text
	if title then
		fontsize = db.font.fontsize.title
		color = colorFont.title.class and mMT.ClassColor or colorFont.title

		title:SetFont(LSM:Fetch("font", db.font.font), fontsize, db.font.fontflag)
		title:SetTextColor(color.r, color.g, color.b)
		title.SetShadowColor = function() end

		if db.settings.questcount then
			local QuestCount = ""
			local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
			QuestCount = "[" .. numQuests .. "/" .. maxNumQuestsCanAccept .. "]"
			title:SetText(TitleText .. " " .. QuestCount)
		end
	end

	-- Line Texts/ Objectives
	if block and block.AddObjective and not block.mMT_Skinned then
		hooksecurefunc(block, "AddObjective", SkinObjective)

		--hooksecurefunc(block, "OnEnter", SkinObjective)
		--hooksecurefunc(block, "OnLeave", SkinObjective)
		block.mMT_Skinned = true
	end

	-- local Frame = ObjectiveTrackerFrame.MODULES
	-- if Frame then
	-- 	for i = 1, #Frame do
	-- 		local Modules = Frame[i]
	-- 		if Modules then
	-- 			mSetupHeaderFont(Modules.Header.Text)

	-- 			if not Modules.IsSkinned then
	-- 				if E.db.mMT.objectivetracker.header.barstyle ~= "none" then
	-- 					mCreatBar(Modules.Header)
	-- 				end
	-- 				if not E.db.mMT.objectivetracker.simple then
	-- 					hooksecurefunc(Modules, "AddObjective", SkinOBTText)
	-- 				end
	-- 				Modules.IsSkinned = true
	-- 			end
	-- 		end
	-- 	end
	-- end
end

local function update(a, b, c, d, e, f, g, h)
	mMT:Print(a, b, c, d, e, f, g, h)
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

		-- Skin Text and Headers
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "SetBlockHeader", ApplySkin)

		module.hooked = true
	end

	module.needReloadUI = true
	module.loaded = true
end
