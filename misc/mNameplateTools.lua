local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)

local NP = E:GetModule("NamePlates")
local LSM = LibStub("LibSharedMedia-3.0")

local mInsert = table.insert
-- local unpack = unpack
-- local UnitPlayerControlled = UnitPlayerControlled
-- local UnitIsTapDenied = UnitIsTapDenied
-- local UnitClass = UnitClass
-- local UnitReaction = UnitReaction
-- local UnitIsConnected = UnitIsConnected
local CreateFrame = CreateFrame
local addon, ns = ...

local SL_NPCs = {
	[179526] = { 66, 33 },
	[176578] = { 66, 33 },
	[176555] = { 40 },
	[176556] = { 40 },
	[175806] = { 70, 40 },
	[114262] = { 20 },
	[114312] = { 60 },
	[115388] = { 30 },
	[114790] = { 66.5, 33.5 },
	[81297] = { 50 },
	[77803] = { 20 },
	[79545] = { 60 },
	[83392] = { 50 },
	[114714] = { 50 },
	[114783] = { 50 },
	[114792] = { 50 },
	[114796] = { 50 },
	[183423] = { 50 },
	[183424] = { 50 },
	[183425] = { 50 },
	[180015] = { 50 },
	[180432] = { 40 },
	[178139] = { 50, 15 },
	[178133] = { 15 },
	[178141] = { 15 },
	[178142] = { 15 },
	[166969] = { 50 },
	[166970] = { 50 },
	[166971] = { 50 },
	[168112] = { 50 },
	[168113] = { 50 },
	[174335] = { 30 },
	[172858] = { 30 },
	[169601] = { 20 },
	[175611] = { 10 },
	[175725] = { 66, 33 },
	[175729] = { 80, 60, 30 },
	[176523] = { 70, 40 },
	[175730] = { 70, 40 },
	[176929] = { 60, 20 },
	[180773] = { 15.5 },
	[183501] = { 75.5, 50.5, 30.5 },
	[181548] = { 40.5 },
	[181551] = { 40.5 },
	[181546] = { 40.5 },
	[181549] = { 40.5 },
	[180906] = { 78.5, 45.5 },
	[183671] = { 35.5 },
}

local executeRange = {
	-- warrior
	[71] = 20,
	[72] = 20,
	--[73] = 0,
	-- paladin
	[65] = 20,
	[66] = 20,
	[70] = 20,
	--HUNTER
	[253] = 35,
	[254] = 20,
	[255] = 20,
	--ROGUE"
	[259] = 35,
	--[260] = 0,
	--[261] = 0,
	--PRIEST
	--[256] = 0,
	--[257] = 0,
	[258] = 35,
	--DEATHKNIGHT
	--[250] = 0,
	--[251] = 0,
	[252] = 35,
	--SHAMAN
	--[262] = 0,
	--[263] = 0,
	--[264] = 0,
	--MAGE
	--[62] = 0,
	--[63] = 0,
	--[64] = 0,
	--"WARLOCK
	[265] = 20,
	--[266] = 0,
	--[267] = 0,
	--MONK
	[268] = 15,
	--[270] = 0,
	[269] = 15,
	--DRUID
	--[102] = 0,
	--[103] = 0,
	--[104] = 0,
	--[105] = 0,
	--DEMONHUNTER
	--[577] = 0,
	--[581] = 0,
}

local function executeMarker(unit)
	local health = unit.Health
	local db = E.db[mPlugin].mExecutemarker

	if not health.executeMarker then
		health.executeMarker = health:CreateTexture(nil, "overlay")
		health.executeMarker:SetColorTexture(1, 1, 1)
	end

	local percent = math.floor((health.cur or 100) / health.max * 100 + 0.5)
	local range = 20
	if db.auto then
		range = executeRange[select(1, GetSpecializationInfo(GetSpecialization()))]
	else
		range = db.range
	end

	if range then
		if percent > range then
			local overlaySize = health:GetWidth() * range / 100
			health.executeMarker:Show()
			health.executeMarker:SetSize(2, health:GetHeight())
			health.executeMarker:SetPoint("left", health, "left", overlaySize, 0)
			health.executeMarker:SetVertexColor(db.indicator.r, db.indicator.g, db.indicator.b)
		else
			health.executeMarker:Hide()
		end
	else
		health.executeMarker:Hide()
	end
