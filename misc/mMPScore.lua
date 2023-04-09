local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

local displayString = ""
local function sort_dungeons(map_table)
	-- 1) fetch score for each dungeon
	local map_scores = {}
	for _, mapID in ipairs(map_table) do
		local inTimeInfo, overtimeInfo = C_MythicPlus.GetSeasonBestForMap(mapID)
		local dungeonScore = 0
		if inTimeInfo and overtimeInfo then
			local inTimeScoreIsBetter = inTimeInfo.dungeonScore > overtimeInfo.dungeonScore
			dungeonScore = inTimeScoreIsBetter and inTimeInfo.dungeonScore or overtimeInfo.dungeonScore
		elseif inTimeInfo or overtimeInfo then
			dungeonScore = inTimeInfo and inTimeInfo.dungeonScore or overtimeInfo and overtimeInfo.dungeonScore
		end
		map_scores[mapID] = dungeonScore
	end

	-- 2) sort them!
	table.sort(map_table, function(a, b)
		return map_scores[a] > map_scores[b]
	end)
	return map_table
end
local function GetDungeonScores()
	local map_table = C_ChallengeMode.GetMapTable()
	local tyrannical = C_ChallengeMode.GetAffixInfo(9)
	local fortified = C_ChallengeMode.GetAffixInfo(10)
	local modes = { tyrannical, fortified }

	sort_dungeons(map_table)

	local map_scores = {}
	local ScoreTable = {}
	local color = "|CFFB2BABB"

	for i = 1, #map_table do
		local mapID = map_table[i]
		local affixScores, overAllScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)
		local name, _, _, icon = C_ChallengeMode.GetMapUIInfo(mapID)
		color = "|CFFB2BABB"
		wipe(ScoreTable)
		if affixScores then
			for j = 1, 2 do
				if affixScores[j] then
					if affixScores[j].name == tyrannical then
						ScoreTable.TyranScore = affixScores[j].score or 0
						ScoreTable.TyranLevel = affixScores[j].level or 0
						ScoreTable.TyranColor = C_ChallengeMode.GetSpecificDungeonScoreRarityColor(affixScores[j].score)
						ScoreTable.TyranTime = affixScores[j].durationSec
						if affixScores[j].overTime then
							ScoreTable.TyranColor = "|CFFB2BABB"
						else
							ScoreTable.TyranColor =
								E:RGBToHex(ScoreTable.TyranColor.r, ScoreTable.TyranColor.g, ScoreTable.TyranColor.b)
						end
					else
						ScoreTable.FortifScore = affixScores[j].score or 0
						ScoreTable.FortifLevel = affixScores[j].level or 0
						ScoreTable.FortifOverTime = affixScores[j].overTime
						ScoreTable.FortifColor =
							C_ChallengeMode.GetSpecificDungeonScoreRarityColor(affixScores[j].score)
						ScoreTable.FortifTime = affixScores[j].durationSec
						if affixScores[j].overTime then
							ScoreTable.FortifColor = "|CFFB2BABB"
						else
							ScoreTable.FortifColor =
								E:RGBToHex(ScoreTable.FortifColor.r, ScoreTable.FortifColor.g, ScoreTable.FortifColor.b)
						end
					end
				end
			end
		end

		if overAllScore then
			color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(overAllScore)
			color = E:RGBToHex(color.r, color.g, color.b)
		end

		DT.tooltip:AddDoubleLine(
			mMT:mIcon(icon) .. " " .. name,
			format(
				"%s%s|r | %s%s|r | %s%s|r",
				ScoreTable.TyranColor or "|CFFB2BABB",
				ScoreTable.TyranLevel or 0,
				ScoreTable.FortifColor or "|CFFB2BABB",
				ScoreTable.FortifLevel or 0,
				color,
				(overAllScore or 0)
			)
		)
	end
end

local function OnEnter(self)
	DT.tooltip:ClearLines()

	local keyText = mMT:OwenKeystone()
	if keyText then
		DT.tooltip:AddLine(keyText[1])
		DT.tooltip:AddLine(keyText[2])
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

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(L["Dungeon Name"], "Tyr | For | Sco")
	GetDungeonScores()
	DT.tooltip:Show()

	self.text:SetFormattedText(displayString, mMT:GetDungeonScore())
end

local function OnEvent(self)
	self.text:SetFormattedText(displayString, mMT:GetDungeonScore())
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin("", hex, "%s|r")

	OnEvent(self)
end

DT:RegisterDatatext(
	"M+ Score",
	"mMediaTag",
	{ "MASTERY_UPDATE" },
	OnEvent,
	nil,
	nil,
	OnEnter,
	nil,
	nil,
	nil,
	ValueColorUpdate
)
