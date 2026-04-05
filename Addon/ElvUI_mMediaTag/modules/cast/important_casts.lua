local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ImportantCasts")

local IsSpellImportant = C_Spell and C_Spell.IsSpellImportant
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

local EDGE_FILE = [[Interface\BUTTONS\WHITE8X8]]
local backdropInfo = { edgeFile = EDGE_FILE, edgeSize = 2 }

-- Thanks to Trenchy for letting me use his code as a basis <3

local function GetOrCreateBorder(castbar)
	if castbar.mMT_ImportantCastBorder then return castbar.mMT_ImportantCastBorder end

	local border = CreateFrame("Frame", "mMT_ImportantCastBorder", castbar, "BackdropTemplate")
	border:SetFrameLevel(castbar:GetFrameLevel() + 5)
	border:Hide()

	castbar.mMT_ImportantCastBorder = border
	return border
end

local function GetOrCreateIcon(castbar)
	if castbar.mMT_ImportantCastIcon then return castbar.mMT_ImportantCastIcon end

	local icon = castbar:CreateTexture("mMT_ImportantCastIcon", "OVERLAY")
	icon:SetWidth(module.iconSize)
	icon:SetHeight(module.iconSize)
	icon:SetPoint(module.anchor, module.posX, module.posY)
	icon:SetTexture(MEDIA.logo)
	--icon:SetFrameLevel(castbar:GetFrameLevel() + 5)
	icon:Hide()

	castbar.mMT_ImportantCastIcon = icon
	return icon
end

local function ApplyBorderStyle(border, castbar)
	local thickness = module.thickness

	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", castbar, -thickness, thickness)
	border:SetPoint("BOTTOMRIGHT", castbar, thickness, -thickness)

	backdropInfo.edgeSize = thickness
	border:SetBackdrop(backdropInfo)

	local color = module.color
	border:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
end

local function ShowImportantCast(castbar)
	local border = GetOrCreateBorder(castbar)
	ApplyBorderStyle(border, castbar)
	border:Show()

	if module.showIcon then
		local icon = GetOrCreateIcon(castbar)
		icon:Show()
	end
end

local function HideImportantCast(castbar)
	local border = castbar.mMT_ImportantCastBorder
	if border and border:IsShown() then border:Hide() end

	local icon = castbar.mMT_ImportantCastIcon
	if icon and icon:IsShown() then icon:Hide() end
end

local function CheckImportant(castbar)
	local spellID = castbar.spellID
	if not spellID then
		HideImportantCast(castbar)
		return
	end

	-- IsSpellImportant may return a ConditionalSecret boolean; pass to SetAlphaFromBoolean if secret
	local isImportant = true --IsSpellImportant(spellID)
	if E:IsSecretValue(isImportant) then
		-- Secret boolean — show the border and let alpha handle visibility
		local border = GetOrCreateBorder(castbar)
		ApplyBorderStyle(border, castbar)
		border:Show()
		border:SetAlphaFromBoolean(isImportant, 1, 0)

		if module.showIcon then
			local icon = GetOrCreateIcon(castbar)
			icon:Show()
            icon:SetAlphaFromBoolean(isImportant, 1, 0)
		end
	elseif isImportant then
		ShowImportantCast(castbar)
	else
		HideImportantCast(castbar)
	end
end

function module:Initialize()
	if not E.db.mMediaTag.important_casts.enable then return end
	if not IsSpellImportant then return end

	module.db = E.db.mMediaTag.important_casts
	if not module.isEnabled then
		hooksecurefunc(NP, "Castbar_PostCastStart", function(castbar)
			if not castbar then return end
			CheckImportant(castbar)
		end)

		hooksecurefunc(NP, "Castbar_PostCastStop", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(NP, "Castbar_PostCastFail", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(NP, "Castbar_PostCastInterrupted", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(UF, "PostCastStart", function(castbar)
			if not castbar then return end
			CheckImportant(castbar)
		end)

		hooksecurefunc(UF, "PostCastStop", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(UF, "PostCastFail", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)

		hooksecurefunc(UF, "PostCastInterrupted", function(castbar)
			if not castbar then return end
			HideImportantCast(castbar)
		end)
		module.isEnabled = true
	end

	module.color = module.db.classColor and MEDIA.myclass or MEDIA.color.important_casts
	module.thickness = module.db.thickness or 2
	module.showIcon = module.db.showIcon
	module.iconSize = module.db.iconSize or 16
	module.anchor = module.db.anchor
    module.posX = module.db.posX or 0
    module.posY = module.db.posY or 0
end
