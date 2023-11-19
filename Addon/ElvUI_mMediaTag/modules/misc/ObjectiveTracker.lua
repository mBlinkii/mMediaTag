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

local colorFont = {}
local color = {}
local dim = 0.2
local fontsize = 12

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
		if not completed and not check then
			local current, required, questText = GetRequirements(lineText)

			if current and required and questText then
				if current == required then
					lineText = questText
				else
					local progressPercent = (tonumber(current) / tonumber(required)) * 100 or 0

					local colorGood = db.font.color.good
					local colorTransit = db.font.color.transit
					local colorBad = db.font.color.bad
					local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
					local colorProgress = E:RGBToHex(r, g, b)
					progressPercent = format("%.f%%", progressPercent)
					lineText = colorProgress .. current .. "/" .. required .. " - " .. progressPercent .. "|r" .. "  " .. questText
				end
			end
		else
			local _, _, questText = GetRequirements(lineText)
			if questText then
				lineText = questText
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

local function SetDungeonLineText(text, complete)
	local lineText = text:GetText()
	if lineText then
		color = db.font.color.text.class and mMT.ClassColor or db.font.color.text
		local current, required, questText = GetRequirements(lineText)
		if complete then
			color = db.font.color.complete
			lineText = color.hex .. (questText or lineText) .. "|r"
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

		return text:GetStringHeight(), complete
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

				local complete = block.currentLine.state or (objectiveKey == "QuestComplete")
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
				end
			end
		end
	end
end

local function SkinDungeons(_, block, objectiveKey, _, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)
	--mMT:Print(a, b, c, _, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)
	--SkinObjective(block, objectiveKey)
	--mMT:DebugPrintTable(c)
	if block then
		if block.HeaderText then
			SetHeaderText(block.HeaderText)
		end
		if block.currentLine then
			if block.currentLine.objectiveKey == 0 then
				SetHeaderText(block.currentLine.Text)
			else
				--mMT:Print(objectiveKey)
				local text = block.currentLine.Text
				if text then
					local height = SetDungeonLineText(text)

					if height and height ~= text:GetHeight() then
						text:SetHeight(height)
					end
				end

				-- if db.settings.hidedash then
				-- 	local dash = block.currentLine.Dash

				-- 	if dash then
				-- 		dash:Hide()
				-- 		dash:SetText(nil)
				-- 	end

				-- 	if text then
				-- 		text:ClearAllPoints()
				-- 		text:Point("TOPLEFT", dash, "TOPLEFT", 0, 0)
				-- 	end

				-- 	if check then
				-- 		check:ClearAllPoints()
				-- 		check:Point("TOPRIGHT", dash, "TOPLEFT", 0, 0)
				-- 	end
				-- end
			end
		end
	end
end

local function SkinDungeonsUpdateCriteria(_, numCriteria, block)
	if block then
		for criteriaIndex = 1, numCriteria do
			local existingLine = block.lines[criteriaIndex]
			if existingLine then
				local text = existingLine.Text
				if text then
					local height = SetDungeonLineText(text, existingLine.completed)

					if height and height ~= text:GetHeight() then
						text:SetHeight(height)
					end
				end

				local icon = existingLine.Icon
				if icon and existingLine.completed then
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

