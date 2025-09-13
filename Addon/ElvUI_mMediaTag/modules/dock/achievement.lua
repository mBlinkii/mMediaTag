local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock

-- Lua functions
local format = format
local GetTotalAchievementPoints = GetTotalAchievementPoints
local GetTrackedIDs = C_ContentTracking.GetTrackedIDs
local GetAchievementInfo = GetAchievementInfo

-- Variables
local _G = _G

local config = {
	name = "mMT_Dock_Achievement",
	localizedName = "|CFF01EEFFDock|r" .. " " .. ACHIEVEMENT_BUTTON,
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMT.dock.tooltip then
		DT.tooltip:AddLine(mMT:TC(ACHIEVEMENT_BUTTON, "title"))
		DT.tooltip:AddLine(" ")

		local points = GetTotalAchievementPoints()
		local guildPoints = GetTotalAchievementPoints(true)
		DT.tooltip:AddDoubleLine(mMT:TC(L["Achievement points:"], "mark"), mMT:TC(points or 0))
		DT.tooltip:AddDoubleLine(mMT:TC(L["Guild Achievement points:"], "mark"), mMT:TC(guildPoints or 0))

		local trackedAchievements = GetTrackedIDs(Enum.ContentTrackingType.Achievement)

		if trackedAchievements and (#trackedAchievements ~= 0) then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(mMT:TC(L["Tracked Achievements"], "title"), mMT:TC(#trackedAchievements))
			for i = 1, #trackedAchievements do
				local achievementID = trackedAchievements[i]
				local _, achievementName, _, completed, _, _, _, _, _, icon = GetAchievementInfo(achievementID)
				DT.tooltip:AddDoubleLine(mMT:TC(format("|T%s:15:15:0:0|t %s", icon, achievementName)), mMT:TC(completed and L["Completed"] or L["Missing"], completed and "green" or "red"))
			end
		end

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then
		Dock:Click(self)
		_G.ToggleAchievementFrame()
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		-- setup settings
		config.icon.texture = icons[E.db.mMT.dock.achievement.style][E.db.mMT.dock.achievement.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.achievement.custom_color and MEDIA.color.dock.achievement or nil

		Dock:CreateDockIcon(self, config, event)
	end
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
