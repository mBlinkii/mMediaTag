local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("LFGInviteInfo", { "AceEvent-3.0" })

-- Cache WoW Globals
local CreateFrame = CreateFrame
local format = format
local GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local GetActivityFullName = C_LFGList.GetActivityFullName
local GetActivityInfoTable = C_LFGList.GetActivityInfoTable

local LSM = E.Libs.LSM
local COLORS = MEDIA.color

function module:Initialize()
	if E.db.mMT.lfg_invite_info.enable then
		module.db = E.db.mMT.lfg_invite_info
		if not module.info_screen then
			module.info_screen = CreateFrame("Frame", "mMediaTag_LFG_Invite_Info", E.UIParent, "BackdropTemplate")
			module.info_screen:SetTemplate("Transparent", true)
			module.info_screen:SetFrameStrata("HIGH")
			module.info_screen:SetPoint("CENTER")
			module.info_screen:SetWidth(300)
			module.info_screen:SetHeight(100)

			module.info_screen.lable = module.info_screen:CreateFontString(nil, "OVERLAY")
			module.info_screen.lable:SetFont(LSM:Fetch("font", module.db.font.font), module.db.font.size, module.db.font.style)
			module.info_screen.lable:SetPoint("CENTER", module.info_screen, "CENTER", 0, 0)
			module.info_screen.lable:SetTextColor(1, 1, 1, 1)
			module.info_screen.info = module.info_screen:CreateFontString(nil, "OVERLAY")
			module.info_screen.info:SetFont(LSM:Fetch("font", module.db.font.font), module.db.font.info, module.db.font.style)
			module.info_screen.info:SetPoint("TOP", module.info_screen.lable, "BOTTOM", 0, 0)
			module.info_screen.info:SetTextColor(1, 1, 1, 1)

			module:RegisterEvent("LFG_LIST_JOINED_GROUP")
			module:RegisterEvent("GROUP_LEFT")
			module:RegisterEvent("ZONE_CHANGED_NEW_AREA")

			E:CreateMover(module.info_screen, "mMediaTag_LFG_Invite_Info_Mover", "mMT LFG Invite Info", nil, nil, nil, "ALL,MMEDIATAG", nil, "mMT,misc,lfg_invite_info", nil)
			module.info_screen:Hide()
		end
	else
		if module.info_screen then module.info_screen:Hide() end
	end
end

function module:LFG_LIST_JOINED_GROUP(_, searchResultID, groupName)
	local searchResultData = GetSearchResultInfo(searchResultID)
	local id = searchResultData.activityIDs and searchResultData.activityIDs[1] or nil
	if id then
		local name = GetActivityFullName(id)
		local comment = searchResultData.comment

		local difficulty = name:match("%((.-)%)")
		local activity = name:gsub(" %(" .. difficulty .. "%)", "")

		local activityInfo = GetActivityInfoTable(id)

		if difficulty or difficulty ~= " " then
			local difficulty_color = activityInfo.isHeroicActivity and COLORS.hc
				or activityInfo.isMythicActivity and COLORS.mythic
				or activityInfo.isMythicPlusActivity and COLORS.mythic_plus
				or activityInfo.isNormalActivity and COLORS.nhc
				or COLORS.none
			difficulty = difficulty_color:WrapTextInColorCode(difficulty)
		end

		module.info_screen.lable:SetText(format("%s \n%s \n%s \n%s", groupName, name, activity, difficulty))

		if comment and comment ~= "" then module.info_screen.info:SetText(COLORS.gray:WrapTextInColorCode(comment)) end

		module.info_screen:Show()

		E:Delay(module.db.delay, function()
			module.info_screen:Hide()
		end)
	end
end

function module:GROUP_LEFT()
	module.info_screen:Hide()
	module.info_screen.lable:SetText("")
	module.info_screen.info:SetText("")
end

function module:ZONE_CHANGED_NEW_AREA()
	if (IsInInstance() or not IsInGroup()) and module.info_screen:IsShown() then
		module.info_screen:Hide()
		module.info_screen.lable:SetText("")
		module.info_screen.info:SetText("")
	end
end
