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

local colors = {
	title = {},
	header = {},
	text = {},
	failed = {},
	complete = {},
	good = {},
	bad = {},
	transit = {},
}

local dim = 0.2

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
local function RGBToHex(r, g, b, debug)
	r = r <= 1 and r >= 0 and r or 1
	g = g <= 1 and g >= 0 and g or 1
	b = b <= 1 and b >= 0 and b or 1
	return format("%s%02x%02x%02x%s", "|cff", r * 255, g * 255, b * 255, "")
end

local function DimColor(color)
	local r, g, b

	dim = E.db.mMT.objectivetracker.font.highlight

	local newR = math.min(1, color.r * dim)
	local newG = math.min(1, color.g * dim)
	local newB = math.min(1, color.b * dim)

	return newR, newG, newB
end

local function SetTextColors()
	local colorFontDB = E.db.mMT.objectivetracker.font.color
	local colorNormal, r, g, b

	colorNormal = colorFontDB.text.class and mMT.ClassColor or colorFontDB.text
	r, g, b = DimColor(colorNormal)

	colors.text = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}

	colorNormal = colorFontDB.title.class and mMT.ClassColor or colorFontDB.title
	r, g, b = DimColor(colorNormal)

	colors.title = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}

	colorNormal = colorFontDB.header.class and mMT.ClassColor or colorFontDB.header
	r, g, b = DimColor(colorNormal)

	colors.header = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}

	colorNormal = colorFontDB.failed
	r, g, b = DimColor(colorNormal)

	colors.failed = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}

	colorNormal = colorFontDB.complete
	r, g, b = DimColor(colorNormal)

	colors.complete = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}

	colorNormal = colorFontDB.good
	r, g, b = DimColor(colorNormal)

	colors.good = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}

	colorNormal = colorFontDB.bad
	r, g, b = DimColor(colorNormal)

	colors.bad = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}

	colorNormal = colorFontDB.transit
	r, g, b = DimColor(colorNormal)

	colors.transit = {
		n = { r = colorNormal.r, g = colorNormal.g, b = colorNormal.b, hex = colorNormal.hex },
		h = { r = r, g = g, b = b, hex = RGBToHex(r, g, b) },
	}
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
	if color then
		text:SetTextColor(color.r, color.g, color.b)
	end
end

local function SkinHeaders(header)
	local fontConfig, color

	fontConfig = E.db.mMT.objectivetracker.font
	color = colors.header.n

	SetTextProperties(header.Text, { font = fontConfig.font, fontsize = fontConfig.fontsize.header, fontflag = fontConfig.fontflag }, color)
	UpdateQuestCount(header)
	AddHeaderBarIfNeeded(header)
end

local function SetCheckIcon(icon, completed)
	if icon and completed then
		icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
		icon:SetVertexColor(E.db.mMT.objectivetracker.font.color.good.r, E.db.mMT.objectivetracker.font.color.good.g, E.db.mMT.objectivetracker.font.color.good.b, 1)
	elseif select(1, IsInInstance()) then
		if E.db.mMT.objectivetracker.dungeon.hidedash then
			icon:Hide()
		else
			icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questMinus.tga")
			icon:SetVertexColor(mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, 1)
		end
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
	if required ~= "1" then
		return (tonumber(current) / tonumber(required)) * 100 or 0
	end
	return nil
end

local function GetColorProgress(progressPercent, colorBad, colorTransit, colorGood)
	dim = E.db.mMT.objectivetracker.font.highlight
	local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
	return RGBToHex(r, g, b)
end

local function GetRequirements(text)
	local current, required, questText = strmatch(text, "^(%d-)/(%d-) (.+)")
	if not current or not required or not questText then
		questText, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end
	return current, required, questText
end

