local E = unpack(ElvUI)
local LSM = E.Libs.LSM
local S = E:GetModule("Skins")

local module = mMT.Modules.ObjectiveTracker

if not module then
	return
end

local _G = _G
local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
local maxNumQuestsCanAccept = min(C_QuestLog.GetMaxNumQuestsCanAccept() + (E.Retail and 10 or 0), 35) -- 20 for ERA, 25 for WotLK, 35 for Retail
local IsInInstance = IsInInstance
local SortQuestWatches = C_QuestLog.SortQuestWatches

local colorFont = {}
local color = {}
local dim = 0.2
local fontsize = 12

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

-- get quest infos

-- skin progress/ timer bars
local function SkinBarColor(Bar, r, g, b)
	if Bar then
		if E.db.mMT.objectivetracker.bar.elvbg then
			local color_barBG = E.db.general.backdropfadecolor
			Bar.backdrop:SetBackdropColor(color_barBG.r, color_barBG.g, color_barBG.b, color_barBG.a)
		end

		if E.db.mMT.objectivetracker.bar.gradient then
			Bar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = r - 0.2, g = g - 0.2, b = b - 0.2, a = 1 }, { r = r + 0.2, g = g + 0.2, b = b + 0.2, a = 1 })
		end
	end
end

-- skin progress/ timer bars
local function SetUpBars(bar)
	-- bar text
	local label = bar.Label

	-- bar height
	bar:Height(E.db.mMT.objectivetracker.bar.hight)

	-- bg color
	if E.db.mMT.objectivetracker.bar.elvbg and bar.backdrop then
		local color_barBG = E.db.general.backdropfadecolor
		bar.backdrop:SetBackdropColor(color_barBG.r, color_barBG.g, color_barBG.b, color_barBG.a)
	end

	-- gradient bar color
	if E.db.mMT.objectivetracker.bar.gradient and not bar.mMT_hooked then
		hooksecurefunc(bar, "SetStatusBarColor", SkinBarColor)
		bar.mMT_hooked = true
	end

	-- setup bar text
	if label then
		label:ClearAllPoints()
		label:SetJustifyH(E.db.mMT.objectivetracker.bar.fontpoint)
		label:Point(E.db.mMT.objectivetracker.bar.fontpoint, bar, E.db.mMT.objectivetracker.bar.fontpoint, E.db.mMT.objectivetracker.bar.fontpoint == "LEFT" and 2 or (E.db.mMT.objectivetracker.bar.fontpoint == "RIGHT" and -2 or 0), 0)
		label:FontTemplate(nil, E.db.mMT.objectivetracker.bar.fontsize, E.db.mMT.objectivetracker.fontflag)
	end

	-- bar shadow
	if E.db.mMT.objectivetracker.bar.shadow and not bar.mMT_Shadow then
		bar:CreateShadow()
		bar.mMT_Shadow = true
	end
end

-- skin progress/ timer bars
local function SkinBarSetValue(self)
	local bar = self and self.Bar
	if not bar then
		return
	end

	SetUpBars(self.Bar)
end

local function SkinProgressBars(_, _, line)
	local progressBar = line and line.ProgressBar
	local bar = progressBar and progressBar.Bar
	if not bar then
		return
	end

	SetUpBars(bar)
end

local function SkinTimerBars(_, _, line)
	local timerBar = line and line.TimerBar
	local bar = timerBar and timerBar.Bar
	if not bar then
		return
	end

	SetUpBars(bar)
end

--line text settings

-- line text for dungeons
local function SetDungeonLineText(text, criteriaString, current, required, complete)
	local lineText = nil
	if criteriaString then
		color = E.db.mMT.objectivetracker.font.color.text.class and mMT.ClassColor or E.db.mMT.objectivetracker.font.color.text

		if complete then
			color = E.db.mMT.objectivetracker.font.color.complete

			lineText = color.hex .. criteriaString .. "|r"
		else
			if current and required then
				lineText = E.db.mMT.objectivetracker.font.color.bad.hex .. current .. "/" .. required .. "|r" .. "  " .. criteriaString
			elseif current then
				lineText = E.db.mMT.objectivetracker.font.color.bad.hex .. current .. "%|r" .. "  " .. criteriaString
			else
				lineText = E.db.mMT.objectivetracker.font.color.bad.hex .. criteriaString
			end
		end

		fontsize = E.db.mMT.objectivetracker.font.fontsize.text

		text:SetFont(LSM:Fetch("font", E.db.mMT.objectivetracker.font.font), fontsize, E.db.mMT.objectivetracker.font.fontflag)
		text:SetTextColor(color.r, color.g, color.b)

		text:SetText(lineText)
		text:SetWordWrap(true)

		return text:GetStringHeight()
	end
