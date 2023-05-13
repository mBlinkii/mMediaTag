local mMT, E, L, V, P, G = unpack((select(2, ...)))
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
		DT.tooltip:AddDoubleLine(ACHIEVEMENT_BUTTON, format("|CFFFFFFFF%s|r", L["Points"]))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(
			format(mMT.ClassColor.string, UnitName("player")),
			format("|CFF6495ED%s|r", GetTotalAchievementPoints())
		)

		local ID1, ID2 = GetTrackedAchievements()

		if ID1 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(L["Tracked Achievements"], format("|CFFFFFFFF%s|r", GetNumTrackedAchievements()))
			local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch =
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
			local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch =
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

	mMT:DockInitialisation(self, event)
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
