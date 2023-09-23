local E = unpack(ElvUI)

local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")
local _G = _G
local hooksecurefunc = _G.hooksecurefunc

function CustomHealthBackdrop(frame)
	if frame.backdropTex then
		frame.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db.mMT.custombackgrounds.health.texture))
		frame.backdropTex:ClearAllPoints()
		frame.backdropTex:SetAllPoints()
	end
end

function CustomPowerBackdrop(frame)
	if frame.backdropTex then
		frame.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db.mMT.custombackgrounds.power.texture))
		frame.backdropTex:ClearAllPoints()
		frame.backdropTex:SetAllPoints()
	end
end

function CustomCastbarBackdrop(frame)
	if frame.backdropTex then
		frame.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db.mMT.custombackgrounds.castbar.texture))
		frame.backdropTex:ClearAllPoints()
		frame.backdropTex:SetAllPoints()
	end
end

function mMT:CustomBackdrop()
	mMT:Print(E.db.mMT.custombackgrounds.health.enable, E.db.mMT.custombackgrounds.power.enable, E.db.mMT.custombackgrounds.castbar.enable)
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
