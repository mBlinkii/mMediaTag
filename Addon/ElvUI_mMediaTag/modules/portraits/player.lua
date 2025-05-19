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




function module:InitializePlayerPortrait()
	print("Initializing Player Portrait", module.db.player.enable)
	if not module.db.player.enable then return end

	local portraits = module.portraits
	local events = { "UNIT_ENTERED_VEHICLE", "UNIT_EXITING_VEHICLE", "UNIT_EXITED_VEHICLE", "VEHICLE_UPDATE" }
	local parent_frame = _G.ElvUF_Player

	if parent_frame then
		local unit = "player"
		local type = "player"

		portraits[unit] = portraits[unit] or module:CreatePortrait("Player", parent_frame)

		if portraits[unit] then
			portraits[unit].__owner = parent_frame
			portraits[unit].unit = parent_frame.unit
			portraits[unit].type = type
			portraits[unit].db = E.db.mMT.portraits.player
			portraits[unit].size = E.db.mMT.portraits.player.size
			portraits[unit].point = E.db.mMT.portraits.player.point
			portraits[unit].isPlayer = nil
			portraits[unit].unitClass = nil
			portraits[unit].lastGUID = nil
			--portraits[unit].func = OnEvent

			portraits.media = module:UpdateTexturesFiles(E.db.mMT.portraits.player.texture, E.db.mMT.portraits.player.mirror)

			module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
			module:InitPortrait(portraits[unit], E.db.mMT.portraits.player.size, E.db.mMT.portraits.player.point)
		end
	end
end

function module:KillPlayerPortrait()
	if module.Portraits.player then
		module:RemovePortrait(module.Portraits.player)
		module.Portraits.player = nil
	end
end
