local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- code is partially based on ElvUI's Durability and Itemlevel datatext

local _G = _G
local format = format
local pi = math.pi

--Variables
local valueString = ""
local GetAverageItemLevel = GetAverageItemLevel
local GetMountInfoByID = C_MountJournal.GetMountInfoByID
local SummonByID = C_MountJournal.SummonByID

local avg, avgEquipped, avgPvp = 0, 0, 0
local GetInventoryItemDurability = GetInventoryItemDurability

local DURABILITY = DURABILITY
local REPAIR_COST = REPAIR_COST
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

local function OnEnter(self)
	DT.tooltip:ClearLines()
	DT.tooltip:AddLine(DURABILITY, mMT:GetRGB("title"))
	DT.tooltip:AddLine(" ")

	DT.tooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL, mMT:GetRGB("title"))
	DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), mMT:GetRGB("text", "M"))
	local r, g, b = mMT:GetRGB()
	DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), r, g, b, E:ColorizeItemLevel(avgEquipped - avg))
	DT.tooltip:AddDoubleLine(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT, format("%0.2f", avgPvp), r, g, b, E:ColorizeItemLevel(avgPvp - avg))
	DT.tooltip:AddLine(" ")

	DT.tooltip:AddLine(DURABILITY, mMT:GetRGB("title"))
	DT.tooltip:AddDoubleLine(DURABILITY, format("%d%%", totalDurability), 1, 1, 1, E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1))

	if totalRepairCost > 0 then DT.tooltip:AddDoubleLine(REPAIR_COST, E:FormatMoney(totalRepairCost, "BLIZZARD", false), mMT:GetRGB("text", "text")) end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. L["left click to open Character Frame"], mMT:GetRGB("tip"))

	local mountID = tonumber(E.db.mMT.datatexts.durability_itemLevel.mount)
	if mountID then
		local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
		if name and isUsable then DT.tooltip:AddDoubleLine(MEDIA.rightClick .. " " .. L["right click to use:"], format("%s %s", name, E:TextureString(icon, ":14:14")), mMT:GetRGB("tip", "M")) end
	end

	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function GetDurability()
	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc, repairCost = (currentDura / maxDura) * 100, 0
			invDurability[index] = perc

			if perc < totalDurability then totalDurability = perc end

			if E.Retail then
				local data = E.ScanTooltip:GetInventoryInfo("player", index)
				repairCost = data and data.repairCost
			else
				_, _, repairCost = E.ScanTooltip:SetInventoryItem("player", index)
			end

			totalRepairCost = totalRepairCost + (repairCost or 0)
		end
	end
end

local function OnEvent(self)
	if E.Retail or E.Mists then
		avg, avgEquipped, avgPvp = GetAverageItemLevel()
	end

	GetDurability()

	self.mMT_GetText = function()
		GetDurability()
		return totalDurability, avgEquipped
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
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or E.db.mMT.datatexts.durability_itemLevel.force_withe_text and "|CFFFFFFFF" or hex
	valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mMT - Durability & ItemLevel", mMT.Name, "UPDATE_INVENTORY_DURABILITY", OnEvent, nil, OnClick, OnEnter, OnLeave, "Durability & ItemLevel", nil, ValueColorUpdate)
