local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("BuffReminder", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local ipairs = ipairs
local next = next
local pairs = pairs
local select = select
local strfind = strfind
local strlower = strlower
local type = type
local unpack = unpack
local wipe = wipe
local ceil = math.ceil
local max = math.max
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetInstanceInfo = GetInstanceInfo
local GetInventoryItemID = GetInventoryItemID
local GetInventoryItemTexture = GetInventoryItemTexture
local GetNumGroupMembers = GetNumGroupMembers
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local RegisterStateDriver = RegisterStateDriver
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsUnit = UnitIsUnit
local UnitIsVisible = UnitIsVisible
local GetAuraDataBySpellName = C_UnitAuras.GetAuraDataBySpellName
local GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local GetTemporaryEnchantmentInfo = C_PaperDollInfo.GetTemporaryEnchantmentInfo
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local GetItemInfo = C_Item.GetItemInfo
local GetItemInfoInstant = C_Item.GetItemInfoInstant
local GetItemNameByID = C_Item.GetItemNameByID
local GetItemSpell = C_Item.GetItemSpell
local GetItemTooltip = C_TooltipInfo.GetItemByID
local GetItemReagentQualityInfo = C_TradeSkillUI.GetItemReagentQualityInfo
local GetItemCraftedQualityInfo = C_TradeSkillUI.GetItemCraftedQualityInfo
local RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID
local GetSpellName = C_Spell.GetSpellName
local GetSpellTexture = C_Spell.GetSpellTexture
local IsSpellKnown = C_SpellBook and C_SpellBook.IsSpellKnown or IsPlayerSpell
local GetSpecialization = C_SpecializationInfo.GetSpecialization or GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo or GetSpecializationInfo
local ShouldAurasBeSecret = C_Secrets and C_Secrets.ShouldAurasBeSecret
local C_Timer_After = C_Timer.After
local C_Timer_NewTicker = C_Timer.NewTicker
local C_Timer_NewTimer = C_Timer.NewTimer

local LSM = E.Libs.LSM
local LCG = LibStub("LibCustomGlow-1.0", true)

local QUALITY_SCALE = 0.45

local function CreateQuality(button)
	local quality = button:CreateTexture(nil, "OVERLAY", nil, 7)
	quality:Point("TOPLEFT", button, "TOPLEFT", 1, -1)
	quality:Hide()
	return quality
end

-- the crafting quality badge Blizzard shows on bag items, scaled to the icon size
local function SetQuality(button, itemID, size)
	local info = itemID and (GetItemReagentQualityInfo(itemID) or GetItemCraftedQualityInfo(itemID))
	if not info then
		button.quality:Hide()
		return
	end

	button.quality:SetAtlas(info.iconInventory, true)
	local width, height = button.quality:GetSize()
	local scale = height > 0 and size * QUALITY_SCALE / height or 1
	button.quality:Size(width * scale, height * scale)
	button.quality:Show()
end

local MAX_ICONS = 16
local TICK = 5
local FADE_TIME = 0.3
local GLOW_KEY = "mMT_BuffReminder"
local GLOW_LEVEL = 8
local glowColor = { 1, 1, 1, 1 }
local FLYOUT_PADDING = 3
local FLYOUT_SPACING = 2
local CURRENT_EXPANSION = LE_EXPANSION_LEVEL_CURRENT
local FOOD_ICON = 136000
local FLASK_ICON = "Interface\\Icons\\INV_Potion_93"
local WELL_FED = 19705
local CLASS_CONSUMABLE = 0
local SUBCLASS_FLASK = 3
local SUBCLASS_FOOD = 5
local SUBCLASS_ENHANCEMENT = 6
-- midnight weapon oils are listed as other consumables
local SUBCLASS_OTHER = 8
local CLASS_WEAPON = 2
local SLOT_MAINHAND = 16
local SLOT_OFFHAND = 17

local RAID_BUFFS = {
	{ class = "MAGE", spell = 1459 }, -- Arcane Intellect
	{ class = "PRIEST", spell = 21562 }, -- Power Word: Fortitude
	{ class = "WARRIOR", spell = 6673 }, -- Battle Shout
	{ class = "DRUID", spell = 1126 }, -- Mark of the Wild
	{ class = "SHAMAN", spell = 462854 }, -- Skyfury
	{ class = "EVOKER", spell = 364342 }, -- Blessing of the Bronze
}

local RUNE_ITEMS = {
	[259085] = true, -- Void-Touched Augment Rune
	[243191] = true, -- Ethereal Augment Rune
	[224572] = true, -- Crystallized Augment Rune
}

-- one entry per group, the last cast or else the first known spell is the one to click
local CLASS_BUFFS = {
	ROGUE = {
		{ 2823, 315584, 8679, 381664 }, -- Deadly, Instant, Wound, Amplifying Poison
		{ 3408, 5761, 381637 }, -- Crippling, Numbing, Atrophic Poison
	},
	PALADIN = {
		{ 465, 183435, 317920, 32223 }, -- Devotion, Retribution, Concentration, Crusader Aura
	},
	SHAMAN = {
		{ 192106, 52127, 974, 383648 }, -- Lightning Shield, Water Shield, Earth Shield, Earth Shield (Elemental Orbit)
	},
}

local PET_SPECS = {
	[253] = 883, -- Beast Mastery, Call Pet 1
	[255] = 883, -- Survival, Call Pet 1
	[252] = 46584, -- Unholy, Raise Dead
	[265] = 688, -- Affliction, Summon Imp
	[266] = 688, -- Demonology, Summon Imp
	[267] = 688, -- Destruction, Summon Imp
}
local GRIMOIRE_OF_SACRIFICE = 196099

-- class spells that imbue the main hand, the button casts them instead of using an oil
local WEAPON_SPELLS = {
	PALADIN = { 433568 }, -- Rite of Sanctification
}

local function WeaponSpell(slot)
	if slot ~= SLOT_MAINHAND then return end
	for _, spellID in ipairs(WEAPON_SPELLS[E.myclass] or {}) do
		if IsSpellKnown(spellID) then return spellID end
	end
end

local missing = {}
local groupClasses = {}
local bags = { flask = {}, rune = {}, food = {}, oil = {} }
local itemSpells = {}
local buffFood = {}
local updateQueued
-- the bags are only scanned again after they changed
local bagsDirty = true
local flyout
local Update

-- the last used consumables and class buffs per character
local function Saved()
	local saved = DB.buff_reminder[E.mynameRealm]
	if not saved then
		saved = { class = {} }
		DB.buff_reminder[E.mynameRealm] = saved
	end
	return saved
end

local function RuneIcon()
	return select(5, GetItemInfoInstant(next(RUNE_ITEMS)))
end

local function OnEnter(button)
	GameTooltip:SetOwner(button, "ANCHOR_BOTTOM")
	GameTooltip:AddLine(button.title or "")
	if button.info then GameTooltip:AddLine(button.info, 1, 1, 1) end
	if button.use then GameTooltip:AddLine(L["Click: %s"]:format(button.use), 0.2, 1, 0.2) end
	if button.kind then GameTooltip:AddLine(L["Right click: choose the item"], 0.2, 1, 0.2) end
	GameTooltip:Show()
end

local function HideFlyout()
	if not (flyout and flyout:IsShown()) then return end
	flyout:Hide()
	flyout.owner = nil
	module:UnregisterEvent("GLOBAL_MOUSE_DOWN")
end

local function FlyoutOnEnter(item)
	GameTooltip:SetOwner(item, "ANCHOR_RIGHT")
	GameTooltip:SetItemByID(item.itemID)
	GameTooltip:Show()
end

-- the choice is remembered per character and used by the button from now on
local function FlyoutOnClick(item)
	Saved()[flyout.kind] = item.itemID
	HideFlyout()
	Update()
end

local function CreateFlyoutItem()
	local item = CreateFrame("Button", nil, flyout, "BackdropTemplate")
	item:SetTemplate()
	item:StyleButton()

	item.icon = item:CreateTexture(nil, "ARTWORK")
	item.icon:SetInside()
	item.icon:SetTexCoord(unpack(E.TexCoords))

	item.quality = CreateQuality(item)

	item.count = item:CreateFontString(nil, "OVERLAY")
	item.count:Point("BOTTOMRIGHT", item, "BOTTOMRIGHT", -1, 2)

	item:SetScript("OnEnter", FlyoutOnEnter)
	item:SetScript("OnLeave", _G.GameTooltip_Hide)
	item:SetScript("OnClick", FlyoutOnClick)

	return item
end

local PickItem

-- opens away from the screen edge, across the direction of the bar
local function LayoutFlyout(owner)
	local db, list = module.db, bags[owner.kind]
	local size = db.size
	local x, y = owner:GetCenter()
	local centerX, centerY = E.UIParent:GetCenter()
	local point, relative, dx, dy
	if db.direction == "HORIZONTAL" then
		if y < centerY then
			point, relative, dx, dy = "BOTTOM", "TOP", 0, 1
		else
			point, relative, dx, dy = "TOP", "BOTTOM", 0, -1
		end
	else
		if x < centerX then
			point, relative, dx, dy = "LEFT", "RIGHT", 1, 0
		else
			point, relative, dx, dy = "RIGHT", "LEFT", -1, 0
		end
	end

	local length = FLYOUT_PADDING * 2 + #list * (size + FLYOUT_SPACING) - FLYOUT_SPACING
	local across = size + FLYOUT_PADDING * 2
	flyout:Size(dx ~= 0 and length or across, dy ~= 0 and length or across)
	flyout:ClearAllPoints()
	flyout:Point(point, owner, relative, dx * FLYOUT_SPACING, dy * FLYOUT_SPACING)

	local font = LSM:Fetch("font", db.text.font)
	local selected = PickItem(owner.kind)
	for i, entry in ipairs(list) do
		local item = flyout.items[i] or CreateFlyoutItem()
		flyout.items[i] = item

		local offset = FLYOUT_PADDING + (i - 1) * (size + FLYOUT_SPACING)
		item:ClearAllPoints()
		item:Point(point, flyout, point, dx * offset, dy * offset)
		item:Size(size)
		item.itemID = entry.itemID
		item.icon:SetTexture(entry.icon)
		SetQuality(item, entry.itemID, size)
		E:SetFont(item.count, font, db.text.size, db.text.fontFlag)
		item.count:SetText(entry.count > 1 and entry.count or "")
		if entry == selected then
			item:SetBackdropBorderColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b)
		else
			item:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		item:Show()
	end

	for i = #list + 1, #flyout.items do
		flyout.items[i]:Hide()
	end
