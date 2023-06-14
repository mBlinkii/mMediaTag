local E = unpack(ElvUI)
local LSM = E.Libs.LSM

-- Lib Globals
local format = format

-- WoW Globals
local _G = _G
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
local ObjectiveTrackerBlocksFrame = _G.ObjectiveTrackerBlocksFrame
local maxNumQuestsCanAccept = 35 --MAX_QUESTS
local HeaderTitel = ObjectiveTrackerBlocksFrame.QuestHeader.Text:GetText()
local width = _G.ObjectiveTrackerFrame:GetWidth()

local function mDashIcon(icon)
	return format("|T%s:8:8:-1:-3.8:64:64|t", icon)
end

local mOTFont = nil
local mOTFontFlag = nil
local c = { r = 1, g = 1, b = 1 }

local function mGetFont()
	mOTFont = LSM:Fetch("font", E.db.mMT.objectivetracker.font)
	mOTFontFlag = E.db.mMT.objectivetracker.fontflag
end

local function mBackdropBars(self, value)
	if not (self.Bar and self.isSkinned and value) then
		return
	end
	self.Bar.backdrop:SetBackdropColor(
		E.db.general.backdropfadecolor.r,
		E.db.general.backdropfadecolor.g,
		E.db.general.backdropfadecolor.b,
		E.db.general.backdropfadecolor.a
	)
end

local function mSetupHeaderFont(headdertext)
	if headdertext then
		local QuestCount = E.db.mMT.objectivetracker.header.questcount
		mGetFont()

		if E.db.mMT.objectivetracker.header.fontcolorstyle == "class" then
			c = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
		else
			c = E.db.mMT.objectivetracker.header.fontcolor
		end

		if QuestCount ~= "none" then
			local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
			local QuestCountText = format("%s/%s", numQuests, maxNumQuestsCanAccept)

			if (QuestCount == "colorleft") or (QuestCount == "colorright") then
				local cg = E.db.mMT.objectivetracker.text.progresscolorgood
				local ct = E.db.mMT.objectivetracker.text.progresscolortransit
				local cb = E.db.mMT.objectivetracker.text.progresscolorbad
				local tmpPercent = mMT:round((tonumber(numQuests) / tonumber(maxNumQuestsCanAccept)) * 100 or 0)
				local r, g, b = E:ColorGradient(tmpPercent * 0.01, cg.r, cg.g, cg.b, ct.r, ct.g, ct.b, cb.r, cb.g, cb.b)
				local CountColorString = E:RGBToHex(r, g, b)

				if QuestCount == "colorleft" then
					ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(
						format("[%s%s|r] %s", CountColorString, QuestCountText, HeaderTitel)
					)
				elseif QuestCount == "colorright" then
					ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(
						format("%s [%s%s|r]", HeaderTitel, CountColorString, QuestCountText)
					)
				end
			elseif QuestCount == "left" then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("[%s] %s", QuestCountText, HeaderTitel))
			elseif QuestCount == "right" then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("%s [%s]", HeaderTitel, QuestCountText))
			end
		end

		headdertext:SetFont(mOTFont, E.db.mMT.objectivetracker.header.fontsize, mOTFontFlag)
		headdertext:SetTextColor(c.r, c.g, c.b)

		if E.db.mMT.objectivetracker.header.textshadow then
			headdertext:SetShadowOffset(1, -1)
		else
			headdertext.SetShadowColor = function() end
		end

		headdertext:SetWordWrap(true)

		local TextHight = headdertext:GetStringHeight()
		if headdertext:GetHeight() ~= TextHight then
			headdertext:SetHeight(TextHight)
		end
	end
end

