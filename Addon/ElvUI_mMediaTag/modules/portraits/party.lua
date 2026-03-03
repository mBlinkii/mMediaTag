local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

function module:InitializePartyPortrait()
	if module.db.party.enable and _G.ElvUF_PartyGroup1UnitButton1 then
		local portraits = module.portraits

		for i = 1, 5 do
			local parent_frame = _G["ElvUF_PartyGroup1UnitButton" .. i]

			if parent_frame then
				local unit = "party" .. i
				local type = "party"
				local name = "Party"

				portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMediaTag.portraits.party)

				if portraits[unit] then
					portraits[unit].__owner = parent_frame
					portraits[unit].unit = parent_frame.unit or unit
					portraits[unit].type = type
					portraits[unit].db = E.db.mMediaTag.portraits.party
					portraits[unit].size = E.db.mMediaTag.portraits.party.size
					portraits[unit].point = E.db.mMediaTag.portraits.party.point
					portraits[unit].isPlayer = nil
					portraits[unit].unitClass = nil
					portraits[unit].lastGUID = nil
					portraits[unit].name = name
					portraits[unit].forceExtra = (E.db.mMediaTag.portraits.party.forceExtra ~= "none") and E.db.mMediaTag.portraits.party.forceExtra or nil

					portraits[unit].media = module:UpdateTexturesFiles(E.db.mMediaTag.portraits.party.texture, E.db.mMediaTag.portraits.party.mirror)

					module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
					module:InitPortrait(portraits[unit], E.db.mMediaTag.portraits.party.size, E.db.mMediaTag.portraits.party.point)

					if not portraits[unit].isEnabled then
						portraits[unit]:RegisterEvent("GROUP_ROSTER_UPDATE")
						portraits[unit]:RegisterEvent("PARTY_MEMBER_ENABLE")
						--portraits[unit]:RegisterEvent("UNIT_HEALTH")
						portraits[unit].isEnabled = true
					end
				end
			end
		end
	elseif module.portraits.party1 then
		for i = 1, 5 do
			local unit = "party" .. i
			module.portraits[unit]:UnregisterAllEvents()
			module.portraits[unit]:Hide()
			module.portraits[unit] = nil
		end
	end
end
