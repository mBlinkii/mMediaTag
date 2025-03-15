local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local LOR = LibStub("LibOpenRaid-1.0", true)

local _G = _G

-- Cache WoW Globals
local C_ChallengeMode = C_ChallengeMode
local C_MythicPlus = C_MythicPlus
local UnitName = UnitName
local GetRealmName = GetRealmName
local IsInGroup = IsInGroup
local InCombatLockdown = InCombatLockdown
local format = format
local ipairs = ipairs
local pairs = pairs
local select = select
local sort = sort
local strjoin = strjoin
local table = table

local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_ChallengeMode_GetMapTable = C_ChallengeMode.GetMapTable
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes
local C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
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
		local keyname = select(1, C_ChallengeMode_GetMapUIInfo(challengeMapID))
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
		for _, mapID in ipairs(map_table) do
			local name, _, _, icon = C_ChallengeMode_GetMapUIInfo(mapID)
			local intimeInfo, overtimeInfo = C_MythicPlus_GetSeasonBestForMap(mapID)
			intimeInfo = intimeInfo or { dungeonScore = 0, level = 0 }
			overtimeInfo = overtimeInfo or { dungeonScore = 0, level = 0 }

			local isTimed = intimeInfo.dungeonScore >= overtimeInfo.dungeonScore
			local score = isTimed and intimeInfo.dungeonScore or overtimeInfo.dungeonScore
			local level = isTimed and intimeInfo.level or overtimeInfo.level

			ScoreTable[mapID] = {
				name = name,
				icon = icon,
				isOwenKeystone = KeystoneChallengeMapID == mapID,
				score = score or 0,
				level = level,
				isTimed = isTimed,
				color = C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor(score),
			}
		end
	end

	return (ScoreTable and map_table) and ScoreTable or nil
end

local function DungeonScoreTooltip()
	local ScoreTable = GetDungeonScores()
	if not ScoreTable then return end

	if E.db.mMT.mpscore.upgrade then
		SortScore(ScoreTable)
		for i = 0, 2 do
			ScoreTable[map_table[#map_table - i]].upgrade = true
		end
	end

	if E.db.mMT.mpscore.sort == "SCORE" and not E.db.mMT.mpscore.upgrade then
		SortScore(ScoreTable)
	else
		SortLevel(ScoreTable)
	end

	for _, mapID in ipairs(map_table) do
		local entry = ScoreTable[mapID]
		local name = entry.name
		local icon = entry.icon
		local isOwenKeystone = entry.isOwenKeystone
		local score = entry.score
		local level = entry.level
		local color = entry.color and entry.color:GenerateHexColor() or "FFFFFFFF"
		local isTimed = entry.isTimed

		if E.db.mMT.mpscore.highlight and isOwenKeystone then
			local highlightColor = E.db.mMT.mpscore.highlightcolor.hex
			name = format("%s%s|r", highlightColor, name)
		end

		local nameString = format("%s %s", mMT:mIcon(icon), name)
		if E.db.mMT.mpscore.upgrade and entry.upgrade then nameString = nameString .. "  " .. mMT:mIcon(mMT.Media.UpgradeIcons[E.db.mMT.mpscore.icon]) end

		color = isTimed and color or "FFAFAFAF"
		local scoreString = (level ~= 0 and score ~= 0) and format("|C%s%s|r - |C%s%s|r", color, level, color, score) or L["No Score"]
		DT.tooltip:AddDoubleLine(nameString, scoreString)
	end
end

local function OnClick(self, button)
	if button == "LeftButton" or button == "MiddleButton" then
		_G.ToggleLFDParentFrame()
		if button == "MiddleButton" then _G.PVEFrameTab3:Click() end
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

	for _, unit in ipairs(GroupMembers) do
		if UnitIsPlayer(unit) then
			local keystoneInfo = LOR.GetKeystoneInfo(unit)
			local playerGear = LOR.GetUnitGear(unit)
			local name = UnitName(unit)
			local ilevel = playerGear and format("|CFFFFCC00i |r|CFFFFFFFF%s|r", playerGear.ilevel) or ""
			local leader = UnitIsGroupLeader(unit) and LeadIcon or ""

			if keystoneInfo then
				local mapName, _, _, icon = C_ChallengeMode.GetMapUIInfo(keystoneInfo.challengeMapID)
				if mapName then
					local scoreColor = C_ChallengeMode_GetDungeonScoreRarityColor(keystoneInfo.rating)
					scoreColor = scoreColor and scoreColor:GenerateHexColor() or "FFFFFFFF"
					icon = E:TextureString(icon, ":14:14")
					local key = format("%s %s%s|r %s", icon, E.db.mMT.datatextcolors.colormyth.hex, mapName, mMT:GetKeyColor(keystoneInfo.level))

					name = format(
						"%s%s|r %s |CFFFFFFFF[|r %sM+|r |C%s%s|r |CFFFFFFFF-|r %s|CFFFFFFFF]|r ",
						mMT:GetClassColor(unit),
						name,
						leader,
						E.db.mMT.instancedifficulty.mp.color,
						scoreColor,
						keystoneInfo.rating,
						ilevel
					)

					DT.tooltip:AddDoubleLine(name, key)
				end
			else
				name = format("%s%s|r %s |CFFFFFFFF[|r%s|CFFFFFFFF]|r ", mMT:GetClassColor(unit), name, leader, ilevel)
				DT.tooltip:AddDoubleLine(name, L["No Keystone"])
			end
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
				for _, line in ipairs(keyText) do
					DT.tooltip:AddLine(line)
				end
			end
		end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Keystones on your Account"])
		for _, v in pairs(mMT.DB.keys) do
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
		for _, line in ipairs(mAffixesText) do
			DT.tooltip:AddLine(line)
		end
	end

	if isMaxLevel then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, myScore)
		DT.tooltip:AddLine(" ")
		DungeonScoreTooltip()
		DT.tooltip:AddLine(" ")

		local rewards = mMT:mGetVaultInfo()
		if rewards then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(GREAT_VAULT_REWARDS)
			DT.tooltip:AddDoubleLine(rewards.raid.name, table.concat(rewards.raid.rewards, WrapTextInColorCode(" - ", "FFFFFFFF")))
			DT.tooltip:AddDoubleLine(rewards.dungeons.name, table.concat(rewards.dungeons.rewards, WrapTextInColorCode(" - ", "FFFFFFFF")))
			DT.tooltip:AddDoubleLine(rewards.world.name, table.concat(rewards.world.rewards, WrapTextInColorCode(" - ", "FFFFFFFF")))
		end
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
