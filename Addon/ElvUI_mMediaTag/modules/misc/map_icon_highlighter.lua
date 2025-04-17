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
local function GetTextPosition(position)
	local anchor = {
		anchor1 = "BOTTOM",
		anchor2 = "TOP",
		x = 0,
		y = 2,
	}

	if position == "BOTTOM" then
		anchor = {
			anchor1 = "TOP",
			anchor2 = "BOTTOM",
			x = 0,
			y = -2,
		}
	elseif position == "LEFT" then
		anchor = {
			anchor1 = "RIGHT",
			anchor2 = "LEFT",
			x = -2,
			y = 0,
		}
	elseif position == "RIGHT" then
		anchor = {
			anchor1 = "LEFT",
			anchor2 = "RIGHT",
			x = 2,
			y = 0,
		}
	else
		anchor = {
			anchor1 = "BOTTOM",
			anchor2 = "TOP",
			x = 0,
			y = 2,
		}
	end

	return anchor
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
local function UpdateSettings()
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
end

local function GetLabelOffsets(frame, info)
	local iconWidth, iconHeight = frame:GetSize()
	local labelWidth, labelHeight = frame.mMT_label:GetSize()

	local posLookup = {
		["LEFT"] = {
			["posX"] = (iconWidth / 2) - (labelWidth / 2) + info.x - 3,
			["posY"] = 0,
		},
		["RIGHT"] = {
			["posX"] = -(iconWidth / 2) + (labelWidth / 2) + info.x - 3,
			["posY"] = 0,
		},
		["TOP"] = {
			["posX"] = 0,
			["posY"] = -(iconHeight / 2) - (labelHeight / 2) + info.y - 3,
		},
		["BOTTOM"] = {
			["posX"] = 0,
			["posY"] = (iconHeight / 2) + (labelHeight / 2) + info.y - 3,
		},
		["CENTER"] = {
			["posX"] = 0,
			["posY"] = 0,
		},
	}

	return posLookup[info.anchor1].posX, posLookup[info.anchor1].posY
end

function module:ApplySettings(frame, texture, atlasName)
	local info = optionsLookup[atlasName]
	if not info then
		print("NOT FOUND", atlasName, info)
		return
	end

	-- global
	local icon_scale = 1
	local blendMode = "ADD"
	local font = LSM:Fetch("font", E.db.mMT.lfg_invite_info.font.font)
	local fontSize = 8
	local fontFlag = "OUTLINE"

	-- icon
	local enable = true
	local alpha = 1
	local use_color = true
	local color = { 2, 1, 1 }
	local text_color = { 1, 2, 1 }
	local point = GetTextPosition("TOP")
	local showText = true

	if not info then
		if frame.mMT_background then frame.mMT_background:Hide() end
		if frame.mMT_label then frame.mMT_label:Hide() end
		return
	end

	texture:SetScale(icon_scale)

	-- Configure outline
	if enable then
		print("AtlasName", atlasName)
		if not frame.mMT_background then frame.mMT_background = frame:CreateTexture() end
		frame.mMT_background:SetAtlas(atlasName)
		frame.mMT_background:SetBlendMode("BLEND")
		frame.mMT_background:SetScale(2)
		frame.mMT_background:SetAlpha(alpha)
		frame.mMT_background:SetVertexColor(unpack(color))
		frame.mMT_background:SetDesaturated(use_color)
		frame.mMT_background:Show()
	elseif frame.mMT_background then
		frame.mMT_background:Hide()
	end

	-- Configure text
	local labelText = frame.poiInfo and frame.poiInfo.name or frame.name

	if showText and (frame.poiInfo or frame.name) then
		if not frame.mMT_label then
			local f = CreateFrame("Frame", "mMT_labelBase", WorldMapFrame)
			local t = f:CreateFontString()
			frame.mMT_label = t
			f:SetParent(WorldMapFrame)
			f:SetFrameStrata("HIGH")
		end
		frame.mMT_label:ClearAllPoints()
		frame.mMT_label:SetPoint(point.anchor1, frame, point.anchor2, point.x, point.y)
		frame.mMT_label:SetFont(font, fontSize, fontFlag)
		frame.mMT_label:SetShadowOffset(1, -1)
		frame.mMT_label:Show()
		frame.mMT_label:SetText(labelText)
		frame.mMT_label:SetVertexColor(unpack(text_color))
		frame.mMT_label:SetAlpha(alpha)

		local _, _, _, iconX, iconY = frame:GetPoint(1)

		if iconX and iconY then -- can be nil
			local scale = WorldMapFrame.ScrollContainer.baseScale * frame:GetScale()
			local offsetX, offsetY = GetLabelOffsets(frame, point)
			labeledIcons[frame] = {
				["text"] = frame.mMT_label,
				["width"] = frame.mMT_label:GetWidth(),
				["height"] = frame.mMT_label:GetHeight(),
				["posX"] = iconX * scale,
				["posY"] = iconY * scale * -1,
				["offsetX"] = offsetX,
				["offsetY"] = offsetY,
			}
		end
	elseif frame.mMT_label then
		frame.mMT_label:Hide()
	end
end

function module:HideHighlights(frame)
	print("HideHighlights", frame:GetName())
	if frame.Texture then
		frame.Texture:SetScale(1)
	elseif frame.Icon then
		frame.Icon:SetScale(1)
	end

	if frame.mMT_background then frame.mMT_background:Hide() end

	if frame.mMT_label then frame.mMT_label:Hide() end
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
				module:ApplySettings(child, child.Icon, atlasName)
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

		--UpdateSettings()

		if not module.isHooked then
			-- the delay is deliberate
			WorldMapFrame:HookScript("OnShow", function()
				E:Delay(0.1, function()
					UpdateShow()
				end)
			end)
			hooksecurefunc(WorldMapFrame.ScrollContainer, "ZoomIn", function()
				print("ZoomIn")
				module:CheckLabels()
			end)
			hooksecurefunc(WorldMapFrame.ScrollContainer, "ZoomOut", function()
				print("ZoomOut")
				module:CheckLabels()
			end)
			hooksecurefunc(WorldMapFrame, "Maximize", function()
				print("Maximize")
				UpdateShow()
			end)
			hooksecurefunc(WorldMapFrame, "Minimize", function()
				print("Minimize")
				UpdateShow()
			end)
			hooksecurefunc(WorldMapFrame, "ProcessCanvasClickHandlers", function(...)
				print("ProcessCanvasClickHandlers", ...)
				UpdateShow()
			end)

			module.isHooked = true
		end
	end
end
