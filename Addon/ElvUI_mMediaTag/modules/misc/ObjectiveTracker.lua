local E = unpack(ElvUI)
local LSM = E.Libs.LSM
local S = E:GetModule("Skins")

local module = mMT.Modules.ObjectiveTracker

if not module then return end

local _G = _G
local pairs, mathMin, strmatch, stringGsub = pairs, math.min, strmatch, string.gsub
local hooksecurefunc = hooksecurefunc
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
local maxNumQuestsCanAccept = min(C_QuestLog.GetMaxNumQuestsCanAccept() + (E.Retail and 10 or 0), 35) -- 20 for ERA, 25 for WotLK, 35 for Retail
local IsInInstance = IsInInstance
local SortQuestWatches = C_QuestLog.SortQuestWatches

local colors = {}
local fonts = {}
local cachedQuests = {}
local dim = 0.2
local allObjectivesText

local trackers = {
	_G.AchievementObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.BonusObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.QuestObjectiveTracker,
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

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

-- copied this from elvui because sometimes E.RGBToHex gets a nil value?
local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 1
	g = g <= 1 and g >= 0 and g or 1
	b = b <= 1 and b >= 0 and b or 1
	return format("%s%02x%02x%02x%s", "|cff", r * 255, g * 255, b * 255, "")
end

local function DimColor(color)
	dim = E.db.mMT.objectivetracker.font.highlight

	local r = mathMin(1, color.r * dim)
	local g = mathMin(1, color.g * dim)
	local b = mathMin(1, color.b * dim)

	return r, g, b
end

local function SetTextColors()
	local colorFontDB = E.db.mMT.objectivetracker.font.color
	local colorKeys = { "text", "title", "header", "failed", "complete", "good", "bad", "transit" }
	local tmpColors = {}

	for _, key in ipairs(colorKeys) do
		local colorNormal = colorFontDB[key].class and mMT.ClassColor or colorFontDB[key]
		local r, g, b = DimColor(colorNormal)

		tmpColors[key] = {
			n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
			h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
		}
	end

	return tmpColors
end

local function SetFonts()
	local fontConfig = E.db.mMT.objectivetracker.font
	local fontKeys = { "bar", "header", "misc", "text", "time", "title" }
	local tmpFonts = {}

	for _, key in ipairs(fontKeys) do
		tmpFonts[key] = { font = fontConfig.font, fontsize = fontConfig.fontsize[key], fontflag = fontConfig.fontflag }
	end

	if tmpFonts["bar"] then tmpFonts["bar"].fontsize = E.db.mMT.objectivetracker.bar.fontsize end

	if tmpFonts["misc"] then tmpFonts["misc"].fontsize = fontConfig.fontsize.text end

	return tmpFonts
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
	S:HandleFrame(headerBar)
	headerBar:SetFrameStrata(header:GetFrameStrata())
	headerBar:SetFrameLevel(header:GetFrameLevel() - 1)
	headerBar:SetSize(width, 5)
	headerBar:SetPoint("BOTTOM", 0, 0)

	headerBar.texture = headerBar:CreateTexture()
	headerBar.texture:SetPoint("TOPLEFT", headerBar, "TOPLEFT", 1, -1)
	headerBar.texture:SetPoint("BOTTOMRIGHT", headerBar, "BOTTOMRIGHT", -1, 1)
	headerBar.texture:SetTexture(LSM:Fetch("statusbar", E.db.mMT.objectivetracker.headerbar.texture))

	local color_HeaderBar = getColorHeaderBar()

	if E.db.mMT.objectivetracker.headerbar.gradient and color_HeaderBar.gradient.a and color_HeaderBar.gradient.b then
		headerBar.texture:SetGradient("HORIZONTAL", color_HeaderBar.gradient.a, color_HeaderBar.gradient.b)
	else
		headerBar.texture:SetVertexColor(color_HeaderBar.r or 1, color_HeaderBar.g or 1, color_HeaderBar.b or 1, 1)
	end

	if E.db.mMT.objectivetracker.headerbar.shadow then headerBar:CreateShadow() end
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

local function SetTextProperties(text, fontSettings, color)
	text:SetFont(LSM:Fetch("font", fontSettings.font), fontSettings.fontsize, fontSettings.fontflag)
	if color then text:SetTextColor(color.r, color.g, color.b) end
end

local function SkinTitleText(text, color)
	SetTextProperties(text, fonts.title, color or colors.title.n)
	local height = text:GetStringHeight()
	if height ~= text:GetHeight() then text:SetHeight(height) end
end

local function SkinHeaders(header)
	SetTextProperties(header.Text, fonts.header, colors.header.n)
	UpdateQuestCount(header)
	AddHeaderBarIfNeeded(header)
end

local function SetIcon(icon, texture, r, g, b)
	icon:SetTexture(texture)
	icon:SetVertexColor(r, g, b, 1)
	icon:Show()
end

local function SetCheckIcon(icon, completed, isDungeon)
	if not icon then return end

	if isDungeon then
		if E.db.mMT.objectivetracker.dungeon.hidedash then
			icon:Hide()
		else
			if completed then
				SetIcon(
					icon,
					"Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga",
					E.db.mMT.objectivetracker.font.color.complete.r,
					E.db.mMT.objectivetracker.font.color.complete.g,
					E.db.mMT.objectivetracker.font.color.complete.b
				)
			else
				SetIcon(icon, "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questMinus.tga", mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b)
			end
		end
	elseif completed then
		SetIcon(
			icon,
			"Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga",
			E.db.mMT.objectivetracker.font.color.complete.r,
			E.db.mMT.objectivetracker.font.color.complete.g,
			E.db.mMT.objectivetracker.font.color.complete.b
		)
	else
		icon:Hide()
	end
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

local function GetProgressPercent(current, required)
	if required ~= "1" then return (tonumber(current) / tonumber(required)) * 100 or 0 end

	return nil
end

local function GetColorProgress(progressPercent, colorBad, colorTransit, colorGood)
	local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
	return RGBToHex(r, g, b)
end

local function matchPatterns(text)
	local patterns = {
		{ "^(%d-)/(%d-) (.+)$", "current", "required", "questText" }, -- output: number, number, text (quests with current/required)
		{ "(.+): (%d-)/(%d-)$", "questText", "current", "required" }, -- output: text, number number (quests with current/required)
		{ "(.+) %(([%d%.]+%%)%)$", "questText", "percent" }, -- output: text, number (quests with one number or %)
		{ "^%(([%d%.]+%%)%) (.+)$", "percent", "questText" }, -- output: number, text (quests with one number or %)
	}

	local result = {}
	for _, pattern in ipairs(patterns) do
		local matches = { strmatch(text, pattern[1]) }
		if #matches > 0 then
			for i, key in ipairs(pattern) do
				if i > 1 then result[key] = matches[i - 1] end
			end
			break
		end
	end

	if result.percent then result.percent = stringGsub(result.percent, "%%", "") end

	return result
end

local function GetQuestInfos(id)
	if id then
		local questLogIndex = C_QuestLog.GetLogIndexForQuestID(id)
		if questLogIndex then
			local info = C_QuestLog.GetInfo(questLogIndex)
			return info
		end
	end
end

local function AddQuestToCache(id, index)
	local quest = {}
	local questLogIndex = index
	local questID = id

	if tonumber(id) and not questLogIndex then questLogIndex = C_QuestLog.GetLogIndexForQuestID(questID) end

	if tonumber(questLogIndex) and not id then questID = C_QuestLog.GetQuestIDForQuestWatchIndex(questLogIndex) end

	if questID and questLogIndex then
		quest.questLogIndex = questLogIndex
		quest.info = C_QuestLog.GetInfo(questLogIndex)

		if quest.info and E.db.mMT.objectivetracker.settings.zoneQuests then
			local questLineInfo = C_QuestLine.GetQuestLineInfo(questID)
			if questLineInfo then
				quest.isCampaign = questLineInfo.isCampaign
				quest.isImportant = questLineInfo.isImportant
				quest.isDaily = questLineInfo.isDaily
			end
		end

		local objectives = C_QuestLog.GetQuestObjectives(questID)
		if objectives then
			quest.lines = {}
			for line, objective in ipairs(objectives) do
				quest.lines[line] = objective.text
			end
		end

		return quest
	end
end

local function UpdateCachedQuests(id, index, text)
	local isSkinned = strmatch(text, "|cff") or strmatch(text, "|CFF")
	cachedQuests[id] = cachedQuests[id] or {}
	if not cachedQuests[id] then cachedQuests[id] = AddQuestToCache(id) end

	cachedQuests[id].lines = cachedQuests[id].lines or {}

	if not isSkinned and cachedQuests[id].lines then cachedQuests[id].lines[index] = text end
end

local function GetRequirements(text)
	local result = matchPatterns(text)
	if not result then return nil end

	if result.current and result.required then
		result.complete = tonumber(result.current) >= tonumber(result.required)
	elseif result.percent then
		result.complete = tonumber(result.percent) >= 100
	end

	return result
end

local function SetLineTextBasedOnProgress(result)
	if result.percent and result.percent ~= 0 then
		result.progress = GetColorProgress(result.percent, result.bad, result.transit, result.good)
		if result.current and result.required then
			return result.progress .. result.current .. "/" .. result.required .. " - " .. format("%.f%%", result.percent) .. "|r" .. "  " .. result.color.hex .. result.questText .. "|r"
		else
			return result.color.hex .. result.questText .. "|r " .. "(" .. result.progress .. format("%.f%%", result.percent) .. "|r)"
		end
	else
		return result.bad.hex .. result.current .. "/" .. result.required .. "|r  " .. result.color.hex .. result.questText .. "|r"
	end
end

local function SetLineText(text, completed, id, index, onEnter, onLeave)
	local colorConfig = completed and colors.complete or colors.text
	local color = onEnter and colorConfig.h or colorConfig.n

	local lineText = text:GetText()
	SetTextProperties(text, fonts.text, color)

	if lineText then
		if id and index then
			UpdateCachedQuests(id, index, lineText)

			if onEnter or onLeave and cachedQuests[id].lines then lineText = cachedQuests[id].lines[index] or lineText end
		end

		local result = GetRequirements(lineText)

		if result then
			result.bad = onEnter and colors.bad.h or colors.bad.n
			result.transit = onEnter and colors.transit.h or colors.transit.n
			result.good = onEnter and colors.good.h or colors.good.n
			result.color = color

			if not result.complete then
				if result.current and result.required and result.questText then
					result.percent = GetProgressPercent(result.current, result.required)
					lineText = SetLineTextBasedOnProgress(result)
				elseif result.percent and result.questText then
					lineText = SetLineTextBasedOnProgress(result)
				elseif result.questText then
					lineText = color.hex .. result.questText .. "|r"
				end
			elseif result.questText then
				color = onEnter and colors.complete.h or colors.complete.n
				lineText = color.hex .. result.questText .. "|r"
			end
		end

		text:SetText(lineText)
		return result and result.complete
	end
end

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

local function SetUpBars(bar)
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
	if bar.Label then
		bar.Label:ClearAllPoints()
		bar.Label:SetJustifyH(E.db.mMT.objectivetracker.bar.fontpoint)
		bar.Label:Point(
			E.db.mMT.objectivetracker.bar.fontpoint,
			bar,
			E.db.mMT.objectivetracker.bar.fontpoint,
			E.db.mMT.objectivetracker.bar.fontpoint == "LEFT" and 2 or (E.db.mMT.objectivetracker.bar.fontpoint == "RIGHT" and -2 or 0),
			0
		)
		SetTextProperties(bar.Label, fonts.bar)
	end

	-- bar shadow
	if E.db.mMT.objectivetracker.bar.shadow and not bar.mMT_Shadow then
		bar:CreateShadow()
		bar.mMT_Shadow = true
	end
end

local function SkinLines(line, id, index, isDungeon)
	if line then
		if line.objectiveKey == 0 then
			SkinTitleText(line.Text)
		else
			local complete = (line.objectiveKey == "QuestComplete") or line.finished
			local lineComplete = SetLineText(line.Text, complete, id, index)
			HideDashIfRequired(line, line.Icon)
			SetCheckIcon(line.Icon, (complete or lineComplete), isDungeon)
			if line.progressBar and line.progressBar.Bar then SetUpBars(line.progressBar.Bar) end

			if line.timerBar and line.timerBar.Bar then SetUpBars(line.timerBar.Bar) end
		end

		-- fix for overlapping blocks/ line and header - thx Merathilis & Fang
		line:SetHeight(line.Text:GetHeight())
	end
end

local function CreateStageFrame(block, isChallengeMode)
	local mMT_StageBlock = CreateFrame("Frame", isChallengeMode and "mMT_ChallengeBlock" or "mMT_StageBlock")
	local width = ObjectiveTrackerFrame:GetWidth()
	S:HandleFrame(mMT_StageBlock)

	mMT_StageBlock:SetParent(block)
	mMT_StageBlock:ClearAllPoints()
	mMT_StageBlock:SetPoint("TOPLEFT", 0, -5)

	mMT_StageBlock:SetSize(width, 80)
	mMT_StageBlock:SetFrameLevel(3)
	mMT_StageBlock:Show()

	if E.db.mMT.objectivetracker.dungeon.shadow then mMT_StageBlock:CreateShadow() end

	-- create difficulty label to dungeon stage block if not m+
	if not mMT_StageBlock.Difficulty and not isChallengeMode then
		local label = mMT_StageBlock:CreateFontString(nil, "OVERLAY")
		SetTextProperties(label, fonts.title)
		label:Point("TOPRIGHT", mMT_StageBlock, "TOPRIGHT", -10, -10)
		label:SetJustifyH("RIGHT")
		label:SetJustifyV("TOP")
		label:SetText(mMT:GetDungeonInfo(false, false, true))
		mMT_StageBlock.Difficulty = label
	end

	-- hide m+ bgs of the blizzard stage block and set positions
	if isChallengeMode then
		block:StripTextures()

		if block.Level then
			block.Level:ClearAllPoints()
			block.Level:SetPoint("TOPLEFT", mMT_StageBlock, "TOPLEFT", 10, -10)
			SetTextProperties(block.Level, fonts.misc)
		end

		if block.TimeLeft then
			block.TimeLeft:ClearAllPoints()
			block.TimeLeft:SetPoint("LEFT", mMT_StageBlock, "LEFT", 8, 2)
			SetTextProperties(block.TimeLeft, fonts.time)
		end

		if block.DeathCount and block.DeathCount.Count then
			--block.DeathCount:ClearAllPoints()
			--block.DeathCount:SetPoint("RIGHT", mMT_StageBlock, "RIGHT", -8, 2)
			SetTextProperties(block.DeathCount.Count, fonts.misc)
		end

		S:HandleStatusBar(block.StatusBar)
	else
		block.Stage:ClearAllPoints()
		block.Stage:SetPoint("LEFT", mMT_StageBlock, "LEFT", 10, 2)
	end

	block.mMT_StageBlock = mMT_StageBlock
end

local function SkinStageBlock(stageBlock, scenarioID, scenarioType, widgetSetID, textureKit, flags, currentStage, stageName, numStages)
	if stageBlock.NormalBG then
		stageBlock.NormalBG:Hide()
		stageBlock.NormalBG:SetTexture()
	end

	if stageBlock.FinalBG then
		stageBlock.FinalBG:Hide()
		stageBlock.FinalBG:SetTexture()
	end

	if stageBlock.Stage then
		SetTextProperties(stageBlock.Stage, fonts.title)

		-- create stage block bg
		if not stageBlock.mMT_StageBlock then
			CreateStageFrame(stageBlock, C_ChallengeMode.GetActiveChallengeMapID())
		else
			if IsInInstance() and stageBlock.mMT_StageBlock and stageBlock.mMT_StageBlock.Difficulty then stageBlock.mMT_StageBlock.Difficulty:SetText(mMT:GetDungeonInfo(false, false, true, true)) end
		end
	end

	if stageBlock.WidgetContainer and stageBlock.WidgetContainer.widgetFrames then
		for _, widgetFrame in pairs(stageBlock.WidgetContainer.widgetFrames) do
			if widgetFrame.Frame then
				widgetFrame.Frame:SetAlpha(0)
				widgetFrame.Frame:Hide()
			end
		end
	end
end

local function SkinChallengeBlock(challengeBlock, elapsedTime)
	if not challengeBlock.SkinChallengeBlock then
		challengeBlock:StripTextures()

		-- create stage block bg
		if not challengeBlock.mMT_StageBlock then CreateStageFrame(challengeBlock, C_ChallengeMode.GetActiveChallengeMapID()) end

		-- get dungeon time limits
		if not challengeBlock.mMT_Timers then
			challengeBlock.mMT_Timers = {}
			challengeBlock.mMT_Timers.chest3 = challengeBlock.timeLimit * 0.6
			challengeBlock.mMT_Timers.chest2 = challengeBlock.timeLimit * 0.8
		end

		-- timer bar color
		local colorA = E.db.mMT.objectivetracker.dungeon.color.chest1.a
		local colorB = E.db.mMT.objectivetracker.dungeon.color.chest1.b

		if elapsedTime < challengeBlock.mMT_Timers.chest3 then
			colorA = E.db.mMT.objectivetracker.dungeon.color.chest3.a
			colorB = E.db.mMT.objectivetracker.dungeon.color.chest3.b
		elseif elapsedTime < challengeBlock.mMT_Timers.chest2 then
			colorA = E.db.mMT.objectivetracker.dungeon.color.chest2.a
			colorB = E.db.mMT.objectivetracker.dungeon.color.chest2.b
		else
			colorA = E.db.mMT.objectivetracker.dungeon.color.chest1.a
			colorB = E.db.mMT.objectivetracker.dungeon.color.chest1.b
		end

		challengeBlock.StatusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = colorA.r, g = colorA.g, b = colorA.b, a = colorA.a }, { r = colorB.r, g = colorB.g, b = colorB.b, a = colorB.a })

		-- create and set time limit markers
		if not challengeBlock.timerMarker then
			local width = challengeBlock.StatusBar:GetWidth()
			local height = challengeBlock.StatusBar:GetHeight()
			local timerMarker = CreateFrame("Frame", nil, challengeBlock)
			timerMarker:SetAllPoints(challengeBlock)

			timerMarker.chest3 = timerMarker:CreateTexture(nil, "OVERLAY")
			timerMarker.chest3:SetColorTexture(1, 1, 1)
			timerMarker.chest3:SetSize(2, height) --block.StatusBar:GetHeight())

			timerMarker.chest2 = timerMarker:CreateTexture(nil, "OVERLAY")
			timerMarker.chest2:SetColorTexture(1, 1, 1)
			timerMarker.chest2:SetSize(2, height) --block.StatusBar:GetHeight())

			timerMarker.chest3:SetPoint("LEFT", challengeBlock.StatusBar, "LEFT", width - (width * challengeBlock.mMT_Timers.chest3 / challengeBlock.timeLimit), 0)
			timerMarker.chest2:SetPoint("LEFT", challengeBlock.StatusBar, "LEFT", width - (width * challengeBlock.mMT_Timers.chest2 / challengeBlock.timeLimit), 0)
			timerMarker.chest3:Show()
			timerMarker.chest2:Show()

			timerMarker:Show()

			challengeBlock.timerMarker = timerMarker
		end

		-- create and add time for current chest or over time
		if not challengeBlock.mMT_Time then
			local timeLable = challengeBlock.StatusBar:CreateFontString(nil, "OVERLAY")
			timeLable:FontTemplate(nil, E.db.mMT.objectivetracker.font.fontsize.title, E.db.mMT.objectivetracker.font.fontflag)
			timeLable:SetFont(LSM:Fetch("font", E.db.mMT.objectivetracker.font.font), E.db.mMT.objectivetracker.font.fontsize.title, E.db.mMT.objectivetracker.font.fontflag)
			timeLable:SetPoint("RIGHT", challengeBlock.StatusBar, "RIGHT", -4, 0)
			timeLable:SetJustifyH("RIGHT")
			timeLable:SetJustifyV("TOP")
			challengeBlock.mMT_Time = timeLable
		end

		local timeText = nil

		-- get time limits and set it to ta label
		if elapsedTime < challengeBlock.mMT_Timers.chest3 then
			timeText = "+3 " .. SecondsToClock(challengeBlock.mMT_Timers.chest3 - elapsedTime)
		elseif elapsedTime < challengeBlock.mMT_Timers.chest2 then
			timeText = "+2 " .. SecondsToClock(challengeBlock.mMT_Timers.chest2 - elapsedTime)
		elseif elapsedTime > challengeBlock.timeLimit then
			timeText = E.db.mMT.objectivetracker.font.color.bad.hex .. "+ " .. SecondsToClock(elapsedTime - challengeBlock.timeLimit) .. "|r"
			challengeBlock.TimeLeft:SetText(E.db.mMT.objectivetracker.font.color.bad.hex .. SecondsToClock(elapsedTime) .. "|r")
		else
			timeText = ""
		end

		if timeText then challengeBlock.mMT_Time:SetText(timeText) end
	end
