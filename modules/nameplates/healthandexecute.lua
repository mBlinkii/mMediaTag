local mMT, E, L, V, P, G = unpack((select(2, ...)))

local NP = E:GetModule("NamePlates")
local LSM = LibStub("LibSharedMedia-3.0")

local CreateFrame = CreateFrame
local IsResting = IsResting

local HM_NPCs = {
	-- DF Dungeons
	[190485] = { 50 }, --Stormvein - Ruby Life pools
	[193435] = { 50 }, --Kyrakka - Ruby Life pools
	[188252] = { 66, 33 }, --Melidrussa Chillworn - Ruby Life pools
	[197697] = { 50 }, -- Flamegullet - Ruby Life Pools
	[186738] = { 75, 50, 25 }, --Umbrelskul - The Azure Vault
	[186125] = { 30 }, --Tricktotem - Brackenhide Hollow
	[186122] = { 30 }, --Rira Hackclaw - Brackenhide Hollow
	[186124] = { 30 }, --Gashtooth - Brackenhide Hollow
	[185534] = { 10 }, --Bonebolt Hunter - Brackenhide Hollow
	[186121] = { 4 }, -- Decatriarch Wratheye - Brackenhide Hollow
	[194816] = { 10 }, -- Forgewrought Monstrosity - Neltharus
	[189719] = { 15 }, --Watcher Irideus - Halls of Infusion
	[190407] = { 20 }, --Aqua Rager - Halls of Infusion
	[186151] = { 60 }, --Balakar Khan - The Nokhud Offensive
	[184020] = { 40 }, -- Hulking Berserker-  Uldaman: Legacy of Tyr
	[184580] = { 10 }, -- Olaf -  Uldaman: Legacy of Tyr
	[184581] = { 10 }, -- Baelog -  Uldaman: Legacy of Tyr
	[184582] = { 10 }, -- Eric "The Swift" -  Uldaman: Legacy of Tyr
	[184422] = { 70, 30 }, --Emberon - Uldaman: Legacy of Tyr

	-- SL Dungeons
	[164451] = { 40 }, --dessia the decapirator - theater of pain
	[164463] = { 40 }, --Paceran the Virulent - theater of pain
	[164461] = { 40 }, --Sathel the Accursed - theater of pain
	[165946] = { 50 }, -- ~mordretha - thather of pain
	[164501] = { 70, 40, 10 }, --mistcaller -mists of  tina
	[164926] = { 50 }, --Drust Boughbreaker - mists of tina
	[164804] = { 22 }, -- Droman Oulfarran - mists of tina
	[164267] = { 66, 33 }, --Magrave Stradama - Plaguefall
	[164967] = { 66, 33 }, --Doctor ickus - Plaguefall
	[169861] = { 66, 33 }, -- Ickor Bileflesh - Plaguefall
	[164218] = { 70, 40 }, --Lord Chamberlain - Halls of Atonemen
	[162099] = { 50 }, --General Kaal Boss fight- Sanguine Depths
	[162061] = { 70, 30 }, --Devos - Spires of Ascension
	[163121] = { 70 }, -- Stitched vanguard - Necrotic Wake
	[164558] = { 80, 60, 40, 20 }, --Hakkar the Soulflayer - De Other Side
	[177269] = { 40 }, --So'leah - Tazavesh: Gambit
	[175806] = { 66, 33 }, --So'azmi - Tazavesh: Streets

	-- BFA Dungeons
	[133345] = { 20 }, --Feckless Assistant - The MOTHERLODE!!
	[150276] = { 50 }, --Heavy Scrapbots - Mechagon: Junk
	[152009] = { 30 }, --Malfunctioning Scrapbots - Mechagon: Jun
	[144298] = { 30 }, --Defense Bot Mk III (casts a shield) -Mechagon: Work

	-- Draenor Dungeons
	[81236] = { 50 }, --Grimrail Technician - Grimrail Depot
	[79545] = { 60 }, --Nitrogg Thundertower - Grimrail Depot
	[77803] = { 20 }, --Railmaster Rocketspark - Grimrail Depot
	[81297] = { 50 }, --Dreadfang -> Fleshrender Nok'gar - Iron Docks

	-- Legion Dungeons
	[114790] = { 66, 33 }, -- Viz'aduum - Kara: Upper
	[114261] = { 50 }, --Toe Knee - Kara: Lower
	[114260] = { 50 }, -- Mrrgria - Kara: Lower
	[114265] = { 50 }, --Gang Ruffian - Kara: Lower
	[114783] = { 50 }, --Reformed Maiden - Kara: Lower
	[114312] = { 60 }, -- Moroes - Kara: Lower
	[96574] = { 30 }, --Stormforged Sentinel - Halls of Valor
	[95676] = { 80 }, --Odyn - Halls of Valor
	[94960] = { 10 }, -- Hymdall - Halls of Valor
	[95674] = { 60 }, -- Fenryr - Halls of Valor
	[104215] = { 25 }, -- Patrouillenoffizier Gerdo

	-- Pandaria Dungeons
	[59544] = { 50 }, --The Nodding Tiger
	[56732] = { 70, 30 }, --Liu Flammenherz

	-- DF Raid
	[181378] = { 66, 33 }, --Kurog Grimtotem, Vault of the Incarnates
	[194990] = { 50 }, -- Stormseeker Acolyte, Vault of the Incarnates

	-- SL Raid
	[181548] = { 40 }, --Absolution: Prototype Pantheon, Sepulcher of the First Ones
	[181551] = { 40 }, --Duty: Prototype Pantheon, Sepulcher of the First Ones
	[181546] = { 40 }, --Renewal: Prototype Pantheon, Sepulcher of the First Ones
	[181549] = { 40 }, --War: Prototype Pantheon, Sepulcher of the First Ones
	[183501] = { 75, 50 }, --Xymox, Sepulcher of the First Ones
	[180906] = { 78, 45 }, --Halondrus, Sepulcher of the First Ones
	[183671] = { 40 }, --Monstrous Soul - Anduin, Sepulcher of the First Ones
	[185421] = { 15 }, --The Jailer, Sepulcher of the First Ones
	[175730] = { 70, 40 }, --Fatescribe Roh-Kalo, Sanctum of domination
	[176523] = { 70, 40 }, --Painsmith, Sanctum of domination
	[175725] = { 66, 33 }, --Eye of the Jailer, Sanctum of domination
	[176929] = { 60, 20 }, --Remnant of Kel'Thuzad, Sanctum of domination
	[175732] = { 83, 50 }, -- Sylvanas Windrunner, Sanctum of Domination
	[166969] = { 50 }, --Council of Blood - Frieda, Castle Nathria
	[166970] = { 50 }, --Council of Blood - Stavros, Castle Nathria
	[166971] = { 50 }, --Council of Blood - Niklaus, Castle Nathria
	[167406] = { 70.5, 37.5 }, --Sire Denathrius, Castle Nathria
	[173162] = { 66, 33 }, --Lord Evershade, Castle Nathria

	-- World
	[180013] = { 20 }, --Escaped Wilderling, Shadowlands - Korthia
	[179931] = { 80, 60 }, --Relic Breaker krelva, Shadowlands - Korthia
	[193532] = { 40 }, --Bazual, The Dreaded Flame, Dhragonflight

	--Mage Tower
	[116410] = { 33 }, -- Karam Magespear
}

