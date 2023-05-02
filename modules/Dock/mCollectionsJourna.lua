local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", COLLECTIONS)
local mTextName = "mCollectionsJourna"

local function mDockCheckFrame()
	return (CollectionsJournal and CollectionsJournal:IsShown())
end

function mMT:CheckFrameCollectionsJourna(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameCollectionsJourna")

	local numOwned = 0
	local mountIDs = C_MountJournal.GetMountIDs()
	for i, mountID in ipairs(mountIDs) do
		local _, _, _, _, _, _, _, _, _, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
		if isCollected and hideOnChar ~= true then
			numOwned = numOwned + 1
		end
	end

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(COLLECTIONS)
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Collected"])
		DT.tooltip:AddDoubleLine(format("|CFF40E0D0%s|r", L["Mounts"]), format("|CFF6495ED%s|r", numOwned))
		DT.tooltip:AddDoubleLine(format("|CFFDE3163%s|r", L["Pets"]), format("|CFF6495ED%s|r", select(2,C_PetJournal.GetNumPets())))
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.collection.icon],
		Notifications = false,
		Text = false,
		Spezial = false,
		IconColor = E.db.mMT.dockdatatext.collection.iconcolor,
		CustomColor = E.db.mMT.dockdatatext.collection.customcolor,
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
	if mMT:CheckCombatLockdown() then
		mMT:mOnClick(self, "CheckFrameCollectionsJourna")
		ToggleCollectionsJournal()
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
