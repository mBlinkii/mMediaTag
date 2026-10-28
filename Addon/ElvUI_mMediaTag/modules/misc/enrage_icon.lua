local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("EnrageIcon", { "AceEvent-3.0", "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")
local NP = E:GetModule("NamePlates")
local AuraUtil = _G.AuraUtil
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local GetNamePlates = C_NamePlate.GetNamePlates
local UnitCanAttack = UnitCanAttack

local SortMethod = _G.AuraContainerSortMethod
local SortDirection = _G.AuraContainerSortDirection
local ICON_KEY = "mMT_Enrage"
local HIGHLIGHT_KEY = "mMT_EnrageHighlight"
local DEMO_ICON = 132126 -- Enrage
-- the dispel name of enrages, older clients use an empty string
local ENRAGE = { [""] = true, Enrage = true }
local CANDIDATE = { includeDispelTypes = ENRAGE }
local UNITS = { target = true, focus = true, boss = true, arena = true }
local ENEMY_PLATES = { ENEMY_NPC = true, ENEMY_PLAYER = true }
-- the candidate filter keeps only enrages, GROUP also drops the ones nobody in your group can remove
-- many enemy buffs are flagged for nameplates only and are left out without INCLUDE_NAME_PLATE_ONLY
local FILTERS = E.Modern and { ALL = "HELPFUL|INCLUDE_NAME_PLATE_ONLY", GROUP = "HELPFUL|RAID_PLAYER_DISPELLABLE|INCLUDE_NAME_PLATE_ONLY" }
	or { ALL = "HELPFUL", GROUP = "HELPFUL|RAID_PLAYER_DISPELLABLE" }
local EVENT_UNITS = { PLAYER_TARGET_CHANGED = "target", PLAYER_FOCUS_CHANGED = "focus" }
-- boss and arena units can change while their frames stay shown
local ALL_UNITS = { INSTANCE_ENCOUNTER_ENGAGE_UNIT = true, ARENA_OPPONENT_UPDATE = true }
-- ElvUI keeps one aura container per plate name as well, created before any plate exists
local PLATETOKENS = 40
local FLOW = {
	RIGHT = { anchor = "TOPLEFT", x = 1, y = 0, growth = "RIGHT_DOWN" },
	LEFT = { anchor = "TOPRIGHT", x = -1, y = 0, growth = "LEFT_DOWN" },
	UP = { anchor = "BOTTOMLEFT", x = 0, y = 1, growth = "UP_RIGHT" },
	DOWN = { anchor = "TOPLEFT", x = 0, y = -1, growth = "DOWN_RIGHT" },
}

local Highlight = mMT.FrameHighlight
local DebuffColors = E.Libs.Dispel:GetDebuffTypeColor()
local frames, plates = {}, {}

-- enemy unitframes and nameplates have their own settings, and only count while ElvUI has them on
local function UnitDB(frame)
	if not frame then return end

	local units = E.db.mMediaTag.enrage_icon.units
	local db, elvui
	if frame.isNameplate then
		db = units.nameplate
		elvui = E.private.nameplates.enable and ENEMY_PLATES[frame.frameType]
	else
		local unit = UNITS[frame.unitframeType] and frame.unitframeType
		local config = unit and E.db.unitframe.units[unit]
		db = unit and units[unit]
		elvui = config and config.enable
	end

	return db and db.enable and elvui and db or nil
end

local function HighlightDB(db)
	return db and db.highlight.enable and db.highlight or nil
end

-- target and focus can be friendly, enrages only matter on units you can attack
local function Allowed(db, unit)
	return (db and unit and UnitCanAttack("player", unit)) or false
end

local function Flow(db)
	return FLOW[db.growth] or FLOW.RIGHT
end

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

-- spell icon in a pixel border of the enrage color, the swipe shows the remaining time
local function StyleIcon(owner)
	local border = owner:CreateTexture(nil, "BACKGROUND")
	border:SetTexture(E.media.blankTex)
	border:SetAllPoints()

	local icon = owner:CreateTexture(nil, "ARTWORK")
	icon:SetInside(owner, E.mult, E.mult, nil, true)
	icon:SetTexCoord(unpack(E.TexCoords))

	local cooldown = CreateFrame("Cooldown", nil, owner, "CooldownFrameTemplate")
	cooldown:SetAllPoints(icon)
	cooldown:SetReverse(true)
	cooldown:SetHideCountdownNumbers(true)

	owner.mMT_Border, owner.mMT_Icon, owner.mMT_Cooldown = border, icon, cooldown
end

local function ColorIcon(owner)
	local color = DebuffColors.Enrage
	owner.mMT_Border:SetVertexColor(color.r, color.g, color.b, 1)
end

local function RaisedParent(frame)
	return frame.RaisedElementParent or frame.RaisedElement or frame
end

-- plain icons for classic and the demo, the demo passes no auras and fills the row
local function FillRow(frame, entry, db, auras)
	HideAll(entry.icons)
	if not db.showIcons then return end

	local flow = Flow(db)
	for index = 1, math.min(auras and #auras or db.count, db.count) do
		local icon = entry.icons[index]
		if not icon then
			icon = CreateFrame("Frame", nil, entry.holder)
			StyleIcon(icon)
			entry.icons[index] = icon
		end

		local aura = auras and auras[index]
		local step = (index - 1) * (db.size + db.spacing)
		icon:ClearAllPoints()
		icon:SetPoint(flow.anchor, entry.holder, flow.anchor, flow.x * step, flow.y * step)
		icon:SetSize(db.size, db.size)
		icon.mMT_Icon:SetTexture(aura and aura.icon or DEMO_ICON)
		ColorIcon(icon)

		if aura and aura.duration and aura.duration > 0 then
			icon.mMT_Cooldown:SetCooldown(aura.expirationTime - aura.duration, aura.duration)
		else
			icon.mMT_Cooldown:Clear()
		end

		icon:Show()
	end
end

local function GetPlainEntry(frame, key)
	local entry = frame[key]
	if not entry then
		local parent = RaisedParent(frame)
		local owner = CreateFrame("Frame", nil, parent)
		owner:SetAllPoints(frame)

		local holder = CreateFrame("Frame", nil, parent)
		-- the nameplate health bar sits above the raised element, the aura level is above it
		local level = frame.isNameplate and frame.RaisedElement and frame.RaisedElement.AuraLevel
		if level then
			owner:SetFrameLevel(level + 1)
			holder:SetFrameLevel(level + 1)
		end

		entry = { holder = holder, icons = {}, highlight = Highlight.Create(owner) }
		frame[key] = entry
	end

	return entry
end

-- a plate can be unmeasured when the highlight is set up, its health bar and the plate itself have a fixed size
local function PlateSize(frame, highlight)
	if not frame.isNameplate then return end
	if highlight.target == "FRAME" then return frame:GetSize() end

	local width, height = frame.Health:GetSize()
	local border = frame.Health.backdrop and 2 * E:Scale(UF.BORDER or 1) or 0
	return width + border, height + border
end

local function SetupPlainEntry(entry, frame, db)
	SetupHolder(entry.holder, frame, db)

	local highlight = HighlightDB(db)
	if highlight then Highlight.Anchor(entry.highlight, frame, highlight, PlateSize(frame, highlight)) end
end

-- retail: own aura containers like the dispel icon module, only Blizzard aura buttons can read the secret auras
local buttons, highlightButtons = {}, {}

local function ApplyButton(button, container)
	local db = UnitDB(container.mMT_Frame)
	if not db then return end

	button:SetSize(db.size, db.size)
	ColorIcon(button)
end

local function InitializeButton(container, button)
	button:EnableMouse(false)
	StyleIcon(button)
	button:SetIcon(button.mMT_Icon)
	button:SetDurationCooldown(button.mMT_Cooldown)

	buttons[button] = container
	ApplyButton(button, container)
end

-- only enrages pass the filter, so the parts keep a fixed color and show with the slot button
local function ApplyHighlightButton(button, parts)
	local frame = parts.container.mMT_Frame
	local highlight = HighlightDB(UnitDB(frame))
	if not highlight then return end

	button:SetAllPoints(frame)
	button:ClearAuraShownAnimations()
	Highlight.Anchor(parts, frame, highlight, PlateSize(frame, highlight))
	Highlight.Show(parts, highlight, DebuffColors.Enrage, true)

	-- hiding the button stops the pixel glow, the button starts it again on every new enrage
	if highlight.glow == "PIXEL" then button:AddAuraShownAnimation(parts.pixel) end
end

local function InitializeHighlightButton(container, button)
	button:EnableMouse(false)

	local parts = Highlight.Create(button)
	parts.container = container
	container.mMT_HighlightButton = button
	highlightButtons[button] = parts
	ApplyHighlightButton(button, parts)
end

local function UpdateButtons()
	if E:IsRestrictedAuras() then return end

	for button, container in next, buttons do
		ApplyButton(button, container)
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
			candidateFilters = CANDIDATE,
			maxFrameCount = count,
			sortMethod = SortMethod.Default,
			sortDirection = SortDirection.Normal,
			layout = layout,
		})

		container.known[ICON_KEY] = filter
	end
