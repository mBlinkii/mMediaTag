local E = unpack(ElvUI)

function mMT:CastbarShield(castbar)
	if castbar.notInterruptible then
        if not castbar.CastbarShield then
            local XY = castbar:GetHeight()
                castbar.CastbarShield = castbar:CreateTexture("CastbarShield", "OVERLAY")
                castbar.CastbarShield:SetWidth(XY)
                castbar.CastbarShield:SetHeight(XY)
                castbar.CastbarShield:SetPoint( "LEFT" )
                castbar.CastbarShield:Hide()
        end

	end
end
