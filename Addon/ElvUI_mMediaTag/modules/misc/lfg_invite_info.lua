local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("LFGInviteInfo", { "AceEvent-3.0" })

-- Cache WoW Globals
local CreateFrame = CreateFrame
local format = format
local gsub = gsub
local GetTime = GetTime
local IsInInstance = IsInInstance
local IsInGroup = IsInGroup
local GetDifficultyInfo = GetDifficultyInfo
local GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local GetActivityFullName = C_LFGList.GetActivityFullName
local GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_Timer_After = C_Timer.After
local C_Timer_NewTimer = C_Timer.NewTimer
local floor = math.floor
local max = math.max
local random = random

local LSM = E.Libs.LSM
local MINIMUM_DISPLAY_TIME = 2
local SHOW_DELAY = 0.2
local ANIM_TIME = 0.28
local SLIDE = 22
local POP_SCALE = 0.92
local PADDING = 14
local SPACING = 8
local LINE_SPACING = 3
local SEPARATOR = "  •  "
local CHAT_RULE = "|T%s:2:190:0:0:8:8:0:8:0:8:%d:%d:%d|t"

local THEMES = {
	class = { accentTop = true, divider = true, color = function() return MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b end },
	custom = { accentTop = true, accentBottom = true, divider = true, color = function() return mMT:HexToRGB(module.db.colors.theme) end },
	minimal = {},
}

local function CancelTimer(key)
	if module[key] then
		module[key]:Cancel()
		module[key] = nil
	end
end

local function ClearInfo()
	module.info_screen.lable:SetText("")
	module.info_screen.lable2:SetText("")
	module.info_screen.lable3:SetText("")
end

local function Details(activity, difficulty)
	activity, difficulty = activity or "", difficulty or ""
	if activity ~= "" and difficulty ~= "" then
		return format("%s%s%s", mMT:TC(activity, "line_b"), mMT:TC(SEPARATOR, "gray"), mMT:TC(difficulty, "line_c"))
	end

	return activity ~= "" and mMT:TC(activity, "line_b") or mMT:TC(difficulty, "line_c")
end

-- activityIDs and groupName are secret on results read inside an instance; indexing or branching on a secret throws, only issecretvalue may probe it
local function PlainValue(value)
	if not E:IsSecretValue(value) then return value end
end

local function SetInfo(location, activity, difficulty, group)
	local screen = module.info_screen
	group = group or ""
	screen.lable:SetText(mMT:TC(location or "", "line_a"))
	screen.lable2:SetText(Details(activity, difficulty))
	screen.lable3:SetText(group ~= "" and mMT:TC(group, "tip") or "")
end

local function AccentColor()
	local theme = THEMES[module.db.theme] or THEMES.class
	if not theme.color then return 1, 1, 1 end
	return theme.color()
end

local function ChatRule()
	local r, g, b = AccentColor()
	return format(CHAT_RULE, E.media.blankTex, floor(r * 255), floor(g * 255), floor(b * 255))
end

local function ApplyTheme()
	local screen = module.info_screen
	if not screen then return end

	local theme = THEMES[module.db.theme] or THEMES.class
	local r, g, b = AccentColor()
	local hasBG = module.db.background

	screen.accent:SetVertexColor(r, g, b, 1)
	screen.accent:SetShown(theme.accentTop and hasBG)

	screen.accentBottom:SetVertexColor(r, g, b, 1)
	screen.accentBottom:SetShown(theme.accentBottom and hasBG)

	screen.divider:SetVertexColor(r, g, b, 0.45)
	screen.divider:SetShown(theme.divider)
end

