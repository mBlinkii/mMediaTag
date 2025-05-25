local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("Portraits")

local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitReaction = UnitReaction
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitClassification = UnitClassification
local UnitFactionGroup = UnitFactionGroup
local UnitIsDead = UnitIsDead
local UnitExists = UnitExists
local InCombatLockdown = InCombatLockdown
local select, tinsert = select, tinsert
local UnitGUID = UnitGUID

local playerFaction = nil

-- portrait texture update functions

function module:UpdatePortrait(portrait, event, unit)
	local showCastIcon = portrait.db.cast and module:UpdateCastIcon(portrait, event)
	local forceDesaturate = module.db.profile.misc.desaturate

	if not showCastIcon then
		if portrait.useClassIcon and (portrait.isPlayer or (module.Retail and UnitInPartyIsAI(unit))) then
			portrait.unitClass = portrait.unitClass or select(2, UnitClass(portrait.unit))
			portrait.texCoords = portrait.classIcons.texCoords[portrait.unitClass]
			portrait.portrait:SetTexture(portrait.classIcons.texture, "CLAMP", "CLAMP", "TRILINEAR")
		else
			SetPortraitTexture(portrait.portrait, unit or portrait.unit, true)
		end

		module:UpdateDesaturated(portrait, (forceDesaturate or portrait.isDead))
	end

	module:Mirror(portrait.portrait, portrait.isPlayer and portrait.db.mirror, (portrait.isPlayer and portrait.useClassIcon) and portrait.texCoords)
end

-- color functions

function module:UpdateDesaturated(portrait, isDead)
	if isDead then
		if not portrait.isDesaturated then
			portrait.portrait:SetDesaturated(true)
			portrait.isDesaturated = true
		end
	elseif portrait.isDesaturated then
		portrait.portrait:SetDesaturated(false)
		portrait.isDesaturated = false
	end
end

-- unit status functions
function module:UpdateDeathStatus(portrait, unit)
	local isDead = (UnitExists(unit) and UnitIsDead(unit))
	if isDead then
		local deathColor = module.db.profile.colors.misc.death
		module:UpdateDesaturated(portrait, isDead)
		portrait.texture:SetVertexColor(deathColor.r, deathColor.g, deathColor.b, deathColor.a or 1)
	end
	return isDead
end

-- update settings functions
local function UpdateZoom(texture, size)
	local zoom = module.db.profile.misc.zoom
	local offset = (size / 2) * zoom

	texture:SetPoint("TOPLEFT", 0 - offset, 0 + offset)
	texture:SetPoint("BOTTOMRIGHT", 0 + offset, 0 - offset)
end

function module:RegisterEvents(portrait, events, cast)
	for _, event in pairs(events) do
		if cast and portrait.type ~= "party" then
			portrait:RegisterUnitEvent(event, portrait.unit)
		else
			portrait:RegisterEvent(event)
		end
		tinsert(portrait.events, event)
	end

	-- death check
	if portrait.type == "party" then
		portrait:RegisterEvent("UNIT_HEALTH")
	else
		portrait:RegisterUnitEvent("UNIT_HEALTH", portrait.unit)
	end
	tinsert(portrait.events, "UNIT_HEALTH")
end

function module:RemovePortrait(frame)
	if frame and frame.events then
		for _, event in pairs(frame.events) do
			frame:UnregisterEvent(event)
		end
	end

	frame:Hide()
	frame = nil
end

