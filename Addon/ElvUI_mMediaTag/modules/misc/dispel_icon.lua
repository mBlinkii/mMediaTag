local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("DispelIcon", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")
local AuraUtil = _G.AuraUtil

local DispelTypeTextureStyle = Enum.CustomAuraButtonDispelTypeTextureStyle
local SortMethod = _G.AuraContainerSortMethod
local SortDirection = _G.AuraContainerSortDirection
local ICON_OPTIONS = { style = DispelTypeTextureStyle and DispelTypeTextureStyle.Icon }
-- keeps our white border and glow textures and tints them in ElvUIs color of the dispel type
local COLOR_OPTIONS = { style = DispelTypeTextureStyle and DispelTypeTextureStyle.PreserveAsset, customDispelColorMap = {} }
local ICON_KEY = "mMT_Dispel"
local HIGHLIGHT_KEY = "mMT_DispelHighlight"
local TYPES = { "Magic", "Curse", "Disease", "Poison", "Bleed" }
local ICON_ATLAS = {
	Magic = "RaidFrame-Icon-DebuffMagic",
	Curse = "RaidFrame-Icon-DebuffCurse",
	Disease = "RaidFrame-Icon-DebuffDisease",
	Poison = "RaidFrame-Icon-DebuffPoison",
	Bleed = "RaidFrame-Icon-DebuffBleed",
}
local GLOWPARTS = { "TopLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner", "TopEdge", "BottomEdge", "LeftEdge", "RightEdge" }
-- the two corners every border edge spans
local BORDER_EDGES = {
	{ "TOPLEFT", "TOPRIGHT", horizontal = true },
	{ "BOTTOMLEFT", "BOTTOMRIGHT", horizontal = true },
	{ "TOPLEFT", "BOTTOMLEFT" },
	{ "TOPRIGHT", "BOTTOMRIGHT" },
}
-- the pixel glow: running lines around the target, every edge runs clockwise from its anchor corner
local PIXEL_EDGES = {
	{ anchor = "TOPLEFT", x = 1, y = 0, horizontal = true },
	{ anchor = "TOPRIGHT", x = 0, y = -1 },
	{ anchor = "BOTTOMRIGHT", x = -1, y = 0, horizontal = true },
	{ anchor = "BOTTOMLEFT", x = 0, y = 1 },
}
local PIXEL_PER_EDGE = 8
-- speed 1 needs PIXEL_LAP seconds per lap, every step makes it faster
local PIXEL_LAP = 16
-- start corner of the row and the step per icon, the retail flow layout uses the matching ElvUI growth key
local FLOW = {
	RIGHT = { anchor = "TOPLEFT", x = 1, y = 0, growth = "RIGHT_DOWN" },
	LEFT = { anchor = "TOPRIGHT", x = -1, y = 0, growth = "LEFT_DOWN" },
	UP = { anchor = "BOTTOMLEFT", x = 0, y = 1, growth = "UP_RIGHT" },
	DOWN = { anchor = "TOPLEFT", x = 0, y = -1, growth = "DOWN_RIGHT" },
}

local DispelTypes = E.Libs.Dispel:GetMyDispelTypes()
local DebuffColors = E.Libs.Dispel:GetDebuffTypeColor()
local mine, every, ordered = {}, {}, {}
local numMine = 0

for _, dispelType in ipairs(TYPES) do
	every[dispelType] = true
end

-- your types and their order (yours first) follow the spec, the colors follow ElvUIs debuff color settings
local function RefreshTypes()
	wipe(mine)
	wipe(ordered)
	wipe(COLOR_OPTIONS.customDispelColorMap)
	numMine = 0

	for _, dispelType in ipairs(TYPES) do
		local color = DebuffColors[dispelType]
		if color then COLOR_OPTIONS.customDispelColorMap[dispelType] = { r = color.r, g = color.g, b = color.b } end

		if DispelTypes[dispelType] then
			mine[dispelType] = true
			numMine = numMine + 1
			tinsert(ordered, numMine, dispelType)
		else
			tinsert(ordered, dispelType)
		end
	end
end

-- every unitframe type has its own settings, and only counts while ElvUI has that unitframe on
local function UnitDB(frame)
	local unit = frame and frame.unitframeType
	local db = unit and E.db.mMediaTag.dispel_icon.units[unit]
	local elvui = unit and E.db.unitframe.units[unit]
	return db and db.enable and elvui and elvui.enable and db or nil
end

local function HighlightDB(db)
	return db and db.highlight.enable and db.highlight or nil
end

-- unitframes only, never nameplates
local function IsUnitframe(frame)
	return frame and frame.Health and frame.unitframeType and not frame.isNameplate
end

local function Flow(db)
	return FLOW[db.growth] or FLOW.RIGHT
end

-- the holder always spans the full row, so the demo matches the real icons
local function SetupHolder(holder, frame, db)
	local horizontal = Flow(db).x ~= 0
	local length = db.count * db.size + (db.count - 1) * db.spacing

	holder:ClearAllPoints()
	holder:SetPoint(db.point, frame.Health, db.point, db.x, db.y)
	holder:SetSize(horizontal and length or db.size, horizontal and db.size or length)
end

local function HideAll(list)
	for _, region in next, list do
		region:Hide()
	end
end

-- plain icons for classic and the demo, your types first, the others only when the row shows every type
local function FillRow(frame, list, holder, db, present, withOthers)
	HideAll(list)
	if not db.showIcons then return end

	local flow, index = Flow(db), 0
	for _, dispelType in ipairs(ordered) do
		if index == db.count then break end

		if (withOthers or mine[dispelType]) and (not present or present[dispelType]) then
			local icon = list[dispelType]
			if not icon then
				icon = (frame.RaisedElementParent or frame):CreateTexture(nil, "OVERLAY", nil, 7)
				icon:SetAtlas(ICON_ATLAS[dispelType])
				list[dispelType] = icon
			end

			local step = index * (db.size + db.spacing)
			icon:ClearAllPoints()
			icon:SetPoint(flow.anchor, holder, flow.anchor, flow.x * step, flow.y * step)
			icon:SetSize(db.size, db.size)
			icon:Show()

			index = index + 1
		end
	end
end

-- frame highlight: a colored border, an ElvUI shadow glow or a pixel glow around the health bar or the whole unitframe
local function HighlightTarget(frame, highlight)
	if highlight.target == "FRAME" then return frame end
	return frame.Health.backdrop or frame.Health
end

local function CreateLine(parent)
	local line = parent:CreateTexture(nil, "OVERLAY", nil, 7)
	line:SetTexture(E.media.blankTex)
	line:Hide()
	return line
end

-- aura buttons run no scripts and take no reparented frames, so the pixel glow is built from plain animations, the same on buttons and plain frames
local function CreateHighlightParts(owner)
	local parts = { edges = {}, segments = {}, moves = {}, used = {} }
	for index = 1, #BORDER_EDGES do
		parts.edges[index] = CreateLine(owner)
	end

	parts.glow = owner:CreateShadow(nil, true)
	parts.glow:Hide()

	-- the lines run inside a clipped frame, so they leave at one corner and come back at the next edge
	parts.clip = CreateFrame("Frame", nil, owner)
	parts.clip:SetClipsChildren(true)
	parts.pixel = parts.clip:CreateAnimationGroup()
	parts.pixel:SetLooping("REPEAT")

	for edge = 1, #PIXEL_EDGES do
		for slot = 0, PIXEL_PER_EDGE - 1 do
			local segment = CreateLine(parts.clip)
			segment.edge, segment.slot = PIXEL_EDGES[edge], slot

			local move = parts.pixel:CreateAnimation("Translation")
			move:SetTarget(segment)

			tinsert(parts.segments, segment)
			tinsert(parts.moves, move)
		end
	end

	return parts
end

-- the lines sit one spacing apart and move by exactly one spacing per loop, so the loop is seamless
local function AnchorPixel(parts, target, highlight, width, height)
	parts.clip:ClearAllPoints()
	parts.clip:SetAllPoints(target)

	if not width then
		width, height = target:GetSize()
	end
	local size = highlight.pixelSize * E.mult
	local spacing = 2 * (width + height) / highlight.pixelLines
	-- every line covers half of its spacing
	local length = math.max(spacing * 0.5, 1)
	local duration = PIXEL_LAP / highlight.pixelSpeed / highlight.pixelLines

	wipe(parts.used)
	for index, segment in ipairs(parts.segments) do
		local edge = segment.edge
		local position = (segment.slot - 1) * spacing

		segment:ClearAllPoints()
		segment:SetPoint(edge.anchor, parts.clip, edge.anchor, edge.x * position, edge.y * position)
		segment:SetSize(edge.horizontal and length or size, edge.horizontal and size or length)
		parts.moves[index]:SetOffset(edge.x * spacing, edge.y * spacing)
		parts.moves[index]:SetDuration(duration)

		if segment.slot <= math.ceil((edge.horizontal and width or height) / spacing) then parts.used[segment] = true end
	end
end

local function AnchorHighlightParts(parts, frame, highlight, width, height)
	local target = HighlightTarget(frame, highlight)

	for index, edge in ipairs(BORDER_EDGES) do
		local line = parts.edges[index]
		line:ClearAllPoints()
		line:SetPoint(edge[1], target, edge[1])
		line:SetPoint(edge[2], target, edge[2])
		if edge.horizontal then
			line:SetHeight(E.mult)
		else
			line:SetWidth(E.mult)
		end
	end

	-- same outset as ElvUIs own CreateShadow
	local offset = E.PixelMode and 3 or 4
	parts.glow:ClearAllPoints()
	parts.glow:SetOutside(target, offset, offset, nil, true)
	parts.glow:SetupTextureCoordinates()

	AnchorPixel(parts, target, highlight, width, height)
end

-- plain parts for classic and the demo, colored directly, the glow uses its own color unless it should follow the debuff type
local function ShowPlainHighlight(parts, highlight, color, buttonAnimated)
	color = highlight and color
	local glowColor = color and (highlight.glowDebuffColor and color or highlight.glowColor)
	local pixel = color and highlight.glow == "PIXEL"

	for _, edge in ipairs(parts.edges) do
		if color then edge:SetVertexColor(color.r, color.g, color.b, 1) end
		edge:SetShown(color and highlight.border or false)
	end

	if glowColor then parts.glow:SetBackdropBorderColor(glowColor.r, glowColor.g, glowColor.b, 0.9) end
	parts.glow:SetShown(color and highlight.glow == "GLOW" or false)

	for _, segment in ipairs(parts.segments) do
		local shown = pixel and parts.used[segment] or false
		if shown then segment:SetVertexColor(glowColor.r, glowColor.g, glowColor.b, 1) end
		segment:SetShown(shown)
	end

	-- an aura button that owns the animation forbids querying it
	if buttonAnimated then
		return
	elseif not pixel then
		parts.pixel:Stop()
	elseif not parts.pixel:IsPlaying() then
		parts.pixel:Play()
	end
end

-- shared with the enrage icon module
mMT.FrameHighlight = { Create = CreateHighlightParts, Anchor = AnchorHighlightParts, Show = ShowPlainHighlight }
mMT.AuraIconRow = { DB = HighlightDB, Flow = Flow, SetupHolder = SetupHolder, HideAll = HideAll }

-- icons and highlight for classic and the demo on plain frames
local function GetPlainEntry(frame, key)
	local entry = frame[key]
	if not entry then
		local parent = frame.RaisedElementParent or frame
		local owner = CreateFrame("Frame", nil, parent)
		owner:SetAllPoints(frame)

		entry = { holder = CreateFrame("Frame", nil, parent), icons = {}, highlight = CreateHighlightParts(owner) }
		frame[key] = entry
	end

	return entry
end

local function SetupPlainEntry(entry, frame, db)
	SetupHolder(entry.holder, frame, db)

	local highlight = HighlightDB(db)
	if highlight then AnchorHighlightParts(entry.highlight, frame, highlight) end
end

-- retail: one own aura container per unitframe set up like ElvUIs containers, only Blizzard aura buttons can resolve the secret dispel type
local buttons, highlightButtons = {}, {}

-- the flow layout only arranges the buttons, ElvUI sizes its own buttons too
local function ApplyButton(button, info)
	local db = UnitDB(info.container.mMT_Frame)
	if not db then return end

	button:SetSize(db.size, db.size)
	button:ClearDispelTypeTextures()
	button:AddDispelTypeTexture(info.icon, ICON_OPTIONS)
end

local function InitializeButton(container, button)
	button:EnableMouse(false)

	local icon = button:CreateTexture(nil, "OVERLAY", nil, 7)
	icon:SetAllPoints()

	local info = { container = container, icon = icon }
	buttons[button] = info
	ApplyButton(button, info)
end

-- a fixed glow color goes through Blizzards color map as well, every dispel type just gets the same color
local function GlowOptions(parts, highlight)
	if highlight.glowDebuffColor then return COLOR_OPTIONS end

	local options = parts.glowOptions
	if not options then
		options = { style = COLOR_OPTIONS.style, customDispelColorMap = {} }
		parts.glowOptions = options
	end

	local color = { r = highlight.glowColor.r, g = highlight.glowColor.g, b = highlight.glowColor.b }
	for _, dispelType in ipairs(TYPES) do
		options.customDispelColorMap[dispelType] = color
	end
	options.customDispelColorMap.None = color

	return options
end

-- the highlight parts belong to the slot button, so they only show while it holds a debuff
local function ApplyHighlightButton(button, parts)
	local frame = parts.container.mMT_Frame
	local highlight = HighlightDB(UnitDB(frame))
	if not highlight then return end

	button:ClearDispelTypeTextures()
	button:ClearAuraShownAnimations()
	AnchorHighlightParts(parts, frame, highlight)

	for _, edge in ipairs(parts.edges) do
		if highlight.border then button:AddDispelTypeTexture(edge, COLOR_OPTIONS) end
		edge:SetShown(highlight.border)
	end

	local glowOptions = GlowOptions(parts, highlight)
	local glow = highlight.glow == "GLOW"
	if glow then
		for _, piece in ipairs(GLOWPARTS) do
			button:AddDispelTypeTexture(parts.glow[piece], glowOptions)
		end
	end
	parts.glow:SetShown(glow)

	-- the button starts the pixel glow whenever it gets a debuff and stops it again
	local pixel = highlight.glow == "PIXEL"
	for _, segment in ipairs(parts.segments) do
		local shown = pixel and parts.used[segment] or false
		if shown then button:AddDispelTypeTexture(segment, glowOptions) end
		segment:SetShown(shown)
	end
	if pixel then button:AddAuraShownAnimation(parts.pixel) end
end

local function InitializeHighlightButton(container, button)
	button:EnableMouse(false)
	button:SetAllPoints(container.mMT_Frame)

	local parts = CreateHighlightParts(button)
	parts.container = container
	container.mMT_HighlightButton = button
	highlightButtons[button] = parts
	ApplyHighlightButton(button, parts)
end

local function UpdateButtons()
	if E:IsRestrictedAuras() then return end

	for button, info in next, buttons do
		ApplyButton(button, info)
	end

	for button, parts in next, highlightButtons do
		ApplyHighlightButton(button, parts)
	end
end

local function SetupIcons(container, db, filter)
	local flow = Flow(db)
	container.size = db.size
	container.spacing = db.spacing
	container.lineSpacing = db.spacing
	container.growthDirection = flow.growth
	container.useWidth = flow.x ~= 0
	container.numAuras = db.count
	-- no buttons keeps only the frame highlight
	local count = db.showIcons and db.count or 0

	local layout = E:Auras_UpdateLayout(container)
	E:Auras_SetFlowLayout(container)
	E:Auras_SetLineSize(container)

	if container.known[ICON_KEY] then
		E:Auras_UpdateGroup(container, ICON_KEY, container.mMT_Icons, layout, count, SortMethod.Default, SortDirection.Normal)
	else
		container:AddAuraGroup(ICON_KEY, filter, {
			initializeFrame = function(button)
				InitializeButton(container, button)
			end,
			candidateFilters = container.mMT_Icons.candidateFilters,
			maxFrameCount = count,
			sortMethod = SortMethod.Default,
			sortDirection = SortDirection.Normal,
			layout = layout,
		})

		container.known[ICON_KEY] = filter
	end
end

-- one slot like ElvUIs dispel highlight, an empty filter switches it off
local function SetupHighlight(container, db, filter)
	local highlight = HighlightDB(db)
	local slotFilter = highlight and filter or ""
	local candidate = container.mMT_Icons.candidateFilters

	if container.known[HIGHLIGHT_KEY] then
		container:SetAuraSlotFilterString(HIGHLIGHT_KEY, slotFilter)
		container:SetAuraSlotCandidateFilters(HIGHLIGHT_KEY, candidate)
	elseif highlight then
		container:AddAuraSlot(HIGHLIGHT_KEY, slotFilter, {
			initializeFrame = function(button)
				InitializeHighlightButton(container, button)
			end,
			candidateFilters = candidate,
		})

		container.known[HIGHLIGHT_KEY] = slotFilter
	end
end

local function SetupContainer(container)
	container.mMT_Pending = nil

	local db = UnitDB(container.mMT_Frame)
	if not db then return end

	-- "ALL" swaps the filter, the same container then shows every dispel type
	local all = db.source == "ALL"
	local filter = all and "HARMFUL" or "HARMFUL|DISPELLABLE"
	local data = container.mMT_Icons
	data.filter = filter
	wipe(data.candidateFilters.includeDispelTypes)
	for dispelType in next, all and every or mine do
		data.candidateFilters.includeDispelTypes[dispelType] = true
	end

	SetupIcons(container, db, filter)
	SetupHighlight(container, db, filter)

	-- the pixel glow follows the size of its target, ElvUI can resize the frame at any time
	local button = container.mMT_HighlightButton
	if button and not E:IsRestrictedAuras() then ApplyHighlightButton(button, highlightButtons[button]) end
end

-- ElvUI only fills its containers once they are shown
local function OnContainerShow(container)
	if container.mMT_Pending then SetupContainer(container) end
end

local function CreateContainer(frame)
	-- built like ElvUIs dispel highlight, isHighlight limits it to units you can assist
	local holder = CreateFrame("Frame", nil, frame)
	holder.unitframeType = frame.unitframeType
	holder.isHighlight = true

	local container = E:Auras_Create(holder, "mMT_Dispel")
	container.isHighlight = true
	container.mMT_Frame = frame
	container.mMT_Icons = { candidateFilters = { includeDispelTypes = {} } }
	container:SetFrameLevel((frame.RaisedElementParent and frame.RaisedElementParent.AuraWatchLevel or frame:GetFrameLevel()) + 1)
	hooksecurefunc(container, "Show", OnContainerShow)

	return container
end

local function UpdateContainer(frame, db)
	local container = frame.mMT_DispelContainer

	-- a unit switched off drops what it already has
	if not db then
		if container then
			container.allowEnable = false
			E:Auras_GroupUnit(container, frame.__unit)
		end

		return
	end

	if not container then
		container = CreateContainer(frame)
		frame.mMT_DispelContainer = container
	end

	container.allowEnable = db.source == "ALL" or numMine > 0
	container.mMT_Pending = true
	SetupHolder(container, frame, db)

	if frame.hasAurasShown ~= nil then
		E:Auras_ToggleActive(container, frame.__unit, frame.hasAurasShown)
	else
		E:Auras_GroupUnit(container, frame.__unit)
	end

	if container:IsShown() then SetupContainer(container) end
end

-- classic: no secrets, so the row closes up without gaps
local found = {}
local function CollectAura(aura)
	local dispelType = aura and aura.dispelName
	if dispelType then found[dispelType] = true end
end

-- your types win the frame highlight
local function FirstFound(withOthers)
	for _, dispelType in ipairs(ordered) do
		if found[dispelType] and (withOthers or mine[dispelType]) then return dispelType end
	end
end

local function PostUpdate_AuraHighlight(_, frame, unit)
	local entry = frame.mMT_DispelClassic
	if not entry then return end

	local db = UnitDB(frame)
	if not db then
		HideAll(entry.icons)
		ShowPlainHighlight(entry.highlight)
		return
	end

	wipe(found)
	if unit and UnitCanAssist("player", unit) then AuraUtil.ForEachAura(unit, "HARMFUL", nil, CollectAura, true) end

	local all = db.source == "ALL"
	local dispelType = FirstFound(all)
	FillRow(frame, entry.icons, entry.holder, db, found, all)
	ShowPlainHighlight(entry.highlight, HighlightDB(db), dispelType and DebuffColors[dispelType])
end

local function UpdateClassic(frame, db)
	local entry = GetPlainEntry(frame, "mMT_DispelClassic")
	if db then
		SetupPlainEntry(entry, frame, db)
	else
		HideAll(entry.icons)
		ShowPlainHighlight(entry.highlight)
	end

	-- ElvUI snapshots PostUpdate on the element at construction, hooking the UF table does nothing
	local highlight = frame.AuraHighlight
	if highlight and highlight.PostUpdate and not highlight.mMT_DispelHooked then
		hooksecurefunc(highlight, "PostUpdate", PostUpdate_AuraHighlight)
		highlight.mMT_DispelHooked = true
	end
end

-- plain icons and highlight of their own, the real ones belong to the aura buttons and cannot be forced on
local function UpdateDemo(frame)
	if not (module.demoActive or frame.mMT_DispelDemo) then return end

	-- nothing may anchor to an aura container, so the demo mirrors the row on a plain frame
	local entry = GetPlainEntry(frame, "mMT_DispelDemo")
	local db = module.demoActive and UnitDB(frame)
	if db then
		SetupPlainEntry(entry, frame, db)
		-- other types fill the row up, so its full size is visible
		FillRow(frame, entry.icons, entry.holder, db, nil, true)
	else
		HideAll(entry.icons)
	end

	ShowPlainHighlight(entry.highlight, HighlightDB(db), DebuffColors.Magic)
end

local function UpdateFrame(frame)
	if not IsUnitframe(frame) then return end

	local db = UnitDB(frame)
	if E.Modern then
		UpdateContainer(frame, db)
	else
		UpdateClassic(frame, db)
	end

	UpdateDemo(frame)
end

local function OnConfigClose()
	if module.demoActive then module:ToggleDemo() end
end

function module:ToggleDemo()
	module.demoActive = not module.demoActive and E.db.mMediaTag.dispel_icon.enable
	if module.demoActive then mMT:HookConfigClose(OnConfigClose) end

	mMT:ForEachUFFrame(function(frame)
		if IsUnitframe(frame) then UpdateDemo(frame) end
	end)
end

function module:Initialize()
	if not E.db.mMediaTag.dispel_icon.enable then return end

	RefreshTypes()

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_AuraHighlight", function(_, frame)
			UpdateFrame(frame)
		end)

		if E.Modern then
			-- the same unit and visibility updates ElvUI gives its own unitframe containers
			module:SecureHook(UF, "Configure_UnitAuras", function(_, frame, unit)
				local container = frame and frame.mMT_DispelContainer
				if container then E:Auras_GroupUnit(container, unit) end
			end)

			module:SecureHook(UF, "Auras_ToggleContainer", function(_, frame, unit, shown)
				local container = frame and frame.mMT_DispelContainer
				if container then E:Auras_ToggleActive(container, unit, shown) end
			end)

			-- a spec or talent change can add or drop dispel types
			module:SecureHook(E, "Auras_DispelUpdated", function()
				RefreshTypes()
				mMT:ForEachUFFrame(UpdateFrame)
			end)
		end

		module.isEnabled = true
	end

	mMT:ForEachUFFrame(UpdateFrame)
	if E.Modern then UpdateButtons() end
end
