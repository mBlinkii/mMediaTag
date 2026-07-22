local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("RoleIcons")

local CH = E:GetModule("Chat")
local UF = E:GetModule("UnitFrames")

local function ForceRoleIconUpdate(frame)
	if frame.GroupRoleIndicator and frame.IsElementEnabled and frame:IsElementEnabled("GroupRoleIndicator") then
		frame.GroupRoleIndicator:ForceUpdate()
	end
end

local function UpdateHeaderRoleIcons(header)
	if not header then return end

	for i = 1, header:GetNumChildren() do
		local child = select(i, header:GetChildren())
		if child then
			ForceRoleIconUpdate(child)
			for j = 1, child:GetNumChildren() do
				local frame = select(j, child:GetChildren())
				if frame then ForceRoleIconUpdate(frame) end
			end
		end
	end
end

function module:Initialize()
	if not E.db.mMediaTag.role_icons.enable then return end

	module.TANK = MEDIA.icons.role[E.db.mMediaTag.role_icons.tank]
	module.HEAL = MEDIA.icons.role[E.db.mMediaTag.role_icons.heal]
	module.DAMAGER = MEDIA.icons.role[E.db.mMediaTag.role_icons.dd]

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

	if E.private.unitframe.enable then
		local units = E.db.unitframe.units

		if units.party and units.party.enable then UpdateHeaderRoleIcons(UF.party) end

		for i = 1, 3 do
			local unit = "raid" .. i
			if units[unit] and units[unit].enable then UpdateHeaderRoleIcons(UF[unit]) end
		end
	end

	CH:CheckLFGRoles()
end
