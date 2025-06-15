local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

function module:InitializeToTPortrait()
	if module.db.targettarget.enable then
		local portraits = module.portraits
		local parent_frame = _G.ElvUF_TargetTarget

		if parent_frame then
			local unit = "targettarget"
			local type = "targettarget"
			local name = "TargetTarget"

			portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMT.portraits.targettarget)

			if portraits[unit] then
				portraits[unit].__owner = parent_frame
				portraits[unit].unit = unit --parent_frame.unit
				portraits[unit].type = type
				portraits[unit].db = E.db.mMT.portraits.targettarget
				portraits[unit].size = E.db.mMT.portraits.targettarget.size
				portraits[unit].point = E.db.mMT.portraits.targettarget.point
				portraits[unit].isPlayer = nil
				portraits[unit].unitClass = nil
				portraits[unit].lastGUID = nil
				--portraits[unit].realUnit = "player"
				portraits[unit].name = name
				portraits[unit].forceExtra = (E.db.mMT.portraits.targettarget.forceExtra ~= "none") and E.db.mMT.portraits.targettarget.forceExtra or nil

				portraits[unit].media = module:UpdateTexturesFiles(E.db.mMT.portraits.targettarget.texture, E.db.mMT.portraits.targettarget.mirror)

				module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
				module:InitPortrait(portraits[unit], E.db.mMT.portraits.targettarget.size, E.db.mMT.portraits.targettarget.point)

				if not portraits[unit].isEnabled then
					portraits[unit]:RegisterEvent("PLAYER_TARGET_CHANGED")
					portraits[unit]:RegisterUnitEvent("UNIT_TARGET", unit)
					portraits[unit].isEnabled = true
				end
			end
		end
	elseif module.portraits.targettarget then
		module.portraits.targettarget:UnregisterAllEvents()
		module.portraits.targettarget:Hide()
		module.portraits.targettarget = nil
	end
end