local executeAutoRange = { enabel = false, range = 30 }

function mMT:updateAutoRange()
	executeAutoRange.enabel = false
	executeAutoRange.range = 0

	local _, class = UnitClass("player")
	local spec = GetSpecialization()
	local specID = GetSpecializationInfo(spec) or 0
	if not (spec or class or specID) or specID == 0 then
		return
	end

	if class == "MAGE" then
		if specID == 62 then
			if IsPlayerSpell(384581) then -- Arcane pressure
				executeAutoRange.enabel = true
				executeAutoRange.range = 35
			end
		elseif specID == 63 then
			if IsPlayerSpell(269644) then -- Touch
				executeAutoRange.enabel = true
				executeAutoRange.range = 30
			end
		end
	elseif class == "WARLOCK" then
		if specID == 265 then
			if IsPlayerSpell(198590) then -- Souldrain
				executeAutoRange.enabel = true
				executeAutoRange.range = 20
			end
		elseif specID == 267 then
			if IsPlayerSpell(17877) then -- Shadowburn
				executeAutoRange.enabel = true
				executeAutoRange.range = 20
			end
		end
	elseif class == "PRIEST" then
		if IsPlayerSpell(309072) or IsPlayerSpell(32379) then -- ToF or SW:Death
			executeAutoRange.enabel = true
			executeAutoRange.range = IsPlayerSpell(309072) and 35 or 20
		end
	elseif class == "WARRIOR" then
		if specID == 72 then
			local execute_Id = (specID == 72) and 280735 or 163201
			local massacre_Id = (specID == 72) and 206315 or 281001
			if IsPlayerSpell(execute_Id) or IsPlayerSpell(massacre_Id) then -- Execute or Massacre
				executeAutoRange.enabel = true
				executeAutoRange.range = IsPlayerSpell(massacre_Id) and 35 or 20
			end
		elseif specID == 73 then
			if IsPlayerSpell(163201) then -- Execute
				executeAutoRange.enabel = true
				executeAutoRange.range = 20
			end
		end
	elseif class == "HUNTER" then
		if IsPlayerSpell(273887) or ((specID == 255) and IsPlayerSpell(385718)) then
			-- Killer Instinct or Ruthless marauder
			executeAutoRange.enabel = true
			executeAutoRange.range = 35
		else
			-- Since Survival has it's own spellId for kill shot
			local killShot_Id = (specID == 255) and 320976 or 53351
			if IsPlayerSpell(killShot_Id) then -- Kill shot
				executeAutoRange.enabel = true
				executeAutoRange.range = 20
			end
		end
	elseif class == "ROGUE" then
		if specID == 259 then
			if IsPlayerSpell(328085) or IsPlayerSpell(381798) then -- Blindside or Zoldyck
				executeAutoRange.enabel = true
				executeAutoRange.range = 35
			end
		end
	elseif class == "PALADIN" then
		if IsPlayerSpell(24275) then -- Hammer of Wrath
			executeAutoRange.enabel = true
			executeAutoRange.range = 20
		end
	elseif class == "MONK" then
		if IsPlayerSpell(322109) and IsPlayerSpell(322113) then -- ToD
			executeAutoRange.enabel = true
			executeAutoRange.range = 15
		end
	elseif class == "DEATHKNIGHT" then
		if IsPlayerSpell(343294) then -- Soulreaper
			executeAutoRange.enabel = true
			executeAutoRange.range = 35
		end
	end
