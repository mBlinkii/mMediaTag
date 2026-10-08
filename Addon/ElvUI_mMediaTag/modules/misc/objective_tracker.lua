local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local module = mMT:AddModule("ObjectiveTracker")

-- Cache WoW Globals
local _G = _G
local pairs, ipairs, tonumber, format, type = pairs, ipairs, tonumber, format, type
local strmatch, strfind, gsub = strmatch, strfind, gsub
local min = min
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local GetQuestDifficultyColor = GetQuestDifficultyColor
local C_QuestLog = C_QuestLog
local QUEST_DASH = QUEST_DASH
local issecretvalue = _G.issecretvalue or function()
	return false
end

local db, fonts, colors

local CHECK_ATLAS = "ui-questtracker-tracker-check"
local CHECK_GAP = 5
local HIGHLIGHT = 0.35
local DASH_SHOW, DASH_HIDE_COLLAPSE = 1, 3 -- OBJECTIVE_DASH_STYLE_SHOW / OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE
local JUSTIFY_FACTOR = { LEFT = 0, CENTER = 0.5, RIGHT = 1 }

local trackerNames = {
	"AchievementObjectiveTracker",
	"AdventureObjectiveTracker",
	"BonusObjectiveTracker",
	"CampaignQuestObjectiveTracker",
	"InitiativeTasksObjectiveTracker",
	"MonthlyActivitiesObjectiveTracker",
	"ProfessionsRecipeTracker",
	"QuestObjectiveTracker",
	"ScenarioObjectiveTracker",
	"UIWidgetObjectiveTracker",
	"WorldQuestObjectiveTracker",
}

local function GetColor(colorDB)
	if colorDB.class then
		local classColor = E:ClassColor(E.myclass, true)
		return { r = classColor.r, g = classColor.g, b = classColor.b }
	end

	local r, g, b = mMT:HexToRGB(colorDB.color)
	return { r = r, g = g, b = b }
end

local function UpdateSettings()
	db = E.db.mMediaTag.objective_tracker

	colors = {
		header = GetColor(db.colors.header),
		title = GetColor(db.colors.title),
		text = GetColor(db.colors.text),
		complete = GetColor(db.colors.complete),
		good = GetColor(db.progress.good),
		transit = GetColor(db.progress.transit),
		bad = GetColor(db.progress.bad),
		headerbar = GetColor(db.headerbar),
		bar = GetColor(db.bars.color),
	}

	local font = LSM:Fetch("font", db.text.font)
	fonts = {
		header = { font = font, size = db.text.size.header, flag = db.text.fontFlag },
		title = { font = font, size = db.text.size.title, flag = db.text.fontFlag },
		text = { font = font, size = db.text.size.text, flag = db.text.fontFlag },
	}
end

local function IsEnabled()
	return db and db.enable
end

-- Midnight SetFont only accepts: OUTLINE, THICKOUTLINE, MONOCHROME, FILTER, FIXEDHEIGHT, NEVERCULL, SLUG
local fontFlagMap = {
	NONE = "",
	SHADOW = "",
	SHADOWOUTLINE = "OUTLINE",
	SHADOWTHICKOUTLINE = "THICKOUTLINE",
	MONOCHROMEOUTLINE = "MONOCHROME,OUTLINE",
	MONOCHROMETHICKOUTLINE = "MONOCHROME,THICKOUTLINE",
}

local function SetFont(text, fontSettings, justify)
	local flag = fontSettings.flag or "NONE"
	text:SetFont(fontSettings.font, fontSettings.size, fontFlagMap[flag] or flag)

	if justify then text:SetJustifyH(justify) end

	if strfind(flag, "SHADOW", 1, true) then
		text:SetShadowColor(0, 0, 0, 1)
		text:SetShadowOffset(1, -1)
	else
		text:SetShadowColor(0, 0, 0, 0)
	end
end

local function SetColor(text, color, highlighted)
	if highlighted then
		text:SetTextColor(color.r + (1 - color.r) * HIGHLIGHT, color.g + (1 - color.g) * HIGHLIGHT, color.b + (1 - color.b) * HIGHLIGHT)
	else
		text:SetTextColor(color.r, color.g, color.b)
	end
end

local function GetTitleColor(block)
	if db.colors.title.difficulty and block and type(block.id) == "number" then
		local tracker = block.parentModule
		if tracker == _G.QuestObjectiveTracker or tracker == _G.CampaignQuestObjectiveTracker then
			local index = C_QuestLog.GetLogIndexForQuestID(block.id)
			local info = index and C_QuestLog.GetInfo(index)
			if info and info.difficultyLevel then return GetQuestDifficultyColor(info.difficultyLevel, info.isScaling, block.id) end
		end
	end

	return colors.title
