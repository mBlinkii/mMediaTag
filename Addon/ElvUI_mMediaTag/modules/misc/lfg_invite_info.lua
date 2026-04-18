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

	if module.info_screen then
		module.info_screen.demo = false
		module.info_screen:Hide()
		if clearText then
			ClearInfo()
		end
	end
end

local function ShowInfo(keepVisible)
	if not module.info_screen then return end

	module.lastShownAt = GetTime()
	module.info_screen:Show()

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
		if IsInInstance() or not IsInGroup() then
			HideInfo(true)
		end
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

		module.info_screen.lable = module.info_screen:CreateFontString(nil, "OVERLAY")
		module.info_screen.lable:SetPoint("TOP", module.info_screen, "TOP", 0, -10)
		module.info_screen.lable:SetTextColor(1, 1, 1, 1)
		module.info_screen.lable:SetJustifyH("CENTER")

		module.info_screen.lable2 = module.info_screen:CreateFontString(nil, "OVERLAY")
		module.info_screen.lable2:SetPoint("TOP", module.info_screen.lable, "BOTTOM", 0, -5)
		module.info_screen.lable2:SetTextColor(1, 1, 1, 1)
		module.info_screen.lable2:SetJustifyH("CENTER")

		module.info_screen:SetScript("OnShow", function(self)
			local width = max(module.info_screen.lable:GetStringWidth(), module.info_screen.lable2:GetStringWidth()) + 20
			local height = module.info_screen.lable:GetStringHeight() + module.info_screen.lable2:GetStringHeight() + 20
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

	if not module.isEnabled then
		module:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
		module:RegisterEvent("LFG_LIST_JOINED_GROUP")
		module:RegisterEvent("GROUP_LEFT")
		module:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		module.isEnabled = true
	end

	if module.db.icon ~= "none" then
		module.info_screen.icon = module.info_screen.icon or module.info_screen:CreateTexture(nil, "ARTWORK")
		local size = (module.db.font.size + module.db.font.size2) * 2
		module.info_screen.icon:SetSize(size, size)
		module.info_screen.icon:SetTexture(MEDIA.icons.lfg[module.db.icon])

		local spacing = -4 * (module.db.font.size / 24)
		module.info_screen.icon:SetPoint("RIGHT", module.info_screen, "LEFT", spacing, 0)
	elseif module.info_screen.icon then
		module.info_screen.icon:SetTexture(nil)
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
