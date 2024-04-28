local E, L, V, P, G = unpack(ElvUI)
local LSM = E.Libs.LSM
local S = E:GetModule("Skins")

local module = mMT.Modules.ObjectiveTracker
local db = nil
if not module then
	return
end

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
local maxNumQuestsCanAccept = min(C_QuestLog.GetMaxNumQuestsCanAccept() + (E.Retail and 10 or 0), 35) -- 20 for ERA, 25 for WotLK, 35 for Retail
local IsInInstance = IsInInstance

local colorFont = {}
local color = {}
local dim = 0.2
local fontsize = 12

-- get quest infos
local function GetRequirements(text)
	local current, required, questText = strmatch(text, "^(%d-)/(%d-) (.+)")
	if not current or not required or not questText then
		questText, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end
	return current, required, questText
end

-- skin progress/ timer bars
local function SkinBarColor(Bar, r, g, b)
	if not db then
		return
	end
	if Bar then
		if db.bar.elvbg then
			local color_barBG = E.db.general.backdropfadecolor
			Bar.backdrop:SetBackdropColor(color_barBG.r, color_barBG.g, color_barBG.b, color_barBG.a)
		end

		if db.bar.gradient then
			Bar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = r - 0.2, g = g - 0.2, b = b - 0.2, a = 1 }, { r = r + 0.2, g = g + 0.2, b = b + 0.2, a = 1 })
		end
	end
end

-- skin progress/ timer bars
local function SetUpBars(bar)
	if not db then
		return
	end
	-- bar text
	local label = bar.Label

	-- bar height
	bar:Height(db.bar.hight)

	-- bg color
	if db.bar.elvbg and bar.backdrop then
		local color_barBG = E.db.general.backdropfadecolor
		bar.backdrop:SetBackdropColor(color_barBG.r, color_barBG.g, color_barBG.b, color_barBG.a)
	end

	-- gradient bar color
	if db.bar.gradient and not bar.mMT_hooked then
		hooksecurefunc(bar, "SetStatusBarColor", SkinBarColor)
		bar.mMT_hooked = true
	end

	-- setup bar text
	if label then
		label:ClearAllPoints()
		label:SetJustifyH(db.bar.fontpoint)
		label:Point(db.bar.fontpoint, bar, db.bar.fontpoint, db.bar.fontpoint == "LEFT" and 2 or (db.bar.fontpoint == "RIGHT" and -2 or 0), 0)
		label:FontTemplate(nil, db.bar.fontsize, db.fontflag)
	end

	-- bar shadow
	if db.bar.shadow and not bar.mMT_Shadow then
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

-- quest text colors
local function SetTextColors()
	if not db then
		return
	end
	colorFont = db.font.color
	dim = db.font.highlight
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

-- title text settings
local function SetTitleText(text)
	if not db then
		return
	end
	color = db.font.color.title.class and mMT.ClassColor or db.font.color.title
	fontsize = db.font.fontsize.title

	text:SetFont(LSM:Fetch("font", db.font.font), fontsize, db.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)
end

--line text settings
local function SetLineText(text, completed, check)
	if not db then
		return
	end
	color = completed and db.font.color.complete or (db.font.color.text.class and mMT.ClassColor or db.font.color.text)
	fontsize = db.font.fontsize.text

	text:SetFont(LSM:Fetch("font", db.font.font), fontsize, db.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)
	local lineText = text:GetText()

	if lineText then
		-- Text Progress
		if not (completed and check) then
			local current, required, questText = GetRequirements(lineText)

			if current and required and questText then
				if current == required then
					lineText = db.font.color.good.hex .. questText .. "|r"
				else
					local progressPercent = nil

					local colorGood = db.font.color.good
					local colorTransit = db.font.color.transit
					local colorBad = db.font.color.bad

					if required ~= "1" then
						progressPercent = (tonumber(current) / tonumber(required)) * 100 or 0
						local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
						local colorProgress = E:RGBToHex(r, g, b)
						progressPercent = format("%.f%%", progressPercent)
						lineText = colorProgress .. current .. "/" .. required .. " - " .. progressPercent .. "|r" .. "  " .. questText
					else
						lineText = db.font.color.bad.hex .. current .. "/" .. required .. "|r  " .. questText
					end
				end
			end
		else
			local _, _, questText = GetRequirements(lineText)
			if questText then
				lineText = db.font.color.good.hex .. questText .. "|r"
			end
		end

		text:SetText(lineText)
		text:SetWordWrap(true)

		return text:GetStringHeight()
	end
