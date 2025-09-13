local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

-- code is partially based on ElvUI's Durability and Itemlevel datatext

local icons = MEDIA.icons.dock
local avg, avgEquipped, avgPvp = 0, 0, 0
local GetAverageItemLevel = GetAverageItemLevel
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

local config = {
	name = "mMT_Dock_Character",
	localizedName = "|CFF01EEFFDock|r" .. " " .. CHARACTER_BUTTON,
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
	text = {
		enable = false,
		center = true,
		a = false, -- first label
		b = false, -- second label
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMT.dock.tooltip then
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine(mMT:TC(CHARACTER_BUTTON, "title"))
		DT.tooltip:AddLine(" ")

		DT.tooltip:AddLine(mMT:TC(STAT_AVERAGE_ITEM_LEVEL, "title"))
		DT.tooltip:AddDoubleLine(mMT:TC(STAT_AVERAGE_ITEM_LEVEL), mMT:TC(format("%0.2f", avg), "M"))
		DT.tooltip:AddDoubleLine(mMT:TC(GMSURVEYRATING3), format("%0.2f", avgEquipped), 1, 1, 1, E:ColorizeItemLevel(avgEquipped - avg))
		DT.tooltip:AddDoubleLine(mMT:TC(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT), format("%0.2f", avgPvp), 1, 1, 1, E:ColorizeItemLevel(avgPvp - avg))
		DT.tooltip:AddLine(" ")

		DT.tooltip:AddLine(mMT:TC(DURABILITY, "title"))
		DT.tooltip:AddDoubleLine(DURABILITY, format("%d%%", totalDurability), 1, 1, 1, E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1))

		if totalRepairCost > 0 then DT.tooltip:AddDoubleLine(mMT:TC(REPAIR_COST), mMT:TC(E:FormatMoney(totalRepairCost, "BLIZZARD", false))) end

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then
		Dock:Click(self)
		_G.ToggleCharacter("PaperDollFrame")
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.character.style][E.db.mMT.dock.character.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.character.custom_color and MEDIA.color.dock.character or nil
		config.text.enable = E.db.mMT.dock.character.text
		config.text.a = E.db.mMT.dock.character.text

		Dock:CreateDockIcon(self, config, event)
	end

	if E.Retail or E.Mists then
		avg, avgEquipped, avgPvp = GetAverageItemLevel()
	end

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

	if E.db.mMT.dock.character.text then
		local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		local hex = E:RGBToHex(r, g, b)
		self.mMT_Dock.TextA:SetFormattedText("%s%d%%|r", hex, totalDurability)
	end

	if totalDurability <= E.db.mMT.dock.character.percThreshold then
		E:Flash(self.mMT_Dock.Icon, 0.5, true)
	else
		E:StopFlash(self.mMT_Dock.Icon, 1)
	end
end

DT:RegisterDatatext(config.name, config.category, { "PLAYER_AVG_ITEM_LEVEL_UPDATE", "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
