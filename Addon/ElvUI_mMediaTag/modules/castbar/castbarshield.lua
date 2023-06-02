local E = unpack(ElvUI)

function mMT:CastbarShield(castbar)
	if castbar.notInterruptible then
		local sizeX = 32
		local sizeY = 32

		if E.db.mMT.castbarshield.auto then
			sizeX = castbar:GetHeight() - 2
			sizeY = sizeX
		else
			sizeX = E.db.mMT.castbarshield.sizeX
			sizeY = E.db.mMT.castbarshield.sizeY
		end

		if not castbar.mCastbarShield then
			castbar.mCastbarShield = castbar:CreateTexture("CastbarShield", "OVERLAY")
			castbar.mCastbarShield:SetWidth(sizeX)
			castbar.mCastbarShield:SetHeight(sizeY)
			castbar.mCastbarShield:SetPoint(
				E.db.mMT.castbarshield.anchor,
				E.db.mMT.castbarshield.posX,
				E.db.mMT.castbarshield.posY
			)
		else
			castbar.mCastbarShield:ClearAllPoints()
			castbar.mCastbarShield:SetWidth(sizeX)
			castbar.mCastbarShield:SetHeight(sizeY)
			castbar.mCastbarShield:SetPoint(
				E.db.mMT.castbarshield.anchor,
				E.db.mMT.castbarshield.posX,
				E.db.mMT.castbarshield.posY
			)
		end

		castbar.mCastbarShield:SetTexture(mMT.Media.Castbar[E.db.mMT.castbarshield.icon])

		if E.db.mMT.castbarshield.custom then
			local color = E.db.mMT.castbarshield.color
			castbar.mCastbarShield:SetVertexColor(color.r, color.g, color.b, color.a)
		else
			castbar.mCastbarShield:SetVertexColor(1, 1, 1, 1)
		end

		castbar.mCastbarShield:Show()
	elseif castbar.mCastbarShield then
		castbar.mCastbarShield:Hide()
	end
end
