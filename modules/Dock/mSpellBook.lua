local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", SPELLBOOK_ABILITIES_BUTTON)
local mTextName = "mSpellBook"

local function mDockCheckFrame()
	return (SpellBookFrame and SpellBookFrame:IsShown())
end

function mMT:CheckFrameSpellBook(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(SPELLBOOK_ABILITIES_BUTTON)
		DT.tooltip:Show()
	end
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameSpellBook")
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.spellbook.icon],
		Notifications = false,
		Text = false,
		Spezial = false,
		IconColor = E.db.mMT.dockdatatext.spellbook.iconcolor,
		CustomColor = E.db.mMT.dockdatatext.spellbook.customcolor,
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
		mMT:mOnClick(self, "CheckFrameSpellBook")
		if not SpellBookFrame:IsShown() then
			ShowUIPanel(SpellBookFrame)
		else
			HideUIPanel(SpellBookFrame)
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
