local mMT, E, L, V, P, G = unpack((select(2, ...)))

function mMT:mNamePlateBorderColor()
	if E.db.mMT.nameplate.bordercolor.border and E.global["nameplates"]["filters"]["ElvUI_Target"] then
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["b"] = mMT.ClassColor.b
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["g"] = mMT.ClassColor.g
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["r"] = mMT.ClassColor.r
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["border"] = true
	end

	if E.db.mMT.nameplate.bordercolor.glow then
		E.db["nameplates"]["colors"]["glowColor"]["b"] = mMT.ClassColor.b
		E.db["nameplates"]["colors"]["glowColor"]["r"] = mMT.ClassColor.r
		E.db["nameplates"]["colors"]["glowColor"]["g"] = mMT.ClassColor.g
	end
end
