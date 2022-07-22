local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local DT = E:GetModule("DataTexts");
local addon, ns = ...

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", L["Durability"])
local mTextName = "mDurability"
local DURABILITY = DURABILITY
local REPAIR_COST = REPAIR_COST
local tooltipString = '%d%%'
local totalDurability = 0
local invDurability = {}
local totalRepairCost
local r, g, b = nil, nil, nil
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
}

local function mCheckDurability()
	if totalDurability <= E.global.datatexts.settings.Durability.percThreshold then
		r, g, b = E:ColorGradient(totalDurability * .01, 1, .1, .1, 1, 1, .1, .1, 1, .1)
		return r, g, b, 1
	end
end

local function mDockCheckFrame()
	return ( CharacterFrame and CharacterFrame:IsShown() )
end

function mMT:CheckFrameDurability(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db[mPlugin].mDock.tip.enable then
		for slot, durability in pairs(invDurability) do
			DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t %s', GetInventoryItemTexture('player', slot), GetInventoryItemLink('player', slot)), format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, .1, .1, 1, 1, .1, .1, 1, .1))
		end
		
		if totalRepairCost > 0 then
			DT.tooltip:AddLine(' ')
			DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), .6, .8, 1, 1, 1, 1)
		end
		
		DT.tooltip:Show()
	end

	self.mIcon.isClicked = mDockCheckFrame()
    mMT:mOnEnter(self, "CheckFrameDurability")
end

local function OnEvent(self, event, ...)
	local Color = E.db[mPlugin].mDock.durability.color
	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.durability.path,
		Notifications = false,
		Text = true,
		Center = false,
		Spezial = true,
		OnlyText = E.db[mPlugin].mDock.durability.onlytext,
	}

	mMT:DockInitialisation(self)

	totalDurability = 100
	totalRepairCost = 0
	local TextColor = mMT:mClassColorString()
	
	wipe(invDurability)
	
	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc = (currentDura/maxDura)*100
			invDurability[index] = perc
			
			if perc < totalDurability then
				totalDurability = perc
			end
			
			totalRepairCost = totalRepairCost + select(3, E.ScanTooltip:SetInventoryItem('player', index))
		end
	end

    if Color == "default" then
        r, g, b = E:ColorGradient(totalDurability * .01, 1, .1, .1, 1, 1, .1, .1, 1, .1)
        TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
	elseif Color == "custom" then
		r, g, b = E.db[mPlugin].mDock.fontcolor.r, E.db[mPlugin].mDock.fontcolor.g, E.db[mPlugin].mDock.fontcolor.b
		TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
	end
	
	if mCheckDurability() then
		E:Flash(self, 0.5, true)
		mMT:DockCustomColor(self, mCheckDurability())
	else
		E:StopFlash(self)
		mMT:DockNormalColor(self)
	end
	
	if self.mSettings.OnlyText and totalDurability then
		self.text:SetFormattedText(TextColor, mMT:round(totalDurability or 0) .. "%")
	else
		if self.text ~= "" then
			self.text:SetText("")
		end
		self.mIcon.TextA:SetFormattedText(TextColor, mMT:round(totalDurability or 0) .. "%")
	end
end

local function OnLeave(self)
	if E.db[mPlugin].mDock.tip.enable then
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

DT:RegisterDatatext(mTextName, "mDock", {'UPDATE_INVENTORY_DURABILITY'}, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)