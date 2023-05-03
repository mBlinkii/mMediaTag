local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local pairs = pairs
local format = format
local wipe = wipe
local select = select
local strjoin = strjoin
local pi = math.pi

--WoW API / Variables
local _G = _G
local GetInventoryItemDurability = GetInventoryItemDurability
local ToggleCharacter = ToggleCharacter
local InCombatLockdown = InCombatLockdown
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString

--Variables
local mText = format("Dock %s", CHARACTER_BUTTON)
local mTextName = "mCharacter"
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
	end
end

local function OnEnter(self)
	local nhc, hc, myth, mythp, other, titel, tip = mMT:mColorDatatext()
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameCharacter")

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:ClearLines()
		if E.Retail then
			local avg, avgEquipped, avgPvp = GetAverageItemLevel()
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

		if totalRepairCost > 0 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
		end

		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	local Option = E.db.mMT.dockdatatext.character.option
	local Color = E.db.mMT.dockdatatext.character.color

	self.mSettings = {
		Name = mTextName,
		IconTexture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.character.icon],
		Notifications = false,
		Text = true,
		Spezial = false,
		IconColor = E.db.mMT.dockdatatext.character.iconcolor,
		CustomColor = E.db.mMT.dockdatatext.character.customcolor,
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

	if Option == "durability" then
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
			hex = E:RGBToHex(r, g, b)

			TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
			self.mIcon.TextA:SetFormattedText("%s%d|r", hex, avgEquipped)
		else
			self.mIcon.TextA:SetFormattedText(mMT:mClassColorString(), avgEquipped)
		end
	else
		self.mIcon.TextA:SetText("")
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
		mMT:mOnClick(self, "CheckFrameCharacter")
		if mCheckDurability() then
			mMT:DockCustomColor(self, mCheckDurability())
		end
		_G.ToggleCharacter("PaperDollFrame")
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