end

local function SkinTitleText(text, block)
	SetFont(text, fonts.title, db.text.justify)
	SetColor(text, GetTitleColor(block), block and block.isHighlighted)

	local height = text:GetStringHeight()
	if height ~= text:GetHeight() then text:SetHeight(height) end
end

local function GetCleanText(text)
	text = gsub(text, "|c%x%x%x%x%x%x%x%x", "")
	text = gsub(text, "|r", "")
	return text
end

-- ColorGradient returns more than r, g, b, which would leak into RGBToHex as header and ending
local function GetProgressColor(percent)
	local r, g, b = E:ColorGradient(percent, colors.bad.r, colors.bad.g, colors.bad.b, colors.transit.r, colors.transit.g, colors.transit.b, colors.good.r, colors.good.g, colors.good.b)
	return r, g, b
end

-- matches "x/y Text", "Text: x/y" and "Text (n%)", returns the ratio so callers can derive completion
local function ParseProgress(lineText)
	local current, required, questText = strmatch(lineText, "^(%d+)/(%d+) (.+)$")
	if not current then
		questText, current, required = strmatch(lineText, "^(.-): (%d+)/(%d+)$")
	end

	if current and required then
		current, required = tonumber(current), tonumber(required)
		if current and required and required > 0 then return questText, current / required, current, required end
		return
	end

	local percentText
	questText, percentText = strmatch(lineText, "^(.+) %(([%d%.]+)%%%)$")
	local percent = percentText and tonumber(percentText)
	if percent then return questText, percent * 0.01 end
end

-- line.finished does not exist in the Blizzard tracker, Text.colorStyle is set on every AddObjective
local function IsCompleted(line)
	if line.objectiveKey == "QuestComplete" then return true end

	local trackerColor = _G.OBJECTIVE_TRACKER_COLOR
	return (trackerColor and line.Text.colorStyle == trackerColor.Complete) or false
end

-- the plain parts take the line color from SetTextColor, so only the numbers carry a color code
local function SetLineText(line, completed)
	local text = line.Text
	local lineText = text:GetText()
	local readable = lineText and not issecretvalue(lineText)

	local questText, ratio, current, required
	if readable then
		questText, ratio, current, required = ParseProgress(GetCleanText(lineText))
	end

	completed = completed or (ratio ~= nil and ratio >= 1)
	line.mMT_Completed = completed

	SetFont(text, fonts.text, db.text.justify)
	SetColor(text, completed and colors.complete or colors.text, line.parentBlock and line.parentBlock.isHighlighted)

	if completed or not ratio or not db.progress.enable then return completed end

	local hex = E:RGBToHex(GetProgressColor(ratio))
	local newText
	if current then
		if required <= 1 then return completed end
		newText = format("%s%d/%d|r %s", hex, current, required, questText)
	else
		newText = format("%s (%s%.f%%|r)", questText, hex, ratio * 100)
	end

	text:SetHeight(0) -- force a clear of internals or GetHeight() might return an incorrect value
	text:SetText(newText)

	return completed
end

-- Blizzard reapplies the dash only when the requested style differs from line.dashStyle, so what is set here survives the next update
local function SetLineDash(line)
	local dash = line.Dash
	if not dash then return end

	local style = db.text.hideDash and DASH_HIDE_COLLAPSE or (line.dashStyle or DASH_SHOW)
	dash:SetText(style ~= DASH_HIDE_COLLAPSE and QUEST_DASH or nil)
	dash:SetShown(style == DASH_SHOW)

	if style == DASH_SHOW then
		SetFont(dash, fonts.text)
		SetColor(dash, colors.text, line.parentBlock and line.parentBlock.isHighlighted)
	end
end

-- the template anchors the icon to the line, not to the text, so a custom font pushes it into the text
local function AnchorLineIcon(icon, text)
	local width = text:GetWidth()
	local free = width - min(text:GetStringWidth(), width)

	icon:ClearAllPoints()
	icon:SetPoint("RIGHT", text, "LEFT", free * (JUSTIFY_FACTOR[db.text.justify] or 0) - CHECK_GAP, 0)
end

-- scenario criteria bring their own icon: a check when done, a nub that stands in for the dash
local function SetLineIcon(line, completed)
	local icon = line.Icon
	if not icon or line.objectiveKey == "Waypoint" then return end -- the waypoint line anchors its Text to the Icon

	local block = line.parentBlock
	if block and block.parentModule == _G.ScenarioObjectiveTracker then
		if not completed and db.text.hideDash then return icon:Hide() end

		AnchorLineIcon(icon, line.Text)
		icon:Show()
		return
	end

	if completed then
		icon:SetAtlas(CHECK_ATLAS, false)
		AnchorLineIcon(icon, line.Text)
		icon:Show()
	elseif icon:GetAtlas() == CHECK_ATLAS then
		icon:Hide()
	end
