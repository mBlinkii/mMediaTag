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

module.media = {}
local mediaPortraits = module.media.portraits
local mediaExtra = module.media.extra
local mediaClass = module.media.class

local playerFaction = nil

-- portrait texture update functions

function module:UpdateExtraTexture(portrait, color, force)
	if not (portrait.extra and portrait.db.extra) then
		if portrait.extra then portrait.extra:Hide() end
		return
	end

	local c = portrait.type == "boss" and "boss" or ((module.CachedBossIDs[portrait.lastGUID] and "boss") or UnitClassification(portrait.unit))
	local isExtraUnit = c == "rare" or c == "elite" or c == "rareelite" or c == "boss"
	if not isExtraUnit and (force and force ~= "none") then c = force end

	if ((force and force ~= "none") or isExtraUnit) and not color then
		if module.db.profile.misc.force_reaction then
			local colorReaction = module.db.profile.colors.reaction
			local reaction = UnitReaction(portrait.unit, "player")
			local reactionType = reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly") or "enemy"
			color = colorReaction[reactionType]
		else
			local colorClassification = module.db.profile.colors.classification
			color = colorClassification[c]
		end
	end

	if color then
		portrait.extra:SetTexture(portrait[c .. "File"], "CLAMP", "CLAMP", "TRILINEAR")
		portrait.extra:SetVertexColor(color.r, color.g, color.b, color.a or 1)
		portrait.extra:Show()
	else
		portrait.extra:Hide()
	end
