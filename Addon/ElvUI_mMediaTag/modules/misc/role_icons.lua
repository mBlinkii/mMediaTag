local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("RoleIcons")

local CH = E:GetModule("Chat")
local UF = E:GetModule("UnitFrames")

function module:Initialize()
	if not E.db.mMediaTag.role_icons.enable then return end

	module.TANK = MEDIA.icons.tags[E.db.mMediaTag.role_icons.tank]
	module.HEAL = MEDIA.icons.tags[E.db.mMediaTag.role_icons.heal]
	module.DAMAGER = MEDIA.icons.tags[E.db.mMediaTag.role_icons.dd]

	_G.INLINE_TANK_ICON = E:TextureString(module.TANK, ":15:15")
	_G.INLINE_HEALER_ICON = E:TextureString(module.HEAL, ":15:15")
	_G.INLINE_DAMAGER_ICON = E:TextureString(module.DAMAGER, ":15:15")

	CH.RoleIcons = {
		TANK = E:TextureString(module.TANK, ":15:15"),
		HEALER = E:TextureString(module.HEAL, ":15:15"),
		DAMAGER = E:TextureString(module.DAMAGER, ":15:15"),
	}

	UF.RoleIconTextures = {
		TANK = module.TANK,
		HEALER = module.HEAL,
		DAMAGER = module.DAMAGER,
	}

	UF:CreateAndUpdateHeaderGroup("party")
	CH:CheckLFGRoles()
end
