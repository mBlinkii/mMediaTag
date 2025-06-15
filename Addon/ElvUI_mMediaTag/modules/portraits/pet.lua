local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

function module:InitializePetPortrait()
	if module.db.pet.enable then
		local portraits = module.portraits
		local parent_frame = _G.ElvUF_Pet

		if parent_frame then
			local unit = "pet"
			local type = "pet"
			local name = "Pet"

			portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMT.portraits.pet)

			if portraits[unit] then
				portraits[unit].__owner = parent_frame
				portraits[unit].unit = unit --parent_frame.unit
				portraits[unit].type = type
				portraits[unit].db = E.db.mMT.portraits.pet
				portraits[unit].size = E.db.mMT.portraits.pet.size
				portraits[unit].point = E.db.mMT.portraits.pet.point
				portraits[unit].isPlayer = nil
				portraits[unit].unitClass = nil
				portraits[unit].lastGUID = nil
				portraits[unit].realUnit = "pet"
				portraits[unit].name = name
				portraits[unit].forceExtra = (E.db.mMT.portraits.pet.forceExtra ~= "none") and E.db.mMT.portraits.pet.forceExtra or nil

				portraits[unit].media = module:UpdateTexturesFiles(E.db.mMT.portraits.pet.texture, E.db.mMT.portraits.pet.mirror)

				module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
				module:InitPortrait(portraits[unit], E.db.mMT.portraits.pet.size, E.db.mMT.portraits.pet.point)

				if not portraits[unit].isEnabled then
					portraits[unit]:RegisterEvent("UNIT_ENTERED_VEHICLE")
					portraits[unit]:RegisterEvent("UNIT_EXITING_VEHICLE")
					portraits[unit]:RegisterEvent("UNIT_EXITED_VEHICLE")
					portraits[unit]:RegisterEvent("VEHICLE_UPDATE")
					portraits[unit].isEnabled = true
				end
			end
		end
	elseif module.portraits.pet then
		module.portraits.pet:UnregisterAllEvents()
		module.portraits.pet:Hide()
		module.portraits.pet = nil
	end
end
