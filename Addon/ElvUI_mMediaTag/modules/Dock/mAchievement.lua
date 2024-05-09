local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local _G = _G

local Config = {
	name = "mMT_Dock_Achievement",
	localizedName = mMT.DockString .. " " .. ACHIEVEMENT_BUTTON,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(ACHIEVEMENT_BUTTON)
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(format(mMT.ClassColor.string, UnitName("player")), format("|CFF6495ED%s|r", GetTotalAchievementPoints()))

		if E.Retail then
			local trackedAchievements = C_ContentTracking.GetTrackedIDs(Enum.ContentTrackingType.Achievement)

			if trackedAchievements and (#trackedAchievements ~= 0) then
				DT.tooltip:AddLine(" ")
				DT.tooltip:AddDoubleLine(L["Tracked Achievements"], format("|CFFFFFFFF%s|r", #trackedAchievements))
				for i = 1, #trackedAchievements do
					local achievementID = trackedAchievements[i]
					local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achievementID)
					DT.tooltip:AddDoubleLine(format("|T%s:15:15:0:0|t |CFF40E0D0%s|r", icon, achievementName), completed and "|CFF88FF88" .. L["Completed"] .. "|r" or "|CFFFF8888" .. L["Missing"] .. "|r")
				end
			end
		end

		DT.tooltip:Show()
	end

	mMT:Dock_OnEnter(self, Config)
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.achievement.icon]
		Config.icon.color = E.db.mMT.dockdatatext.achievement.customcolor and E.db.mMT.dockdatatext.achievement.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		_G.ToggleAchievementFrame()
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
