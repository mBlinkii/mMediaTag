local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format

--Variables
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
	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:AddDoubleLine(ACHIEVEMENT_BUTTON, format("|CFFFFFFFF%s|r", L["Points"]))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(
			format(mMT:mClassColorString(), UnitName("player")),
			format("|CFF6495ED%s|r", GetTotalAchievementPoints())
		)

		ID1, ID2 = GetTrackedAchievements()
		if ID1 or ID2 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(L["Tracked Achievements"], format("|CFFFFFFFF%s|r", GetNumTrackedAchievements()))

			local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch =
				GetAchievementInfo(ID1)

			if ID1 and Name and RewardText then
				IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch =
					GetAchievementInfo(ID1)

				DT.tooltip:AddLine(" ")
				DT.tooltip:AddDoubleLine(
					format("|CFF40E0D0%s|r", Name),
					Completed and "|CFF88FF88completed|r" or "|CFFFF8888missing|r"
				)
				if not Completed and Description then
					DT.tooltip:AddLine(format("|CFFFFFFFF%s|r", Description))
				end
			end

			if ID2 then
				IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch =
					GetAchievementInfo(ID2)

				DT.tooltip:AddLine(" ")
				DT.tooltip:AddDoubleLine(
					format("|CFF40E0D0%s|r", Name),
					Completed and "|CFF88FF88completed|r" or "|CFFFF8888missing|r"
				)
				if not Completed and Description then
					DT.tooltip:AddLine(format("|CFFFFFFFF%s|r", Description))
				end
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
		IconTexture = E.db[mPlugin].mDock.achievement.path,
		Notifications = false,
		Text = false,
		Spezial = false,
		IconColor = E.db[mPlugin].mDock.achievement.iconcolor,
		CustomColor = E.db[mPlugin].mDock.achievement.customcolor,
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
		mMT:mOnClick(self, "CheckFrameAchievement")
		ToggleAchievementFrame()
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
