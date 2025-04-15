local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

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
local COLORS = MEDIA.color

function module:Demo(show)
	if show then
		module.info_screen.lable:SetText(format("%s", mMT:TC(L["GROUP NAME"] .. " - " .. L["ACTIVITY NAME"], "line_a")))
		module.info_screen.lable2:SetText(format("%s \n%s", mMT:TC(L["ACTIVITY NAME"], "line_b"), mMT:TC(L["DIFFICULTY"], "line_c")))
		module.info_screen:Show()
	else
		module.info_screen:Hide()
		module.info_screen.lable:SetText("")
		module.info_screen.lable2:SetText("")
	end
end

function module:Initialize(demo)
	if E.db.mMT.lfg_invite_info.enable then
		module.db = E.db.mMT.lfg_invite_info
		if not module.info_screen then
			module.info_screen = CreateFrame("Button", "mMediaTag_LFG_Invite_Info", E.UIParent, "BackdropTemplate")
			module.info_screen:SetFrameStrata("HIGH")
			module.info_screen:SetPoint("CENTER")
			module.info_screen:SetWidth(400)
			module.info_screen:SetHeight(64)

			module.info_screen.lable = module.info_screen:CreateFontString(nil, "OVERLAY")
			module.info_screen.lable:SetPoint("CENTER", module.info_screen, "CENTER", 0, 0)
			module.info_screen.lable:SetTextColor(1, 1, 1, 1)
			module.info_screen.lable:SetJustifyH("CENTER")

			module.info_screen.lable2 = module.info_screen:CreateFontString(nil, "OVERLAY")
			module.info_screen.lable2:SetPoint("TOP", module.info_screen.lable, "BOTTOM", 0, 0)
			module.info_screen.lable2:SetTextColor(1, 1, 1, 1)
			module.info_screen.lable2:SetJustifyH("CENTER")

			module.info_screen:RegisterForClicks("AnyDown")
			module.info_screen:SetScript("OnClick", function(_, btn)
				if btn == "RightButton" then module.info_screen:Hide() end
			end)

			E:CreateMover(module.info_screen, "mMediaTag_LFG_Invite_Info_Mover", "mMT LFG Invite Info", nil, nil, nil, "ALL,MMEDIATAG", nil, "mMT,misc,lfg_invite_info", nil)
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
			if not module.info_screen.icon then module.info_screen.icon = module.info_screen:CreateTexture(nil, "ARTWORK") end

			local size = module.db.font.size * 2 + module.db.font.size2 * 2
			module.info_screen.icon:SetHeight(size )
			module.info_screen.icon:SetWidth(size)
			module.info_screen.icon:SetTexture(MEDIA.icons.lfg[module.db.icon])

			local spacing = -4 * (module.db.font.size / 24)
			module.info_screen.icon:ClearAllPoints()
			module.info_screen.icon:SetPoint("RIGHT", module.info_screen.lable, "LEFT", spacing, 0)
		elseif module.info_screen.icon then
			module.info_screen.icon:SetTexture(nil)
		end

		if demo then module:Demo(not module.info_screen:IsShown()) end
	else
		if module.info_screen then
			module.info_screen:Hide()
			if module.isEnabled then
				module.info_screen:UnregisterAllEvents()
				module.isEnabled = true
			end
		end
	end
end

function module:LFG_LIST_JOINED_GROUP(_, searchResultID, groupName)
	local searchResultData = GetSearchResultInfo(searchResultID)
	local id = searchResultData.activityIDs and searchResultData.activityIDs[1] or nil
	if id then
		local name = GetActivityFullName(id)

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

		module.info_screen.lable:SetText(format("%s", mMT:TC(groupName .. " - " .. name, "line_a")))
		module.info_screen.lable2:SetText(format("%s \n%s", mMT:TC(activity, "line_b"), mMT:TC(difficulty, "line_c")))

		module.info_screen:Show()

		E:Delay(module.db.delay, function()
			module.info_screen:Hide()
		end)
	end
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