local function mSetupTitleFont(titletext)
	if titletext then
		mGetFont()
		if E.db.mMT.objectivetracker.title.fontcolorstyle == "class" then
			c = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
		else
			c = E.db.mMT.objectivetracker.title.fontcolor
		end
		titletext:SetFont(mOTFont, E.db.mMT.objectivetracker.title.fontsize, mOTFontFlag)
		titletext:SetTextColor(c.r, c.g, c.b)

		if E.db.mMT.objectivetracker.title.textshadow then
			titletext:SetShadowOffset(1, -1)
		else
			titletext.SetShadowColor = function() end
		end

		titletext:SetWordWrap(true)

		local TextHight = titletext:GetStringHeight()
		if titletext:GetHeight() ~= TextHight then
			titletext:SetHeight(TextHight)
		end
	end
end

local function mSetupQuestFont(linetext, state)
	if linetext then
		mGetFont()
		if E.db.mMT.objectivetracker.text.fontcolorstyle == "class" then
			c = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
		elseif state == "COMPLETED" then
			c = E.db.mMT.objectivetracker.text.completecolor
		else
			c = E.db.mMT.objectivetracker.text.fontcolor
		end
		linetext:SetFont(mOTFont, E.db.mMT.objectivetracker.text.fontsize, mOTFontFlag)

		linetext:SetTextColor(c.r, c.g, c.b)

		if E.db.mMT.objectivetracker.text.textshadow then
			linetext:SetShadowOffset(1, -1)
		else
			linetext.SetShadowColor = function() end
		end

		linetext:SetWordWrap(true)
		local TextHight = linetext:GetStringHeight()
		if linetext:GetHeight() ~= TextHight then
			linetext:SetHeight(TextHight)
		end
	end
end

local function SetGradientColors(bar, r, g, b)
	if mMT.ElvUI_EltreumUI.loaded and E.db.ElvUI_EltreumUI.unitframes.gradientmode and E.db.mMT.objectivetracker.header.barcolorstyle == "class" then
		local ElvUI_EltreumUI = E:GetModule("ElvUI_EltreumUI", true)
		if ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes.gradientmode.customcolor then
			bar:GetStatusBarTexture()
				:SetGradient("HORIZONTAL", ElvUI_EltreumUI:GradientColorsCustom(E.myclass, false, false, false))
		else
			bar:GetStatusBarTexture()
				:SetGradient("HORIZONTAL", ElvUI_EltreumUI:GradientColors(E.myclass, false, false, false))
		end
	else
		if E.db.mMT.objectivetracker.header.revers then
			bar:GetStatusBarTexture()
				:SetGradient("HORIZONTAL", CreateColor(r, g, b, 1), CreateColor(r - 0.4, g - 0.4, b - 0.4, 1))
		else
			bar:GetStatusBarTexture()
				:SetGradient("HORIZONTAL", CreateColor(r - 0.4, g - 0.4, b - 0.4, 1), CreateColor(r, g, b, 1))
		end
	end
