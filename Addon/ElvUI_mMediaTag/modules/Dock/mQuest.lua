local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local _G = _G
local mText = format("Dock %s", QUESTLOG_BUTTON)
local mTextName = "mQuest"

local function mDockCheckFrame()
	return (WorldMapFrame and WorldMapFrame:IsShown())
end

function mMT:CheckFrameQuest(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(QUESTLOG_BUTTON)
		DT.tooltip:Show()
	end
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameQuest")
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		icon = {
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.quest.icon],
			color = E.db.mMT.dockdatatext.quest.iconcolor,
			customcolor = E.db.mMT.dockdatatext.quest.customcolor,
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
		mMT:mOnClick(self, "CheckFrameQuest")
		_G.ToggleQuestLog()
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
