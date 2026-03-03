local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

function module:InitializeFocusPortrait()
	if module.db.focus.enable then
		local portraits = module.portraits
		local parent_frame = _G.ElvUF_Focus

		if parent_frame then
			local unit = "focus"
			local type = "focus"
			local name = "Focus"

			portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMediaTag.portraits.focus)

			if portraits[unit] then
				portraits[unit].__owner = parent_frame
				portraits[unit].unit = unit --parent_frame.unit
				portraits[unit].type = type
				portraits[unit].db = E.db.mMediaTag.portraits.focus
				portraits[unit].size = E.db.mMediaTag.portraits.focus.size
				portraits[unit].point = E.db.mMediaTag.portraits.focus.point
				portraits[unit].isPlayer = nil
				portraits[unit].unitClass = nil
				portraits[unit].lastGUID = nil
				--portraits[unit].realUnit = "player"
				portraits[unit].name = name
				portraits[unit].forceExtra = (E.db.mMediaTag.portraits.focus.forceExtra ~= "none") and E.db.mMediaTag.portraits.focus.forceExtra or nil

				portraits[unit].media = module:UpdateTexturesFiles(E.db.mMediaTag.portraits.focus.texture, E.db.mMediaTag.portraits.focus.mirror)

				module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
				module:InitPortrait(portraits[unit], E.db.mMediaTag.portraits.focus.size, E.db.mMediaTag.portraits.focus.point)

				if not portraits[unit].isEnabled then
					portraits[unit]:RegisterEvent("PLAYER_FOCUS_CHANGED")
					portraits[unit].isEnabled = true
				end
			end
		end
	elseif module.portraits.focus then
		module.portraits.focus:UnregisterAllEvents()
		module.portraits.focus:Hide()
		module.portraits.focus = nil
	end
end