end

local function SkinLine(line)
	if not (line and line.Text) then return end

	if line.objectiveKey == 0 then
		SkinTitleText(line.Text, line.parentBlock)
	else
		SetLineDash(line)
		SetLineIcon(line, SetLineText(line, IsCompleted(line)))
	end

	-- fix for overlapping blocks/ line and header - thx Merathilis & Fang
	local height = line.Text:GetHeight()
	line.Text:SetHeight(height)
	line:SetHeight(height)
end

-- UpdateHighlight resets header and line colors to the Blizzard ones on mouseover
local function ColorBlock(block)
	if not IsEnabled() then return end

	local highlighted = block.isHighlighted
	if block.HeaderText then SetColor(block.HeaderText, GetTitleColor(block), highlighted) end
	if not block.usedLines then return end

	for _, line in pairs(block.usedLines) do
		if line.used and line.Text then
			if line.objectiveKey == 0 then
				SetColor(line.Text, GetTitleColor(block), highlighted)
			else
				SetColor(line.Text, line.mMT_Completed and colors.complete or colors.text, highlighted)
				if line.Dash and line.Dash:IsShown() then SetColor(line.Dash, colors.text, highlighted) end
			end
		end
	end
end

local function SkinBlock(_, block)
	if not IsEnabled() or not block then return end

	if not block.mMT_Hooked and block.UpdateHighlight then
		hooksecurefunc(block, "UpdateHighlight", ColorBlock)
		block.mMT_Hooked = true
	end

	if block.HeaderText then SkinTitleText(block.HeaderText, block) end

	if block.usedLines then
		for _, line in pairs(block.usedLines) do
			if line.used then SkinLine(line) end
		end
	end
end

local function ColorBar(bar, value)
	if not (IsEnabled() and db.bars.enable) then return end

	local r, g, b
	if db.bars.progressColor then
		value = value or bar:GetValue()
		local _, maxValue = bar:GetMinMaxValues()
		if issecretvalue(value) or issecretvalue(maxValue) or not (value and maxValue) or maxValue <= 0 then return end
		r, g, b = GetProgressColor(value / maxValue)
	else
		r, g, b = colors.bar.r, colors.bar.g, colors.bar.b
	end

	bar:SetStatusBarColor(r, g, b)
	if bar.backdrop then bar.backdrop:SetBackdropColor(r * 0.25, g * 0.25, b * 0.25) end
end

-- the backdrop comes from the ElvUI tracker skin, the bar is only retextured and recolored here
local function SkinBar(bar, label)
	if not bar then return end

	bar:SetStatusBarTexture(LSM:Fetch("statusbar", db.bars.texture))

	-- timer bars change their value every frame and bonus bars outside the tracker update, so color on change
	if not bar.mMT_Hooked then
		bar:HookScript("OnValueChanged", ColorBar)
		bar.mMT_Hooked = true
	end

	ColorBar(bar)
	if label then SetFont(label, fonts.text) end
end

local function SkinProgressBar(tracker, key)
	if not (IsEnabled() and db.bars.enable) then return end

	local progress = tracker.usedProgressBars and tracker.usedProgressBars[key]
	if progress and progress.Bar then SkinBar(progress.Bar, progress.Bar.Label) end
end

local function SkinTimerBar(tracker, key)
	if not (IsEnabled() and db.bars.enable) then return end

	local timer = tracker.usedTimerBars and tracker.usedTimerBars[key]
	if timer then SkinBar(timer.Bar, timer.Label) end
end

-- blocks and bars laid out before Initialize keep the Blizzard look until the next tracker update, so skin them once here
local function SkinActiveRegions(tracker)
	if tracker.EnumerateActiveBlocks then tracker:EnumerateActiveBlocks(function(block)
		SkinBlock(nil, block)
	end) end

	if tracker.FixedBlocks then
		for _, block in ipairs(tracker.FixedBlocks) do
			if block.used then SkinBlock(nil, block) end
		end
	end

	if tracker.usedProgressBars then
		for key in pairs(tracker.usedProgressBars) do
			SkinProgressBar(tracker, key)
		end
	end

	if tracker.usedTimerBars then
		for key in pairs(tracker.usedTimerBars) do
			SkinTimerBar(tracker, key)
		end
	end
end

