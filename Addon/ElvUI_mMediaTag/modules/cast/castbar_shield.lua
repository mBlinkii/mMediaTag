local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("CastbarShield")
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

local function AddShieldIcon(castbar)
	if not castbar.mMT_ShieldIcon then castbar.mMT_ShieldIcon = castbar:CreateTexture("mMT-ShieldIcon", "OVERLAY") end

	local sizeX, sizeY = module.sizeX, module.sizeY

	if module.auto then
		local size = castbar:GetHeight() - 2
		sizeX = size
		sizeY = size
	end

	castbar.mMT_ShieldIcon:ClearAllPoints()
	castbar.mMT_ShieldIcon:SetWidth(sizeX)
	castbar.mMT_ShieldIcon:SetHeight(sizeY)
	castbar.mMT_ShieldIcon:SetPoint(module.anchor, module.posX, module.posY)

	castbar.mMT_ShieldIcon:SetTexture(MEDIA.icons.castbar[module.texture])

    local color = MEDIA.color.castbar_shield
	castbar.mMT_ShieldIcon:SetVertexColor(color.r, color.g, color.b, color.a)
	castbar.mMT_ShieldIcon:Show()
end

local function Update(castbar)
	if castbar.notInterruptible then
		AddShieldIcon(castbar)
	elseif castbar.mMT_ShieldIcon and castbar.mMT_ShieldIcon:IsShown() then
		castbar.mMT_ShieldIcon:Hide()
	end
end

function module:Initialize()
	if E.db.mMT.castbar_shield.enable then
		if not module.isEnabled then
			if E.db.mMT.castbar_shield.nameplates then hooksecurefunc(NP, "Castbar_PostCastStart", Update) end
			if E.db.mMT.castbar_shield.unitframes then hooksecurefunc(UF, "PostCastStart", Update) end

			module.isEnabled = true
		end

		module.texture = E.db.mMT.castbar_shield.texture
		module.sizeX = E.db.mMT.castbar_shield.sizeX
		module.sizeY = E.db.mMT.castbar_shield.sizeY
		module.anchor = E.db.mMT.castbar_shield.anchor
		module.posX = E.db.mMT.castbar_shield.posX
		module.posY = E.db.mMT.castbar_shield.posY
		module.auto = E.db.mMT.castbar_shield.auto

		module.loaded = true
	end
end
