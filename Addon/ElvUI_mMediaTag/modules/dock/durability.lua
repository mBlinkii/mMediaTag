local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

-- code is partially based on ElvUI's Durability and Itemlevel datatext

local icons = MEDIA.icons.dock
local avg, avgEquipped, avgPvp = 0, 0, 0
local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemDurability = GetInventoryItemDurability
local GetMountInfoByID = C_MountJournal.GetMountInfoByID
local SummonByID = C_MountJournal.SummonByID

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
	name = "mMT_Dock_Durability",
	localizedName = "|CFF01EEFFDock|r" .. " " .. DURABILITY,
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
		DT.tooltip:AddLine(DURABILITY, mMT:GetRGB("title"))
		DT.tooltip:AddLine(" ")

		local r, g, b = mMT:GetRGB()
		DT.tooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL, mMT:GetRGB("title"))
		DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), mMT:GetRGB("text", "M"))
		DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), r, g, b, E:ColorizeItemLevel(avgEquipped - avg))
		DT.tooltip:AddDoubleLine(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT, format("%0.2f", avgPvp), r, g, b, E:ColorizeItemLevel(avgPvp - avg))
		DT.tooltip:AddLine(" ")

		DT.tooltip:AddLine(DURABILITY, mMT:GetRGB("title"))
		DT.tooltip:AddDoubleLine(DURABILITY, format("%d%%", totalDurability), r, g, b, E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1))

		if totalRepairCost > 0 then DT.tooltip:AddDoubleLine(REPAIR_COST, E:FormatMoney(totalRepairCost, "BLIZZARD", false), mMT:GetRGB("text", "text")) end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(MEDIA.leftClick .. " " .. L["left click to open Character Frame"], mMT:GetRGB("tip"))

		local mountID = tonumber(E.db.mMT.dock.durability.mount)
		if mountID then
			local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
			if name and isUsable then DT.tooltip:AddDoubleLine(MEDIA.rightClick .. " " .. L["right click to use:"], format("%s %s", name, E:TextureString(icon, ":14:14")), mMT:GetRGB("tip", "M")) end
		end

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	if not E:AlertCombat() then
		if btn == "LeftButton" then
			_G.ToggleCharacter("PaperDollFrame")
		elseif btn == "RightButton" then
			local mountID = tonumber(E.db.mMT.dock.durability.mount)
			if mountID then
				local isUsable = select(5, GetMountInfoByID(mountID))
				if isUsable then SummonByID(mountID) end
			end
		end
	end
end

local function OnEvent(self, event, ...)
	local textStyle = E.db.mMT.dock.durability.text
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.durability.style][E.db.mMT.dock.durability.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.durability.custom_color and MEDIA.color.dock.durability or nil
		config.text.enable = textStyle ~= "none"
		config.text.a = textStyle == "both" or textStyle == "durability" or textStyle == "ilevel"
		config.text.b = textStyle == "both"

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

	if textStyle ~= "noon" then
		local hex = "|cFFFFFFFF"

		if textStyle == "durability" or textStyle == "both" then
			local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
			hex = E:RGBToHex(r, g, b)
		end

		if textStyle == "durability" then
			self.mMT_Dock.TextA:SetText(hex .. format("%d%%", totalDurability) .. "|r")
		elseif textStyle == "ilevel" then
			self.mMT_Dock.TextA:SetText(format("%d", avg))
		elseif textStyle == "both" then
			self.mMT_Dock.TextA:SetText(hex .. format("%d%%", totalDurability) .. "|r")
			self.mMT_Dock.TextB:SetText(format("%d", avg))
		end
	end

	if totalDurability <= E.db.mMT.dock.durability.percThreshold then
		E:Flash(self.mMT_Dock.Icon, 0.5, true)
	else
		E:StopFlash(self.mMT_Dock.Icon, 1)
	end
end

DT:RegisterDatatext(
	config.name,
	config.category,
	{ "PLAYER_AVG_ITEM_LEVEL_UPDATE", "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	config.localizedName,
	nil,
	nil
)