end

local function ToggleFlyout(owner)
	if InCombatLockdown() or not owner.kind then return end
	if flyout and flyout:IsShown() and flyout.owner == owner then return HideFlyout() end
	if #bags[owner.kind] == 0 then return end

	if not flyout then
		-- below the holder, so it hides with the buttons in combat
		flyout = CreateFrame("Frame", nil, module.frame.holder, "BackdropTemplate")
		flyout:SetTemplate("Transparent")
		flyout:SetFrameStrata("DIALOG")
		flyout.items = {}
	end

	flyout.owner = owner
	flyout.kind = owner.kind
	LayoutFlyout(owner)
	flyout:Show()
	module:RegisterEvent("GLOBAL_MOUSE_DOWN")
end

-- clicks anywhere else close the flyout
function module:GLOBAL_MOUSE_DOWN()
	if flyout and not (flyout:IsMouseOver() or (flyout.owner and flyout.owner:IsMouseOver())) then HideFlyout() end
end

-- secure buttons, so attributes, size and anchors only change out of combat
local function CreateIcon(frame)
	local button = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate, BackdropTemplate")
	button:RegisterForClicks("AnyUp", "AnyDown")
	button:SetTemplate()
	button:StyleButton()

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetInside()
	button.icon:SetTexCoord(unpack(E.TexCoords))

	button.quality = CreateQuality(button)

	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:Point("BOTTOM", button, "BOTTOM", 0, 2)

	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave", _G.GameTooltip_Hide)
	-- "flyout" is a Blizzard action type, an unknown type makes the secure template call this field on right click
	button.mmtChooseItem = ToggleFlyout
	button:Hide()

	return button
