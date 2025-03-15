local E = unpack(ElvUI)
local L = mMT.Locales

--Lua functions
local ipairs = ipairs
local format = format
local wipe = wipe
local tinsert = tinsert

--WoW API / Variables
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local C_MythicPlus = C_MythicPlus
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor

function mMT:OwenKeystone()
	local OwenKeystoneText = {}
	wipe(OwenKeystoneText)
	local keyStoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()

	if keyStoneLevel then
		local challengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local name, _, _, _, _ = C_ChallengeMode.GetMapUIInfo(challengeMapID)
		local nhc, hc, myth, _, other, title = mMT:mColorDatatext()

		tinsert(OwenKeystoneText, 1, format("%s%s|r", title, L["Mythic Plus Keystone"]))
		tinsert(OwenKeystoneText, 2, format("%s%s:|r %s%s|r %s", other, L["Keystone"], myth, name, mMT:GetKeyColor(keyStoneLevel)))
		return OwenKeystoneText
	end
end

function mMT:GetDungeonScore()
	local data = C_PlayerInfo_GetPlayerMythicPlusRatingSummary("PLAYER")
	local seasonScore = data and data.currentSeasonScore
	if seasonScore and seasonScore > 0 then
		local color = C_ChallengeMode_GetDungeonScoreRarityColor(seasonScore)
		local hex = color and color:GenerateHexColor() or "FFFFFFFF"
		return "|C" .. hex .. seasonScore .. "|r"
	else
		return L["No Score"]
	end
end

function mMT:WeeklyAffixes()
	local WeeklyAffixesText, affixes = {}, {}
	wipe(WeeklyAffixesText)
	wipe(affixes)
	local _, _, _, _, other, title = mMT:mColorDatatext()
	local AffixText = nil
	local savedYear = mMT.DB.mplusaffix.year

	affixes = C_MythicPlus.GetCurrentAffixes()

	if (date("%u") == "2") or (date("%u") == "3" or date("%y") ~= savedYear) and not mMT.DB.mplusaffix.reset then
		mMT.DB.mplusaffix.affixes = nil
		mMT.DB.mplusaffix.reset = true
		mMT.DB.mplusaffix.year = date("%y")
	elseif (date("%u") ~= "2") and (date("%u") ~= "3") then
		mMT.DB.mplusaffix.reset = false
	end

	if not affixes and (date("%u") ~= "2") and (date("%u") ~= "3") then
		affixes = mMT.DB.mplusaffix.affixes
		if affixes == nil then
			affixes = C_MythicPlus.GetCurrentAffixes()
			if affixes ~= nil then mMT.DB.mplusaffix.affixes = affixes end
		end
	else
		affixes = C_MythicPlus.GetCurrentAffixes()
		mMT.DB.mplusaffix.affixes = affixes
		mMT.DB.mplusaffix.year = date("%y")
	end

	if affixes then
		for i, affix in ipairs(affixes) do
			local name, _, _ = C_ChallengeMode.GetAffixInfo(affix.id)
			if AffixText == nil then
				AffixText = name
			else
				AffixText = format("%s, %s", AffixText, name)
			end
		end
	else
		affixes = C_MythicPlus.GetCurrentAffixes()
		if not affixes == nil then mMT.DB.mplusaffix.affixes = affixes end
	end

	if AffixText ~= nil then
		local seasonID = C_MythicPlus.GetCurrentSeason()
		if seasonID <= 0 then seasonID = mMT.DB.mplusaffix.season end

		if seasonID >= 1 then
			mMT.DB.mplusaffix.season = seasonID

			tinsert(WeeklyAffixesText, 1, format("%s%s|r", title, L["This Week Affix"]))
			tinsert(WeeklyAffixesText, 2, format("%s%s|r", other, AffixText))

			return WeeklyAffixesText
		else
			tinsert(WeeklyAffixesText, 3, format("|CFFE74C3C%s|n%s|r", L["Season has not started yet."], L["ERROR! Please open the Mythic+ window, LFG Tool or Reload UI!"]))
			return WeeklyAffixesText
		end
	else
		tinsert(WeeklyAffixesText, 3, format("|CFFE74C3C%s|r", L["ERROR! Please open the Mythic+ window, LFG Tool or Reload UI!"]))
		return WeeklyAffixesText
	end
end

--Great Vault Functions

--  [16:47]   [1] table: 0000026AFCE2E360
--  [16:47]         [type]  =  1
--  [16:47]         [index]  =  1
--  [16:47]         [activityTierID]  =  13
--  [16:47]         [progress]  =  1
--  [16:47]         [rewards]  >  table: 0000026AFCE2E3B0
--  [16:47]         [threshold]  =  1
--  [16:47]         [level]  =  0
--  [16:47]         [raidString]  =  Besiegt %d Bosse im Palast der Nerub'ar
--  [16:47]         [id]  =  134
--  [16:47]   [2] table: 0000026AFCE2E400
--  [16:47]         [type]  =  1
--  [16:47]         [index]  =  2
--  [16:47]         [activityTierID]  =  0
--  [16:47]         [progress]  =  1
--  [16:47]         [rewards]  >  table: 0000026AFCE2E450
--  [16:47]         [threshold]  =  4
--  [16:47]         [level]  =  0
--  [16:47]         [raidString]  =  Besiegt %d Bosse im Palast der Nerub'ar
--  [16:47]         [id]  =  135
--  [16:47]   [3] table: 0000026AFCE2E4A0
--  [16:47]         [type]  =  1
--  [16:47]         [index]  =  3
--  [16:47]         [activityTierID]  =  0
--  [16:47]         [progress]  =  1
--  [16:47]         [rewards]  >  table: 0000026AFCE2E4F0
--  [16:47]         [threshold]  =  8
--  [16:47]         [level]  =  0
--  [16:47]         [raidString]  =  Besiegt %d Bosse im Palast der Nerub'ar
--  [16:47]         [id]  =  136

local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local GetActivities = C_WeeklyRewards.GetActivities
local WrapTextInColorCode = WrapTextInColorCode
local GetExampleRewardItemHyperlinks =  C_WeeklyRewards.GetExampleRewardItemHyperlinks

local function padNumber(n, w)
	n = n or 0
	return format("%" .. w .. "s", n)
end

function mMT:mGetVaultInfo()
	local tblRewards = {
		raid = {
			name = RAID,
			rewards = {},
		},
		dungeons = {
			name = DUNGEONS,
			rewards = {},
		},
		world = {
			name = WORLD,
			rewards = {},
		},
	}

	local function processRewards(rewardType, rewardTable)
		local rewards = GetActivities(rewardType)
		for _, reward in pairs(rewards) do
			if reward.progress < reward.threshold then
				tinsert(rewardTable, WrapTextInColorCode(reward.progress .. "/" .. reward.threshold, "ff9d9d9d"))
			else
				local itemLink = GetExampleRewardItemHyperlinks(reward.id)
				local itemLevel = itemLink and GetDetailedItemLevelInfo(itemLink) or ""
				local color = GetKeystoneLevelRarityColor(reward.level)
				if color then tinsert(rewardTable, color:WrapTextInColorCode(padNumber("+" .. reward.level, 3) .. " (" .. itemLevel .. ")")) end
			end
		end
	end

	processRewards(Enum.WeeklyRewardChestThresholdType.Raid, tblRewards.raid.rewards)
	processRewards(Enum.WeeklyRewardChestThresholdType.Activities, tblRewards.dungeons.rewards)
	processRewards(Enum.WeeklyRewardChestThresholdType.World, tblRewards.world.rewards)

	return tblRewards
end
