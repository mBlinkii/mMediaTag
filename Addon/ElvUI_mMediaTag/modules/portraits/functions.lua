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
local select, tinsert = select, tinsert

local mediaPortraits = module.media.portraits
local mediaExtra = module.media.extra
local mediaClass = module.media.class

local playerFaction = nil

-- portrait texture update functions
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

function module:UpdateTextures(portrait)
	local mirror = portrait.db.mirror

	SetTexture(portrait.texture, portrait.textureFile, "CLAMP")
	SetTexture(portrait.mask, portrait.maskFile, "CLAMPTOBLACKADDITIVE")

	if portrait.extraMask then SetTexture(portrait.extraMask, portrait.extraMaskFile, "CLAMPTOBLACKADDITIVE") end
	SetTexture(portrait.bg, portrait.bgFile, "CLAMP")

	module:Mirror(portrait.texture, mirror)
	module:Mirror(portrait.extra, mirror)
end

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

function module:UpdateSize(portrait, size, point)
	if not InCombatLockdown() then
		size = size or portrait.size
		point = point or portrait.point
		portrait:SetSize(size/2, size/2)
		portrait.texture:SetSize(size, size)
		portrait:ClearAllPoints()
		portrait:SetPoint(point.point, portrait.parentFrame, point.relativePoint, point.x, point.y)

		if portrait.db.strata ~= "AUTO" then portrait:SetFrameStrata(portrait.db.strata) end
		portrait:SetFrameLevel(portrait.db.level)
	end
end

function module:UpdateTexturesFiles(portrait, settings)
	local dbMisc = module.db.profile.misc
	local dbCustom = module.db.profile.custom
	local media = mediaPortraits[settings.texture]

	portrait.bgFile = "Interface\\Addons\\Blinkiis_Portraits\\media\\blank.tga"

	if portrait.useClassIcon then portrait.classIcons = mediaClass[module.db.profile.misc.class_icon] end

	if dbCustom.enable then
		portrait.textureFile = "Interface\\Addons\\" .. dbCustom.texture
		portrait.maskFile = "Interface\\Addons\\" .. dbCustom.mask

		portrait.extraMaskFile = "Interface\\Addons\\" .. dbCustom.extra_mask

		if dbCustom.extra then
			portrait.playerFile = "Interface\\Addons\\" .. dbCustom.player

			portrait.rareFile = "Interface\\Addons\\" .. dbCustom.rare
			portrait.eliteFile = "Interface\\Addons\\" .. dbCustom.elite
			portrait.rareeliteFile = "Interface\\Addons\\" .. dbCustom.rareelite
			portrait.bossFile = "Interface\\Addons\\" .. dbCustom.boss
		else
			portrait.playerFile = mediaExtra[dbMisc.player]

			portrait.rareFile = mediaExtra[dbMisc.rare]
			portrait.eliteFile = mediaExtra[dbMisc.elite]
			portrait.rareeliteFile = mediaExtra[dbMisc.rareelite]
			portrait.bossFile = mediaExtra[dbMisc.boss]
		end
	else
		portrait.textureFile = media.texture
		portrait.maskFile = (settings.mirror and media.mask_mirror) and media.mask_mirror or media.mask

		portrait.extraMaskFile = (settings.mirror and media.extra_mirror) and media.extra_mirror or media.extra

		portrait.playerFile = mediaExtra[dbMisc.player]

		portrait.rareFile = mediaExtra[dbMisc.rare]
		portrait.eliteFile = mediaExtra[dbMisc.elite]
		portrait.rareeliteFile = mediaExtra[dbMisc.rareelite]
		portrait.bossFile = mediaExtra[dbMisc.boss]
	end
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

function module:CreatePortrait(name, parent)
	if parent then
		local portrait = CreateFrame("Button", "BP_Portrait_" .. name, parent, "SecureUnitButtonTemplate")

		-- texture
		portrait.texture = portrait:CreateTexture("BP_texture-" .. name, "ARTWORK", nil, 4)
		portrait.texture:SetPoint("CENTER", portrait, "CENTER", 0, 0)

		-- mask
		portrait.mask = portrait:CreateMaskTexture()
		portrait.mask:SetAllPoints(portrait.texture)

		-- portrait
		portrait.portrait = portrait:CreateTexture("BP_portrait-" .. name, "ARTWORK", nil, 2)
		portrait.portrait:SetAllPoints(portrait.texture)
		portrait.portrait:AddMaskTexture(portrait.mask)
		local unit = (parent.unit == "party" or not parent.unit) and "player" or parent.unit

		-- rare/elite/boss
		local extraOnTop = module.db.profile.misc.extratop
		portrait.extra = portrait:CreateTexture("BP_extra-" .. name, "OVERLAY", nil, extraOnTop and 7 or 1)
		portrait.extra:SetAllPoints(portrait.texture)

		-- extra mask
		if not extraOnTop then
			portrait.extraMask = portrait:CreateMaskTexture()
			portrait.extraMask:SetAllPoints(portrait.texture)
			portrait.extra:AddMaskTexture(portrait.extraMask)
		end

		-- bg
		portrait.bg = portrait:CreateTexture("BP_bg-" .. name, "BACKGROUND", nil, 1)
		portrait.bg:SetAllPoints(portrait.texture)
		portrait.bg:AddMaskTexture(portrait.mask)
		portrait.bg:SetVertexColor(0, 0, 0, 1)

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
end

function module:InitPortrait(portrait, events)
	if portrait then
		module:UpdateTextures(portrait)

		if not portrait.eventsSet then
			module:RegisterEvents(portrait, events)

			portrait:SetScript("OnEvent", portrait.func)
			portrait.eventsSet = true
		end
		portrait:func(portrait)

		UpdateZoom(portrait.portrait, portrait.size)
	end
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

function module:RegisterCastEvents(portrait)
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

function module:UpdateCastSettings(portrait)
	if portrait.db.cast then
		module:RegisterCastEvents(portrait)
		portrait.cast = true
	elseif portrait.cast then
		module:UnregisterCastEvents(portrait)
		portrait.cast = false
	end
end

function module:Initialize()
	if E.db.mMT.portraits.enable then
		module.db = E.db.mMT.portraits
		module.portraits = module.portraits or {}

		module:InitializeArenaPortrait()
		module:InitializeBossPortrait()
		module:InitializeFocusPortrait()
		module:InitializePartyPortrait()
		module:InitializePetPortrait()
		module:InitializePlayerPortrait()
		module:InitializeTargetPortrait()
		module:InitializeTargetTargetPortrait()
	else
		module:InitializeArenaPortrait()
		module:InitializeBossPortrait()
		module:InitializeFocusPortrait()
		module:InitializePartyPortrait()
		module:InitializePetPortrait()
		module:InitializePlayerPortrait()
		module:InitializeTargetPortrait()
		module:InitializeTargetTargetPortrait()
	end
end
