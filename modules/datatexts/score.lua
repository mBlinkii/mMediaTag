local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

local displayString = ""

local function GetDungeonScores()
	local map_table = C_ChallengeMode.GetMapTable()
	local tyrannical = C_ChallengeMode.GetAffixInfo(9)
	local fortified = C_ChallengeMode.GetAffixInfo(10)
	local modes = { tyrannical, fortified }

	for i = 1, #map_table do
		local mapID = map_table[i]
		local affixScores, bestOverAllScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)
		local name, _, _, icon = C_ChallengeMode.GetMapUIInfo(mapID)
        local ScoreTyrannical = 0
        local ScoreFortified = 0

		for j, affix in pairs(modes) do
            ScoreTyrannical = affix == tyrannical and affixScores or 0
            ScoreFortified = affix == fortified and affixScores or 0

            if j == 2 then
                DT.tooltip:AddDoubleLine(name, format("%s|%s|%s", ScoreTyrannical, ScoreFortified, (bestOverAllScore or 0)))
                --scorTable[mapID] = {name = name, tyrannical = ScoreTyrannical, fortified = ScoreFortified}
                --print(scorTable[mapID].name, scorTable[mapID].tyrannical, scorTable[mapID].fortified)
            end
		end
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
