local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("Portraits", { "AceEvent-3.0" })
local UF = E:GetModule("UnitFrames")
local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitReaction = UnitReaction
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitClassification = UnitClassification
local UnitFactionGroup = UnitFactionGroup
local UnitIsDead = UnitIsDead
local InCombatLockdown = InCombatLockdown
local select = select
local UnitGUID = UnitGUID

local playerFaction = nil

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
	local db = module.db.misc
	local e_db = element.db

	unit = unit or element.unit
	local color = module:GetUnitColor(unit, element.unitClass, element.isPlayer, element.isDead)
	element.color = color

	if color then
		local primary, secondary = color.c, color.g

		if e_db.mirror and db.gradient_mode == "HORIZONTAL" then
			primary, secondary = secondary, primary
		end

		if db.gradient then
			local gradient_params = {
				{ r = primary.r, g = primary.g, b = primary.b, a = primary.a or 1 },
				{ r = secondary.r, g = secondary.g, b = secondary.b, a = secondary.a or 1 },
			}

			element.texture:SetGradient(db.gradient_mode, unpack(gradient_params))

			if element.embellishment then
				if not element.media.disable_color then
					element.embellishment:SetGradient(db.gradient_mode, unpack(gradient_params))
				else
					element.embellishment:SetVertexColor(1, 1, 1, 1)
				end
			end
		else
			local c = color.c
			element.texture:SetVertexColor(c.r, c.g, c.b, c.a or 1)

			if element.embellishment then
				if element.media.disable_color then
					element.embellishment:SetVertexColor(1, 1, 1, 1)
				else
					element.embellishment:SetVertexColor(c.r, c.g, c.b, c.a or 1)
				end
			end
		end
	end

	if element.isDead or db.desaturate then
		if not element.isDesaturated then
			element.unit_portrait:SetDesaturated(true)
			element.isDesaturated = true
		end
	elseif element.isDesaturated and not db.desaturate then
		element.unit_portrait:SetDesaturated(false)
		element.isDesaturated = false
	end
end

local function GetCastIcon(unit)
	return select(3, UnitCastingInfo(unit)) or select(3, UnitChannelInfo(unit))
end

local function SetupExtraTexture(element, low)
	local extraOnTop = module.db.misc.extratop and not low
	element.extra:SetDrawLayer(extraOnTop and "OVERLAY" or "ARTWORK", extraOnTop and 7 or 0)

	-- extra mask
	if not extraOnTop and not element.extra_mask then
		element.extra_mask = element:CreateMaskTexture()
		element.extra_mask:SetAllPoints(element.extra)
		element.extra:AddMaskTexture(element.extra_mask)
	elseif element.extra_mask then
		element.extra:RemoveMaskTexture(element.extra_mask)
	end
end

local function UpdateExtraTexture(element, force)
	if element.extra and not element.db.extra then
		element.extra:Hide()
		return
	end

	local db = module.db.misc
	local e_db = element.db

	local color
	local npcID = element.lastGUID and select(6, strsplit("-", element.lastGUID))
	if element.type == "boss" and npcID and not DB.boss_ids[npcID] then DB.boss_ids[npcID] = true end

	local isBoss = element.type == "boss" or (npcID and DB.boss_ids[npcID])
	local c = isBoss and "boss" or UnitClassification(element.unit)
	if c == "worldboss" then c = "boss" end

	local classification = force and force or c

	if element.db.unitcolor then
		color = element.color
	elseif db.force_reaction then
		local reaction = UnitReaction(element.unit, "player")
		local reactionType = reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly") or "enemy"
		color = MEDIA.color.portraits.reaction[reactionType]
	else
		color = MEDIA.color.portraits.classification[classification]
	end

	if color then
		local extra = element.extra
		SetupExtraTexture(element, element.media[classification].low)
		extra:SetTexture(element.media[classification].texture, "CLAMP", "CLAMP", "TRILINEAR")

		if db.gradient then
			local primary, secondary = color.c, color.g

			if e_db.mirror and db.gradient_mode == "HORIZONTAL" then
				primary, secondary = secondary, primary
			end

			local gradient_params = {
				{ r = primary.r, g = primary.g, b = primary.b, a = primary.a or 1 },
				{ r = secondary.r, g = secondary.g, b = secondary.b, a = secondary.a or 1 },
			}

			extra:SetGradient(db.gradient_mode, unpack(gradient_params))
		else
			extra:SetVertexColor(color.c.r, color.c.g, color.c.b, color.c.a or 1)
		end

		extra:Show()
	else
		element.extra:Hide()
	end