function module:GetUnitColor(unit, class, isPlayer, isDead)
	if not unit then return end

	local colors = MEDIA.color.portraits

	if isDead then return colors.misc.death end

	if module.db.misc.force_default then return colors.misc.default end

	if isPlayer then
		if module.db.misc.force_reaction then
			local unitFaction = select(1, UnitFactionGroup(unit))
			playerFaction = playerFaction or select(1, UnitFactionGroup("player"))

			local reactionType = (playerFaction == unitFaction) and "friendly" or "enemy"
			return colors.reaction[reactionType]
		else
			return colors.class[class]
		end
	else
		local reaction = (unit == "pet") and UnitReaction("player", unit) or UnitReaction(unit, "player")
		local reactionType = (reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly")) or "enemy"
		return colors.reaction[reactionType]
	end
end

local function UpdateTextureColor(element, unit)
	unit = unit or element.unit
	local color = module:GetUnitColor(unit, element.unitClass, element.isPlayer, element.isDead)
	element.color = color

	if color then
		local c = color.c
		element.texture:SetVertexColor(c.r, c.g, c.b, c.a or 1)
		if element.embellishment then element.embellishment:SetVertexColor(c.r, c.g, c.b, c.a or 1) end
	end
end

local function GetCastIcon(unit)
	return select(3, UnitCastingInfo(unit)) or select(3, UnitChannelInfo(unit))
end

local CachedBossIDs = {}

local function UpdateExtraTexture(element, force)
	if element.extra and not element.db.extra then
		element.extra:Hide()
		return
	end

	local color
	local classification = force and force or (element.type == "boss" and "boss" or ((CachedBossIDs[element.lastGUID] and "boss") or UnitClassification(element.unit)))

	if element.db.unitcolor then
		color = element.color
	elseif module.db.misc.force_reaction then
		local reaction = UnitReaction(element.unit, "player")
		local reactionType = reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly") or "enemy"
		color = MEDIA.color.portraits.reaction[reactionType]
	else
		color = MEDIA.color.portraits.classification[classification]
	end

	if color then
		element.extra:SetTexture(element.media[classification], "CLAMP", "CLAMP", "TRILINEAR")
		element.extra:SetVertexColor(color.c.r, color.c.g, color.c.b, color.c.a or 1)
		element.extra:Show()
	else
		element.extra:Hide()
	end
end

local function Update(self, event, unit)
	if not unit or not UnitIsUnit(self.unit, unit) then return end
	print("Update", unit, event)

	local element = self

	local guid = UnitGUID(unit)
	local isAvailable = UnitIsConnected(unit) and UnitIsVisible(unit)
	local hasStateChanged = ((event == "ForceUpdate") or (element.guid ~= guid) or (element.state ~= isAvailable))
	if hasStateChanged then
		local class = select(2, UnitClass(unit))
		local isPlayer = UnitIsPlayer(unit) or (E.Retail and UnitInPartyIsAI(unit))

		local classIcons = false

		if classIcons then
			--element:SetAtlas("classicon-" .. class)
		else
			SetPortraitTexture(element.unit_portrait, unit, true)
		end

		element.guid = guid
		element.state = isAvailable
		element.isPlayer = isPlayer
		element.unit = unit
		element.unitClass = class

		UpdateTextureColor(element, unit)
		UpdateExtraTexture(element, element.forceExtra)

		if not InCombatLockdown() and self:GetAttribute("unit") ~= unit then self:SetAttribute("unit", unit) end
	end
end

function module:CreatePortrait(name, parent, settings)
	local portrait = CreateFrame("Button", "mMT-Portrait-" .. name, parent, "SecureUnitButtonTemplate")

	-- texture
	portrait.texture = portrait:CreateTexture("mMT-Portrait-Texture-" .. name, "ARTWORK", nil, 5)
	portrait.texture:SetPoint("CENTER", portrait, "CENTER", 0, 0)

	-- shadow
	portrait.shadow = portrait:CreateTexture("mMT-Portrait-Shadow-" .. name, "ARTWORK", nil, 4)
	portrait.shadow:SetAllPoints(portrait.texture)

	-- mask
	portrait.mask = portrait:CreateMaskTexture()
	portrait.mask:SetAllPoints(portrait.texture)

	-- portrait
	portrait.unit_portrait = portrait:CreateTexture("mMT-Portrait-Unit-Portrait-" .. name, "ARTWORK", nil, 3)
	portrait.unit_portrait:SetAllPoints(portrait.texture)
	portrait.unit_portrait:AddMaskTexture(portrait.mask)

	-- rare/elite/boss
	local extraOnTop = module.db.misc.extratop
	portrait.extra = portrait:CreateTexture("mMT-Portrait-Extra-" .. name, "OVERLAY", nil, extraOnTop and 7 or 1)

	if settings.extra_settings.enable then
		portrait.extra:SetPoint("CENTER", portrait.texture, "CENTER", settings.extra_settings.offset.x, settings.extra_settings.offset.y)
		portrait.extra.changed = true
	else
		portrait.extra:SetAllPoints(portrait.texture)
	end

	-- extra mask
	if not extraOnTop then
		portrait.extra_mask = portrait:CreateMaskTexture()
		portrait.extra_mask:SetAllPoints(portrait.extra)
		portrait.extra:AddMaskTexture(portrait.extra_mask)
	end

	-- bg
	portrait.bg = portrait:CreateTexture("mMT-Portrait-BG-" .. name, "BACKGROUND", nil, 2)
	portrait.bg:SetAllPoints(portrait.texture)
	portrait.bg:AddMaskTexture(portrait.mask)
	--portrait.bg:SetVertexColor(0, 0, 0, 1)

	-- scripts to interact with mouse
	portrait:SetAttribute("unit", portrait.unit)
	portrait:SetAttribute("*type1", "target")
	portrait:SetAttribute("*type2", "togglemenu")
	portrait:SetAttribute("type3", "focus")
	portrait:SetAttribute("toggleForVehicle", true)
	portrait:SetAttribute("ping-receiver", true)
	portrait:RegisterForClicks("AnyUp")
	portrait:Show()

	return portrait
end

function module:UpdateTexturesFiles(style, mirror)
	local media = MEDIA.portraits
	local db = module.db

	local bg = media.bg["default"].texture
	local classIcons = db.misc.class_icon and media.icons[db.misc.class_icon] or nil

	local texture, shadow, mask, extra_mask, embellishment
	local player, rare, elite, rareelite, boss

	if db.custom.enable then
		local custom = db.custom
		texture = "Interface\\Addons\\" .. custom.texture
		shadow = "Interface\\Addons\\" .. custom.shadow
		mask = "Interface\\Addons\\" .. custom.mask
		extra_mask = "Interface\\Addons\\" .. custom.extra_mask

		if custom.extra then
			player, rare, elite, rareelite, boss =
				"Interface\\Addons\\" .. custom.player,
				"Interface\\Addons\\" .. custom.rare,
				"Interface\\Addons\\" .. custom.elite,
				"Interface\\Addons\\" .. custom.rareelite,
				"Interface\\Addons\\" .. custom.boss
		else
			player, rare, elite, rareelite, boss = media.extra[db.misc.player], media.extra[db.misc.rare], media.extra[db.misc.elite], media.extra[db.misc.rareelite], media.extra[db.misc.boss]
		end
	else
		local textures = media.textures[style]
		texture, shadow = textures.texture, textures.shadow
		mask = mirror and textures.mask_mirror or textures.mask
		extra_mask = mirror and textures.extra_mirror or textures.extra
		embellishment = mirror and textures.embellishment_mirror or textures.embellishment

		player, rare, elite, rareelite, boss =
			media.extra[db.misc.player].texture, media.extra[db.misc.rare].texture, media.extra[db.misc.elite].texture, media.extra[db.misc.rareelite].texture, media.extra[db.misc.boss].texture
	end

	return {
		texture = texture,
		shadow = shadow,
		mask = mask,
		extra_mask = extra_mask,
		player = player,
		rare = rare,
		elite = elite,
		rareelite = rareelite,
		boss = boss,
		bg = bg,
		embellishment = embellishment,
		classIcons = classIcons,
	}
end

function module:UpdateSize(element, size, point)
	if not InCombatLockdown() then
		size = size or element.size
		point = point or element.point
		element:SetSize(size / 2, size / 2)
		element.texture:SetSize(size, size)
		element:ClearAllPoints()
		element:SetPoint(point.point, element.__owner, point.relativePoint, point.x, point.y)

		if element.db.extra_settings.enable then
			if not element.extra.changed then
				element.extra:ClearAllPoints()
				element.extra:SetPoint("CENTER", element.texture, "CENTER", element.db.extra_settings.offset.x, element.db.extra_settings.offset.y)
				element.extra.changed = true
			end
			element.extra:SetSize(element.db.extra_settings.size, element.db.extra_settings.size)
		elseif element.extra.changed then
			element.extra:ClearAllPoints()
			element.extra:SetAllPoints(element.texture)
			element.extra.changed = false
		end

		if element.db.strata ~= "AUTO" then element:SetFrameStrata(element.db.strata) end
		element:SetFrameLevel(element.db.level)
	end
end

local function UpdateCastIconStart(self)
	self.isCasting = true

	local texture = GetCastIcon(self.unit)
	if texture then self.unit_portrait:SetTexture(texture) end
end

local function UpdateCastIconStop(self, event)
	self.isCasting = false

	SetPortraitTexture(self.unit_portrait, self.unit)
end

local function VehicleUpdate(self, event, _, arg2)
	local unit
	if self.realUnit == "player" then
		unit = (UnitInVehicle("player") and arg2) and UnitExists("pet") and "pet" or "player"
	else
		unit = (UnitInVehicle("player") and arg2) and "player" or "pet"
	end

	Update(self, event, unit)
end

local eventHandlers = {
	-- portrait updates
	PORTRAITS_UPDATED = Update,
	UNIT_CONNECTION = Update,
	UNIT_PORTRAIT_UPDATE = Update,
	PARTY_MEMBER_ENABLE = Update,

	-- cast icon updates
	UNIT_SPELLCAST_CHANNEL_START = UpdateCastIconStart,
	UNIT_SPELLCAST_START = UpdateCastIconStart,

	UNIT_SPELLCAST_CHANNEL_STOP = UpdateCastIconStop,
	UNIT_SPELLCAST_INTERRUPTED = UpdateCastIconStop,
	UNIT_SPELLCAST_STOP = UpdateCastIconStop,

	UNIT_SPELLCAST_EMPOWER_START = UpdateCastIconStart,
	UNIT_SPELLCAST_EMPOWER_STOP = UpdateCastIconStop,

	-- vehicle updates
	UNIT_ENTERED_VEHICLE = VehicleUpdate,
	UNIT_EXITING_VEHICLE = VehicleUpdate,
	UNIT_EXITED_VEHICLE = VehicleUpdate,
	VEHICLE_UPDATE = VehicleUpdate,

	-- death updates
	UNIT_HEALTH = function(self)
		self.isDead = UnitIsDeadOrGhost(self.unit)
	end,
}

local function OnEvent(self, event, unit, arg)
	if eventHandlers[event] then eventHandlers[event](self, event, unit, arg) end
end

local function RegisterEvent(element, event, unitEvent)
	if unitEvent then
		element:RegisterUnitEvent(event, element.unit)
	else
		element:RegisterEvent(event)
	end
end

function module:InitPortrait(element)
	if element then
		if element.media.embellishment and not element.embellishment then
			element.embellishment = element:CreateTexture("mMT-Portrait-Embellishment-" .. element.name, "OVERLAY", nil, 6)
			element.embellishment:SetAllPoints(element.texture)
		end

		module:UpdateTextures(element)

		-- default events
		if not element.eventsSet then
			for _, event in pairs({ "UNIT_PORTRAIT_UPDATE", "PORTRAITS_UPDATED", "UNIT_CONNECTION" }) do
				RegisterEvent(element, event)
			end

			if element.type == "party" then element:RegisterEvent("PARTY_MEMBER_ENABLE") end
			element.eventsSet = true
		end

		-- death check
		if element.type == "party" then
			element:RegisterEvent("UNIT_HEALTH")
		else
			element:RegisterUnitEvent("UNIT_HEALTH", element.unit)
		end

		-- cast events
		if element.db.cast and not element.cast_eventsSet then
			for _, event in pairs({ "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_CHANNEL_STOP" }) do
				RegisterEvent(element, event, (element.type ~= "party"))
			end

			if E.Retail then
				for _, event in pairs({ "UNIT_SPELLCAST_EMPOWER_START", "UNIT_SPELLCAST_EMPOWER_STOP" }) do
					RegisterEvent(element, event, (element.type ~= "party"))
				end
			end

			element.cast_eventsSet = true
		elseif element.cast_eventsSet then
			element:UnregisterEvent("UNIT_SPELLCAST_START")
			element:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
			element:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
			element:UnregisterEvent("UNIT_SPELLCAST_STOP")
			element:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

			if E.Retail then
				element:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START")
				element:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
			end
			element.cast_eventsSet = false
		end

		Update(element, "ForceUpdate", element.unit)
		element:SetScript("OnEvent", OnEvent)

		--UpdateZoom(element.portrait, element.size)
	end
end

function module:Mirror(texture, mirror, texCoords)
	if texCoords then
		local coords = texCoords
		if #coords == 8 then
			texture:SetTexCoord(unpack((mirror and { coords[5], coords[6], coords[7], coords[8], coords[1], coords[2], coords[3], coords[4] } or coords)))
		else
			texture:SetTexCoord(unpack((mirror and { coords[2], coords[1], coords[3], coords[4] } or coords)))
		end
	else
		texture:SetTexCoord(mirror and 1 or 0, mirror and 0 or 1, 0, 1)
	end
end

local function SetTexture(texture, file, wrapMode)
	texture:SetTexture(file, wrapMode, wrapMode, "TRILINEAR")
end

function module:UpdateTextures(element)
	SetTexture(element.texture, element.media.texture, "CLAMP")
	SetTexture(element.mask, element.media.mask, "CLAMPTOBLACKADDITIVE")
	SetTexture(element.shadow, element.media.shadow, "CLAMP")

	local mirror = element.db.mirror
	if element.embellishment then
		SetTexture(element.embellishment, element.media.embellishment, "CLAMP")
		module:Mirror(element.embellishment, mirror)
	end

	if element.extra_mask then SetTexture(element.extra_mask, element.media.extra_mask, "CLAMPTOBLACKADDITIVE") end
	SetTexture(element.bg, element.media.bg, "CLAMP")

	module:Mirror(element.texture, mirror)
	module:Mirror(element.shadow, mirror)
	module:Mirror(element.extra, mirror)
end

function module:Initialize()
	module.db = E.db.mMT.portraits
	--module.portraits = module.portraits or {}

	if module.db.enable then
		module.portraits = module.portraits or {}

		--module:InitializeArenaPortrait()
		--module:InitializeBossPortrait()
		--module:InitializeFocusPortrait()
		--module:InitializePartyPortrait()
		--module:InitializePetPortrait()
		E:Delay(1, module.InitializePlayerPortrait)
		--module:InitializeTargetPortrait()
		--module:InitializeTargetTargetPortrait()
	else
		for _, element in pairs(module.portraits) do
			element:UnregisterAllEvents()
			element:Hide()
			element = nil
		end
		module.portraits = nil
	end
end
