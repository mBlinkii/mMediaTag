local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

function module:InitializeTargetPortrait()
	if module.db.target.enable then
		local portraits = module.portraits
		local parent_frame = _G.ElvUF_Target

		if parent_frame then
			local unit = "target"
			local type = "target"
			local name = "Target"

			portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMT.portraits.target)

			if portraits[unit] then
				portraits[unit].__owner = parent_frame
				portraits[unit].unit = unit --parent_frame.unit
				portraits[unit].type = type
				portraits[unit].db = E.db.mMT.portraits.target
				portraits[unit].size = E.db.mMT.portraits.target.size
				portraits[unit].point = E.db.mMT.portraits.target.point
				portraits[unit].isPlayer = nil
				portraits[unit].unitClass = nil
				portraits[unit].lastGUID = nil
				--portraits[unit].realUnit = "player"
				portraits[unit].name = name
				--portraits[unit].forceExtra = E.db.mMT.portraits.target.extra and "player" or nil

				portraits[unit].media = module:UpdateTexturesFiles(E.db.mMT.portraits.target.texture, E.db.mMT.portraits.target.mirror)

				module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
				module:InitPortrait(portraits[unit], E.db.mMT.portraits.target.size, E.db.mMT.portraits.target.point)

				portraits[unit]:RegisterEvent("PLAYER_TARGET_CHANGED")
			end
		end
	elseif module.portrait.target then
		module:RemovePortrait(module.portraits.target)
		module.portraits.target = nil
	end
end
