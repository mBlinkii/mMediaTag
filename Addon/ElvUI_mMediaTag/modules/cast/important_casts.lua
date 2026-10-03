local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ImportantCasts", { "AceEvent-3.0" })

-- Cache WoW Globals
local pairs, next = pairs, next
local CreateFrame = CreateFrame
local UnitIsDead = UnitIsDead
local UnitCanAttack = UnitCanAttack
local max = math.max
local hooksecurefunc = hooksecurefunc
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

local function ApplyIconStyle(iconHolder)
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
	-- a preceding secret cast may have left the alpha at 0
	border:SetAlpha(1)
	border:Show()

	if module.showIcon then
		local icon = GetOrCreateIcon(castbar)
		ApplyIconStyle(icon)
		icon.texture:SetAlpha(1)
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

-- nameplates with a colored health bar, checked for death on UNIT_HEALTH
local coloredPlates = {}
local MAX_SECRET_OVERLAYS = 20

-- index 1 is the plain overlay, every secret cast gets its own one, a secret result can not be merged with earlier ones and must not turn them off
local function GetOrCreateHealthOverlay(healthBar, index)
	local overlays = healthBar.mMT_ImportantCastOverlays
	if not overlays then
		overlays = {}
		healthBar.mMT_ImportantCastOverlays = overlays
	end

	local overlay = overlays[index]
	if overlay then return overlay end

	overlay = healthBar:CreateTexture(nil, "OVERLAY", nil, 7)
	overlay:SetTexture(EDGE_FILE)
	overlay:SetBlendMode("BLEND")
	overlay:SetAllPoints(healthBar:GetStatusBarTexture())
	overlay:SetAlpha(0)

	overlays[index] = overlay
	return overlay
end

-- stays until the unit dies or the plate gets a new unit
local function ApplyOverlayState(nameplate, isImportant)
	local healthBar = nameplate and nameplate.Health
	if not healthBar then return end

	local overlay
	if module.demo or E:NotSecretValue(isImportant) then
		if not (module.demo or isImportant) then return end
		overlay = GetOrCreateHealthOverlay(healthBar, 1)
		overlay:SetAlpha(1)
	else
		local used = (healthBar.mMT_ImportantCastSecretUsed or 0) + 1
		if used > MAX_SECRET_OVERLAYS then return end
		healthBar.mMT_ImportantCastSecretUsed = used

		overlay = GetOrCreateHealthOverlay(healthBar, used + 1)
		overlay:SetAlphaFromBoolean(isImportant, 1, 0)
	end

	overlay:SetVertexColor(module.healthColor.r, module.healthColor.g, module.healthColor.b)
	coloredPlates[nameplate] = true
end

local function ResetImportantCastOverlay(nameplate)
	if not nameplate then return end
	coloredPlates[nameplate] = nil

	local healthBar = nameplate.Health
	local overlays = healthBar and healthBar.mMT_ImportantCastOverlays
	if not overlays then return end

	for _, overlay in pairs(overlays) do
		overlay:SetAlpha(0)
	end
	healthBar.mMT_ImportantCastSecretUsed = 0
end

local function OnUnitHealth(_, unit)
	if not next(coloredPlates) then return end

	for nameplate in pairs(coloredPlates) do
		if nameplate.__unit == unit and UnitIsDead(unit) then ResetImportantCastOverlay(nameplate) end
	end
end

local function ResetAllImportantCastOverlays()
	if not NP.Plates then return end

	for nameplate in pairs(NP.Plates) do
		ResetImportantCastOverlay(nameplate)
	end
end

local function CheckImportant(castbar)
	if not (module.db and module.db.enable) then
		HideImportantCast(castbar)
		return false, false
	end

	-- the spell id is secret on restricted units, IsSpellImportant accepts it as is
	local spellID = castbar.spellID
	if E:NotSecretValue(spellID) and not spellID then
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
	local nameplate = GetCastbarNameplate(castbar)

	local isImportant, isSecret = CheckImportant(castbar)
	if not isSecret and not isImportant then return end

	if nameplate then ApplyOverlayState(nameplate, isImportant) end