end

local function SkinDungeonsUpdateCriteria(_, numCriteria, block)
	if block then
		for criteriaIndex = 1, numCriteria do
			local existingLine = block.lines[criteriaIndex]
			local criteriaString, _, completed, quantity, totalQuantity, _, _, _, criteriaID, _, _, _, _ = C_Scenario.GetCriteriaInfo(criteriaIndex)
			if existingLine then
				local text = existingLine.Text

				if text then
					local height = SetDungeonLineText(text, criteriaString, quantity, (criteriaID ~= 0) and totalQuantity or nil, (completed or existingLine.completed))

					-- set text/ line height
					if height and height ~= text:GetHeight() then
						text:SetHeight(height)
					end
				end

				-- done icon and dash
				local icon = existingLine.Icon

				if icon then
					if E.db.mMT.objectivetracker.dungeon.hidedash then
						icon:Hide()
					else
						icon:Show()
						if existingLine.completed then
							icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
							icon:SetVertexColor(E.db.mMT.objectivetracker.font.color.complete.r, E.db.mMT.objectivetracker.font.color.complete.g, E.db.mMT.objectivetracker.font.color.complete.b, 1)
						else
							icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questMinus.tga")
							icon:SetVertexColor(mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, 1)
						end
					end
				end
			end
		end
	end
end

-- skin m+ stage block and time
local function SkinChallengeModeTime(block, elapsedTime)
	-- get dungeon time limits
	if not block.mMT_Timers then
		block.mMT_Timers = {}
		block.mMT_Timers.chest3 = block.timeLimit * 0.6
		block.mMT_Timers.chest2 = block.timeLimit * 0.8
	end

	-- timer bar color
	local colorA = E.db.mMT.objectivetracker.dungeon.color.chest1.a
	local colorB = E.db.mMT.objectivetracker.dungeon.color.chest1.b

	if elapsedTime < block.mMT_Timers.chest3 then
		colorA = E.db.mMT.objectivetracker.dungeon.color.chest3.a
		colorB = E.db.mMT.objectivetracker.dungeon.color.chest3.b
	elseif elapsedTime < block.mMT_Timers.chest2 then
		colorA = E.db.mMT.objectivetracker.dungeon.color.chest2.a
		colorB = E.db.mMT.objectivetracker.dungeon.color.chest2.b
	else
		colorA = E.db.mMT.objectivetracker.dungeon.color.chest1.a
		colorB = E.db.mMT.objectivetracker.dungeon.color.chest1.b
	end

	block.StatusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = colorA.r, g = colorA.g, b = colorA.b, a = colorA.a }, { r = colorB.r, g = colorB.g, b = colorB.b, a = colorB.a })

	-- create and set time limit markers
	if not block.timerMarker then
		local width = block.StatusBar:GetWidth()
		local height = block.StatusBar:GetHeight()
		local timerMarker = CreateFrame("Frame", nil, block)
		timerMarker:SetAllPoints(block)

		timerMarker.chest3 = timerMarker:CreateTexture(nil, "OVERLAY")
		timerMarker.chest3:SetColorTexture(1, 1, 1)
		timerMarker.chest3:SetSize(2, height) --block.StatusBar:GetHeight())

		timerMarker.chest2 = timerMarker:CreateTexture(nil, "OVERLAY")
		timerMarker.chest2:SetColorTexture(1, 1, 1)
		timerMarker.chest2:SetSize(2, height) --block.StatusBar:GetHeight())

		timerMarker.chest3:SetPoint("LEFT", block.StatusBar, "LEFT", width - (width * block.mMT_Timers.chest3 / block.timeLimit), 0)
		timerMarker.chest2:SetPoint("LEFT", block.StatusBar, "LEFT", width - (width * block.mMT_Timers.chest2 / block.timeLimit), 0)
		timerMarker.chest3:Show()
		timerMarker.chest2:Show()

		timerMarker:Show()

		block.timerMarker = timerMarker
	end

	-- create and add time for current chest or over time
	if not block.mMT_Time then
		local timeLable = block.StatusBar:CreateFontString(nil, "OVERLAY")
		timeLable:FontTemplate(nil, E.db.mMT.objectivetracker.font.fontsize.title, E.db.mMT.objectivetracker.font.fontflag)
		timeLable:SetFont(LSM:Fetch("font", E.db.mMT.objectivetracker.font.font), E.db.mMT.objectivetracker.font.fontsize.title, E.db.mMT.objectivetracker.font.fontflag)
		timeLable:SetPoint("RIGHT", block.StatusBar, "RIGHT", -4, 0)
		timeLable:SetJustifyH("RIGHT")
		timeLable:SetJustifyV("TOP")
		block.mMT_Time = timeLable
	end

	local timeText = nil

	-- get time limits and set it to ta label
	if elapsedTime < block.mMT_Timers.chest3 then
		timeText = "+3 " .. SecondsToClock(block.mMT_Timers.chest3 - elapsedTime)
	elseif elapsedTime < block.mMT_Timers.chest2 then
		timeText = "+2 " .. SecondsToClock(block.mMT_Timers.chest2 - elapsedTime)
	elseif elapsedTime > block.timeLimit then
		timeText = E.db.mMT.objectivetracker.font.color.bad.hex .. "+ " .. SecondsToClock(elapsedTime - block.timeLimit) .. "|r"
		block.TimeLeft:SetText(E.db.mMT.objectivetracker.font.color.bad.hex .. SecondsToClock(elapsedTime) .. "|r")
	else
		timeText = ""
	end

	if timeText then
		block.mMT_Time:SetText(timeText)
	end
