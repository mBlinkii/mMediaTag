local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-ExecuteMarker", { "AceHook-3.0", "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")

-- Cache WoW Globals
local pairs, ipairs = pairs, ipairs
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local GetSpecialization = C_SpecializationInfo.GetSpecialization or GetSpecialization
local IsPlayerSpell = IsPlayerSpell
local IsSpellKnownOrOverridesKnown = IsSpellKnownOrOverridesKnown
local GetActiveConfigID = C_ClassTalents.GetActiveConfigID
local GetNodeInfo = C_Traits.GetNodeInfo

-- Midnight: enemy health is secret, so instead of comparing values the marker sits in a clip frame
-- anchored to the health bar fill texture and is clipped away by itself below the threshold.

local autoRange = { enable = false, range = 0 }
local markers = setmetatable({}, { __mode = "k" }) -- [healthBar] = { clip, line }
local execDB -- cached E.db.mMediaTag.nameplates.execute, set in Initialize

-- Execute thresholds in percent per class. The first entry the player knows wins,
-- a known entry in "raise" replaces its range. spells = spell ids (any of), nodes = talent node ids (any of).
local EXECUTE_RANGES = {
	PRIEST = {
		{ range = 20, spells = { 32379 }, raise = { { range = 35, spells = { 392507 } } } }, -- Shadow Word: Death, Deathspeaker
	},
	MAGE = {
		{ range = 35, spells = { 384581 } }, -- Arcane Bombardment
		{ range = 30, spells = { 2948 }, raise = { { range = 35, nodes = { 449349 } } } }, -- Scorch, Sunfury Execution
	},
	WARRIOR = {
		{ range = 20, spells = { 163201 }, raise = { { range = 35, spells = { 281001, 206315 } } } }, -- Execute, Massacre
	},
	HUNTER = {
		{ range = 35, spells = { 273887 } }, -- Killer Instinct
		{ range = 20, nodes = { 94987 } }, -- Black Arrow
		{ range = 20, spells = { 53351, 320976 } }, -- Kill Shot
	},
	PALADIN = {
		{ range = 20, spells = { 24275 } }, -- Hammer of Wrath
	},
	MONK = {
		-- Touch of Death scales with the unit health, which is secret in Midnight, so its base threshold is used
		{ range = 15, spells = { 322113 } },
	},
	WARLOCK = {
		{ range = 20, spells = { 17877 }, raise = { { range = 30, spells = { 456939 } } } }, -- Shadowburn, Blistering Atrophy
		{ range = 20, spells = { 198590 } }, -- Drain Soul
	},
	ROGUE = {
		{ range = 35, spells = { 328085, 381798 } }, -- Blindside, Zoldyck Recipe
	},
	DEATHKNIGHT = {
		{ range = 35, spells = { 343294 } }, -- Soul Reaper
	},
}

local function IsTalentNodeActive(nodeID)
	local configID = GetActiveConfigID()
	local info = configID and GetNodeInfo(configID, nodeID)
	return info and (info.activeRank or 0) > 0
end

-- IsPlayerSpell covers passive talents, the override check spells that replace another one (Drain Soul)
local function IsEntryKnown(entry)
	if entry.spells then
		for _, spellID in ipairs(entry.spells) do
			if IsPlayerSpell(spellID) or IsSpellKnownOrOverridesKnown(spellID) then return true end
		end
	end

	if entry.nodes then
		for _, nodeID in ipairs(entry.nodes) do
			if IsTalentNodeActive(nodeID) then return true end
		end
	end

	return false
end

local function GetEntryRange(entry)
	if entry.raise then
		for _, raise in ipairs(entry.raise) do
			if IsEntryKnown(raise) then return raise.range end
		end
	end

	return entry.range
end

local function UpdateAutoRange()
	autoRange.enable = false
	autoRange.range = 0

	local entries = EXECUTE_RANGES[E.myclass]
	if not (entries and GetSpecialization()) then return end

	for _, entry in ipairs(entries) do
		if IsEntryKnown(entry) then
			autoRange.enable = true
			autoRange.range = GetEntryRange(entry)
			return
		end
	end
end

local function GetRange(db)
	if db.auto then return autoRange.enable and autoRange.range or nil end

	return db.range
end

