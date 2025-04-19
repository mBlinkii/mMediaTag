local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local _G = _G
local format = format
local pi = math.pi

--Variables
local valueString = ""
local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemTexture = GetInventoryItemTexture
local GetMountInfoByID = C_MountJournal.GetMountInfoByID
local SummonByID = C_MountJournal.SummonByID

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

local styles = {
	a = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_01,
	},
	b = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_01,
	},
	c = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_01,
	},
	d = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_02,
	},
	e = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_02,
	},
	f = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_02,
	},
	g = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_03,
	},
	h = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_03,
	},
	i = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_03,
	},
	j = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_04,
	},
	k = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_04,
	},
	l = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_04,
	},
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
		DT.tooltip:AddDoubleLine(
			format("|T%s:14:14:0:0:64:64:4:60:4:60|t %s", GetInventoryItemTexture("player", slot), GetInventoryItemLink("player", slot)),
			format(tooltipString, durability),
			1,
			1,
			1,
			E:ColorGradient(durability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		)
	end

	if totalRepairCost > 0 then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
	end

	if E.Retail or E.Cata then
		local avg, avgEquipped, avgPvp = GetAverageItemLevel()
		DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), 1, 1, 1, 0.1, 1, 0.1)
		DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), 1, 1, 1, colorize(avgEquipped - avg))
		DT.tooltip:AddDoubleLine(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT, format("%0.2f", avgPvp), 1, 1, 1, colorize(avgPvp - avg))
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. mMT:TC(L["left click to open Character Frame"], "tip"))

	DT.tooltip:Show()

	local mountID = tonumber(E.db.mMT.datatexts.durability_itemLevel.mount)
	if mountID then
		local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
		if name and isUsable then DT.tooltip:AddDoubleLine(MEDIA.rightClick .. " " .. mMT:TC(L["right click to use:"], "tip"), format("%s %s", name, E:TextureString(icon, ":14:14"))) end
	end

	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function OnEvent(self)
	totalDurability, totalRepairCost = 100, 0
	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura and maxDura > 0 then
			local perc = (currentDura / maxDura) * 100
			invDurability[index] = perc
			totalDurability = math.min(totalDurability, perc)

			local repairCost = 0
			if E.Retail then
				local data = E.ScanTooltip:GetInventoryInfo("player", index)
				repairCost = data and data.repairCost or 0
			else
				_, _, repairCost = E.ScanTooltip:SetInventoryItem("player", index)
				repairCost = repairCost or 0
			end

			totalRepairCost = totalRepairCost + repairCost
		end
	end

	local avgEquipped = 0
	if E.Retail or E.Cata then
		_, avgEquipped = GetAverageItemLevel()
	end

	local avgEquippedString = format("%." .. E.db.general.decimalLength .. "f", avgEquipped)
	local totalDurabilityString = format("%." .. E.db.general.decimalLength .. "f%%", totalDurability)

	local icons = E.db.mMT.datatexts.durability_itemLevel.style ~= "none" and styles[E.db.mMT.datatexts.durability_itemLevel.style]
	local durability_color
	if E.db.mMT.datatexts.durability_itemLevel.warning then
		local repair_threshold = E.db.mMT.datatexts.durability_itemLevel.repair_threshold
		local warning_threshold = E.db.mMT.datatexts.durability_itemLevel.warning_threshold

		if totalDurability <= repair_threshold then
			durability_color = MEDIA.color.di_repair
		elseif totalDurability <= warning_threshold then
			durability_color = MEDIA.color.di_warning
		end

		if totalDurability <= repair_threshold then
			E:Flash(self, 0.5, true)
			self.isFlashing = true
		else
			E:StopFlash(self, 1)
			self.isFlashing = false
		end
	elseif self.isFlashing then
		E:StopFlash(self, 1)
		self.isFlashing = false
	end

	local text = ""
	if icons then
		local shieldIcon = E:TextureString(icons.shield, ":14:14")
		local armorIcon = E:TextureString(icons.armor, ":14:14")

		if durability_color then
			local color_data = format(":14:14:0:0:64:64:5:59:5:59:%d:%d:%d", mMT:round(durability_color.r * 255), mMT:round(durability_color.g * 255), mMT:round(durability_color.b * 255))
			text = format("%s |C%s%s|r %s %s", E:TextureString(icons.shield, color_data), durability_color.hex, totalDurabilityString, armorIcon, avgEquippedString)
		else
			text = format("%s %s %s %s", shieldIcon, totalDurabilityString, armorIcon, avgEquippedString)
		end
	else
		text = format("%s | %s", totalDurabilityString, avgEquippedString)
	end

	self.text:SetFormattedText(valueString, text)
end

local function OnClick(_, button)
	if not E:AlertCombat() then
		if button == "LeftButton" then
			_G.ToggleCharacter("PaperDollFrame")
		elseif button == "RightButton" then
			local mountID = tonumber(E.db.mMT.datatexts.durability_itemLevel.mount)
			if mountID then
				local isUsable = select(5, GetMountInfoByID(mountID))
				if isUsable then SummonByID(mountID) end
			end
		end
	end
end

local function ValueColorUpdate(self, hex)
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or E.db.mMT.datatexts.durability_itemLevel.force_withe_text and  "|CFFFFFFFF" or hex
	valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mMT - Durability & ItemLevel", mMT.Name, "UPDATE_INVENTORY_DURABILITY", OnEvent, nil, OnClick, OnEnter, OnLeave, "Durability & ItemLevel", nil, ValueColorUpdate)
