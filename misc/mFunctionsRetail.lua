local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...

--Lua functions
local string, type, ipairs, date = string, type, ipairs, date
local gmatch, gsub, format = gmatch, gsub, format
local unpack, pairs, wipe, floor, ceil = unpack, pairs, wipe, floor, ceil
local strfind, strmatch, strlower, strsplit = strfind, strmatch, strlower, strsplit
local utf8lower, utf8sub, utf8len = string.utf8lower, string.utf8sub, string.utf8len
local mInsert = table.insert

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
local C_ChallengeMode_GetDungeonScoreRarityColor  = C_ChallengeMode.GetDungeonScoreRarityColor

--Great Vault Functions
local function mColorGardient(level)
	local r, g, b = E:ColorGradient(level * 0.04 , 0, .43, .86, .63, .2, .93, .89, .16, .31)
	return E:RGBToHex(r, g, b)
end

function mMT:mGetVaultInfo()
    local vaultinfo = {}
    local vaultinforaid, vaultinfomplus, vaultinfopvp, vaultinfohighest, ok = {}, {}, {}, nil, nil
	vaultinfo = C_WeeklyRewards.GetActivities()
	if not vaultinfo then 
		return {}, {}, {}, nil, false
	else
		local vaultinfohighest, ok = 0, false
		for i = 1, 9 do
			local id = vaultinfo[i] and vaultinfo[i].id or 0
			local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(id)
			if itemLink then
				local ItemLevelInfo = GetDetailedItemLevelInfo(itemLink)
				if ItemLevelInfo then
					vaultinfohighest = (vaultinfohighest and (vaultinfohighest < ItemLevelInfo) and ItemLevelInfo or vaultinfohighest) or (not vaultinfohighest and ItemLevelInfo)
					if i < 4 then
						mInsert(vaultinfomplus, format("%s%s|r", mColorGardient(ItemLevelInfo), ItemLevelInfo))
					elseif i < 7 then
						mInsert(vaultinfopvp, format("%s%s|r", mColorGardient(ItemLevelInfo), ItemLevelInfo))
					else
						mInsert(vaultinforaid, format("%s%s|r", mColorGardient(ItemLevelInfo), ItemLevelInfo))
					end
					ok = true
				end
			end
		end
		vaultinfohighest = format("%s%s|r", mColorGardient(tonumber(vaultinfohighest)), vaultinfohighest)
		return vaultinforaid, vaultinfomplus, vaultinfopvp, vaultinfohighest, ok
	end
end

function mMT:MythPlusDifficultyShort()
	local name, instanceType, instanceDifficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamicInstance = GetInstanceInfo()
	local nhc, hc, myth, mythp, other, titel = mMT:mColorDatatext()
	
	if instanceDifficultyID == 8 then
		local keyStoneLevel, _ = C_ChallengeMode.GetActiveKeystoneInfo()
		local r, g, b = E:ColorGradient(keyStoneLevel * 0.06 , .1, 1, .1, 1, 1, .1, 1, .1, .1)
		if keyStoneLevel ~= nil and C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
			return format("%s%s|r", E:RGBToHex(r, g, b), keyStoneLevel)
		else
			return format("%s%s|r", mythp, L["M+"])
		end
	else
		return format("%s%s|r", other, E:ShortenString(difficultyName, 1))
	end
end

--Keystone Functions
function mMT:OwenKeystone()
	local OwenKeystoneText = {}
	local keyStoneLevel, keyStoneLevelMax = C_MythicPlus.GetOwnedKeystoneLevel(), 20
	
	if keyStoneLevel then
		local challengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(challengeMapID)
		local r, g, b = E:ColorGradient(keyStoneLevel * 0.06 , .1, 1, .1, 1, 1, .1, 1, .1, .1) 
		local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()
		
		mInsert(OwenKeystoneText, 1, format("%s%s|r", titel, L["Mythic Plus Keystone"]))
		mInsert(OwenKeystoneText, 2, format("%s%s: |r %s%s|r%s +%s|r", other, L["Keystone"], myth, name, E:RGBToHex(r, g, b), keyStoneLevel))
		
		--if E.db[mPlugin].mLogKeystone then
		--	--E.db[mPlugin].mKeystoneDB = 
		--	mInsert(E.db[mPlugin].mKeystoneDB, "name", "key")
		--end

		return OwenKeystoneText
	end
end

