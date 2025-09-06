local E = unpack(ElvUI)

function mMT:mNamePlateBorderColor()
	if E.db.mMT.nameplate.bordercolor.glow and E.db["nameplates"]["colors"]["glowColor"] then
		E.db["nameplates"]["colors"]["glowColor"]["b"] = mMT.ClassColor.b
		E.db["nameplates"]["colors"]["glowColor"]["r"] = mMT.ClassColor.r
		E.db["nameplates"]["colors"]["glowColor"]["g"] = mMT.ClassColor.g
	end
end
