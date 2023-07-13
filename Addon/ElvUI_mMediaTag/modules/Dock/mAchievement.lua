local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local _G = _G
local mText = format("Dock %s", ACHIEVEMENT_BUTTON)
local mTextName = "mAchievement"

local function mDockCheckFrame()
	return (AchievementFrame and AchievementFrame:IsShown())
end

function mMT:CheckFrameAchievement(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(ACHIEVEMENT_BUTTON)
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(
			format(mMT.ClassColor.string, UnitName("player")),
			format("|CFF6495ED%s|r", GetTotalAchievementPoints())
		)

		local trackedAchievements = C_ContentTracking.GetTrackedIDs(Enum.ContentTrackingType.Achievement)

		if trackedAchievements and (#trackedAchievements ~= 0) then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(L["Tracked Achievements"], format("|CFFFFFFFF%s|r", #trackedAchievements))
			for i = 1, #trackedAchievements do
				local achievementID = trackedAchievements[i]
				local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe =
					GetAchievementInfo(achievementID)
				DT.tooltip:AddDoubleLine(
					format("|T%s:15:15:0:0|t |CFF40E0D0%s|r", icon, achievementName),
					completed and "|CFF88FF88" .. L["Completed"] .. "|r" or "|CFFFF8888" .. L["Missing"] .. "|r"
				)
			end
		end

		DT.tooltip:Show()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameAchievement")
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		icon = {
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.achievement.icon],
			color = E.db.mMT.dockdatatext.achievement.iconcolor,
			customcolor = E.db.mMT.dockdatatext.achievement.customcolor,
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
		mMT:mOnClick(self, "CheckFrameAchievement")
		_G.ToggleAchievementFrame()
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
