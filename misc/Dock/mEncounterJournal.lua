local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", ENCOUNTER_JOURNAL)
local mTextName = "mEncounterJournal"

local function mDockCheckFrame()
	return (EncounterJournal and EncounterJournal:IsShown())
end

function mMT:CheckFrameEncounterJournal(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:AddLine(ENCOUNTER_JOURNAL)
		DT.tooltip:Show()
	end
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameEncounterJournal")
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.encounter.path,
		Notifications = false,
		Text = false,
		Spezial = false,
		IconColor = E.db[mPlugin].mDock.encounter.iconcolor,
		CustomColor = E.db[mPlugin].mDock.encounter.customcolor,
	}

	mMT:DockInitialisation(self)
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
		mMT:mOnClick(self, "CheckFrameEncounterJournal")
		ToggleEncounterJournal()
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
