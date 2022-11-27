local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local pairs = pairs
local format = format
local wipe = wipe
local select = select
local strjoin = strjoin
local pi = math.pi

--WoW API / Variables
local _G = _G
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString
local GetInventoryItemDurability = GetInventoryItemDurability

--Variables
local mText = format("Dock %s", CHARACTER_BUTTON)
local mTextName = "mCharacter"
local DURABILITY = DURABILITY
local REPAIR_COST = REPAIR_COST
local tooltipString = "%d%%"
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

local function colorize(num)
	if num >= 0 then
		return 0.1, 1, 0.1
	else
		return E:ColorGradient(-(pi / num), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	end
end

local function mCheckDurability()
	if totalDurability <= E.global.datatexts.settings.Durability.percThreshold then
		r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		return r, g, b, 1
	end
end

local function mDockCheckFrame()
	return (CharacterFrame and CharacterFrame:IsShown())
end

function mMT:CheckFrameCharacter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
	if mCheckDurability() then
		mMT:DockCustomColor(self, mCheckDurability())
		--self.mIcon:SetVertexColor(mCheckDurability())
	end
end

local function OnEnter(self)
	local nhc, hc, myth, mythp, other, titel, tip = mMT:mColorDatatext()
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameCharacter")

	if E.db[mPlugin].mDock.tip.enable then
		if E.Retail then
			local avg, avgEquipped, avgPvp = GetAverageItemLevel()
			DT.tooltip:AddLine(format("%s%s|r", titel, STAT_AVERAGE_ITEM_LEVEL))
			DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), 1, 1, 1, 0.1, 1, 0.1)
			DT.tooltip:AddDoubleLine(
				GMSURVEYRATING3,
				format("%0.2f", avgEquipped),
				1,
				1,
				1,
				colorize(avgEquipped - avg)
			)
			DT.tooltip:AddDoubleLine(
				LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT,
				format("%0.2f", avgPvp),
				1,
				1,
				1,
				colorize(avgPvp - avg)
			)
			DT.tooltip:AddLine(" ")
		end

		DT.tooltip:AddLine(format("%s%s|r", titel, L["Durability"]))
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
		invDurability = wipe(invDurability)
		if totalRepairCost > 0 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
		end

		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	local Option = E.db[mPlugin].mDock.character.option
	local Color = E.db[mPlugin].mDock.character.color
	local IconText = nil
	local TextColor = mMT:mClassColorString()

	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.character.path,
		Notifications = false,
		Text = true,
		Spezial = false,
		IconColor = E.db[mPlugin].mDock.character.iconcolor,
		CustomColor = E.db[mPlugin].mDock.character.customcolor,
	}

	mMT:DockInitialisation(self)

	totalDurability = 100
	totalRepairCost = 0

	invDurability = wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc, repairCost = (currentDura/maxDura)*100
			invDurability[index] = perc

			if perc < totalDurability then
				totalDurability = perc
			end

			if E.Retail and E.ScanTooltip.GetTooltipData then
				E.ScanTooltip:SetInventoryItem('player', index)
				E.ScanTooltip:Show()

				local data = E.ScanTooltip:GetTooltipData()
				repairCost = data and data.repairCost
			else
				repairCost = select(3, E.ScanTooltip:SetInventoryItem('player', index))
			end

			totalRepairCost = totalRepairCost + (repairCost or 0)
		end
	end

	if Option == "durability" then
		if Color == "default" then
			r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
			TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
		end
		IconText = mMT:round(totalDurability or 0) .. "%"
	elseif Option == "ilvl" then
		local avg, avgEquipped = GetAverageItemLevel()
		if Color == "default" then
			r, g, b = E:ColorGradient(
				mMT:round((avgEquipped / 260) * 100 or 0) * 0.01,
				0,
				1,
				0.11,
				0,
				0.4,
				0.8,
				0.63,
				0.18,
				0.78
			)
			TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
		end
		IconText = mMT:round(avgEquipped)
	else
		IconText = ""
	end

	if mCheckDurability() then
		E:Flash(self, 0.5, true)
		mMT:DockCustomColor(self, mCheckDurability())
	else
		E:StopFlash(self)
		mMT:DockNormalColor(self)
	end

	self.mIcon.TextA:SetFormattedText(TextColor, IconText)
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
		mMT:mOnClick(self, "CheckFrameCharacter")
		if mCheckDurability() then
			mMT:DockCustomColor(self, mCheckDurability())
		end
		ToggleCharacter("PaperDollFrame")
	end
end

DT:RegisterDatatext(
	mTextName,
	"mDock",
	{ "UPDATE_INVENTORY_DURABILITY", "PLAYER_AVG_ITEM_LEVEL_UPDATE" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	nil
)
