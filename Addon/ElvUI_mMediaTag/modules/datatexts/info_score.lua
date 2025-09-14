local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")
local LOR = LibStub("LibOpenRaid-1.0", true)

-- Cache WoW Globals
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local GetMapTable = C_ChallengeMode.GetMapTable
local GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes
local GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local UIParentLoadAddOn = UIParentLoadAddOn
local UnitName = UnitName
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local UnitIsPlayer = UnitIsPlayer
local UnitIsGroupLeader = UnitIsGroupLeader
local format = format
local ipairs = ipairs
local pairs = pairs
local strjoin = strjoin

local valueString = ""
local textString = ""
local isMaxLevel = nil
local leaderIcon = E:TextureString(MEDIA.icons.leader.leader01, ":14:14")
local armorIcon = E:TextureString(MEDIA.icons.datatexts.misc.armor, ":14:14")
local scoreIcon = E:TextureString(MEDIA.icons.datatexts.misc.score, ":14:14")

local function SaveMyKeystone()
	local myKeystone = mMT:GetMyKeystone()
	if myKeystone then
		DB.keystones = DB.keystones or {}
		DB.keystones[E.mynameRealm] = {
			name = format(MEDIA.myclass.string, E.mynameRealm),
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

	local name = GetMapUIInfo(id)
	if not name then return end

	local color = ITEM_QUALITY_COLORS[4]

	local colorKey = GetKeystoneLevelRarityColor(keyStoneLevel)
	colorKey.hex = colorKey and colorKey:GenerateHexColor() or "FFFFFFFF"

	return color.hex .. name .. " " .. format("|c%s+%s|r", colorKey.hex, keyStoneLevel) .. "|r", id
end

local function GetDungeonSummary()
	local scoreTable = {}
	local mapTable = GetMapTable()
	local summary = GetPlayerMythicPlusRatingSummary("player")
	local myKeystoneMapID = GetOwnedKeystoneChallengeMapID()

	-- build score table
	for _, id in ipairs(mapTable) do
		local name, _, _, texture = GetMapUIInfo(id)
		scoreTable[id] = {
			mapName = name or UNKNOWN,
			bestRunLevel = 0,
			levelColor = MEDIA.color.gray,
			mapScore = 0,
			scoreColor = MEDIA.color.gray,
			icon = E:TextureString(texture, ":14:14"),
			finishedSuccess = false,
			isMyKeystone = (id == myKeystoneMapID),
		}
	end

	if summary and summary.runs then
		for _, v in ipairs(summary.runs) do
			local name, _, _, texture = GetMapUIInfo(v.challengeModeID)
			scoreTable[v.challengeModeID] = {
				mapName = name or UNKNOWN,
				bestRunLevel = v.bestRunLevel,
				levelColor = GetKeystoneLevelRarityColor(v.bestRunLevel),
				mapScore = v.mapScore,
				scoreColor = GetSpecificDungeonOverallScoreRarityColor(v.mapScore) or HIGHLIGHT_FONT_COLOR,
				icon = E:TextureString(texture, ":14:14"),
				finishedSuccess = v.finishedSuccess,
				isMyKeystone = (v.challengeModeID == myKeystoneMapID),
			}
		end
	end

	if E.db.mMT.datatexts.score.sort_method == "SCORE" then
		table.sort(scoreTable, function(a, b)
			return a.mapScore > b.mapScore
		end)
	else
		table.sort(scoreTable, function(a, b)
			return a.bestRunLevel > b.bestRunLevel
		end)
	end

	return scoreTable
end

local function AddTooltipLine(v, mapName)
	local ratingColor = v.finishedSuccess and v.scoreColor:GenerateHexColor() or "FFA9A9A9"
	local rating = format("|c%s%s|r", ratingColor, v.mapScore)

	local levelColor = v.finishedSuccess and v.levelColor:GenerateHexColor() or "FFA9A9A9"
	local level = format("|c%s+%s|r", levelColor, v.bestRunLevel)

	DT.tooltip:AddDoubleLine(v.icon .. " " .. mapName, rating .. " (" .. level .. ")", mMT:GetRGB("text", "text"))
end

local function DungeonScoreTooltip()
	local scoreTable = GetDungeonSummary()

	if not next(scoreTable) then return end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["Dungeon overview:"], mMT:GetRGB("title"))

	for _, v in pairs(scoreTable) do
		local mapName = v.mapName
		if v.isMyKeystone then mapName = mMT:TC(mapName, "mark") end
		AddTooltipLine(v, mapName)
	end

	if E.db.mMT.datatexts.score.show_upgrade then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Possible next upgrades:"], mMT:GetRGB("title"))

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
				if v.isMyKeystone then mapName = mMT:TC(mapName, "mark") end
				AddTooltipLine(v, mapName)
			end
		end
	end
