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

local function SetCustomTexture(bar, texture)
	bar:SetStatusBarTexture(texture)
end

local function SetBGTexture(bg, texture)
	bg:SetTexture(texture)
	bg:ClearAllPoints()
	bg:SetAllPoints()
end

local function UpdateTextures(typ, frame)
	--mMT:Print(frame.Power.backdropTex, frame.Power.bg)
	db = E.db.mMT.customtextures
	local dbBG = E.db.mMT.custombackgrounds
	local texture = nil
	if frame then
		if db.health.enable and frame.Health then
			texture = LSM:Fetch("statusbar", db.health.texture)
			SetCustomTexture(frame.Health, texture)
			if not dbBG.health.enable and frame.Health.backdropTex then
				SetBGTexture(frame.Health.backdropTex, texture)
			end
		end

		if db.power.enable and frame.Power then
			texture = LSM:Fetch("statusbar", db.power.texture)
			SetCustomTexture(frame.Power, texture)
			if not dbBG.power.enable and frame.Power.backdropTex then
				SetBGTexture(frame.Power.backdropTex, texture)
			end
		end

		if db.castbar.enable and frame.Castbar then
			texture = LSM:Fetch("statusbar", db.castbar.texture)
			SetCustomTexture(frame.Castbar, texture)
			if not dbBG.castbar.enable and frame.Castbar.backdropTex then
				SetBGTexture(frame.Castbar.backdropTex, texture)
			end
		end

		if db.altpower.enable and frame.AlternativePower then
			texture = LSM:Fetch("statusbar", db.altpower.texture)
			SetCustomTexture(frame.AlternativePower, texture)
			if not dbBG.altpower.enable and frame.AlternativePower.backdropTex then
				SetBGTexture(frame.AlternativePower.backdropTex, texture)
			end
		end
	end
end

function module:Initialize()
	db = E.db.mMT.customtextures
	if db.health.enable and not module.health then
		hooksecurefunc(UF, "Configure_HealthBar", UpdateTextures)
		module.health = true
	end

	if db.power.enable and not module.power then
		hooksecurefunc(UF, "Configure_Power", UpdateTextures)
		module.power = true
	end

	if db.castbar.enable and not module.castbar then
		hooksecurefunc(UF, "Configure_Castbar", UpdateTextures)
		module.castbar = true
	end

	if db.altpower.enable and not module.altpower then
		hooksecurefunc(UF, "Configure_AltPowerBar", UpdateTextures)
		module.altpower = true
	end

	module.needReloadUI = true
	module.loaded = true
end
