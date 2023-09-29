local E = unpack(ElvUI)

local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")

local _G = _G
local hooksecurefunc = _G.hooksecurefunc

function CustomBackdrop(frame, texture)
	if frame.backdropTex then
		frame.backdropTex:SetTexture(LSM:Fetch("statusbar", texture))
		frame.backdropTex:ClearAllPoints()
		frame.backdropTex:SetAllPoints()
	end
end

function CustomHealthBackdrop(frame)
	CustomBackdrop(frame, E.db.mMT.custombackgrounds.health.texture)
end

function CustomPowerBackdrop(frame)
	CustomBackdrop(frame, E.db.mMT.custombackgrounds.power.texture)
end

function CustomCastbarBackdrop(frame)
	CustomBackdrop(frame, E.db.mMT.custombackgrounds.castbar.texture)
end

function mMT:CustomBackdrop()
	if E.db.mMT.custombackgrounds.health.enable then
		hooksecurefunc(UF, "PostUpdateHealthColor", CustomHealthBackdrop)
	end

	if E.db.mMT.custombackgrounds.power.enable then
		hooksecurefunc(UF, "PostUpdatePowerColor", CustomPowerBackdrop)
	end

	if E.db.mMT.custombackgrounds.castbar.enable then
		hooksecurefunc(UF, "PostCastStart", CustomCastbarBackdrop)
	end
end
