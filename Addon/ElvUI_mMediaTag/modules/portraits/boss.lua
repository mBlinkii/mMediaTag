local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

function module:InitializeBossPortrait()
	if module.db.boss.enable and _G.ElvUF_Boss1 then
		local portraits = module.portraits

		for i = 1, 8 do
			local parent_frame = _G["ElvUF_Boss" .. i]

			if parent_frame then
				local unit = "boss" .. i
				local type = "boss"
				local name = "Boss" .. i

				portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMT.portraits.boss)

				if portraits[unit] then
					portraits[unit].__owner = parent_frame
					portraits[unit].unit = parent_frame.unit or unit
					portraits[unit].type = type
					portraits[unit].db = E.db.mMT.portraits.boss
					portraits[unit].size = E.db.mMT.portraits.boss.size
					portraits[unit].point = E.db.mMT.portraits.boss.point
					portraits[unit].isPlayer = nil
					portraits[unit].unitClass = nil
					portraits[unit].lastGUID = nil
					portraits[unit].name = name
					--portraits[unit].forceExtra = E.db.mMT.portraits.boss.extra and "player" or nil

					portraits[unit].media = module:UpdateTexturesFiles(E.db.mMT.portraits.boss.texture, E.db.mMT.portraits.boss.mirror)

					module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
					module:InitPortrait(portraits[unit], E.db.mMT.portraits.boss.size, E.db.mMT.portraits.boss.point)

					if not portraits[unit].isEnabled then
						portraits[unit]:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
						portraits[unit]:RegisterEvent("UNIT_TARGETABLE_CHANGED")
						portraits[unit].isEnabled = true
					end
				end
			end
		end
	elseif module.portraits.boss1 then
		for i = 1, 8 do
			local unit = "boss" .. i
			module.portraits[unit]:UnregisterAllEvents()
			module.portraits[unit]:Hide()
			module.portraits[unit] = nil
		end
	end
end
