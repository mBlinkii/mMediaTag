local mMT, E, L, V, P, G = unpack((select(2, ...)))

--Lua functions
local string, type, ipairs = string, type, ipairs
local gmatch, gsub, format = gmatch, gsub, format
local unpack, pairs, wipe, floor, ceil = unpack, pairs, wipe, floor, ceil
local strfind, strmatch, strlower, strsplit = strfind, strmatch, strlower, strsplit
local utf8lower, utf8sub, utf8len = string.utf8lower, string.utf8sub, string.utf8len
local tinsert = tinsert

--WoW API / Variables
local _G = _G
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementInfo = GetAchievementInfo
local GetInstanceInfo = GetInstanceInfo
local GetDifficultyInfo = GetDifficultyInfo
local GetRaidDifficultyID = GetRaidDifficultyID
local GetDungeonDifficultyID = GetDungeonDifficultyID
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local C_MythicPlus = C_MythicPlus
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local C_ChallengeMode_GetOverallDungeonScore = C_ChallengeMode.GetOverallDungeonScore
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor

function mMT:OwenKeystone()
	local OwenKeystoneText = {}
	OwenKeystoneText = wipe(OwenKeystoneText)
	local keyStoneLevel, keyStoneLevelMax = C_MythicPlus.GetOwnedKeystoneLevel(), 20

	if keyStoneLevel then
		local challengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(challengeMapID)
		local r, g, b = E:ColorGradient(keyStoneLevel * 0.06, 0.1, 1, 0.1, 1, 1, 0.1, 1, 0.1, 0.1)
		local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()

		tinsert(OwenKeystoneText, 1, format("%s%s|r", titel, L["Mythic Plus Keystone"]))
		tinsert(OwenKeystoneText, 2, format("%s%s: |r %s%s|r%s +%s|r", other, L["Keystone"], myth, name, E:RGBToHex(r, g, b), keyStoneLevel))
		return OwenKeystoneText
	end
end

function mMT:GetDungeonScore()
	local data = C_PlayerInfo_GetPlayerMythicPlusRatingSummary("PLAYER")
	local seasonScore = data and data.currentSeasonScore
	local color = C_ChallengeMode_GetDungeonScoreRarityColor(seasonScore)
	local colorString = E:RGBToHex(color.r, color.g, color.b)
	if seasonScore > 0 then
		return colorString .. seasonScore .. "|r"
	else
		return L["No Score"]
	end
end

function mMT:WeeklyAffixes()
	local WeeklyAffixesText, affixes = {}, {}
	WeeklyAffixesText = wipe(WeeklyAffixesText)
	affixes = wipe(affixes)
	local _, _, _, _, other, titel = mMT:mColorDatatext()
	local AffixText = nil
	local savedYear = E.global.mMT.mplusaffix.year

	affixes = C_MythicPlus.GetCurrentAffixes()

	if
		(date("%u") == "2")
		or (date("%u") == "3" or date("%y") ~= savedYear) and not E.global.mMT.mplusaffix.reset
	then
		E.global.mMT.mplusaffix.affixes = nil
		E.global.mMT.mplusaffix.reset = true
		E.global.mMT.mplusaffix.year = date("%y")
	elseif (date("%u") ~= "2") and (date("%u") ~= "3") then
		E.global.mMT.mplusaffix.reset = false
	end

	if not affixes and (date("%u") ~= "2") and (date("%u") ~= "3") then
		affixes = E.global.mMT.mplusaffix.affixes
		if affixes == nil then
			affixes = C_MythicPlus.GetCurrentAffixes()
			if affixes ~= nil then
				E.global.mMT.mplusaffix.affixes = affixes
			end
		end
	else
		affixes = C_MythicPlus.GetCurrentAffixes()
		E.global.mMT.mplusaffix.affixes = affixes
		E.global.mMT.mplusaffix.year = date("%y")
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
		if not affixes == nil then
			E.global.mMT.mplusaffix.affixes = affixes
		end
	end

	if AffixText ~= nil then
		local seasonID = C_MythicPlus.GetCurrentSeason()
		if seasonID <= 0 then
			seasonID = E.global.mMT.mplusaffix.season
		end

		if seasonID >= 1 then
			E.global.mMT.mplusaffix.season = seasonID

			tinsert(WeeklyAffixesText, 1, format("%s%s|r", titel, L["This Week Affix"]))
			tinsert(WeeklyAffixesText, 2, format("%s%s|r", other, AffixText))

			return WeeklyAffixesText
		else
			tinsert(
				WeeklyAffixesText,
				3,
				format( "|CFFE74C3C%s|n%s|r", L["Season has not started yet."], L["%sERROR! Please open the Mythic+ window, LFG Tool or Reload UI!|r"] )
			)
			return WeeklyAffixesText
		end
	else
		tinsert(
			WeeklyAffixesText,
			3,
			format("|CFFE74C3C%s|r", L["ERROR! Please open the Mythic+ window, LFG Tool or Reload UI!"])
		)
		return WeeklyAffixesText
	end
end