local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("MapIconHighlighter", { "AceEvent-3.0" })

-- Cache WoW Globals
local CreateFrame = _G.CreateFrame
local format = _G.format
local unpack = _G.unpack
local pairs = _G.pairs
local ipairs = _G.ipairs

local LSM = E.Libs.LSM
local COLORS = MEDIA.color

-- Global settings
local globalScale = 1
local globalTextSize = 12
local globalTextFont = "PT Sans Narrow"
local globalTextOutline = "OUTLINE"

local labeledIcons = {}

-- Options lookup table
local optionsLookup = {}

-- Helper function to configure outline settings
local function ConfigureOutline(info, cfg)
	if cfg.style == 1 then
		info.outlineBlendMode = "ADD"
		info.outlineInFront = true
	elseif cfg.style == 2 then
		info.outlineBlendMode = "BLEND"
		info.outlineInFront = false
	elseif cfg.style == 3 then
		info.outlineBlendMode = "ADD"
		info.outlineInFront = false
	end
end

-- Helper function to configure text position
local function ConfigureTextPosition(info, cfg)
	if cfg.textPosition == 2 then
		info.textAnchor1 = "TOP"
		info.textAnchor2 = "BOTTOM"
		info.textX = 0
		info.textY = -2
	elseif cfg.textPosition == 3 then
		info.textAnchor1 = "RIGHT"
		info.textAnchor2 = "LEFT"
		info.textX = -2
		info.textY = 0
	elseif cfg.textPosition == 4 then
		info.textAnchor1 = "LEFT"
		info.textAnchor2 = "RIGHT"
		info.textX = 2
		info.textY = 0
	elseif cfg.textPosition == 5 then
		info.textAnchor1 = "CENTER"
		info.textAnchor2 = "CENTER"
		info.textX = 0
		info.textY = 0
	else
		info.textAnchor1 = "BOTTOM"
		info.textAnchor2 = "TOP"
		info.textX = 0
		info.textY = 2
	end
end

local tmp = {
	iconScale = 1,
	enable = true,
	scale = 1,
	use_color = true,
	color = { r = 1, g = 1, b = 1 },
	alpha = 1,
	show_text = true,
	custom_font = false,
	font = "PT Sans Narrow",
	fontflag = "OUTLINE",
	textScale = 1,
	text_color = { r = 1, g = 1, b = 1 },
	text_alpha = 1,
}

-- Build atlas lookup table
local atlasLookup = {}
for atlasName, cfg in pairs(optionsLookup) do
	local info = {
		iconScale = cfg.iconScale * globalScale,
		outline = cfg.enable,
		outlineScale = cfg.scale * cfg.iconScale * globalScale,
		outlineDesaturate = cfg.use_color,
		outlineColor = cfg.color,
		outlineAlpha = cfg.alpha,
		showLabel = cfg.show_text,
		textFont = cfg.custom_font and LSM:Fetch("font", cfg.font) or globalTextFont,
		textSize = globalTextSize * cfg.textScale,
		textOutline = cfg.custom_font and cfg.fontflag or globalTextOutline,
		textColor = cfg.text_color,
		textAlpha = cfg.text_alpha,
	}

	ConfigureOutline(info, cfg)
	ConfigureTextPosition(info, cfg)

	atlasLookup[atlasName] = info
end

function module:ApplySettings(frame, texture, atlasName)
	local info = atlasLookup[atlasName]
    print(frame, texture, atlasName, info)

	if not info then
		if frame.MIH_background then frame.MIH_background:Hide() end
		if frame.MIH_label then frame.MIH_label:Hide() end
		return
	end

	texture:SetScale(info.iconScale)

	-- Configure outline
	if info.outline then
		if not frame.MIH_background then frame.MIH_background = frame:CreateTexture() end
		frame.MIH_background:SetAtlas(atlasName)
		frame.MIH_background:SetBlendMode(info.outlineBlendMode)
		frame.MIH_background:SetScale(info.outlineScale)
		frame.MIH_background:SetAlpha(info.outlineAlpha)
		frame.MIH_background:SetVertexColor(unpack(info.outlineColor))
		frame.MIH_background:SetDesaturated(info.outlineDesaturate)
		frame.MIH_background:Show()
	elseif frame.MIH_background then
		frame.MIH_background:Hide()
	end

	-- Configure text
	if info.showLabel then
		if not frame.MIH_label then frame.MIH_label = frame:CreateFontString(nil, "OVERLAY") end
		frame.MIH_label:SetFont(info.textFont, info.textSize, info.textOutline)
		frame.MIH_label:SetTextColor(unpack(info.textColor))
		frame.MIH_label:SetAlpha(info.textAlpha)
		frame.MIH_label:SetPoint(info.textAnchor1, frame, info.textAnchor2, info.textX, info.textY)
		frame.MIH_label:Show()
	elseif frame.MIH_label then
		frame.MIH_label:Hide()
	end
end

function module:GetLabelOffsets(frame, info)
	local iconWidth, iconHeight = frame:GetSize()
	local labelWidth, labelHeight = frame.MIH_label:GetSize()

	local posLookup = {
		["LEFT"] = {
			["posX"] = (iconWidth / 2) - (labelWidth / 2) + info.textX - 3,
			["posY"] = 0,
		},
		["RIGHT"] = {
			["posX"] = -(iconWidth / 2) + (labelWidth / 2) + info.textX - 3,
			["posY"] = 0,
		},
		["TOP"] = {
			["posX"] = 0,
			["posY"] = -(iconHeight / 2) - (labelHeight / 2) + info.textY - 3,
		},
		["BOTTOM"] = {
			["posX"] = 0,
			["posY"] = (iconHeight / 2) + (labelHeight / 2) + info.textY - 3,
		},
		["CENTER"] = {
			["posX"] = 0,
			["posY"] = 0,
		},
	}

	return posLookup[info.textAnchor1].posX, posLookup[info.textAnchor1].posY
