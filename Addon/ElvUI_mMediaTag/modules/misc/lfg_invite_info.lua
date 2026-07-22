local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("LFGInviteInfo", { "AceEvent-3.0" })

-- Cache WoW Globals
local CreateFrame = CreateFrame
local format = format
local GetTime = GetTime
local IsInInstance = IsInInstance
local IsInGroup = IsInGroup
local GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local GetActivityFullName = C_LFGList.GetActivityFullName
local GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_Timer_After = C_Timer.After
local C_Timer_NewTimer = C_Timer.NewTimer
local max = math.max
local random = random

local LSM = E.Libs.LSM
local MINIMUM_DISPLAY_TIME = 2
local SHOW_DELAY = 0.2
local FADE_TIME = 0.25
local PADDING = 14
local SPACING = 8

local function CancelFadeTimer()
	if module.fadeTimer then
		module.fadeTimer:Cancel()
		module.fadeTimer = nil
	end
end

local THEMES = {
	class = { accentTop = true, divider = true, color = function() return MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b end },
	gold = { accentTop = true, accentBottom = true, divider = true, color = function() return 1, 0.78, 0.1 end },
	minimal = {},
}

local function ApplyTheme()
	local screen = module.info_screen
	if not screen then return end

	local theme = THEMES[module.db.theme] or THEMES.class
	local r, g, b = 1, 1, 1
	if theme.color then
		r, g, b = theme.color()
	end
	local hasBG = module.db.background

	screen.accent:SetVertexColor(r, g, b, 1)
	screen.accent:SetShown(theme.accentTop and hasBG)

	screen.accentBottom:SetVertexColor(r, g, b, 1)
	screen.accentBottom:SetShown(theme.accentBottom and hasBG)

	screen.divider:SetVertexColor(r, g, b, 0.6)
	screen.divider:SetShown(theme.divider)

	screen.lable2:ClearAllPoints()
	if theme.divider then
		screen.lable2:SetPoint("TOP", screen.divider, "BOTTOM", 0, -SPACING)
	else
		screen.lable2:SetPoint("TOP", screen.lable, "BOTTOM", 0, -SPACING)
	end
end

local function CancelHideTimer()
	if module.hideTimer then
		module.hideTimer:Cancel()
		module.hideTimer = nil
	end
end

local function CancelShowTimer()
	if module.showTimer then
		module.showTimer:Cancel()
		module.showTimer = nil
	end
end

local function ClearInfo()
	module.info_screen.lable:SetText("")
	module.info_screen.lable2:SetText("")
end

local function HideInfo(clearText)
	CancelShowTimer()
	CancelHideTimer()

	local screen = module.info_screen
	if not screen then return end

	screen.demo = false

	if screen:IsShown() then
		E:UIFrameFadeOut(screen, FADE_TIME, screen:GetAlpha(), 0)
		module.fadeTimer = C_Timer_NewTimer(FADE_TIME, function()
			module.fadeTimer = nil
			screen:Hide()
			screen:SetAlpha(1)
			if clearText then ClearInfo() end
		end)
	elseif clearText then
		ClearInfo()
	end
end

local function ShowInfo(keepVisible)
	if not module.info_screen then return end

	CancelFadeTimer()

	module.lastShownAt = GetTime()
	module.info_screen:Show()
	E:UIFrameFadeIn(module.info_screen, FADE_TIME, module.info_screen:GetAlpha(), 1)

	CancelHideTimer()
	if keepVisible then return end

	module.hideTimer = C_Timer_NewTimer(module.db.delay, function()
		module.hideTimer = nil
		HideInfo()
	end)
end

local function QueueShowInfo()
	if not module.info_screen then return end

	CancelShowTimer()
	module.showTimer = C_Timer_NewTimer(SHOW_DELAY, function()
		module.showTimer = nil
		local textA = module.info_screen.lable and module.info_screen.lable:GetText() or ""
		local textB = module.info_screen.lable2 and module.info_screen.lable2:GetText() or ""
		if textA == "" and textB == "" then return end
		ShowInfo()
	end)
end

local function HideInfoWhenStateSettles()
	if not module.info_screen or not module.info_screen:IsShown() or module.info_screen.demo then return end
	if not (IsInInstance() or not IsInGroup()) then return end

	local shownAt = module.lastShownAt or 0
	local delay = max(0, MINIMUM_DISPLAY_TIME - (GetTime() - shownAt))

	C_Timer_After(delay, function()
		if not module.info_screen or not module.info_screen:IsShown() or module.info_screen.demo then return end
		if module.lastShownAt ~= shownAt then return end
		if IsInInstance() or not IsInGroup() then HideInfo(true) end
	end)
