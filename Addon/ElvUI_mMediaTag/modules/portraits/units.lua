local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:GetModule("Portraits")

--- Set up common fields on a portrait element.
local function SetupPortrait(portraits, unit, name, type, parent_frame, dbKey, forceRealUnit)
	local db    = E.db.mMediaTag.portraits[dbKey]
	local p     = portraits[unit]

	p.__owner   = parent_frame
	p.unit      = parent_frame.unit or unit
	p.type      = type
	p.db        = db
	p.size      = db.size
	p.point     = db.point
	p.isPlayer  = nil
	p.unitClass = nil
	p.lastGUID  = nil
	p.name      = name

	if forceRealUnit then
		p.realUnit = unit
	end

	-- forceExtra: player always uses "player"; others use db value or nil
	if dbKey == "player" then
		p.forceExtra = db.extra and "player" or nil
	else
		p.forceExtra = (db.forceExtra ~= "none") and db.forceExtra or nil
	end

	p.media = module:UpdateTexturesFiles(db.texture, db.mirror)

	module:UpdateSize(p, p.size, p.point)
	module:InitPortrait(p, db.size, db.point)
end

local function DestroyPortrait(portraits, unit)
	local p = portraits[unit]
	if p then
		p:UnregisterAllEvents()
		p:Hide()
		portraits[unit] = nil
	end
end

local singleUnits = {
	{
		method   = "InitializePlayerPortrait",
		dbKey    = "player",
		unit     = "player",
		type     = "player",
		name     = "Player",
		frame    = "ElvUF_Player",
		realUnit = true,
		events   = { "UNIT_ENTERED_VEHICLE", "UNIT_EXITING_VEHICLE", "UNIT_EXITED_VEHICLE", "VEHICLE_UPDATE" },
	},
	{
		method = "InitializeTargetPortrait",
		dbKey  = "target",
		unit   = "target",
		type   = "target",
		name   = "Target",
		frame  = "ElvUF_Target",
		events = { "PLAYER_TARGET_CHANGED" },
	},
	{
		method   = "InitializeFocusPortrait",
		dbKey    = "focus",
		unit     = "focus",
		type     = "focus",
		name     = "Focus",
		frame    = "ElvUF_Focus",
		events   = { "PLAYER_FOCUS_CHANGED" },
	},
	{
		method   = "InitializePetPortrait",
		dbKey    = "pet",
		unit     = "pet",
		type     = "pet",
		name     = "Pet",
		frame    = "ElvUF_Pet",
		realUnit = true,
		events   = { "UNIT_ENTERED_VEHICLE", "UNIT_EXITING_VEHICLE", "UNIT_EXITED_VEHICLE", "VEHICLE_UPDATE" },
	},
	{
		method = "InitializeToTPortrait",
		dbKey  = "targettarget",
		unit   = "targettarget",
		type   = "targettarget",
		name   = "TargetTarget",
		frame  = "ElvUF_TargetTarget",
		events = { "PLAYER_TARGET_CHANGED" },
		extraEvents = function(p, unit)
			p:RegisterUnitEvent("UNIT_TARGET", unit)
		end,
	},
}

for _, cfg in ipairs(singleUnits) do
	module[cfg.method] = function(self)
		local portraits = module.portraits
		local parent_frame = _G[cfg.frame]

		if module.db[cfg.dbKey].enable then
			if not parent_frame then return end

			local unit = cfg.unit
			portraits[unit] = portraits[unit] or module:CreatePortrait(cfg.name, parent_frame, E.db.mMediaTag.portraits[cfg.dbKey])
			if not portraits[unit] then return end

			SetupPortrait(portraits, unit, cfg.name, cfg.type, parent_frame, cfg.dbKey, cfg.realUnit)

			if not portraits[unit].isEnabled then
				for _, event in ipairs(cfg.events) do
					portraits[unit]:RegisterEvent(event)
				end
				if cfg.extraEvents then cfg.extraEvents(portraits[unit], unit) end
				portraits[unit].isEnabled = true
			end
		elseif portraits[cfg.unit] then
			DestroyPortrait(portraits, cfg.unit)
		end
	end
end

function module:InitializeArenaPortrait()
	local portraits = module.portraits

	if module.db.arena.enable and _G.ElvUF_Arena1 then
		for i = 1, 5 do
			local parent_frame = _G["ElvUF_Arena" .. i]
			if parent_frame then
				local unit = "arena" .. i
				local name = "Arena" .. i

				portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMediaTag.portraits.arena)
				if portraits[unit] then
					SetupPortrait(portraits, unit, name, "arena", parent_frame, "arena")

					if not portraits[unit].isEnabled then
						portraits[unit]:RegisterEvent("ARENA_OPPONENT_UPDATE")
						if E.Retail then portraits[unit]:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS") end
						portraits[unit].isEnabled = true
					end
				end
			end
		end
	elseif portraits.arena1 then
		for i = 1, 5 do DestroyPortrait(portraits, "arena" .. i) end
	end
end

function module:InitializeBossPortrait()
	local portraits = module.portraits

	if module.db.boss.enable and _G.ElvUF_Boss1 then
		for i = 1, 8 do
			local parent_frame = _G["ElvUF_Boss" .. i]
			if parent_frame then
				local unit = "boss" .. i
				local name = "Boss" .. i

				portraits[unit] = portraits[unit] or module:CreatePortrait(name, parent_frame, E.db.mMediaTag.portraits.boss)
				if portraits[unit] then
					SetupPortrait(portraits, unit, name, "boss", parent_frame, "boss")

					if not portraits[unit].isEnabled then
						portraits[unit]:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
						portraits[unit]:RegisterEvent("UNIT_TARGETABLE_CHANGED")
						portraits[unit].isEnabled = true
					end
				end
			end
		end
	elseif portraits.boss1 then
		for i = 1, 8 do DestroyPortrait(portraits, "boss" .. i) end
	end
end

function module:InitializePartyPortrait()
	local portraits = module.portraits

	if module.db.party.enable and _G.ElvUF_PartyGroup1UnitButton1 then
		for i = 1, 5 do
			local parent_frame = _G["ElvUF_PartyGroup1UnitButton" .. i]
			if parent_frame then
				local unit = "party" .. i

				portraits[unit] = portraits[unit] or module:CreatePortrait("Party", parent_frame, E.db.mMediaTag.portraits.party)
				if portraits[unit] then
					SetupPortrait(portraits, unit, "Party", "party", parent_frame, "party")

					if not portraits[unit].isEnabled then
						portraits[unit]:RegisterEvent("GROUP_ROSTER_UPDATE")
						portraits[unit]:RegisterEvent("PARTY_MEMBER_ENABLE")
						portraits[unit].isEnabled = true
					end
				end
			end
		end
	elseif portraits.party1 then
		for i = 1, 5 do DestroyPortrait(portraits, "party" .. i) end
	end
end