end

local function OnClick(self, button)
	if button == "LeftButton" or button == "MiddleButton" then
		_G.ToggleLFDParentFrame()
		if button == "MiddleButton" then _G.PVEFrameTab3:Click() end
	else
		if IsShiftKeyDown() then
			DB.keystones = {}
		else
			if not _G.WeeklyRewardsFrame then UIParentLoadAddOn("Blizzard_WeeklyRewards") end
			if _G.WeeklyRewardsFrame:IsVisible() then
				_G.WeeklyRewardsFrame:Hide()
			else
				_G.WeeklyRewardsFrame:Show()
			end
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
		if unit and UnitIsPlayer(unit) then
			local keystoneInfo = LOR.GetKeystoneInfo(unit)
			local unitGear = LOR.GetUnitGear(unit)
			local name = UnitName(unit)
			local unitName = format("%s%s|r", UnitClassColor(unit), name)
			local key = L["No Keystone"]

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

	if not isMaxLevel then self.text:SetFormattedText(textString, L["Level: "] .. format(valueString, E.mylevel)) end

	if not inCombat then
		if isMaxLevel then
			SaveMyKeystone()
			local myScore = mMT:GetMyMythicPlusScore()
			local myKeystone = mMT:GetMyKeystone()

			DT.tooltip:AddLine(L["My Info"], mMT:GetRGB("title"))
			DT.tooltip:AddDoubleLine(DUNGEON_SCORE, myScore, mMT:GetRGB("text", "text"))
			DT.tooltip:AddDoubleLine(L["Keystone"], myKeystone, mMT:GetRGB("text", "text"))
			self.text:SetText(myScore)
		end

		if DB.keystones and next(DB.keystones) then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(L["Keystones on your Account"], mMT:GetRGB("title"))
			for _, characters in pairs(DB.keystones) do
				DT.tooltip:AddDoubleLine(characters.name, characters.key)
			end
		end

		if E.db.mMT.datatexts.score.group_keystones and LOR and IsInGroup() and isMaxLevel then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(L["Keystones in your Group"], mMT:GetRGB("title"))
			GetGroupKeystone()
		end
	end

	local weeklyAffixes = mMT:GetWeeklyAffixes()
	if weeklyAffixes then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["This Week Affix"], mMT:GetRGB("title"))
		DT.tooltip:AddLine(weeklyAffixes, mMT:GetRGB("text"))
	end

	if isMaxLevel then
		DungeonScoreTooltip()

		local vaultInfoRaid, vaultInfoDungeons, vaultInfoWorld = mMT:GetVaultInfo()
		if vaultInfoRaid and vaultInfoDungeons and vaultInfoWorld then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(GREAT_VAULT_REWARDS, mMT:GetRGB("title"))
			DT.tooltip:AddDoubleLine(RAID, vaultInfoRaid, mMT:GetRGB("text", "text"))
			DT.tooltip:AddDoubleLine(DUNGEONS, vaultInfoDungeons, mMT:GetRGB("text", "text"))
			DT.tooltip:AddDoubleLine(WORLD, vaultInfoWorld, mMT:GetRGB("text", "text"))
		end
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. L["left click to open LFD Frame"], mMT:GetRGB("tip"))
	DT.tooltip:AddLine(MEDIA.middleClick .. " " .. L["middle click to open M+ Frame"], mMT:GetRGB("tip"))
	DT.tooltip:AddLine(MEDIA.rightClick .. " " .. L["right click to open Great Vault"], mMT:GetRGB("tip"))
	DT.tooltip:AddLine(MEDIA.rightClick .. " " .. L["SHIFT + right click to clear all saved keystones."], mMT:GetRGB("tip"))

	DT.tooltip:Show()
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		if mMT:GetWeeklyResetTime() then DB.keystones = {} end
	end

	isMaxLevel = isMaxLevel or E:XPIsLevelMax()

	if isMaxLevel then
		if event == "ELVUI_FORCE_UPDATE" then
			C_MythicPlus_RequestMapInfo()
			C_MythicPlus_RequestCurrentAffixes()
		end

		SaveMyKeystone()
	end
	local myScore = mMT:GetMyMythicPlusScore()
	self.text:SetFormattedText(textString, isMaxLevel and myScore or L["Level: "] .. format(valueString, E.mylevel))
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex
	textString = strjoin("", textHex, "%s|r")
	valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

local events = { "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO", "CHALLENGE_MODE_RESET", "ENCOUNTER_END", "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" }

DT:RegisterDatatext("mMT - M+ Score", mMT.Name, events, OnEvent, nil, OnClick, OnEnter, OnLeave, L["M+ Score"], nil, ValueColorUpdate)