local function UpdateLayout()
	local screen = module.info_screen
	if not screen then return end

	local card, iconSize = screen.card, screen.embeddedIconSize
	local iconSpace = iconSize and (iconSize + SPACING) or 0
	local justify = iconSize and "LEFT" or "CENTER"
	local hasGroup = (screen.lable3:GetText() or "") ~= ""

	screen.lable3:SetShown(hasGroup)

	screen.lable:SetJustifyH(justify)
	screen.lable2:SetJustifyH(justify)
	screen.lable3:SetJustifyH(justify)

	local textWidth = max(screen.lable:GetStringWidth(), screen.lable2:GetStringWidth(), screen.lable3:GetStringWidth()) + 2
	screen.lable:SetWidth(textWidth)
	screen.lable2:SetWidth(textWidth)
	screen.lable3:SetWidth(textWidth)

	local dividerSpace = screen.divider:IsShown() and (SPACING * 2 + 1) or SPACING
	local groupSpace = hasGroup and (screen.lable3:GetStringHeight() + LINE_SPACING) or 0
	local textHeight = screen.lable:GetStringHeight() + dividerSpace + screen.lable2:GetStringHeight() + groupSpace
	local width = textWidth + PADDING * 2 + iconSpace
	local height = max(textHeight + PADDING * 2, (iconSize or 0) + PADDING * 2)

	screen.lable:ClearAllPoints()
	screen.lable:SetPoint("TOPLEFT", card, "TOPLEFT", PADDING + iconSpace, -((height - textHeight) / 2))

	screen.divider:ClearAllPoints()
	screen.divider:SetPoint("TOPLEFT", screen.lable, "BOTTOMLEFT", 0, -SPACING)
	screen.divider:SetWidth(textWidth)

	screen.lable2:ClearAllPoints()
	screen.lable2:SetPoint("TOPLEFT", screen.divider:IsShown() and screen.divider or screen.lable, "BOTTOMLEFT", 0, -SPACING)

	screen.lable3:ClearAllPoints()
	screen.lable3:SetPoint("TOPLEFT", screen.lable2, "BOTTOMLEFT", 0, -LINE_SPACING)

	screen:SetSize(width, height)
	card:SetSize(width, height)
end

local function ApplyAnimation()
	local card = module.info_screen.card
	local style = module.db.animation.style
	local slide = style == "slide" and SLIDE or 0
	local scale = style == "pop" and POP_SCALE or 1

	card.slide = slide
	card.showMove:SetOffset(0, slide)
	card.hideMove:SetOffset(0, -slide)
	card.showScale:SetScaleFrom(scale, scale)
	card.hideScale:SetScaleTo(scale, scale)
end

local function RestCard()
	local card = module.info_screen.card
	card:ClearAllPoints()
	card:SetPoint("CENTER", module.info_screen, "CENTER", 0, 0)
	card:SetAlpha(1)
end

-- an animation group does not start on a frame that was shown in the same tick, so set the start state now and play on the next one
local function PlayShowAnim()
	local screen = module.info_screen
	if not (screen and screen:IsShown()) then return end

	screen.card.showAnim:Play()
	if not screen.card.showAnim:IsPlaying() then RestCard() end
end

local function ShowCard()
	local screen = module.info_screen
	local card = screen.card

	card.showAnim:Stop()
	card.hideAnim:Stop()
	module.clearOnHide = nil

	RestCard()
	screen:Show()
	UpdateLayout()

	if not module.db.animation.enable then return end

	card:SetAlpha(0)
	card:ClearAllPoints()
	card:SetPoint("CENTER", screen, "CENTER", 0, -card.slide)
	C_Timer_After(0, PlayShowAnim)
end

local function HideCard(clearText)
	local screen = module.info_screen
	local card = screen.card

	card.showAnim:Stop()
	card.hideAnim:Stop()
	RestCard()

	if module.db.animation.enable then
		module.clearOnHide = clearText
		card.hideAnim:Play()
		return
	end

	screen:Hide()
	if clearText then ClearInfo() end
end

local function HideInfo(clearText)
	CancelTimer("showTimer")
	CancelTimer("hideTimer")

	local screen = module.info_screen
	if not screen then return end

	screen.demo = false

	if screen:IsShown() then
		HideCard(clearText)
	elseif clearText then
		ClearInfo()
	end
