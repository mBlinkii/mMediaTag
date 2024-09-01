local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local LOR = LibStub("LibOpenRaid-1.0", true)

local _G = _G

local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo
local C_MythicPlus_GetCurrentAffixes = C_MythicPlus.GetCurrentAffixes
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_ChallengeMode_GetMapTable = C_ChallengeMode.GetMapTable
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
local C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes
local C_ChallengeMode_GetSpecificDungeonScoreRarityColor = C_ChallengeMode.GetSpecificDungeonScoreRarityColor
local C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local C_MythicPlus_GetSeasonBestAffixScoreInfoForMap = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local UIParentLoadAddOn = UIParentLoadAddOn

local tablesort = sort
local displayString = ""
local tyrannical = C_ChallengeMode_GetAffixInfo(9)
local fortified = C_ChallengeMode_GetAffixInfo(10)
local affixes = C_MythicPlus_GetCurrentAffixes()
local weeklyAffixID = affixes and affixes[1] and affixes[1].id
local weeklyAffixName = weeklyAffixID and C_ChallengeMode_GetAffixInfo(weeklyAffixID)
local map_table = C_ChallengeMode_GetMapTable()
local MPlusDataLoaded = false

local IconOverall = E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\overall.tga", ":14:14")
local IconTyrannical = E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\tyrannical.tga", ":14:14")
local IconFortified = E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\fortified.tga", ":14:14")
local LeadIcon = E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\crown1.tga", ":14:14")
local isMaxLevel = E:XPIsLevelMax()

local function GetPlayerScore()
	local ratingSummary = C_PlayerInfo_GetPlayerMythicPlusRatingSummary("PLAYER")
	return ratingSummary and ratingSummary.currentSeasonScore or 0
end

