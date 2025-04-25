local E, _, _, P, _ = unpack(ElvUI)
local LSM = E.Libs.LSM
local M = E:GetModule("Minimap")

--Lua functions
local format = format

--WoW API / Variables
local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance
local MinimapCluster = _G.MinimapCluster
local Minimap = _G.Minimap

--Variables
local mIDF = nil

local percentValue = {
	[2] = 0,
	[3] = 0.14,
	[4] = 0.28,
	[5] = 0.42,
	[6] = 0.56,
	[7] = 0.71,
	[8] = 0.85,
	[9] = 1,
	[10] = 0.2,
	[11] = 0.4,
	[12] = 0.6,
	[13] = 0.8,
	[14] = 1,
	[15] = 0.2,
	[16] = 0.4,
	[17] = 0.6,
	[18] = 0.8,
	[19] = 1,
	[20] = 0.2,
	[21] = 0.4,
	[22] = 0.6,
	[23] = 0.8,
	[24] = 1,
	[25] = 0.2,
	[26] = 0.4,
	[27] = 0.6,
	[28] = 0.8,
	[29] = 1,
}
local instanceDifficulty = {
	[1] = { c = "|CFF00FC00", d = "N" },
	[2] = { c = "|CFF005AFC", d = "H" },
	[3] = { c = "|CFF00FC00", d = "N" },
	[4] = { c = "|CFF00FC00", d = "N" },
	[5] = { c = "|CFF005AFC", d = "H" },
	[6] = { c = "|CFF005AFC", d = "H" },
	[8] = { c = "|CFFFC9100", d = "M+" },
	[14] = { c = "|CFF00FC00", d = "N" },
	[15] = { c = "|CFF005AFC", d = "H" },
	[16] = { c = "|CFF7E00FC", d = "M" },
	[17] = { c = "|CFFFCDE00", d = "LFR" },
	[23] = { c = "|CFF7E00FC", d = "M" },
	[24] = { c = "|CFF85C1E9", d = "TW" },
	[25] = { c = "|CFFFF0074", d = "PVP" },
	[29] = { c = "|CFFFF0074", d = "PVP" },
	[33] = { c = "|CFF85C1E9", d = "TW" },
	[34] = { c = "|CFFFF0074", d = "PVP" },
	[39] = { c = "|CFF005AFC", d = "H" },
	[40] = { c = "|CFF7E00FC", d = "M" },
	[149] = { c = "|CFF005AFC", d = "H" },
	[151] = { c = "|CFFFCDE00", d = "LFR" },
	[167] = { c = "|CFF00C9FF", d = "TG" },
	[205] = { c = "|CFF00FCD2", d = "AI" },
	[208] = { c = "|CFFAB5C07", d = "DELVE" },
	[216] = { c = "|CFFFCA400", d = "QUEST" },
	[220] = { c = "|CFF9700FC", d = "STORY" },
}

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
	[2451]	= "ULD", --Uldaman: Legacy of Tyr
	[2515]	= "AV", --The Azure Vault
	[2516]	= "NO", --The Nokhud Offensive
	[2519]	= "NELTH", --Neltharus
	[2520]	= "BH", --Brackenhide Hollow
	[2521]	= "RLP", --Ruby Life Pools
	[2526]	= "AA", --Algeth'ar Academy
	[2527]	= "HOI", --Halls of Infusion
	[2579]	= "DOTI", --Dawn of the Infinite

	-- sl
	[2284]	= "SD", --Sanguine Depths
	[2285]	= "SOA", --Spires of Ascension
	[2286]	= "NW", --The Necrotic Wake
	[2287]	= "HOA", --Halls of Atonement
	[2289]	= "PF", --Plaguefall
	[2290]	= "MISTS", --Mists of Tirna Scithe
	[2291]	= "DOS", --De Other Side
	[2293]	= "TOP", --Theater of Pain
	[2441]	= "TAZ", --Tazavesh, the Veiled Market

	-- bfa
	[1594]	= "ML", --The MOTHERLODE!!
	[1754]	= "FH", --Freehold
	[1762]	= "KR", --Kings' Rest
	[1763]	= "AD", --Atal'Dazar
	[1771]	= "DAGOR", --Tol Dagor
	[1822]	= "SIEGE", --Siege of Boralus
	[1841]	= "UNDR", --The Underrot
	[1862]	= "WM", --Waycrest Manor
	[1864]	= "SOS", --Shrine of the Storm
	[1877]	= "TOS", --Temple of Sethraliss
	[2097]	= "MECHA", --Operation: Mechagon

	-- legion
	[1456]	= "EOA", --Eye of Azshara
	[1458]	= "NL", --Neltharion's Lair
	[1466]	= "DT", --Darkheart Thicket
	[1477]	= "HOV", --Halls of Valor
	[1492]	= "MOS", --Maw of Souls
	[1493]	= "VOTW", --Vault of the Wardens
	[1501]	= "BRH", --Black Rook Hold
	[1516]	= "ARC", --The Arcway
	[1544]	= "VH", --Violet Hold
	[1571]	= "COS", --Court of Stars
	[1651]	= "KARA", --Return to Karazhan
	[1677]	= "COEN", --Cathedral of Eternal Night
	[1753]	= "SOT", --Seat of the Triumvirate

	-- wod
	[1182]	= "AUCH", --Auchindoun
	[1175]	= "BSM", --Bloodmaul Slag Mines
	[1176]	= "SBG", --Shadowmoon Burial Grounds
	[1195]	= "ID", --Iron Docks
	[1208]	= "GD", --Grimrail Depot
	[1209]	= "SR", --Skyreach
	[1279]	= "EB", --The Everbloom
	[1358]	= "UBRS", --Upper Blackrock Spire

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
	[574]	= "UK", --Utgarde Keep
	[575]	= "UP", --Utgarde Pinnacle
	[576]	= "NEXUS", --The Nexus
	[578]	= "OCULUS", --The Oculus
	[595]	= "TCOS", --The Culling of Stratholme
	[599]	= "HS", --Halls of Stone
	[600]	= "DRAK", --Drak'Tharon Keep
	[601]	= "NERUB", --Azjol-Nerub
	[602]	= "HOL", --Halls of Lightning
	[604]	= "GD", --Gundrak
	[608]	= "VH", --The Violet Hold
	[619]	= "AHN", --Ahn'kahet: The Old Kingdom
	[632]	= "FOS", --The Forge of Souls
	[650]	= "TOC", --Trial of the Champion
	[658]	= "POS", --Pit of Saron
	[668]	= "HOR", --Halls of Reflection

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

