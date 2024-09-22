local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local pairs = pairs
local format = format
local wipe = wipe
local select = select
local pi = math.pi

--WoW API / Variables
local _G = _G
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString

--Variables
local Config = {
	name = "mMT_Dock_Character",
	localizedName = mMT.DockString .. " " .. CHARACTER_BUTTON,
	category = "mMT-" .. mMT.DockString,
	text = {
		enable = true,
		center = false,
		a = true, -- first label
		b = false, -- second label
	},
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

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

local function StartFlash(self, color)
	mMT:SetTextureColor(self.mMT_Dock.Icon, color)
	self.mMT_Dock.Icon.flash = true
	E:Flash(self.mMT_Dock.Icon, 0.5, true)
end

local function StopFlash(self)
	self.mMT_Dock.Icon.flash = false
	E:StopFlash(self.mMT_Dock.Icon)
	mMT:InitializeDockIcon(self, Config)
end

local function colorize(num)
	if num >= 0 then
		return 0.1, 1, 0.1
	else
		return E:ColorGradient(-(pi / num), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	end
end

local function mCheckDurability()
	if totalDurability <= 35 then
		local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		return { r = r, g = g, b = b, a = 1 }
	end
end

local function OnEnter(self)
	local nhc, hc, myth, mythp, other, title, tip = mMT:mColorDatatext()

	mMT:Dock_OnEnter(self, Config)

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:ClearLines()
		if E.Retail then
			local avg, avgEquipped, avgPvp = GetAverageItemLevel()
			DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), 1, 1, 1, 0.1, 1, 0.1)
			DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), 1, 1, 1, colorize(avgEquipped - avg))
			DT.tooltip:AddDoubleLine(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT, format("%0.2f", avgPvp), 1, 1, 1, colorize(avgPvp - avg))
			DT.tooltip:AddLine(" ")
		end

		DT.tooltip:AddLine(format("%s%s|r", title, L["Durability"]))
		for slot, durability in pairs(invDurability) do
			DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:4:60:4:60|t %s", GetInventoryItemTexture("player", slot), GetInventoryItemLink("player", slot)), format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1))
		end

		if totalRepairCost > 0 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
		end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(format("%s |CFFFFFFFF%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), L["Click:"]), format("%s%s|r", tip, L["Open Character Frame"]))

		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.text.enable = (E.db.mMT.dockdatatext.character.option ~= "none")
		Config.text.a = (E.db.mMT.dockdatatext.character.option ~= "none")
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.character.icon]
		Config.icon.color = E.db.mMT.dockdatatext.character.customcolor and E.db.mMT.dockdatatext.character.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

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

	if Config.text.enable then
		local r, g, b, hex = nil, nil, nil, nil
		local text = nil

		if E.db.mMT.dockdatatext.character.option == "durability" then
			text = format("%d%%", totalDurability)

			if E.db.mMT.dockdatatext.character.color then
				r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
				hex = E:RGBToHex(r, g, b)
			end
		elseif E.db.mMT.dockdatatext.character.option == "ilvl" then
			text = mMT:round(select(2, GetAverageItemLevel()) or 0)
			if E.Retail  and E.db.mMT.dockdatatext.character.color then
				r, g, b = GetItemLevelColor()
				hex = E:RGBToHex(r, g, b)
			end
		end

		if hex then
			self.mMT_Dock.TextA:SetText(hex .. text .. "|r")
		else
			self.mMT_Dock.TextA:SetText(text)
		end
	end

	local colorWarning = mCheckDurability()
	if colorWarning then
		StartFlash(self, colorWarning)
	elseif self.mMT_Dock.Icon.flash then
		StopFlash(self)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)

	local colorWarning = mCheckDurability()
	if colorWarning then
		StartFlash(self, colorWarning)
	end
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		_G.ToggleCharacter("PaperDollFrame")
	end
end

DT:RegisterDatatext(Config.name, Config.category, { "UPDATE_INVENTORY_DURABILITY" }, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
