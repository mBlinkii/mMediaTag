local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local _G = _G
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
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(L["Calendar"])
		local DateText = ""
		local day, month, year = date("%d"), date("%m"), date("%y")
		local option = E.db.mMT.dockdatatext.calendar.option
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
	local option = E.db.mMT.dockdatatext.calendar.option
	local texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.calendar.icon]
	if option ~= "none" then
		EnableText = true
	end

	if E.db.mMT.dockdatatext.calendar.dateicon ~= "none" then
		texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\calendar\\".. E.db.mMT.dockdatatext.calendar.dateicon .. date("%d") .. ".tga"
	else
		texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.calendar.icon]
	end
	self.mSettings = {
		Name = mTextName,
		text = {
			spezial = EnableText,
			textA = EnableText,
			textB = false,
		},
		icon = {
			texture = texture,
			color = E.db.mMT.dockdatatext.calendar.iconcolor,
			customcolor = E.db.mMT.dockdatatext.calendar.customcolor,
		},
	}

	local DateText = nil
	if EnableText and not E.db.mMT.dockdatatext.calendar.dateicon == "none" then
		local day, month, year = date("%d"), date("%m"), date("%y")
		if E.db.mMT.dockdatatext.calendar.showyear then
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
	end

	mMT:DockInitialisation(self, event, DateText)
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:mOnClick(self, "CheckFrameCalendar")
		if E.Retail then
			_G.GameTimeFrame:Click()
		elseif E.Wrath then
			_G.Calendar_LoadUI()
			_G.ToggleCalendar()
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