local function SortScore(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then
		tablesort(map_table, function(a, b)
			return ScoreTable[a].score > ScoreTable[b].score
		end)
	end
end
local function SortWeeklyLevel(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then
		tablesort(map_table, function(a, b)
			return ScoreTable[a][weeklyAffixName].level > ScoreTable[b][weeklyAffixName].level
		end)
	end
end

local function SortWeeklyScore(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then
		tablesort(map_table, function(a, b)
			return ScoreTable[a][weeklyAffixName].score > ScoreTable[b][weeklyAffixName].score
		end)
	end
end

local function addNotPlayed(ScoreTable, mapID, affix)
	ScoreTable[mapID][affix] = {}
	ScoreTable[mapID][affix].score = 0
	ScoreTable[mapID][affix].level = 0
	ScoreTable[mapID][affix].overTime = false
	ScoreTable[mapID][affix].color = "FFB2BABB"
end

function mMT:GetKeyColor(key)
	if key < 5 then
		return format("|CFFFFFFFF+%s|r", key)
	elseif key <= 7 then
		return format("|CFF82ffc3+%s|r", key)
	elseif key < 10 then
		return format("|CFF00C31E+%s|r", key)
	elseif key == 10 then
		return format("|CFF00F9FF+%s|r", key)
	elseif key <= 14 then
		return format("|CFF0080FF+%s|r", key)
	elseif key == 15 then
		return format("|CFF9933FF+%s|r", key)
	elseif key <= 19 then
		return format("|CFFD06000+%s|r", key)
	elseif key <= 24 then
		return format("|CFFE268A8+%s|r", key)
	elseif key > 25 then
		return format("|CFFE5CC80+%s|r", key)
	else
		return format("|CFFFFFFFF+%s|r", key)
	end
end

local function SaveMyKeystone()
	if weeklyAffixID then
		if weeklyAffixID == mMT.DB.affix then
			local name = UnitName("player")
			local realmName = GetRealmName()
			local keyStoneLevel = C_MythicPlus_GetOwnedKeystoneLevel()
			if keyStoneLevel then
				local challengeMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
				local keyname, _, _, _, _ = C_ChallengeMode_GetMapUIInfo(challengeMapID)
				mMT.DB.keys[name .. "-" .. realmName] = {
					name = format("%s%s|r", mMT.ClassColor.hex, name .. "-" .. realmName),
					key = format("%s%s|r %s", E.db.mMT.datatextcolors.colormyth.hex, keyname, mMT:GetKeyColor(keyStoneLevel)),
				}
			end
		else
			mMT.DB.keys = {}
			mMT.DB.affix = weeklyAffixID
		end
	end
end

local function GetDungeonScores()
	local ScoreTable = {}
	local KeystoneChallengeMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then
		for i = 1, #map_table do
			local mapID = map_table[i]
			local affixScores, overAllScore = C_MythicPlus_GetSeasonBestAffixScoreInfoForMap(mapID)
			local name, _, _, icon = C_ChallengeMode_GetMapUIInfo(mapID)
			local color = nil

			ScoreTable[mapID] = {}
			ScoreTable[mapID].name = name
			ScoreTable[mapID].icon = icon
			ScoreTable[mapID].OwnedKeystone = KeystoneChallengeMapID == mapID
			ScoreTable[mapID].score = overAllScore or 0

			if overAllScore then
				color = C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor(overAllScore)
				ScoreTable[mapID].color = color and color:GenerateHexColor() or "FFFFFFFF"
			else
				ScoreTable[mapID].color = "FFB2BABB"
			end

			local tmpName = nil
			for j = 1, 2 do
				if affixScores and affixScores[j] then
					tmpName = affixScores[j].name
					ScoreTable[mapID][affixScores[j].name] = {}
					ScoreTable[mapID][affixScores[j].name].score = affixScores and affixScores[j].score or 0
					ScoreTable[mapID][affixScores[j].name].level = affixScores and affixScores[j].level or 0
					ScoreTable[mapID][affixScores[j].name].overTime = affixScores and affixScores[j].overTime or false

					if affixScores[j].overTime then
						ScoreTable[mapID][affixScores[j].name].color = "FFB2BABB"
					else
						color = C_ChallengeMode_GetSpecificDungeonScoreRarityColor(affixScores[j].score)
						ScoreTable[mapID][affixScores[j].name].color = color and color:GenerateHexColor() or "FFFFFFFF"
					end
				else
					if tmpName and tmpName == tyrannical then
						tmpName = fortified
						addNotPlayed(ScoreTable, mapID, tmpName)
					elseif tmpName and tmpName == fortified then
						tmpName = tyrannical
						addNotPlayed(ScoreTable, mapID, tmpName)
					else
						tmpName = fortified
						addNotPlayed(ScoreTable, mapID, tmpName)
					end
				end
			end
		end
	end

	if ScoreTable and map_table then
		if E.db.mMT.mpscore.upgrade then
			SortWeeklyScore(ScoreTable)
			ScoreTable[map_table[#map_table]].upgrade = true
			ScoreTable[map_table[#map_table - 1]].upgrade = true
			ScoreTable[map_table[#map_table - 2]].upgrade = true
		end

		if E.db.mMT.mpscore.sort == "SCORE" and weeklyAffixName then
			SortWeeklyScore(ScoreTable)
		elseif E.db.mMT.mpscore.sort == "AFFIX" and weeklyAffixName then
			SortWeeklyLevel(ScoreTable)
		else
			SortScore(ScoreTable)
		end

		for i = 1, #map_table do
			local mapID = map_table[i]

			local nameString = L["No Dungeon"]
			local scoreString = L["No Score"]

			if ScoreTable[mapID].OwnedKeystone and E.db.mMT.mpscore.highlight then
				nameString = format("%s%s %s|r", E.db.mMT.mpscore.highlightcolor.hex, mMT:mIcon(ScoreTable[mapID].icon), ScoreTable[mapID].name)
			else
				nameString = format("%s %s", mMT:mIcon(ScoreTable[mapID].icon), ScoreTable[mapID].name)
			end

			if ScoreTable[mapID].upgrade and E.db.mMT.mpscore.upgrade then
				nameString = nameString .. "  " .. mMT:mIcon(mMT.Media.UpgradeIcons[E.db.mMT.mpscore.icon])
			end

			scoreString = format("|C%s%s|r | |C%s%s|r | |C%s%s|r", ScoreTable[mapID][tyrannical].color, ScoreTable[mapID][tyrannical].level, ScoreTable[mapID][fortified].color, ScoreTable[mapID][fortified].level, ScoreTable[mapID].color, ScoreTable[mapID].score)
			DT.tooltip:AddDoubleLine(nameString, scoreString)
		end
	end
end

local function OnClick(self, button)
	if button == "LeftButton" then
		_G.ToggleLFDParentFrame()
	elseif button == "MiddleButton" then
		_G.ToggleLFDParentFrame()
		_G.PVEFrameTab3:Click()
	else
		if not _G.WeeklyRewardsFrame then
			UIParentLoadAddOn("Blizzard_WeeklyRewards")
		end
		if _G.WeeklyRewardsFrame:IsVisible() then
			_G.WeeklyRewardsFrame:Hide()
		else
			_G.WeeklyRewardsFrame:Show()
		end
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end
local function GetGroupKeystone()
	local GroupMembers = {}
	tinsert(GroupMembers, "player")

	for i = 1, GetNumGroupMembers() - 1 do
		tinsert(GroupMembers, "party" .. i)
	end

	LOR.RequestKeystoneDataFromParty()
	LOR.GearManager.GetAllUnitsGear()

	for _, unit in ipairs(GroupMembers) do
		local info = LOR.GetKeystoneInfo(unit)
		local UnitInfo = LOR.GetUnitGear(unit)
		local name = UnitName(unit)
		local ilevel = ""
		local leader = ""
		-- mapID
		-- challengeMapID
		-- mythicPlusMapID
		-- rating
		-- classID
		-- level
		if UnitIsGroupLeader(unit) then
			leader = LeadIcon
		end

		if UnitInfo then
			ilevel = format("|CFFFFCC00i |r|CFFFFFFFF%s|r", UnitInfo.ilevel)
		end

		if info then
			local mapName, _, _, icon = C_ChallengeMode.GetMapUIInfo(info.mythicPlusMapID)
			if mapName then
				local scoreColor = C_ChallengeMode_GetDungeonScoreRarityColor(info.rating)
				scoreColor = scoreColor and scoreColor:GenerateHexColor() or "FFFFFFFF"
				icon = E:TextureString(icon, ":14:14")
				local key = format("%s %s%s|r %s", icon, E.db.mMT.datatextcolors.colormyth.hex, mapName, mMT:GetKeyColor(info.level))

				name = format("%s%s|r %s |CFFFFFFFF[|r %sM+|r |C%s%s|r |CFFFFFFFF-|r %s|CFFFFFFFF]|r ", mMT:GetClassColor(unit), UnitName(unit), leader, E.db.mMT.instancedifficulty.mp.color, scoreColor, info.rating, ilevel)

				DT.tooltip:AddDoubleLine(name, key)
			end
		elseif UnitInfo then
			name = format("%s%s|r %s |CFFFFFFFF[|r%s|CFFFFFFFF]|r ", mMT:GetClassColor(unit), UnitName(unit), leader, ilevel)
			DT.tooltip:AddDoubleLine(name, L["No Keystone"])
		end
	end
end
local function OnEnter(self)
	isMaxLevel = E:XPIsLevelMax()

	local inCombat = InCombatLockdown()
	DT.tooltip:ClearLines()

	if not inCombat then
		SaveMyKeystone()

		if isMaxLevel then
			local keyText = mMT:OwenKeystone()
			if keyText then
				DT.tooltip:AddLine(keyText[1])
				DT.tooltip:AddLine(keyText[2])
			end
		end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Keystones on your Account"])
		for k, v in pairs(mMT.DB.keys) do
			DT.tooltip:AddDoubleLine(v.name, v.key)
		end

		if E.db.mMT.mpscore.groupkeys and LOR and IsInGroup() and isMaxLevel then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(L["Keystones in your Group"])
			GetGroupKeystone()
		end
	end

	local mAffixesText = mMT:WeeklyAffixes()
	if mAffixesText then
		DT.tooltip:AddLine(" ")
		if mAffixesText[3] then
			DT.tooltip:AddLine(mAffixesText[3])
		else
			DT.tooltip:AddLine(mAffixesText[1])
			DT.tooltip:AddLine(mAffixesText[2])
		end
	end

	if isMaxLevel and MPlusDataLoaded and GetPlayerScore() > 0 then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(L["Dungeon Name"], IconTyrannical .. " | " .. IconFortified .. " | " .. IconOverall)
		GetDungeonScores()
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open LFD Frame"]))
	DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["Middle click to open M+ Frame"]))
	DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open Great Vault"]))

	DT.tooltip:Show()

	self.text:SetFormattedText(displayString, isMaxLevel and mMT:GetDungeonScore() or L["Level: "] .. E.mylevel)
end

local function OnEvent(self, event, ...)
	isMaxLevel = E:XPIsLevelMax()

	if isMaxLevel then
		if event == "ELVUI_FORCE_UPDATE" then
			C_MythicPlus_RequestMapInfo()
			C_MythicPlus_RequestCurrentAffixes()
		elseif event == "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" then
			affixes = C_MythicPlus_GetCurrentAffixes()
			weeklyAffixID = affixes and affixes[1] and affixes[1].id
			weeklyAffixName = weeklyAffixID and C_ChallengeMode_GetAffixInfo(weeklyAffixID)
			MPlusDataLoaded = true
		end

		SaveMyKeystone()
	end

	self.text:SetFormattedText(displayString, isMaxLevel and mMT:GetDungeonScore() or L["Level: "] .. E.mylevel)
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin("", hex, "%s|r")

	OnEvent(self)
end

DT:RegisterDatatext("M+ Score", mMT.DatatextString, {
	"CHALLENGE_MODE_START",
	"CHALLENGE_MODE_COMPLETED",
	"PLAYER_ENTERING_WORLD",
	"UPDATE_INSTANCE_INFO",
	"CHALLENGE_MODE_RESET",
	"ENCOUNTER_END",
	"MYTHIC_PLUS_CURRENT_AFFIX_UPDATE",
}, OnEvent, nil, OnClick, OnEnter, OnLeave, nil, nil, ValueColorUpdate)