end

local function CreateFade(frame, from, to)
	local group = frame:CreateAnimationGroup()
	group:SetToFinalAlpha(true)

	local alpha = group:CreateAnimation("Alpha")
	alpha:SetFromAlpha(from)
	alpha:SetToAlpha(to)
	alpha:SetDuration(FADE_TIME)
	alpha:SetSmoothing(to > from and "OUT" or "IN")

	return group
end

-- an animation group does not start on a frame shown in the same tick, so it starts on the next one
local function PlayFadeIn()
	local frame = module.frame
	if frame:IsVisible() and not frame.fadeOut:IsPlaying() then frame.fadeIn:Play() end
	if not frame.fadeIn:IsPlaying() and not frame.fadeOut:IsPlaying() then frame:SetAlpha(1) end
end

local function FadeIn()
	if not module.db.animation then return end
	module.frame:SetAlpha(0)
	C_Timer_After(0, PlayFadeIn)
end

local function CreateReminderFrame()
	-- the buttons are secure, so only a state driver may hide them in combat
	local holder = CreateFrame("Frame", nil, E.UIParent)
	holder:SetAllPoints(E.UIParent)
	RegisterStateDriver(holder, "visibility", "[combat] hide; show")

	local frame = CreateFrame("Frame", "mMediaTag_BuffReminder", holder)
	frame:Size(200, 32)
	frame:Point("TOP", E.UIParent, "TOP", 0, -220)
	frame:Hide()

	frame.icons = {}
	for i = 1, MAX_ICONS do
		frame.icons[i] = CreateIcon(frame)
	end

	E:CreateMover(frame, "mMediaTag_BuffReminder_Mover", "mMT " .. L["Buff Reminder"], nil, nil, nil, "ALL,MMEDIATAG", function()
		return E.db.mMediaTag.buff_reminder.enable
	end, "mMT,group,group_tools,buff_reminder")

	frame.fadeIn = CreateFade(frame, 0, 1)
	frame.fadeOut = CreateFade(frame, 1, 0)
	-- OnFinished also fires on Stop(), requested tells the two apart
	frame.fadeOut:SetScript("OnFinished", function(_, requested)
		if requested or InCombatLockdown() then return end
		frame:Hide()
		frame:SetAlpha(1)
	end)

	-- leaving combat shows the holder again, the reminder fades back in
	holder:HookScript("OnShow", function()
		if frame:IsShown() and frame:GetAlpha() > 0 then FadeIn() end
	end)

	frame.holder = holder
	module.frame = frame
