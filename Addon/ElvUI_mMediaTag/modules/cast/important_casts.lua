local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ImportantCasts", { "AceEvent-3.0" })

local IsSpellImportant = C_Spell and C_Spell.IsSpellImportant
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

local EDGE_FILE = [[Interface\BUTTONS\WHITE8X8]]
local backdropInfo = { edgeFile = EDGE_FILE, edgeSize = 2 }

-- Thanks to Trenchy for letting me use his code as a basis <3

local function GetOrCreateBorder(castbar)
	if castbar.mMT_ImportantCastBorder then return castbar.mMT_ImportantCastBorder end

	local border = CreateFrame("Frame", nil, castbar, "BackdropTemplate")
	border:SetFrameLevel(castbar:GetFrameLevel() + 5)
	border:Hide()

	castbar.mMT_ImportantCastBorder = border
	return border
end

local function GetOrCreateIcon(castbar)
	if castbar.mMT_ImportantCastIcon then return castbar.mMT_ImportantCastIcon end

	local iconHolder = CreateFrame("Frame", nil, castbar)
	iconHolder:SetFrameLevel(castbar:GetFrameLevel() + 6)
	iconHolder:Hide()

	local icon = iconHolder:CreateTexture(nil, "OVERLAY")
	icon:SetAllPoints()
	iconHolder.texture = icon

	castbar.mMT_ImportantCastIcon = iconHolder
	return iconHolder
end

local function ApplyIconStyle(iconHolder)
	local pointMap = {
		TOP = { point = "BOTTOM", relativePoint = "TOP" },
		BOTTOM = { point = "TOP", relativePoint = "BOTTOM" },
		LEFT = { point = "RIGHT", relativePoint = "LEFT" },
		RIGHT = { point = "LEFT", relativePoint = "RIGHT" },
		CENTER = { point = "CENTER", relativePoint = "CENTER" },
		TOPLEFT = { point = "BOTTOMRIGHT", relativePoint = "TOPLEFT" },
		TOPRIGHT = { point = "BOTTOMLEFT", relativePoint = "TOPRIGHT" },
		BOTTOMLEFT = { point = "TOPRIGHT", relativePoint = "BOTTOMLEFT" },
		BOTTOMRIGHT = { point = "TOPLEFT", relativePoint = "BOTTOMRIGHT" },
	}
	local anchorData = pointMap[module.anchor] or pointMap.TOP

	iconHolder:ClearAllPoints()
	iconHolder:SetSize(module.iconSize, module.iconSize)
	iconHolder:SetPoint(anchorData.point, iconHolder:GetParent(), anchorData.relativePoint, module.posX, module.posY)
	iconHolder.texture:SetTexture(module.icon, "CLAMP", "CLAMP", "TRILINEAR")
end

local function ApplyBorderStyle(border, castbar)
	local thickness = module.thickness

	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", castbar, -thickness, thickness)
	border:SetPoint("BOTTOMRIGHT", castbar, thickness, -thickness)

	backdropInfo.edgeSize = thickness
	border:SetBackdrop(backdropInfo)

	local color = module.borderColor
	border:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
end

local function ShowImportantCast(castbar)
	local border = GetOrCreateBorder(castbar)
	ApplyBorderStyle(border, castbar)
	border:Show()

	if module.showIcon then
		local icon = GetOrCreateIcon(castbar)
		ApplyIconStyle(icon)
		icon:Show()
	end
end

local function HideImportantCast(castbar)
	local border = castbar.mMT_ImportantCastBorder
	if border and border:IsShown() then border:Hide() end

	local icon = castbar.mMT_ImportantCastIcon
	if icon and icon:IsShown() then icon:Hide() end
end

local function GetCastbarNameplate(castbar)
	return castbar and castbar.__owner
end

local function GetOrCreateHealthOverlay(nameplate)
	local healthBar = nameplate and nameplate.Health
	if not healthBar then return nil end

	if healthBar.mMT_ImportantCastOverlay then return healthBar.mMT_ImportantCastOverlay end

	local overlay = healthBar:CreateTexture(nil, "OVERLAY", nil, 7)
	local fillTexture = healthBar:GetStatusBarTexture()

	overlay:SetTexture(EDGE_FILE)
	overlay:SetBlendMode("BLEND")
	overlay:SetPoint("TOPLEFT", fillTexture, "TOPLEFT")
	overlay:SetPoint("BOTTOMLEFT", fillTexture, "BOTTOMLEFT")
	overlay:SetPoint("TOPRIGHT", fillTexture, "TOPRIGHT")
	overlay:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMRIGHT")
	overlay:SetAlpha(0)

	healthBar.mMT_ImportantCastOverlay = overlay
	return overlay
end

