local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local _G = _G
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

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(BLIZZARD_STORE)
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.blizzardstore.icon],
		Notifications = false,
		Text = false,
		Spezial = false,
		IconColor = E.db.mMT.dockdatatext.blizzardstore.iconcolor,
		CustomColor = E.db.mMT.dockdatatext.blizzardstore.customcolor,
	}

	mMT:DockInitialisation(self)
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self)
	mMT:mOnClick(self, "CheckFrameBlizzardStore")
	_G.StoreMicroButton:Click()
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