end

-- check if m+ is active
local function isChallengeModeActive()
	return C_MythicPlus.IsMythicPlusActive() and C_ChallengeMode.GetActiveChallengeMapID()
end

--skin stage block
function SkinStageBlock()
	local isChallengeMode = isChallengeModeActive()
	local StageBlock = isChallengeMode and _G.ScenarioChallengeModeBlock or _G.ScenarioStageBlock

	if not isChallengeMode then
		-- Hide Dungeon Frame Block
		StageBlock.NormalBG:Hide()
		StageBlock.FinalBG:Hide()

		-- Hide Open world Scenario Block
		local container = StageBlock.WidgetContainer
		if container and container.widgetFrames then
			for _, widgetFrame in pairs(container.widgetFrames) do
				if widgetFrame.Frame then
					widgetFrame.Frame:Hide()
				end
			end
		end
	end

	-- replace the level text with keystone level of the dungeon
	if isChallengeMode then
		StageBlock.Level:SetText(mMT:GetDungeonInfo(false, true, true))
	end

	-- create stage block bg
	if not StageBlock.mMT_StageBlock then
		local mMT_StageBlock = CreateFrame("Frame", "mMT_StageBlock")
		local width = ObjectiveTrackerFrame:GetWidth()
		S:HandleFrame(mMT_StageBlock)

		mMT_StageBlock:SetParent(StageBlock)
		mMT_StageBlock:ClearAllPoints()
		mMT_StageBlock:SetPoint("TOPLEFT", 10, -5)

		mMT_StageBlock:SetSize(width, 80)
		mMT_StageBlock:SetFrameLevel(3)
		mMT_StageBlock:Show()

		if E.db.mMT.objectivetracker.dungeon.shadow then
			mMT_StageBlock:CreateShadow()
		end

		-- create difficulty label to dungeon stage block if not m+
		if not mMT_StageBlock.Difficulty and not isChallengeMode then
			local label = mMT_StageBlock:CreateFontString(nil, "OVERLAY")
			label:FontTemplate(nil, E.db.mMT.objectivetracker.font.fontsize.title, E.db.mMT.objectivetracker.font.fontflag)
			label:SetFont(LSM:Fetch("font", E.db.mMT.objectivetracker.font.font), E.db.mMT.objectivetracker.font.fontsize.title, E.db.mMT.objectivetracker.font.fontflag)
			label:Point("TOPRIGHT", mMT_StageBlock, "TOPRIGHT", -10, -10)
			label:SetJustifyH("RIGHT")
			label:SetJustifyV("TOP")
			mMT_StageBlock.Difficulty = label
		end

		-- hide m+ bgs of the blizzard stage block and set positions
		if isChallengeMode then
			StageBlock:StripTextures()

			StageBlock.Level:ClearAllPoints()
			StageBlock.Level:SetPoint("TOPLEFT", mMT_StageBlock, "TOPLEFT", 10, -10)

			StageBlock.TimeLeft:ClearAllPoints()
			StageBlock.TimeLeft:SetPoint("LEFT", mMT_StageBlock, "LEFT", 8, 2)

			S:HandleStatusBar(StageBlock.StatusBar)
		else
			StageBlock.Stage:ClearAllPoints()
			StageBlock.Stage:SetPoint("LEFT", mMT_StageBlock, "LEFT", 10, 2)
		end

		StageBlock.mMT_StageBlock = mMT_StageBlock
	else
		-- add difficulty text to our lable
		if IsInInstance() and StageBlock.mMT_StageBlock and StageBlock.mMT_StageBlock.Difficulty then
			StageBlock.mMT_StageBlock.Difficulty:SetText(mMT:GetDungeonInfo(false, false, true))
		end
	end
