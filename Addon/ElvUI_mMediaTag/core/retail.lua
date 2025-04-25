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
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local GetDifficultyInfo = GetDifficultyInfo
local InGuildParty = InGuildParty

local shortNames = {
	-- tww
	[2648] = "ROOK", --The Rookery
	[2649] = "PSF", --Priory of the Sacred Flame
	[2651] = "DFC", --Darkflame Cleft
	[2652] = "SV", --The Stonevault
	[2660] = "ARAK", --Ara-Kara, City of Echoes
	[2661] = "BREW", --Cinderbrew Meadery
	[2662] = "DAWN", --The Dawnbreaker
	[2669] = "COT", --City of Threads
	[2773] = "FLOOD", --Operation: Floodgate

	--df
	[2451] = "ULD", --Uldaman: Legacy of Tyr
	[2515] = "AV", --The Azure Vault
	[2516] = "NO", --The Nokhud Offensive
	[2519] = "NELTH", --Neltharus
	[2520] = "BH", --Brackenhide Hollow
	[2521] = "RLP", --Ruby Life Pools
	[2526] = "AA", --Algeth'ar Academy
	[2527] = "HOI", --Halls of Infusion
	[2579] = "DOTI", --Dawn of the Infinite

	-- sl
	[2284] = "SD", --Sanguine Depths
	[2285] = "SOA", --Spires of Ascension
	[2286] = "NW", --The Necrotic Wake
	[2287] = "HOA", --Halls of Atonement
	[2289] = "PF", --Plaguefall
	[2290] = "MISTS", --Mists of Tirna Scithe
	[2291] = "DOS", --De Other Side
	[2293] = "TOP", --Theater of Pain
	[2441] = "TAZ", --Tazavesh, the Veiled Market

	-- bfa
	[1594] = "ML", --The MOTHERLODE!!
	[1754] = "FH", --Freehold
	[1762] = "KR", --Kings' Rest
	[1763] = "AD", --Atal'Dazar
	[1771] = "DAGOR", --Tol Dagor
	[1822] = "SIEGE", --Siege of Boralus
	[1841] = "UNDR", --The Underrot
	[1862] = "WM", --Waycrest Manor
	[1864] = "SOS", --Shrine of the Storm
	[1877] = "TOS", --Temple of Sethraliss
	[2097] = "MECHA", --Operation: Mechagon

	-- legion
	[1456] = "EOA", --Eye of Azshara
	[1458] = "NL", --Neltharion's Lair
	[1466] = "DT", --Darkheart Thicket
	[1477] = "HOV", --Halls of Valor
	[1492] = "MOS", --Maw of Souls
	[1493] = "VOTW", --Vault of the Wardens
	[1501] = "BRH", --Black Rook Hold
	[1516] = "ARC", --The Arcway
	[1544] = "VH", --Violet Hold
	[1571] = "COS", --Court of Stars
	[1651] = "KARA", --Return to Karazhan
	[1677] = "COEN", --Cathedral of Eternal Night
	[1753] = "SOT", --Seat of the Triumvirate

	-- wod
	[1182] = "AUCH", --Auchindoun
	[1175] = "BSM", --Bloodmaul Slag Mines
	[1176] = "SBG", --Shadowmoon Burial Grounds
	[1195] = "ID", --Iron Docks
	[1208] = "GD", --Grimrail Depot
	[1209] = "SR", --Skyreach
	[1279] = "EB", --The Everbloom
	[1358] = "UBRS", --Upper Blackrock Spire

	-- mop
	[959] = "SM", --Shado-pan Monastery
	[960] = "TJS", --Temple of the Jade Serpent
	[961] = "SSB", --Stormstout Brewery
	[962] = "GOTSS", --Gate of the Setting Sun
	[994] = "MSP", --Mogu'Shan Palace
	[1011] = "SNT", --Siege of Niuzao Temple

	-- cata
	[568] = "ZA", --Zul'Aman
	[643] = "TOTT", --Throne of the Tides
	[644] = "HOC", --Halls of Origination
	[645] = "BC", --Blackrock Caverns
	[657] = "VP", --The Vortex Pinnacle
	[670] = "GB", --Grim Batol
	[725] = "SC", --The Stonecore
	[755] = "LCOTT", --Lost City of the Tol'vir
	[859] = "ZG", --Zul'Gurub
	[938] = "ET", --End Time
	[939] = "WE", --Well of Eternity
	[940] = "HT", --Hour of Twilight

	--wrath
	[574] = "UK", --Utgarde Keep
	[575] = "UP", --Utgarde Pinnacle
	[576] = "NEXUS", --The Nexus
	[578] = "OCULUS", --The Oculus
	[595] = "TCOS", --The Culling of Stratholme
	[599] = "HS", --Halls of Stone
	[600] = "DRAK", --Drak'Tharon Keep
	[601] = "NERUB", --Azjol-Nerub
	[602] = "HOL", --Halls of Lightning
	[604] = "GD", --Gundrak
	[608] = "VH", --The Violet Hold
	[619] = "AHN", --Ahn'kahet: The Old Kingdom
	[632] = "FOS", --The Forge of Souls
	[650] = "TOC", --Trial of the Champion
	[658] = "POS", --Pit of Saron
	[668] = "HOR", --Halls of Reflection

	-- Quest Scenarios
	[2570] = "TFR",
	[2444] = "DI",
	[2512] = "GTA",
	[2518] = "OB",
	[2523] = "TDD",
	[2524] = "TRD",
	[2529] = "YB",
	[2534] = "DI-BDC",
	[2556] = "ED",
	[2563] = "NPGA",
	[2573] = "LA",
	[2574] = "DIR",

	-- Time Rifts
	[2639] = "TR",
	[2635] = "TR",
	[2634] = "TR",
	[2595] = "TR",
	[2594] = "TR",
	[2593] = "TR",
	[2587] = "TR",
	[2586] = "TR",
}