end

local function executeMarker(unit, percent)
	local health = unit.Health
	local db = E.db.mMT.nameplate.executemarker

	if not health.executeMarker then
		health.executeMarker = health:CreateTexture(nil, "overlay", nil, 2)
		health.executeMarker:SetColorTexture(1, 1, 1)
	end

	local range = nil

	if db.auto and executeAutoRange.enabel then
		range = executeAutoRange.range
	elseif not db.auto then
		range = db.range
	end

	if range then
		if percent > range then
			local overlaySize = health:GetWidth() * range / 100
			health.executeMarker:SetSize(2, health:GetHeight())
			health.executeMarker:SetPoint("left", health, "left", overlaySize, 0)
			health.executeMarker:SetVertexColor(db.indicator.r, db.indicator.g, db.indicator.b)
			health.executeMarker:Show()
		else
			health.executeMarker:Hide()
		end
	else
		health.executeMarker:Hide()
	end
end

local function healthMarkers(unit, percent)
	local inInstance, instanceType = IsInInstance()
	local health = unit.Health
	if
		E.db.mMT.nameplate.healthmarker.inInstance
		and not (inInstance and instanceType == "party" or instanceType == "raid")
	then
		if health.healthMarker then
			health.healthMarker:Hide()
			health.healthOverlay:Hide()
		end
	end

	local npcID = tonumber(unit.npcID)

	local db = E.db.mMT.nameplate.healthmarker
	if not npcID and health.healthMarker then
		health.healthMarker:Hide()
		health.healthOverlay:Hide()
	else
		local markersTable = nil
		if db.useDefaults then
			markersTable = db.NPCs[npcID] or HM_NPCs[npcID]
		else
			markersTable = db.NPCs[npcID]
		end

		local texture = LSM:Fetch("statusbar", db.overlaytexture)

		if markersTable then
			for _, p in ipairs(markersTable) do
				if percent > p and p > 0 and p < 100 then
					local overlaySize = health:GetWidth() * p / 100

					if not health.healthMarker then
						health.healthMarker = health:CreateTexture(nil, "overlay", nil, 1)
						health.healthMarker:SetColorTexture(1, 1, 1)
						health.healthOverlay = health:CreateTexture(texture, "overlay", nil, 1)
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
				if health.healthMarker then
					health.healthMarker:Hide()
					health.healthOverlay:Hide()
				end
			end
		elseif health.healthMarker then
			health.healthMarker:Hide()
			health.healthOverlay:Hide()
		end
	end
end

local function mNameplateTools(table, event, frame)
	if table.isNamePlate and (table.Health and table.Health.max) then --and executeAutoRange.enabel
		local percent = math.floor((table.Health.cur or 100) / table.Health.max * 100 + 0.5)

		if E.db.mMT.nameplate.healthmarker.enable then
			healthMarkers(table, percent)
		end

		if E.db.mMT.nameplate.executemarker.enable then
			executeMarker(table, percent)
		end
	end
end

function mMT:StartNameplateTools()
	if E.db.mMT.nameplate.executemarker.auto then
		mMT:updateAutoRange()
	end

	hooksecurefunc(NP, "Health_UpdateColor", mNameplateTools)
end
