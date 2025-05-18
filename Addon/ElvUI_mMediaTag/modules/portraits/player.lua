local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

local UnitGUID = UnitGUID
local UnitExists = UnitExists

local function OnEvent(portrait, event, eventUnit, arg2)
	local unit = (portrait.demo and not UnitExists(portrait.parentFrame.unit)) and "player" or (portrait.unit or portrait.parentFrame.unit)

	if not unit or not UnitExists(unit) or ((event == "PORTRAITS_UPDATED" or event == "UNIT_PORTRAIT_UPDATE" or event == "UNIT_HEALTH") and unit ~= eventUnit) then return end

	if event == "VEHICLE_UPDATE" or event == "UNIT_EXITING_VEHICLE" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "PET_UI_UPDATE" then
		unit = (UnitInVehicle("player") and arg2) and "pet" or "player"
	end

	portrait.unit = unit

	if event == "UNIT_HEALTH" then
		portrait.isDead = module:UpdateDeathStatus(unit)
		return
	end

	local guid = UnitGUID(unit)
	if portrait.lastGUID ~= guid or portrait.forceUpdate then
		local color, isPlayer, class = module:GetUnitColor(unit, portrait.isDead)

		portrait.isPlayer = isPlayer
		portrait.unitClass = class
		portrait.lastGUID = guid

		if color then portrait.texture:SetVertexColor(color.r, color.g, color.b, color.a or 1) end

		module:UpdatePortrait(portrait, event, portrait.demo and unit)
		module:UpdateExtraTexture(portrait, portrait.db.unitcolor and color, portrait.db.extra and "player")

		portrait.forceUpdate = false
	else
		module:UpdatePortrait(portrait, event, portrait.demo and unit)
	end

	if not InCombatLockdown() and portrait:GetAttribute("unit") ~= unit then portrait:SetAttribute("unit", unit) end
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
			SetPortraitTexture(element.unit_portrait, unit, true)
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

local function Enable(self, unit)
	local element = self.Portrait
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_MODEL_CHANGED", Path)
		self:RegisterEvent("UNIT_PORTRAIT_UPDATE", Path)
		self:RegisterEvent("PORTRAITS_UPDATED", Path, true)
		self:RegisterEvent("UNIT_CONNECTION", Path)

		-- The quest log uses PARTY_MEMBER_{ENABLE,DISABLE} to handle updating of
		-- party members overlapping quests. This will probably be enough to handle
		-- model updating.
		--
		-- DISABLE isn't used as it fires when we most likely don't have the
		-- information we want.
		if unit == "party" then self:RegisterEvent("PARTY_MEMBER_ENABLE", Path) end

		element:Show()

		return true
	end
end

local function Disable(self)
	local element = self.Portrait
	if element then
		element:Hide()

		self:UnregisterEvent("UNIT_MODEL_CHANGED", Path)
		self:UnregisterEvent("UNIT_PORTRAIT_UPDATE", Path)
		self:UnregisterEvent("PORTRAITS_UPDATED", Path)
		self:UnregisterEvent("PARTY_MEMBER_ENABLE", Path)
		self:UnregisterEvent("UNIT_CONNECTION", Path)
	end
end

