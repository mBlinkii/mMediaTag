local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ImportantCasts", { "AceEvent-3.0" })

-- Cache WoW Globals
local pairs = pairs
local CreateFrame = CreateFrame
local UnitCanAttack = UnitCanAttack
local UnitIsDead = UnitIsDead
local hooksecurefunc = hooksecurefunc
local issecretvalue = issecretvalue
local IsSpellImportant = C_Spell and C_Spell.IsSpellImportant

local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")
local LCG = LibStub("LibCustomGlow-1.0", true)

local GLOW_KEY = "mMT_ImportantGlow"
local glowColor = { 1, 1, 1, 1 }

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
-- unit token > colored plate, so UNIT_HEALTH finds its plate without a loop
local coloredUnits = {}
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

	-- sublevel 7 stays free for raid marker colors that are set to show above this one
	overlay = healthBar:CreateTexture(nil, "OVERLAY", nil, 6)
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
	local unit = nameplate.__unit
	if unit then
		coloredUnits[unit] = nameplate
		nameplate.mMT_ColoredUnit = unit
	end
end

local function ResetImportantCastOverlay(nameplate)
	if not nameplate then return end
	local unit = nameplate.mMT_ColoredUnit
	if unit and coloredUnits[unit] == nameplate then coloredUnits[unit] = nil end
	nameplate.mMT_ColoredUnit = nil

	local healthBar = nameplate.Health
	local overlays = healthBar and healthBar.mMT_ImportantCastOverlays
	if not overlays then return end

	for _, overlay in pairs(overlays) do
		overlay:SetAlpha(0)
	end
	healthBar.mMT_ImportantCastSecretUsed = 0
end

-- a recycled plate can carry another unit by now, so the token is checked again
local function OnUnitHealth(_, unit)
	local nameplate = coloredUnits[unit]
	if nameplate and nameplate.__unit == unit and UnitIsDead(unit) then ResetImportantCastOverlay(nameplate) end
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
	if not isSecret and not isImportant then return isImportant, isSecret end

	if nameplate then ApplyOverlayState(nameplate, isImportant) end
	return isImportant, isSecret
end

-- secret values can not be compared to nil
local function HasValue(value)
	return issecretvalue(value) or value ~= nil
end

local function GlowTargets(castbar)
	local glow = module.db.glow_castbar and castbar or nil
	local health = module.db.glow_health and castbar.__owner and castbar.__owner.Health or nil
	return glow, health
end

-- nested frames multiply their alpha, which ANDs the secret conditions: important > interruptible > kick ready
local function GetGlowHolder(target)
	local holder = target.mMT_ImportantGlow
	if holder then return holder end

	local important = CreateFrame("Frame", nil, target)
	important:SetAllPoints(target)
	important:SetFrameLevel(target:GetFrameLevel() + 5)

	local interruptible = CreateFrame("Frame", nil, important)
	interruptible:SetAllPoints(target)

	local ready = CreateFrame("Frame", nil, interruptible)
	ready:SetAllPoints(target)

	holder = { important = important, interruptible = interruptible, ready = ready }
	target.mMT_ImportantGlow = holder
	return holder
end

local function StopGlow(target)
	local holder = target and target.mMT_ImportantGlow
	if not (holder and holder.active) then return end

	LCG.PixelGlow_Stop(holder.ready, GLOW_KEY)
	holder.active = false
end

local function StopGlows(castbar)
	if not LCG then return end
	StopGlow(castbar)
	StopGlow(castbar.__owner and castbar.__owner.Health)
end

local function SetInterruptible(holder, castbar)
	local notInterruptible = castbar.notInterruptible
	if module.db.glow_interruptible_only and HasValue(notInterruptible) then
		holder.interruptible:SetAlphaFromBoolean(notInterruptible, 0, 1)
	else
		holder.interruptible:SetAlpha(1)
	end
end

-- without Interrupt On CD or an interrupt there is nothing to wait for
local function SetReady(holder, ready)
	if module.db.glow_ready_only and HasValue(ready) then
		holder.ready:SetAlphaFromBoolean(ready, 1, 0)
	else
		holder.ready:SetAlpha(1)
	end