end
local function mCreatBar(modul)
	local BarColorStyle, BarColor, BarShadow = "class", { r = 1, g = 1, b = 1 }, true
	if E.db.mMT.objectivetracker.header.barstyle ~= "none" then
		BarStyle = E.db.mMT.objectivetracker.header.barstyle
		BarColor = E.db.mMT.objectivetracker.header.barcolor
		BarColorStyle = E.db.mMT.objectivetracker.header.barcolorstyle
		BarShadow = E.db.mMT.objectivetracker.header.barshadow
		if BarColorStyle == "class" then
			BarColor = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
		end
		local BarTexture = LSM:Fetch("statusbar", E.db.mMT.objectivetracker.header.texture)

		local mBarOne = CreateFrame("StatusBar", "mMT_BarOne", modul)
		mBarOne:SetFrameStrata("BACKGROUND")
		if (BarStyle == "onebig") or (BarStyle == "twobig") then
			mBarOne:SetSize(width, 5)
		else
			mBarOne:SetSize(width, 1)
		end
		mBarOne:SetPoint("BOTTOM", 0, 0)
		mBarOne:SetStatusBarTexture(BarTexture)
		if E.db.mMT.objectivetracker.header.gradient then
			SetGradientColors(mBarOne, BarColor.r, BarColor.g, BarColor.b)
		else
			mBarOne:SetStatusBarColor(BarColor.r, BarColor.g, BarColor.b)
		end
		mBarOne:CreateBackdrop()

		if BarShadow then
			mBarOne:CreateShadow()
		end

		if (BarStyle == "two") or (BarStyle == "twobig") then
			local mBarTwo = CreateFrame("StatusBar", "mMT_BarTwo", modul)
			mBarTwo:SetFrameStrata("BACKGROUND")
			if BarStyle == "twobig" then
				mBarTwo:SetSize(width, 5)
			else
				mBarTwo:SetSize(width, 1)
			end
			mBarTwo:SetPoint("TOP", 0, 0)
			mBarTwo:SetStatusBarTexture(BarTexture, BarColor.r, BarColor.g, BarColor.b)
			if E.db.mMT.objectivetracker.header.gradient then
				SetGradientColors(mBarTwo)
			else
				mBarTwo:SetStatusBarColor(BarColor.r, BarColor.g, BarColor.b)
			end
			mBarTwo:CreateBackdrop()

			if BarShadow then
				mBarTwo:CreateShadow()
			end
		end
	end
end

local function SkinQuestText(text)
	local QuestCount = E.db.mMT.objectivetracker.header.questcount
	if QuestCount ~= "none" then
		local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
		local QuestCountText = format("%s/%s", numQuests, maxNumQuestsCanAccept)

		if (QuestCount == "colorleft") or (QuestCount == "colorright") then
			local cg = E.db.mMT.objectivetracker.text.progresscolorgood
			local ct = E.db.mMT.objectivetracker.text.progresscolortransit
			local cb = E.db.mMT.objectivetracker.text.progresscolorbad
			local tmpPercent = mMT:round((tonumber(numQuests) / tonumber(maxNumQuestsCanAccept)) * 100 or 0)
			local r, g, b = E:ColorGradient(tmpPercent * 0.01, cg.r, cg.g, cg.b, ct.r, ct.g, ct.b, cb.r, cb.g, cb.b)
			local CountColorString = E:RGBToHex(r, g, b)

			if QuestCount == "colorleft" then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(
					format("[%s%s|r] %s", CountColorString, QuestCountText, HeaderTitel)
				)
			elseif QuestCount == "colorright" then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(
					format("%s [%s%s|r]", HeaderTitel, CountColorString, QuestCountText)
				)
			end
		elseif QuestCount == "left" then
			ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("[%s] %s", QuestCountText, HeaderTitel))
		elseif QuestCount == "right" then
			ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("%s [%s]", HeaderTitel, QuestCountText))
		end
	end

	local current, required, details = strmatch(text, "^(%d-)/(%d-) (.+)")
	if (current == nil) or (required == nil) or (details == nil) then
		details, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end

	if (current == nil) or (required == nil) or (details == nil) then
		return
	end

	if (current ~= nil) or (required ~= nil) or (details ~= nil) then
		local tmpPercent = mMT:round((tonumber(current) / tonumber(required)) * 100 or 0)

		if E.db.mMT.objectivetracker.text.progresscolor then
			local cg = E.db.mMT.objectivetracker.text.progresscolorgood
			local ct = E.db.mMT.objectivetracker.text.progresscolortransit
			local cb = E.db.mMT.objectivetracker.text.progresscolorbad
			local r, g, b = E:ColorGradient(tmpPercent * 0.01, cb.r, cb.g, cb.b, ct.r, ct.g, ct.b, cg.r, cg.g, cg.b)
			local ColorString = E:RGBToHex(r, g, b)

			if
				E.db.mMT.objectivetracker.text.progresscolor
				and E.db.mMT.objectivetracker.text.progrespercent
				and (tonumber(required) >= 2)
			then
				if E.db.mMT.objectivetracker.text.cleantext then
					return format(
						"%s%s/%s|r - %s%s|r %s",
						ColorString,
						current,
						required,
						ColorString,
						tmpPercent .. "%",
						details
					)
				else
					return format(
						"%s%s/%s|r - %s%s|r %s",
						ColorString,
						current,
						required,
						ColorString,
						tmpPercent .. "%",
						details
					)
				end
			else
				if E.db.mMT.objectivetracker.text.cleantext then
					return format("%s%s/%s|r %s", ColorString, current, required, details)
				else
					return format("[%s%s/%s|r] %s", ColorString, current, required, details)
				end
			end
		else
			if E.db.mMT.objectivetracker.text.progrespercent and (tonumber(required) >= 2) then
				if E.db.mMT.objectivetracker.text.cleantext then
					return format("%s/%s - %s %s", current, required, tmpPercent .. "%", details)
				else
					return format("[%s/%s] - %s %s", current, required, tmpPercent .. "%", details)
				end
			else
				if E.db.mMT.objectivetracker.text.cleantext then
					return format("%s/%s %s", current, required, details)
				else
					return format("[%s/%s] %s", current, required, details)
				end
			end
		end
	else
		return text
	end
