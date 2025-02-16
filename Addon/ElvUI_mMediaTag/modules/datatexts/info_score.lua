local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")
local LOR = LibStub("LibOpenRaid-1.0", true)

-- Cache WoW Globals
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_ChallengeMode_GetMapTable = C_ChallengeMode.GetMapTable
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes
local GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local UIParentLoadAddOn = UIParentLoadAddOn
local C_MythicPlus_GetSeasonBestForMap = C_MythicPlus.GetSeasonBestForMap
local UnitName = UnitName
local GetRealmName = GetRealmName
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local UnitIsPlayer = UnitIsPlayer
local UnitIsGroupLeader = UnitIsGroupLeader
local format = format
local ipairs = ipairs
local pairs = pairs
local sort = sort
local strjoin = strjoin

local displayString = ""
local map_table = C_ChallengeMode_GetMapTable()
local LeadIcon = E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\crown1.tga", ":14:14")
local isMaxLevel = nil
--local myScore = 0

local leaderIcon = E:TextureString(MEDIA.icons.leader.leader01, ":14:14")
local armorIcon = E:TextureString(MEDIA.icons.datatexts.armor, ":14:14")
local scoreIcon = E:TextureString(MEDIA.icons.datatexts.score, ":14:14")

local function SaveMyKeystone()
	local myKeystone = mMT:GetMyKeystone()
	if myKeystone then
		DB.keystones = DB.keystones or {}
		DB.keystones[E.mynameRealm] = {
			name = format(MEDIA.classColor.string, E.mynameRealm),
			key = myKeystone,
		}
	end
end

local function UnitClassColor(unit)
	local _, unitClass = UnitClass(unit)
	local classColor = E.oUF.colors.class[unitClass]
	return classColor and E:RGBToHex(classColor.r, classColor.g, classColor.b) or "|cffffffff"
end

local function GetKeystoneString(id, keyStoneLevel)
	if not id then return end

	local name, _, _, icon, _ = GetMapUIInfo(id)
	if not name and icon then return end

	local color = ITEM_QUALITY_COLORS[4]

	local colorKey = GetKeystoneLevelRarityColor(keyStoneLevel)
	colorKey.hex = colorKey and colorKey:GenerateHexColor() or "FFFFFFFF"

	return mMT:GetIconString(icon) .. " " .. color.hex .. name .. " +" .. format("|c%s%s|r", colorKey.hex, keyStoneLevel) .. "|r", id
end

local function SortScore(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then sort(map_table, function(a, b)
		return ScoreTable[a].score > ScoreTable[b].score
	end) end
end

local function SortLevel(ScoreTable)
	map_table = C_ChallengeMode_GetMapTable()
	if map_table then sort(map_table, function(a, b)
		return ScoreTable[a].level > ScoreTable[b].level
	end) end
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

local function GetDungeonSummary()
	local scoreTable = {}
	local summary = GetPlayerMythicPlusRatingSummary("player")
	local myKeystoneMapID = GetOwnedKeystoneChallengeMapID()

	if summary and summary.runs then
		for i, v in ipairs(summary.runs) do
			local name, _, _, texture, _ = GetMapUIInfo(v.challengeModeID)
			scoreTable[v.challengeModeID] = {
				mapName = name or UNKNOWN,
				bestRunLevel = v.bestRunLevel,
				levelColor = GetKeystoneLevelRarityColor(v.bestRunLevel),
				mapScore = v.mapScore,
				scoreColor = GetSpecificDungeonOverallScoreRarityColor(v.mapScore) or HIGHLIGHT_FONT_COLOR,
				icon = mMT:GetIconString(texture),
				finishedSuccess = v.finishedSuccess,
				isMyKeystone = v.challengeModeID == myKeystoneMapID,
			}
		end
	end

	return scoreTable
end

local function DungeonScoreTooltip()
	local scoreTable = GetDungeonSummary()

	if not next(scoreTable) then return end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["Dungeon overview:"])

	if E.db.mMT.datatexts.score.sort_method == "SCORE" then
		sort(scoreTable, function(a, b)
			return scoreTable[a].mapScore > scoreTable[b].mapScore
		end)
	else
		sort(scoreTable, function(a, b)
			return scoreTable[a].bestRunLevel > scoreTable[b].bestRunLevel
		end)
	end

	for _, v in pairs(scoreTable) do
		local mapName = v.mapName

		if E.db.mMT.datatexts.score.highlight and v.isOwenKeystone then
			local highlightColor = HIGHLIGHT_FONT_COLOR:GenerateHexColor()
			mapName = format("|c%s%s|r", highlightColor, mapName)
		end

		local ratingColor = v.finishedSuccess and v.scoreColor:GenerateHexColor() or "FFA9A9A9"
		local rating = format("|c%s%s|r", ratingColor, v.mapScore)

		local levelColor = v.finishedSuccess and v.levelColor:GenerateHexColor() or "FFA9A9A9"
		local level = format("|c%s+%s|r", levelColor, v.bestRunLevel)

		DT.tooltip:AddDoubleLine(v.icon .. " " .. mapName, rating .. " (" .. level .. ")")
	end

	if E.db.mMT.datatexts.score.show_upgrade then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Possible next upgrades:"])

		local upgradeTable = {}
		for _, data in pairs(scoreTable) do
			table.insert(upgradeTable, data)
		end

		table.sort(upgradeTable, function(a, b)
			return a.mapScore < b.mapScore
		end)

		if #upgradeTable >= 2 then
			upgradeTable[1].upgrade = true
			upgradeTable[2].upgrade = true
		end

		for _, v in pairs(upgradeTable) do
			if v.upgrade then
				local mapName = v.mapName

				if E.db.mMT.datatexts.score.highlight and v.isOwenKeystone then
					local highlightColor = HIGHLIGHT_FONT_COLOR:GenerateHexColor()
					mapName = format("|c%s%s|r", highlightColor, mapName)
				end

				local ratingColor = v.finishedSuccess and v.scoreColor:GenerateHexColor() or "FFA9A9A9"
				local rating = format("|c%s%s|r", ratingColor, v.mapScore)

				local levelColor = v.finishedSuccess and v.levelColor:GenerateHexColor() or "FFA9A9A9"
				local level = format("|c%s+%s|r", levelColor, v.bestRunLevel)

				DT.tooltip:AddDoubleLine(v.icon .. " " .. mapName, rating .. " (" .. level .. ")")
			end
		end
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
			local unitGear = LOR.GetUnitGear(unit)
			local name = UnitName(unit)
			local unitName = format("%s%s|r", UnitClassColor(unit), name)
			local key = L["No Keystone"]

			print(UnitIsGroupLeader(unit))

			local unitItemLevel = ""
			if unitGear and unitGear.ilevel then
				local hex = "FFAB5CFE"
				unitItemLevel = format("|c%s%s|r", hex, unitGear.ilevel)
			end

			local info = (UnitIsGroupLeader(unit) and leaderIcon or "") .. unitName .. unitItemLevel

			if keystoneInfo then
				local membersKeystone = GetKeystoneString(keystoneInfo.challengeMapID, keystoneInfo.level)
				if membersKeystone then
					local ratingColor = GetDungeonScoreRarityColor(keystoneInfo.rating)
					ratingColor.hex = ratingColor and ratingColor:GenerateHexColor() or "FFFFFFFF"
					local unitRating = format("|c%s%s|r", ratingColor.hex, keystoneInfo.rating)

					key = membersKeystone
					info = (UnitIsGroupLeader(unit) and leaderIcon .. " " or "") .. unitName .. "   " .. scoreIcon .. " " .. unitRating .. "   " .. armorIcon .. " " .. unitItemLevel
				end
			end

			DT.tooltip:AddDoubleLine(info, key)
		end
	end