end

local function Update(self, event, eventUnit, arg)
	if self.type == "player" then print(event, " - start") end
	if not eventUnit or not UnitIsUnit(self.unit, eventUnit) then return end
	--print(" - passed unit check")

	local unit = (self.demo and not UnitExists(self.unit)) and "player" or self.unit
	local guid = UnitGUID(unit)
	local isAvailable = UnitIsConnected(unit) and UnitIsVisible(unit)
	local hasStateChanged = ((event == "ForceUpdate") or (self.guid ~= guid) or (self.state ~= isAvailable))
	local isDead = event == "UNIT_HEALTH" and self.isDead or UnitIsDead(unit)

	--print(" - isAvailable:", isAvailable, " | isDead:", isDead, " | hasStateChanged:", hasStateChanged)
	if hasStateChanged or isDead then
		--print(" - state changed")
		local texCoords
		local class = select(2, UnitClass(unit))
		local isPlayer = UnitIsPlayer(unit) or (E.Retail and UnitInPartyIsAI(unit))
		local shouldMirror = (isPlayer and self.db.mirror) or (not isPlayer and not self.db.mirror)

		if module.useClassIcons and isPlayer then
			texCoords = module.texCoords[class].texCoords or module.texCoords[class]
			self.unit_portrait:SetTexture(module.classIcons, "CLAMP", "CLAMP", "TRILINEAR")
		else
			if self.type == "player" then print(self.unit, event, " - player portrait") end
			SetPortraitTexture(self.unit_portrait, unit, true)
		end

		module:Mirror(self.unit_portrait, shouldMirror, texCoords)

		self.guid = guid
		self.state = isAvailable
		self.isPlayer = isPlayer
		self.unit = unit
		self.unitClass = class
		self.isDead = isDead

		UpdateTextureColor(self, unit)
		UpdateExtraTexture(self, (self.forceExtra ~= "none" and self.forceExtra or nil))

		if not InCombatLockdown() and self:GetAttribute("unit") ~= unit then self:SetAttribute("unit", unit) end
	end
end

local function DemoUpdate(self)
	local element = self
	local texCoords
	local unit = "player"
	local class = select(2, UnitClass(unit))
	local isPlayer = true
	local shouldMirror = (isPlayer and self.db.mirror) or (not isPlayer and not self.db.mirror)

	if module.useClassIcons then
		texCoords = module.texCoords[class].texCoords or module.texCoords[class]
		element.unit_portrait:SetTexture(module.classIcons, "CLAMP", "CLAMP", "TRILINEAR")
	else
		SetPortraitTexture(element.unit_portrait, unit, true)
	end

	module:Mirror(element.unit_portrait, shouldMirror, texCoords)

	element.isPlayer = isPlayer
	element.unitClass = class

	UpdateTextureColor(element, unit)
	UpdateExtraTexture(element, (element.forceExtra ~= "none" and element.forceExtra or nil))
end

function module:CreatePortrait(name, parent, settings)
	local portrait = CreateFrame("Button", "mMT-Portrait-" .. name, parent, "SecureUnitButtonTemplate")

	-- texture
	portrait.texture = portrait:CreateTexture("mMT-Portrait-Texture-" .. name, "ARTWORK", nil, 5)
	portrait.texture:SetPoint("CENTER", portrait, "CENTER", 0, 0)

	-- shadow
	--portrait.shadow = portrait:CreateTexture("mMT-Portrait-Shadow-" .. name, "ARTWORK", nil, 4)
	--portrait.shadow:SetAllPoints(portrait.texture)

	-- mask
	portrait.mask = portrait:CreateMaskTexture()
	portrait.mask:SetAllPoints(portrait.texture)

	-- portrait
	portrait.unit_portrait = portrait:CreateTexture("mMT-Portrait-Unit-Portrait-" .. name, "ARTWORK", nil, 3)
	--portrait.unit_portrait:SetAllPoints(portrait.texture)
	portrait.unit_portrait:SetPoint("CENTER", portrait.texture, "CENTER")
	portrait.unit_portrait:AddMaskTexture(portrait.mask)

	-- rare/elite/boss
	local extraOnTop = module.db.misc.extratop
	portrait.extra = portrait:CreateTexture("mMT-Portrait-Extra-" .. name, "OVERLAY", nil, extraOnTop and 7 or 0)

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
	portrait.bg = portrait:CreateTexture("mMT-Portrait-BG-" .. name, "ARTWORK", nil, 1)
	portrait.bg:SetAllPoints(portrait.texture)
	portrait.bg:AddMaskTexture(portrait.mask)

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

	local bg = media.bg[db.bg.style].texture

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
		embellishment = embellishment,
		disable_color = media.textures[style].disable_color,
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

		element.unit_portrait:SetSize(size, size)

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

		local scale = module.db.misc.scale
		element.unit_portrait:SetScale(scale)
	end
