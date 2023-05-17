local E, L = unpack(ElvUI)

--Lua functions
local string, ipairs = string, ipairs
local format = format
local wipe =  wipe
local tinsert = tinsert

--WoW API / Variables
local GetInstanceInfo = GetInstanceInfo
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
		local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(challengeMapID)
		local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()

		tinsert(OwenKeystoneText, 1, format("%s%s|r", titel, L["Mythic Plus Keystone"]))
		tinsert(OwenKeystoneText, 2, format("%s%s:|r %s%s|r %s", other, L["Keystone"], myth, name, mMT:GetKeyColor(keyStoneLevel)))
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
	wipe(WeeklyAffixesText)
	wipe(affixes)
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

--Great Vault Functions
function mMT:mGetVaultInfo()
	local vaultinfo = {}
	vaultinfo = wipe(vaultinfo)
	local vaultinforaid, vaultinfomplus, vaultinfopvp, vaultinfohighest, ok = {}, {}, {}, nil, nil
	vaultinforaid = wipe(vaultinforaid)
	vaultinfomplus = wipe(vaultinfomplus)
	vaultinfopvp = wipe(vaultinfopvp)
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
					vaultinfohighest = (
						vaultinfohighest and (vaultinfohighest < ItemLevelInfo) and ItemLevelInfo or vaultinfohighest
					) or (not vaultinfohighest and ItemLevelInfo)
					if i < 4 then
						tinsert(vaultinfomplus, format("%s%s|r", mMT:mColorGardient(ItemLevelInfo), ItemLevelInfo))
					elseif i < 7 then
						tinsert(vaultinfopvp, format("%s%s|r", mMT:mColorGardient(ItemLevelInfo), ItemLevelInfo))
					else
						tinsert(vaultinforaid, format("%s%s|r", mMT:mColorGardient(ItemLevelInfo), ItemLevelInfo))
					end
					ok = true
				end
			end
		end
		vaultinfohighest = format("%s%s|r", mMT:mColorGardient(tonumber(vaultinfohighest)), vaultinfohighest)
		return vaultinforaid, vaultinfomplus, vaultinfopvp, vaultinfohighest, ok
	end
end

--Dungeon Difficulty
function mMT:DungeonDifficultyShort()
	local name, instanceType, instanceDifficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamicInstance =
		GetInstanceInfo()
	local nhc, hc, myth, mythp, other, titel = mMT:mColorDatatext()

	if
		instanceDifficultyID == 1
		or instanceDifficultyID == 3
		or instanceDifficultyID == 4
		or instanceDifficultyID == 14
	then
		return format("%s%s|r", nhc, L["N"])
	elseif
		instanceDifficultyID == 2
		or instanceDifficultyID == 5
		or instanceDifficultyID == 6
		or instanceDifficultyID == 15
		or instanceDifficultyID == 39
		or instanceDifficultyID == 149
	then
		return format("%s%s|r", hc, L["H"])
	elseif instanceDifficultyID == 23 or instanceDifficultyID == 16 or instanceDifficultyID == 40 then
		return format("%s%s|r", myth, L["M"])
	elseif instanceDifficultyID == 8 then
		local keyStoneLevel, _ = C_ChallengeMode.GetActiveKeystoneInfo()
		local r, g, b = E:ColorGradient(keyStoneLevel * 0.06, 0.1, 1, 0.1, 1, 1, 0.1, 1, 0.1, 0.1)
		if
			keyStoneLevel ~= nil
			and C_MythicPlus.IsMythicPlusActive()
			and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil)
		then
			return format(L["%sM|r%s+%s|r"], mythp, E:RGBToHex(r, g, b), keyStoneLevel)
		else
			return format("%s%s|r", mythp, L["M+"])
		end
	elseif instanceDifficultyID == 24 then
		return format("%s%s|r", "|CFF85C1E9", E:ShortenString(difficultyName, 1))
	elseif instanceDifficultyID == 167 then
		return format("%s%s|r", "|CFFF4D03F", E:ShortenString(difficultyName, 1))
	else
		return format("%s%s|r", other, E:ShortenString(difficultyName, 1))
	end
end
