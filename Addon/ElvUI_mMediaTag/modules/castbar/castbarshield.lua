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

		if not castbar.CastbarShield then
			castbar.CastbarShield = castbar:CreateTexture("CastbarShield", "HIGHLIGHT")
			castbar.CastbarShield:SetWidth(sizeX)
			castbar.CastbarShield:SetHeight(sizeY)
			castbar.CastbarShield:SetPoint(
				E.db.mMT.castbarshield.anchor,
				E.db.mMT.castbarshield.posX,
				E.db.mMT.castbarshield.posY
			)
		else
			castbar.CastbarShield:ClearAllPoints()
			castbar.CastbarShield:SetWidth(sizeX)
			castbar.CastbarShield:SetHeight(sizeY)
			castbar.CastbarShield:SetPoint(
				E.db.mMT.castbarshield.anchor,
				E.db.mMT.castbarshield.posX,
				E.db.mMT.castbarshield.posY
			)
		end

		castbar.CastbarShield:SetTexture(mMT.Media.Castbar[E.db.mMT.castbarshield.icon])

		if E.db.mMT.castbarshield.custom then
			local color = E.db.mMT.castbarshield.color
			castbar.CastbarShield:SetVertexColor(color.r, color.g, color.b, color.a)
		else
			castbar.CastbarShield:SetVertexColor(1, 1, 1, 1)
		end

		castbar.CastbarShield:Show()
	elseif castbar.CastbarShield then
		castbar.CastbarShield:Hide()
	end
end
