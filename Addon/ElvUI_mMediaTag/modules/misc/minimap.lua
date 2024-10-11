local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule("Minimap")
local module = mMT.Modules.Minimap
if not module then return end

local Minimap = _G.Minimap
local MinimapCluster = _G.MinimapCluster
local ceil = math.ceil

local aspectRatios = {
	["3:2"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\3-2.tga",
		aspectratio = 1.5,
		offset = 1,
	},
	["4:3"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\4-3.tga",
		aspectratio = 1.33333,
		offset = 2,
	},
	["16:8"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-8.tga",
		aspectratio = 2,
		offset = 1,
	},
	["16:9"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-9.tga",
		aspectratio = 1.77777,
		offset = 1,
	},
	["16:10"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-10.tga",
		aspectratio = 1.6,
		offset = 1,
	},
}

local function GetYOffset()
	local aspectRatio = aspectRatios[E.db.mMT.minimap.aspectRatio]
	local width = E.MinimapSize
	local height = width / aspectRatio.aspectratio
	local difference = width - height
	return -ceil(difference / 2) + aspectRatio.offset
end

local function HandleTrackingButton()
	local tracking = MinimapCluster.Tracking or MinimapCluster.TrackingFrame or _G.MiniMapTrackingFrame or _G.MiniMapTracking
	if not tracking then return end

	local hidden = not Minimap:IsShown()
	if not hidden or E.private.general.minimap.hideTracking then
		local _, position, xOffset, y = M:GetIconSettings("tracking")
		local yOffset = GetYOffset() - y

        tracking:ClearAllPoints()
		tracking:SetPoint(position, Minimap, xOffset, -yOffset)
	end
end

local function HandleExpansionButton()
	local garrison = _G.ExpansionLandingPageMinimapButton or _G.GarrisonLandingPageMinimapButton
	if not garrison then return end

	local hidden = not Minimap:IsShown()

	if not hidden or E.private.general.minimap.hideClassHallReport then
        local _, position, xOffset, y = M:GetIconSettings("classHall")
		local yOffset = GetYOffset() - y

		garrison:ClearAllPoints()
		garrison:Point(position, Minimap, xOffset, -yOffset)

	end
end

local function SkinMinimap()
	local aspectRatio = aspectRatios[E.db.mMT.minimap.aspectRatio]
	local width = E.MinimapSize
	local height = width / aspectRatio.aspectratio

	Minimap:SetSize(width, width)
	M.MapHolder:SetSize(width, height)
	Minimap:SetMaskTexture(aspectRatio.mask)

	local yOffset = GetYOffset()
	Minimap.backdrop:ClearAllPoints()
	Minimap.backdrop:SetOutside(Minimap, 1, yOffset)

	local yOffsetOther = yOffset + aspectRatio.offset
	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOPLEFT", M.MapHolder, "TOPLEFT", 0, -yOffsetOther)

	if Minimap.location then
		Minimap.location:ClearAllPoints()
		Minimap.location:SetPoint("TOP", Minimap, 0, yOffsetOther - 2)
	end
end

function module:Initialize()
	if not module.hooked then
		hooksecurefunc(M, "UpdateSettings", SkinMinimap)
		hooksecurefunc(M, "HandleTrackingButton", HandleTrackingButton)
		hooksecurefunc(M, "HandleExpansionButton", HandleExpansionButton)
		module.hooked = true
	end

	SkinMinimap()
	HandleTrackingButton()
    HandleExpansionButton()

	module.needReloadUI = true
	module.loaded = true
end
