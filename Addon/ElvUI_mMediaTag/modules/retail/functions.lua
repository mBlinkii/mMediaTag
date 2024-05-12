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
			if affixes ~= nil then
				mMT.DB.mplusaffix.affixes = affixes
			end
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
		if not affixes == nil then
			mMT.DB.mplusaffix.affixes = affixes
		end
	end

	if AffixText ~= nil then
		local seasonID = C_MythicPlus.GetCurrentSeason()
		if seasonID <= 0 then
			seasonID = mMT.DB.mplusaffix.season
		end

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

local function isMaxLevel(unit)
	local exp, maxxp = UnitXP("player"), UnitXPMax("player")
	return "%s / %s", exp, maxxp
end

--Great Vault Functions
function mMT:mGetVaultInfo()
	local vaultinfo = {}
	vaultinfo = wipe(vaultinfo)
	local vaultinforaid, vaultinfomplus, vaultinfopvp, vaultinfohighest, ok = {}, {}, {}, nil, false
	vaultinforaid = wipe(vaultinforaid)
	vaultinfomplus = wipe(vaultinfomplus)
	vaultinfopvp = wipe(vaultinfopvp)
	vaultinfo = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Activities)

	if not vaultinfo then
		return {}, {}, {}, nil, false
	else
		table.sort(vaultinfo, function(left, right)
			return left.index < right.index
		end)
		for i = 1, 9 do
			local id = vaultinfo[i] and vaultinfo[i].id or 0
			local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(id)
			if itemLink then
				local ItemLevelInfo = GetDetailedItemLevelInfo(itemLink)
				if ItemLevelInfo then
					vaultinfohighest = (vaultinfohighest and (vaultinfohighest < ItemLevelInfo) and ItemLevelInfo or vaultinfohighest) or (not vaultinfohighest and ItemLevelInfo)
					if i < 4 then
						tinsert(vaultinfomplus, format("%s%s|r", mMT:mColorGradient(ItemLevelInfo), ItemLevelInfo))
					elseif i < 7 then
						tinsert(vaultinfopvp, format("%s%s|r", mMT:mColorGradient(ItemLevelInfo), ItemLevelInfo))
					else
						tinsert(vaultinforaid, format("%s%s|r", mMT:mColorGradient(ItemLevelInfo), ItemLevelInfo))
					end
					ok = true
				end
			end
		end
		local vaultinfohighestString = format("%s%s|r", mMT:mColorGradient(tonumber(vaultinfohighest) or 0), vaultinfohighest or 0)
		return vaultinforaid, vaultinfomplus, vaultinfopvp, vaultinfohighestString, ok
	end
end