end

-- skin objectivetracker bg
local function BackgroundSkin()
	if not ObjectiveTrackerFrame.NineSlice.mMT_Skin then
		ObjectiveTrackerFrame.NineSlice:SetTemplate("Transparent")
		ObjectiveTrackerFrame.NineSlice:SetFrameStrata("LOW")

		if E.db.mMT.objectivetracker.bg.shadow then
			ObjectiveTrackerFrame.NineSlice:CreateShadow()
		end

		ObjectiveTrackerFrame.NineSlice.mMT_Skin = true
	end

	ObjectiveTrackerFrame.NineSlice:SetBackdropColor(E.db.mMT.objectivetracker.bg.color.bg.r, E.db.mMT.objectivetracker.bg.color.bg.g, E.db.mMT.objectivetracker.bg.color.bg.b, E.db.mMT.objectivetracker.bg.color.bg.a)

	if E.db.mMT.objectivetracker.bg.border then
		ObjectiveTrackerFrame.NineSlice:SetBackdropBorderColor(E.db.mMT.objectivetracker.bg.color.border.r, E.db.mMT.objectivetracker.bg.color.border.g, E.db.mMT.objectivetracker.bg.color.border.b, E.db.mMT.objectivetracker.bg.color.border.a)
	end

	ObjectiveTrackerFrame.NineSlice:SetAlpha(E.db.mMT.objectivetracker.bg.color.bg.a)
end

local function UpdateTracker()
	-- skin objectivetracker bg
	if E.db.mMT.objectivetracker.bg.enable then
		BackgroundSkin()
	end

	--  update header text and add header bar
	if E.db.mMT.objectivetracker.headerbar.enable then
		UpdateHeaders()
	end

	-- Add Quest amount text to the header
	AddQuestNumText()
end
-- ^^ old code ^^
local function CheckFontDB()
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
end

local function SetTextColors()
	colorFont = E.db.mMT.objectivetracker.font.color
	dim = E.db.mMT.objectivetracker.font.highlight
	local colorNormal = colorFont.text.class and mMT.ClassColor or colorFont.text
	local colorTitle = colorFont.title.class and mMT.ClassColor or colorFont.title

	OBJECTIVE_TRACKER_COLOR = {
		["Normal"] = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b },
		["NormalHighlight"] = { r = colorNormal.r - dim, g = colorNormal.g - dim, b = colorNormal.b - dim },
		["Failed"] = { r = colorFont.failed.r, g = colorFont.failed.g, b = colorFont.failed.b },
		["FailedHighlight"] = { r = colorFont.failed.r - dim, g = colorFont.failed.g - dim, b = colorFont.failed.b - dim },
		["Header"] = { r = colorTitle.r, g = colorTitle.g, b = colorTitle.b },
		["HeaderHighlight"] = { r = colorTitle.r - dim, g = colorTitle.g - dim, b = colorTitle.b - dim },
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