end

local function LinesOnEnterLeave(line, id, index, onEnter, onLeave)
	if line then
		if line.objectiveKey == 0 then
			local color = onEnter and colors.title.h or colors.title.n
			SkinTitleText(line.Text, color)
		else
			local complete = (line.objectiveKey == "QuestComplete") or line.finished
			SetLineText(line.Text, complete, id, index, onEnter, onLeave)
			line:SetHeight(line.Text:GetHeight())
		end
	end
end

local function GetLevelInfoText(level, onEnter)
	if level then
		local color = (level < 0) and { r = 1, g = 0, b = 0 } or GetCreatureDifficultyColor(level) --GetRelativeDifficultyColor(teamLevel, level)
		local r, g, b = onEnter and DimColor(color) or color.r, color.g, color.b
		local colorString = RGBToHex(r, g, b)
		local levelText = (level < 0) and "??" or level

		return "[" .. colorString .. levelText .. "|r] "
	else
		return ""
	end
end

local function OnHeaderEnter(block)
	if block.HeaderText then
		SkinTitleText(block.HeaderText, colors.title.h)

		if E.db.mMT.objectivetracker.settings.showLevel and (cachedQuests[block.id] and cachedQuests[block.id].info) then
			block.HeaderText:SetText(GetLevelInfoText(cachedQuests[block.id].info.level, true) .. cachedQuests[block.id].title)
		end
	end

	if block.usedLines then
		for index, line in pairs(block.usedLines) do
			LinesOnEnterLeave(line, block.id, index, true, false)
		end
	end