local function SetLineText(text, completed, onEnter, onLeave)
	local fontConfig, colorConfig, color, colorBad, colorTransit, colorGood, colorProgress, tmpText

	fontConfig = E.db.mMT.objectivetracker.font
	colorConfig = completed and colors.complete or colors.text
	color = onEnter and colorConfig.h or colorConfig.n

	SetTextProperties(text, { font = fontConfig.font, fontsize = fontConfig.fontsize.text, fontflag = fontConfig.fontflag }, color)

	local lineText = text:GetText()
	local tmpText = text:GetText()

	if onEnter or onLeave and text.originalText then
		lineText = text.originalText
	end

	if lineText then
		if not completed then
			local current, required, questText = GetRequirements(lineText)

			if current and required and questText then
				if current >= required then
					color = onEnter and colors.complete.h or colors.complete.n
					lineText = color.hex .. questText .. "|r"
				else
					local progressPercent = GetProgressPercent(current, required)

					if progressPercent then
						colorBad = onEnter and colors.bad.h or colors.bad.n
						colorTransit = onEnter and colors.transit.h or colors.transit.n
						colorGood = onEnter and colors.good.h or colors.good.n
						color = onEnter and colors.text.h or colors.text.n
						colorProgress = GetColorProgress(progressPercent, colorBad, colorTransit, colorGood)

						lineText = colorProgress .. current .. "/" .. required .. " - " .. format("%.f%%", progressPercent) .. "|r" .. "  " .. color.hex .. questText .. "|r"
					else
						colorBad = onEnter and colors.bad.h or colors.bad.n
						color = onEnter and colors.text.h or colors.text.n
						lineText = colorBad.hex .. current .. "/" .. required .. "|r  " .. color.hex .. questText .. "|r"
					end
				end
			end
		else
			local _, _, questText = GetRequirements(lineText)
			if questText then
				color = onEnter and colors.complete.h or colors.complete.n
				lineText = color.hex .. questText .. "|r"
			end
		end

		if not text.originalText or text.originalText ~= tmpText then
			local isSkinned, _ = string.find(text:GetText(), "|cff")
			if not isSkinned then
				text.originalText = text:GetText()
			end
		end

		text:SetText(lineText)
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
		local fontConfig = E.db.mMT.objectivetracker.font
		bar.Label:ClearAllPoints()
		bar.Label:SetJustifyH(E.db.mMT.objectivetracker.bar.fontpoint)
		bar.Label:Point(E.db.mMT.objectivetracker.bar.fontpoint, bar, E.db.mMT.objectivetracker.bar.fontpoint, E.db.mMT.objectivetracker.bar.fontpoint == "LEFT" and 2 or (E.db.mMT.objectivetracker.bar.fontpoint == "RIGHT" and -2 or 0), 0)
		SetTextProperties(bar.Label, { font = fontConfig.font, fontsize = E.db.mMT.objectivetracker.bar.fontsize, fontflag = fontConfig.fontflag })
	end

	-- bar shadow
	if E.db.mMT.objectivetracker.bar.shadow and not bar.mMT_Shadow then
		bar:CreateShadow()
		bar.mMT_Shadow = true
	end
end

local function SkinLines(line)
	if line then
		if line.objectiveKey == 0 then
			local fontConfig = E.db.mMT.objectivetracker.font
			SetTextProperties({ font = fontConfig.font, fontsize = fontConfig.fontsize.title, fontflag = fontConfig.fontflag }, colors.title.n)
		else
			local complete = line.state or (line.objectiveKey == "QuestComplete") or line.finished
			SetCheckIcon(line.Icon, complete)
			HideDashIfRequired(line, line.Icon)
			SetLineText(line.Text, complete)
			if line.progressBar and line.progressBar.Bar then
				SetUpBars(line.progressBar.Bar)
			end

			if line.usedTimerBars or line.Bar then
				mMT:DebugPrintTable(line)
			end
		end

		-- fix for overlapping blocks/ line and header - thx Merathilis & Fang
		line:SetHeight(line.Text:GetHeight())
	end
end

local function CreateStageFrame(block, isChallengeMode)
	local mMT_StageBlock = CreateFrame("Frame", isChallengeMode and "mMT_ChallengeBlock" or "mMT_StageBlock")
	local width = ObjectiveTrackerFrame:GetWidth()
	local fontConfig = E.db.mMT.objectivetracker.font
	S:HandleFrame(mMT_StageBlock)

	mMT_StageBlock:SetParent(block)
	mMT_StageBlock:ClearAllPoints()
	mMT_StageBlock:SetPoint("TOPLEFT", 0, -5)

	mMT_StageBlock:SetSize(width, 80)
	mMT_StageBlock:SetFrameLevel(3)
	mMT_StageBlock:Show()

	if E.db.mMT.objectivetracker.dungeon.shadow then
		mMT_StageBlock:CreateShadow()
	end

	-- create difficulty label to dungeon stage block if not m+
	if not mMT_StageBlock.Difficulty and not isChallengeMode then
		local label = mMT_StageBlock:CreateFontString(nil, "OVERLAY")
		label:FontTemplate(nil, fontConfig.fontsize.title, fontConfig.fontflag)
		SetTextProperties(label, { font = fontConfig.font, fontsize = fontConfig.fontsize.title, fontflag = fontConfig.fontflag })

		label:Point("TOPRIGHT", mMT_StageBlock, "TOPRIGHT", -10, -10)
		label:SetJustifyH("RIGHT")
		label:SetJustifyV("TOP")
		label:SetText(mMT:GetDungeonInfo(false, false, true))
		mMT_StageBlock.Difficulty = label
	end

	-- hide m+ bgs of the blizzard stage block and set positions
	if isChallengeMode then
		block:StripTextures()

		block.Level:ClearAllPoints()
		block.Level:SetPoint("TOPLEFT", mMT_StageBlock, "TOPLEFT", 10, -10)
		SetTextProperties(block.Level, { font = fontConfig.font, fontsize = fontConfig.fontsize.text, fontflag = fontConfig.fontflag })

		block.TimeLeft:ClearAllPoints()
		block.TimeLeft:SetPoint("LEFT", mMT_StageBlock, "LEFT", 8, 2)
		SetTextProperties(block.TimeLeft, { font = fontConfig.font, fontsize = fontConfig.fontsize.time, fontflag = fontConfig.fontflag })

		--block.DeathCount:ClearAllPoints()
		--block.DeathCount:SetPoint("RIGHT", mMT_StageBlock, "RIGHT", -8, 2)
		SetTextProperties(block.DeathCount.Count, { font = fontConfig.font, fontsize = fontConfig.fontsize.text, fontflag = fontConfig.fontflag })

		S:HandleStatusBar(block.StatusBar)
	else
		block.Stage:ClearAllPoints()
		block.Stage:SetPoint("LEFT", mMT_StageBlock, "LEFT", 10, 2)
	end

	block.mMT_StageBlock = mMT_StageBlock