local function ApplyOverlayState(nameplate, isImportant)
	local healthBar = nameplate and nameplate.Health
	local unit = nameplate and nameplate.unit
	local overlay = GetOrCreateHealthOverlay(nameplate)
	if not (healthBar and unit and overlay) then return end

	local trackedUnit = healthBar.mMT_ImportantCastUnit
	if trackedUnit and trackedUnit ~= unit and module.trackedUnits then module.trackedUnits[trackedUnit] = nil end

	module.trackedUnits = module.trackedUnits or {}
	module.trackedUnits[unit] = nameplate
	healthBar.mMT_ImportantCastUnit = unit

	overlay:SetVertexColor(module.healthColor.r, module.healthColor.g, module.healthColor.b)

	if module.demo then
		overlay:SetAlpha(1)
	elseif E:IsSecretValue(isImportant) then
		overlay:SetAlphaFromBoolean(isImportant, 1, 0)
	elseif isImportant then
		overlay:SetAlpha(1)
	end
end

local function ResetImportantCastOverlay(nameplate)
	local healthBar = nameplate and nameplate.Health
	if not healthBar then return end

	if healthBar.mMT_ImportantCastUnit and module.trackedUnits then module.trackedUnits[healthBar.mMT_ImportantCastUnit] = nil end

	healthBar.mMT_ImportantCastUnit = nil

	local overlay = healthBar.mMT_ImportantCastOverlay
	if overlay then overlay:SetAlpha(0) end
end

local function CheckImportant(castbar)
	if not (module.db and module.db.enable) then
		HideImportantCast(castbar)
		return false, false
	end

	local spellID = castbar.spellID
	if not spellID then
		HideImportantCast(castbar)
		return false, false
	end

	local isImportant = IsSpellImportant(spellID)
	local isSecret = E:IsSecretValue(isImportant)

	if module.demo then
		local border = GetOrCreateBorder(castbar)
		ApplyBorderStyle(border, castbar)
		border:Show()
		border:SetAlpha(1)

		if module.showIcon then
			local icon = GetOrCreateIcon(castbar)
			ApplyIconStyle(icon)
			icon:Show()
			icon.texture:SetAlpha(1)
		end

		return true, false
	end

	if isSecret then
		local border = GetOrCreateBorder(castbar)
		ApplyBorderStyle(border, castbar)
		border:Show()
		border:SetAlphaFromBoolean(isImportant, 1, 0)

		if module.showIcon then
			local icon = GetOrCreateIcon(castbar)
			ApplyIconStyle(icon)
			icon:Show()
			icon.texture:SetAlphaFromBoolean(isImportant, 1, 0)
		end
	elseif isImportant then
		ShowImportantCast(castbar)
	else
		HideImportantCast(castbar)
	end

	return isImportant, isSecret
end

local function CheckImportantNameplate(castbar)
	local isImportant, isSecret = CheckImportant(castbar)
	if not isSecret and not isImportant then return end

	local nameplate = GetCastbarNameplate(castbar)
	if nameplate then ApplyOverlayState(nameplate, isImportant) end
end

function module:RefreshTrackedPlates()
	if not module.trackedUnits then return end

	for unit, nameplate in pairs(module.trackedUnits) do
		if nameplate and nameplate.unit == unit and nameplate.Health then
			ApplyOverlayState(nameplate, true)
		else
			module.trackedUnits[unit] = nil
		end
	end
end

function module:Initialize(demo)
	if not E.db.mMediaTag.important_casts.enable then return end
	if not IsSpellImportant then return end

	module.db = E.db.mMediaTag.important_casts

	if not module.isEnabled then
		hooksecurefunc(NP, "Castbar_PostCastStart", function(castbar)
			if not castbar then return end

			if module.overrideHealthBarColor then
				CheckImportantNameplate(castbar)
			else
				CheckImportant(castbar)
			end
		end)

		hooksecurefunc(NP, "Castbar_PostCastStop", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(NP, "Castbar_PostCastFail", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(NP, "Castbar_PostCastInterrupted", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(UF, "PostCastStart", function(castbar)
			if not castbar then return end
			CheckImportant(castbar)
		end)

		hooksecurefunc(UF, "PostCastStop", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(UF, "PostCastFail", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(UF, "PostCastInterrupted", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		if module.db.overrideHealthBarColor then
			module:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
			module:SetScript("OnEvent", function(_, event, unit)
				if event ~= "NAME_PLATE_UNIT_REMOVED" or not unit then return end

				local nameplate = module.trackedUnits and module.trackedUnits[unit]
				if nameplate then ResetImportantCastOverlay(nameplate) end
			end)
		end
		module.isEnabled = true
	end

	module.borderColor = module.db.classColor and MEDIA.myclass or MEDIA.color.important_casts.border
	module.healthColor = MEDIA.color.important_casts.health
	module.overrideHealthBarColor = module.db.overrideHealthBarColor
	module.thickness = module.db.thickness or 2
	module.showIcon = module.db.showIcon
	module.iconSize = module.db.iconSize or 16
	module.icon = MEDIA.icons.important_casts[module.db.icon]
	module.anchor = module.db.anchor or "TOP"
	module.posX = module.db.posX or 0
	module.posY = module.db.posY or 0
	module.demo = demo

	if module.db.overrideHealthBarColor then module:RefreshTrackedPlates() end
end
