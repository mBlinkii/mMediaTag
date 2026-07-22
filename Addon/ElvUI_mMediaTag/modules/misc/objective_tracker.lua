local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local module = mMT:AddModule("ObjectiveTracker")

-- Cache WoW Globals
local _G = _G
local pairs, ipairs, tonumber, format = pairs, ipairs, tonumber, format
local strmatch, strfind, gsub = strmatch, strfind, gsub
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local issecretvalue = _G.issecretvalue or function() return false end

local db, fonts, colors

local trackerNames = {
	"AchievementObjectiveTracker",
	"AdventureObjectiveTracker",
	"BonusObjectiveTracker",
	"CampaignQuestObjectiveTracker",
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
		return { r = classColor.r, g = classColor.g, b = classColor.b, hex = E:RGBToHex(classColor.r, classColor.g, classColor.b) }
	end

	local r, g, b = mMT:HexToRGB(colorDB.color)
	return { r = r, g = g, b = b, hex = E:RGBToHex(r, g, b) }
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
	}

	fonts = {
		header = { font = LSM:Fetch("font", db.font.font), size = db.font.size.header, flag = db.font.fontFlag },
		title = { font = LSM:Fetch("font", db.font.font), size = db.font.size.title, flag = db.font.fontFlag },
		text = { font = LSM:Fetch("font", db.font.font), size = db.font.size.text, flag = db.font.fontFlag },
	}
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

local function SetTextProperties(text, fontSettings, color)
	local flag = fontSettings.flag or "NONE"
	text:SetFont(fontSettings.font, fontSettings.size, fontFlagMap[flag] or flag)

	if strfind(flag, "SHADOW", 1, true) then
		text:SetShadowColor(0, 0, 0, 1)
		text:SetShadowOffset(1, -1)
	else
		text:SetShadowColor(0, 0, 0, 0)
	end

	if color then text:SetTextColor(color.r, color.g, color.b) end
end

local function SkinTitleText(text)
	SetTextProperties(text, fonts.title, colors.title)
	local height = text:GetStringHeight()
	if height ~= text:GetHeight() then text:SetHeight(height) end
end

-- progress coloring
-- strips old color codes and colors "x/y Text", "Text: x/y" or "Text (x%)" lines by progress
local function GetCleanText(text)
	text = gsub(text, "|c%x%x%x%x%x%x%x%x", "")
	text = gsub(text, "|r", "")
	return text
end

local function GetProgressHex(percent)
	local r, g, b = E:ColorGradient(percent, colors.bad.r, colors.bad.g, colors.bad.b, colors.transit.r, colors.transit.g, colors.transit.b, colors.good.r, colors.good.g, colors.good.b)
	return E:RGBToHex(r, g, b)
end

local function BuildProgressText(lineText, color)
	local current, required, questText = strmatch(lineText, "^(%d+)/(%d+) (.+)$")
	if not current then
		questText, current, required = strmatch(lineText, "^(.-): (%d+)/(%d+)$")
	end

	if current and required then
		current, required = tonumber(current), tonumber(required)
		if current and required and required > 1 and current < required then
			local hex = GetProgressHex(current / required)
			return format("%s%d/%d|r %s%s|r", hex, current, required, color.hex, questText)
		end
		return nil
	end

	local percentText
	questText, percentText = strmatch(lineText, "^(.+) %(([%d%.]+)%%%)$")
	if questText and percentText then
		local percent = tonumber(percentText)
		if percent and percent < 100 then
			local hex = GetProgressHex(percent * 0.01)
			return format("%s%s|r (%s%.f%%|r)", color.hex, questText, hex, percent)
		end
	end
end

local function SetLineText(text, completed)
	local color = completed and colors.complete or colors.text
	SetTextProperties(text, fonts.text, color)

	if completed or not db.progress.enable then return end

	local lineText = text:GetText()
	if not lineText or issecretvalue(lineText) then return end

	local newText = BuildProgressText(GetCleanText(lineText), color)
	if newText then
		text:SetHeight(0) -- force a clear of internals or GetHeight() might return an incorrect value
		text:SetText(newText)
	end