end

local function SkinStageBlock()
	if _G.ScenarioObjectiveTracker then
		local stageBlocks = { _G.ScenarioObjectiveTracker.ContentsFrame:GetChildren() }
		for _, stageBlock in pairs(stageBlocks) do
			if stageBlock.Stage then
				local fontConfig = E.db.mMT.objectivetracker.font
				SetTextProperties(stageBlock.Stage, { font = fontConfig.font, fontsize = fontConfig.fontsize.title, fontflag = fontConfig.fontflag })

				-- create stage block bg
				if not stageBlock.mMT_StageBlock then
					CreateStageFrame(stageBlock, false)
				else
					if IsInInstance() and stageBlock.mMT_StageBlock and stageBlock.mMT_StageBlock.Difficulty then
						stageBlock.mMT_StageBlock.Difficulty:SetText(mMT:GetDungeonInfo(false, false, true))
					end
				end
			end

			if stageBlock.NormalBG then
				stageBlock.NormalBG:Hide()
				stageBlock.NormalBG:SetTexture()
			end

			if stageBlock.FinalBG then
				stageBlock.FinalBG:Hide()
				stageBlock.FinalBG:SetTexture()
			end
		end
	end
end

local function SkinChallengeBlock(challengeBlock, elapsedTime)
	if not challengeBlock.SkinChallengeBlock then
		challengeBlock:StripTextures()

		-- create stage block bg
		if not challengeBlock.mMT_StageBlock then
			CreateStageFrame(challengeBlock, true)
		end

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

		if timeText then
			challengeBlock.mMT_Time:SetText(timeText)
		end
	end
end

local function LinesOnEnterLeave(line, onEnter, onLeave)
	if line then
		if line.objectiveKey == 0 then
			local fontConfig, color

			fontConfig = E.db.mMT.objectivetracker.font
			color = onEnter and colors.title.h or colors.title.n

			SetTextProperties(line.Text, { font = fontConfig.font, fontsize = fontConfig.fontsize.title, fontflag = fontConfig.fontflag }, color)
		else
			local complete = line.state or (line.objectiveKey == "QuestComplete") or line.finished
			SetLineText(line.Text, complete, onEnter, onLeave)
		end
	end
end

local function OnHeaderEnter(block)
	if block.HeaderText then
		local fontConfig, color

		fontConfig = E.db.mMT.objectivetracker.font
		color = colors.title.h

		SetTextProperties(block.HeaderText, { font = fontConfig.font, fontsize = fontConfig.fontsize.title, fontflag = fontConfig.fontflag }, color)
	end

	if block.usedLines then
		for _, line in pairs(block.usedLines) do
			LinesOnEnterLeave(line, true, false)
		end
	end
end

local function OnHeaderLeave(block)
	if block.HeaderText then
		local fontConfig, color

		fontConfig = E.db.mMT.objectivetracker.font
		color = colors.title.n

		SetTextProperties(block.HeaderText, { font = fontConfig.font, fontsize = fontConfig.fontsize.title, fontflag = fontConfig.fontflag }, color)
	end

	if block.usedLines then
		for _, line in pairs(block.usedLines) do
			LinesOnEnterLeave(line, false, true)
		end
	end
end

local function SkinBlock(tracker, block)
	if block then
		if block.Stage and not block.mMT_StageSkin then
			hooksecurefunc(block, "UpdateStageBlock", SkinStageBlock)
			block.mMT_StageSkin = true
		end

		if block.affixPool and block.UpdateTime and not block.mMT_ChallengeBlock then
			hooksecurefunc(block, "UpdateTime", SkinChallengeBlock)
			block.mMT_ChallengeBlock = true
		end

		if block.HeaderText then
			local fontConfig, color

			fontConfig = E.db.mMT.objectivetracker.font
			color = colors.title.n

			SetTextProperties(block.HeaderText, { font = fontConfig.font, fontsize = fontConfig.fontsize.title, fontflag = fontConfig.fontflag }, color)
		end

		if block.usedLines then
			for _, line in pairs(block.usedLines) do
				SkinLines(line)
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
	end
end

function module:Initialize()
	-- prevent bugs with wrong db entries
	CheckFontDB()

	-- font colors
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