end

-- one slot for the frame highlight, an empty filter switches it off
local function SetupHighlight(container, db, filter)
	local highlight = HighlightDB(db)
	local slotFilter = highlight and filter or ""

	if container.known[HIGHLIGHT_KEY] then
		container:SetAuraSlotFilterString(HIGHLIGHT_KEY, slotFilter)
		container:SetAuraSlotCandidateFilters(HIGHLIGHT_KEY, CANDIDATE)
	elseif highlight then
		container:AddAuraSlot(HIGHLIGHT_KEY, slotFilter, {
			initializeFrame = function(button)
				InitializeHighlightButton(container, button)
			end,
			candidateFilters = CANDIDATE,
		})

		container.known[HIGHLIGHT_KEY] = slotFilter
	end
end

local function SetupContainer(container)
	container.mMT_Pending = nil

	local db = UnitDB(container.mMT_Frame)
	if not db then return end

	local filter = FILTERS[db.source] or FILTERS.GROUP
	container.mMT_Icons.filter = filter

	SetupIcons(container, db, filter)
	SetupHighlight(container, db, filter)

	local button = container.mMT_HighlightButton
	if button and not E:IsRestrictedAuras() then ApplyHighlightButton(button, highlightButtons[button]) end
end

-- ElvUI only fills its containers once they are shown
local function OnContainerShow(container)
	if container.mMT_Pending then SetupContainer(container) end
