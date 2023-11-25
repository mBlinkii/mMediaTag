local E = unpack(ElvUI)
local LSM = E.Libs.LSM
local S = E:GetModule("Skins")

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
local IsInInstance = IsInInstance

local colorFont = {}
local color = {}
local dim = 0.2
local fontsize = 12
local mMT_elapsedTime = nil
local mMT_timeLimit = nil

local function GetRequirements(text)
	local current, required, questText = strmatch(text, "^(%d-)/(%d-) (.+)")
	if not current or not required or not questText then
		questText, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end
	return current, required, questText
end

local function SkinBarColor(Bar, r, g, b)
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

local function SkinBarSetValue(self)
	if db.bar.gradient and not self.Bar.mMT_hooked then
		hooksecurefunc(self.Bar, "SetStatusBarColor", SkinBarColor)
		self.Bar.mMT_hooked = true
	end
end

local function SkinProgressBars(_, _, line)
	local progressBar = line and line.ProgressBar
	local bar = progressBar and progressBar.Bar
	if not bar then
		return
	end

	local label = bar.Label

	bar:Height(db.bar.hight)

	if db.bar.elvbg then
		local color_barBG = E.db.general.backdropfadecolor
		bar.backdrop:SetBackdropColor(color_barBG.r, color_barBG.g, color_barBG.b, color_barBG.a)
	end

	if db.bar.gradient and not bar.mMT_hooked then
		hooksecurefunc(bar, "SetStatusBarColor", SkinBarColor)
		bar.mMT_hooked = true
	end

	if label then
		label:ClearAllPoints()
		label:SetJustifyH(db.bar.fontpoint)
		label:Point(db.bar.fontpoint, bar, db.bar.fontpoint, db.bar.fontpoint == "LEFT" and 2 or (db.bar.fontpoint == "RIGHT" and -2 or 0), 0)
		label:FontTemplate(nil, db.bar.fontsize, db.fontflag)
	end

	if db.bar.shadow and not bar.mMT_Shadow then
		bar:CreateShadow()
		bar.mMT_Shadow = true
	end
end

local function SkinTimerBars(_, _, line)
	local timerBar = line and line.TimerBar
	local bar = timerBar and timerBar.Bar

	local label = bar.Label

	bar:Height(db.bar.hight)

	if db.bar.elvbg then
		local color_barBG = E.db.general.backdropfadecolor
		bar.backdrop:SetBackdropColor(color_barBG.r, color_barBG.g, color_barBG.b, color_barBG.a)
	end

	if db.bar.gradient and not bar.mMT_hooked then
		hooksecurefunc(bar, "SetStatusBarColor", SkinBarColor)
		bar.mMT_hooked = true
	end

	if label then
		label:ClearAllPoints()
		label:SetJustifyH(db.bar.fontpoint)
		label:Point(db.bar.fontpoint, bar, db.bar.fontpoint, db.bar.fontpoint == "LEFT" and 2 or (db.bar.fontpoint == "RIGHT" and -2 or 0), 0)
		label:FontTemplate(nil, db.bar.fontsize, db.fontflag)
	end

	if db.bar.shadow and not bar.mMT_Shadow then
		bar:CreateShadow()
		bar.mMT_Shadow = true
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
end

local function SetLineText(text, completed, check)
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
			-- local doneIcon = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga:16:16:0:0:16:16:0:16:0:16"
			-- doneIcon = doneIcon .. ":" .. tostring(mMT:round(db.font.color.good.r * 255)) .. ":" .. tostring(mMT:round(db.font.color.good.g * 255)) .. ":" .. tostring(mMT:round(db.font.color.good.b * 255)) .. "|t"
			-- lineText = doneIcon .. lineText
		end

		text:SetText(lineText)
		text:SetWordWrap(true)

		return text:GetStringHeight()
	end
end