end

local function DelayedUpdate(portrait, event)
	if portrait._delayedUpdateTimer then portrait._delayedUpdateTimer:Cancel() end
	portrait._delayedUpdateTimer = C_Timer.NewTimer(0.6, function()
		Update(portrait, event, portrait.unit)
		portrait._delayedUpdateTimer = nil
	end)
end

local function UpdateCastIconStart(self)
	self.isCasting = true

	local texture = GetCastIcon(self.unit)
	if texture then self.unit_portrait:SetTexture(texture) end
end

local function UpdateCastIconStop(self)
	self.isCasting = false

	SetPortraitTexture(self.unit_portrait, self.unit)
end

local function SimpleUpdate(portrait, event)
	Update(portrait, event, portrait.unit)
end

local eventHandlers = {
	-- portrait updates
	PORTRAITS_UPDATED = SimpleUpdate,
	UNIT_CONNECTION = Update,
	UNIT_PORTRAIT_UPDATE = Update,
	PARTY_MEMBER_ENABLE = Update,
	ForceUpdate = Update,

	-- cast icon updates
	UNIT_SPELLCAST_CHANNEL_START = UpdateCastIconStart,
	UNIT_SPELLCAST_START = UpdateCastIconStart,

	UNIT_SPELLCAST_CHANNEL_STOP = UpdateCastIconStop,
	UNIT_SPELLCAST_INTERRUPTED = UpdateCastIconStop,
	UNIT_SPELLCAST_STOP = UpdateCastIconStop,

	UNIT_SPELLCAST_EMPOWER_START = UpdateCastIconStart,
	UNIT_SPELLCAST_EMPOWER_STOP = UpdateCastIconStop,

	-- vehicle updates
	UNIT_ENTERED_VEHICLE = DelayedUpdate,
	UNIT_EXITING_VEHICLE = SimpleUpdate,
	UNIT_EXITED_VEHICLE = SimpleUpdate,
	VEHICLE_UPDATE = SimpleUpdate,

	-- target/ focus updates
	PLAYER_TARGET_CHANGED = SimpleUpdate,
	PLAYER_FOCUS_CHANGED = SimpleUpdate,
	UNIT_TARGET = SimpleUpdate,

	-- party
	GROUP_ROSTER_UPDATE = SimpleUpdate,
	UNIT_NAME_UPDATE = SimpleUpdate,

	-- arena
	ARENA_OPPONENT_UPDATE = Update,
	UNIT_TARGETABLE_CHANGED = Update,
	ARENA_PREP_OPPONENT_SPECIALIZATIONS = SimpleUpdate,
	INSTANCE_ENCOUNTER_ENGAGE_UNIT = SimpleUpdate,
	UPDATE_ACTIVE_BATTLEFIELD = SimpleUpdate,

	-- death updates
	UNIT_HEALTH = function(self)
		self.isDead = UnitIsDeadOrGhost(self.unit)
		print("UNIT_HEALTH", self.__owner.unit or self.unit, self.isDead)

		UpdateTextureColor(self, self.__owner.unit or self.unit)
	end,
}

local function OnEvent(self, event, eventUnit, arg)
	local unit = self.__owner.unit or self.unit
	self.unit = unit
	self.isDead = UnitIsDeadOrGhost(unit)

	if eventHandlers[event] then eventHandlers[event](self, event, eventUnit, arg) end
end

local function RegisterEvent(element, event, unitEvent)
	if unitEvent then
		element:RegisterUnitEvent(event, element.unit)
	else
		element:RegisterEvent(event)
	end
end

local function adjustColor(color, shift)
	return {
		r = color.r * shift,
		g = color.g * shift,
		b = color.b * shift,
		a = color.a,
	}
end