end

local function healthMarkers(unit)
	local npcID = tonumber(unit.npcID)
	local health = unit.Health

	local db = E.db[mPlugin].mHealthmarker
	if not npcID then
		if health.healthMarker then
			health.healthMarker:Hide()
			health.healthOverlay:Hide()
		end
	else
		local markersTable = nil
		if db.useDefaults then
			markersTable = db.NPCs[npcID] or SL_NPCs[npcID]
		else
			markersTable = db.NPCs[npcID]
		end

		local texture = LSM:Fetch("statusbar", db.overlaytexture)

		if markersTable then
			for _, p in ipairs(markersTable) do
				local percent = math.floor((health.cur or 100) / health.max * 100 + 0.5)

				if percent > p then
					local overlaySize = health:GetWidth() * p / 100

					if not health.healthMarker then
						health.healthMarker = health:CreateTexture(nil, "overlay")
						health.healthMarker:SetColorTexture(1, 1, 1)
						health.healthOverlay = health:CreateTexture(texture, "overlay")
						health.healthOverlay:SetColorTexture(1, 1, 1)
					end

					health.healthMarker:Show()
					health.healthMarker:SetSize(1, health:GetHeight())
					health.healthMarker:SetPoint("left", health, "left", overlaySize, 0)
					health.healthMarker:SetVertexColor(db.indicator.r, db.indicator.g, db.indicator.b)

					health.healthOverlay:Show()
					health.healthOverlay:SetSize(overlaySize, health:GetHeight())
					health.healthOverlay:SetPoint("right", health.healthMarker, "left", 0, 0)
					health.healthOverlay:SetTexture(texture)
					health.healthOverlay:SetVertexColor(db.overlay.r, db.overlay.g, db.overlay.b)
					health.healthOverlay:SetAlpha(db.overlay.a)
					return
				end
			end

			if health.healthMarker then
				health.healthMarker:Hide()
				health.healthOverlay:Hide()
			end
		else
			if health.healthMarker then
				health.healthMarker:Hide()
				health.healthOverlay:Hide()
			end
		end
	end
end

local function mNameplateTools(table, frame, r, g, b)
	if table.isNamePlate then
		if table.Health and E.db[mPlugin].mHealthmarker.enable then
			healthMarkers(table)
		end

		if table.Health and E.db[mPlugin].mExecutemarker.enable then
			executeMarker(table)
		end
	end
end

function mMT:StartNameplateTools()
	hooksecurefunc(NP, "Health_UpdateColor", mNameplateTools)
end

local selectedID = nil
local selected = nil
local filterTabel = {}

local function updateFilterTabel()
	filterTabel = {}
	for k, v in pairs(E.db[mPlugin].mHealthmarker.NPCs) do
		mInsert(filterTabel, k)
	end
end

