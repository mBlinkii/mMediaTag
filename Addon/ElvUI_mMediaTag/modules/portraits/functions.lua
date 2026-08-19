local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("Portraits", { "AceEvent-3.0" })
local UF = E:GetModule("UnitFrames")
local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitReaction = UnitReaction
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsConnected = UnitIsConnected
local UnitIsVisible = UnitIsVisible
local SetPortraitTexture = SetPortraitTexture
local CreateFrame = CreateFrame
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitFactionGroup = UnitFactionGroup
local InCombatLockdown = InCombatLockdown
local select = select
local UnitGUID = UnitGUID
local IsUnitModelReadyForUI = IsUnitModelReadyForUI
local C_Timer_NewTimer = C_Timer.NewTimer
local issecretvalue = issecretvalue
local GetSpecialization = C_SpecializationInfo.GetSpecialization or GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo or GetSpecializationInfo

local playerFaction = nil

local function SafeValue(value)
	if issecretvalue and issecretvalue(value) then return nil end
	return value
end

function module:GetUnitColor(unit, class, isPlayer, isDead)
	if not unit then return end

	local colors = MEDIA.color.portraits

	if isDead then return colors.misc.death end

	if module.db.misc.force_default then return colors.misc.default end

	if isPlayer then
		if module.db.misc.force_reaction then
			local unitFaction = SafeValue(UnitFactionGroup(unit))
			playerFaction = playerFaction or UnitFactionGroup("player")

			local reactionType = (playerFaction == unitFaction) and "friendly" or "enemy"
			return colors.reaction[reactionType]
		else
			return colors.class[class] or colors.misc.default
		end
	else
		local reaction = SafeValue((unit == "pet") and UnitReaction("player", unit) or UnitReaction(unit, "player"))
		local reactionType = (reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly")) or "enemy"
		return colors.reaction[reactionType]
	end
end

-- a color built from a secret source has secret components, its alpha must not be branched on
local function ApplyColor(target, color)
	if not (target and color) then return end

	local alpha = color.a
	target:SetVertexColor(color.r, color.g, color.b, (E:IsSecretValue(alpha) or alpha == nil) and 1 or alpha)
end

local function UpdateTextureColor(element, unit)
	local db = module.db.misc
	unit = unit or element.unit

	local color = module:GetUnitColor(unit, element.unitClass, element.isPlayer, element.isDead) -- element.isDead)
	element.color = color
	if not color then return end

	ApplyColor(element.texture, color.c)
	ApplyColor(element.embellishment, color.c)

	local shouldDesaturate = element.isDead or db.desaturate
	if shouldDesaturate ~= element.isDesaturated then
		element.unit_portrait:SetDesaturated(shouldDesaturate)
		element.isDesaturated = shouldDesaturate
	end
end

local function GetCastIcon(unit)
	return select(3, UnitCastingInfo(unit)) or select(3, UnitChannelInfo(unit))
end

local function SetupExtraTexture(element, low)
	local extraOnTop = module.db.misc.extratop and not low
	element.extra:SetDrawLayer(extraOnTop and "OVERLAY" or "ARTWORK", extraOnTop and 7 or 0)

	if not extraOnTop and not element.extra_mask then
		element.extra_mask = element:CreateMaskTexture()
		element.extra_mask:SetAllPoints(element.extra)
		element.extra:AddMaskTexture(element.extra_mask)
	elseif element.extra_mask then
		element.extra:RemoveMaskTexture(element.extra_mask)
	end
end

local function UpdateExtraTexture(element, force)
	local extra = element.extra
	if extra and not element.db.extra then return extra:Hide() end

	local db, e_db = module.db.misc, element.db
	local classification = force or mMT:GetUnitClassification(element.unit, element.type == "boss", element.isPlayer, element.lastGUID)

	local color
	if e_db.unitcolor then
		color = element.color
	elseif db.force_reaction then
		local reaction = SafeValue(UnitReaction(element.unit, "player"))
		local reactionType = (reaction and ((reaction <= 3 and "enemy") or (reaction == 4 and "neutral") or "friendly")) or "enemy"
		color = MEDIA.color.portraits.reaction[reactionType]
	else
		color = MEDIA.color.portraits.classification[classification]
	end

	local media = element.media[classification]
	if not (color and media) then return extra:Hide() end

	SetupExtraTexture(element, media.low)
	extra:SetTexture(media.texture, "CLAMP", "CLAMP", "TRILINEAR")

	ApplyColor(extra, color.c)

	extra:Show()