local function SetDungeonLineText(text, complete, time)
	local lineText = text:GetText()
	if lineText then
		color = db.font.color.text.class and mMT.ClassColor or db.font.color.text
		local current, required, questText = GetRequirements(lineText)
		if complete then
			color = db.font.color.complete
			if time then
				mMT:Print("JAAA", time)
				lineText = color.hex .. (questText or lineText) .. "|r" .. " [" .. SecondsToClock(time) .. "]"
			else
				lineText = color.hex .. (questText or lineText) .. "|r"
			end
		else
			if current and required and questText then
				lineText = db.font.color.bad.hex .. current .. "/" .. required .. "|r" .. "  " .. questText
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

local function SkinObjective(_, block, objectiveKey, _, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)
	if block then
		if block.HeaderText then
			SetHeaderText(block.HeaderText)
		end

		if block.currentLine then
			if block.currentLine.objectiveKey == 0 then
				SetHeaderText(block.currentLine.Text)
			else
				local check = block.currentLine.Check
				local isShownCheck = false
				if check then
					isShownCheck = true
					check:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
					check:SetVertexColor(db.font.color.good.r, db.font.color.good.g, db.font.color.good.b, 1)
				end

				-- worldquest check, needs mor testing did not work
				-- local icon = block.currentLine.Icon
				-- if icon then
				-- 	isShownCheck = true
				-- 	icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
				-- 	icon:SetVertexColor(db.font.color.good.r, db.font.color.good.g, db.font.color.good.b, 1)
				-- 	icon:Hide()
				-- end

				local complete = block.currentLine.state or (objectiveKey == "QuestComplete") or block.currentLine.finished
				local text = block.currentLine.Text
				if text then
					local height = SetLineText(text, complete, isShownCheck)

					if height and height ~= text:GetHeight() then
						text:SetHeight(height)
					end
				end

				if db.settings.hidedash then
					local dash = block.currentLine.Dash

					if dash then
						dash:Hide()
						dash:SetText(nil)
					end

					if text then
						text:ClearAllPoints()
						text:Point("TOPLEFT", dash, "TOPLEFT", 0, 0)
					end

					if check then
						check:ClearAllPoints()
						check:Point("TOPRIGHT", dash, "TOPLEFT", 0, 0)
					end

					-- if icon then
					-- 	icon:ClearAllPoints()
					-- 	icon:Point("TOPRIGHT", dash, "TOPLEFT", 0, 0)
					-- end
				end
			end
		end
	end
end

local function isChallengeModeActive()
	return C_MythicPlus.IsMythicPlusActive() and C_ChallengeMode.GetActiveChallengeMapID()
end

local function SkinDungeonsUpdateCriteria(_, numCriteria, block)
	if block then
		for criteriaIndex = 1, numCriteria do
			local existingLine = block.lines[criteriaIndex]
			if existingLine then
				local text = existingLine.Text
				if text then
					local time = nil
					mMT:Print(mMT_elapsedTime)

					if mMT_elapsedTime and mMT_timeLimit and isChallengeModeActive() then
						time = mMT_timeLimit - mMT_elapsedTime
					end

					local height = SetDungeonLineText(text, existingLine.completed, time)

					if height and height ~= text:GetHeight() then
						text:SetHeight(height)
					end
				end

				local icon = existingLine.Icon
				if icon and existingLine.completed then
					if db.dungeon.hidedash then
						icon:Show()
					end
					icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questDone.tga")
					icon:SetVertexColor(db.font.color.complete.r, db.font.color.complete.g, db.font.color.complete.b, 1)
				else
					if db.dungeon.hidedash then
						icon:Hide()
					else
						icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\questMinus.tga")
						icon:SetVertexColor(mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, 1)
					end
				end
			end
		end
	end
end