function module:InitPortrait(element)
	if element then
		-- embellishment
		if module.db.misc.embellishment and element.media.embellishment and not element.embellishment then
			element.embellishment = element:CreateTexture("mMT-Portrait-Embellishment-" .. element.name, "OVERLAY", nil, 6)
			element.embellishment:SetAllPoints(element.texture)
		elseif not module.db.misc.embellishment and element.embellishment then
			element.embellishment:Hide()
			element.embellishment = nil
		end

		-- shadow
		if module.db.shadow.enable and element.media.shadow and not element.shadow then
			element.shadow = element:CreateTexture("mMT-Portrait-Shadow-" .. element.name, "ARTWORK", nil, 4)
			element.shadow:SetAllPoints(element.texture)
		elseif not module.db.shadow.enable and element.shadow then
			element.shadow:Hide()
			element.shadow = nil
		end

		module:UpdateTextures(element)

		local bgColor = module.db.bg.classBG and MEDIA.myclass or MEDIA.color.portraits.misc.bg
		if module.db.bg.classBG then bgColor = adjustColor(bgColor, module.db.bg.bgColorShift or 1) end
		element.bg:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, bgColor.a)

		-- default events
		if not element.eventsSet then
			for _, event in pairs({ "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED", "UNIT_CONNECTION" }) do
				RegisterEvent(element, event, (element.type ~= "party"))
			end

			element:RegisterEvent("PORTRAITS_UPDATED")

			if element.type == "party" then element:RegisterEvent("PARTY_MEMBER_ENABLE") end
			element.eventsSet = true
		end

		-- death check
		-- if element.type == "party" then
		-- 	element:RegisterEvent("UNIT_HEALTH")
		-- else
		-- 	element:RegisterUnitEvent("UNIT_HEALTH", element.unit)
		-- end

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
		elseif element.cast_eventsSet and not element.db.cast then
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
		element:SetScript("OnEvent", OnEvent)
		OnEvent(element, "ForceUpdate", element.unit)
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

	local mirror = element.db.mirror
	if element.embellishment then
		SetTexture(element.embellishment, element.media.embellishment, "CLAMP")
		module:Mirror(element.embellishment, mirror)
	end

	if element.extra_mask then SetTexture(element.extra_mask, element.media.extra_mask, "CLAMPTOBLACKADDITIVE") end
	SetTexture(element.bg, element.media.bg, "CLAMP")

	module:Mirror(element.texture, mirror)
	module:Mirror(element.extra, mirror)

	if element.shadow then
		SetTexture(element.shadow, element.media.shadow, "CLAMP")
		element.shadow:SetAlpha(module.db.shadow.alpha)
		module:Mirror(element.shadow, mirror)
	end
end

local function ToggleForceShowGroupFrames(_, group, numGroup)
	if group == "boss" or group == "arena" then
		for i = 1, numGroup do
			if module.portraits[group .. i] then DemoUpdate(module.portraits[group .. i]) end
		end
	end
end

local function HeaderConfig(_, header, configMode)
	if header.groups and header.groupName == "party" then
		for i = 1, #header.groups[1] do
			if module.portraits["party" .. i] then DemoUpdate(module.portraits["party" .. i]) end
		end
	end
end

function module:PLAYER_ENTERING_WORLD()
	module:InitializeArenaPortrait()
	module:InitializeBossPortrait()
	module:InitializeFocusPortrait()
	module:InitializePartyPortrait()
	module:InitializePetPortrait()
	module:InitializePlayerPortrait()
	module:InitializeTargetPortrait()
	module:InitializeToTPortrait()
end

function module:Initialize()
	module.db = E.db.mMT.portraits

	if module.db.enable then
		module.portraits = module.portraits or {}
		if not module.isEnabled then
			module:RegisterEvent("PLAYER_ENTERING_WORLD")
			hooksecurefunc(UF, "ToggleForceShowGroupFrames", ToggleForceShowGroupFrames)
			hooksecurefunc(UF, "HeaderConfig", HeaderConfig)
			module.isEnabled = true
		end

		local classIconStyle = module.db.misc.class_icon
		local classIcons = (classIconStyle ~= "none") and (MEDIA.icons.class.icons.mmt[classIconStyle] or MEDIA.icons.class.icons.custom[classIconStyle]) or nil
		module.classIcons = classIcons and classIcons.texture or nil
		module.useClassIcons = classIcons and (module.db.misc.class_icon ~= "none") and true or false
		module.texCoords = classIcons and (classIcons.texCoords or MEDIA.icons.class.data) or nil

		module:PLAYER_ENTERING_WORLD()
	elseif module.isEnabled then
		module:UnregisterAllEvents()
		for _, element in pairs(module.portraits) do
			element:UnregisterAllEvents()
			element:Hide()
			element = nil
		end
		module.isEnabled = false
		module.portraits = nil
	end
end