end

-- line text for dungeons
local function SetDungeonLineText(text, criteriaString, current, required, complete)
	if not db then
		return
	end
	local lineText = nil
	if criteriaString then
		color = db.font.color.text.class and mMT.ClassColor or db.font.color.text

		if complete then
			color = db.font.color.complete

			lineText = color.hex .. criteriaString .. "|r"
		else
			if current and required then
				lineText = db.font.color.bad.hex .. current .. "/" .. required .. "|r" .. "  " .. criteriaString
			elseif current then
				lineText = db.font.color.bad.hex .. current .. "%|r" .. "  " .. criteriaString
			else
				lineText = db.font.color.bad.hex .. criteriaString
			end
		end

		fontsize = db.font.fontsize.text

		text:SetFont(LSM:Fetch("font", db.font.font), fontsize, db.font.fontflag)
		text:SetTextColor(color.r, color.g, color.b)

		text:SetText(lineText)
		text:SetWordWrap(true)

		return text:GetStringHeight()
	end
end

-- skin Objectives
local function SkinObjective(_, block, objectiveKey)
	if not db then
		return
	end
	if block then
		-- title text
		if block.HeaderText then
			SetTitleText(block.HeaderText)
		end

		if block.currentLine then
			-- title text else line text
			if block.currentLine.objectiveKey == 0 then
				SetTitleText(block.currentLine.Text)
			else
				-- done icon
				local check = block.currentLine.Check
				local isShownCheck = false
				if check then
					isShownCheck = true
					check:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
					check:SetVertexColor(db.font.color.good.r, db.font.color.good.g, db.font.color.good.b, 1)
				end

				-- line text
				-- is quest completed
				local complete = block.currentLine.state or (objectiveKey == "QuestComplete") or block.currentLine.finished
				local text = block.currentLine.Text
				if text then
					local height = SetLineText(text, complete, isShownCheck)

					-- set the text/ line height
					if height and height ~= text:GetHeight() then
						text:SetHeight(height)
					end
				end

				-- settings if dash is hide
				if db.settings.hidedash then
					-- hide dash
					local dash = block.currentLine.Dash
					if dash then
						dash:Hide()
						dash:SetText(nil)
					end

					-- new position for text
					if text then
						text:ClearAllPoints()
						text:Point("TOPLEFT", dash, "TOPLEFT", 0, 0)
					end

					-- new position for done icon
					if check then
						check:ClearAllPoints()
						check:Point("TOPRIGHT", dash, "TOPLEFT", 0, 0)
					end
				end
			end
		end
	end
end