end

local function ShowFrame()
	local frame = module.frame
	local appearing = not frame:IsShown() or frame.fadeOut:IsPlaying()

	frame.fadeOut:Stop()
	frame:SetAlpha(1)
	frame:Show()
	if appearing then FadeIn() end
end

local function HideFrame()
	local frame = module.frame
	if not frame:IsShown() or frame.fadeOut:IsPlaying() then return end

	frame.fadeIn:Stop()
	if module.isEnabled and module.db.animation and frame:IsVisible() and frame:GetAlpha() > 0 then
		frame.fadeOut:Play()
	else
		frame:Hide()
		frame:SetAlpha(1)
	end
end

-- after entering a dungeon or raid everything below the minimum duration glows until the first pull
local function SetGlow(button, expiring)
	if not LCG then return end
	local glow = module.db.glow
	if expiring and (glow.enable or (module.entryActive and module.db.entry.enable)) then
		local r, g, b = mMT:HexToRGB(glow.color)
		glowColor[1], glowColor[2], glowColor[3] = r, g, b
		LCG.PixelGlow_Start(button, glowColor, glow.lines, 0.25, nil, glow.thickness, 0, 0, nil, GLOW_KEY, GLOW_LEVEL)
		button.glowing = true
	elseif button.glowing then
		LCG.PixelGlow_Stop(button, GLOW_KEY)
		button.glowing = nil
	end
end

-- without an item the right click still opens the flyout to choose one
local function ItemAction(entry, kind, slot)
	return { type = entry and "item" or nil, item = entry and entry.itemID, kind = kind, slot = slot }
end

local function SpellAction(spellID)
	return spellID and { type = "spell", spell = spellID }
end