end

function module:Demo()
	local demoTexts = {
		{ grp = "QUEST", name = L["The Flame Burns Eternal"], acc = L["Weekly"], diff = L["Normal"] },
		{ grp = "m0", name = L["The Rookery"], acc = L["Mythic"], diff = L["Mythic"] },
		{ grp = "+12", name = L["The Floodgate"], acc = L["Keystone"], diff = L["Mythic+"] },
		{ grp = L["Transmog farming"], name = L["Custom"], acc = L["PVE"], diff = L["Custom"] },
	}
	if module.info_screen.demo then
		module.info_screen.demo = false
		HideInfo()
	else
		local info = demoTexts[random(1, #demoTexts)]
		module.info_screen.demo = true
		module.info_screen.lable:SetText(format("%s", mMT:TC(info.grp .. " - " .. info.name, "line_a")))
		module.info_screen.lable2:SetText(format("%s \n%s", mMT:TC(info.acc, "line_b"), mMT:TC(info.diff, "line_c")))
		ShowInfo(true)
	end
end

function module:Initialize(demo)
	if not E.db.mMediaTag.lfg_invite_info.enable then
		if module.info_screen then
			HideInfo(true)
			if module.isEnabled then
				module:UnregisterAllEvents()
				module.isEnabled = false
			end
		end
		return
	end

	module.db = E.db.mMediaTag.lfg_invite_info

	if not module.info_screen then
		module.info_screen = CreateFrame("Button", "mMediaTag_LFG_Invite_Info", E.UIParent, "BackdropTemplate")
		module.info_screen:SetFrameStrata("TOOLTIP")
		module.info_screen:SetToplevel(true)
		module.info_screen:SetClampedToScreen(true)
		module.info_screen:SetPoint("CENTER", 0, 200)
		module.info_screen:SetSize(400, 100)

		if module.db.background then module.info_screen:SetTemplate("Transparent", true) end

		local function CreateLine()
			local tex = module.info_screen:CreateTexture(nil, "OVERLAY")
			tex:SetTexture(E.media.blankTex)
			return tex
		end

		local accent = CreateLine()
		accent:SetHeight(2)
		accent:SetPoint("TOPLEFT", module.info_screen, "TOPLEFT", 1, -1)
		accent:SetPoint("TOPRIGHT", module.info_screen, "TOPRIGHT", -1, -1)
		module.info_screen.accent = accent

		local accentBottom = CreateLine()
		accentBottom:SetHeight(2)
		accentBottom:SetPoint("BOTTOMLEFT", module.info_screen, "BOTTOMLEFT", 1, 1)
		accentBottom:SetPoint("BOTTOMRIGHT", module.info_screen, "BOTTOMRIGHT", -1, 1)
		module.info_screen.accentBottom = accentBottom

		module.info_screen.lable = module.info_screen:CreateFontString(nil, "OVERLAY")
		module.info_screen.lable:SetPoint("TOP", module.info_screen, "TOP", 0, -PADDING)
		module.info_screen.lable:SetTextColor(1, 1, 1, 1)
		module.info_screen.lable:SetJustifyH("CENTER")

		local divider = module.info_screen:CreateTexture(nil, "OVERLAY")
		divider:SetTexture(E.media.blankTex)
		divider:SetHeight(1)
		divider:SetPoint("TOP", module.info_screen.lable, "BOTTOM", 0, -SPACING)
		module.info_screen.divider = divider

		module.info_screen.lable2 = module.info_screen:CreateFontString(nil, "OVERLAY")
		module.info_screen.lable2:SetPoint("TOP", divider, "BOTTOM", 0, -SPACING)
		module.info_screen.lable2:SetTextColor(1, 1, 1, 1)
		module.info_screen.lable2:SetJustifyH("CENTER")

		module.info_screen:SetScript("OnShow", function(self)
			local screen = module.info_screen
			local textWidth = max(screen.lable:GetStringWidth(), screen.lable2:GetStringWidth())
			local dividerSpace = screen.divider:IsShown() and (SPACING * 2 + 1) or SPACING
			local height = screen.lable:GetStringHeight() + screen.lable2:GetStringHeight() + PADDING * 2 + dividerSpace
			local iconSpace = screen.embeddedIconSize and (screen.embeddedIconSize + SPACING * 2) or 0
			screen.lable:ClearAllPoints()
			screen.lable:SetPoint("TOP", screen, "TOP", iconSpace / 2, -PADDING)

			local width = textWidth + PADDING * 2 + iconSpace
			if screen.embeddedIconSize then height = max(height, screen.embeddedIconSize + PADDING * 2) end

			screen.divider:SetWidth(textWidth)
			self:SetSize(width, height)
		end)

		module.info_screen:RegisterForClicks("AnyDown")
		module.info_screen:SetScript("OnClick", function(_, btn)
			if btn == "RightButton" then HideInfo() end
		end)

		E:CreateMover(module.info_screen, "mMediaTag_LFG_Invite_Info_Mover", "mMT " .. L["LFG Invite Info"], nil, nil, nil, "ALL,MMEDIATAG", function()
			return E.db.mMediaTag.lfg_invite_info.enable
		end, "mMT,misc,lfg_invite_info")
		module.info_screen:Hide()
	end

	E:SetFont(module.info_screen.lable, LSM:Fetch("font", module.db.font.font), module.db.font.size, module.db.font.fontFlag)
	E:SetFont(module.info_screen.lable2, LSM:Fetch("font", module.db.font.font), module.db.font.size2, module.db.font.fontFlag)

	ApplyTheme()

	if not module.isEnabled then
		module:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
		module:RegisterEvent("LFG_LIST_JOINED_GROUP")
		module:RegisterEvent("GROUP_LEFT")
		module:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		module.isEnabled = true
	end

	if module.db.icon ~= "none" then
		module.info_screen.icon = module.info_screen.icon or module.info_screen:CreateTexture(nil, "ARTWORK")
		local icon = module.info_screen.icon
		icon:SetTexture(MEDIA.icons.lfg[module.db.icon])
		icon:ClearAllPoints()

		if module.db.embed_icon and module.db.background then
			local size = module.db.font.size + module.db.font.size2
			icon:SetSize(size, size)
			icon:SetPoint("LEFT", module.info_screen, "LEFT", SPACING, 0)
			module.info_screen.embeddedIconSize = size
		else
			local size = (module.db.font.size + module.db.font.size2) * 2
			icon:SetSize(size, size)
			local spacing = -4 * (module.db.font.size / 24)
			icon:SetPoint("RIGHT", module.info_screen, "LEFT", spacing, 0)
			module.info_screen.embeddedIconSize = nil
		end
	else
		module.info_screen.embeddedIconSize = nil
		if module.info_screen.icon then module.info_screen.icon:SetTexture(nil) end
	end

	if demo then module:Demo() end
end

function module:LFG_LIST_JOINED_GROUP(_, searchResultID, groupName)
	local searchResultData = GetSearchResultInfo(searchResultID)
	local id = searchResultData.activityIDs and searchResultData.activityIDs[1]

	if not id then return end

	local name = GetActivityFullName(id) or ""
	local activityInfo = GetActivityInfoTable(id)
	local difficulty, activity = "", ""

	if activityInfo then
		local difficultyName, groupType = GetDifficultyInfo(activityInfo.difficultyID)
		difficulty = difficultyName and (difficultyName .. (groupType and " (" .. groupType .. ")" or "")) or name:match("%((.-)%)")
		activity = activityInfo.shortName or activityInfo.fullName or ""
	end

	module.info_screen.lable:SetText(format("%s", mMT:TC((groupName or " ") .. " - " .. name, "line_a")))
	module.info_screen.lable2:SetText(format("%s \n%s", mMT:TC(activity, "line_b"), mMT:TC(difficulty or "", "line_c")))

	if module.db.print then
		print(mMT:TC("*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~", "blue"))
		print(mMT:TC(mMT:AddSettingsIcon(L["LFG Invite Info"], "greeting_message"), "purple"))
		print(L["Group:"], mMT:TC(groupName or "", "line_a"))
		print(L["Location:"], mMT:TC(name or "", "line_a"))
		print(L["Activity:"], mMT:TC(activity or "", "line_b"))
		print(L["Difficulty:"], mMT:TC(difficulty or "", "line_c"))
		print(mMT:TC("*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~", "blue"))
	end

	QueueShowInfo()
end

function module:LFG_LIST_APPLICATION_STATUS_UPDATED(_, searchResultID, newStatus)
	if newStatus ~= "inviteaccepted" then return end
	if module.info_screen and module.info_screen:IsShown() then return end

	QueueShowInfo()
end

function module:GROUP_LEFT()
	HideInfoWhenStateSettles()
end

function module:ZONE_CHANGED_NEW_AREA()
	HideInfoWhenStateSettles()
end