local colors = {
	mpe = { color = "|cffff003e", r = 1, g = 0, b = 0.24 },
	mpf = { color = "|cffff003e", r = 1, g = 0, b = 0.24 },
	hc = { color = "|cff004dff", b = 1, g = 0.30, r = 0 },
	guild = { color = "|cff94ff00", r = 0.58, g = 1, b = 0 },
	tw = { color = "|cff00c0ff", r = 0, g = 0.75, b = 1 },
	mpc = { color = "|cfffff819", r = 1, g = 0.97, b = 0.098 },
	nhc = { color = "|cff52ff76", b = 0.46, g = 1, r = 0.32 },
	mpa = { color = "|cff97ffbd", r = 0.59, g = 1, b = 0.74 },
	mpd = { color = "|cffff8b00", r = 1, g = 0.54, b = 0 },
	m = { color = "|cffaf00ff", g = 0, r = 0.68, b = 1.00 },
	name = { color = "|cffffffff", r = 1, g = 1, b = 1 },
	mp = { color = "|cffff8f00", b = 0, g = 0.56, r = 1 },
	mpb = { color = "|cff27ff59", r = 0.15, g = 1, b = 0.34 },
	lfr = { color = "|cff00ffef", b = 0.93, g = 1, r = 0 },
	tg = { color = "|cff5dffb8", r = 0.36, g = 1, b = 0.72 },
	pvp = { color = "|cffeb0056", r = 0.92, g = 0, b = 0.33 },
	quest = { color = "|cfffca400", r = 0.98, g = 0.64, b = 0 },
	delve = { color = "|cffab5c07", r = 0.67, g = 0.36, b = 0.02 },
	ai = { color = "|cff00fcd2", r = 0, g = 0.98, b = 0.82 },
	story = { color = "|cff00fcd2", r = 0.59, g = 0, b = 0.98 },
}

