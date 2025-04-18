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

local settings = {
	["CaveUnderground-Down"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["CaveUnderground-Up"] = {
		alpha = 1,
		color = { icon = { 1, 1, 0 }, text = { 0, 1, 1 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["Dungeon"] = {
		alpha = 1,
		color = { icon = { 1, 0, 1 }, text = { 1, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["QuestNormal"] = {
		alpha = 1,
		color = { icon = { 0.5, 0, 1 }, text = { 1, 0.5, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["Raid"] = {
		alpha = 1,
		color = { icon = { 0.5, 1, 0 }, text = { 0, 0.5, 1 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["SCRAP-activated"] = {
		alpha = 1,
		color = { icon = { 1, 0.5, 0 }, text = { 0.5, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["SCRAP-deactivated"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0.5 }, text = { 0, 1, 0.5 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["TaxiNode_Alliance"] = {
		alpha = 1,
		color = { icon = { 0, 0.5, 1 }, text = { 0, 0, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["TaxiNode_Continent_Alliance"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["TaxiNode_Continent_Horde"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["TaxiNode_Continent_Neutral"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["TaxiNode_Horde"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["TaxiNode_Neutral"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["TaxiNode_Undiscovered"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["UI-QuestPoiRecurring-QuestBang"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["Waypoint-MapPin-Tracked"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["Waypoint-MapPin-Untracked"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["WildBattlePetCapturable"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["delves-bountiful"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["delves-regular"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["poi-hub"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["quest-wrapper-available"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["trading-post-minimap-icon"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
	["worldquest-Capstone-questmarker-epic-Locked"] = {
		alpha = 1,
		color = { icon = { 1, 0, 0 }, text = { 0, 1, 0 } },
		color_icons = true,
		enable = true,
		point = GetTextPosition("TOP"),
		showText = true,
		use_color = true,
	},
}

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
	local info = settings[atlasName]

	-- global
	local icon_scale = 1
	local font = LSM:Fetch("font", E.db.mMT.lfg_invite_info.font.font)
	local fontSize = 10
	local fontFlag = "OUTLINE"

	if not info then
		if frame.mMT_background then frame.mMT_background:Hide() end
		if frame.mMT_label then frame.mMT_label:Hide() end
		print("NOT FOUND", atlasName, info)
		return
	end

	texture:SetScale(icon_scale)

	if info.enable then
		if not frame.mMT_background then frame.mMT_background = frame:CreateTexture() end

		local w, h = texture:GetSize()
		local layer, sublevel = texture:GetDrawLayer()
		frame.mMT_background:SetAtlas(atlasName)
		frame.mMT_background:SetDrawLayer(layer, sublevel - 1)
		frame.mMT_background:SetSize(w, h)
		frame.mMT_background:SetPoint("CENTER", frame, "CENTER", 0, 0)
		frame.mMT_background:SetScale(1.2)
		frame.mMT_background:SetBlendMode("ADD")
		if info.color_icons then
			frame.mMT_background:SetDesaturated(true)
			frame.mMT_background:SetVertexColor(unpack(info.color.icon))
		else
			frame.mMT_background:SetDesaturated(false)
			frame.mMT_background:SetVertexColor(1, 1, 1, 1)
		end
		frame.mMT_background:SetAlpha(1)

		frame.mMT_background:Show()
	elseif frame.mMT_background then
		frame.mMT_background:Hide()
	end

	local labelText = frame.poiInfo and frame.poiInfo.name or frame.name

	if info.showText and (frame.poiInfo or frame.name) then
		if not frame.mMT_label then
			local f = CreateFrame("Frame", "mMT_labelBase", WorldMapFrame)
			local t = f:CreateFontString()
			frame.mMT_label = t
			f:SetParent(WorldMapFrame)
			f:SetFrameStrata("HIGH")
		end
		frame.mMT_label:ClearAllPoints()
		frame.mMT_label:SetPoint(info.point.anchor1, frame, info.point.anchor2, info.point.x, info.point.y)
		frame.mMT_label:SetFont(font, fontSize, fontFlag)
		frame.mMT_label:SetShadowOffset(1, -1)
		frame.mMT_label:Show()
		frame.mMT_label:SetText(labelText)
		frame.mMT_label:SetVertexColor(unpack(info.color.text))
		frame.mMT_label:SetAlpha(1)

		local _, _, _, iconX, iconY = frame:GetPoint(1)

		if iconX and iconY then -- can be nil
			local scale = WorldMapFrame.ScrollContainer.baseScale * frame:GetScale()
			local offsetX, offsetY = GetLabelOffsets(frame, info.point)
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
				--print("ZoomIn")
				module:CheckLabels()
			end)
			hooksecurefunc(WorldMapFrame.ScrollContainer, "ZoomOut", function()
				--print("ZoomOut")
				module:CheckLabels()
			end)
			hooksecurefunc(WorldMapFrame, "Maximize", function()
				--print("Maximize")
				UpdateShow()
			end)
			hooksecurefunc(WorldMapFrame, "Minimize", function()
				--print("Minimize")
				UpdateShow()
			end)
			hooksecurefunc(WorldMapFrame, "ProcessCanvasClickHandlers", function(...)
				--print("ProcessCanvasClickHandlers", ...)
				UpdateShow()
			end)

			module.isHooked = true
		end
	end
end