function mMT:GetMyKeystone(withIcon)
	local keyStoneLevel = GetOwnedKeystoneLevel()
	if keyStoneLevel then
		local color = ITEM_QUALITY_COLORS[4]
		local challengeMapID = GetOwnedKeystoneChallengeMapID()
		local name, id, _, icon, _ = GetMapUIInfo(challengeMapID)
		local colorKey = GetKeystoneLevelRarityColor(keyStoneLevel)
		colorKey.hex = colorKey and colorKey:GenerateHexColor() or "FFFFFFFF"

		return (withIcon and E:TextureString(icon, ":14:14") .. " " or "") .. color.hex .. name .. " " .. format("|c%s+%s|r", colorKey.hex, keyStoneLevel) .. "|r", id
	end
end

function mMT:GetMyMythicPlusScore()
	local score = GetOverallDungeonScore()
	local color = GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
	color.hex = color:GenerateHexColor() or "FFFFFFFF"

	return format("|c%s%s|r", color.hex, score)
end

local GetCurrentAffixes = C_MythicPlus.GetCurrentAffixes
local GetAffixInfo = C_ChallengeMode.GetAffixInfo

function mMT:GetWeeklyAffixes()
	if not _G.ChallengesFrame then UIParentLoadAddOn("Blizzard_ChallengesUI") end

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

function mMT:GetDungeonInfo()
	local isInInstance, instanceType = IsInInstance()
	if not isInInstance then return end


	--if not name then return end --or (hideDelve and difficultyID == 208)

	local info = {}

	local name, _, difficultyID, _, _, _, _, instanceID, instanceGroupSize = GetInstanceInfo()
	local difficultyName, _, _, _, _, _, toggleDifficultyID = GetDifficultyInfo(difficultyID)

	info.name = name
	info.shortName = shortNames[instanceID] or E:ShortenString(name, 6)
	info.difficultyName = difficultyName
	info.toggleDifficultyID = toggleDifficultyID
	info.isGuildParty = InGuildParty()
	info.instanceType = instanceType
	info.instanceID = instanceID
	info.instanceGroupSize = instanceGroupSize

	return info
end