end

-- no unitframeType on the parent, so ElvUI adds no events of its own
local function CreateContainer(parent)
	local container = E:Auras_Create(parent, "mMT_Enrage")
	container.mMT_Icons = { candidateFilters = CANDIDATE }
	hooksecurefunc(container, "Show", OnContainerShow)

	return container
end

-- nameplates have no shown state, ElvUI then checks the parent which is the plate
local function Refresh(container)
	local frame = container.mMT_Frame
	local unit = frame.__unit

	container.allowEnable = Allowed(UnitDB(frame), unit)
	E:Auras_SetUnit(container, unit)
	E:Auras_AssistUnit(container, unit, frame.hasAurasShown)
end

local function UpdateContainer(container)
	local frame = container.mMT_Frame
	local db = UnitDB(frame)
	if db then
		container.mMT_Pending = true
		SetupHolder(container, frame, db)
	end

	Refresh(container)
	if container.mMT_Pending and container:IsShown() then SetupContainer(container) end
end

-- classic: no secrets, so a plain aura loop
local auras = {}
local function CollectAura(aura)
	if aura and ENRAGE[aura.dispelName] then tinsert(auras, aura) end
end

local function UpdateClassic(frame)
	local entry = GetPlainEntry(frame, "mMT_EnrageClassic")
	local db = UnitDB(frame)
	local unit = frame.__unit

	wipe(auras)
	if Allowed(db, unit) then
		SetupPlainEntry(entry, frame, db)
		AuraUtil.ForEachAura(unit, FILTERS[db.source] or FILTERS.GROUP, nil, CollectAura, true)
	end

	if db then
		FillRow(frame, entry, db, auras)
	else
		HideAll(entry.icons)
	end

	Highlight.Show(entry.highlight, HighlightDB(db), auras[1] and DebuffColors.Enrage)
end

local function UpdateDemo(frame)
	if not (module.demoActive or frame.mMT_EnrageDemo) then return end

	-- nothing may anchor to an aura container, so the demo mirrors the row on a plain frame
	local entry = GetPlainEntry(frame, "mMT_EnrageDemo")
	local db = module.demoActive and UnitDB(frame)
	if db then
		SetupPlainEntry(entry, frame, db)
		FillRow(frame, entry, db)
	else
		HideAll(entry.icons)
	end

	Highlight.Show(entry.highlight, HighlightDB(db), DebuffColors.Enrage)
end

local function UpdatePlate(frame)
	local container = plates[frame:GetName()]
	if not E.Modern then
		UpdateClassic(frame)
	elseif container then
		container.mMT_Frame = frame
		container:SetParent(frame)
		container:SetFrameLevel((frame.RaisedElement and frame.RaisedElement.AuraLevel or frame:GetFrameLevel()) + 1)
		UpdateContainer(container)
	end

	UpdateDemo(frame)
end

local function HidePlate(frame)
	local container = plates[frame:GetName()]
	if container then
		container.allowEnable = false
		E:Auras_GroupUnit(container)
	end

	local entry = frame.mMT_EnrageClassic
	if entry then
		HideAll(entry.icons)
		Highlight.Show(entry.highlight)
	end