end

local function SkinScenarioText(text)
	local current, required, details = strmatch(text, "^(%d-)/(%d-) (.+)")
	if (current == nil) or (required == nil) or (details == nil) then
		details, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end

	if (current ~= nil) or (required ~= nil) or (details ~= nil) then
		local cg = E.db.mMT.objectivetracker.text.progresscolorgood.hex
		local cb = E.db.mMT.objectivetracker.text.progresscolorbad.hex

		if E.db.mMT.objectivetracker.text.cleantext then
			if current == required then
				return format("%s%s/%s %s|r", cg, current, required, details)
			else
				return format("%s%s/%s|r %s", cb, current, required, details)
			end
		else
			if current == required then
				return format("%s[%s/%s] %s|r", cg, current, required, details)
			else
				return format("[%s%s/%s|r] %s", cb, current, required, details)
			end
		end
	else
		return text
	end
end

local S = E:GetModule("Skins")
local function SkinOBTScenarioBlock()
	if not _G.ScenarioStageBlock.mMTSkin then
		local DungeonBG = CreateFrame("Frame", "mMT_ScenarioBlock")
		S:HandleFrame(DungeonBG)
		DungeonBG:SetParent(_G.ScenarioStageBlock)
		DungeonBG:ClearAllPoints()
		DungeonBG:SetPoint("CENTER", _G.ScenarioStageBlock, "CENTER", 27, 0)
		DungeonBG:SetSize(width + 2, 80)
		DungeonBG:SetFrameLevel(3)
		DungeonBG:Show()

		_G.ScenarioStageBlock.mMTSkin = true
	end

	_G.ScenarioStageBlock.NormalBG:Hide()
	_G.ScenarioStageBlock.FinalBG:Hide()
	if _G.ScenarioStageBlock.WidgetContainer then
		_G.ScenarioStageBlock.WidgetContainer:Hide()
	end
end
local function SkinOBTScenario(numCriteria, objectiveBlock)
	if _G.ScenarioObjectiveBlock then
		local childs = { _G.ScenarioObjectiveBlock:GetChildren() }
		for _, child in pairs(childs) do
			if child.Text then
				local LineText = ""
				mSetupQuestFont(child.Text)
				LineText = child.Text:GetText()

				if child.Icon then
					local current, required, details = strmatch(LineText, "^(%d-)/(%d-) (.+)")
					if (current ~= nil or required ~= nil) and current == required then
						child.Icon:SetTexture(mMT.Media.MiscIcons["DONE1"])
					else
						if E.db.mMT.objectivetracker.dash.style == "icon" then
							child.Icon:SetTexture(mMT.Media.DashIcons[E.db.mMT.objectivetracker.dash.texture])
						elseif E.db.mMT.objectivetracker.dash.style == "none" then
							child.Icon:Hide()
						end
					end
				end

				if LineText ~= nil then
					LineText = SkinScenarioText(LineText)
					if LineText ~= nil then
						child.Text:SetText(LineText)
					end
				end
			end
		end
	end