local function mhealtmarkerOptions()
	local ids = E.db[mPlugin].mHealthmarker.NPCs
	updateFilterTabel()

	E.Options.args.mMediaTag.args.general.args.healtmarker.args = {
		markers = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable Nameplate Healthmarker"],
			get = function(info)
				return E.db[mPlugin].mHealthmarker.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mHealthmarker.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		spacer = {
			order = 2,
			type = "description",
			name = "\n\n",
		},
		header1 = {
			order = 3,
			type = "header",
			name = "",
		},
		colorindicator = {
			type = "color",
			order = 11,
			name = L["Indicator Color"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mHealthmarker.indicator
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mHealthmarker.indicator
				t.r, t.g, t.b = r, g, b
			end,
		},
		coloroverlay = {
			type = "color",
			order = 12,
			name = L["Overlay Color"],
			hasAlpha = true,
			get = function(info)
				local t = E.db[mPlugin].mHealthmarker.overlay
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b, a)
				local t = E.db[mPlugin].mHealthmarker.overlay
				t.r, t.g, t.b, t.a = r, g, b, a
			end,
		},
        useDefaults = {
			order = 13,
			type = "toggle",
			name = L["Use Default SL NPC IDs"],
			desc = L["Uses Custom and default NPC IDs"],
			get = function(info)
				return E.db[mPlugin].mHealthmarker.useDefaults
			end,
			set = function(info, value)
				E.db[mPlugin].mHealthmarker.useDefaults = value
			end,
		},
		overlaytexture = {
			order = 14,
			type = "select",
			dialogControl = "LSM30_Statusbar",
			name = L["Overlay Texture"],
			values = LSM:HashTable("statusbar"),
			get = function(info)
				return E.db[mPlugin].mHealthmarker.overlaytexture
			end,
			set = function(info, value)
				E.db[mPlugin].mHealthmarker.overlaytexture = value
			end,
		},
		header2 = {
			order = 15,
			type = "header",
			name = "",
		},
		customid = {
			order = 21,
			name = L["Custom NPCID"],
			desc = L["Enter a NPCID"],
			type = "input",
			width = "smal",
			set = function(info, value)
				if E.db[mPlugin].mHealthmarker.NPCs[tonumber(value)] then
					selectedID = tonumber(value)
				else
					selected = nil
					selectedID = nil
					mInsert(E.db[mPlugin].mHealthmarker.NPCs, value, { 0, 0, 0, 0 })
				end
				updateFilterTabel()
			end,
		},
		idtable = {
			type = "select",
			order = 22,
			name = L["NPC IDS"],
			values = function()
				updateFilterTabel()
				return filterTabel
			end,
			get = function(info)
				updateFilterTabel()
				return selected
			end,
			set = function(info, value)
				selected = value
				selectedID = tonumber(filterTabel[value])
			end,
		},
		deleteid = {
			order = 22,
			name = L["Delete NPCID"],
			type = "input",
			width = "smal",
			set = function(info, value)
				if E.db[mPlugin].mHealthmarker.NPCs[tonumber(value)] then
					E.db[mPlugin].mHealthmarker.NPCs[tonumber(value)] = nil
					selectedID = 0
					selected = nil
					updateFilterTabel()
				end
			end,
		},
		deleteall = {
			order = 23,
			type = "execute",
			name = L["Delete all"],
			func = function()
				E.db[mPlugin].mHealthmarker.NPCs = {}
				filterTabel = {}
			end,
		},
		header3 = {
			order = 30,
			type = "header",
			name = "",
		},
		mark1 = {
			order = 31,
			name = L["Healthmark 1"],
			desc = L["0 = disable"],
			type = "range",
			min = 0,
			max = 100,
			step = 0.5,
			disabled = function()
				return not E.db[mPlugin].mHealthmarker.NPCs[selectedID]
			end,
			get = function()
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					return E.db[mPlugin].mHealthmarker.NPCs[selectedID][1]
				end
			end,
			set = function(info, value)
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					E.db[mPlugin].mHealthmarker.NPCs[selectedID][1] = value
					if value == 0 or value == 100 then
						E.db[mPlugin].mHealthmarker.NPCs[selectedID][2] = 0
						E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] = 0
						E.db[mPlugin].mHealthmarker.NPCs[selectedID][4] = 0
					end
				end
			end,
		},
		mark2 = {
			order = 32,
			name = L["Healthmark 2"],
			desc = L["0 = disable"],
			type = "range",
			min = 0,
			max = 100,
			step = 0.5,
			disabled = function()
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					if E.db[mPlugin].mHealthmarker.NPCs[selectedID][1] then
						if
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][1] == 0
							or E.db[mPlugin].mHealthmarker.NPCs[selectedID][1] == 100
						then
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][2] = 0
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] = 0
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][4] = 0
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end,
			get = function()
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					return E.db[mPlugin].mHealthmarker.NPCs[selectedID][2]
				end
			end,
			set = function(info, value)
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					if value > E.db[mPlugin].mHealthmarker.NPCs[selectedID][1] then
						value = E.db[mPlugin].mHealthmarker.NPCs[selectedID][1] - 0.5
					end
					if value == 0 or value == 100 then
						E.db[mPlugin].mHealthmarker.NPCs[3] = 0
						E.db[mPlugin].mHealthmarker.NPCs[4] = 0
					end
				end
			end,
		},
		mark3 = {
			order = 33,
			name = L["Healthmark 3"],
			desc = L["0 = disable"],
			type = "range",
			min = 0,
			max = 100,
			step = 0.5,
			disabled = function()
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					if E.db[mPlugin].mHealthmarker.NPCs[selectedID][2] then
						if
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][2] == 0
							or E.db[mPlugin].mHealthmarker.NPCs[selectedID][2] == 100
						then
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] = 0
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][4] = 0
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end,
			get = function()
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					return E.db[mPlugin].mHealthmarker.NPCs[selectedID][3]
				end
			end,
			set = function(info, value)
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					if value > E.db[mPlugin].mHealthmarker.NPCs[selectedID][2] then
						value = E.db[mPlugin].mHealthmarker.NPCs[selectedID][2] - 0.5
					end
					E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] = value
					if value == 0 or value == 100 then
						E.db[mPlugin].mHealthmarker.NPCs[selectedID][4] = 0
					end
				end
			end,
		},
		mark4 = {
			order = 34,
			name = L["Healthmark 4"],
			desc = L["0 = disable"],
			type = "range",
			min = 0,
			max = 100,
			step = 0.5,
			disabled = function()
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					if E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] then
						if
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] == 0
							or E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] == 100
						then
							E.db[mPlugin].mHealthmarker.NPCs[selectedID][4] = 0
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end,
			get = function()
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					return E.db[mPlugin].mHealthmarker.NPCs[selectedID][4]
				end
			end,
			set = function(info, value)
				if E.db[mPlugin].mHealthmarker.NPCs[selectedID] then
					if value > E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] then
						value = E.db[mPlugin].mHealthmarker.NPCs[selectedID][3] - 0.5
					end
					E.db[mPlugin].mHealthmarker.NPCs[selectedID][4] = value
				end
			end,
		},
        header4 = {
			order = 60,
			type = "header",
			name = L["Execute indicator"],
		},
        executemarkers = {
			order = 61,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable Nameplate Executeindicator"],
			get = function(info)
				return E.db[mPlugin].mExecutemarker.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mExecutemarker.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		autorange = {
			order = 62,
			type = "toggle",
			name = L["Auto range"],
			desc = L["Execute range based on your Class"],
			get = function(info)
				return E.db[mPlugin].mHealthmarker.auto
			end,
			set = function(info, value)
				E.db[mPlugin].mHealthmarker.auto = value
			end,
		},
        executeindicator = {
			type = "color",
			order = 63,
			name = L["Indicator Color"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mExecutemarker.indicator
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mExecutemarker.indicator
				t.r, t.g, t.b = r, g, b
			end,
		},
        executerange = {
            order = 64,
            name = L["Execute Range HP%"],
            type = "range",
            min = 5,
            max = 95,
            step = 1,
            get = function(info)
                return E.db[mPlugin].mExecutemarker.range
            end,
            set = function(info, value)
                E.db[mPlugin].mExecutemarker.range = value
            end,
        },
	}
end

mInsert(ns.Config, mhealtmarkerOptions)
