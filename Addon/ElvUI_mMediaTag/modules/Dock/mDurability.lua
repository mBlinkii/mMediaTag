local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local _G = _G
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString

--Variables
local mText = format("Dock %s", L["Durability"])
local mTextName = "mDurability"
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

local function mCheckDurability()
	if totalDurability <= 35 then
		local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		return r, g, b, 1
	end
end

local function mDockCheckFrame()
	return (CharacterFrame and CharacterFrame:IsShown())
end

function mMT:CheckFrameDurability(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:ClearLines()

		for slot, durability in pairs(invDurability) do
			DT.tooltip:AddDoubleLine(
				format(
					"|T%s:14:14:0:0:64:64:4:60:4:60|t %s",
					GetInventoryItemTexture("player", slot),
					GetInventoryItemLink("player", slot)
				),
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

		DT.tooltip:Show()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameDurability")
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		text = {
			onlytext = E.db.mMT.dockdatatext.durability.onlytext,
			spezial = true,
			textA = E.db.mMT.dockdatatext.bag.text ~= 5 and E.db.mMT.dockdatatext.durability.text or false,
			textB = false,
		},
		icon = {
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.durability.icon],
			color = E.db.mMT.dockdatatext.durability.iconcolor,
			customcolor = E.db.mMT.dockdatatext.durability.customcolor,
		},
	}

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

	local r, g, b = 1, 1, 1
	local hex = nil
	local text = nil

	if E.db.mMT.dockdatatext.durability.color then
		r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		hex = E:RGBToHex(r, g, b)
	end

	if self.mSettings.OnlyText and totalDurability then
		if E.db.mMT.dockdatatext.durability.color then
			self.text:SetFormattedText("%s%d%%|r", hex, totalDurability)
		else
			self.text:SetFormattedText("%s%d%%|r", E.media.hexvaluecolor, totalDurability)
		end
	else
		if self.text ~= "" then
			self.text:SetText("")
		end

		text = format("%d%%|r", totalDurability)
	end

	mMT:DockInitialisation(self, event, text, nil, hex)

	if mCheckDurability() then
		E:Flash(self, 0.5, true)
		mMT:DockCustomColor(self, mCheckDurability())
	else
		E:StopFlash(self)
		mMT:DockNormalColor(self)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)

	if mCheckDurability() then
		mMT:DockCustomColor(self, mCheckDurability())
	end
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:mOnClick(self, "CheckFrameDurability")
		if mCheckDurability() then
			mMT:DockCustomColor(self, mCheckDurability())
		end
		_G.ToggleCharacter("PaperDollFrame")
	end
end

DT:RegisterDatatext(
	mTextName,
	"mDock",
	{ "UPDATE_INVENTORY_DURABILITY" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	nil
)