end

local function SkinOBTText(_, line)
	if line then
		if line.HeaderText then
			mSetupTitleFont(line.HeaderText)
		end

		if line.currentLine then
			if line.currentLine.objectiveKey == 0 then
				mSetupTitleFont(line.currentLine.Text)
			else
				local DashStyle = E.db.mMT.objectivetracker.dash.style
				if line.currentLine.Dash then
					if DashStyle ~= "blizzard" then
						if DashStyle == "custom" then
							line.currentLine.Dash:SetText(E.db.mMT.objectivetracker.dash.customstring)
						elseif DashStyle == "icon" then
							line.currentLine.Dash:SetText(
								mDashIcon(mMT.Media.DashIcons[E.db.mMT.objectivetracker.dash.texture])
							)
						else
							line.currentLine.Dash:Hide()
							line.currentLine.Text:ClearAllPoints()
							line.currentLine.Text:Point("TOPLEFT", line.currentLine.Dash, "TOPLEFT", 0, 0)
						end
					end
				end

				if line.currentLine.Check then
					if DashStyle == "none" then
						line.currentLine.Check:ClearAllPoints()
						line.currentLine.Check:Point("TOPRIGHT", line.currentLine.Dash, "TOPLEFT", 0, 0)
					end
					line.currentLine.Check:SetTexture(mMT.Media.MiscIcons["DONE1"])
					line.currentLine.Check:SetVertexColor(1, 1, 1, 1)
				end

				if line.currentLine.Text then
					local LineText = line.currentLine.Text:GetText()

					if LineText ~= nil then
						LineText = SkinQuestText(LineText)
						if LineText ~= nil then
							line.currentLine.Text:SetText(LineText)
						end
					end
					mSetupQuestFont(line.currentLine.Text, line.currentLine.state)
				end
			end
		end
	end
end

local function SkinOBT()
	local Frame = ObjectiveTrackerFrame.MODULES
	if Frame then
		for i = 1, #Frame do
			local Modules = Frame[i]
			if Modules then
				mSetupHeaderFont(Modules.Header.Text)
				if not Modules.IsSkinned then
					if E.db.mMT.objectivetracker.header.barstyle ~= "none" then
						mCreatBar(Modules.Header)
					end
					if not E.db.mMT.objectivetracker.simple then
						hooksecurefunc(Modules, "AddObjective", SkinOBTText)
					end
					Modules.IsSkinned = true
				end
			end
		end
	end
end

local function mOBTFontColors()
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

function mMT:InitializemOBT()
	if E.db.mMT.objectivetracker.simple and E.db.mMT.objectivetracker.enable then
		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "SetBlockHeader", SkinOBT)
	elseif E.db.mMT.objectivetracker.enable then
		mOBTFontColors()

		hooksecurefunc(_G.QUEST_TRACKER_MODULE, "SetBlockHeader", SkinOBT)
		hooksecurefunc("ObjectiveTracker_Update", SkinOBT)
		hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", SkinOBTScenario)
		hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, "Update", SkinOBTScenarioBlock)
		if E.db.mMT.objectivetracker.text.backdrop then
			hooksecurefunc("BonusObjectiveTrackerProgressBar_SetValue", mBackdropBars) --[Color]: Bonus Objective Progress Bar
			hooksecurefunc("ObjectiveTrackerProgressBar_SetValue", mBackdropBars) --[Color]: Quest Progress Bar
			hooksecurefunc("ScenarioTrackerProgressBar_SetValue", mBackdropBars)
		end
	end
end