local function GetHeaders()
	local headers = { _G.ObjectiveTrackerFrame.Header }
	for _, name in ipairs(trackerNames) do
		local tracker = _G[name]
		if tracker and tracker.Header then headers[#headers + 1] = tracker.Header end
	end
	return headers
end

local function UpdateHeaderBarWidth()
	local width = _G.ObjectiveTrackerFrame:GetWidth()
	for _, header in ipairs(GetHeaders()) do
		if header.mMT_HeaderBar then header.mMT_HeaderBar:SetWidth(width) end
	end
end

local function AddHeaderBar(header)
	local headerBar = CreateFrame("Frame", nil, header)
	headerBar:SetFrameStrata(header:GetFrameStrata())
	headerBar:SetFrameLevel(header:GetFrameLevel() - 1)
	headerBar:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 0, 0)

	-- the backdrop sits outside the bar, so the bar keeps its full height
	headerBar:CreateBackdrop("Transparent")

	headerBar.texture = headerBar:CreateTexture(nil, "ARTWORK")
	headerBar.texture:SetAllPoints()

	header.mMT_HeaderBar = headerBar
	return headerBar
end

local function UpdateHeaderBar(header, isMain)
	local headerBar = header.mMT_HeaderBar
	if not (IsEnabled() and db.headerbar.enable and (not isMain or db.headerbar.mainHeader)) then
		if headerBar then headerBar:Hide() end
		return
	end

	headerBar = headerBar or AddHeaderBar(header)
	headerBar:SetSize(_G.ObjectiveTrackerFrame:GetWidth(), db.headerbar.height)
	headerBar.backdrop:SetShown(db.headerbar.border)
	headerBar.texture:SetTexture(LSM:Fetch("statusbar", db.headerbar.texture))

	local color = colors.headerbar
	if db.headerbar.gradient then
		headerBar.texture:SetGradient("HORIZONTAL", { r = color.r * 0.6, g = color.g * 0.6, b = color.b * 0.6, a = 1 }, { r = color.r, g = color.g, b = color.b, a = 1 })
	else
		headerBar.texture:SetGradient("HORIZONTAL", { r = color.r, g = color.g, b = color.b, a = 1 }, { r = color.r, g = color.g, b = color.b, a = 1 })
	end

	headerBar:Show()
end

local function SkinHeader(header, isMain)
	if not (header and header.Text) then return end

	SetFont(header.Text, fonts.header)
	SetColor(header.Text, colors.header)
	UpdateHeaderBar(header, isMain)
end

local function SetCollapsed(_, collapsed)
	local backdrop = _G.ObjectiveTrackerFrame.backdrop
	if backdrop then backdrop:SetShown(not collapsed and IsEnabled() and db.bg.enable) end
end

local function UpdateBackground()
	local tracker = _G.ObjectiveTrackerFrame
	local backdrop = tracker.backdrop

	if not (IsEnabled() and db.bg.enable) then
		if backdrop then backdrop:Hide() end
		return
	end

	if not backdrop then
		tracker:CreateBackdrop()
		backdrop = tracker.backdrop
	end

	backdrop:SetTemplate(db.bg.transparent and "Transparent" or "Default")

	if db.bg.classBorder then
		local classColor = E:ClassColor(E.myclass, true)
		backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b, 1)
	end

	backdrop:ClearAllPoints()
	backdrop:SetPoint("TOPLEFT", tracker, "TOPLEFT", -10, 10)
	backdrop:SetPoint("BOTTOMRIGHT", tracker, "BOTTOMRIGHT", 10, -10)

	SetCollapsed(nil, tracker.isCollapsed)
end

function module:Initialize()
	UpdateSettings()

	local trackerFrame = _G.ObjectiveTrackerFrame
	if not trackerFrame then return end

	if not db.enable and not module.isSkinned then return end

	UpdateBackground()

	-- main header - do not SetText on it, it will taint
	if db.enable then
		SkinHeader(trackerFrame.Header, true)
	else
		UpdateHeaderBar(trackerFrame.Header, true)
	end

	for _, name in ipairs(trackerNames) do
		local tracker = _G[name]
		if tracker then
			if db.enable then
				SkinHeader(tracker.Header)
			elseif tracker.Header then
				UpdateHeaderBar(tracker.Header)
			end

			if not tracker.mMT_Skinned then
				hooksecurefunc(tracker, "AddBlock", SkinBlock)
				hooksecurefunc(tracker, "GetProgressBar", SkinProgressBar)
				hooksecurefunc(tracker, "GetTimerBar", SkinTimerBar)
				tracker.mMT_Skinned = true
			end

			SkinActiveRegions(tracker)
		end
	end

	if not module.isSkinned then
		hooksecurefunc(trackerFrame.Header, "SetCollapsed", SetCollapsed)
		trackerFrame:HookScript("OnSizeChanged", UpdateHeaderBarWidth)
		module.isSkinned = true
	end

	module.loaded = true
end
