local UnitGUID = UnitGUID
local UnitExists = UnitExists

local function OnEvent(portrait, event, eventUnit, arg2)
	local unit = portrait.isCellParentFrame and portrait.parentFrame._unit or portrait.parentFrame.unit
	unit = (portrait.demo and not UnitExists(unit)) and "player" or (portrait.unit or unit)

	if not unit or not UnitExists(unit) or ((event == "PORTRAITS_UPDATED" or event == "UNIT_PORTRAIT_UPDATE" or event == "UNIT_HEALTH") and unit ~= eventUnit) then return end

	if event == "VEHICLE_UPDATE" or event == "UNIT_EXITING_VEHICLE" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "PET_UI_UPDATE" then
		unit = (UnitInVehicle("player") and arg2) and "pet" or "player"
	end

	portrait.unit = unit

	if event == "UNIT_HEALTH" then
		portrait.isDead = BLINKIISPORTRAITS:UpdateDeathStatus(unit)
		return
	end

	local guid = UnitGUID(unit)
	if portrait.lastGUID ~= guid or portrait.forceUpdate then
		local color, isPlayer, class = BLINKIISPORTRAITS:GetUnitColor(unit, portrait.isDead)

		portrait.isPlayer = isPlayer
		portrait.unitClass = class
		portrait.lastGUID = guid

		if color then portrait.texture:SetVertexColor(color.r, color.g, color.b, color.a or 1) end

		BLINKIISPORTRAITS:UpdatePortrait(portrait, event, portrait.demo and unit)
		BLINKIISPORTRAITS:UpdateExtraTexture(portrait, portrait.db.unitcolor and color, portrait.db.extra and "player")

		portrait.forceUpdate = false
	else
		BLINKIISPORTRAITS:UpdatePortrait(portrait, event, portrait.demo and unit)
	end

	if not InCombatLockdown() and portrait:GetAttribute("unit") ~= unit then portrait:SetAttribute("unit", unit) end
end

function BLINKIISPORTRAITS:InitializePlayerPortrait()
	if not BLINKIISPORTRAITS.db.profile.player.enable then return end

	local unitframe, parentFrame = BLINKIISPORTRAITS:GetUnitFrames("player", BLINKIISPORTRAITS.db.profile.player.unitframe)
	if unitframe then
		local portraits = BLINKIISPORTRAITS.Portraits
		local events = { "UNIT_PORTRAIT_UPDATE", "PORTRAITS_UPDATED", "UNIT_ENTERED_VEHICLE", "UNIT_EXITING_VEHICLE", "UNIT_EXITED_VEHICLE", "VEHICLE_UPDATE" }
		local parent = _G[unitframe]

		if parent then
			local unit = "player"
			local type = "player"

			portraits[unit] = portraits[unit] or BLINKIISPORTRAITS:CreatePortrait("player", _G[unitframe])

			if portraits[unit] then
				if BLINKIISPORTRAITS.db.profile[type].unitframe ~= "auto" then portraits[unit]:SetParent(_G[unitframe]) end
				local isCellParentFrame = (parentFrame == "cell") and BLINKIISPORTRAITS.Cell
				portraits[unit].events = {}
				portraits[unit].parentFrame = parent
				portraits[unit].isCellParentFrame = isCellParentFrame
				portraits[unit].unit = isCellParentFrame and parent._unit or parent.unit
				portraits[unit].type = type -- frameType or frame.type
				portraits[unit].db = BLINKIISPORTRAITS.db.profile[type]
				portraits[unit].size = BLINKIISPORTRAITS.db.profile[type].size
				portraits[unit].point = BLINKIISPORTRAITS.db.profile[type].point
				portraits[unit].useClassIcon = BLINKIISPORTRAITS.db.profile.misc.class_icon ~= "none"
				portraits[unit].demo = BLINKIISPORTRAITS.SUF and not ShadowUF.db.profile.locked
				portraits[unit].func = OnEvent

				portraits[unit].isPlayer = nil
				portraits[unit].unitClass = nil
				portraits[unit].lastGUID = nil
				portraits[unit].forceUpdate = true

				BLINKIISPORTRAITS:UpdateTexturesFiles(portraits[unit], BLINKIISPORTRAITS.db.profile[type])
				BLINKIISPORTRAITS:UpdateSize(portraits[unit])
				BLINKIISPORTRAITS:UpdateCastSettings(portraits[unit])

				BLINKIISPORTRAITS:InitPortrait(portraits[unit], events)
			end
		end
	end
end

function BLINKIISPORTRAITS:KillPlayerPortrait()
	if BLINKIISPORTRAITS.Portraits.player then
		BLINKIISPORTRAITS:RemovePortrait(BLINKIISPORTRAITS.Portraits.player)
		BLINKIISPORTRAITS.Portraits.player = nil
	end
end
