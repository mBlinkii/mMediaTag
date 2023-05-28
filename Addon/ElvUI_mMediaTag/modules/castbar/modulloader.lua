local E, L = unpack(ElvUI)
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
local function Loader(castbar)
	if castbar.unit == "vehicle" or castbar.unit == "player" then
		return
	end

	if E.db.mMT.interruptoncd.enable then
		mMT:InterruptChecker(castbar)
	end

	if E.db.mMT.importantspells.interrupt.enable or E.db.mMT.importantspells.stun.enable then
	end
end

function mMT:CastbarModuleLoader()
	hooksecurefunc(NP, "Castbar_CheckInterrupt", Loader)
	hooksecurefunc(UF, "PostCastStart", Loader)
end
