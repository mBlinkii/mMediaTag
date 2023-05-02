local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local _G = _G
local GetInventoryItemDurability = GetInventoryItemDurability
local ToggleCharacter = ToggleCharacter
local InCombatLockdown = InCombatLockdown
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString

--Variables
local mText = format("Dock %s", L["Durability"])
local mTextName = "mDurability"
local DURABILITY = DURABILITY
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
	local Color = E.db.mMT.dockdatatext.durability.color
	self.mSettings = {
		Name = mTextName,
		IconTexture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.durability.icon],
		Notifications = false,
		Text = true,
		Center = false,
		Spezial = true,
		OnlyText = E.db.mMT.dockdatatext.durability.onlytext,
		IconColor = E.db.mMT.dockdatatext.durability.iconcolor,
		CustomColor = E.db.mMT.dockdatatext.durability.customcolor,
	}

	mMT:DockInitialisation(self)

	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc, repairCost = (currentDura / maxDura) * 100
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

	local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	local hex = E:RGBToHex(r, g, b)

	if self.mSettings.OnlyText and totalDurability then
		self.text:SetFormattedText("%s%d%%|r", hex, totalDurability)
	else
		if self.text ~= "" then
			self.text:SetText("")
		end

		if Color == "default" then
			self.mIcon.TextA:SetFormattedText("%s%d%%|r", hex, totalDurability)
		elseif Color == "custom" then
			self.mIcon.TextA:SetFormattedText(
				strjoin(
					"",
					E:RGBToHex(
						E.db.mMT.dockdatatext.fontcolor.r,
						E.db.mMT.dockdatatext.fontcolor.g,
						E.db.mMT.dockdatatext.fontcolor.b
					),
					"%s|r"
				),
				format("%d%%|r", totalDurability)
			)
		else
			self.mIcon.TextA:SetFormattedText(mMT:mClassColorString(), format("%d%%|r", totalDurability))
		end
	end


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
		ToggleCharacter("PaperDollFrame")
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