end

local function OnEnter(self)
	isMaxLevel = isMaxLevel or E:XPIsLevelMax()
	local inCombat = InCombatLockdown()
	DT.tooltip:ClearLines()

	if not isMaxLevel then self.text:SetFormattedText(displayString, L["Level: "] .. E.mylevel) end

	if not inCombat then
		if isMaxLevel then
			SaveMyKeystone()
			local myScore = mMT:GetMyMythicPlusScore()
			local myKeystone = mMT:GetMyKeystone(true)

			DT.tooltip:AddLine(L["My Info"])
			DT.tooltip:AddDoubleLine(DUNGEON_SCORE, myScore)
			DT.tooltip:AddDoubleLine(L["Keystone"], myKeystone)
			self.text:SetFormattedText(displayString, myScore)
		end

		if next(DB.keystones) then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(L["Keystones on your Account"])
			for _, characters in pairs(DB.keystones) do
				DT.tooltip:AddDoubleLine(characters.name, characters.key)
			end
		end

		if E.db.mMT.datatexts.score.group_keystones and LOR and IsInGroup() and isMaxLevel then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(L["Keystones in your Group"])
			GetGroupKeystone()
		end
	end

	-- local mAffixesText = mMT:WeeklyAffixes()
	-- if mAffixesText then
	-- 	DT.tooltip:AddLine(" ")
	-- 	for _, line in ipairs(mAffixesText) do
	-- 		DT.tooltip:AddLine(line)
	-- 	end
	-- end

	-- if isMaxLevel then
	DungeonScoreTooltip()

	-- 	local rewards = mMT:mGetVaultInfo()
	-- 	if rewards then
	-- 		DT.tooltip:AddLine(" ")
	-- 		DT.tooltip:AddLine(GREAT_VAULT_REWARDS)
	-- 		DT.tooltip:AddDoubleLine(rewards.raid.name, table.concat(rewards.raid.rewards, WrapTextInColorCode(" - ", "FFFFFFFF")))
	-- 		DT.tooltip:AddDoubleLine(rewards.dungeons.name, table.concat(rewards.dungeons.rewards, WrapTextInColorCode(" - ", "FFFFFFFF")))
	-- 		DT.tooltip:AddDoubleLine(rewards.world.name, table.concat(rewards.world.rewards, WrapTextInColorCode(" - ", "FFFFFFFF")))
	-- 	end
	-- end

	-- DT.tooltip:AddLine(" ")
	-- DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open LFD Frame"]))
	-- DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["Middle click to open M+ Frame"]))
	-- DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open Great Vault"]))

	DT.tooltip:Show()
end

local function OnEvent(self, event, ...)
	isMaxLevel = isMaxLevel or E:XPIsLevelMax()

	if isMaxLevel then
		if event == "ELVUI_FORCE_UPDATE" then
			C_MythicPlus_RequestMapInfo()
			C_MythicPlus_RequestCurrentAffixes()
		end

		SaveMyKeystone()
	end
	print(mMT:GetMyKeystone(true))
	local myScore = mMT:GetMyMythicPlusScore()
	self.text:SetFormattedText(displayString, isMaxLevel and myScore or L["Level: "] .. E.mylevel)
end

local function ValueColorUpdate(self, hex)
	if E.db.mMT.datatexts.text.override_color then hex = E.db.mMT.datatexts.text.color.hex end
	displayString = strjoin("", hex, "%s|r")
	OnEvent(self)
end

local events = { "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO", "CHALLENGE_MODE_RESET", "ENCOUNTER_END", "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" }

DT:RegisterDatatext("M+ Score", mMT.NameShort, events, OnEvent, nil, OnClick, OnEnter, OnLeave, nil, nil, ValueColorUpdate)
