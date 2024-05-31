local E = unpack(ElvUI)

local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")

local module = mMT.Modules.CustomUFTextures
if not module then
	return
end

local _G = _G
local hooksecurefunc = _G.hooksecurefunc
local db = nil

local function SetBGTexture(bg, texture)
	bg:SetTexture(texture)
	bg:ClearAllPoints()
	bg:SetAllPoints()
end

local function SetCustomTexture(bar, texture, bg)
	bar:SetStatusBarTexture(texture)
	if bg and bar.backdropTex then
		SetBGTexture(bar.backdropTex, texture)
	end
end

local function CustomHealthTexture(_, frame)
	if frame and frame.Health and not frame.Health.isTransparent then
		SetCustomTexture(frame.Health, LSM:Fetch("statusbar", E.db.mMT.customtextures.health.texture), not E.db.mMT.custombackgrounds.health.enable)
	end
end

local function CustomPowerTexture(_, frame)
	if frame and frame.Power and not frame.Power.isTransparent then
		SetCustomTexture(frame.Power, LSM:Fetch("statusbar", E.db.mMT.customtextures.power.texture), not E.db.mMT.custombackgrounds.power.enable)
	end
end

local function CustomCastbarTexture(_, frame)
	if frame and frame.Castbar and not frame.Castbar.isTransparent then
		SetCustomTexture(frame.Castbar, LSM:Fetch("statusbar", E.db.mMT.customtextures.castbar.texture), not E.db.mMT.custombackgrounds.castbar.enable)
	end
end

local function CustomAltPowerTexture(_, frame)
	if frame and frame.AlternativePower and not frame.AlternativePower.isTransparent then
		SetCustomTexture(frame.AlternativePower, LSM:Fetch("statusbar", E.db.mMT.customtextures.altpower.texture), not E.db.mMT.custombackgrounds.altpower.enable)
	end
end

function module:Initialize()
	db = E.db.mMT.customtextures
	if db.health.enable and not module.health then
		hooksecurefunc(UF, "Configure_HealthBar", CustomHealthTexture)
		module.health = true
	end

	if db.power.enable and not module.power then
		hooksecurefunc(UF, "Configure_Power", CustomPowerTexture)
		module.power = true
	end

	if db.castbar.enable and not module.castbar then
		hooksecurefunc(UF, "Configure_Castbar", CustomCastbarTexture)
		module.castbar = true
	end

	if db.altpower.enable and not module.altpower then
		hooksecurefunc(UF, "Configure_AltPowerBar", CustomAltPowerTexture)
		module.altpower = true
	end

	module.needReloadUI = true
	module.loaded = true
end