end

local Update

local function RetryPortrait(element)
	if element.portraitRetry or not element:IsVisible() or (element.portraitTries or 0) >= 10 then return end
	element.portraitTries = (element.portraitTries or 0) + 1

	element.portraitRetry = C_Timer_NewTimer(0.2, function()
		element.portraitRetry = nil
		if element:IsVisible() then Update(element, "ForceUpdate") end
	end)
end

function Update(self, event)
	local unit = self.unit or self.__owner.__unit
	if not unit then return end

	-- a secret unit is always a player, its class token stays secret
	local isSecret = E:IsSecretUnit(unit) or false
	local class = SafeValue(select(2, UnitClass(unit)))
	local isDead = not isSecret and SafeValue(UnitIsDeadOrGhost(unit)) or false
	local guid = UnitGUID(unit)
	local secretGUID = E:IsSecretValue(guid)
	local newGUID = secretGUID or (self.guid ~= guid)
	guid = not secretGUID and guid or ""

	if newGUID then self.guid = guid end
	self.lastGUID = secretGUID and " " or guid

	local isAvailable = self:IsVisible() and IsUnitModelReadyForUI(unit) and UnitIsConnected(unit) and UnitIsVisible(unit)
	-- full update only on a real change (GUID, availability, death); same-GUID model changes arrive as ForceUpdate.
	local hasStateChanged = newGUID or (self.state ~= isAvailable) or event == "ForceUpdate" or (self.isDead ~= isDead)

	if hasStateChanged then
		local isPlayer = isSecret or SafeValue(UnitIsPlayer(unit)) or (E.Retail and SafeValue(UnitInPartyIsAI(unit))) or false
		local shouldMirror = (isPlayer and self.db.mirror) or (not isPlayer and not self.db.mirror)

		local applied = false

		if module.useClassIcons and isPlayer and class then
			local coords = module.texCoords[class]
			if coords then
				self.unit_portrait:SetTexture(module.classIcons, "CLAMP", "CLAMP", "TRILINEAR")
				module:Mirror(self.unit_portrait, shouldMirror, coords.texCoords or coords)
				applied = true
			end
		elseif module.useSpecIcon and isPlayer and not isSecret then
			local info = E.Retail and E:GetUnitSpecInfo(unit)

			if info then
				if module.db.misc.spec_icon == "blizzard" then
					if info.icon then
						self.unit_portrait:SetTexture(info.icon, "CLAMP", "CLAMP", "TRILINEAR")
						module:Mirror(self.unit_portrait, shouldMirror)
						applied = true
					end
				else
					local coords = info.id and module.texCoords[info.id]
					if coords then
						self.unit_portrait:SetTexture(module.specIcons, "CLAMP", "CLAMP", "TRILINEAR")
						module:Mirror(self.unit_portrait, shouldMirror, coords.texCoords or coords)
						applied = true
					end
				end
			end
		end

		if applied then
			self.portraitSet = nil
		else
			-- fallback so a not-yet-inspected member never keeps the previous units texture; INSPECT_READY repeats the update.
			-- SetPortraitTexture paints solid black while the model is not ready (quest/item transform), so keep the old texture and retry.
			if isAvailable or newGUID or not self.portraitSet then
				SetPortraitTexture(self.unit_portrait, unit, true)
				module:Mirror(self.unit_portrait, shouldMirror)
			end

			self.portraitSet = isAvailable
			if isAvailable then
				self.portraitTries = nil
			else
				RetryPortrait(self)
			end
		end

		self.state = isAvailable
		self.isSecret = isSecret
		self.isPlayer = isPlayer
		self.unit = unit
		self.unitClass = class
		self.isDead = isDead

		if isDead then
			self:RegisterUnitEvent("UNIT_HEALTH", unit)
		elseif self.eventsSet then
			self:UnregisterEvent("UNIT_HEALTH")
		end

		UpdateTextureColor(self, unit)
		UpdateExtraTexture(self, self.forceExtra ~= "none" and self.forceExtra or nil)

		if not InCombatLockdown() and self:GetAttribute("unit") ~= unit then self:SetAttribute("unit", unit) end
	end