local function Add(title, texture, info, text, action, expiring, qualityItem)
	missing[#missing + 1] = { title = title, texture = texture, info = info, text = text, action = action, expiring = expiring, qualityItem = qualityItem }
end

-- minutes, the minimum duration replaces the threshold while the entry check runs
local function Threshold()
	local db = module.db
	if module.entryActive and db.entry.enable then return max(db.threshold, db.entry.duration) end
	return db.threshold
end

-- remaining minutes below the threshold count as missing
local function Expiring(expirationTime)
	if not expirationTime or expirationTime == 0 then return false end
	return expirationTime - GetTime() < Threshold() * 60
end

local function MinutesLeft(expirationTime)
	if not expirationTime or expirationTime == 0 then return nil end
	return ceil((expirationTime - GetTime()) / 60) .. "m"
end

local function GroupUnits()
	local units, raid = {}, IsInRaid()
	local count = raid and GetNumGroupMembers() or GetNumGroupMembers() - 1
	for i = 1, count do
		units[#units + 1] = (raid and "raid" or "party") .. i
	end
	if not raid then units[#units + 1] = "player" end
	return units
end

local function CollectGroupClasses(units)
	wipe(groupClasses)
	groupClasses[E.myclass] = true
	for _, unit in ipairs(units) do
		if UnitExists(unit) and UnitIsConnected(unit) then
			local _, class = UnitClass(unit)
			if class and E:NotSecretValue(class) then groupClasses[class] = true end
		end
	end
end

local function CheckRaidBuffs()
	local units = GroupUnits()
	CollectGroupClasses(units)

	for _, buff in ipairs(RAID_BUFFS) do
		local name = GetSpellName(buff.spell)
		local own = buff.class == E.myclass and IsSpellKnown(buff.spell)
		if name and groupClasses[buff.class] and (own or not module.db.raid_buffs.own) then
			local aura = GetAuraDataBySpellName("player", name, "HELPFUL")
			local count = 0
			-- your own buff is also checked on the group members you can see
			if own and module.db.raid_buffs.group then
				for _, unit in ipairs(units) do
					if UnitExists(unit) and not UnitIsUnit(unit, "player") and UnitIsConnected(unit) and UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
						if not GetAuraDataBySpellName(unit, name, "HELPFUL") then count = count + 1 end
					end
				end
			end

			if not aura or Expiring(aura.expirationTime) or count > 0 then
				local info = count > 0 and L["Missing on %d group members"]:format(count) or nil
				Add(name, GetSpellTexture(buff.spell), info, count > 0 and count or (aura and MinutesLeft(aura.expirationTime)), own and SpellAction(buff.spell), aura and Expiring(aura.expirationTime))
			end
		end
	end
end

local function AddItem(list, itemID, icon, spellID, count, buff)
	for _, entry in ipairs(list) do
		if entry.itemID == itemID then
			entry.count = entry.count + count
			return
		end
	end
	list[#list + 1] = { itemID = itemID, icon = icon, spellID = spellID, count = count, buff = buff }
end

-- buff food mentions the well fed buff in its tooltip, plain food and drinks do not
-- only a match is kept, a miss is checked again since tooltip data and the buff name can arrive later
local function IsBuffFood(itemID)
	if buffFood[itemID] then return true end
	local data = GetItemTooltip(itemID)
	if not (data and data.lines) then return false end

	-- the current buff can be a variant like hearty well fed, so both names are tried
	local names = { GetSpellName(WELL_FED), module.wellFedName }
	for _, line in ipairs(data.lines) do
		local text = line.leftText and E:NotSecretValue(line.leftText) and strlower(line.leftText)
		for _, name in pairs(names) do
			if text and strfind(text, strlower(name), 1, true) then
				buffFood[itemID] = true
				return true
			end
		end
	end
	return false
end

-- the expansion of an item is only known once its data is loaded
local function IsCurrentExpansion(itemID)
	local expansionID = select(15, GetItemInfo(itemID))
	if not expansionID then
		module.itemsPending = true
		RequestLoadItemDataByID(itemID)
	end
	return expansionID == CURRENT_EXPANSION
end

-- flasks and runes only count when one is in your bags, their aura comes from the item spell
local function ScanBags()
	for _, list in pairs(bags) do
		wipe(list)
	end
	wipe(itemSpells)

	for bag = 0, _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS or _G.NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemInfo(bag, slot)
			local itemID = item and item.itemID
			if itemID then
				local _, _, _, _, _, classID, subClassID = GetItemInfoInstant(itemID)
				local kind = RUNE_ITEMS[itemID] and "rune"
					or classID == CLASS_CONSUMABLE
						and (subClassID == SUBCLASS_FLASK and "flask" or subClassID == SUBCLASS_FOOD and "food" or (subClassID == SUBCLASS_ENHANCEMENT or subClassID == SUBCLASS_OTHER) and "oil")
				-- food, flasks and oils only from the current expansion
				if kind and kind ~= "rune" and not IsCurrentExpansion(itemID) then kind = nil end
				if kind then
					local _, spellID = GetItemSpell(itemID)
					if spellID then
						AddItem(bags[kind], itemID, item.iconFileID, spellID, item.stackCount or 1, kind ~= "food" or IsBuffFood(itemID))
						itemSpells[spellID] = { kind = kind, itemID = itemID }
					end
				end
			end
		end
	end
end

-- the chosen or last used item of that kind first, else the biggest stack, which also keeps feasts back
-- food the tooltip check does not know as buff food is only used once it was chosen in the flyout
function PickItem(kind)
	local list, preferred = bags[kind], Saved()[kind]
	local best
	for _, entry in ipairs(list) do
		if entry.itemID == preferred then return entry end
		if entry.buff and (not best or entry.count > best.count) then best = entry end
	end
	return best
end

local function CheckItemBuff(kind, title, fallback)
	local list = bags[kind]
	if #list == 0 then return end

	local aura
	for _, entry in ipairs(list) do
		aura = GetPlayerAuraBySpellID(entry.spellID)
		if aura then break end
	end

	if not aura or Expiring(aura.expirationTime) then
		local entry = PickItem(kind)
		Add(title, entry and entry.icon or list[1].icon or fallback, nil, aura and MinutesLeft(aura.expirationTime), ItemAction(entry, kind), aura ~= nil, entry and entry.itemID)
	end
end

local function FindFood()
	for i = 1, 255 do
		local aura = GetAuraDataByIndex("player", i, "HELPFUL")
		if not aura then return end
		if aura.icon == FOOD_ICON then return aura end
	end
end

local function CheckFood()
	local aura = FindFood()
	-- a new buff name can turn more food into buff food
	if aura and E:NotSecretValue(aura.name) and aura.name ~= module.wellFedName then
		module.wellFedName = aura.name
		bagsDirty = true
	end
	if not aura or Expiring(aura.expirationTime) then
		local entry = PickItem("food")
		Add(L["Food"], entry and entry.icon or FOOD_ICON, nil, aura and MinutesLeft(aura.expirationTime), ItemAction(entry, "food"), aura ~= nil, entry and entry.itemID)
	end
end

local function CheckWeaponSlot(slot)
	local itemID = GetInventoryItemID("player", slot)
	if not itemID then return end
	local _, _, _, _, _, classID = GetItemInfoInstant(itemID)
	if classID ~= CLASS_WEAPON then return end

	local enchant = GetTemporaryEnchantmentInfo(slot)
	local expiring = enchant and enchant.hasExpirationTime and enchant.remainingTimeMs < Threshold() * 60000
	if not enchant or expiring then
		local text = enchant and enchant.hasExpirationTime and ceil(enchant.remainingTimeMs / 60000) .. "m" or nil
		local spellID = WeaponSpell(slot)
		local action = spellID and SpellAction(spellID) or ItemAction(PickItem("oil"), "oil", slot)
		Add(slot == SLOT_MAINHAND and L["Main Hand Enchant"] or L["Off Hand Enchant"], GetInventoryItemTexture("player", slot), nil, text, action, expiring)
	end
end

local function CheckClassBuffs()
	local saved = Saved().class
	for index, group in ipairs(CLASS_BUFFS[E.myclass] or {}) do
		local known, active, expiring
		for _, spellID in ipairs(group) do
			if IsSpellKnown(spellID) then
				known = known or spellID
				local aura = GetPlayerAuraBySpellID(spellID)
				if aura then
					if Expiring(aura.expirationTime) then
						expiring = aura
					else
						active = true
					end
				end
			end
		end
		if known and not active then
			local spellID = saved[index] and IsSpellKnown(saved[index]) and saved[index] or known
			Add(GetSpellName(spellID), GetSpellTexture(spellID), nil, expiring and MinutesLeft(expiring.expirationTime), SpellAction(spellID), expiring ~= nil)
		end
	end

	local specIndex = GetSpecialization()
	local specID = specIndex and GetSpecializationInfo(specIndex)
	local petSpell = specID and PET_SPECS[specID]
	if petSpell and not (UnitExists("pet") and not UnitIsDead("pet")) and not GetPlayerAuraBySpellID(GRIMOIRE_OF_SACRIFICE) then
		-- warlocks pick their own demon, the imp only gives the icon
		Add(L["Pet"], GetSpellTexture(petSpell), nil, nil, E.myclass ~= "WARLOCK" and IsSpellKnown(petSpell) and SpellAction(petSpell))
	end
end

-- "world" outside of instances, else the instance type
local function Zone()
	local inInstance, instanceType = IsInInstance()
	return inInstance and instanceType or "world"
end

local function ShouldCheck()
	if module.demo then return true end
	if UnitIsDeadOrGhost("player") then return false end
	-- auras turn secret during restricted content, the reminder only works when they are readable
	if ShouldAurasBeSecret and ShouldAurasBeSecret() then return false end

	local zone = Zone()
	if zone == "world" then return module.db.world end
	return module.db.instances[zone]
end

local function CollectDemo()
	for _, buff in ipairs(RAID_BUFFS) do
		Add(GetSpellName(buff.spell), GetSpellTexture(buff.spell))
	end
	Add(L["Flask"], FLASK_ICON)
	Add(L["Food"], FOOD_ICON, nil, "3m", nil, true)
	Add(L["Augment Rune"], RuneIcon())
	Add(L["Main Hand Enchant"], GetInventoryItemTexture("player", SLOT_MAINHAND))
end

local function Collect()
	wipe(missing)
	if module.demo then return CollectDemo() end

	local db = module.db
	if bagsDirty then
		bagsDirty = false
		ScanBags()
	end
	-- each check can be limited to some zones
	local zone, zones = Zone(), db.zones
	if db.raid_buffs.enable and zones.raid_buffs[zone] then CheckRaidBuffs() end
	if db.flask and zones.flask[zone] then CheckItemBuff("flask", L["Flask"], FLASK_ICON) end
	if db.rune and zones.rune[zone] then CheckItemBuff("rune", L["Augment Rune"], RuneIcon()) end
	if db.food and zones.food[zone] then CheckFood() end
	if db.weapon and zones.weapon[zone] then
		CheckWeaponSlot(SLOT_MAINHAND)
		CheckWeaponSlot(SLOT_OFFHAND)
	end
	if db.class_buffs and zones.class_buffs[zone] then CheckClassBuffs() end
end

local function ApplyLayout(count)
	local frame, db = module.frame, module.db
	local font = LSM:Fetch("font", db.text.font)
	local horizontal = db.direction == "HORIZONTAL"
	local step = db.size + db.spacing
	local length = count * step - db.spacing

	if horizontal then
		frame:Size(length, db.size)
	else
		frame:Size(db.size, length)
	end

	for i, button in ipairs(frame.icons) do
		button:ClearAllPoints()
		if horizontal then
			button:Point("LEFT", frame, "LEFT", (i - 1) * step, 0)
		else
			button:Point("TOP", frame, "TOP", 0, -(i - 1) * step)
		end
		button:Size(db.size)
		E:SetFont(button.text, font, db.text.size, db.text.fontFlag)
		button.text:SetTextColor(mMT:HexToRGB(db.text.color))
	end
end

local function SetAction(button, action)
	local isItem = action and action.type == "item"
	button:SetAttribute("type", action and action.type or nil)
	button:SetAttribute("unit", action and action.type == "spell" and "player" or nil)
	button:SetAttribute("item", isItem and "item:" .. action.item or nil)
	button:SetAttribute("target-slot", isItem and action.slot or nil)
	button:SetAttribute("spell", action and action.spell or nil)
	-- runes have no choice, food, flasks and oils open the flyout on right click
	button.kind = action and action.kind ~= "rune" and action.kind or nil
	button:SetAttribute("type2", button.kind and "mmtChooseItem" or nil)

	if isItem then
		button.use = GetItemNameByID(action.item)
	else
		button.use = action and action.spell and GetSpellName(action.spell)
	end
end

local function StopHideTimer()
	if module.hideTimer then
		module.hideTimer:Cancel()
		module.hideTimer = nil
	end
end

-- the reminder stays hidden after the hide time until the next instance or group
local function Expire()
	module.hideTimer = nil
	module.expired = true
	Update()
end

local function ShowAgain()
	StopHideTimer()
	module.expired = nil
end

function Update()
	updateQueued = nil
	local frame = module.frame
	if not frame then return end

	-- the state driver hides the buttons in combat, leaving combat updates them again
	if InCombatLockdown() then return end

	if not (module.isEnabled and ShouldCheck()) or (module.expired and not module.demo) then
		HideFlyout()
		HideFrame()
		return
	end

	Collect()
	local count = #missing
	if count == 0 then
		StopHideTimer()
		HideFlyout()
		HideFrame()
		return
	end

	count = count > MAX_ICONS and MAX_ICONS or count
	ApplyLayout(count)

	for i, button in ipairs(frame.icons) do
		local entry = missing[i]
		if entry and i <= count then
			button.title = entry.title
			button.info = entry.info
			button.icon:SetTexture(entry.texture or FLASK_ICON)
			SetQuality(button, entry.qualityItem, module.db.size)
			button.text:SetText(module.db.text.enable and entry.text or "")
			SetAction(button, entry.action)
			SetGlow(button, entry.expiring)
			button:Show()
		else
			SetAction(button)
			SetGlow(button)
			button:Hide()
		end
	end

	ShowFrame()

	if not (module.hideTimer or module.demo) and module.db.hide_after > 0 then module.hideTimer = C_Timer_NewTimer(module.db.hide_after, Expire) end

	if flyout and flyout:IsShown() then
		local owner = flyout.owner
		if owner:IsShown() and owner.kind == flyout.kind and #bags[owner.kind] > 0 then
			LayoutFlyout(owner)
		else
			HideFlyout()
		end
	end
end

local function QueueUpdate(delay)
	if updateQueued then return end
	updateQueued = true
	C_Timer_After(type(delay) == "number" and delay or 0.2, Update)
end

local function RescanBags()
	bagsDirty = true
	QueueUpdate()
end

-- auras of group members change all the time in a raid, they are checked at most once per second
function module:UNIT_AURA(_, unit)
	if unit == "player" then
		QueueUpdate()
	elseif module.db.raid_buffs.group and (unit:find("^party") or unit:find("^raid")) then
		QueueUpdate(1)
	end
end

function module:GET_ITEM_INFO_RECEIVED()
	if not module.itemsPending then return end
	module.itemsPending = nil
	RescanBags()
end

function module:UNIT_PET(_, unit)
	if unit == "player" then QueueUpdate() end
end

function module:UNIT_INVENTORY_CHANGED(_, unit)
	if unit == "player" then QueueUpdate() end
end

-- remembers the consumable or class buff you used last, the button offers it next time
function module:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellID)
	if unit ~= "player" or not E:NotSecretValue(spellID) then return end

	local item = itemSpells[spellID]
	if item then
		Saved()[item.kind] = item.itemID
		return
	end

	for index, group in ipairs(CLASS_BUFFS[E.myclass] or {}) do
		for _, groupSpell in ipairs(group) do
			if groupSpell == spellID then Saved().class[index] = spellID end
		end
	end
end

local function StopTicker()
	if module.ticker then
		module.ticker:Cancel()
		module.ticker = nil
	end
end

-- everything that triggers a check, none of it runs in combat
local CHECK_EVENTS = {
	PLAYER_ENTERING_WORLD = "PLAYER_ENTERING_WORLD",
	ZONE_CHANGED_NEW_AREA = "ZONE_CHANGED_NEW_AREA",
	GET_ITEM_INFO_RECEIVED = "GET_ITEM_INFO_RECEIVED",
	PLAYER_ALIVE = QueueUpdate,
	PLAYER_UNGHOST = QueueUpdate,
	GROUP_ROSTER_UPDATE = QueueUpdate,
	UNIT_AURA = "UNIT_AURA",
	UNIT_PET = "UNIT_PET",
	UNIT_INVENTORY_CHANGED = "UNIT_INVENTORY_CHANGED",
	UNIT_SPELLCAST_SUCCEEDED = "UNIT_SPELLCAST_SUCCEEDED",
	WEAPON_ENCHANT_CHANGED = QueueUpdate,
	BAG_UPDATE_DELAYED = RescanBags,
	SPELLS_CHANGED = QueueUpdate,
	PLAYER_SPECIALIZATION_CHANGED = QueueUpdate,
}

local function StartChecks()
	if module.ticker then return end
	for event, handler in pairs(CHECK_EVENTS) do
		module:RegisterEvent(event, handler)
	end
	-- expiring buffs and weapon enchants cross the threshold without an event
	module.ticker = C_Timer_NewTicker(TICK, QueueUpdate)
end

local function StopChecks()
	for event in pairs(CHECK_EVENTS) do
		module:UnregisterEvent(event)
	end
	StopTicker()
end

local ENTRY_TYPES = { party = true, raid = true }
-- delves count as scenarios
local SHOW_TYPES = { party = true, raid = true, scenario = true }

-- a new dungeon or raid starts the entry check, leaving it or another instance of the same id does not
-- a new dungeon, raid, delve or scenario shows the reminder again for the hide time
local function UpdateEntry()
	local _, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
	if not (SHOW_TYPES[instanceType] and E:NotSecretValue(instanceID)) then
		module.entryInstance = nil
		module.entryActive = nil
		return
	end

	if instanceID ~= module.entryInstance then
		module.entryInstance = instanceID
		module.entryActive = ENTRY_TYPES[instanceType]
		ShowAgain()
	end
end

function module:PLAYER_ENTERING_WORLD()
	UpdateEntry()
	RescanBags()
end

function module:ZONE_CHANGED_NEW_AREA()
	UpdateEntry()
	QueueUpdate()
end

-- joining a group shows the reminder again for the hide time
function module:GROUP_JOINED()
	ShowAgain()
	QueueUpdate()
end

-- the first pull ends the entry check
function module:PLAYER_REGEN_DISABLED()
	HideFlyout()
	StopChecks()
	module.entryActive = nil
end

-- bags and buffs may have changed during the fight
function module:PLAYER_REGEN_ENABLED()
	StartChecks()
	RescanBags()
end

-- on a profile switch events fire before mMT:UpdateAll, the old profile has lost its defaults by then
local function RebindProfile()
	module.db = E.db.mMediaTag.buff_reminder
end

function module:Initialize(demo)
	if not (E.Retail and E.db.mMediaTag.buff_reminder.enable) then
		module.demo = nil
		if module.isEnabled then
			module:UnregisterAllEvents()
			module.isEnabled = false
			StopTicker()
			StopHideTimer()
			HideFlyout()
			Update()
		end
		return
	end

	module.db = E.db.mMediaTag.buff_reminder
	if not module.profileHooked then
		hooksecurefunc(E, "UpdateStart", RebindProfile)
		module.profileHooked = true
	end
	if demo then module.demo = not module.demo end

	if not module.frame then CreateReminderFrame() end
	bagsDirty = true
	-- a changed setting starts the hide time again
	ShowAgain()
	-- the loading screen is usually over before the module starts, a reload inside an instance counts as entering it
	if not InCombatLockdown() then UpdateEntry() end

	if not module.isEnabled then
		module:RegisterEvent("PLAYER_REGEN_ENABLED")
		module:RegisterEvent("PLAYER_REGEN_DISABLED")
		module:RegisterEvent("GROUP_JOINED")
		if not InCombatLockdown() then StartChecks() end
		module.isEnabled = true
	end

	QueueUpdate()
end
