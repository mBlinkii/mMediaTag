local E = unpack(ElvUI)

local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")


local function CustomHealthBackdrop(unitframe, framename, r, g, b)
	if unitframe.backdropTex then
		unitframe.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db.mMT.custombackgrounds.health.texture))
		unitframe.backdropTex:ClearAllPoints()
		local statusBarOrientation = unitframe:GetOrientation()
		if statusBarOrientation == 'VERTICAL' then
			unitframe.backdropTex:Point('TOPLEFT')
			unitframe.backdropTex:Point('BOTTOMLEFT')
			unitframe.backdropTex:Point('BOTTOMRIGHT')

		else
			unitframe.backdropTex:Point('TOPLEFT')
			unitframe.backdropTex:Point('BOTTOMLEFT')
			unitframe.backdropTex:Point('BOTTOMRIGHT')
		end
	end
end

local function CustomPowerBackdrop(powerframe)
	if powerframe.backdropTex then
		powerframe.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db.mMT.custombackgrounds.power.texture))
		powerframe.backdropTex:ClearAllPoints()
		local statusBarOrientation = powerframe:GetOrientation()
		if statusBarOrientation == 'VERTICAL' then
			powerframe.backdropTex:Point('TOPLEFT')
			powerframe.backdropTex:Point('BOTTOMLEFT')
			powerframe.backdropTex:Point('BOTTOMRIGHT')

		else
			powerframe.backdropTex:Point('TOPLEFT')
			powerframe.backdropTex:Point('BOTTOMLEFT')
			powerframe.backdropTex:Point('BOTTOMRIGHT')
		end
	end
end

local function CustomCastbarBackdrop(castbarframe, frame, r, g, b)
	if castbarframe.backdropTex then
		castbarframe.backdropTex:SetTexture(LSM:Fetch("statusbar", E.db.mMT.custombackgrounds.castbar.texture))
		castbarframe.backdropTex:ClearAllPoints()
		local statusBarOrientation = castbarframe:GetOrientation()
		if statusBarOrientation == 'VERTICAL' then
			castbarframe.backdropTex:Point('TOPLEFT')
			castbarframe.backdropTex:Point('BOTTOMLEFT')
			castbarframe.backdropTex:Point('BOTTOMRIGHT')

		else
			castbarframe.backdropTex:Point('TOPLEFT')
			castbarframe.backdropTex:Point('BOTTOMLEFT')
			castbarframe.backdropTex:Point('BOTTOMRIGHT')
		end
	end
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
