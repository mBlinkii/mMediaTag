local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local LOR = LibStub("LibOpenRaid-1.0", true)

local _G = _G

local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_ChallengeMode_GetMapTable = C_ChallengeMode.GetMapTable
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes
local C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
local C_MythicPlus_RequestRewards = C_MythicPlus.RequestRewards
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local C_WeeklyRewards_GetActivities = C_WeeklyRewards.GetActivities
local UIParentLoadAddOn = UIParentLoadAddOn
local C_MythicPlus_GetSeasonBestForMap = C_MythicPlus.GetSeasonBestForMap

local tablesort = sort
local displayString = ""
local map_table = C_ChallengeMode_GetMapTable()
local LeadIcon = E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\crown1.tga", ":14:14")
local isMaxLevel = E:XPIsLevelMax()
local myScore = 0

local function SortScore(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then tablesort(map_table, function(a, b)
		return ScoreTable[a].score > ScoreTable[b].score
	end) end
end

local function SortLevel(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then tablesort(map_table, function(a, b)
		return ScoreTable[a].level > ScoreTable[b].level
	end) end
end

function mMT:GetKeyColor(key)
	local keyColor = GetKeystoneLevelRarityColor(key)
	keyColor = keyColor and keyColor:GenerateHexColor() or "FFFFFFFF"

	return format("|C%s+%s|r", keyColor, key)
end

local function SaveMyKeystone()
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
end

local function GetDungeonScores()
	local ScoreTable = {}

	local KeystoneChallengeMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
	map_table = C_ChallengeMode_GetMapTable()

	if map_table then
		for i = 1, #map_table do
			local mapID = map_table[i]
			local name, _, _, icon = C_ChallengeMode_GetMapUIInfo(mapID)
			local intimeInfo, overtimeInfo = C_MythicPlus_GetSeasonBestForMap(mapID)

			intimeInfo = intimeInfo or { dungeonScore = 0, level = 0 }
			overtimeInfo = overtimeInfo or { dungeonScore = 0, level = 0 }

			local isTimed = intimeInfo.dungeonScore >= overtimeInfo.dungeonScore
			local score = isTimed and intimeInfo.dungeonScore or overtimeInfo.dungeonScore
			local level = isTimed and intimeInfo.level or overtimeInfo.level
			ScoreTable[mapID] = {}
			ScoreTable[mapID].name = name
			ScoreTable[mapID].icon = icon
			ScoreTable[mapID].isOwenKeystone = KeystoneChallengeMapID == mapID
			ScoreTable[mapID].score = score or 0
			ScoreTable[mapID].level = level
			ScoreTable[mapID].isTimed = isTimed
			ScoreTable[mapID].color = C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor(score)
		end
	end

	return (ScoreTable and map_table) and ScoreTable or nil
end

local function padNumber(n, w)
	n = n or 0
	return format("%" .. w .. "s", n)
end

local function GetRewards()
	local rewards = C_WeeklyRewards_GetActivities(Enum.WeeklyRewardChestThresholdType.Activities)
	local rewardsText = {}

	for i = 1, #rewards do
		local reward = rewards[i]
		local ilvl = C_MythicPlus.GetRewardLevelForDifficultyLevel(reward.level)

		if reward.progress < reward.threshold then
			local rt = reward.progress .. "/" .. reward.threshold
			table.insert(rewardsText, WrapTextInColorCode(rt, "ff9d9d9d"))
		else
			local color = GetKeystoneLevelRarityColor(reward.level)
			local rt = reward.threshold .. "/" .. reward.threshold .. ": " .. padNumber("+" .. reward.level, 3) .. " (" .. ilvl .. ")"
			if color then table.insert(rewardsText, color:WrapTextInColorCode(rt)) end
		end
	end

	return table.concat(rewardsText, WrapTextInColorCode(" - ", "FFFFFFFF"))
end

local function DungeonScoreTooltip()
	ScoreTable = GetDungeonScores()
	local reward = GetRewards()

	if ScoreTable then
		if E.db.mMT.mpscore.upgrade then
			SortScore(ScoreTable)
			ScoreTable[map_table[#map_table]].upgrade = true
			ScoreTable[map_table[#map_table - 1]].upgrade = true
			ScoreTable[map_table[#map_table - 2]].upgrade = true
		end

		if E.db.mMT.mpscore.sort == "SCORE" and not E.db.mMT.mpscore.upgrade then
			SortScore(ScoreTable)
		else
			SortLevel(ScoreTable)
		end

		for i = 1, #map_table do
			local mapID = map_table[i]

			local name = ScoreTable[mapID].name
			local icon = ScoreTable[mapID].icon
			local isOwenKeystone = ScoreTable[mapID].isOwenKeystone
			local score = ScoreTable[mapID].score
			local level = ScoreTable[mapID].level
			local color = ScoreTable[mapID].color and ScoreTable[mapID].color:GenerateHexColor() or "FFFFFFFF"
			local isTimed = ScoreTable[mapID].isTimed

			local nameString = L["No Dungeon"]
			local scoreString = L["No Score"]

			if E.db.mMT.mpscore.highlight and isOwenKeystone then
				local highlightColor = E.db.mMT.mpscore.highlightcolor.hex
				name = format("%s%s|r", highlightColor, name)
			end

			nameString = format("%s %s", mMT:mIcon(icon), name)

			if E.db.mMT.mpscore.upgrade and ScoreTable[mapID].upgrade then nameString = nameString .. "  " .. mMT:mIcon(mMT.Media.UpgradeIcons[E.db.mMT.mpscore.icon]) end

			color = isTimed and color or "FFAFAFAF"
			scoreString = (level ~= 0 and score ~= 0) and format("|C%s%s|r - |C%s%s|r", color, level, color, score) or L["No Score"]
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
		if not _G.WeeklyRewardsFrame then UIParentLoadAddOn("Blizzard_WeeklyRewards") end
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
	local GroupMembers = { "player" }

	for i = 1, GetNumGroupMembers() - 1 do
		table.insert(GroupMembers, "party" .. i)
	end

	LOR.RequestKeystoneDataFromParty()
	LOR.GearManager.GetAllUnitsGear()

	for _, unit in ipairs(GroupMembers) do
		local info = LOR.GetKeystoneInfo(unit)
		local UnitInfo = LOR.GetUnitGear(unit)
		local name = UnitName(unit)
		local ilevel = ""
		local leader = UnitIsGroupLeader(unit) and LeadIcon or ""

		if UnitInfo then ilevel = format("|CFFFFCC00i |r|CFFFFFFFF%s|r", UnitInfo.ilevel) end

		if info then
			local mapName, _, _, icon = C_ChallengeMode.GetMapUIInfo(info.mythicPlusMapID)
			if mapName then
				local scoreColor = C_ChallengeMode_GetDungeonScoreRarityColor(info.rating)
				scoreColor = scoreColor and scoreColor:GenerateHexColor() or "FFFFFFFF"
				icon = E:TextureString(icon, ":14:14")
				local key = format("%s %s%s|r %s", icon, E.db.mMT.datatextcolors.colormyth.hex, mapName, mMT:GetKeyColor(info.level))

				name = format(
					"%s%s|r %s |CFFFFFFFF[|r %sM+|r |C%s%s|r |CFFFFFFFF-|r %s|CFFFFFFFF]|r ",
					mMT:GetClassColor(unit),
					UnitName(unit),
					leader,
					E.db.mMT.instancedifficulty.mp.color,
					scoreColor,
					info.rating,
					ilevel
				)

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
		myScore = mMT:GetDungeonScore()
		if isMaxLevel then
			local keyText = mMT:OwenKeystone()
			if keyText then
				for i = 1, #keyText do
					DT.tooltip:AddLine(keyText[i])
				end
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
		for i = 1, #mAffixesText do
			DT.tooltip:AddLine(mAffixesText[i])
		end
	end

	if isMaxLevel then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, myScore)
		DT.tooltip:AddLine(" ")
		DungeonScoreTooltip()
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(L["Rewards"], GetRewards())
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open LFD Frame"]))
	DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["Middle click to open M+ Frame"]))
	DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open Great Vault"]))

	DT.tooltip:Show()

	self.text:SetFormattedText(displayString, isMaxLevel and myScore or L["Level: "] .. E.mylevel)
end

local function OnEvent(self, event, ...)
	isMaxLevel = E:XPIsLevelMax()

	if isMaxLevel then
		if event == "ELVUI_FORCE_UPDATE" then
			C_MythicPlus_RequestMapInfo()
			C_MythicPlus_RequestCurrentAffixes()
		end

		SaveMyKeystone()
	end

	myScore = mMT:GetDungeonScore()
	self.text:SetFormattedText(displayString, isMaxLevel and myScore or L["Level: "] .. E.mylevel)
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