end

local function DemoUpdate(self)
	local element = self
	local texCoords
	local unit = "player"
	local class = select(2, UnitClass(unit))
	local specID = select(1, GetSpecializationInfo(GetSpecialization()))
	local isPlayer = true
	local shouldMirror = (isPlayer and self.db.mirror) or (not isPlayer and not self.db.mirror)

	if module.useSpecIcon and isPlayer then
		texCoords = module.texCoords[specID].texCoords or module.texCoords[specID]
		element.unit_portrait:SetTexture(module.specIcons, "CLAMP", "CLAMP", "TRILINEAR")
	elseif module.useClassIcons and isPlayer then
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

	portrait.texture = portrait:CreateTexture("mMT-Portrait-Texture-" .. name, "ARTWORK", nil, 5)
	portrait.texture:SetPoint("CENTER", portrait, "CENTER", 0, 0)

	portrait.mask = portrait:CreateMaskTexture()
	portrait.mask:SetAllPoints(portrait.texture)

	portrait.unit_portrait = portrait:CreateTexture("mMT-Portrait-Unit-Portrait-" .. name, "ARTWORK", nil, 3)
	portrait.unit_portrait:SetPoint("CENTER", portrait.texture, "CENTER")
	portrait.unit_portrait:AddMaskTexture(portrait.mask)

	local extraOnTop = module.db.misc.extratop
	portrait.extra = portrait:CreateTexture("mMT-Portrait-Extra-" .. name, "OVERLAY", nil, extraOnTop and 7 or 0)

	if settings.extra_settings.enable then
		portrait.extra:SetPoint("CENTER", portrait.texture, "CENTER", settings.extra_settings.offset.x, settings.extra_settings.offset.y)
		portrait.extra.changed = true
	else
		portrait.extra:SetAllPoints(portrait.texture)
	end

	if not extraOnTop then
		portrait.extra_mask = portrait:CreateMaskTexture()
		portrait.extra_mask:SetAllPoints(portrait.extra)
		portrait.extra:AddMaskTexture(portrait.extra_mask)
	end

	portrait.bg = portrait:CreateTexture("mMT-Portrait-BG-" .. name, "ARTWORK", nil, 1)
	portrait.bg:SetAllPoints(portrait.texture)
	portrait.bg:AddMaskTexture(portrait.mask)

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

		if element.db.strata ~= "AUTO" then element:SetFrameStrata(element.db.strata) end
		element:SetFrameLevel(element.db.level)
	end
end

local function UpdateCastIconStart(self)
	self.isCasting = true

	local texture = GetCastIcon(self.unit)
	if texture then
		local mirror = self.db.mirror
		self.unit_portrait:SetTexture(texture)
		self.unit_portrait:SetTexCoord(mirror and 1 or 0, mirror and 0 or 1, 0, 1)
		self.portraitSet = nil
	end
end

local function UpdateCastIconStop(self)
	self.isCasting = false

	Update(self, "ForceUpdate")
end

local function SimpleUpdate(self, event)
	Update(self, event)
end

-- RegisterUnitEvent instead of RegisterEvent: unfiltered, every party portrait ran its handler for every unit in the game.
local portraitUnitEvents = { "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED", "UNIT_CONNECTION" }
local castUnitEvents = {
	"UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_STOP",
	"UNIT_SPELLCAST_CHANNEL_STOP",
}
local castUnitEventsRetail = { "UNIT_SPELLCAST_EMPOWER_START", "UNIT_SPELLCAST_EMPOWER_STOP" }

-- re-targets every filtered event to the elements current unit; call after any unit change (party reorder, roster update, OnShow).
local function ApplyUnitEvents(element, force)
	local unit = element.unit or (element.__owner and element.__owner.__unit)
	if not unit then return end
	if not force and element.registeredUnit == unit then return end
	element.registeredUnit = unit
	element.unit = unit

	for _, event in next, portraitUnitEvents do
		element:RegisterUnitEvent(event, unit)
	end

	if element.db and element.db.cast then
		for _, event in next, castUnitEvents do
			element:RegisterUnitEvent(event, unit)
		end

		if E.Retail then
			for _, event in next, castUnitEventsRetail do
				element:RegisterUnitEvent(event, unit)
			end
		end
	end

	if element.isDead then element:RegisterUnitEvent("UNIT_HEALTH", unit) end