local function SkinDungeonsUpdateCriteria(_, numCriteria, block)
	if not db then
		return
	end

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
					if db.dungeon.hidedash then
						icon:Hide()
					else
						icon:Show()
						if existingLine.completed then
							icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
							icon:SetVertexColor(db.font.color.complete.r, db.font.color.complete.g, db.font.color.complete.b, 1)
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
	if not db then
		return
	end
	-- get dungeon time limits
	if not block.mMT_Timers then
		block.mMT_Timers = {}
		block.mMT_Timers.chest3 = block.timeLimit * 0.6
		block.mMT_Timers.chest2 = block.timeLimit * 0.8
	end

	-- timer bar color
	local colorA = db.dungeon.color.chest1.a
	local colorB = db.dungeon.color.chest1.b

	if elapsedTime < block.mMT_Timers.chest3 then
		colorA = db.dungeon.color.chest3.a
		colorB = db.dungeon.color.chest3.b
	elseif elapsedTime < block.mMT_Timers.chest2 then
		colorA = db.dungeon.color.chest2.a
		colorB = db.dungeon.color.chest2.b
	else
		colorA = db.dungeon.color.chest1.a
		colorB = db.dungeon.color.chest1.b
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
		timeLable:FontTemplate(nil, db.font.fontsize.title, db.font.fontflag)
		timeLable:SetFont(LSM:Fetch("font", db.font.font), db.font.fontsize.title, db.font.fontflag)
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
		timeText = db.font.color.bad.hex .. "+ " .. SecondsToClock(elapsedTime - block.timeLimit) .. "|r"
		block.TimeLeft:SetText(db.font.color.bad.hex .. SecondsToClock(elapsedTime) .. "|r")
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
	if not db then
		return
	end

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

		if db.dungeon.shadow then
			mMT_StageBlock:CreateShadow()
		end

		-- create difficulty label to dungeon stage block if not m+
		if not mMT_StageBlock.Difficulty and not isChallengeMode then
			local label = mMT_StageBlock:CreateFontString(nil, "OVERLAY")
			label:FontTemplate(nil, db.font.fontsize.title, db.font.fontflag)
			label:SetFont(LSM:Fetch("font", db.font.font), db.font.fontsize.title, db.font.fontflag)
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

-- set header text
local function SetHeaderText(text, isQuest)
	if not db then
		return
	end
	color = colorFont.header.class and mMT.ClassColor or colorFont.header

	local font = LSM:Fetch("font", db.font.font)
	text:SetFont(font, db.font.fontsize.header, db.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)

	if isQuest and db.settings.questcount then
		local QuestCount = ""
		local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
		QuestCount = numQuests .. "/" .. maxNumQuestsCanAccept
		text:SetText(QUESTS_LABEL .. " - " .. QuestCount)
	end
end

-- header bar
local function AddHeaderBar(header)
	local width = ObjectiveTrackerFrame:GetWidth()
	local headerBar = CreateFrame("Frame", "mMT_ObjectiveTracker_HeaderBar", header)
	headerBar:SetFrameStrata("LOW")
	headerBar:SetSize(width, 5)
	headerBar:SetPoint("BOTTOM", 0, 0)

	headerBar.texture = headerBar:CreateTexture()
	headerBar.texture:SetAllPoints(headerBar)
	headerBar.texture:SetTexture(LSM:Fetch("statusbar", db.headerbar.texture))

	if db then
		local color_HeaderBar = { r = 1, g = 1, b = 1, gradient = { a = { r = 0.8, g = 0.8, b = 0.8, a = 1 }, b = { r = 1, g = 1, b = 1, a = 1 }} }

		if db.headerbar.class then
			color_HeaderBar = mMT.ClassColor or color_HeaderBar
		else
			local c = db.headerbar.color

			color_HeaderBar = { r = c.r, g = c.g, b = c.b, gradient = { a = { r = c.r + 0.2, g = c.g + 0.2, b = c.b + 0.2, a = 1 }, b = { r = c.r - 0.2, g = c.g - 0.2, b = c.b - 0.2, a = 1 } } }
		end

		if db.headerbar.gradient and color_HeaderBar.gradient.a and color_HeaderBar.gradient.b then
			headerBar.texture:SetGradient("HORIZONTAL", color_HeaderBar.gradient.a, color_HeaderBar.gradient.b)
		else
			headerBar.texture:SetVertexColor(color_HeaderBar.r or 1, color_HeaderBar.g or 1, color_HeaderBar.b or 1, 1)
		end

		if db and db.headerbar.shadow then
			headerBar:CreateShadow()
		end
	end
end