-- header bar
local function getColorHeaderBar()
	local color_HeaderBar = { r = 1, g = 1, b = 1, gradient = { a = { r = 0.8, g = 0.8, b = 0.8, a = 1 }, b = { r = 1, g = 1, b = 1, a = 1 } } }

	if E.db.mMT.objectivetracker.headerbar.class then
		color_HeaderBar = mMT.ClassColor or color_HeaderBar
	else
		local c = E.db.mMT.objectivetracker.headerbar.color
		color_HeaderBar = { r = c.r, g = c.g, b = c.b, gradient = { a = { r = c.r + 0.2, g = c.g + 0.2, b = c.b + 0.2, a = 1 }, b = { r = c.r - 0.2, g = c.g - 0.2, b = c.b - 0.2, a = 1 } } }
	end

	return color_HeaderBar
end

local function AddHeaderBar(header)
	local width = ObjectiveTrackerFrame:GetWidth()
	local headerBar = CreateFrame("Frame", "mMT_ObjectiveTracker_HeaderBar", header)
	headerBar:SetFrameStrata("LOW")
	headerBar:SetSize(width, 5)
	headerBar:SetPoint("BOTTOM", 0, 0)

	headerBar.texture = headerBar:CreateTexture()
	headerBar.texture:SetAllPoints(headerBar)
	headerBar.texture:SetTexture(LSM:Fetch("statusbar", E.db.mMT.objectivetracker.headerbar.texture))

	local color_HeaderBar = getColorHeaderBar()

	if E.db.mMT.objectivetracker.headerbar.gradient and color_HeaderBar.gradient.a and color_HeaderBar.gradient.b then
		headerBar.texture:SetGradient("HORIZONTAL", color_HeaderBar.gradient.a, color_HeaderBar.gradient.b)
	else
		headerBar.texture:SetVertexColor(color_HeaderBar.r or 1, color_HeaderBar.g or 1, color_HeaderBar.b or 1, 1)
	end

	if E.db.mMT.objectivetracker.headerbar.shadow then
		headerBar:CreateShadow()
	end
end

local function SetHeaderTextColor(header, color)
	header.Text:SetTextColor(color.r, color.g, color.b)
end

local function SetHeaderTextFont(header, fontSettings)
	header.Text:SetFont(LSM:Fetch("font", fontSettings.font), fontSettings.fontsize.header, fontSettings.fontflag)
end

local function UpdateQuestCount(header)
	if E.db.mMT.objectivetracker.settings.questcount and (_G.QuestObjectiveTracker and (header == _G.QuestObjectiveTracker.Header)) then
		local numQuests = select(2, C_QuestLog.GetNumQuestLogEntries())
		QuestCount = (numQuests .. "/" .. maxNumQuestsCanAccept) or ""
		header.Text:SetText(QUESTS_LABEL .. " - " .. QuestCount)
	end
end

local function AddHeaderBarIfNeeded(header)
	if not header.mMT_BarSkin and header ~= _G.ObjectiveTrackerFrame.Header then
		AddHeaderBar(header)
		header.mMT_BarSkin = true
	end
end

local function SkinHeaders(header)
	SetHeaderTextFont(header, E.db.mMT.objectivetracker.font)
	SetHeaderTextColor(header, E.db.mMT.objectivetracker.font.color.header.class and mMT.ClassColor or E.db.mMT.objectivetracker.font.color.header)
	UpdateQuestCount(header)
	AddHeaderBarIfNeeded(header)
end

local function SetTextColor(text, color)
	text:SetTextColor(color.r, color.g, color.b)
end

local function SetTextFont(text, fontSettings)
	text:SetFont(LSM:Fetch("font", fontSettings.font), fontSettings.fontsize.title, fontSettings.fontflag)
end

local function AdjustTextHeight(text)
	local height = text:GetStringHeight() + 2
	if height ~= text:GetHeight() then
		text:SetHeight(height)
	end
end

local function SetTitleText(text)
	SetTextFont(text, E.db.mMT.objectivetracker.font)
	SetTextColor(text, E.db.mMT.objectivetracker.font.color.title.class and mMT.ClassColor or E.db.mMT.objectivetracker.font.color.title)
	AdjustTextHeight(text) -- fix for overlapping blocks/ line and header - thx Merathilis & Fang
end

local function SetCheckIcon(check)
	local isShownCheck = false
	if check then
		isShownCheck = true
		check:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
		check:SetVertexColor(E.db.mMT.objectivetracker.font.color.good.r, E.db.mMT.objectivetracker.font.color.good.g, E.db.mMT.objectivetracker.font.color.good.b, 1)
	end
	return isShownCheck
end