function mMT:UpdateColors()
	local db = E.db.mMT.instancedifficulty
	instanceDifficulty[1].c = db.nhc.color
	instanceDifficulty[2].c = db.hc.color
	instanceDifficulty[3].c = db.nhc.color
	instanceDifficulty[4].c = db.nhc.color
	instanceDifficulty[5].c = db.hc.color
	instanceDifficulty[6].c = db.hc.color
	instanceDifficulty[8].c = db.mp.color
	instanceDifficulty[14].c = db.nhc.color
	instanceDifficulty[15].c = db.hc.color
	instanceDifficulty[16].c = db.m.color
	instanceDifficulty[17].c = db.lfr.color
	instanceDifficulty[23].c = db.m.color
	instanceDifficulty[24].c = db.tw.color
	instanceDifficulty[25].c = db.pvp.color
	instanceDifficulty[29].c = db.pvp.color
	instanceDifficulty[33].c = db.tw.color
	instanceDifficulty[34].c = db.pvp.color
	instanceDifficulty[39].c = db.hc.color
	instanceDifficulty[40].c = db.m.color
	instanceDifficulty[149].c = db.hc.color
	instanceDifficulty[151].c = db.lfr.color
	instanceDifficulty[167].c = db.tg.color
	instanceDifficulty[205].c = db.ai.color
	instanceDifficulty[208].c = db.delve.color
	instanceDifficulty[216].c = db.quest.color
	instanceDifficulty[220].c = db.story.color

	colors.nhc = db.nhc
	colors.hc = db.hc
	colors.m = db.m
	colors.mp = db.mp
	colors.pvp = db.pvp
	colors.lfr = db.lfr
	colors.tw = db.tw
	colors.tg = db.tg
	colors.name = db.name
	colors.guild = db.guild
	colors.mpa = db.mpa
	colors.mpb = db.mpb
	colors.mpc = db.mpc
	colors.mpd = db.mpd
	colors.mpe = db.mpe
	colors.mpf = db.mpf
	colors.ai = db.ai
	colors.delve = db.delve
	colors.quest = db.quest
	colors.story = db.story
end

local function GetIconSettings(button)
	local defaults = P.general.minimap.icons[button]
	local profile = E.db.general.minimap.icons[button]

	return profile.position or defaults.position, profile.xOffset or defaults.xOffset, profile.yOffset or defaults.yOffset
end

local function GetKeystoneLevelandColor()
	local color = {}
	local keyStoneLevel, _ = C_ChallengeMode.GetActiveKeystoneInfo()
	if keyStoneLevel == 2 then
		return format("%s%s|r", colors.mpa.color, keyStoneLevel)
	elseif keyStoneLevel <= 9 then
		color = mMT:ColorFade(E.db.mMT.instancedifficulty.mpa, E.db.mMT.instancedifficulty.mpb, percentValue[keyStoneLevel])
		if color then return format("%s%s|r", color.color, keyStoneLevel) end
	elseif keyStoneLevel <= 14 then
		color = mMT:ColorFade(E.db.mMT.instancedifficulty.mpb, E.db.mMT.instancedifficulty.mpc, percentValue[keyStoneLevel])
		if color then return format("%s%s|r", color.color, keyStoneLevel) end
	elseif keyStoneLevel <= 19 then
		color = mMT:ColorFade(E.db.mMT.instancedifficulty.mpc, E.db.mMT.instancedifficulty.mpd, percentValue[keyStoneLevel])
		if color then return format("%s%s|r", color.color, keyStoneLevel) end
	elseif keyStoneLevel >= 24 then
		color = mMT:ColorFade(E.db.mMT.instancedifficulty.mpd, E.db.mMT.instancedifficulty.mpe, percentValue[keyStoneLevel])
		if color then return format("%s%s|r", color.color, keyStoneLevel) end
	elseif keyStoneLevel >= 29 then
		color = mMT:ColorFade(E.db.mMT.instancedifficulty.mpe, E.db.mMT.instancedifficulty.mpf, percentValue[keyStoneLevel])
		if color then return format("%s%s|r", color.color, keyStoneLevel) end
	else
		return format("%s%s|r", colors.mpf.color, keyStoneLevel)
	end
end

function mMT:GetCurrentDelveTier()
	local widgetIDs = {
		{ id = 6183, tierType = "numbered" },
		{ id = 6184, tierType = "?" },
		{ id = 6185, tierType = "??" },
	}

	for _, widget in ipairs(widgetIDs) do
		local delveInfo = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(widget.id)
		if delveInfo and delveInfo.shownState == Enum.WidgetShownState.Shown then
			if widget.tierType ~= "numbered" then return widget.tierType end

			local tierText = delveInfo.tierText or ""
			return tonumber(tierText:match("%d+")) or 1
		end
	end

	return 1