end

local function ShowInfo(keepVisible)
	if not module.info_screen then return end

	module.lastShownAt = GetTime()
	ShowCard()

	CancelTimer("hideTimer")
	if keepVisible then return end

	module.hideTimer = C_Timer_NewTimer(module.db.delay, function()
		module.hideTimer = nil
		HideInfo()
	end)
end

local function QueueShowInfo()
	if not module.info_screen then return end

	CancelTimer("showTimer")
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

local function CreateAnimations(card)
	local show = card:CreateAnimationGroup()
	local showAlpha = show:CreateAnimation("Alpha")
	showAlpha:SetFromAlpha(0)
	showAlpha:SetToAlpha(1)
	showAlpha:SetDuration(ANIM_TIME)
	showAlpha:SetSmoothing("OUT")

	card.showMove = show:CreateAnimation("Translation")
	card.showMove:SetDuration(ANIM_TIME)
	card.showMove:SetSmoothing("OUT")

	card.showScale = show:CreateAnimation("Scale")
	card.showScale:SetScaleTo(1, 1)
	card.showScale:SetOrigin("CENTER", 0, 0)
	card.showScale:SetDuration(ANIM_TIME)
	card.showScale:SetSmoothing("OUT")

	show:SetScript("OnFinished", RestCard)
	card.showAnim = show

	local hide = card:CreateAnimationGroup()
	local hideAlpha = hide:CreateAnimation("Alpha")
	hideAlpha:SetFromAlpha(1)
	hideAlpha:SetToAlpha(0)
	hideAlpha:SetDuration(ANIM_TIME)
	hideAlpha:SetSmoothing("IN")

	card.hideMove = hide:CreateAnimation("Translation")
	card.hideMove:SetDuration(ANIM_TIME)
	card.hideMove:SetSmoothing("IN")

	card.hideScale = hide:CreateAnimation("Scale")
	card.hideScale:SetScaleFrom(1, 1)
	card.hideScale:SetOrigin("CENTER", 0, 0)
	card.hideScale:SetDuration(ANIM_TIME)
	card.hideScale:SetSmoothing("IN")

	-- OnFinished also fires on Stop(), requested tells the two apart
	hide:SetScript("OnFinished", function(_, requested)
		if requested then return end
		module.info_screen:Hide()
		RestCard()
		if module.clearOnHide then ClearInfo() end
		module.clearOnHide = nil
	end)
	card.hideAnim = hide
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
		SetInfo(info.name, info.acc, info.diff, info.grp)
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

	-- the gold theme became a free color, keep profiles that still name it
	if module.db.theme == "gold" then module.db.theme = "custom" end

	if not module.info_screen then
		local screen = CreateFrame("Button", "mMediaTag_LFG_Invite_Info", E.UIParent)
		module.info_screen = screen
		screen:SetFrameStrata("TOOLTIP")
		screen:SetToplevel(true)
		screen:SetClampedToScreen(true)
		screen:SetPoint("CENTER", 0, 200)
		screen:SetSize(400, 100)

		local card = CreateFrame("Frame", nil, screen, "BackdropTemplate")
		card:SetPoint("CENTER", screen, "CENTER", 0, 0)
		card:SetSize(400, 100)
		card.slide = 0
		screen.card = card

		if module.db.background then card:SetTemplate("Transparent", true) end

		local function CreateLine()
			local tex = card:CreateTexture(nil, "OVERLAY")
			tex:SetTexture(E.media.blankTex)
			return tex
		end

		local accent = CreateLine()
		accent:SetHeight(2)
		accent:SetPoint("TOPLEFT", card, "TOPLEFT", 1, -1)
		accent:SetPoint("TOPRIGHT", card, "TOPRIGHT", -1, -1)
		screen.accent = accent

		local accentBottom = CreateLine()
		accentBottom:SetHeight(2)
		accentBottom:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 1, 1)
		accentBottom:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -1, 1)
		screen.accentBottom = accentBottom

		local divider = CreateLine()
		divider:SetHeight(1)
		screen.divider = divider

		local function CreateText()
			local text = card:CreateFontString(nil, "OVERLAY")
			text:SetTextColor(1, 1, 1, 1)
			text:SetWordWrap(false)
			return text
		end

		screen.lable = CreateText()
		screen.lable2 = CreateText()
		screen.lable3 = CreateText()

		CreateAnimations(card)

		screen:RegisterForClicks("AnyDown")
		screen:SetScript("OnClick", function(_, btn)
			if btn == "RightButton" then HideInfo() end
		end)

		E:CreateMover(screen, "mMediaTag_LFG_Invite_Info_Mover", "mMT " .. L["LFG Invite Info"], nil, nil, nil, "ALL,MMEDIATAG", function()
			return E.db.mMediaTag.lfg_invite_info.enable
		end, "mMT,misc,lfg_invite_info")
		screen:Hide()
	end

	local font = LSM:Fetch("font", module.db.text.font)
	E:SetFont(module.info_screen.lable, font, module.db.text.size, module.db.text.fontFlag)
	E:SetFont(module.info_screen.lable2, font, module.db.text.size2, module.db.text.fontFlag)
	E:SetFont(module.info_screen.lable3, font, module.db.text.size2, module.db.text.fontFlag)

	ApplyTheme()
	ApplyAnimation()

	if not module.isEnabled then
		module:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
		module:RegisterEvent("LFG_LIST_JOINED_GROUP")
		module:RegisterEvent("GROUP_LEFT")
		module:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		module.isEnabled = true
	end

	if module.db.icon ~= "none" then
		module.info_screen.icon = module.info_screen.icon or module.info_screen.card:CreateTexture(nil, "ARTWORK")
		local icon = module.info_screen.icon
		icon:SetTexture(MEDIA.icons.lfg[module.db.icon])
		icon:ClearAllPoints()
		icon:Show()

		if module.db.embed_icon and module.db.background then
			local size = module.db.text.size + module.db.text.size2
			icon:SetSize(size, size)
			icon:SetPoint("LEFT", module.info_screen.card, "LEFT", PADDING, 0)
			module.info_screen.embeddedIconSize = size
		else
			local size = (module.db.text.size + module.db.text.size2) * 2
			icon:SetSize(size, size)
			icon:SetPoint("RIGHT", module.info_screen.card, "LEFT", -SPACING, 0)
			module.info_screen.embeddedIconSize = nil
		end
	else
		module.info_screen.embeddedIconSize = nil
		if module.info_screen.icon then module.info_screen.icon:Hide() end
	end

	if module.info_screen:IsShown() then UpdateLayout() end

	if demo then module:Demo() end
end

function module:LFG_LIST_JOINED_GROUP(_, searchResultID, groupName)
	local searchResultData = PlainValue(GetSearchResultInfo(searchResultID))
	local ids = searchResultData and PlainValue(searchResultData.activityIDs)
	local id = ids and PlainValue(ids[1])

	if not id then return end

	local fullName = GetActivityFullName(id) or ""
	local activityInfo = GetActivityInfoTable(id)
	local difficulty, activity = "", ""

	if activityInfo then
		difficulty = GetDifficultyInfo(PlainValue(activityInfo.difficultyID)) or fullName:match("%((.-)%)") or ""
		activity = activityInfo.shortName or activityInfo.fullName or ""
	end

	local location = gsub(fullName, "%s*%(.-%)%s*$", "")
	local group = PlainValue(groupName) or ""

	SetInfo(location, activity, difficulty, group)

	if module.db.print then
		local rule = ChatRule()
		print(rule)
		print(mMT:AddSettingsIcon(mMT:TC(location, "line_a"), "greeting_message"))
		print(Details(activity, difficulty))
		if group ~= "" then print(mMT:TC(group, "tip")) end
		print(rule)
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
