local E = unpack(ElvUI)
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

function mMT:SetCastbarColor(castbar, colorA, colorB)
	if colorA and colorB then
		castbar:GetStatusBarTexture():SetGradient(
			"HORIZONTAL",
			{ r = colorA.r, g = colorA.g, b = colorA.b, a = 1 },
			{ r = colorB.r, g = colorB.g, b = colorB.b, a = 1 }
		)
	else
		castbar:SetStatusBarColor(colorA.r, colorA.g, colorA.b)
	end
end
local function NPLoader(castbar)
	if castbar.unit == "vehicle" or castbar.unit == "player" then
		return
	end

	if E.db.mMT.importantspells.enable and E.db.mMT.importantspells.np then
		mMT:ImportantSpells(castbar, true)
	end

	if E.db.mMT.interruptoncd.enable then
		mMT:InterruptChecker(castbar)
	end

	if E.db.mMT.castbarshield.enable and E.db.mMT.castbarshield.np then
		mMT:CastbarShield(castbar)
	end
end
local function UFLoader(castbar)
	if castbar.unit == "vehicle" or castbar.unit == "player" then
		return
	end

	if E.db.mMT.importantspells.enable and E.db.mMT.importantspells.uf then
		mMT:ImportantSpells(castbar)
	end

	if E.db.mMT.interruptoncd.enable then
		mMT:InterruptChecker(castbar)
	end

	if E.db.mMT.castbarshield.enable and E.db.mMT.castbarshield.uf then
		mMT:CastbarShield(castbar)
	end
end

function mMT:CastbarModuleLoader()
	hooksecurefunc(NP, "Castbar_CheckInterrupt", NPLoader)
	hooksecurefunc(UF, "PostCastStart", UFLoader)
end