function SkinStageBlock(stageDescription, stageBlock, objectiveBlock, BlocksFrame, j, l)
	mMT:Print(stageDescription, stageBlock, objectiveBlock, BlocksFrame, j, l)
	-- if not self:ShouldShowCriteria() then
	-- 	return;
	-- end

	-- -- A progress bar here is the entire tree for scenarios
	-- SCENARIO_TRACKER_MODULE.lineSpacing = 2;
	-- SCENARIO_TRACKER_MODULE:AddObjective(objectiveBlock, 1, stageDescription);
	-- objectiveBlock.currentLine.Icon:Hide();
	-- local progressBar = SCENARIO_TRACKER_MODULE:AddProgressBar(objectiveBlock, objectiveBlock.currentLine);
	-- objectiveBlock:SetHeight(objectiveBlock.height);
	-- if ( ObjectiveTracker_AddBlock(objectiveBlock) ) then
	-- 	if ( not BlocksFrame.slidingAction ) then
	-- 		objectiveBlock:Show();
	-- 	end
	-- else
	-- 	objectiveBlock:Hide();
	-- 	stageBlock:Hide();
	-- end

	-- if not _G.ScenarioStageBlock.mMTSkin then
	-- 	local DungeonBG = CreateFrame("Frame", "mMT_ScenarioBlock")
	-- 	S:HandleFrame(DungeonBG)
	-- 	DungeonBG:SetParent(_G.ScenarioStageBlock)
	-- 	DungeonBG:ClearAllPoints()
	-- 	DungeonBG:SetPoint("CENTER", _G.ScenarioStageBlock, "CENTER", 27, 0)
	-- 	DungeonBG:SetSize(width + 2, 80)
	-- 	DungeonBG:SetFrameLevel(3)
	-- 	DungeonBG:Show()

	-- 	_G.ScenarioStageBlock.mMTSkin = true
	-- end

	-- _G.ScenarioStageBlock.NormalBG:Hide()
	-- _G.ScenarioStageBlock.FinalBG:Hide()
	-- -- if _G.ScenarioStageBlock.WidgetContainer then
	-- -- 	_G.ScenarioStageBlock.WidgetContainer:Hide()
	-- -- end

	-- local container = _G.ScenarioStageBlock.WidgetContainer
	-- if not container or not container.widgetFrames then
	-- 	return
	-- end

	-- for _, widgetFrame in pairs(container.widgetFrames) do
	-- 	if widgetFrame.Frame then
	-- 		widgetFrame.Frame:SetAlpha(0)
	-- 	end
	-- end

	-- [16:35] 0 userdata: 000001747DA41ED8
	-- [16:35] WidgetContainer table: 0000017494C22E10
	-- [16:35] FinalBG table: 0000017494C22C30
	-- [16:35] appliedAlready true
	-- [16:35] CompleteLabel table: 0000017494C22D70
	-- [16:35] module table: 0000017494C21380
	-- [16:35] Name table: 0000017494C22DC0
	-- [16:35] nextBlock table: 0000017494C22AA0
	-- [16:35] height 83.000007629395
	-- [16:35] GlowTexture table: 0000017494C22C80
	-- [16:35] Stage table: 0000017494C22D20
	-- [16:35] NormalBG table: 0000017494C22BE0
	-- [16:35] mMediaTag & Tools: table: 0000017494C20FC0 nil nil nil nil nil
	local StageBlock = _G.ScenarioStageBlock

	StageBlock.NormalBG:Hide()
	StageBlock.FinalBG:Hide()

	if not StageBlock.mMT_StageBlock then
		-- dungeon = {
		-- 	hidedash = true,
		-- 	color = {
		-- 		normal = { r = 0.24, g = 0.24, b = 0.24, a = 1},
		-- 		complete = { r = 0, g = 1, b = 0.27, a = 1},
		-- 	}
		-- },

		local mMT_StageBlock = CreateFrame("Frame", "mMT_StageBlock")
		local width = _G.ObjectiveTrackerFrame:GetWidth()
		S:HandleFrame(mMT_StageBlock)

		mMT_StageBlock:SetParent(_G.ScenarioStageBlock)
		mMT_StageBlock:ClearAllPoints()
		mMT_StageBlock:SetPoint("TOPLEFT", 10, -5)

		mMT_StageBlock:SetSize(width, 80)
		mMT_StageBlock:SetFrameLevel(3)
		mMT_StageBlock:Show()

		if db.dungeon.shadow then
			mMT_StageBlock:CreateShadow()
		end

		local label = mMT_StageBlock:CreateFontString(nil, "OVERLAY")
		label:FontTemplate(nil, db.font.fontsize.title, db.font.fontflag)
		label:SetFont(LSM:Fetch("font", db.font.font), db.font.fontsize.title, db.font.fontflag)
		label:SetText(mMT:GetDungeonInfo(true, true))
		label:Point("TOPRIGHT", mMT_StageBlock, "TOPRIGHT", -10, -10)
		label:SetTextColor(color.r, color.g, color.b)
		label:SetJustifyH("RIGHT")
		label:SetJustifyV("TOP")

		mMT_StageBlock.Difficulty = label

		StageBlock.Stage:ClearAllPoints()
		StageBlock.Stage:SetPoint("LEFT", mMT_StageBlock, "LEFT", 10, 2)

		--mMT:DebugPrintTable(StageBlock)
		StageBlock.mMT_StageBlock = mMT_StageBlock
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

		-- Skin Headers
		hooksecurefunc("ObjectiveTracker_Update", UpdateHeaders)
	end

	module.needReloadUI = true
	module.loaded = true
end
