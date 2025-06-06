local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:GetModule("Portraits")

function module:InitializeArenaPortrait()
	if module.db.arena.enable and _G.ElvUF_Arena1 then
		local portraits = module.portraits

		for i = 1, 5 do
			local parent_frame = _G["ElvUF_Arena" .. i]

			if parent_frame then
				local unit = "arena" .. i
				local type = "arena"
				local name = "Arena" .. i

				portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMT.portraits.arena)

				if portraits[unit] then
					portraits[unit].__owner = parent_frame
					portraits[unit].unit = parent_frame.unit or unit
					portraits[unit].type = type
					portraits[unit].db = E.db.mMT.portraits.arena
					portraits[unit].size = E.db.mMT.portraits.arena.size
					portraits[unit].point = E.db.mMT.portraits.arena.point
					portraits[unit].isPlayer = nil
					portraits[unit].unitClass = nil
					portraits[unit].lastGUID = nil
					portraits[unit].name = name
					portraits[unit].forceExtra = E.db.mMT.portraits.arena.extra and "player" or nil

					portraits[unit].media = module:UpdateTexturesFiles(E.db.mMT.portraits.arena.texture, E.db.mMT.portraits.arena.mirror)

					module:UpdateSize(portraits[unit], portraits[unit].size, portraits[unit].point)
					module:InitPortrait(portraits[unit], E.db.mMT.portraits.arena.size, E.db.mMT.portraits.arena.point)

					if not portraits[unit].isEnabled then
						portraits[unit]:RegisterEvent("ARENA_OPPONENT_UPDATE")
						if E.Retail then portraits[unit]:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS") end
						portraits[unit].isEnabled = true
					end
				end
			end
		end
	elseif module.portraits.arena1 then
		for i = 1, 5 do
			local unit = "arena" .. i
			module.portraits[unit]:UnregisterAllEvents()
			module.portraits[unit]:Hide()
			module.portraits[unit] = nil
		end
	end
end