-- skin objectivetracker bg
local function BackgroundSkin()
	if not ObjectiveTrackerFrame.NineSlice.mMT_Skin then
		ObjectiveTrackerFrame.NineSlice:SetTemplate("Transparent")
		ObjectiveTrackerFrame.NineSlice:SetFrameStrata("LOW")

		if db and db.bg.shadow then
			ObjectiveTrackerFrame.NineSlice:CreateShadow()
		end

		ObjectiveTrackerFrame.NineSlice.mMT_Skin = true
	end

	ObjectiveTrackerFrame.NineSlice:SetBackdropColor(db.bg.color.bg.r, db.bg.color.bg.g, db.bg.color.bg.b, db.bg.color.bg.a)

	if db and db.bg.border then
		ObjectiveTrackerFrame.NineSlice:SetBackdropBorderColor(db.bg.color.border.r, db.bg.color.border.g, db.bg.color.border.b, db.bg.color.border.a)
	end

	ObjectiveTrackerFrame.NineSlice:SetAlpha(db.bg.color.bg.a)
end

-- Add Quest amount text to the header
local function AddQuestNumText()
	if _G.ObjectiveTrackerBlocksFrame and _G.ObjectiveTrackerBlocksFrame.QuestHeader and _G.ObjectiveTrackerBlocksFrame.QuestHeader.Text then
		local QuestCount = ""
		local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
		QuestCount = numQuests .. "/" .. maxNumQuestsCanAccept
		_G.ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(QUESTS_LABEL .. " - " .. QuestCount)
	end
end

--  update header text and add header bar
local function UpdateHeaders()
	local Frame = ObjectiveTrackerFrame.MODULES
	if Frame then
		for i = 1, #Frame do
			local Module = Frame[i]
			if Module then
				SetHeaderText(Module.Header.Text)

				if not Module.mMT_BarAdded then
					AddHeaderBar(Module.Header)
					Module.mMT_BarAdded = true
				end
			end
		end
	end
end

local function UpdateTracker()
	-- skin objectivetracker bg
	if db and db.bg.enable then
		BackgroundSkin()
	end

	--  update header text and add header bar
	if db and db.headerbar.enable then
		UpdateHeaders()
	end

	-- Add Quest amount text to the header
	AddQuestNumText()
end

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

	SetTextColors()

	if not module.hooked then
		-- Bar Skins
		hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", SkinProgressBars)
		hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars)
		hooksecurefunc(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", SkinProgressBars)
		hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", SkinProgressBars)
		hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars)
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBars)
		hooksecurefunc(_G.UI_WIDGET_TRACKER_MODULE, "AddProgressBar", SkinProgressBars)

		-- Bar Color
		hooksecurefunc("BonusObjectiveTrackerProgressBar_SetValue", SkinBarSetValue)
		hooksecurefunc("ObjectiveTrackerProgressBar_SetValue", SkinBarSetValue)
		hooksecurefunc("ScenarioTrackerProgressBar_SetValue", SkinBarSetValue)

		-- Timer Bar Skins
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "AddTimerBar", SkinTimerBars)
		hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, "AddTimerBar", SkinTimerBars)
		hooksecurefunc(_G.ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", SkinTimerBars)

		-- Skin Text and Headers
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "AddObjective", SkinObjective)
		--hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, "AddObjective", SkinDungeons)
		hooksecurefunc(_G.ACHIEVEMENT_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.UI_WIDGET_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.PROFESSION_RECIPE_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.MONTHLY_ACTIVITIES_TRACKER_MODULE, "AddObjective", SkinObjective)
		hooksecurefunc(_G.ADVENTURE_TRACKER_MODULE, "AddObjective", SkinObjective)

		-- Skin Dungeon Text
		hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", SkinDungeonsUpdateCriteria)

		-- Skin Stage Block
		hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, "Update", SkinStageBlock)

		-- Skin M+ Timer
		hooksecurefunc("Scenario_ChallengeMode_UpdateTime", SkinChallengeModeTime)

		-- Skin Headers
		hooksecurefunc("ObjectiveTracker_Update", UpdateTracker)
	end

	module.needReloadUI = true
	module.loaded = true
end
