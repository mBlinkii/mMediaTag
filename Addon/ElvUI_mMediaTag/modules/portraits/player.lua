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

function module:InitializePlayerPortrait()
	if not module.db.profile.player.enable then return end

	local portraits = module.portraits
	local events = { "UNIT_PORTRAIT_UPDATE", "PORTRAITS_UPDATED", "UNIT_ENTERED_VEHICLE", "UNIT_EXITING_VEHICLE", "UNIT_EXITED_VEHICLE", "VEHICLE_UPDATE" }
	local parent = _G.ElvUF_Player

	if parent then
		local unit = "player"
		local type = "player"

		portraits[unit] = portraits[unit] or module:CreatePortrait("player", parent)

		if portraits[unit] then
			portraits[unit].events = {}
			portraits[unit].parentFrame = parent
			portraits[unit].unit = parent.unit
			portraits[unit].type = type
			portraits[unit].db = module.db.profile[type]
			portraits[unit].size = module.db.profile[type].size
			portraits[unit].point = module.db.profile[type].point
			portraits[unit].useClassIcon = module.db.profile.misc.class_icon ~= "none"
			portraits[unit].func = OnEvent

			portraits[unit].isPlayer = nil
			portraits[unit].unitClass = nil
			portraits[unit].lastGUID = nil
			portraits[unit].forceUpdate = true

			module:UpdateTexturesFiles(portraits[unit], module.db.profile[type])
			module:UpdateSize(portraits[unit])
			module:UpdateCastSettings(portraits[unit])

			module:InitPortrait(portraits[unit], events)
		end
	end
end

function module:KillPlayerPortrait()
	if module.Portraits.player then
		module:RemovePortrait(module.Portraits.player)
		module.Portraits.player = nil
	end
end
