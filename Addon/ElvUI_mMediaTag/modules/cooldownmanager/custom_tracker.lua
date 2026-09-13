local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:GetModule("CooldownManager")

-- Cache WoW Globals
local _G = _G
local ipairs = ipairs
local wipe = wipe
local ceil = math.ceil
local floor = math.floor
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UnitRace = UnitRace
local GameTooltip = GameTooltip
local GetInventoryItemID = GetInventoryItemID
local GetInventoryItemCooldown = GetInventoryItemCooldown
local GetInventoryItemTexture = GetInventoryItemTexture
local C_Timer_After = C_Timer.After
local C_Item_GetItemCount = C_Item.GetItemCount
local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local C_Item_GetItemSpell = C_Item.GetItemSpell
local C_Container_GetItemCooldown = C_Container.GetItemCooldown
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture
local C_Spell_GetSpellCooldown = C_Spell.GetSpellCooldown
local C_Spell_GetSpellCooldownDuration = C_Spell.GetSpellCooldownDuration
local C_Spell_GetSpellName = C_Spell.GetSpellName
local C_Item_GetItemNameByID = C_Item.GetItemNameByID
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local IsSpellKnown = C_SpellBook and C_SpellBook.IsSpellKnown
local IsSpellKnownOrOverridesKnown = C_SpellBook and C_SpellBook.IsSpellKnownOrOverridesKnown

local MAX_ICONS = 24
local BELT_SLOT = 6
local TRINKET_SLOTS = { 13, 14 }

module.EQUIPMENT_SLOTS = {
	{ id = 1, label = _G.HEADSLOT },
	{ id = 2, label = _G.NECKSLOT },
	{ id = 3, label = _G.SHOULDERSLOT },
	{ id = 5, label = _G.CHESTSLOT },
	{ id = 6, label = _G.WAISTSLOT },
	{ id = 7, label = _G.LEGSSLOT },
	{ id = 8, label = _G.FEETSLOT },
	{ id = 9, label = _G.WRISTSLOT },
	{ id = 10, label = _G.HANDSSLOT },
	{ id = 11, label = _G.FINGER0SLOT .. " 1" },
	{ id = 12, label = _G.FINGER1SLOT .. " 2" },
	{ id = 13, label = _G.TRINKET0SLOT .. " 1" },
	{ id = 14, label = _G.TRINKET1SLOT .. " 2" },
	{ id = 15, label = _G.BACKSLOT },
	{ id = 16, label = _G.MAINHANDSLOT },
	{ id = 17, label = _G.SECONDARYHANDSLOT },
}

local HEALTHSTONES = { 5512, 224464 }
local WEYRNSTONES = { 205146 }

local HEALING_POTIONS = {
	241305, -- Silvermoon Health Potion
	241307, -- Refreshing Serum
	241299, -- Amani Extract
	258138, -- Potent Healing Potion
	244835, -- Invigorating Healing Potion
}

local COMBAT_POTIONS = {
	241309, -- Light's Potential
	241297, -- Potion of Zealotry
	241289, -- Potion of Recklessness
	241293, -- Draught of Rampant Abandon
	241303, -- Void-Shrouded Tincture
}

-- Several entries per race cover the class specific variants, filtered by IsSpellKnown
local RACIAL_SPELLS = {
	Orc = { 33697, 33702, 20572 },
	Troll = { 26297 },
	Dwarf = { 20594 },
	NightElf = { 58984 },
	Human = { 59752 },
	Gnome = { 20589 },
	Draenei = { 59542, 59543, 59544, 59545, 59547, 59548, 121093 },
	Worgen = { 68992 },
	Tauren = { 20549 },
	Scourge = { 7744 },
	BloodElf = { 28730, 50613, 80483, 129597, 155145, 202719, 232633 },
	Goblin = { 69041 },
	Pandaren = { 107079 },
	VoidElf = { 256948 },
	LightforgedDraenei = { 255647 },
	HighmountainTauren = { 255654 },
	Nightborne = { 260364 },
	MagharOrc = { 274738 },
	DarkIronDwarf = { 265221 },
	ZandalariTroll = { 291944 },
	KulTiran = { 287712 },
	Vulpera = { 312411 },
	Mechagnome = { 312924 },
	EarthenDwarf = { 424283 },
}

local icons = {}
local active = {}
local racials = {}

