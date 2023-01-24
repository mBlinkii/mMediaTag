local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...


local displayString = ''

local function OnEnter()
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

	DT.tooltip:Show()
end

local function OnEvent(self)
    self.text:SetFormattedText(displayString, mMT:GetDungeonScore())
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', hex, "%s|r")

	OnEvent(self)
end

DT:RegisterDatatext('M+ Score', "mMediaTag", {'MASTERY_UPDATE'}, OnEvent, nil, nil, OnEnter, nil, nil, nil, ValueColorUpdate)