end

local function FormatText(name, difficultyColor, difficultyShort, extraText, isGuildParty)
    local colorPrefix = isGuildParty and colors.guild.color or colors.name.color or "|CFFFFFFFF"
    return format("%s%s|r %s%s|r %s", colorPrefix, name, difficultyColor, difficultyShort, extraText or "")
end

local function GetDifficultyInfo(difficultyID)
    local difficulty = instanceDifficulty[difficultyID] or {}
    return difficulty.c or "|CFFFFFFFF", difficulty.d or ""
end

function mMT:GetDungeonInfo(datatext, short, stageBlock, hideDelve)
    local name, _, difficultyID, _, _, _, _, instanceID, instanceGroupSize = GetInstanceInfo()
    local _, instanceType = IsInInstance()
    name = shortNames[instanceID] or E:ShortenString(name, 5)

    if not name or (hideDelve and difficultyID == 208) then return end

    local difficultyColor, difficultyShort = GetDifficultyInfo(difficultyID)
    local isGuildParty = InGuildParty()
    local text = ""

    if E.Retail and difficultyID == 8 and C_MythicPlus.IsMythicPlusActive() and C_ChallengeMode.GetActiveChallengeMapID() then
        local keystoneText = GetKeystoneLevelandColor()
        text = short and format("%s%s|r %s", difficultyColor, difficultyShort, keystoneText)
            or FormatText(name, difficultyColor, difficultyShort, keystoneText, isGuildParty)
    elseif difficultyID == 208 then
        local delveTier = mMT:GetCurrentDelveTier()
        text = format("%s%s|r\n%s%s|r |CFFF7DC6F%s|r", (isGuildParty and colors.guild.color or colors.name.color), name, difficultyColor, difficultyShort, delveTier)
    elseif instanceType == "pvp" or instanceType == "arena" then
        difficultyColor, difficultyShort = GetDifficultyInfo(34)
        text = short and format("%s%s|r", difficultyColor, difficultyShort)
            or FormatText(name, difficultyColor, difficultyShort, nil, isGuildParty)
    else
        local extraText = stageBlock and "" or format("|CFFF7DC6F%s|r", instanceGroupSize)
        text = short and format("%s%s|r %s%s|r", (isGuildParty and colors.guild.color or colors.name.color), name, difficultyColor, difficultyShort)
            or FormatText(name, difficultyColor, difficultyShort, extraText, isGuildParty)
    end

    return text
end

function UpdateDifficulty()
	local difficulty = MinimapCluster.InstanceDifficulty or _G.MiniMapInstanceDifficulty
	local difficultyGuild = _G.GuildInstanceDifficulty
	local battlefieldFrame = _G.MiniMapBattlefieldFrame

	if difficulty then difficulty:Hide() end
	if difficultyGuild then difficultyGuild:Hide() end
	if battlefieldFrame then battlefieldFrame:Hide() end

	local name, _, diffID, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
	local inInstance, _ = IsInInstance()

	if mIDF then
		if inInstance or (diffID == 208 and C_DelvesUI.HasActiveDelve(instanceID)) and name then
			mIDF.Text:SetText(mMT:GetDungeonInfo())
			mIDF:Show()
		else
			mIDF:Hide()
		end
	end
end

function mMT:UpdateText()
	UpdateDifficulty()
end

function mMT:SetupInstanceDifficulty()
	local position, xOffset, yOffset = GetIconSettings("difficulty")
	local Font = LSM:Fetch("font", E.db.general.font)

	mIDF = CreateFrame("Frame", "m_MinimapInstanceDifficulty", E.UIParent)
	mIDF:Size(32, 32)
	mIDF:SetPoint(position, Minimap, xOffset, yOffset)
	mIDF.Text = mIDF:CreateFontString("mIDF_Text", "OVERLAY", "GameTooltipText")
	mIDF.Text:SetPoint("CENTER", mIDF, "CENTER")
	mIDF.Text:SetFont(Font, E.db.general.fontSize or 12, "SHADOW")
	mIDF:Hide()

	mMT:UpdateColors()

	hooksecurefunc(M, "UpdateIcons", UpdateDifficulty)
end