function module:InitializePlayerPortrait()
	print("Initializing Player Portrait", module.db.player.enable)
	if not module.db.player.enable then return end

	local portraits = module.portraits
	local events = { "UNIT_PORTRAIT_UPDATE", "PORTRAITS_UPDATED", "UNIT_ENTERED_VEHICLE", "UNIT_EXITING_VEHICLE", "UNIT_EXITED_VEHICLE", "VEHICLE_UPDATE" }
	local parent = _G.ElvUF_Player

	if parent then
		print("Creating Player Portrait")
		local unit = "player"
		local type = "player"
		local name = "Player"

		local db = module.db.player
		local size = db.size
		local point = db.point

		local element = CreateFrame("Button", "mMT-Portrait-" .. name, parent, "SecureUnitButtonTemplate")

		element.unit = unit --parent.unit
		element.type = type
		element.db = module.db[type]
		element.__owner = _G.ElvUF_Player
		element.ForceUpdate = ForceUpdate

		-- texture
		element.texture = element:CreateTexture("mMT-Portrait-Texture-" .. name, "ARTWORK", nil, 4)
		element.texture:SetPoint("CENTER", element, "CENTER", 0, 0)

		-- shadow
		element.shadow = element:CreateTexture("mMT-Portrait-Shadow-" .. name, "ARTWORK", nil, 0)
		element.shadow:SetPoint("CENTER", element, "CENTER", 0, 0)

		-- mask
		element.mask = element:CreateMaskTexture()
		element.mask:SetAllPoints(element.texture)

		-- portrait
		element.unit_portrait = element:CreateTexture("mMT-Portrait-Unit-Portrait-" .. name, "ARTWORK", nil, 2)
		element.unit_portrait:SetAllPoints(element.texture)
		element.unit_portrait:AddMaskTexture(element.mask)

		-- rare/elite/boss
		local extraOnTop = module.db.misc.extratop
		element.extra = element:CreateTexture("mMT-Portrait-Extra-" .. name, "OVERLAY", nil, extraOnTop and 7 or 1)
		element.extra:SetAllPoints(element.texture)

		-- extra mask
		if not extraOnTop then
			element.extra_mask = element:CreateMaskTexture()
			element.extra_mask:SetAllPoints(element.texture)
			element.extra:AddMaskTexture(element.extra_mask)
		end

		-- bg
		element.bg = element:CreateTexture("mMT-Portrait-BG-" .. name, "BACKGROUND", nil, 1)
		element.bg:SetAllPoints(element.texture)
		element.bg:AddMaskTexture(element.mask)
		--portrait.bg:SetVertexColor(0, 0, 0, 1)

		-- scripts to interact with mouse
		element:SetAttribute("unit", element.unit)
		element:SetAttribute("*type1", "target")
		element:SetAttribute("*type2", "togglemenu")
		element:SetAttribute("type3", "focus")
		element:SetAttribute("toggleForVehicle", true)
		element:SetAttribute("ping-receiver", true)
		element:RegisterForClicks("AnyUp")

		--portraits[unit].portrait = portraits[unit].portrait or module:CreatePortrait(portraits[unit], "Player")
		element.media = module:UpdateTexturesFiles(module.db.player)
		module:InitPortrait(element)

		portraits[unit] = element
		portraits[unit]:Show()
		portraits[unit]:ForceUpdate(element)
	end

	-- if parent then
	-- 	local unit = "player"
	-- 	local type = "player"

	-- 	portraits[unit] = portraits[unit] or module:CreatePortrait("player", parent)

	-- 	if portraits[unit] then
	-- 		portraits[unit].events = {}
	-- 		portraits[unit].parentFrame = parent
	-- 		portraits[unit].unit = parent.unit
	-- 		portraits[unit].type = type
	-- 		portraits[unit].db = module.db.profile[type]
	-- 		portraits[unit].size = module.db.profile[type].size
	-- 		portraits[unit].point = module.db.profile[type].point
	-- 		portraits[unit].useClassIcon = module.db.profile.misc.class_icon ~= "none"
	-- 		portraits[unit].func = OnEvent

	-- 		portraits[unit].isPlayer = nil
	-- 		portraits[unit].unitClass = nil
	-- 		portraits[unit].lastGUID = nil
	-- 		portraits[unit].forceUpdate = true

	-- 		module:UpdateTexturesFiles(portraits[unit], module.db.profile[type])
	-- 		module:UpdateSize(portraits[unit])
	-- 		module:UpdateCastSettings(portraits[unit])

	-- 		module:InitPortrait(portraits[unit], events)
	-- 	end
	-- end
end

function module:KillPlayerPortrait()
	if module.Portraits.player then
		module:RemovePortrait(module.Portraits.player)
		module.Portraits.player = nil
	end
end
