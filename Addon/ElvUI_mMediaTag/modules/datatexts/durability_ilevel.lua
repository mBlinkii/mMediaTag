local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown
local pi = math.pi
--Variables
local mText = L["Durability/ Ilevel"]
local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)

local REPAIR_COST = REPAIR_COST
local tooltipString = "%d%%"
local totalDurability = 0
local invDurability = {}
local totalRepairCost

local slots = {
	[1] = _G.INVTYPE_HEAD,
	[3] = _G.INVTYPE_SHOULDER,
	[5] = _G.INVTYPE_CHEST,
	[6] = _G.INVTYPE_WAIST,
	[7] = _G.INVTYPE_LEGS,
	[8] = _G.INVTYPE_FEET,
	[9] = _G.INVTYPE_WRIST,
	[10] = _G.INVTYPE_HAND,
	[16] = _G.INVTYPE_WEAPONMAINHAND,
	[17] = _G.INVTYPE_WEAPONOFFHAND,
	[18] = _G.INVTYPE_RANGED,
}

local function colorize(num)
	if num >= 0 then
		return 0.1, 1, 0.1
	else
		return E:ColorGradient(-(pi / num), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	end
end
local function OnEnter(self)
    DT.tooltip:ClearLines()

    for slot, durability in pairs(invDurability) do
        DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:4:60:4:60|t %s", GetInventoryItemTexture("player", slot), GetInventoryItemLink("player", slot)), format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1))
    end

    if totalRepairCost > 0 then
        DT.tooltip:AddLine(" ")
        DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
    end

    local avg, avgEquipped, avgPvp = GetAverageItemLevel()
    DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), 1, 1, 1, 0.1, 1, 0.1)
    DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), 1, 1, 1, colorize(avgEquipped - avg))
    DT.tooltip:AddDoubleLine(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT, format("%0.2f", avgPvp), 1, 1, 1, colorize(avgPvp - avg))

	DT.tooltip:Show()
end

local function OnLeave(self)
    DT.tooltip:Hide()
end

local function OnEvent(self)
	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc, repairCost = (currentDura / maxDura) * 100, 0
			invDurability[index] = perc

			if perc < totalDurability then
				totalDurability = perc
			end

			if E.Retail and E.ScanTooltip.GetTooltipData then
				E.ScanTooltip:SetInventoryItem("player", index)
				E.ScanTooltip:Show()

				local data = E.ScanTooltip:GetTooltipData()
				repairCost = data and data.repairCost
			else
				repairCost = select(3, E.ScanTooltip:SetInventoryItem("player", index))
			end

			totalRepairCost = totalRepairCost + (repairCost or 0)
		end
	end
    local _, avgEquipped = GetAverageItemLevel()
    local TextDurability = totalDurability and format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\shield.tga:14:14:0:0:64:64:5:59:5:59|t %s", format("%d%%|r", totalDurability)) or ""
	local TextIlvl = format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\armor.tga:14:14:0:0:64:64:5:59:5:59|t %s", mMT:round(avgEquipped or 0))
    self.text:SetText(TextDurability .. " " .. TextIlvl)
end

local function OnClick()
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	else
		_G.ToggleCharacter("PaperDollFrame")
	end
end

DT:RegisterDatatext("DurabilityIlevel", "mMediaTag", "UPDATE_INVENTORY_DURABILITY", OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
