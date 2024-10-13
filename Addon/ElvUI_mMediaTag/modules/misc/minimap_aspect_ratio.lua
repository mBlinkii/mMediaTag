local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule("Minimap")
local module = mMT.Modules.MinimapAspectRatio
if not module then return end

local Minimap = _G.Minimap
local MinimapCluster = _G.MinimapCluster
local ceil = math.ceil

local aspectRatios = {
	["3:2"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\3-2.tga",
		aspectratio = 1.5,
		offset = 2,
	},
	["4:3"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\4-3.tga",
		aspectratio = 1.33333,
		offset = 1,
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
	local aspectRatio = aspectRatios[E.db.mMT.minimapAspectRatio.aspectRatio]
	local width = E.MinimapSize
	local height = width / aspectRatio.aspectratio
	local difference = width - height
	return -ceil(difference / 2) + aspectRatio.offset
end

local function HandleButton(button, iconType, hideSetting)
	if not button then return end

	local hidden = not Minimap:IsShown()
	if not hidden or E.private.general.minimap[hideSetting] then
		local _, position, xOffset, y = M:GetIconSettings(iconType)
		local yOffset = GetYOffset() - y

		button:ClearAllPoints()
		button:SetPoint(position, Minimap, xOffset, -yOffset)
	end
end

local function HandleTrackingButton()
	local tracking = MinimapCluster.Tracking or MinimapCluster.TrackingFrame or _G.MiniMapTrackingFrame or _G.MiniMapTracking
	HandleButton(tracking, "tracking", "hideTracking")
end

local function HandleExpansionButton()
	local garrison = _G.ExpansionLandingPageMinimapButton or _G.GarrisonLandingPageMinimapButton
	HandleButton(garrison, "classHall", "hideClassHallReport")
end

local function SetAspectRatio()
	local aspectRatio = aspectRatios[E.db.mMT.minimapAspectRatio.aspectRatio]
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
		hooksecurefunc(M, "UpdateSettings", SetAspectRatio)
		hooksecurefunc(M, "HandleTrackingButton", HandleTrackingButton)
		hooksecurefunc(M, "HandleExpansionButton", HandleExpansionButton)
		module.hooked = true
	end

	SetAspectRatio()
	HandleTrackingButton()
	HandleExpansionButton()

	module.needReloadUI = true
	module.loaded = true
end