local function SkinChallengeModeTime(block, elapsedTime)
	if not block.mMT_Timers then
		block.mMT_Timers = {}
		block.mMT_Timers.chest3 = block.timeLimit * 0.6
		block.mMT_Timers.chest2 = block.timeLimit * 0.8
		mMT_timeLimit = block.timeLimit
	end

	mMT_elapsedTime = elapsedTime

	-- if block.Affixes and not block.Affixes.mMT_Skin then
	-- 	local num = #block.Affixes
	-- 	local leftPoint = 30 + (4 * (num - 1)) + (22 * num);
	-- 	block.Affixes[1]:ClearAllPoints()
	-- 	block.Affixes[1]:SetPoint("TOPRIGHT", block.mMT_StageBlock, "TOPRIGHT", -leftPoint, -10)

	-- 	-- for i = 1, num do
	-- 	-- 	local affixFrame = block.Affixes[i]
	-- 	-- 	local prev = block.Affixes[i - 1]
	-- 	-- 	affixFrame:ClearAllPoints()
	-- 	-- 	affixFrame:SetPoint("LEFT", prev, "RIGHT", 4, 0)
	-- 	-- end

	-- 	block.Affixes.mMT_Skin = true
	-- end

	-- timer bar color
	local colorA = db.font.color.good
	local colorB = db.font.color.good
	if elapsedTime < block.mMT_Timers.chest3 and not block.StatusBar.mMT_Skin == 3 then
		colorA = db.font.color.good
		colorB = db.font.color.transit
		block.StatusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = colorB.r, g = colorB.g, b = colorB.b, a = 1 }, { r = colorA.r, g = colorA.g, b = colorA.b, a = 1 })
	elseif elapsedTime < block.mMT_Timers.chest2 and not block.StatusBar.mMT_Skin == 2 then
		colorA = db.font.color.transit
		colorB = db.font.color.bad
		block.StatusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = colorB.r, g = colorB.g, b = colorB.b, a = 1 }, { r = colorA.r, g = colorA.g, b = colorA.b, a = 1 })
	elseif not block.StatusBar.mMT_Skin == 1 then
		colorA = db.font.color.bad
		colorB = { r = colorA.r - 0.2, g = colorA.g - 0.2, b = colorA.r - 0.2 }
		block.StatusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", { r = colorB.r, g = colorB.g, b = colorB.b, a = 1 }, { r = colorA.r, g = colorA.g, b = colorA.b, a = 1 })
	end

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

	if not block.mMT_Time then
		local timeLable = block.StatusBar:CreateFontString(nil, "OVERLAY")
		timeLable:FontTemplate(nil, db.font.fontsize.title, db.font.fontflag)
		timeLable:SetFont(LSM:Fetch("font", db.font.font), db.font.fontsize.title, db.font.fontflag)
		timeLable:SetPoint("BOTTOMRIGHT", block.StatusBar, "TOPRIGHT", -2, 2)
		timeLable:SetJustifyH("RIGHT")
		timeLable:SetJustifyV("TOP")
		block.mMT_Time = timeLable
	end

	local timeText = nil

	if elapsedTime < block.mMT_Timers.chest3 then
		timeText = "+3 " .. SecondsToClock(block.mMT_Timers.chest3 - elapsedTime)
	elseif elapsedTime < block.mMT_Timers.chest2 then
		timeText = "+2 " .. SecondsToClock(block.mMT_Timers.chest2 - elapsedTime)
	elseif elapsedTime > block.timeLimit then
		timeText = db.font.color.bad.hex .. "+ " .. SecondsToClock(elapsedTime - block.timeLimit) .. "|r"
		block.TimeLeft:SetText(db.font.color.bad.hex .. SecondsToClock(elapsedTime) .. "|r")
	end

	if timeText then
		block.mMT_Time:SetText(timeText)
	end