local function ShouldShow(db)
	return not db.onlyCombat or InCombatLockdown()
end

-- friendly and personal plates have no use for an execute marker
local function IsEnemyPlate(nameplate)
	local frameType = nameplate.frameType
	return frameType == "ENEMY_NPC" or frameType == "ENEMY_PLAYER"
end

local function HideMarker(healthBar)
	local marker = markers[healthBar]
	if marker then marker.clip:Hide() end
end

local UpdateMarker

local function GetMarker(nameplate, healthBar)
	local marker = markers[healthBar]
	if marker then return marker end

	local clip = CreateFrame("Frame", nil, healthBar)
	clip:SetClipsChildren(true)
	clip:SetFrameLevel(healthBar:GetFrameLevel() + 1)

	local line = clip:CreateTexture(nil, "OVERLAY", nil, 2)
	line:SetColorTexture(1, 1, 1)

	marker = { clip = clip, line = line }
	markers[healthBar] = marker

	-- the bar can still be unsized when the plate is set up, reposition once it gets its size
	healthBar:HookScript("OnSizeChanged", function()
		UpdateMarker(nameplate)
	end)

	return marker
end

function UpdateMarker(nameplate, force)
	local healthBar = nameplate.Health
	if not healthBar then return end

	local db = execDB
	local range = db and db.enable and GetRange(db)
	if not (range and range > 0 and range < 100 and IsEnemyPlate(nameplate) and ShouldShow(db)) then return HideMarker(healthBar) end

	local marker = GetMarker(nameplate, healthBar)
	local width = healthBar:GetWidth()
	if width <= 0 then return marker.clip:Hide() end

	-- hot path: skip the layout unless fill texture, bar size or range changed.
	local fill = healthBar:GetStatusBarTexture()
	if force or marker.fill ~= fill then
		marker.clip:ClearAllPoints()
		marker.clip:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 0, 0)
		marker.clip:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT", 0, 0)
		marker.clip:SetPoint("RIGHT", fill, "RIGHT", 0, 0)
		marker.fill = fill
	end

	local height = healthBar:GetHeight()
	if force or marker.range ~= range or marker.width ~= width or marker.height ~= height then
		marker.line:SetSize(2, height)
		marker.line:ClearAllPoints()
		marker.line:SetPoint("LEFT", healthBar, "LEFT", width * range / 100, 0)
		marker.range, marker.width, marker.height = range, width, height
	end

	if force or not marker.colored then
		local color = MEDIA.color.nameplates.execute_color
		if color then marker.line:SetVertexColor(color.r, color.g, color.b) end
		marker.colored = true
	end

	marker.clip:Show()
end

-- all plates, not only those with a marker: with "only in combat" no marker exists yet when combat starts
local function UpdateAllMarkers(force)
	if not NP.Plates then return end

	for nameplate in pairs(NP.Plates) do
		UpdateMarker(nameplate, force)
	end
end

-- UpdatePlate runs for every new unit on a plate, Update_Health only when the plate type changes
local function OnUpdatePlate(_, nameplate)
	if nameplate then UpdateMarker(nameplate) end
end

function module:CombatUpdate()
	UpdateAllMarkers()
end

function module:RangeUpdate()
	UpdateAutoRange()
	UpdateAllMarkers()
end

function module:Initialize()
	if not E.private.nameplates.enable then return end

	local db = E.db.mMediaTag.nameplates.execute
	execDB = db

	if not (db and db.enable) then
		if module.initialized then UpdateAllMarkers() end
		return
	end

	UpdateAutoRange()

	if not module.initialized then
		module:SecureHook(NP, "UpdatePlate", OnUpdatePlate)

		module:RegisterEvent("PLAYER_ENTERING_WORLD", "RangeUpdate")
		module:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "RangeUpdate")
		module:RegisterEvent("TRAIT_CONFIG_UPDATED", "RangeUpdate")
		-- learned spells can lag behind the talent event, and leveling unlocks execute spells
		module:RegisterEvent("SPELLS_CHANGED", "RangeUpdate")
		module:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatUpdate")
		module:RegisterEvent("PLAYER_REGEN_ENABLED", "CombatUpdate")

		module.initialized = true
	end

	UpdateAllMarkers(true) -- force: settings (range/color/anchors) may have changed
end
