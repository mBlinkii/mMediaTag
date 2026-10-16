local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local GetOverallDungeonScore = C_ChallengeMode.GetOverallDungeonScore
local GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local GetActivities = C_WeeklyRewards.GetActivities
local GetExampleRewardItemHyperlinks = C_WeeklyRewards.GetExampleRewardItemHyperlinks
local GetDetailedItemLevelInfo = C_Item and C_Item.GetDetailedItemLevelInfo or GetDetailedItemLevelInfo
local GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
local GetScenarioHeaderDelvesWidgetVisualizationInfo = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo

function mMT:GetMyKeystone(withIcon)
	local keyStoneLevel = GetOwnedKeystoneLevel()
	if keyStoneLevel then
		local color = ITEM_QUALITY_COLORS[4]
		local challengeMapID = GetOwnedKeystoneChallengeMapID()
		local name, id, _, icon, _ = GetMapUIInfo(challengeMapID)
		local colorKey = GetKeystoneLevelRarityColor(keyStoneLevel)
		local keyHex = colorKey and colorKey:GenerateHexColor() or "FFFFFFFF"

		return (withIcon and E:TextureString(icon, ":14:14") .. " " or "") .. color.hex .. name .. " " .. format("|c%s+%s|r", keyHex, keyStoneLevel) .. "|r", id
	end
end

function mMT:GetMyMythicPlusScore()
	local score = GetOverallDungeonScore()
	local color = GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR

	return format("|c%s%s|r", color:GenerateHexColor(), score)
end

function mMT:GetActiveKeystoneLevel()
	local keystoneLevel = GetActiveKeystoneInfo()
	local keystoneColor = GetKeystoneLevelRarityColor(keystoneLevel)
	return keystoneColor:WrapTextInColorCode(keystoneLevel)
end

local GetCurrentAffixes = C_MythicPlus.GetCurrentAffixes
local GetAffixInfo = C_ChallengeMode.GetAffixInfo

function mMT:GetWeeklyAffixes()
	if not _G.ChallengesFrame then E:LoadAddon("Blizzard_ChallengesUI") end

	local affixes = GetCurrentAffixes()
	if not affixes then return L["No current Mythic+ affixes found."] end

	local affixString

	for _, affixInfo in ipairs(affixes) do
		local name, _ = GetAffixInfo(affixInfo.id)
		if not affixString then
			affixString = name
		else
			affixString = affixString .. ", " .. name
		end
	end

	return affixString
end

local function GetRewards(rewardType)
	local rewards = GetActivities(rewardType)
	local rewardsString = ""

	for _, reward in pairs(rewards) do
		if reward.progress < reward.threshold then
			local progressText = mMT:TC(reward.progress .. "/" .. reward.threshold, "tip")
			rewardsString = rewardsString == "" and progressText or rewardsString .. " / " .. progressText
		else
			local itemLink = GetExampleRewardItemHyperlinks(reward.id)
			local itemLevel = itemLink and GetDetailedItemLevelInfo(itemLink) or ""
			local color = GetKeystoneLevelRarityColor(reward.level)
			if color then
				local rewardText = WrapTextInColorCode(tostring(itemLevel), "ffa335ee") .. " (" .. color:WrapTextInColorCode("+" .. reward.level) .. ")"
				rewardsString = rewardsString == "" and rewardText or rewardsString .. " / " .. rewardText
			end
		end
	end

	return rewardsString
end

function mMT:GetVaultInfo()
	local vaultInfoRaid = GetRewards(Enum.WeeklyRewardChestThresholdType.Raid)
	local vaultInfoDungeons = GetRewards(Enum.WeeklyRewardChestThresholdType.Activities)
	local vaultInfoWorld = GetRewards(Enum.WeeklyRewardChestThresholdType.World)

	return vaultInfoRaid, vaultInfoDungeons, vaultInfoWorld
end

function mMT:GetCurrentDelveTier()
	local widgetIDs = {
		{ id = 6183, tierType = "numbered" },
		{ id = 6184, tierType = "?" },
		{ id = 6185, tierType = "??" },
	}

	for _, widget in ipairs(widgetIDs) do
		local delveInfo = GetScenarioHeaderDelvesWidgetVisualizationInfo(widget.id)
		if delveInfo and delveInfo.shownState == Enum.WidgetShownState.Shown then
			if widget.tierType ~= "numbered" then return widget.tierType end

			local tierText = delveInfo.tierText or ""
			return tonumber(tierText:match("%d+")) or 1
		end
	end

	return 1
end
