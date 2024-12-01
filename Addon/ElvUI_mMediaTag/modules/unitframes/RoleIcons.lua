local E = unpack(ElvUI)
local CH = E:GetModule("Chat")
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.RoleIcons
if not module then
	return
end

local sizeString = ":15:15"

function module:Initialize()
	local icons = { tank = { icon = nil, path = nil }, heal = { icon = nil, path = nil }, dd = { icon = nil, path = nil } }

	if E.db.mMT.roleicons.customtexture then
		icons.tank.icon = E:TextureString(E.db.mMT.roleicons.customtank, sizeString)
		icons.tank.path = E.db.mMT.roleicons.customtank

		icons.heal.icon = E:TextureString(E.db.mMT.roleicons.customheal, sizeString)
		icons.heal.path = E.db.mMT.roleicons.customheal

		icons.dd.icon = E:TextureString(E.db.mMT.roleicons.customdd, sizeString)
		icons.dd.path = E.db.mMT.roleicons.customdd
	else
		icons.tank.icon = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.tank], sizeString)
		icons.tank.path = mMT.Media.Role[E.db.mMT.roleicons.tank]

		icons.heal.icon = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.heal], sizeString)
		icons.heal.path = mMT.Media.Role[E.db.mMT.roleicons.heal]

		icons.dd.icon = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.dd], sizeString)
		icons.dd.path = mMT.Media.Role[E.db.mMT.roleicons.dd]
	end

	if icons.tank.icon and icons.heal.icon and icons.dd.icon then
		_G.INLINE_TANK_ICON = icons.tank.icon
		_G.INLINE_HEALER_ICON = icons.heal.icon
		_G.INLINE_DAMAGER_ICON = icons.dd.icon

		CH.RoleIcons = {
			TANK = icons.tank.icon,
			HEALER = icons.heal.icon,
			DAMAGER = icons.dd.icon,
		}

		UF.RoleIconTextures = {
			TANK = icons.tank.path,
			HEALER = icons.heal.path,
			DAMAGER = icons.dd.path,
		}
	end

	module.hooked = true
	module.needReloadUI = true
	module.loaded = true
end
