local E = unpack(ElvUI)
local L = mMT.Locales

local module = mMT:AddModule("LFGInviteInfo", { "AceEvent-3.0" })

-- Cache WoW Globals
local CreateFrame = CreateFrame
local format = format
local IsInInstance = IsInInstance
local IsInGroup = IsInGroup
local GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local GetActivityFullName = C_LFGList.GetActivityFullName
local GetActivityInfoTable = C_LFGList.GetActivityInfoTable

local LSM = E.Libs.LSM

local COLORS = {
	line_a = "FF1EFF00",
	line_b = "FF0070DD",
	line_c = "FFA335EE",
}

local lfg_icons = {
	lfg01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_01.tga",
	lfg02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_02.tga",
	lfg03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_03.tga",
	lfg04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_04.tga",
	lfg05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_05.tga",
	lfg06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_06.tga",
	lfg07 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_07.tga",
	lfg08 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_08.tga",
	lfg09 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_09.tga",
}

local function ColorText(text, color)
	color = COLORS[color or "line_a"]
	return format("|C%s%s|r", color, text)
end

local function UpdateColors()
	COLORS.line_a = E.db.mMT.lfg_invite_info.colors.line_a
	COLORS.line_b = E.db.mMT.lfg_invite_info.colors.line_b
	COLORS.line_c = E.db.mMT.lfg_invite_info.colors.line_c
end
function module:Demo(show)
	if show then
		module.info_screen.lable:SetText(format("%s", ColorText(L["GROUP NAME"] .. " - " .. L["ACTIVITY NAME"], "line_a")))
		module.info_screen.lable2:SetText(format("%s \n%s", ColorText(L["ACTIVITY NAME"], "line_b"), ColorText(L["DIFFICULTY"], "line_c")))
		module.info_screen:Show()
	else
		module.info_screen:Hide()
		module.info_screen.lable:SetText("")
		module.info_screen.lable2:SetText("")
	end
end

function module:Initialize(demo)
	if not E.db.mMT.lfg_invite_info.enable then
		if module.info_screen then
			module.info_screen:Hide()
			if module.isEnabled then
				module.info_screen:UnregisterAllEvents()
				module.isEnabled = false
			end
		end
		return
	end

	module.db = E.db.mMT.lfg_invite_info

	if not module.info_screen then
		module.info_screen = CreateFrame("Button", "mMediaTag_LFG_Invite_Info", E.UIParent, "BackdropTemplate")
		module.info_screen:SetFrameStrata("HIGH")
		module.info_screen:SetPoint("CENTER")

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
			local width = math.max(module.info_screen.lable:GetStringWidth(), module.info_screen.lable2:GetStringWidth()) + 20
			local height = module.info_screen.lable:GetStringHeight() + module.info_screen.lable2:GetStringHeight() + 20
			self:SetSize(width, height)
		end)

		module.info_screen:RegisterForClicks("AnyDown")
		module.info_screen:SetScript("OnClick", function(_, btn)
			if btn == "RightButton" then module.info_screen:Hide() end
		end)

		E:CreateMover(module.info_screen, "mMediaTag_LFG_Invite_Info_Mover", "mMT LFG Invite Info", nil, nil, nil, "ALL,MMEDIATAG", nil, "mMT,misc,lfg_invite_info")
		module.info_screen:Hide()
	end

	E:SetFont(module.info_screen.lable, LSM:Fetch("font", module.db.font.font), module.db.font.size, module.db.font.fontflag)
	E:SetFont(module.info_screen.lable2, LSM:Fetch("font", module.db.font.font), module.db.font.size2, module.db.font.fontflag)

	if not module.isEnabled then
		module:RegisterEvent("LFG_LIST_JOINED_GROUP")
		module:RegisterEvent("GROUP_LEFT")
		module:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		module.isEnabled = true
	end

	if module.db.icon ~= "none" then
		module.info_screen.icon = module.info_screen.icon or module.info_screen:CreateTexture(nil, "ARTWORK")
		local size = (module.db.font.size + module.db.font.size2) * 2
		module.info_screen.icon:SetSize(size, size)
		module.info_screen.icon:SetTexture(lfg_icons[module.db.icon])

		local spacing = -4 * (module.db.font.size / 24)
		module.info_screen.icon:SetPoint("RIGHT", module.info_screen, "LEFT", spacing, 0)
	elseif module.info_screen.icon then
		module.info_screen.icon:SetTexture(nil)
	end

	if demo then module:Demo(not module.info_screen:IsShown()) end
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

	module.info_screen.lable:SetText(format("%s", ColorText((groupName or " ") .. " - " .. name, "line_a")))
	module.info_screen.lable2:SetText(format("%s \n%s", ColorText(activity, "line_b"), ColorText(difficulty, "line_c")))

	module.info_screen:Show()

	E:Delay(module.db.delay, function()
		module.info_screen:Hide()
	end)
end

function module:GROUP_LEFT()
	module.info_screen:Hide()
	module.info_screen.lable:SetText("")
	module.info_screen.lable2:SetText("")
end

function module:ZONE_CHANGED_NEW_AREA()
	if (IsInInstance() or not IsInGroup()) and module.info_screen:IsShown() then
		module.info_screen:Hide()
		module.info_screen.lable:SetText("")
		module.info_screen.lable2:SetText("")
	end
end
