local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local _G = _G
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
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(ENCOUNTER_JOURNAL)
		DT.tooltip:Show()
	end
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameEncounterJournal")
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		icon = {
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.encounter.icon],
			color = E.db.mMT.dockdatatext.encounter.iconcolor,
			customcolor = E.db.mMT.dockdatatext.encounter.customcolor,
		},
	}

	mMT:DockInitialization(self, event)
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
		mMT:mOnClick(self, "CheckFrameEncounterJournal")
		if not IsAddOnLoaded("Blizzard_EncounterJournal") then
			UIParentLoadAddOn("Blizzard_EncounterJournal")
		end
		if not EncounterJournal:IsShown() then
			EncounterJournal_OpenJournal()
		else
			ToggleFrame(_G.EncounterJournal)
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