end

function module:HideHighlights(frame)
	if frame.Texture then
		frame.Texture:SetScale(1)
	elseif frame.Icon then
		frame.Icon:SetScale(1)
	end

	if frame.MIH_background then frame.MIH_background:Hide() end

	if frame.MIH_label then frame.MIH_label:Hide() end
end

function module:CheckLabels()
	local viewRect = WorldMapFrame.ScrollContainer.viewRect

	if not viewRect then viewRect = WorldMapFrame:GetViewRect() end

	local minimizedWidth, minimizedHeight = WorldMapFrame.ScrollContainer:GetSize()
	for frame, info in pairs(labeledIcons) do
		local offsetX = info.offsetX * frame:GetScale() * WorldMapFrame.ScrollContainer.baseScale
		local offsetY = info.offsetY * frame:GetScale() * WorldMapFrame.ScrollContainer.baseScale

		local x = (info.posX / minimizedWidth) - (offsetX / minimizedHeight)
		local y = (info.posY / minimizedHeight) - (offsetY / minimizedHeight)

		if viewRect:EnclosesPoint(x, y) then
			info.text:Show()
		else
			info.text:Hide()
		end
	end
end

local function UpdateShow()
	if not WorldMapFrame:IsShown() then return false end

	labeledIcons = {}
	local frame = WorldMapFrame.ScrollContainer.Child
	local children = { frame:GetChildren() }

	for _, child in ipairs(children) do
		if not child:IsVisible() then
			module:HideHighlights(child)
		elseif child.Icon then
			local atlasName = child.Icon:GetAtlas()
			if atlasName then
				module:GetLabelOffsetsApplySettings(child, child.Icon, atlasName)
			else
				module:HideHighlights(child)
			end
		elseif child.Texture then
			local atlasName = child.Texture:GetAtlas()
			if atlasName then
				module:ApplySettings(child, child.Texture, atlasName)
			else
				module:HideHighlights(child)
			end
		else
			module:HideHighlights(child)
		end
	end
	module:CheckLabels()
end

function module:Initialize(demo)
	if E.db.mMT.map_icon_highlighter.enable then
		globalScale = E.db.mMT.map_icon_highlighter.globalScale
		globalTextSize = E.db.mMT.map_icon_highlighter.globalTextSize
		globalTextFont = LSM:Fetch("font", E.db.mMT.map_icon_highlighter.globalTextFont)
		globalTextOutline = E.db.mMT.map_icon_highlighter.globalTextOutline
		labeledIcons = {}

		-- Options lookup table
		optionsLookup = {
			["delves-regular"] = E.db.mMT.map_icon_highlighter.delves,
			["delves-bountiful"] = E.db.mMT.map_icon_highlighter.delvesBountiful,
			["CaveUnderground-Up"] = E.db.mMT.map_icon_highlighter.caveExitUp,
			["CaveUnderground-Down"] = E.db.mMT.map_icon_highlighter.caveExitDown,
			["TaxiNode_Continent_Neutral"] = E.db.mMT.map_icon_highlighter.zonePortalNeutral,
			["TaxiNode_Continent_Alliance"] = E.db.mMT.map_icon_highlighter.zonePortalAlliance,
			["TaxiNode_Continent_Horde"] = E.db.mMT.map_icon_highlighter.zonePortalHorde,
			["TaxiNode_Neutral"] = E.db.mMT.map_icon_highlighter.flightpoint,
			["TaxiNode_Alliance"] = E.db.mMT.map_icon_highlighter.flightpoint,
			["TaxiNode_Horde"] = E.db.mMT.map_icon_highlighter.flightpoint,
			["TaxiNode_Undiscovered"] = E.db.mMT.map_icon_highlighter.flightpointUnknown,
			["poi-hub"] = E.db.mMT.map_icon_highlighter.poiHub,
			["worldquest-Capstone-questmarker-epic-Locked"] = E.db.mMT.map_icon_highlighter.wqAssignmentLocked,
			["Dungeon"] = E.db.mMT.map_icon_highlighter.dungeon,
			["Raid"] = E.db.mMT.map_icon_highlighter.raid,
			["Waypoint-MapPin-Untracked"] = E.db.mMT.map_icon_highlighter.waypoint,
			["Waypoint-MapPin-Tracked"] = E.db.mMT.map_icon_highlighter.waypoint,
			["SCRAP-activated"] = E.db.mMT.map_icon_highlighter.scrapHeap_active,
			["SCRAP-deactivated"] = E.db.mMT.map_icon_highlighter.scrapHeap_inactive,
		}

		if not module.isHooked then
			-- the delay is deliberate
			WorldMapFrame:HookScript("OnShow", function()
				print("OnShow")
				E:Delay(0.1, function()
					UpdateShow()
				end)
			end)
			hooksecurefunc(WorldMapFrame.ScrollContainer, "ZoomIn", function()
				module:CheckLabels()
			end)
			hooksecurefunc(WorldMapFrame.ScrollContainer, "ZoomOut", function()
				module:CheckLabels()
			end)
			hooksecurefunc(WorldMapFrame, "Maximize", function()
				UpdateShow()
			end)
			hooksecurefunc(WorldMapFrame, "Minimize", function()
				UpdateShow()
			end)
			hooksecurefunc(WorldMapFrame, "ProcessCanvasClickHandlers", function(...)
				UpdateShow()
			end)

			module.isHooked = true
		end
	end
end
