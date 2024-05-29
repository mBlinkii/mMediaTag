local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")

local module = mMT.Modules.CustomBGTextures
if not module then
	return
end

local _G = _G
local hooksecurefunc = _G.hooksecurefunc

local function CustomBackdrop(frame, texture)
	if frame.backdropTex then
		frame.backdropTex:SetTexture(LSM:Fetch("statusbar", texture))
		frame.backdropTex:ClearAllPoints()
		frame.backdropTex:SetAllPoints()
	end
end

local function CustomHealthBackdrop(frame)
	CustomBackdrop(frame, E.db.mMT.custombackgrounds.health.texture)
end

local function CustomPowerBackdrop(frame)
	CustomBackdrop(frame, E.db.mMT.custombackgrounds.power.texture)
end

local function CustomCastbarBackdrop(frame)
	CustomBackdrop(frame, E.db.mMT.custombackgrounds.castbar.texture)
end

function module:Initialize()
	if E.db.mMT.custombackgrounds.health.enable and not module.health then
		hooksecurefunc(UF, "PostUpdateHealthColor", CustomHealthBackdrop)
		module.health = true
	end

	if E.db.mMT.custombackgrounds.power.enable and not module.power then
		hooksecurefunc(UF, "PostUpdatePowerColor", CustomPowerBackdrop)
		module.power = true
	end

	if E.db.mMT.custombackgrounds.castbar.enable and not module.castbar then
		hooksecurefunc(UF, "PostCastStart", CustomCastbarBackdrop)
		module.castbar = true
	end

	module.needReloadUI = true
	module.loaded = true
end
