local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")

local module = mMT.Modules.CustomBGTextures
if not module then
	return
end

local _G = _G
local hooksecurefunc = _G.hooksecurefunc

local function CustomBackdrop(bar, texture)
	if bar and bar.backdropTex and not bar.isTransparent then
		bar.backdropTex:SetTexture(LSM:Fetch("statusbar", texture))
		bar.backdropTex:ClearAllPoints()
		bar.backdropTex:SetAllPoints()
	end
end

local function CustomHealthBackdrop(_, frame)
	CustomBackdrop(frame and frame.Health, E.db.mMT.custombackgrounds.health.texture)
end

local function CustomPowerBackdrop(_, frame)
	CustomBackdrop(frame and frame.Power, E.db.mMT.custombackgrounds.power.texture)
end

local function CustomCastbarBackdrop(_, frame)
	CustomBackdrop(frame and frame.Castbar, E.db.mMT.custombackgrounds.castbar.texture)
end

local function CustomAltPowerBackdrop(_, frame)
	CustomBackdrop(frame and frame.AlternativePower, E.db.mMT.custombackgrounds.altpower.texture)
end

function module:Initialize()
	if E.db.mMT.custombackgrounds.health.enable and not module.health then
		hooksecurefunc(UF, "Configure_HealthBar", CustomHealthBackdrop)
		module.health = true
	end

	if E.db.mMT.custombackgrounds.power.enable and not module.power then
		hooksecurefunc(UF, "Configure_Power", CustomPowerBackdrop)
		module.power = true
	end

	if E.db.mMT.custombackgrounds.castbar.enable and not module.castbar then
		hooksecurefunc(UF, "Configure_Castbar", CustomCastbarBackdrop)
		module.castbar = true
	end

	if E.db.mMT.custombackgrounds.altpower.enable and not module.altpower then
		hooksecurefunc(UF, "Configure_AltPowerBar", CustomAltPowerBackdrop)
		module.altpower = true
	end

	module.needReloadUI = true
	module.loaded = true
end