--Affixes Functions
function mMT:WeeklyAffixes()
	local WeeklyAffixesText, affixes = {}, {}
	local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()
	local AffixText = nil
	local savedYear = E.db[mPlugin].mSavedAffixes.year

	if (date("%u") == "2") or (date("%u") == "3" or date("%y") ~= savedYear) and not E.db[mPlugin].mSavedAffixes.reset then
		E.db[mPlugin].mSavedAffixes.affixes = nil
		E.db[mPlugin].mSavedAffixes.reset = true
		E.db[mPlugin].mSavedAffixes.year = date("%y")
	elseif (date("%u") ~= "2") and (date("%u") ~= "3") then
		E.db[mPlugin].mSavedAffixes.reset = false
	end
	
	if (date("%u") ~= "2") and (date("%u") ~= "3") then
		affixes = E.db[mPlugin].mSavedAffixes.affixes
		if (affixes) == nil then
			affixes = C_MythicPlus.GetCurrentAffixes()
			if affixes ~= nil then
				E.db[mPlugin].mSavedAffixes.affixes = affixes
			end
		end
	else
		affixes = C_MythicPlus.GetCurrentAffixes()
		E.db[mPlugin].mSavedAffixes.affixes = affixes
		E.db[mPlugin].mSavedAffixes.year = date("%y")
	end
	
	if (affixes) then
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
		if not (affixes) == nil then
			E.db[mPlugin].mSavedAffixes.affixes = affixes
		end
	end
	
	if AffixText ~= nil then
		local seasonID = C_MythicPlus.GetCurrentSeason()
		if seasonID <= 0 then
			seasonID = E.db[mPlugin].mSavedAffixes.season
		end
		
		if seasonID >= 1 then
			E.db[mPlugin].mSavedAffixes.season = seasonID
			
			mInsert(WeeklyAffixesText, 1, format("%s%s|r", titel, L["This Week Affix"]))
			mInsert(WeeklyAffixesText, 2, format("%s%s|r", other, AffixText))
			
			return WeeklyAffixesText
		else
			mInsert(WeeklyAffixesText, 3, format("%s%s|n%s|r", ns.mColor5, L["Saisson has not started yet."], L["%sERROR! Please open the Mythic+ window, LFG Tool or Reload UI!|r"]))
			return WeeklyAffixesText
		end
	else
		mInsert(WeeklyAffixesText, 3, format(L["%sERROR! Please open the Mythic+ window, LFG Tool or Reload UI!|r"], ns.mColor5))
		return WeeklyAffixesText
	end
end

--Instance Informations Myth+
function mMT:MythicPlusDungeon()
	local MythicPlusDungeonText = {}
	local keyStoneLevel, _ = C_ChallengeMode.GetActiveKeystoneInfo()
	local name, instanceType, instanceDifficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamicInstance = GetInstanceInfo()
	local nhc, hc, myth, mythp, other, titel, tip = mMT:mColorDatatext()
	local r, g, b = E:ColorGradient(keyStoneLevel * 0.06 , .1, 1, .1, 1, 1, .1, 1, .1, .1)
	
	mInsert(MythicPlusDungeonText, 1, format("%s%s|r", titel, L["Mythic Plus"]))
	mInsert(MythicPlusDungeonText, 2, format("%s%s: |r %s%s|r%s +%s|r", other, L["Keystone"], myth, name, E:RGBToHex(r, g, b), keyStoneLevel))
	
	return MythicPlusDungeonText
end

--Achievements
local function mAchievementInfo(mID)
	local mAchievementInfoText = {}
	local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy = GetAchievementInfo(mID)
	mAchievementInfoText = {name = name, icon = mMT:mIcon(icon)}
	return mAchievementInfoText
end

function mMT:Achievement(option)
	local AchievementText = {}
	local _, _, _, _, other, titel, tip = mMT:mColorDatatext()
	local colorCompletStatus = tip
	if option == 15 then 
		-- Score 2000
		local info0 = mAchievementInfo(15078)
		local a, _, c, d, e = GetAchievementCriteriaInfo(15078, 1)
		if d == e then
			colorCompletStatus = "|CFF58D68D"
		else
			colorCompletStatus = tip
		end
		mInsert(AchievementText, 0, format("%s%s|r %s", titel, info0.name, info0.icon))
		mInsert(AchievementText, 1, {format("%s%s|r %s(%s/%s)|r", other, a, colorCompletStatus, d, e), string.format("[%s]", c and format("%s%s|r", ns.mColor6, L["True"]) or format("%s%s|r", ns.mColor5, L["False"]))})
	elseif option == 10 then
		-- Score 1500
		local info0 = mAchievementInfo(15077)
		local a, _, c, d, e = GetAchievementCriteriaInfo(15077, 1)
		if d == e then
			colorCompletStatus = "|CFF58D68D"
		else
			colorCompletStatus = tip
		end
		mInsert(AchievementText, 0, format("%s%s|r %s", titel, info0.name, info0.icon))
		mInsert(AchievementText, 1, {format("%s%s|r %s(%s/%s)|r", other, a, colorCompletStatus, d, e), string.format("[%s]", c and format("%s%s|r", ns.mColor6, L["True"]) or format("%s%s|r", ns.mColor5, L["False"]))})
	elseif option == 0 then
		local info0 = mAchievementInfo(15073)
		-- Score 750
		local a, _, c, d, e = GetAchievementCriteriaInfo(15073, 1)
		if d == e then
			colorCompletStatus = "|CFF58D68D"
		else
			colorCompletStatus = tip
		end
		mInsert(AchievementText, 0, format("%s%s|r %s", titel, info0.name, info0.icon))
		mInsert(AchievementText, 1, {format("%s%s|r %s(%s/%s)|r", other, a, colorCompletStatus, d, e), string.format("[%s]", c and format("%s%s|r", ns.mColor6, L["True"]) or format("%s%s|r", ns.mColor5, L["False"]))})
	end
	return AchievementText
end

function mMT:GetDungeonScore()
	local data = C_PlayerInfo_GetPlayerMythicPlusRatingSummary("PLAYER")
	local seasonScore = data and data.currentSeasonScore
	local color = C_ChallengeMode_GetDungeonScoreRarityColor(seasonScore) 
	local colorString = E:RGBToHex(color.r, color.g, color.b)
	return colorString .. seasonScore .. "|r"
end