end

-- frame levels are relative, raising the plate moves health, castbar and the rest above every other plate without a strata change
local RAISE_LEVELS = 100

local function RaisePlate(nameplate)
	if nameplate.mMT_CastRaised then return end
	nameplate.mMT_CastRaised = true
	nameplate:SetFrameLevel(nameplate:GetFrameLevel() + RAISE_LEVELS)
end

local function LowerPlate(nameplate)
	if not (nameplate and nameplate.mMT_CastRaised) then return end
	nameplate.mMT_CastRaised = nil
	nameplate:SetFrameLevel(max(nameplate:GetFrameLevel() - RAISE_LEVELS, 0))
end

-- casting itself is never secret, so every enemy plate with a cast comes forward, the important ones are marked as before
local function RaiseCastingPlate(castbar)
	local owner = castbar.__owner
	if not (module.raiseCasting and owner and owner.isNameplate) or owner == NP.PlayerFrame or owner == NP.TestFrame then return end

	local unit = owner.unit
	if unit and UnitCanAttack("player", unit) then RaisePlate(owner) end
end

local function OnCastEnd(castbar)
	if not castbar then return end
	HideImportantCast(castbar)
	LowerPlate(castbar.__owner)
end

-- ElvUI snapshots the castbar callbacks at frame construction and oUF only calls element:PostCastX(), so hooking the NP/UF tables does nothing - hook the instances.
local CASTBAR_HOOKS = {
	PostCastStart = function(castbar)
		if not castbar then return end

		RaiseCastingPlate(castbar)

		local owner = castbar.__owner
		if module.overrideHealthBarColor and owner and owner.isNameplate then
			CheckImportantNameplate(castbar)
		else
			CheckImportant(castbar)
		end
	end,
	PostCastStop = OnCastEnd,
	PostCastFail = OnCastEnd,
	PostCastInterrupted = OnCastEnd,
}

local function HookCastbarInstance(castbar)
	if not castbar or castbar.mMT_ImportantCastsHooked then return end

	for method, handler in pairs(CASTBAR_HOOKS) do
		if castbar[method] then hooksecurefunc(castbar, method, handler) end
	end

	-- a recycled plate hides its castbar without a stop callback
	castbar:HookScript("OnHide", function(self)
		LowerPlate(self.__owner)
	end)

	castbar.mMT_ImportantCastsHooked = true
end

function module:Initialize(demo)
	-- refresh the db reference first, the hooks keep running after a profile switch that disables the module
	module.db = E.db.mMediaTag.important_casts
	if not module.db.enable then return end
	if not IsSpellImportant then return end

	if not module.isEnabled then
		if E.private.nameplates.enable then
			hooksecurefunc(NP, "UpdatePlate", function(_, nameplate)
				LowerPlate(nameplate)
				if module.overrideHealthBarColor then ResetImportantCastOverlay(nameplate) end
			end)

			-- StylePlate/Configure_Castbar also catch frames created or enabled later.
			hooksecurefunc(NP, "StylePlate", function(_, nameplate)
				if nameplate then HookCastbarInstance(nameplate.Castbar) end
			end)

			if NP.Plates then
				for nameplate in pairs(NP.Plates) do
					HookCastbarInstance(nameplate.Castbar)
				end
			end
		end

		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			if frame then HookCastbarInstance(frame.Castbar) end
		end)

		mMT:ForEachUFFrame(function(frame)
			HookCastbarInstance(frame.Castbar)
		end)

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
	module.raiseCasting = module.db.raiseCasting

	if not module.raiseCasting and NP.Plates then
		for nameplate in pairs(NP.Plates) do
			LowerPlate(nameplate)
		end
	end

	ResetAllImportantCastOverlays()
	if module.overrideHealthBarColor then
		module:RegisterEvent("UNIT_HEALTH", OnUnitHealth)
	else
		module:UnregisterEvent("UNIT_HEALTH")
	end
end