local function HideDashIfRequired(line, check)
	if E.db.mMT.objectivetracker.settings.hidedash then
		local dash = line.Dash
		if dash then
			dash:Hide()
			dash:SetText(nil)
		end

		if check then
			check:ClearAllPoints()
			check:Point("RIGHT", line, "LEFT", 0, 0)
		end
	end
end

local function SetTextProperties(text, color, fontsize)
	text:SetFont(LSM:Fetch("font", E.db.mMT.objectivetracker.font.font), fontsize, E.db.mMT.objectivetracker.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)
end

local function GetProgressPercent(current, required)
	if required ~= "1" then
		return (tonumber(current) / tonumber(required)) * 100 or 0
	end
	return nil
end

local function GetColorProgress(progressPercent, colorBad, colorTransit, colorGood)
	local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
	return E:RGBToHex(r, g, b)
end

local function GetRequirements(text)
	local current, required, questText = strmatch(text, "^(%d-)/(%d-) (.+)")
	if not current or not required or not questText then
		questText, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end
	return current, required, questText
end

local function SetLineText(text, completed, check)
	SetTextProperties(text, completed and E.db.mMT.objectivetracker.font.color.complete or (E.db.mMT.objectivetracker.font.color.text.class and mMT.ClassColor or E.db.mMT.objectivetracker.font.color.text), E.db.mMT.objectivetracker.font.fontsize.text)

	local lineText = text:GetText()

	if lineText then
		if not (completed and check) then
			local current, required, questText = GetRequirements(lineText)

			if current and required and questText then
				if current >= required then
					lineText = E.db.mMT.objectivetracker.font.color.good.hex .. questText .. "|r"
				else
					local progressPercent = GetProgressPercent(current, required)

					if progressPercent then
						local colorProgress = GetColorProgress(progressPercent, E.db.mMT.objectivetracker.font.color.bad, E.db.mMT.objectivetracker.font.color.transit, E.db.mMT.objectivetracker.font.color.good)
						progressPercent = format("%.f%%", progressPercent)
						lineText = colorProgress .. current .. "/" .. required .. " - " .. progressPercent .. "|r" .. "  " .. questText
					else
						lineText = E.db.mMT.objectivetracker.font.color.bad.hex .. current .. "/" .. required .. "|r  " .. questText
					end
				end
			end
		else
			local _, _, questText = GetRequirements(lineText)
			if questText then
				lineText = E.db.mMT.objectivetracker.font.color.good.hex .. questText .. "|r"
			end
		end

		text:SetText(lineText)
	end
end

local function SkinLines(line, objectiveKey)
	if line then
		if line.objectiveKey == 0 then
			SetTitleText(line.Text)
		else
			local isShownCheck = SetCheckIcon(line.Icon)
			local complete = line.state or (objectiveKey == "QuestComplete") or line.finished
			HideDashIfRequired(line, line.Icon)
			SetLineText(line.Text, complete, isShownCheck)
		end

		-- fix for overlapping blocks/ line and header - thx Merathilis & Fang
		line:SetHeight(line.Text:GetHeight())
	end
end

local function SkinBlock(tracker, block)
	if block then
		if block.HeaderText then
			SetTitleText(block.HeaderText)
		end

		if block.usedLines then
			for objectiveKey, line in pairs(block.usedLines) do
				SkinLines(line, objectiveKey)
			end
		end
	end
end

function module:Initialize()
	-- prevent bugs with wrong db entries
	CheckFontDB()

	-- OT font colors
	SetTextColors()

	-- hook and skin the OT modules/ blocks
	if not module.hooked then
		-- main header "all quests/ objectives"
		if _G.ObjectiveTrackerFrame and _G.ObjectiveTrackerFrame.Header then
			SkinHeaders(_G.ObjectiveTrackerFrame.Header)
		end

		-- add skin to each tracker and block
		for _, tracker in pairs(trackers) do
			if tracker then
				-- tracker header (campaign/ quests ...)
				SkinHeaders(tracker.Header)

				-- add skin to each block/ quest
				if not tracker.mMTSkin then
					hooksecurefunc(tracker, "AddBlock", SkinBlock)
					tracker.mMTSkin = true
				end
			end
		end
	end

	-- fix for overlapping blocks/ line and header - thx Merathilis & Fang
	E:Delay(0.5, function()
		SortQuestWatches()
	end)

	module.needReloadUI = true
	module.loaded = true
end