end

local function OnHeaderLeave(block)
	if block.HeaderText then
		SkinTitleText(block.HeaderText, colors.title.n)
		if E.db.mMT.objectivetracker.settings.showLevel and (cachedQuests[block.id] and cachedQuests[block.id].info) then
			block.HeaderText:SetText(GetLevelInfoText(cachedQuests[block.id].info.level) .. cachedQuests[block.id].title)
		end
	end

	if block.usedLines then
		for index, line in pairs(block.usedLines) do
			LinesOnEnterLeave(line, block.id, index, false, true)
		end
	end
end

local function SkinBlock(_, block)
	if block then
		local totalHeight = 2

		if block.Stage and not block.mMT_StageSkin then
			hooksecurefunc(block, "UpdateStageBlock", SkinStageBlock)
			SkinStageBlock(block)
			block.mMT_StageSkin = true
		end

		if block.WidgetContainer and block.WidgetContainer.widgetFrames then
			for _, widgetFrame in pairs(block.WidgetContainer.widgetFrames) do
				if widgetFrame.Frame then
					widgetFrame.Frame:SetAlpha(0)
					widgetFrame.Frame:Hide()
				end
			end
		end

		if block.id and (not cachedQuests[block.id] or not cachedQuests[block.id].update) then
			cachedQuests[block.id] = AddQuestToCache(block.id)
			if cachedQuests[block.id] then cachedQuests[block.id].update = true end
		end

		if block.affixPool and block.UpdateTime and not block.mMT_ChallengeBlock then
			hooksecurefunc(block, "UpdateTime", SkinChallengeBlock)
			block.mMT_ChallengeBlock = true
		end

		if block.HeaderText then
			SkinTitleText(block.HeaderText)
			if (cachedQuests[block.id] and cachedQuests[block.id].info) and E.db.mMT.objectivetracker.settings.showLevel then
				cachedQuests[block.id].title = block.HeaderText:GetText()
				block.HeaderText:SetText(GetLevelInfoText(cachedQuests[block.id].info.level) .. block.HeaderText:GetText())
			end
			totalHeight = totalHeight + block.HeaderText:GetHeight()
		end

		if block.usedLines then
			for index, line in pairs(block.usedLines) do
				SkinLines(line, block.id, index, block.Stage)
			end
		end

		if block.OnHeaderEnter and not block.mMT_OnEnterHook then
			hooksecurefunc(block, "OnHeaderEnter", OnHeaderEnter)
			block.mMT_OnEnterHook = true
		end

		if block.OnHeaderLeave and not block.mMT_OnLeaveHook then
			hooksecurefunc(block, "OnHeaderLeave", OnHeaderLeave)
			block.mMT_OnLeaveHook = true
		end

		if not block.WidgetContainerand and not (C_ChallengeMode.GetActiveChallengeMapID() or IsInInstance()) then
			if block.usedLines then
				for _, line in pairs(block.usedLines) do
					totalHeight = totalHeight + line:GetHeight()
				end
			end
			block:SetHeight(totalHeight)
		end
	end