end

-- hidden frames skip all event work, so catch up on show
local function OnShow(self)
	if not self.db then return end
	ApplyUnitEvents(self)
	Update(self, "ForceUpdate")
end

-- party reordering re-assigns the buttons unit attribute - re-target the filtered events
local function OnUnitAttributeChanged(frame, name, value)
	if name ~= "unit" or not value then return end

	local element = frame.mMT_Portrait
	if element and element.registeredUnit ~= value then
		element.unit = value
		ApplyUnitEvents(element)
		if element:IsVisible() then Update(element, "ForceUpdate") end
	end
end

local function PartyUpdate(_, header)
	if not module.portraits then return end

	if header.groupName == "party" then
		for i = 1, 5 do
			local element = module.portraits["party" .. i]
			if element then
				element.unit = element.__owner.__unit
				ApplyUnitEvents(element)
				Update(element, "ForceUpdate")
			end
		end
	end
end

local function ForceUpdate(self, event)
	Update(self, "ForceUpdate")
end

local function DeathCheck(self, event)
	local isDead = not self.isSecret and SafeValue(UnitIsDeadOrGhost(self.unit)) or false
	if self.isDead == isDead then return end

	self.isDead = isDead
	Update(self, event)

	-- UNIT_HEALTH only for dead units
	if isDead then
		self:RegisterUnitEvent("UNIT_HEALTH", self.unit)
	else
		self:UnregisterEvent("UNIT_HEALTH")
	end
end

local eventHandlers = {
	-- these keep the GUID so they must bypass change detection; UNIT_MODEL_CHANGED is the one that fires once a transformed model is loaded.
	PORTRAITS_UPDATED = ForceUpdate,
	UNIT_CONNECTION = Update,
	UNIT_PORTRAIT_UPDATE = ForceUpdate,
	UNIT_MODEL_CHANGED = ForceUpdate,
	PARTY_MEMBER_ENABLE = Update,
	PARTY_MEMBER_DISABLE = Update,

	UNIT_SPELLCAST_CHANNEL_START = UpdateCastIconStart,
	UNIT_SPELLCAST_START = UpdateCastIconStart,

	UNIT_SPELLCAST_CHANNEL_STOP = UpdateCastIconStop,
	UNIT_SPELLCAST_INTERRUPTED = UpdateCastIconStop,
	UNIT_SPELLCAST_STOP = UpdateCastIconStop,

	UNIT_SPELLCAST_EMPOWER_START = UpdateCastIconStart,
	UNIT_SPELLCAST_EMPOWER_STOP = UpdateCastIconStop,

	-- vehicle updates (model swaps without a GUID change - bypass change detection)
	UNIT_ENTERED_VEHICLE = ForceUpdate,
	UNIT_EXITING_VEHICLE = ForceUpdate,
	UNIT_EXITED_VEHICLE = ForceUpdate,
	VEHICLE_UPDATE = ForceUpdate,

	PLAYER_TARGET_CHANGED = SimpleUpdate,
	PLAYER_FOCUS_CHANGED = SimpleUpdate,
	UNIT_TARGET = SimpleUpdate,

	-- roster changes reshuffle unit tokens without reliable per-token events - always force
	GROUP_ROSTER_UPDATE = ForceUpdate,

	-- spec info arrives async via inspect - repaint once (only with spec icons enabled)
	INSPECT_READY = function(self, _, guid)
		if module.useSpecIcon and guid and guid == self.guid then Update(self, "ForceUpdate") end
	end,

	ARENA_OPPONENT_UPDATE = Update,
	UNIT_TARGETABLE_CHANGED = Update,
	ARENA_PREP_OPPONENT_SPECIALIZATIONS = SimpleUpdate,
	-- force: the boss1-bossN tokens become valid here without a GUID change
	INSTANCE_ENCOUNTER_ENGAGE_UNIT = ForceUpdate,
	UPDATE_ACTIVE_BATTLEFIELD = SimpleUpdate,

	UNIT_HEALTH = DeathCheck,

	UNIT_PET = ForceUpdate,
}

