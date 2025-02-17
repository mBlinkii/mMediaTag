local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local GetOverallDungeonScore = C_ChallengeMode.GetOverallDungeonScore
local GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor

function mMT:GetMyKeystone(withIcon)
	local keyStoneLevel = GetOwnedKeystoneLevel()
	if keyStoneLevel then
		local color = ITEM_QUALITY_COLORS[4]
		local challengeMapID = GetOwnedKeystoneChallengeMapID()
		local name, id, _, icon, _ = GetMapUIInfo(challengeMapID)
		local colorKey = GetKeystoneLevelRarityColor(keyStoneLevel)
		colorKey.hex = colorKey and colorKey:GenerateHexColor() or "FFFFFFFF"

		return (withIcon and mMT:GetIconString(icon) .. " " or "") .. color.hex .. name .. " " .. format("|c%s+%s|r", colorKey.hex, keyStoneLevel) .. "|r", id
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

	local affixString = ""

	for _, affixInfo in ipairs(affixes) do
		local name, _ = GetAffixInfo(affixInfo.id)
		affixString = affixString .. " " .. name
	end

	return affixString
end