local function CreateIcon(parent, index)
	local frame = CreateFrame("Button", "mMediaTag_CDM_CustomIcon" .. index, parent, "BackdropTemplate")
	frame:SetTemplate("Default")
	frame:SetFrameStrata("LOW")
	frame:SetFrameLevel(6)

	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetInside(frame)
	frame.Icon = frame.icon

	local cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	cooldown:SetAllPoints(frame.icon)
	cooldown:SetDrawEdge(false)
	cooldown:SetHideCountdownNumbers(false)
	E:RegisterCooldown(cooldown, "cdmanager")
	frame.Cooldown = cooldown

	-- Nothing fires on natural expiry, so the desaturation has to be dropped here
	cooldown:HookScript("OnCooldownDone", function()
		frame.icon:SetDesaturated(false)
	end)

	frame.countText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.countText:SetPoint("BOTTOMRIGHT", 0, 0)

	frame:SetScript("OnEnter", function(self)
		local vdb = module:ViewerDB("custom")
		if not self.trackType or not vdb or vdb.tooltips == false then return end

		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self.trackType == "spell" and self.spellID then
			GameTooltip:SetSpellByID(self.spellID)
		elseif self.trackType == "slot" and self.slot then
			GameTooltip:SetInventoryItem("player", self.slot)
		elseif self.trackType == "item" and self.itemID then
			GameTooltip:SetItemByID(self.itemID)
		end
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", _G.GameTooltip_Hide)

	frame:Hide()
	return frame
end

local function DetectRacials()
	wipe(racials)

	local _, race = UnitRace("player")
	local candidates = RACIAL_SPELLS[race]
	if not candidates then return end

	for _, spellID in ipairs(candidates) do
		if IsSpellKnown and IsSpellKnown(spellID) then racials[#racials + 1] = spellID end
	end
end

local function UpdateSpell(frame, spellID)
	frame.trackType = "spell"
	frame.spellID = spellID
	frame.itemID, frame.slot = nil, nil
	frame.icon:SetTexture(C_Spell_GetSpellTexture(spellID))
	frame.countText:SetText("")

	local duration = C_Spell_GetSpellCooldownDuration(spellID)
	if duration then
		frame.Cooldown:SetCooldownFromDurationObject(duration)
	else
		frame.Cooldown:Clear()
	end

	-- isActive is the only readable cooldown state, the GCD has to be excluded or everything greys out on every cast
	local info = C_Spell_GetSpellCooldown(spellID)
	frame.icon:SetDesaturated((info and info.isActive and not info.isOnGCD) or false)
end

local function UpdateSlot(frame, slot)
	if not GetInventoryItemID("player", slot) then
		frame:Hide()
		return false
	end

	frame.trackType = "slot"
	frame.slot = slot
	frame.spellID, frame.itemID = nil, nil
	frame.icon:SetTexture(GetInventoryItemTexture("player", slot))
	frame.countText:SetText("")

	local start, duration, enable = GetInventoryItemCooldown("player", slot)
	if enable and enable ~= 0 then
		frame.Cooldown:SetCooldown(start, duration)
	else
		frame.Cooldown:Clear()
	end

	frame.icon:SetDesaturated(enable ~= 0 and duration > 0)
	frame:Show()
	return true
end

local function UpdateItem(frame, itemID)
	local count = C_Item_GetItemCount(itemID, false, true)
	if count == 0 then
		frame:Hide()
		return false
	end

	frame.trackType = "item"
	frame.itemID = itemID
	frame.spellID, frame.slot = nil, nil
	frame.icon:SetTexture(C_Item_GetItemIconByID(itemID))
	frame.countText:SetText(count > 1 and count or "")

	local start, duration, enable = C_Container_GetItemCooldown(itemID)
	if enable and enable ~= 0 then
		frame.Cooldown:SetCooldown(start, duration)
	else
		frame.Cooldown:Clear()
	end

	frame.icon:SetDesaturated(enable ~= 0 and duration > 0)
	frame:Show()
	return true
end

local function SpellUsable(spellID, knownOnly)
	if not knownOnly then return C_Spell_GetSpellName(spellID) ~= nil end

	if IsSpellKnownOrOverridesKnown and IsSpellKnownOrOverridesKnown(spellID) then return true end
	return (IsSpellKnown and IsSpellKnown(spellID)) or false
end

-- Own entries carry only a type and an ID, everything else is resolved from the game
function module:CustomEntryInfo(entry)
	if not entry or not entry.id then return nil, nil end

	if entry.type == "spell" then
		return C_Spell_GetSpellName(entry.id), C_Spell_GetSpellTexture(entry.id)
	elseif entry.type == "item" then
		return C_Item_GetItemNameByID(entry.id), C_Item_GetItemIconByID(entry.id)
	end

	for _, slot in ipairs(module.EQUIPMENT_SLOTS) do
		if slot.id == entry.id then return slot.label, GetInventoryItemTexture("player", entry.id) end
	end

	return nil, nil
end

function module:ValidCustomEntry(entryType, id)
	if entryType == "spell" then return C_Spell_GetSpellName(id) ~= nil end
	if entryType == "item" then return C_Item_GetItemInfoInstant(id) ~= nil end

	for _, slot in ipairs(module.EQUIPMENT_SLOTS) do
		if slot.id == id then return true end
	end

	return false
end

-- Passive and proc trinkets expose no use effect
local function IsOnUseTrinket(slot)
	local itemID = GetInventoryItemID("player", slot)
	return (itemID and C_Item_GetItemSpell(itemID) ~= nil) or false
end

local function UpdateIcons()
	local vdb = module:ViewerDB("custom")
	if not vdb or not vdb.enable then return end

	wipe(active)
	local index = 0

	local function Take()
		index = index + 1
		return index <= MAX_ICONS and icons[index] or nil
	end

	local function AddItems(list)
		for _, itemID in ipairs(list) do
			if C_Item_GetItemCount(itemID) > 0 then
				local frame = Take()
				if not frame then return end
				if UpdateItem(frame, itemID) then active[#active + 1] = frame end
			end
		end
	end

	for _, entry in ipairs(vdb.entries or {}) do
		if entry.enable ~= false and entry.id then
			local frame = Take()
			if not frame then break end

			if entry.type == "spell" then
				if SpellUsable(entry.id, vdb.known_only ~= false) then
					UpdateSpell(frame, entry.id)
					frame:Show()
					active[#active + 1] = frame
				else
					frame:Hide()
					index = index - 1
				end
			elseif entry.type == "item" then
				if UpdateItem(frame, entry.id) then
					active[#active + 1] = frame
				else
					index = index - 1
				end
			elseif UpdateSlot(frame, entry.id) then
				active[#active + 1] = frame
			else
				index = index - 1
			end
		end
	end

	if vdb.racials then
		for _, spellID in ipairs(racials) do
			local frame = Take()
			if not frame then break end
			UpdateSpell(frame, spellID)
			frame:Show()
			active[#active + 1] = frame
		end
	end

	if vdb.healthstone then AddItems(HEALTHSTONES) end
	if vdb.potions then AddItems(HEALING_POTIONS) end
	if vdb.combat_potions then AddItems(COMBAT_POTIONS) end
	if vdb.weyrnstone then AddItems(WEYRNSTONES) end

	-- enable is 1 only when the belt actually carries a tinker
	if vdb.belt_tinker then
		local _, _, enable = GetInventoryItemCooldown("player", BELT_SLOT)
		if enable == 1 then
			local frame = Take()
			if frame and UpdateSlot(frame, BELT_SLOT) then active[#active + 1] = frame end
		end
	end

	local mode = vdb.trinkets or "both"
	if mode ~= "none" then
		local slots = (mode == "both" and TRINKET_SLOTS) or (mode == "slot1" and { 13 }) or { 14 }
		for _, slot in ipairs(slots) do
			if not vdb.on_use_only or IsOnUseTrinket(slot) then
				local frame = Take()
				if not frame then break end
				if UpdateSlot(frame, slot) then active[#active + 1] = frame end
			end
		end
	end

	for i = index + 1, MAX_ICONS do
		if icons[i] then icons[i]:Hide() end
	end

	module:LayoutCustomTracker()
end

function module:LayoutCustomTracker()
	local container = module.containers.custom
	local vdb = module:ViewerDB("custom")
	if not container or not vdb then return end

	local count = #active
	module.emptyViewers.custom = count == 0
	module:UpdateContainerShown("custom")

	if count == 0 then return end

	local db = module:GetDB()
	local width = E:Scale(vdb.width or 36)
	local height = (vdb.keep_ratio and width) or E:Scale(vdb.height or 36)
	local spacing = E:Scale(vdb.spacing or 4)
	local perRow = vdb.per_row or 6
	local growth = vdb.growth or "CENTER"

	for _, icon in ipairs(active) do
		icon:SetSize(width, height)
		icon.icon:SetTexCoord(E:GetTexCoords())
		module:ApplyCooldownText(icon.Cooldown, vdb.cooldown_text)
		module:ApplySwipeOverride(icon.Cooldown, db)
		module:StyleText(icon.countText, vdb.count_text)
	end

	local vertical = growth == "UP" or growth == "DOWN"
	local cols = vertical and 1 or (count < perRow and count or perRow)
	local rows = vertical and count or ceil(count / perRow)
	local totalWidth = cols * width + (cols - 1) * spacing
	local totalHeight = rows * height + (rows - 1) * spacing
	module:SetContainerSize(container, totalWidth, totalHeight)

	local anchor = (growth == "LEFT" and "RIGHT") or (growth == "UP" and "BOTTOMLEFT") or "TOPLEFT"
	local xDir = growth == "LEFT" and -1 or 1
	local yDir = growth == "UP" and 1 or -1

	for i, icon in ipairs(active) do
		local row = vertical and (i - 1) or floor((i - 1) / perRow)
		local col = vertical and 0 or ((i - 1) % perRow)

		icon:ClearAllPoints()
		icon:SetPoint(anchor, container, anchor, xDir * col * (width + spacing), yDir * row * (height + spacing))
	end

	local mover = _G[module.VIEWERS.custom.mover .. "_Mover"]
	if not mover then return end

	container:ClearAllPoints()
	if growth == "CENTER" then
		if not InCombatLockdown() then mover:SetSize(totalWidth, totalHeight) end
		container:SetAllPoints(mover)
	else
		if not InCombatLockdown() then mover:SetSize(width, height) end
		container:SetPoint(anchor, mover, anchor)
	end
end

local updatePending = false
local function ScheduleUpdate()
	if updatePending then return end
	updatePending = true
	C_Timer_After(0.1, function()
		updatePending = false
		UpdateIcons()
	end)
end

local function OnEvent(event, arg1)
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		if arg1 == 13 or arg1 == 14 or arg1 == BELT_SLOT then ScheduleUpdate() end
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
		DetectRacials()
		ScheduleUpdate()
	else
		ScheduleUpdate()
	end
end

local function CreateContainer()
	local vdb = module:ViewerDB("custom")
	local width = (vdb and vdb.width) or 36
	local height = (vdb and vdb.keep_ratio and width) or (vdb and vdb.height) or 36

	local frame = CreateFrame("Frame", module.VIEWERS.custom.mover .. "_Holder", E.UIParent)
	frame:SetSize(width, height)
	frame:SetPoint("CENTER", E.UIParent, "CENTER", 0, -200)
	frame:SetFrameStrata("LOW")
	frame:SetFrameLevel(5)

	E:CreateMover(frame, module.VIEWERS.custom.mover .. "_Mover", "mMT " .. module.VIEWERS.custom.label, nil, nil, function() end, "ALL,MMEDIATAG", function()
		return module:IsDisabled()
	end, "mMT,cooldownmanager,custom", true)

	module.containers.custom = frame
end

function module:InitCustomTracker()
	local vdb = module:ViewerDB("custom")
	if not vdb or not vdb.enable or module.containers.custom then return end

	CreateContainer()

	for i = 1, MAX_ICONS do
		icons[i] = CreateIcon(module.containers.custom, i)
	end

	DetectRacials()

	module:RegisterEvent("BAG_UPDATE_COOLDOWN", OnEvent)
	module:RegisterEvent("BAG_UPDATE", OnEvent)
	module:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", OnEvent)
	module:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent)
	module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", OnEvent)
	module:RegisterEvent("PLAYER_TALENT_UPDATE", OnEvent)

	UpdateIcons()
end

function module:RefreshCustomTracker()
	if module.containers.custom then UpdateIcons() end
end

-- AceEvent keeps one handler per event, so SPELL_UPDATE_COOLDOWN is dispatched from core.lua
function module:ScheduleCustomUpdate()
	if module.containers.custom then ScheduleUpdate() end
end