end

local function StartGlow(target, castbar, isImportant, isSecret)
	if not target then return end
	local holder = GetGlowHolder(target)

	local color = MEDIA.color.important_casts.glow
	glowColor[1], glowColor[2], glowColor[3] = color.r, color.g, color.b
	LCG.PixelGlow_Start(holder.ready, glowColor, 8, 0.25, nil, module.db.glow_thickness, 0, 0, nil, GLOW_KEY)
	holder.active = true

	if isSecret then
		holder.important:SetAlphaFromBoolean(isImportant, 1, 0)
	else
		holder.important:SetAlpha(1)
	end

	SetInterruptible(holder, castbar)
	local interruptOnCD = M.InterruptOnCD
	SetReady(holder, interruptOnCD and interruptOnCD.GetKickReady and interruptOnCD:GetKickReady())
end

-- only enemy casts glow, like the interrupt it is meant for
local function UpdateGlows(castbar, isImportant, isSecret)
	if not LCG then return end
	StopGlows(castbar)

	local glow, health = GlowTargets(castbar)
	if not (glow or health) then return end
	if not (module.demo or isSecret or isImportant) then return end

	local unit = castbar.unit or (castbar.__owner and castbar.__owner.__unit)
	if not (module.demo or (unit and UnitCanAttack("player", unit))) then return end

	StartGlow(glow, castbar, module.demo or isImportant, isSecret)
	StartGlow(health, castbar, module.demo or isImportant, isSecret)
end

-- called by Interrupt On CD on cast start and while the cast runs
function module:UpdateKickReady(castbar, ready)
	if not (LCG and module.db and module.db.enable and module.db.glow_ready_only) then return end

	for _, target in pairs({ GlowTargets(castbar) }) do
		local holder = target.mMT_ImportantGlow
		if holder and holder.active then SetReady(holder, ready) end
	end
end

local function OnInterruptibleChanged(castbar)
	if not (LCG and module.db and module.db.enable) then return end

	for _, target in pairs({ GlowTargets(castbar) }) do
		local holder = target.mMT_ImportantGlow
		if holder and holder.active then SetInterruptible(holder, castbar) end
	end
end

local function OnCastEnd(castbar)
	if not castbar then return end
	HideImportantCast(castbar)
	StopGlows(castbar)
end

-- ElvUI snapshots the castbar callbacks at frame construction and oUF only calls element:PostCastX(), so hooking the NP/UF tables does nothing - hook the instances.
local CASTBAR_HOOKS = {
	PostCastStart = function(castbar)
		if not castbar then return end

		local owner = castbar.__owner
		local isImportant, isSecret
		if module.overrideHealthBarColor and owner and owner.isNameplate then
			isImportant, isSecret = CheckImportantNameplate(castbar)
		else
			isImportant, isSecret = CheckImportant(castbar)
		end

		if module.db and module.db.enable then UpdateGlows(castbar, isImportant, isSecret) end
	end,
	PostCastStop = OnCastEnd,
	PostCastFail = OnCastEnd,
	PostCastInterrupted = OnCastEnd,
	PostCastInterruptible = OnInterruptibleChanged,
}

local function HookCastbarInstance(castbar)
	if not castbar or castbar.mMT_ImportantCastsHooked then return end

	for method, handler in pairs(CASTBAR_HOOKS) do
		if castbar[method] then hooksecurefunc(castbar, method, handler) end
	end
	-- a recycled nameplate hides the castbar without a stop callback, the health bar glow would keep running
	castbar:HookScript("OnHide", StopGlows)

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
				if not module.overrideHealthBarColor then return end
				ResetImportantCastOverlay(nameplate)
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

	ResetAllImportantCastOverlays()
	if module.overrideHealthBarColor then
		module:RegisterEvent("UNIT_HEALTH", OnUnitHealth)
	else
		module:UnregisterEvent("UNIT_HEALTH")
	end
end
