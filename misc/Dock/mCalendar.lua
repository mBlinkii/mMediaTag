local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", L["Calendar"])
local mTextName = "mCalendar"

local function mDockCheckFrame()
	return (CalendarFrame and CalendarFrame:IsShown())
end

function mMT:CheckFrameCalendar(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:AddLine(L["Calendar"])
		local DateText = ""
		local day, month, year = date("%d"), date("%m"), date("%y")
		local option = E.db[mPlugin].mDock.calendar.option
		if option == "de" then
			DateText = format("%s.%s.%s", day, month, year)
		elseif option == "us" then
			DateText = format("%s/%s/%s", month, day, year)
		elseif option == "gb" then
			DateText = format("%s/%s/%s", day, month, year)
		end
		DT.tooltip:AddLine(DateText)
		DT.tooltip:Show()
	end
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameCalendar")
end

local function OnEvent(self, event, ...)
	local EnableText = false
	local option = E.db[mPlugin].mDock.calendar.option
	local texture = E.db[mPlugin].mDock.calendar.path
	if option ~= "none" then
		EnableText = true
	end

	if E.db[mPlugin].mDock.calendar.dateicon then
		texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\calendar\\c" .. date("%d") .. ".tga"
	else
		texture = E.db[mPlugin].mDock.calendar.path
	end

	self.mSettings = {
		Name = mTextName,
		IconTexture = texture,
		Notifications = false,
		Text = EnableText,
		Spezial = EnableText,
		IconColor = E.db[mPlugin].mDock.calendar.iconcolor,
		CustomColor = E.db[mPlugin].mDock.calendar.customcolor,
	}

	mMT:DockInitialisation(self)

	if EnableText and not E.db[mPlugin].mDock.calendar.dateicon then
		local DateText = ""
		local day, month, year = date("%d"), date("%m"), date("%y")
		if E.db[mPlugin].mDock.calendar.showyear then
			if option == "de" then
				DateText = format("%s.%s.%s", day, month, year)
			elseif option == "us" then
				DateText = format("%s/%s/%s", month, day, year)
			elseif option == "gb" then
				DateText = format("%s/%s/%s", day, month, year)
			end
		else
			if option == "de" then
				DateText = format("%s.%s", day, month)
			elseif option == "us" then
				DateText = format("%s/%s", month, day)
			elseif option == "gb" then
				DateText = format("%s/%s", day, month)
			end
		end

		self.mIcon.TextA:SetFormattedText(mMT:mClassColorString(), DateText)
	end
end

local function OnLeave(self)
	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:mOnClick(self, "CheckFrameCalendar")
		if E.Retail then
			GameTimeFrame:Click()
		else
			Calendar_LoadUI()
			ToggleCalendar()
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
