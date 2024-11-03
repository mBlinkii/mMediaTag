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
		aspectratio = 3 / 2,
		offset = 2,
	},
	["4:3"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\4-3.tga",
		aspectratio = 4 / 3,
		offset = 1,
	},
	["16:8"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-8.tga",
		aspectratio = 16 / 8,
		offset = 1,
	},
	["16:9"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-9.tga",
		aspectratio = 16 / 9,
		offset = 1,
	},
	["16:10"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-10.tga",
		aspectratio = 16 / 10,
		offset = 1,
	},
}

local function HandleButton(button, iconType, hideSetting)
	if not (button and Minimap.mMT_Offset) then return end

	local hidden = hideSetting and (not Minimap:IsShown() or E.private.general.minimap[hideSetting]) or false
	if hidden then return end

	local _, position, xOffset, y = M:GetIconSettings(iconType)
	local yOffset = Minimap.mMT_Offset + y

	button:ClearAllPoints()
	local isTop = position == "TOP" or position == "TOPLEFT" or position == "TOPRIGHT"
	button:SetPoint(position, Minimap, xOffset, isTop and -yOffset or yOffset)
end

local function HandleTrackingButton()
	local tracking = MinimapCluster.Tracking or MinimapCluster.TrackingFrame or _G.MiniMapTrackingFrame or _G.MiniMapTracking
	HandleButton(tracking, "tracking", "hideTracking")
end

local function HandleExpansionButton()
	local garrison = _G.ExpansionLandingPageMinimapButton or _G.GarrisonLandingPageMinimapButton
	HandleButton(garrison, "classHall", "hideClassHallReport")
end

local function HandleDifficulty()
	local difficulty = MinimapCluster.InstanceDifficulty or _G.MiniMapInstanceDifficulty
	HandleButton(difficulty, "difficulty")
end

local function HandleIcons()
	local mailFrame = (MinimapCluster.IndicatorFrame and MinimapCluster.IndicatorFrame.MailFrame) or _G.MiniMapMailFrame
	HandleButton(mailFrame, "mail")

	local gameTime = _G.GameTimeFrame
	HandleButton(gameTime, "calendar")

	local craftingFrame = MinimapCluster.IndicatorFrame and MinimapCluster.IndicatorFrame.CraftingOrderFrame
	HandleButton(craftingFrame, "crafting")
end

local function SetAspectRatio()
	local aspectRatio = aspectRatios[E.db.mMT.minimapAspectRatio.aspectRatio]
	local width = E.MinimapSize
	local height = width / aspectRatio.aspectratio
	local difference = width - height
	local borderSize = E.PixelMode and 1 or 3
	local offset = ceil(difference / 2)
	Minimap.mMT_Offset = offset

	M.MapHolder:SetSize(width, height)

	Minimap:SetMaskTexture(aspectRatio.mask)

	Minimap.backdrop:ClearAllPoints()
	Minimap.backdrop:SetOutside(Minimap, borderSize, -offset + borderSize)

	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOP", M.MapHolder, "TOP", 0, offset)

	if Minimap.location then
		Minimap.location:ClearAllPoints()
		Minimap.location:SetPoint("TOP", Minimap, 0, -offset - 2)
	end
end

function module:Initialize()
	if not module.hooked then
		hooksecurefunc(M, "UpdateSettings", SetAspectRatio)
		hooksecurefunc(M, "HandleTrackingButton", HandleTrackingButton)
		hooksecurefunc(M, "HandleExpansionButton", HandleExpansionButton)
		hooksecurefunc(M, "HandleDifficulty", HandleDifficulty)
		hooksecurefunc(M, "UpdateIcons", HandleIcons)
		module.hooked = true
	end

	SetAspectRatio()
	HandleTrackingButton()
	HandleExpansionButton()
	HandleDifficulty()
	HandleIcons()

	module.needReloadUI = true
	module.loaded = true
end
