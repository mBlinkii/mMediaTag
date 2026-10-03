local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NP-RaidMarkerColor", { "AceEvent-3.0" })

local NP = E:GetModule("NamePlates")

-- Cache WoW Globals
local pairs, ipairs = pairs, ipairs
local format = format
local hooksecurefunc = hooksecurefunc
local GetRaidTargetIndex = GetRaidTargetIndex
local UnitExists = UnitExists

-- The marker index is secret and can only pick a sprite sheet cell. Every marker has its own white sheet that is
-- filled in its own cell only, tinted in the marker color, so the index makes exactly one of the layers visible.
local SHEET = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\raidmarker\\cell_%d.tga"
-- index order of the raid target icons
local MARKERS = { "star", "circle", "diamond", "triangle", "moon", "square", "cross", "skull" }
local NUM_MARKERS = #MARKERS

local function GetLayer(nameplate, marker)
	local layers = nameplate.mMT_MarkerLayers
	if not layers then
		layers = {}
		nameplate.mMT_MarkerLayers = layers
	end

	local layer = layers[marker]
	if not layer then
		layer = nameplate.Health:CreateTexture(nil, "ARTWORK", nil, 5)
		-- unfiltered, otherwise the empty neighbour cells bleed into the picked one
		layer:SetTexture(format(SHEET, marker), "CLAMP", "CLAMP", "NEAREST")
		layer:Hide()
		layers[marker] = layer
	end

	return layer
end

local function HideLayers(nameplate)
	local layers = nameplate.mMT_MarkerLayers
	if not layers then return end

	for _, layer in pairs(layers) do
		layer:Hide()
	end
end

local function UpdatePlate(nameplate)
	local health = nameplate.Health
	local unit = nameplate.__unit
	if not (module.isEnabled and health and unit) or nameplate.frameType == "PLAYER" or nameplate == NP.TestFrame or not UnitExists(unit) then return HideLayers(nameplate) end

	-- a boolean test is allowed on a secret number, nil means no marker
	local index = GetRaidTargetIndex(unit)
	if not index then return HideLayers(nameplate) end

	-- the fill texture can change with the health bar texture setting
	local fill = health:GetStatusBarTexture()
	for marker = 1, NUM_MARKERS do
		local settings = module.markers[marker]
		if settings then
			local layer = GetLayer(nameplate, marker)
			layer:SetAllPoints(fill)
			layer:SetVertexColor(settings.r, settings.g, settings.b, module.alpha)
			layer:SetSpriteSheetCell(index, 1, NUM_MARKERS)
			layer:Show()
		elseif nameplate.mMT_MarkerLayers and nameplate.mMT_MarkerLayers[marker] then
			nameplate.mMT_MarkerLayers[marker]:Hide()
		end
	end
end

local function UpdateAllPlates()
	if not NP.Plates then return end

	for nameplate in pairs(NP.Plates) do
		if nameplate:IsShown() then
			UpdatePlate(nameplate)
		else
			HideLayers(nameplate)
		end
	end
end

function module:Initialize()
	if not E.private.nameplates.enable then return end

	local db = E.db.mMediaTag.nameplates.raid_marker_color

	if not db.enable then
		if module.isEnabled then
			module.isEnabled = false
			module:UnregisterEvent("RAID_TARGET_UPDATE")
			UpdateAllPlates()
		end
		return
	end

	-- only enabled markers get a layer, the colors are copied so the hot path does no lookups
	module.markers = {}
	for marker, key in ipairs(MARKERS) do
		if db.markers[key] then module.markers[marker] = MEDIA.color.raid_markers[key] end
	end
	module.alpha = db.alpha or 1

	if not module.hooked then
		-- runs for every new unit on a plate
		hooksecurefunc(NP, "UpdatePlate", function(_, nameplate)
			if nameplate then UpdatePlate(nameplate) end
		end)
		module.hooked = true
	end

	module:RegisterEvent("RAID_TARGET_UPDATE", UpdateAllPlates)
	module.isEnabled = true

	UpdateAllPlates()
end