local function OnEvent(self, event, eventUnit)
	-- hidden frames do no event work, OnShow catches up with one ForceUpdate
	if not self:IsVisible() then return end

	local unit = self.__owner.__unit or self.unit
	if unit ~= self.unit then
		self.unit = unit
		ApplyUnitEvents(self) -- unit token changed - re-target filtered events
	end

	if eventHandlers[event] then eventHandlers[event](self, event, eventUnit) end
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
		if module.db.misc.embellishment and element.media.embellishment and not element.embellishment then
			element.embellishment = element:CreateTexture("mMT-Portrait-Embellishment-" .. element.name, "OVERLAY", nil, 6)
			element.embellishment:SetAllPoints(element.texture)
		elseif not module.db.misc.embellishment and element.embellishment then
			element.embellishment:Hide()
			element.embellishment = nil
		end

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

		-- non-unit events (fire without unit filter)
		if not element.eventsSet then
			element:RegisterEvent("PORTRAITS_UPDATED")

			if element.type == "party" then
				element:RegisterEvent("PARTY_MEMBER_ENABLE")
				element:RegisterEvent("PARTY_MEMBER_DISABLE")
			end

			element.eventsSet = true
		end

		-- module-level flag: the hook already loops all 5 party portraits
		if element.type == "party" and not module.partyHeaderHooked then
			hooksecurefunc(UF, "Update_PartyHeader", PartyUpdate)
			module.partyHeaderHooked = true
		end

		-- safety net for party reordering: watch the buttons secure unit attribute
		if element.type == "party" and element.__owner and not element.unitAttributeHooked then
			element.__owner.mMT_Portrait = element
			element.__owner:HookScript("OnAttributeChanged", OnUnitAttributeChanged)
			element.unitAttributeHooked = true
		end

		-- cast events disabled since last init -> drop them
		if element.cast_eventsSet and not element.db.cast then
			for _, event in next, castUnitEvents do
				element:UnregisterEvent(event)
			end

			if E.Retail then
				for _, event in next, castUnitEventsRetail do
					element:UnregisterEvent(event)
				end
			end
		end
		element.cast_eventsSet = element.db.cast and true or false

		-- unit-filtered events (force: settings or unit may have changed)
		ApplyUnitEvents(element, true)

		if SafeValue(UnitIsDeadOrGhost(element.unit or "")) then element:RegisterUnitEvent("UNIT_HEALTH", element.unit) end

		element:SetScript("OnShow", OnShow)
		element:SetScript("OnEvent", OnEvent)
		Update(element, "ForceUpdate")
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
	texture:SetTexture(file, wrapMode, wrapMode)
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
	if not module.db.enable then return end
	if group == "boss" or group == "arena" then
		for i = 1, numGroup do
			local unit = group .. i
			if module.portraits[unit] then DemoUpdate(module.portraits[unit]) end
		end
	end
end

local function HeaderConfig(_, header, configMode)
	if not module.db.enable then return end
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
	module.db = E.db.mMediaTag.portraits

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
		local specIconStyle = module.db.misc.spec_icon
		local specIcons = (specIconStyle ~= "none") and (MEDIA.icons.spec.icons.mmt[specIconStyle] or MEDIA.icons.spec.icons.custom[specIconStyle]) or nil

		local useClassIcons = (classIcons and (module.db.misc.class_icon ~= "none") and (module.db.misc.spec_icon == "none")) and true or false
		local useSpecIcon = ((specIcons or specIconStyle == "blizzard")) and (module.db.misc.spec_icon ~= "none") and true or false

		module.classIcons = classIcons and classIcons.texture or nil
		module.useClassIcons = useClassIcons and classIcons
		module.texCoords = useSpecIcon and (specIcons and (specIcons.texCoords or MEDIA.icons.spec.data)) or classIcons and (classIcons.texCoords or MEDIA.icons.class.data) or nil
		module.specIcons = specIcons and specIcons.texture or nil
		module.useSpecIcon = useSpecIcon and (specIcons or specIconStyle == "blizzard")

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
