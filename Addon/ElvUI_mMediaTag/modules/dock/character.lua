local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

-- code is partially based on ElvUI's Durability and Itemlevel datatext

local icons = MEDIA.icons.dock
local avg, avgEquipped, avgPvp = 0, 0, 0
local format = format
local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemDurability = GetInventoryItemDurability
local RequestTimePlayed = RequestTimePlayed
local SecondsToTime = SecondsToTime
local pairs = pairs
local time = time
local wipe = wipe

local DURABILITY = DURABILITY
local REPAIR_COST = REPAIR_COST
local totalDurability = 0
local invDurability = {}
local totalRepairCost
local totalTimePlayed
local levelTimePlayed
local lastPlayedRequest
local PLAYED_REFRESH_INTERVAL = 1800

local function GetPlayedCharacters()
	DB.playedCharacters = DB.playedCharacters or {}
	return DB.playedCharacters
end

local function GetPlayedRequestTimes()
	DB.lastPlayedRequest = DB.lastPlayedRequest or {}
	return DB.lastPlayedRequest
end

local function UpdatePlayedCache(totalTime, levelTime)
	local guid = mMT:GetCurrentPlayerGUID()
	if not guid then return end

	local info = GetPlayedCharacters()[guid] or {}
	info.name = E.mynameRealm
	info.total = totalTime or 0
	info.level = levelTime or 0
	GetPlayedCharacters()[guid] = info

	totalTimePlayed = info.total
	levelTimePlayed = info.level
end

local function LoadCurrentPlayedCache()
	local guid = mMT:GetCurrentPlayerGUID()
	if not guid then return end

	local info = GetPlayedCharacters()[guid]
	if not info then
		totalTimePlayed = nil
		levelTimePlayed = nil
		return
	end

	info.name = E.mynameRealm
	totalTimePlayed = info.total
	levelTimePlayed = info.level
end

local function RequestPlayedTime(force)
	local guid = mMT:GetCurrentPlayerGUID()
	if not guid then return end

	lastPlayedRequest = GetPlayedRequestTimes()

	local now = time()
	local lastRequest = lastPlayedRequest[guid] or 0
	if not force and (now - lastRequest) < PLAYED_REFRESH_INTERVAL then return end

	lastPlayedRequest[guid] = now
	RequestTimePlayed()
end

local function GetAccountPlayedTotal()
	local total = 0

	for _, info in pairs(GetPlayedCharacters()) do
		total = total + (info.total or 0)
	end

	return total
end

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
	RequestPlayedTime(false)
	LoadCurrentPlayedCache()

	if E.db.mMediaTag.dock.tooltip then
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine(CHARACTER_BUTTON, mMT:GetRGB("title"))
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

		if totalTimePlayed or levelTimePlayed then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(TIME_PLAYED_MSG, mMT:GetRGB("title"))
			DT.tooltip:AddDoubleLine(L["Account total"], SecondsToTime(GetAccountPlayedTotal()), mMT:GetRGB("text", "text"))

			if totalTimePlayed then
				DT.tooltip:AddDoubleLine(L["Total play time"], SecondsToTime(totalTimePlayed), mMT:GetRGB("text", "text"))
			end

			if levelTimePlayed then
				DT.tooltip:AddDoubleLine(L["Time played this level"], SecondsToTime(levelTimePlayed), mMT:GetRGB("text", "text"))
			end
		end

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMediaTag.dock.tooltip then DT.tooltip:Hide() end
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
		config.icon.texture = icons[E.db.mMediaTag.dock.character.style][E.db.mMediaTag.dock.character.icon] or MEDIA.fallback
		config.icon.color = E.db.mMediaTag.dock.character.custom_color and MEDIA.color.dock.character or nil
		config.text.enable = E.db.mMediaTag.dock.character.text
		config.text.a = E.db.mMediaTag.dock.character.text

		Dock:CreateDockIcon(self, config, event)
	end

	if event == "PLAYER_ENTERING_WORLD" then
		LoadCurrentPlayedCache()
		RequestPlayedTime(true)
	elseif event == "TIME_PLAYED_MSG" then
		local totalTime, levelTime = ...
		UpdatePlayedCache(totalTime, levelTime)

		if E.db.mMediaTag.dock.tooltip and DT.tooltip and DT.tooltip:IsShown() then
			OnEnter(self)
		end

		return
	end

	LoadCurrentPlayedCache()

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

	if E.db.mMediaTag.dock.character.text then
		local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		local hex = E:RGBToHex(r, g, b)
		self.mMT_Dock.TextA:SetFormattedText("%s%d%%|r", hex, totalDurability)
	end

	if totalDurability <= E.db.mMediaTag.dock.character.percThreshold then
		E:Flash(self.mMT_Dock.Icon, 0.5, true)
	else
		E:StopFlash(self.mMT_Dock.Icon, 1)
	end
end

DT:RegisterDatatext(config.name, config.category, { "PLAYER_ENTERING_WORLD", "TIME_PLAYED_MSG", "PLAYER_AVG_ITEM_LEVEL_UPDATE", "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