end

local function UpdateUnitframe(frame)
	if not (frame and UNITS[frame.unitframeType] and frame.Health) or frame.isNameplate then return end

	frames[frame] = true
	if E.Modern then
		local container = frame.mMT_EnrageContainer
		if not container and UnitDB(frame) then
			container = CreateContainer(CreateFrame("Frame", nil, frame))
			container.mMT_Frame = frame
			container:SetFrameLevel((frame.RaisedElementParent and frame.RaisedElementParent.AuraWatchLevel or frame:GetFrameLevel()) + 1)
			frame.mMT_EnrageContainer = container
		end

		if container then UpdateContainer(container) end
	else
		UpdateClassic(frame)
	end

	UpdateDemo(frame)
end

local function ForEachPlate(callback)
	if not E.private.nameplates.enable then return end

	for _, plate in ipairs(GetNamePlates()) do
		local frame = plate.unitFrame
		if frame and frame.isNameplate and frame.__unit then callback(frame) end
	end
end

local function PlateByUnit(unit)
	local success, plate = pcall(GetNamePlateForUnit, unit)
	local frame = success and plate and plate.unitFrame
	return frame and frame.isNameplate and frame or nil
end

local function RefreshUnitframe(frame)
	if not E.Modern then
		UpdateClassic(frame)
	elseif frame.mMT_EnrageContainer then
		Refresh(frame.mMT_EnrageContainer)
	end
end

-- a unit changed who it is or whether you can attack it, without unit every frame updates
local function UpdateUnit(unit)
	for frame in next, frames do
		if not unit or frame.__unit == unit then RefreshUnitframe(frame) end
	end

	local plate = unit and strmatch(unit, "^nameplate") and PlateByUnit(unit)
	if plate then UpdatePlate(plate) end
end

function module:OnEvent(event, unit)
	if event == "NAME_PLATE_UNIT_REMOVED" then
		local plate = PlateByUnit(unit)
		if plate then HidePlate(plate) end
	elseif ALL_UNITS[event] then
		UpdateUnit()
	else
		UpdateUnit(EVENT_UNITS[event] or unit)
	end
end

local function HookConfigClose()
	local ACD = E.Libs.AceConfigDialog
	local config = ACD and ACD.OpenFrames and ACD.OpenFrames.ElvUI
	if not (config and config.frame) or module.configHooked == config.frame then return end

	module.configHooked = config.frame
	config.frame:HookScript("OnHide", function()
		if module.demoActive then module:ToggleDemo() end
	end)
end

function module:ToggleDemo()
	module.demoActive = not module.demoActive and E.db.mMediaTag.enrage_icon.enable
	if module.demoActive then HookConfigClose() end

	for frame in next, frames do
		UpdateDemo(frame)
	end
	ForEachPlate(UpdateDemo)
end

function module:Initialize()
	if not E.db.mMediaTag.enrage_icon.enable then return end

	if not module.isEnabled then
		module:SecureHook(UF, "ConfigureFrame", function(_, frame)
			UpdateUnitframe(frame)
		end)

		if E.Modern then
			-- unit changes and the shown state of the unitframe
			for _, method in ipairs({ "Configure_UnitAuras", "Auras_ToggleContainer" }) do
				module:SecureHook(UF, method, function(_, frame)
					if frame then RefreshUnitframe(frame) end
				end)
			end
		end

		if E.private.nameplates.enable then
			-- runs on every new unit and faction change once the plate knows if it is an enemy
			module:SecureHook(NP, "UpdatePlateType", function(_, frame)
				if frame and frame.isNameplate and frame ~= NP.TestFrame then UpdatePlate(frame) end
			end)

			module:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "OnEvent")
		end

		if not E.Modern then module:RegisterEvent("UNIT_AURA", "OnEvent") end
		module:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
		module:RegisterEvent("UNIT_FACTION", "OnEvent")
		if mMT.Supports.focus then module:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnEvent") end
		if E.Retail or E.Mists then
			module:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "OnEvent")
			module:RegisterEvent("ARENA_OPPONENT_UPDATE", "OnEvent")
		end

		module.isEnabled = true
	end

	if E.Modern and E.private.nameplates.enable and not module.plateHolder then
		module.plateHolder = CreateFrame("Frame")
		for index = 1, PLATETOKENS do
			plates["ElvNP_NamePlate" .. index] = CreateContainer(module.plateHolder)
		end
	end

	mMT:ForEachUFFrame(UpdateUnitframe)
	ForEachPlate(UpdatePlate)
	if E.Modern then UpdateButtons() end
end
