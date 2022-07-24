local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", BLIZZARD_STORE)
local mTextName = "mBlizzardStore"

local function mDockCheckFrame()
	return (StoreFrame and StoreFrame_IsShown())
end

function mMT:CheckFrameBlizzardStore(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameBlizzardStore")

	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:AddLine(BLIZZARD_STORE)
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.blizzardstore.path,
		Notifications = false,
		Text = false,
		Spezial = false,
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
	mMT:mOnClick(self, "CheckFrameBlizzardStore")
	StoreMicroButton:Click()
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
