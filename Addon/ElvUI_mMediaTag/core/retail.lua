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
local GetDungeonDifficultyID = GetDungeonDifficultyID
local GetRaidDifficultyID = GetRaidDifficultyID
local GetLegacyRaidDifficultyID = GetLegacyRaidDifficultyID
local GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
local GetScenarioHeaderDelvesWidgetVisualizationInfo = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo

local shortNames = {
	-- Midnight Dungeons
	[2805] = "WS", --Windrunner Spire
	[2811] = "MT", --Magisters' Terrace
	[2813] = "MR", --Murder Row
	[2825] = "DON", --Den of Nalorakk
	[2859] = "BV", --The Blinding Vale
	[2874] = "MC", --Maisara Caverns
	[2915] = "NPX", --Nexus-Point Xenas
	[2923] = "VA", --Voidscar Arena
	[2993] = "AOF", --Altar of Fangs (12.1)

	-- Midnight Raids
	[1592] = "SF", --Sporefall
	[2912] = "VS", --The Voidspire
	[2913] = "MQD", --March on Quel'Danas
	[2939] = "DR", --The Dreamrift
	[3004] = "TVA", --The Venomous Abyss (12.1)

	-- Midnight Delves
	[2933] = "CC", --Collegiate Calamity
	[2952] = "SE", --The Shadow Enclave
	[2953] = "PP", --Parhelion Plaza
	[2961] = "CRYPTS", --Twilight Crypts
	[2962] = "ATAL", --Atal'Aman
	[2963] = "GP", --The Grudge Pit
	[2964] = "TGM", --The Gulf of Memory
	[2965] = "SS", --Sunkiller Sanctum
	[2966] = "TR", --Torment's Rise
	[2979] = "SP", --Shadowguard Point
	[3003] = "TDW", --The Darkway
	[3038] = "GI", --Gnarldor Isle (12.1)
	[3077] = "ROG", --The Ring of Glory (12.1)
	[3079] = "VD", --Venomfall Deeps (12.1)
	[2735] = "FP", --Gruenderspitze (TODO: verify ID/english name)

	-- The War Within Dungeons
	[2648] = "ROOK", --The Rookery
	[2649] = "PSF", --Priory of the Sacred Flame
	[2651] = "DFC", --Darkflame Cleft
	[2652] = "SV", --The Stonevault
	[2660] = "ARAK", --Ara-Kara, City of Echoes
	[2661] = "BREW", --Cinderbrew Meadery
	[2662] = "DAWN", --The Dawnbreaker
	[2669] = "COT", --City of Threads
	[2710] = "ATM", --Awakening the Machine
	[2773] = "FLOOD", --Operation: Floodgate
	[2830] = "EDA", --Eco-Dome Al'dani

	-- The War Within Raids
	[2657] = "NP", --Nerub-ar Palace
	[2769] = "LOU", --Liberation of Undermine
	[2810] = "MFO", --Manaforge Omega

	-- The War Within Delves
	[2664] = "FF", --Fungal Folly
	[2679] = "MYCO", --Mycomancer Cavern
	[2680] = "EM", --Earthcrawl Mines
	[2681] = "KVR", --Kriegval's Rest
	[2682] = "ZL", --Zekvir's Lair
	[2683] = "WW", --The Waterworks
	[2684] = "DP", --The Dread Pit
	[2685] = "SB", --Skittering Breach
	[2686] = "NS", --Nightfall Sanctum
	[2687] = "SINK", --The Sinkhole
	[2688] = "SW", --The Spiral Weave
	[2689] = "TRA", --Tak-Rethan Abyss
	[2690] = "UNDK", --The Underkeep
	[2803] = "ARCH", --Archival Assault
	[2815] = "ES9", --Excavation Site 9
	[2826] = "SLUICE", --Sidestreet Sluice
	[2831] = "DD", --Demolition Dome
	[2951] = "VRS", --Voidrazor Sanctuary

	-- Dragonflight Dungeons
	[2451] = "ULD", --Uldaman: Legacy of Tyr
	[2515] = "AV", --The Azure Vault
	[2516] = "NO", --The Nokhud Offensive
	[2519] = "NELTH", --Neltharus
	[2520] = "BH", --Brackenhide Hollow
	[2521] = "RLP", --Ruby Life Pools
	[2526] = "AA", --Algeth'ar Academy
	[2527] = "HOI", --Halls of Infusion
	[2579] = "DOTI", --Dawn of the Infinite

	-- Dragonflight Raids
	[2522] = "VOTI", --Vault of the Incarnates
	[2549] = "AMIR", --Amirdrassil, the Dream's Hope
	[2569] = "ABER", --Aberrus, the Shadowed Crucible

	-- Shadowlands Dungeons
	[2284] = "SD", --Sanguine Depths
	[2285] = "SOA", --Spires of Ascension
	[2286] = "NW", --The Necrotic Wake
	[2287] = "HOA", --Halls of Atonement
	[2289] = "PF", --Plaguefall
	[2290] = "MISTS", --Mists of Tirna Scithe
	[2291] = "DOS", --De Other Side
	[2293] = "TOP", --Theater of Pain
	[2441] = "TAZ", --Tazavesh, the Veiled Market

	-- Shadowlands Raids
	[2296] = "CN", --Castle Nathria
	[2450] = "SOD", --Sanctum of Domination
	[2481] = "SFO", --Sepulcher of the First Ones

	-- Battle for Azeroth Dungeons
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
	[2212] = "HVO", --Horrific Vision of Orgrimmar
	[2213] = "HVS", --Horrific Vision of Stormwind
	[2827] = "HVS", --Horrific Vision of Stormwind (Revisited)
	[2828] = "HVO", --Horrific Vision of Orgrimmar (Revisited)

	-- Battle for Azeroth Raids
	[1861] = "ULDIR", --Uldir
	[2070] = "BOD", --Battle of Dazar'alor
	[2096] = "COS", --Crucible of Storms
	[2164] = "TEP", --The Eternal Palace
	[2217] = "NYA", --Ny'alotha, the Waking City

	-- Legion Dungeons
	[1456] = "EOA", --Eye of Azshara
	[1458] = "NL", --Neltharion's Lair
	[1466] = "DT", --Darkheart Thicket
	[1477] = "HOV", --Halls of Valor
	[1492] = "MOS", --Maw of Souls
	[1493] = "VOTW", --Vault of the Wardens
	[1501] = "BRH", --Black Rook Hold
	[1516] = "ARC", --The Arcway
	[1544] = "VH", --Assault on Violet Hold
	[1571] = "COS", --Court of Stars
	[1651] = "KARA", --Return to Karazhan
	[1677] = "COEN", --Cathedral of Eternal Night
	[1753] = "SEAT", --Seat of the Triumvirate

	-- Legion Raids
	[1520] = "EN", --The Emerald Nightmare
	[1530] = "NH", --The Nighthold
	[1648] = "TOV", --Trial of Valor
	[1676] = "TOS", --Tomb of Sargeras
	[1712] = "ABT", --Antorus, the Burning Throne

	-- Warlords of Draenor Dungeons
	[1175] = "BSM", --Bloodmaul Slag Mines
	[1176] = "SBG", --Shadowmoon Burial Grounds
	[1182] = "AUCH", --Auchindoun
	[1195] = "ID", --Iron Docks
	[1208] = "GD", --Grimrail Depot
	[1209] = "SR", --Skyreach
	[1279] = "EB", --The Everbloom
	[1358] = "UBRS", --Upper Blackrock Spire

	-- Warlords of Draenor Raids
	[1205] = "BRF", --Blackrock Foundry
	[1228] = "HM", --Highmaul
	[1448] = "HFC", --Hellfire Citadel

	-- Mists of Pandaria Dungeons
	[959] = "SM", --Shado-Pan Monastery
	[960] = "TJS", --Temple of the Jade Serpent
	[961] = "SSB", --Stormstout Brewery
	[962] = "GOTSS", --Gate of the Setting Sun
	[994] = "MSP", --Mogu'shan Palace
	[1001] = "SH", --Scarlet Halls
	[1004] = "SCM", --Scarlet Monastery
	[1007] = "SCHOLO", --Scholomance
	[1011] = "SNT", --Siege of Niuzao Temple
	[1112] = "PBH", --Pursuing the Black Harvest

	-- Mists of Pandaria Raids
	[996] = "TOES", --Terrace of Endless Spring
	[1008] = "MSV", --Mogu'shan Vaults
	[1009] = "HOF", --Heart of Fear
	[1098] = "TOT", --Throne of Thunder
	[1136] = "SOO", --Siege of Orgrimmar

	-- Cataclysm Dungeons
	[33] = "SFK", --Shadowfang Keep
	[36] = "DM", --The Deadmines
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

	-- Cataclysm Raids
	[669] = "BWD", --Blackwing Descent
	[671] = "BOT", --The Bastion of Twilight
	[720] = "FL", --Firelands
	[754] = "TFW", --Throne of the Four Winds
	[757] = "BARA", --Baradin Hold
	[967] = "DS", --Dragon Soul

	-- Wrath of the Lich King Dungeons
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

	-- Wrath of the Lich King Raids
	[533] = "NAXX", --Naxxramas
	[603] = "ULDUAR", --Ulduar
	[615] = "OS", --The Obsidian Sanctum
	[616] = "EOE", --The Eye of Eternity
	[624] = "VOA", --Vault of Archavon
	[631] = "ICC", --Icecrown Citadel
	[649] = "TOTC", --Trial of the Crusader
	[724] = "RS", --The Ruby Sanctum

	-- The Burning Crusade Dungeons
	[269] = "BM", --The Black Morass
	[540] = "SHH", --The Shattered Halls
	[542] = "BF", --The Blood Furnace
	[543] = "RAMP", --Hellfire Ramparts
	[545] = "STV", --The Steamvault
	[546] = "UB", --The Underbog
	[547] = "SLP", --The Slave Pens
	[552] = "ARCA", --The Arcatraz
	[553] = "BOTA", --The Botanica
	[554] = "MECH", --The Mechanar
	[555] = "SLAB", --Shadow Labyrinth
	[556] = "SETH", --Sethekk Halls
	[557] = "MAT", --Mana-Tombs
	[558] = "AC", --Auchenai Crypts
	[560] = "OHB", --Old Hillsbrad Foothills
	[585] = "MGT", --Magisters' Terrace

	-- The Burning Crusade Raids
	[532] = "KARA", --Karazhan
	[534] = "HYJAL", --The Battle for Mount Hyjal
	[544] = "MAG", --Magtheridon's Lair
	[548] = "SSC", --Serpentshrine Cavern
	[550] = "TK", --Tempest Keep
	[564] = "BT", --Black Temple
	[565] = "GRUUL", --Gruul's Lair
	[580] = "SWP", --Sunwell Plateau

	-- Classic Dungeons
	[209] = "ZF", --Zul'Farrak
	[229] = "BRS", --Blackrock Spire
	[329] = "STRAT", --Stratholme
	[429] = "DIRE", --Dire Maul

	-- Classic Raids
	[249] = "ONY", --Onyxia's Lair
	[409] = "MOLTEN", --Molten Core
	[469] = "BWL", --Blackwing Lair
	[509] = "AQ20", --Ruins of Ahn'Qiraj
	[531] = "AQ40", --Temple of Ahn'Qiraj

	-- Misc
	[369] = "TRAM", --Deeprun Tram
	[1043] = "BGA", --Brawl'gar Arena

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
		[1] = { color = MEDIA.color.N, name = "N" }, --Normal	party
		[2] = { color = MEDIA.color.H, name = "H" }, --Heroic	party	isHeroic
		[3] = { color = MEDIA.color.N, name = "10N" }, --10 Player	raid	toggleDifficultyID: 5
		[4] = { color = MEDIA.color.N, name = "25N" }, --25 Player	raid	toggleDifficultyID: 6
		[5] = { color = MEDIA.color.H, name = "10H" }, --10 Player (Heroic)	raid	isHeroic, toggleDifficultyID: 3
		[6] = { color = MEDIA.color.H, name = "25H" }, --25 Player (Heroic)	raid	isHeroic, toggleDifficultyID: 4
		[7] = { color = MEDIA.color.LFR, name = "LFR" }, --Looking For Raid	raid	Legacy LFRs prior to SoO
		[8] = { color = MEDIA.color.MP, name = "M+" }, --Mythic Keystone	party	isHeroic, isChallengeMode
		[9] = { color = MEDIA.color.N, name = "40N" }, --40 Player	raid
		[11] = { color = MEDIA.color.H, name = "SCH" }, --Heroic Scenario	scenario	isHeroic
		[12] = { color = MEDIA.color.N, name = "SC" }, --Normal Scenario	scenario
		[14] = { color = MEDIA.color.N, name = "N" }, --Normal	raid
		[15] = { color = MEDIA.color.H, name = "H" }, --Heroic	raid	displayHeroic
		[16] = { color = MEDIA.color.M, name = "M" }, --Mythic	raid	isHeroic, displayMythic
		[17] = { color = MEDIA.color.LFR, name = "LFR" }, --Looking For Raid	raid
		[18] = { color = MEDIA.color.N, name = "E" }, --Event	raid
		[19] = { color = MEDIA.color.N, name = "E" }, --Event	party
		[20] = { color = MEDIA.color.SC, name = "E" }, --Event Scenario	scenario
		[23] = { color = MEDIA.color.M, name = "M" }, --Mythic	party	isHeroic, displayMythic
		[24] = { color = MEDIA.color.TW, name = "TW" }, --Timewalking	party
		[25] = { color = MEDIA.color.PVP, name = "SC-PVP" }, --World PvP Scenario	scenario
		[29] = { color = MEDIA.color.PVP, name = "SC-PVP" }, --PvEvP Scenario	pvp
		[30] = { color = MEDIA.color.SC, name = "E" }, --Event	scenario
		[32] = { color = MEDIA.color.PVP, name = "SC-PVP" }, --World PvP Scenario	scenario
		[33] = { color = MEDIA.color.TW, name = "TW" }, --Timewalking	raid
		[34] = { color = MEDIA.color.PVP, name = "PVP" }, --PvP	pvp
		[38] = { color = MEDIA.color.N, name = "SC" }, --Normal	scenario
		[39] = { color = MEDIA.color.H, name = "SCH" }, --Heroic	scenario	displayHeroic
		[40] = { color = MEDIA.color.M, name = "SCM" }, --Mythic	scenario	displayMythic
		[45] = { color = MEDIA.color.PVP, name = "SC-PVP" }, --PvP	scenario	displayHeroic
		[147] = { color = MEDIA.color.N, name = "WF" }, --Normal	scenario	Warfronts
		[149] = { color = MEDIA.color.H, name = "WFH" }, --Heroic	scenario	displayHeroic Warfronts
		[150] = { color = MEDIA.color.N, name = "N" }, --Normal	party
		[151] = { color = MEDIA.color.TW, name = "TW" }, --Looking For Raid	raid	Timewalking
		[152] = { color = MEDIA.color.SC, name = "SC" }, --Visions of N'Zoth	scenario
		[153] = { color = MEDIA.color.SC, name = "SC" }, --Teeming Island	scenario	displayHeroic
		[167] = { color = MEDIA.color.OTHER, name = "TG" }, --Torghast	scenario
		[168] = { color = MEDIA.color.SC, name = "SC" }, --Path of Ascension: Courage	scenario
		[169] = { color = MEDIA.color.SC, name = "SC" }, --Path of Ascension: Loyalty	scenario
		[170] = { color = MEDIA.color.SC, name = "SC" }, --Path of Ascension: Wisdom	scenario
		[171] = { color = MEDIA.color.SC, name = "SC" }, --Path of Ascension: Humility	scenario
		[172] = { color = MEDIA.color.N, name = "WB" }, --World Boss	none
		[192] = { color = MEDIA.color.MP, name = "CM" }, --Challenge Level 1	none
		[205] = { color = MEDIA.color.FOLLOWER, name = "FD" },
		[208] = { color = MEDIA.color.DELVE, name = "D" },
		[216] = { color = MEDIA.color.QUEST, name = "Q" },
		[220] = { color = MEDIA.color.STORY, name = "S" },
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

	if DB.DEV and not shortNames[instanceID] then DB.unknownIDS[instanceID] = { id = instanceID, name = name } end

	info.name = name
	info.shortName = shortNames[instanceID] or E:ShortenString(name, 6)
	info.difficultyName = difficultyName
	info.difficultyShort = difficultyInfo and difficultyInfo.name
	info.difficultyColor = difficultyInfo and difficultyInfo.color or MEDIA.color.OTHER
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
