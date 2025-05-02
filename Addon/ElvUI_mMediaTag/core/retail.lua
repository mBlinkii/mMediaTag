local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

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
local GetDungeonDifficultyID = GetDungeonDifficultyID
local GetRaidDifficultyID = GetRaidDifficultyID
local GetLegacyRaidDifficultyID = GetLegacyRaidDifficultyID
local GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
local GetScenarioHeaderDelvesWidgetVisualizationInfo = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo

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

local shortDifficulty = {}

local function UpdateColors()
	shortDifficulty = {
		[1] = { color = COLORS.N, name = "N" }, --Normal	party
		[2] = { color = COLORS.H, name = "H" }, --Heroic	party	isHeroic
		[3] = { color = COLORS.N, name = "10N" }, --10 Player	raid	toggleDifficultyID: 5
		[4] = { color = COLORS.N, name = "25N" }, --25 Player	raid	toggleDifficultyID: 6
		[5] = { color = COLORS.H, name = "10H" }, --10 Player (Heroic)	raid	isHeroic, toggleDifficultyID: 3
		[6] = { color = COLORS.H, name = "25H" }, --25 Player (Heroic)	raid	isHeroic, toggleDifficultyID: 4
		[7] = { color = COLORS.LFR, name = "LFR" }, --Looking For Raid	raid	Legacy LFRs prior to SoO
		[8] = { color = COLORS.MP, name = "M+" }, --Mythic Keystone	party	isHeroic, isChallengeMode
		[9] = { color = COLORS.N, name = "40N" }, --40 Player	raid
		[11] = { color = COLORS.H, name = "SCH" }, --Heroic Scenario	scenario	isHeroic
		[12] = { color = COLORS.N, name = "SC" }, --Normal Scenario	scenario
		[14] = { color = COLORS.N, name = "N" }, --Normal	raid
		[15] = { color = COLORS.H, name = "H" }, --Heroic	raid	displayHeroic
		[16] = { color = COLORS.M, name = "M" }, --Mythic	raid	isHeroic, displayMythic
		[17] = { color = COLORS.LFR, name = "LFR" }, --Looking For Raid	raid
		[18] = { color = COLORS.N, name = "E" }, --Event	raid
		[19] = { color = COLORS.N, name = "E" }, --Event	party
		[20] = { color = COLORS.SC, name = "E" }, --Event Scenario	scenario
		[23] = { color = COLORS.M, name = "M" }, --Mythic	party	isHeroic, displayMythic
		[24] = { color = COLORS.TW, name = "TW" }, --Timewalking	party
		[25] = { color = COLORS.PVP, name = "SC-PVP" }, --World PvP Scenario	scenario
		[29] = { color = COLORS.PVP, name = "SC-PVP" }, --PvEvP Scenario	pvp
		[30] = { color = COLORS.SC, name = "E" }, --Event	scenario
		[32] = { color = COLORS.PVP, name = "SC-PVP" }, --World PvP Scenario	scenario
		[33] = { color = COLORS.TW, name = "TW" }, --Timewalking	raid
		[34] = { color = COLORS.PVP, name = "PVP" }, --PvP	pvp
		[38] = { color = COLORS.N, name = "SC" }, --Normal	scenario
		[39] = { color = COLORS.H, name = "SCH" }, --Heroic	scenario	displayHeroic
		[40] = { color = COLORS.M, name = "SCM" }, --Mythic	scenario	displayMythic
		[45] = { color = COLORS.PVP, name = "SC-PVP" }, --PvP	scenario	displayHeroic
		[147] = { color = COLORS.N, name = "WF" }, --Normal	scenario	Warfronts
		[149] = { color = COLORS.H, name = "WFH" }, --Heroic	scenario	displayHeroic Warfronts
		[150] = { color = COLORS.N, name = "N" }, --Normal	party
		[151] = { color = COLORS.TW, name = "TW" }, --Looking For Raid	raid	Timewalking
		[152] = { color = COLORS.SC, name = "SC" }, --Visions of N'Zoth	scenario
		[153] = { color = COLORS.SC, name = "SC" }, --Teeming Island	scenario	displayHeroic
		[167] = { color = COLORS.OTHER, name = "TG" }, --Torghast	scenario
		[168] = { color = COLORS.SC, name = "SC" }, --Path of Ascension: Courage	scenario
		[169] = { color = COLORS.SC, name = "SC" }, --Path of Ascension: Loyalty	scenario
		[170] = { color = COLORS.SC, name = "SC" }, --Path of Ascension: Wisdom	scenario
		[171] = { color = COLORS.SC, name = "SC" }, --Path of Ascension: Humility	scenario
		[172] = { color = COLORS.N, name = "WB" }, --World Boss	none
		[192] = { color = COLORS.MP, name = "CM" }, --Challenge Level 1	none
		[205] = { color = COLORS.FOLLOWER, name = "FD" },
		[208] = { color = COLORS.DELVE, name = "D" },
		[216] = { color = COLORS.QUEST, name = "Q" },
		[220] = { color = COLORS.STORY, name = "S" },
	}
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

function mMT:GetPlayerDifficulty()
	local info = {}
	local DungeonDifficultyID, RaidDifficultyID = GetDungeonDifficultyID(), GetRaidDifficultyID()

	info.dungeon = shortDifficulty[DungeonDifficultyID]
	info.raid = shortDifficulty[RaidDifficultyID]
	if E.Retail then
		local LegacyRaidDifficultyID = GetLegacyRaidDifficultyID()
		info.legacy = E.Retail and shortDifficulty[LegacyRaidDifficultyID]
	end

	return info
end

function mMT:GetDungeonInfo()
	if not shortDifficulty.OTHER then UpdateColors() end

	local isInInstance, instanceType = IsInInstance()
	if not isInInstance then return end

	local info = {}

	local name, _, difficultyID, _, _, _, _, instanceID, instanceGroupSize = GetInstanceInfo()
	local difficultyName, _, _, _, _, _, toggleDifficultyID = GetDifficultyInfo(difficultyID)
	local difficultyInfo = shortDifficulty[difficultyID]

	info.name = name
	info.shortName = shortNames[instanceID] or E:ShortenString(name, 6)
	info.difficultyName = difficultyName
	info.difficultyShort = difficultyInfo and difficultyInfo.name
	info.difficultyColor = difficultyInfo and difficultyInfo.color or COLORS.OTHER
	info.toggleDifficultyID = toggleDifficultyID
	info.isGuildParty = InGuildParty()
	info.instanceType = instanceType
	info.instanceID = instanceID
	info.instanceGroupSize = instanceGroupSize

	if difficultyID == 8 then
		local keystoneLevel = GetActiveKeystoneInfo()
		local keystoneColor = GetKeystoneLevelRarityColor(keystoneLevel)
		info.isChallengeMode = true
		info.level = keystoneColor:WrapTextInColorCode(keystoneLevel)
	end

	if difficultyID == 208 then
		info.isDelve = true
		info.level = mMT:GetCurrentDelveTier()
	end


	return info
end
