local mMT, E, L, V, P, G = unpack((select(2, ...)))

function mMT:mNamePlateBorderColor()
	local classColor = ElvUF.colors.class[E.myclass]

	if E.db.mMT.nameplate.bordercolor.border and E.global["nameplates"]["filters"]["ElvUI_Target"] then
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["b"] = classColor.b
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["g"] = classColor.g
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["r"] = classColor.r
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["border"] = true
	end

	if E.db.mMT.nameplate.bordercolor.glow then
		E.db["nameplates"]["colors"]["glowColor"]["b"] = classColor.b
		E.db["nameplates"]["colors"]["glowColor"]["r"] = classColor.r
		E.db["nameplates"]["colors"]["glowColor"]["g"] = classColor.g
	end
end