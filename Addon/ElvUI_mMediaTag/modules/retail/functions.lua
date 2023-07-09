local E, L = unpack(ElvUI)

--Lua functions
local string, ipairs = string, ipairs
local format = format
local wipe = wipe
local tinsert = tinsert

--WoW API / Variables
local GetInstanceInfo = GetInstanceInfo
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local C_MythicPlus = C_MythicPlus
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo

local totalDurability = 0
local invDurability = {}
local totalRepairCost

local slots = {
	[1] = _G.INVTYPE_HEAD,
	[3] = _G.INVTYPE_SHOULDER,
	[5] = _G.INVTYPE_CHEST,
	[6] = _G.INVTYPE_WAIST,
	[7] = _G.INVTYPE_LEGS,
	[8] = _G.INVTYPE_FEET,
	[9] = _G.INVTYPE_WRIST,
	[10] = _G.INVTYPE_HAND,
	[16] = _G.INVTYPE_WEAPONMAINHAND,
	[17] = _G.INVTYPE_WEAPONOFFHAND,
	[18] = _G.INVTYPE_RANGED,
}
function mMT:GetDurabilityInfo()

	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc, repairCost = (currentDura/maxDura)*100, 0
			invDurability[index] = perc

			if perc < totalDurability then
				totalDurability = perc
			end

			if E.Retail and E.ScanTooltip.GetTooltipData then
				E.ScanTooltip:SetInventoryItem('player', index)
				E.ScanTooltip:Show()

				local data = E.ScanTooltip:GetTooltipData()
				repairCost = data and data.repairCost
			else
				repairCost = select(3, E.ScanTooltip:SetInventoryItem('player', index))
			end

			totalRepairCost = totalRepairCost + (repairCost or 0)
		end
	end

	local r, g, b = E:ColorGradient(totalDurability * .01, 1, .1, .1, 1, 1, .1, .1, 1, .1)
	local hex = E:RGBToHex(r, g, b)

	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	return { durability = mMT:round(totalDurability), repair = (( totalRepairCost ~= 0) and GetMoneyString(totalRepairCost)) or nil}
end

-- local Currency = {
-- 	info = {
-- 		color = "|CFFFF8000",
-- 		id = 204194,
-- 		name = nil,
-- 		icon = nil,
-- 		link = nil,
-- 		count = nil,
--         cap = nil,
-- 	},
-- 	bag = {
-- 		id = 204078,
-- 		link = nil,
-- 		icon = nil,
-- 		count = nil,
-- 	},
-- 	fragment = {
-- 		id = 2412,
-- 		cap = nil,
-- 		quantity = nil,
-- 	},
-- 	loaded = false,
-- }
function mMT:GetCurrenciesInfo(tbl, item)
	if tbl and tbl.info and tbl.info.id then
		local itemName, itemLink, itemTexture, itemStackCount  = nil, nil, nil, nil
		local info = nil

		if item then
			itemName, itemLink, _, _, _, _, _, itemStackCount , _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(tbl.info.id)
			if itemName and itemLink and itemTexture then
				tbl.info.name = itemName
				tbl.info.icon = mMT:mIcon(itemTexture, 12, 12)
				tbl.info.link = itemLink
				tbl.info.count = GetItemCount(tbl.info.id, true)
				tbl.info.cap = itemStackCount
				tbl.loaded = true
			end
		else
			info = C_CurrencyInfo_GetCurrencyInfo(tbl.info.id)
			if info then
				tbl.info.name = info.name
				tbl.info.icon = mMT:mIcon(info.iconFileID, 12, 12)
				tbl.info.link = mMT:mCurrencyLink(tbl.info.id)
				tbl.info.count = info.quantity
				tbl.loaded = true
				if not tbl.fragment and info.maxQuantity then
					tbl.info.cap = info.maxQuantity
				end
			end
		end

		if tbl.bag and tbl.bag.id then
			itemName, itemLink, _, _, _, _, _, _, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(tbl.bag.id)
			if itemName and itemLink and itemTexture then
				tbl.bag.link = itemLink
				tbl.bag.icon = mMT:mIcon(itemTexture, 12, 12)
				tbl.bag.count = GetItemCount(tbl.bag.id, true)
			end
		end

		if tbl.fragment and tbl.fragment.id then
			info = C_CurrencyInfo_GetCurrencyInfo(tbl.fragment.id)
			if info then
				tbl.fragment.cap = info.maxQuantity
				tbl.fragment.quantity = info.quantity or 0
			end
		end
	else
		error(L["GetCurrenciesInfo no Table or no ID."])
	end
end

function mMT:OwenKeystone()
	local OwenKeystoneText = {}
	wipe(OwenKeystoneText)
	local keyStoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()

	if keyStoneLevel then
		local challengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(challengeMapID)
		local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()

		tinsert(OwenKeystoneText, 1, format("%s%s|r", titel, L["Mythic Plus Keystone"]))
		tinsert(
			OwenKeystoneText,
			2,
			format("%s%s:|r %s%s|r %s", other, L["Keystone"], myth, name, mMT:GetKeyColor(keyStoneLevel))
		)
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

			tinsert(WeeklyAffixesText, 1, format("%s%s|r", titel, L["This Week Affix"]))
			tinsert(WeeklyAffixesText, 2, format("%s%s|r", other, AffixText))

			return WeeklyAffixesText
		else
			tinsert(
				WeeklyAffixesText,
				3,
				format(
					"|CFFE74C3C%s|n%s|r",
					L["Season has not started yet."],
					L["%sERROR! Please open the Mythic+ window, LFG Tool or Reload UI!|r"]
				)
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
