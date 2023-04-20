local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

local displayString = ""
local tyrannical = C_ChallengeMode.GetAffixInfo(9)
local fortified = C_ChallengeMode.GetAffixInfo(10)
local affixes = C_MythicPlus.GetCurrentAffixes()
local weeklyAffixID = affixes and affixes[1] and affixes[1].id
local weehlyAffixName = weeklyAffixID and C_ChallengeMode.GetAffixInfo(weeklyAffixID)
local KeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
local C_ChallengeMode_GetMapTable = C_ChallengeMode.GetMapTable
local tablesort = table.sort
local tablegetn = table.getn
local map_table = C_ChallengeMode_GetMapTable()
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local MPlusDataLoaded = false

local function GetPlayerScore()
	local ratingSummary = C_PlayerInfo_GetPlayerMythicPlusRatingSummary("PLAYER")
	return ratingSummary and ratingSummary.currentSeasonScore or 0
end
local function SortScore(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	tablesort(map_table, function(a, b)
		return ScoreTable[a].score > ScoreTable[b].score
	end)
end
local function SortWeeklyLevel(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	tablesort(map_table, function(a, b)
		return ScoreTable[a][weehlyAffixName].level > ScoreTable[b][weehlyAffixName].level
	end)
end

local function SortWeeklyScore(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	tablesort(map_table, function(a, b)
		return ScoreTable[a][weehlyAffixName].score > ScoreTable[b][weehlyAffixName].score
	end)
end

local function addNotPlayed(ScoreTable, mapID, affix)
	ScoreTable[mapID][affix] = {}
	ScoreTable[mapID][affix].score = 0
	ScoreTable[mapID][affix].level = 0
	ScoreTable[mapID][affix].overTime = false
	ScoreTable[mapID][affix].color = "|CFFB2BABB"
end

local function GetColor(key)
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
	local name = UnitName("player")
	local realmName = GetRealmName()
	local _, unitClass = UnitClass("player")
	local class = ElvUF.colors.class[unitClass]
	local keyStoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
	if keyStoneLevel then
		local challengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local keyname, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(challengeMapID)
		E.db[mPlugin].keys[name .. "-" .. realmName] = {
			name = format("%s%s|r", E:RGBToHex(class[1], class[2], class[3]), name),
			key = (format("%s%s|r", E.db[mPlugin].mDataText.colormyth.hex, keyname) .. " " .. GetColor(keyStoneLevel)),
		}
	end
end

local function GetDungeonScores()
	local sortwl = false
	local sortws = false
	local showup = true
	local ScoreTable = {}
	map_table = C_ChallengeMode_GetMapTable()

	for i = 1, #map_table do
		local mapID = map_table[i]
		local affixScores, overAllScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)
		local name, _, _, icon = C_ChallengeMode.GetMapUIInfo(mapID)
		local inTimeInfo, overtimeInfo = C_MythicPlus.GetSeasonBestForMap(mapID)
		local color = "|CFFB2BABB"

		ScoreTable[mapID] = {}
		ScoreTable[mapID].name = name
		ScoreTable[mapID].icon = icon
		ScoreTable[mapID].OwnedKeystone = KeystoneChallengeMapID == mapID
		ScoreTable[mapID].score = overAllScore or 0

		if overAllScore then
			color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(overAllScore)
			ScoreTable[mapID].color = E:RGBToHex(color.r, color.g, color.b)
		else
			ScoreTable[mapID].color = "|CFFB2BABB"
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
					ScoreTable[mapID][affixScores[j].name].color = "|CFFB2BABB"
				else
					color = C_ChallengeMode.GetSpecificDungeonScoreRarityColor(affixScores[j].score)
					ScoreTable[mapID][affixScores[j].name].color = E:RGBToHex(color.r, color.g, color.b)
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

	if ScoreTable and map_table then
		if showup then
			SortWeeklyScore(ScoreTable)
			ScoreTable[map_table[tablegetn(map_table)]].upgrade = true
			ScoreTable[map_table[tablegetn(map_table) - 1]].upgrade = true
			ScoreTable[map_table[tablegetn(map_table) - 2]].upgrade = true
		end

		if sortws and weehlyAffixName then
			SortWeeklyScore(ScoreTable)
		elseif sortwl and weehlyAffixName then
			SortWeeklyLevel(ScoreTable)
		else
			SortScore(ScoreTable)
		end

		for i = 1, #map_table do
			local mapID = map_table[i]

			local nameString = L["No Dungeon"]
			local scoreString = L["No Score"]

			if ScoreTable[mapID].OwnedKeystone then
				nameString =
					format("%s%s %s|r", "|CFF58D68D", mMT:mIcon(ScoreTable[mapID].icon), ScoreTable[mapID].name)
			else
				nameString = format("%s %s", mMT:mIcon(ScoreTable[mapID].icon), ScoreTable[mapID].name)
			end

			if ScoreTable[mapID].upgrade and showup then
				nameString = nameString .. "  " .. mMT:mIcon([[Interface\AddOns\ElvUI_mMediaTag\media\upgrade7.tga]])
			end

			scoreString = format(
				"%s%s|r | %s%s|r | %s%s|r",
				ScoreTable[mapID][tyrannical].color,
				ScoreTable[mapID][tyrannical].level,
				ScoreTable[mapID][fortified].color,
				ScoreTable[mapID][fortified].level,
				ScoreTable[mapID].color,
				ScoreTable[mapID].score
			)
			DT.tooltip:AddDoubleLine(nameString, scoreString)
		end
	end
end

local function OnEnter(self)
	SaveMyKeystone()
	DT.tooltip:ClearLines()

	local keyText = mMT:OwenKeystone()
	if keyText then
		DT.tooltip:AddLine(keyText[1])
		DT.tooltip:AddLine(keyText[2])
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["Keystons on your Account"])
	for k, v in pairs(E.db[mPlugin].keys) do
		DT.tooltip:AddDoubleLine(v.name, v.key)
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

	if MPlusDataLoaded and GetPlayerScore() > 0 then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(L["Dungeon Name"], "Tyr | For | Sco")
		GetDungeonScores()
	end

	DT.tooltip:Show()

	self.text:SetFormattedText(displayString, mMT:GetDungeonScore())
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		C_MythicPlus.RequestMapInfo()
		C_MythicPlus.RequestCurrentAffixes()
	elseif event == "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" then
		MPlusDataLoaded = true
	end
	local savekey = true

	if savekey then
		SaveMyKeystone()
	end

	self.text:SetFormattedText(displayString, mMT:GetDungeonScore())
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin("", hex, "%s|r")

	OnEvent(self)
end

DT:RegisterDatatext("M+ Score", "mMediaTag", {
	"CHALLENGE_MODE_START",
	"CHALLENGE_MODE_COMPLETED",
	"PLAYER_ENTERING_WORLD",
	"UPDATE_INSTANCE_INFO",
	"CHALLENGE_MODE_LEADERS_UPDATE",
	"MYTHIC_PLUS_CURRENT_AFFIX_UPDATE",
}, OnEvent, nil, nil, OnEnter, nil, nil, nil, ValueColorUpdate)