end

local function AddBackground()
	-- inspired by Merathilis background, thank you
	local backdrop = _G.ObjectiveTrackerFrame.backdrop

	if E.db.mMT.objectivetracker.bg.enable then
		if not backdrop then
			_G.ObjectiveTrackerFrame:CreateBackdrop()
			backdrop = _G.ObjectiveTrackerFrame.backdrop
		end

		if E.db.mMT.objectivetracker.bg.shadow then backdrop:CreateShadow() end

		backdrop:SetTemplate(E.db.mMT.objectivetracker.bg.transparent and "Transparent")

		if E.db.mMT.objectivetracker.bg.border then
			local borderColor = E.db.mMT.objectivetracker.bg.classBorder and mMT.ClassColor or E.db.mMT.objectivetracker.bg.color.border
			backdrop:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a or 1)
		end

		local backgroundColor

		if not E.db.mMT.objectivetracker.bg.transparent then
			backgroundColor = E.db.mMT.objectivetracker.bg.classBG and mMT.ClassColor or E.db.mMT.objectivetracker.bg.color.bg
		else
			backgroundColor = E.db.mMT.objectivetracker.bg.classBG and { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b, a = 0.25 } or nil
		end

		if backgroundColor then backdrop:SetBackdropColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a) end

		backdrop:ClearAllPoints()
		backdrop:SetPoint("TOPLEFT", _G.ObjectiveTrackerFrame.NineSlice, "TOPLEFT", 10, 10)
		backdrop:SetPoint("BOTTOMRIGHT", _G.ObjectiveTrackerFrame.NineSlice, "BOTTOMRIGHT", 16, -10)

		backdrop:Show()
	else
		if backdrop then backdrop:Hide() end
	end
