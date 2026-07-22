local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-ExecuteMarker", { "AceHook-3.0", "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")

-- Cache WoW Globals
local pairs = pairs
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local IsPlayerSpell = IsPlayerSpell
local IsSpellKnownOrOverridesKnown = IsSpellKnownOrOverridesKnown
local GetActiveConfigID = C_ClassTalents.GetActiveConfigID
local GetNodeInfo = C_Traits.GetNodeInfo

-- Midnight note:
-- UnitHealth/UnitHealthPercent return secrets for enemy units, so we can never
-- compare the units health against the execute threshold in Lua. Instead the
-- marker lives inside a clip frame whose right edge is anchored to the health
-- bars fill texture. The client resizes that texture securely, so the marker
-- is clipped away (hidden) automatically once the unit drops below the
-- threshold - without us ever reading a health value.

local autoRange = { enable = false, range = 0 }
local markers = setmetatable({}, { __mode = "k" }) -- [healthBar] = { clip, line }

-- spell/talent IDs verified against Plater Nameplates (Interface 12.0.7/12.1.0)
local function IsTalentLearned(nodeID)
	local configID = GetActiveConfigID()
	local nodeInfo = configID and nodeID and GetNodeInfo(configID, nodeID)
	return nodeInfo and nodeInfo.entryIDsWithCommittedRanks and nodeInfo.entryIDsWithCommittedRanks[1] and true or false
end

local function SetRange(range)
	autoRange.enable = true
	autoRange.range = range
end

local function UpdateAutoRange()
	autoRange.enable = false
	autoRange.range = 0

	local _, class = UnitClass("player")
	local spec = GetSpecialization()
	if not (class and spec) then return end

	if class == "PRIEST" then
		if IsPlayerSpell(32379) then -- SW:Death
			SetRange(IsPlayerSpell(392507) and 35 or 20) -- Deathspeaker
		end
	elseif class == "MAGE" then
		if IsPlayerSpell(384581) then -- Arcane Bombardment
			SetRange(35)
		elseif IsPlayerSpell(2948) then -- Scorch
			SetRange(IsTalentLearned(449349) and 35 or 30) -- Sunfury Execution
		end
	elseif class == "WARRIOR" then
		if IsPlayerSpell(163201) then -- Execute
			SetRange((IsPlayerSpell(281001) or IsPlayerSpell(206315)) and 35 or 20) -- Massacre
		end
	elseif class == "HUNTER" then
		if IsPlayerSpell(273887) then -- Killer Instinct
			SetRange(35)
		elseif IsTalentLearned(94987) then -- Black Arrow
			SetRange(20)
		elseif IsPlayerSpell(53351) or IsPlayerSpell(320976) then -- Kill Shot
			SetRange(20)
		end
	elseif class == "PALADIN" then
		if IsPlayerSpell(24275) then -- Hammer of Wrath
			SetRange(20)
		end
	elseif class == "MONK" then
		if IsPlayerSpell(322113) then -- Touch of Death
			-- the old dynamic ToD range (own max health vs unit max health) is
			-- impossible in Midnight, unit health is secret - use the static 15%
			SetRange(15)
		end
	elseif class == "WARLOCK" then
		if IsPlayerSpell(17877) then -- Shadowburn
			SetRange(IsPlayerSpell(456939) and 30 or 20) -- Blistering Atrophy
		elseif IsSpellKnownOrOverridesKnown(198590) then -- Drain Soul
			SetRange(20)
		end
	elseif class == "ROGUE" then
		if IsPlayerSpell(328085) or IsPlayerSpell(381798) then -- Blindside or Zoldyck Recipe
			SetRange(35)
		end
	elseif class == "DEATHKNIGHT" then
		if IsPlayerSpell(343294) then -- Soul Reaper
			SetRange(35)
		end
	end
end

local function GetRange(db)
	if db.auto then
		return autoRange.enable and autoRange.range or nil
	end

	return db.range
end

local function ShouldShow(db)
	return not db.onlyCombat or InCombatLockdown()
end

local function GetMarker(healthBar)
	local marker = markers[healthBar]
	if marker then return marker end

	local clip = CreateFrame("Frame", nil, healthBar)
	clip:SetClipsChildren(true)
	clip:SetFrameLevel(healthBar:GetFrameLevel() + 1)

	local line = clip:CreateTexture(nil, "OVERLAY", nil, 2)
	line:SetColorTexture(1, 1, 1)

	marker = { clip = clip, line = line }
	markers[healthBar] = marker

	return marker
end

local function UpdateMarker(healthBar)
	local db = E.db.mMediaTag.nameplates.execute
	local marker = markers[healthBar]

	if not (db and db.enable) then
		if marker then marker.clip:Hide() end
		return
	end

	local range = GetRange(db)
	local width = healthBar:GetWidth()

	if not range or range <= 0 or range >= 100 or width <= 0 or not ShouldShow(db) then
		if marker then marker.clip:Hide() end
		return
	end

	marker = marker or GetMarker(healthBar)

	local fill = healthBar:GetStatusBarTexture()
	marker.clip:ClearAllPoints()
	marker.clip:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 0, 0)
	marker.clip:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT", 0, 0)
	marker.clip:SetPoint("RIGHT", fill, "RIGHT", 0, 0)

	local color = MEDIA.color.nameplates.execute_color
	marker.line:SetSize(2, healthBar:GetHeight())
	marker.line:ClearAllPoints()
	marker.line:SetPoint("LEFT", healthBar, "LEFT", width * range / 100, 0)
	if color then marker.line:SetVertexColor(color.r, color.g, color.b) end

	marker.clip:Show()
end

local function UpdateAllMarkers()
	for healthBar in pairs(markers) do
		UpdateMarker(healthBar)
	end
end

local function OnUpdateHealth(_, nameplate)
	if not (nameplate and nameplate.Health) then return end
	UpdateMarker(nameplate.Health)
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
	if not (db and db.enable) then
		if module.initialized then UpdateAllMarkers() end
		return
	end

	UpdateAutoRange()

	if not module.initialized then
		module:SecureHook(NP, "Update_Health", OnUpdateHealth)

		module:RegisterEvent("PLAYER_ENTERING_WORLD", "RangeUpdate")
		module:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "RangeUpdate")
		module:RegisterEvent("TRAIT_CONFIG_UPDATED", "RangeUpdate")
		module:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatUpdate")
		module:RegisterEvent("PLAYER_REGEN_ENABLED", "CombatUpdate")

		module.initialized = true
	end

	UpdateAllMarkers()
end