end

local function SkinLine(line)
	if not (line and line.Text) then return end

	if line.objectiveKey == 0 then
		SkinTitleText(line.Text)
	else
		local completed = (line.objectiveKey == "QuestComplete") or line.finished
		SetLineText(line.Text, completed)
	end

	-- fix for overlapping blocks/ line and header - thx Merathilis & Fang
	local height = line.Text:GetHeight()
	line.Text:SetHeight(height)
	line:SetHeight(height)
end

local function SkinBlock(_, block)
	if not (db and db.enable) or not block then return end

	if block.HeaderText then SkinTitleText(block.HeaderText) end

	if block.usedLines then
		for _, line in pairs(block.usedLines) do
			SkinLine(line)
		end
	end
end

-- header bar
local function UpdateHeaderBar(headerBar)
	headerBar:SetShown(db.headerbar.enable)
	if not db.headerbar.enable then return end

	headerBar.texture:SetTexture(LSM:Fetch("statusbar", db.headerbar.texture))

	local color = db.headerbar.class and GetColor({ class = true }) or GetColor({ color = db.headerbar.color })

	if db.headerbar.gradient then
		headerBar.texture:SetGradient("HORIZONTAL", { r = color.r * 0.6, g = color.g * 0.6, b = color.b * 0.6, a = 1 }, { r = color.r, g = color.g, b = color.b, a = 1 })
	else
		headerBar.texture:SetVertexColor(color.r, color.g, color.b, 1)
	end
end

local function AddHeaderBar(header)
	local headerBar = CreateFrame("Frame", nil, header)
	headerBar:SetTemplate("Transparent")
	headerBar:SetFrameStrata(header:GetFrameStrata())
	headerBar:SetFrameLevel(header:GetFrameLevel() - 1)
	headerBar:SetSize(_G.ObjectiveTrackerFrame:GetWidth(), 5)
	headerBar:SetPoint("BOTTOM", 0, 0)

	headerBar.texture = headerBar:CreateTexture(nil, "ARTWORK")
	headerBar.texture:SetPoint("TOPLEFT", headerBar, "TOPLEFT", 1, -1)
	headerBar.texture:SetPoint("BOTTOMRIGHT", headerBar, "BOTTOMRIGHT", -1, 1)

	header.mMT_HeaderBar = headerBar
end

local function SkinHeader(header)
	if not (header and header.Text) then return end

	SetTextProperties(header.Text, fonts.header, colors.header)

	if header ~= _G.ObjectiveTrackerFrame.Header then
		if not header.mMT_HeaderBar then AddHeaderBar(header) end
		UpdateHeaderBar(header.mMT_HeaderBar)
	end
end

-- background
local function SetCollapsed(_, collapsed)
	local backdrop = _G.ObjectiveTrackerFrame.backdrop
	if backdrop then backdrop:SetShown(not collapsed and db.bg.enable) end
end

local function UpdateBackground()
	local tracker = _G.ObjectiveTrackerFrame
	local backdrop = tracker.backdrop

	if not db.bg.enable then
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

	if not db.enable then
		if module.isSkinned then
			UpdateBackground()
			for _, name in ipairs(trackerNames) do
				local tracker = _G[name]
				if tracker and tracker.Header and tracker.Header.mMT_HeaderBar then tracker.Header.mMT_HeaderBar:Hide() end
			end
		end
		return
	end

	UpdateBackground()

	-- main header - do not SetText on it, it will taint
	SkinHeader(trackerFrame.Header)

	for _, name in ipairs(trackerNames) do
		local tracker = _G[name]
		if tracker then
			SkinHeader(tracker.Header)

			if not tracker.mMT_Skinned then
				hooksecurefunc(tracker, "AddBlock", SkinBlock)
				tracker.mMT_Skinned = true
			end
		end
	end

	if not module.isSkinned then
		hooksecurefunc(trackerFrame.Header, "SetCollapsed", SetCollapsed)
		module.isSkinned = true
	end

	module.loaded = true
end