end

local function BuildQuestCache()
	local watchedQuests = {}
	for i = 1, C_QuestLog.GetNumQuestWatches() do
		local questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i)
		if questID then watchedQuests[questID] = AddQuestToCache(questID, i) end
	end

	return watchedQuests
end

function module:TrackUntrackQuests()
	if not cachedQuests then cachedQuests = BuildQuestCache() end

	for id, quest in pairs(cachedQuests) do
		quest.info = GetQuestInfos(id)
		if quest.info then
			local isOnMap = quest.info.isOnMap
			local isCampaign = quest.isCampaign
			if isOnMap or isCampaign then
				C_QuestLog.AddQuestWatch(id)
			else
				C_QuestLog.RemoveQuestWatch(id)
			end
		end
	end

	SortQuestWatches()
end

function module:Initialize()
	-- prevent bugs with wrong db entries
	CheckFontDB()

	-- update colors
	colors = SetTextColors()

	-- update font
	fonts = SetFonts()

	if _G.ObjectiveTrackerFrame then
		-- OT Background
		AddBackground()

		-- main header "all quests/ objectives"
		if _G.ObjectiveTrackerFrame.Header then
			if _G.ObjectiveTrackerFrame.Header.Text then
				if E.db.mMT.objectivetracker.settings.hideAll then
					_G.ObjectiveTrackerFrame.Header.Text:Hide() -- do not touch this, it will taint if SetText()
				elseif allObjectivesText then
					_G.ObjectiveTrackerFrame.Header.Text:SetText(allObjectivesText)
				end
			end
			SkinHeaders(_G.ObjectiveTrackerFrame.Header)
		end
	end

	-- hook and skin the OT modules/ blocks
	if not module.hooked then
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

				--tracker:SetHeight(5)
			end
		end
		module.hooked = true
	end

	cachedQuests = BuildQuestCache()

	if E.db.mMT.objectivetracker.settings.zoneQuests then module:TrackUntrackQuests() end

	-- fix for overlapping blocks/ line and header - thx Merathilis & Fang
	E:Delay(0.5, function()
		SortQuestWatches()
	end)

	module.needReloadUI = true
	module.loaded = true
end