end

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
function module:GetUnitColor(unit, isDead)
	if not unit then return end

	local colors = module.db.profile.colors
	local isPlayer = UnitIsPlayer(unit) or (module.Retail and UnitInPartyIsAI(unit))

	if isDead then return colors.misc.death, isPlayer end

	if module.db.profile.misc.force_default then return colors.misc.default, isPlayer end

	if isPlayer then
		if module.db.profile.misc.force_reaction then
			local unitFaction = select(1, UnitFactionGroup(unit))
			playerFaction = select(1, UnitFactionGroup("player"))

			local reactionType = (playerFaction == unitFaction) and "friendly" or "enemy"
			return colors.reaction[reactionType], isPlayer
		else
			local _, class = UnitClass(unit)
			return colors.class[class], isPlayer, class
		end
	else
		local reaction = (unit == "pet") and UnitReaction("player", unit) or UnitReaction(unit, "player")
		local reactionType = (reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly")) or "enemy"
		return colors.reaction[reactionType], isPlayer
	end
end

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

-- cast functions
local castStartEvents = {
	UNIT_SPELLCAST_START = true,
	UNIT_SPELLCAST_CHANNEL_START = true,
	UNIT_SPELLCAST_EMPOWER_START = true,
}

local castStopEvents = {
	UNIT_SPELLCAST_INTERRUPTED = true,
	UNIT_SPELLCAST_STOP = true,
	UNIT_SPELLCAST_CHANNEL_STOP = true,
	UNIT_SPELLCAST_EMPOWER_STOP = true,
}

local function GetCastIcon(unit)
	return select(3, UnitCastingInfo(unit)) or select(3, UnitChannelInfo(unit))
end

function module:UpdateCastIcon(portrait, event)
	portrait.castStarted = castStartEvents[event] or false
	portrait.castStopped = castStopEvents[event] or false

	if portrait.castStarted or (portrait.isCasting and not portrait.castStopped) then
		portrait.isCasting = true
		portrait.empowering = (event == "UNIT_SPELLCAST_EMPOWER_START") or false
		local texture = GetCastIcon(portrait.unit)
		if texture then
			portrait.portrait:SetTexture(texture)
			return true
		end
		return false
	elseif portrait.castStopped or (portrait.isCasting and not GetCastIcon(portrait.unit)) then
		portrait.isCasting = false
		return false
	end

	return false
end

local castEvents = { "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_CHANNEL_STOP" }
local empowerEvents = { "UNIT_SPELLCAST_EMPOWER_START", "UNIT_SPELLCAST_EMPOWER_STOP" }

local function UnregisterEvents(portrait, events)
	for _, event in pairs(events) do
		portrait:UnregisterEvent(event)
	end
end

function module:RegisterCastEvents(element)
	if not portrait.castEventsSet then
		module:RegisterEvents(portrait, castEvents, true)

		if module.Retail then module:RegisterEvents(portrait, empowerEvents, true) end
		portrait.castEventsSet = true
	end
end

function module:UnregisterCastEvents(portrait)
	UnregisterEvents(portrait, castEvents)

	if module.Retail then UnregisterEvents(portrait, empowerEvents) end
	portrait.castEventsSet = false
end

function module:UpdateCastSettings(element)
	if element.db.cast then
		module:RegisterCastEvents(element)
		element.cast = true
	elseif element.cast then
		module:UnregisterCastEvents(element)
		element.cast = false
	end
end

local function Update(self, event, unit)
	if not unit or not UnitIsUnit(self.unit, unit) then return end
	print("Update", unit, event)

	local element = self

	local guid = UnitGUID(unit)
	local isAvailable = UnitIsConnected(unit) and UnitIsVisible(unit)
	local hasStateChanged = event ~= "OnUpdate" or element.guid ~= guid or element.state ~= isAvailable
	if hasStateChanged then
		local class = element.showClass and UnitClassBase(unit)
		if class then
			element:SetAtlas("classicon-" .. class)
		else
			SetPortraitTexture(element.portrait, unit, true)
		end

		element.guid = guid
		element.state = isAvailable
	end
end

local function Path(self, ...)
	return (self.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	print("ForceUpdate", element.__owner.unit)
	return Path(element, "ForceUpdate", element.__owner.unit)
end

function module:CreatePortrait(name, parent)
	local portrait = CreateFrame("Button", "mMT-Portrait-" .. name, parent, "SecureUnitButtonTemplate")

	-- texture
	portrait.texture = portrait:CreateTexture("mMT-Portrait-Texture-" .. name, "ARTWORK", nil, 4)
	portrait.texture:SetPoint("CENTER", portrait, "CENTER", 0, 0)

	-- shadow
	portrait.shadow = portrait:CreateTexture("mMT-Portrait-Shadow-" .. name, "ARTWORK", nil, 0)
	portrait.shadow:SetPoint("CENTER", portrait, "CENTER", 0, 0)

	-- mask
	portrait.mask = portrait:CreateMaskTexture()
	portrait.mask:SetAllPoints(portrait.texture)

	-- portrait
	portrait.unit_portrait = portrait:CreateTexture("mMT-Portrait-Unit-Portrait-" .. name, "ARTWORK", nil, 2)
	portrait.unit_portrait:SetAllPoints(portrait.texture)
	portrait.unit_portrait:AddMaskTexture(portrait.mask)

	-- rare/elite/boss
	local extraOnTop = module.db.misc.extratop
	portrait.extra = portrait:CreateTexture("mMT-Portrait-Extra-" .. name, "OVERLAY", nil, extraOnTop and 7 or 1)
	portrait.extra:SetAllPoints(portrait.texture)

	-- extra mask
	if not extraOnTop then
		portrait.extra_mask = portrait:CreateMaskTexture()
		portrait.extra_mask:SetAllPoints(portrait.texture)
		portrait.extra:AddMaskTexture(portrait.extra_mask)
	end

	-- bg
	portrait.bg = portrait:CreateTexture("mMT-Portrait-BG-" .. name, "BACKGROUND", nil, 1)
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

	local bg = media.bg["default"]
	local classIcons = db.misc.class_icon and media.icons[db.misc.class_icon] or nil

	local texture, shadow, mask, extra_mask
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

		player, rare, elite, rareelite, boss = media.extra[db.misc.player], media.extra[db.misc.rare], media.extra[db.misc.elite], media.extra[db.misc.rareelite], media.extra[db.misc.boss]
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

		if element.db.strata ~= "AUTO" then element:SetFrameStrata(element.db.strata) end
		element:SetFrameLevel(element.db.level)
	end
end

local function UpdateCastIconStart(self, event)
	self.isCasting = true
	self.empowering = (event == "UNIT_SPELLCAST_EMPOWER_START") or false

	local texture = GetCastIcon(self.unit)
	if texture then self.portrait:SetTexture(texture) end
end

-- here stop
local function UpdateCastIconStop(self, event)
	self.isCasting = false
	self.empowering = false

	SetPortraitTexture(self.portrait, self.unit, true)
end

function module:InitPortrait(element)
	if element then
		module:UpdateTextures(element)

		-- default events
		if not element.eventsSet then
			element:RegisterEvent("UNIT_MODEL_CHANGED", Update)
			element:RegisterEvent("UNIT_PORTRAIT_UPDATE", Update)
			element:RegisterEvent("PORTRAITS_UPDATED", Update, true)
			element:RegisterEvent("UNIT_CONNECTION", Update)

			if element.type == "party" then element:RegisterEvent("PARTY_MEMBER_ENABLE", Update) end

			element.eventsSet = true
		end

		-- cast events
		if element.db.cast and not element.cast_eventsSet then
			element:RegisterEvent("UNIT_SPELLCAST_START", UpdateCastIconStart)
			element:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", UpdateCastIconStart)
			element:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", UpdateCastIconStop)
			element:RegisterEvent("UNIT_SPELLCAST_STOP", UpdateCastIconStop)
			element:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", UpdateCastIconStop)

			if E.Retail then
				element:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START", UpdateCastIconStart)
				element:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP", UpdateCastIconStop)
			end

			element.cast_eventsSet = true
		elseif element.cast_eventsSet then
			element:UnregisterCastEvents("UNIT_SPELLCAST_START")
			element:UnregisterCastEvents("UNIT_SPELLCAST_CHANNEL_START")
			element:UnregisterCastEvents("UNIT_SPELLCAST_INTERRUPTED")
			element:UnregisterCastEvents("UNIT_SPELLCAST_STOP")
			element:UnregisterCastEvents("UNIT_SPELLCAST_CHANNEL_STOP")

			if E.Retail then
				element:UnregisterCastEvents("UNIT_SPELLCAST_EMPOWER_START")
				element:UnregisterCastEvents("UNIT_SPELLCAST_EMPOWER_STOP")
			end
			element.element.cast_eventsSet = false
		end

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

	if element.extra_mask then SetTexture(element.extra_mask, element.media.extra_mask, "CLAMPTOBLACKADDITIVE") end
	SetTexture(element.bg, element.media.bg, "CLAMP")

	local mirror = element.db.mirror
	module:Mirror(element.texture, mirror)
	module:Mirror(element.extra, mirror)
end

function module:Initialize()
	module.db = E.db.mMT.portraits
	module.portraits = module.portraits or {}

	if module.db.enable then
		print("Portraits module loaded")
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
		--module:InitializeArenaPortrait()
		--module:InitializeBossPortrait()
		--module:InitializeFocusPortrait()
		--module:InitializePartyPortrait()
		--module:InitializePetPortrait()
		module:InitializePlayerPortrait()
		--module:InitializeTargetPortrait()
		--module:InitializeTargetTargetPortrait()
	end
end