end

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

	if isChallengeMode then
		StageBlock.Level:SetText(mMT:GetDungeonInfo(false, true, true))
	end

	if not StageBlock.mMT_StageBlock then
		local mMT_StageBlock = CreateFrame("Frame", "mMT_StageBlock")
		local width = _G.ObjectiveTrackerFrame:GetWidth()
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

		if not mMT_StageBlock.Difficulty and isChallengeMode then
			local label = mMT_StageBlock:CreateFontString(nil, "OVERLAY")
			label:FontTemplate(nil, db.font.fontsize.title, db.font.fontflag)
			label:SetFont(LSM:Fetch("font", db.font.font), db.font.fontsize.title, db.font.fontflag)
			label:Point("TOPRIGHT", mMT_StageBlock, "TOPRIGHT", -10, -10)
			label:SetJustifyH("RIGHT")
			label:SetJustifyV("TOP")
			mMT_StageBlock.Difficulty = label
		end

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
	end

	if IsInInstance() and StageBlock.mMT_StageBlock and StageBlock.mMT_StageBlock.Difficulty then
		if not isChallengeMode then
			StageBlock.mMT_StageBlock.Difficulty:SetText(mMT:GetDungeonInfo(false, false, true))
		end
	end
end

local function SetTitleText(text, isQuest)
	color = colorFont.title.class and mMT.ClassColor or colorFont.title

	local font = LSM:Fetch("font", db.font.font)
	text:SetFont(font, db.font.fontsize.title, db.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)

	if isQuest and db.settings.questcount then
		local QuestCount = ""
		local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
		QuestCount = numQuests .. "/" .. maxNumQuestsCanAccept
		text:SetText(QUESTS_LABEL .. " - " .. QuestCount)
	end
end

local function AddHeaderBar(header)
	local width = _G.ObjectiveTrackerFrame:GetWidth()
	local headerBar = CreateFrame("Frame", "mMT_ObjectiveTracker_HeaderBar", header)
	headerBar:SetFrameStrata("BACKGROUND")
	headerBar:SetSize(width, 5)
	headerBar:SetPoint("BOTTOM", 0, 0)

	headerBar.texture = headerBar:CreateTexture()
	headerBar.texture:SetAllPoints(headerBar)
	headerBar.texture:SetTexture(LSM:Fetch("statusbar", db.headerbar.texture))

	local color_HeaderBar = db.headerbar.class and mMT.ClassColor or db.headerbar.color

	if db.headerbar.gradient then
		headerBar.texture:SetGradient("HORIZONTAL", { r = color_HeaderBar.r - 0.2, g = color_HeaderBar.g - 0.2, b = color_HeaderBar.b - 0.2, a = color_HeaderBar.a or 1 }, { r = color_HeaderBar.r + 0.2, g = color_HeaderBar.g + 0.2, b = color_HeaderBar.b + 0.2, a = color_HeaderBar.a or 1 })
	else
		headerBar.texture:SetVertexColor(color_HeaderBar.r, color_HeaderBar.g, color_HeaderBar.b, 1)
	end

	if db.headerbar.shadow then
		headerBar:CreateShadow()
	end
end

local function UpdateHeaders()
	local Frame = ObjectiveTrackerFrame.MODULES
	if Frame then
		for i = 1, #Frame do
			local Module = Frame[i]
			if Module then
				SetTitleText(Module.Header.Text)

				if db.headerbar.enable and not Module.mMT_BarAdded then
					AddHeaderBar(Module.Header)
					Module.mMT_BarAdded = true
				end
			end
		end
	end

	if _G.ObjectiveTrackerBlocksFrame and _G.ObjectiveTrackerBlocksFrame.QuestHeader and _G.ObjectiveTrackerBlocksFrame.QuestHeader.Text then
		local QuestCount = ""
		local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
		QuestCount = numQuests .. "/" .. maxNumQuestsCanAccept
		_G.ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(QUESTS_LABEL .. " - " .. QuestCount)
	end
end

function module:Initialize()
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
		hooksecurefunc("ObjectiveTracker_Update", UpdateHeaders)
	end

	module.needReloadUI = true
	module.loaded = true
end
