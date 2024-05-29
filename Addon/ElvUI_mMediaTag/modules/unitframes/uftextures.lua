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

local function CustomHealthTexture(_, frame)
	db = E.db.mMT.customtextures
	local texture = LSM:Fetch("statusbar", db.health.texture)

	if frame and frame.Health then
		frame.Health:SetStatusBarTexture(texture)
		if not E.db.mMT.custombackgrounds.health.enable and frame.Health.backdropTex then
			SetBGTexture(frame.Health.backdropTex, texture)
		end
	end
end

local function CustomPowerTexture(_, frame)
	db = E.db.mMT.customtextures
	local texture = LSM:Fetch("statusbar", db.power.texture)

	if frame and frame.Power then
		frame.Power:SetStatusBarTexture(texture)
		if not E.db.mMT.custombackgrounds.power.enable and frame.Power.backdropTex then
			SetBGTexture(frame.Power.backdropTex, texture)
		end
	end
end

local function CustomCastbarTexture(_, frame)
	db = E.db.mMT.customtextures
	local texture = LSM:Fetch("statusbar", db.castbar.texture)

	if frame and frame.Castbar then
		frame.Castbar:SetStatusBarTexture(texture)
		if not E.db.mMT.custombackgrounds.castbar.enable and frame.Castbar.backdropTex then
			SetBGTexture(frame.Castbar.backdropTex, texture)
		end
	end
end

local function CustomAltPowerTexture(_, frame)
	db = E.db.mMT.customtextures
	local texture = LSM:Fetch("statusbar", db.altpower.texture)

	if frame and frame.AlternativePower then
		frame.AlternativePower:SetStatusBarTexture(texture)
		if not E.db.mMT.custombackgrounds.altpower.enable and frame.AlternativePower.backdropTex then
			SetBGTexture(frame.AlternativePower.backdropTex, texture)
		end
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
