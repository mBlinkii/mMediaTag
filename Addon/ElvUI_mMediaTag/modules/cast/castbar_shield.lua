local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("CastbarShield", { "AceEvent-3.0" })

local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local IsSpellInRange = C_Spell and C_Spell.IsSpellInRange or IsSpellInRange
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")


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

local function AddShieldIcon(castbar)
    if not castbar or castbar.unit == "vehicle" or castbar.unit == "player" then return end

    if E.db.mMT.castbarshield.enable then
        mMT:CastbarShield(castbar)
    else
        if castbar.mCastbarShield then
            castbar.mCastbarShield:Hide()
        end
    end
end

local function Update(castbar)
	if not castbar or castbar.unit == "vehicle" or castbar.unit == "player" then return end

	InterruptChecker(castbar)

	if not castbar._interruptOnCD_OnUpdateHooked then
		castbar:HookScript("OnUpdate", Castbar_OnUpdate)
		castbar._interruptOnCD_OnUpdateHooked = true
	end
end

function module:Initialize()
	if E.db.mMT.castbar_shield.enable then
		if not module.isEnabled then

			hooksecurefunc(NP, "Castbar_PostCastStart", Update)
			hooksecurefunc(UF, "PostCastStart", Update)

			module.isEnabled = true
		end

		module.color = MEDIA.color.castbar_shield
		module.texture = E.db.mMT.castbar_shield.texture

		module.loaded = true
	end
end
