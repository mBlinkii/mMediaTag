local E = unpack(ElvUI)

local NP = E:GetModule("NamePlates")
local LSM = LibStub("LibSharedMedia-3.0")

local HM_NPCs = {
	-- DF Dungeons
	-- Algeth'ar Academy
	[191736] = { 75, 45 }, --Crawth

	-- Brackenhide Hollow
	[186125] = { 15 }, --Tricktotem
	[186122] = { 15 }, --Rira Hackclaw
	[186124] = { 15 }, --Gashtooth
	[186121] = { 4 }, -- Decatriarch Wratheye
	[185534] = { 15 }, --Bonebolt Hunter
	[185508] = { 15 }, --Claw Fighter
	[186206] = { 15 }, --Cruel Bonecrusher
	[185528] = { 15 }, --Trickclaw Mystic
	[189719] = { 15 }, --Watcher Irideus

	-- Halls of Infusion
	[190407] = { 20 }, --Aqua Rager

	-- Neltharus
	[194816] = { 10 }, -- Forgewrought Monstrosity

	-- Ruby Life pools
	[190485] = { 50 }, --Stormvein
	[190484] = { 50 }, --Kyrakka
	[193435] = { 50 }, --Kyrakka
	[188252] = { 66, 33 }, --Melidrussa Chillworn
	[197697] = { 50 }, -- Flamegullet

	-- The Azure Vault
	[186738] = { 75, 50, 25 }, --Umbrelskul

	-- The Nokhud Offensive
	[186151] = { 60 }, --Balakar Khan

	-- Uldaman: Legacy of Tyr
	[184020] = { 40 }, -- Hulking Berserker
	[184580] = { 10 }, -- Olaf
	[184581] = { 10 }, -- Baelog
	[184582] = { 10 }, -- Eric "The Swift"
	[184422] = { 70, 30 }, --Emberon

	-- SL Dungeons
	-- De Other Side
	[164558] = { 80, 60, 40, 20 }, --Hakkar the Soulflayer

	-- Halls of Atonemen
	[164218] = { 70, 40 }, --Lord Chamberlain

	-- Mists of Tirna Scithe
	[164501] = { 70, 40, 10 }, --Mistcaller
	[164926] = { 50 }, --Drust Boughbreaker
	[164804] = { 22 }, -- Droman Oulfarran

	-- Plaguefall
	[164267] = { 66, 33 }, --Magrave Stradama
	[164967] = { 66, 33 }, --Doctor ickus
	[169861] = { 66, 33 }, -- Ickor Bileflesh

	-- Sanguine Depths
	[162099] = { 50 }, --General Kaal Boss fight

	-- Spires of Ascension
	[162061] = { 70, 30 }, --Devos

	-- Tazavesh
	[177269] = { 40 }, --So'leah (Gambit)
	[175806] = { 66, 33 }, --So'azmi (Streets)

	-- The Necrotic Wake
	[163121] = { 70 }, -- Stitched vanguard

	-- Theater of Pain
	[164451] = { 40 }, --Dessia the Decapirator
	[164463] = { 40 }, --Paceran the Virulent
	[164461] = { 40 }, --Sathel the Accursed
	[165946] = { 50 }, --Mordretha

	-- BFA Dungeons

	-- Freehold
	[126983] = { 60, 30 }, -- Harlan Sweete
	[126832] = { 75 }, --Skycap'n Kragg

	-- Operation: Mechagon
	[150276] = { 50 }, --Heavy Scrapbots (Junk)
	[152009] = { 30 }, --Malfunctioning Scrapbots (Junk)
	[144298] = { 30 }, --Defense Bot Mk III (Workshop)

	--The MOTHERLODE!!
	[133345] = { 20 }, --Feckless Assistant

	--The Underrot
	[133007] = { 85, 68, 51, 34, 17 }, --Unbound Abomination

	-- Draenor Dungeons
	-- Grimrail Depot
	[81236] = { 50 }, -- Grimrail Technician
	[79545] = { 60 }, -- Nitrogg Thundertower
	[77803] = { 20 }, -- Railmaster Rocketspark

	-- Iron Docks
	[81297] = { 50 }, -- Dreadfang -> Fleshrender Nok'gar

	-- Shadowmoon Burial Grounds
	[76057] = { 20 }, -- Carrion Worm

	-- Legion Dungeons
	-- Court of Stars
	[104215] = { 25 }, -- Patrol Captain Gerdo

	-- Return to Karazhan (Lower)
	[114261] = { 50 }, --Toe Knee
	[114260] = { 50 }, -- Mrrgria
	[114265] = { 50 }, --Gang Ruffian
	[114783] = { 50 }, --Reformed Maiden
	[114312] = { 60 }, -- Moroes

	-- Return to Karazhan (Upper)
	[114790] = { 66, 33 }, -- Viz'aduum

	-- Halls of Valor
	[96574] = { 30 }, --Stormforged Sentinel
	[97087] = { 30 }, --Valarjar Champion
	[95674] = { 60 }, -- Fenryr P1
	[94960] = { 10 }, -- Hymdall
	[95676] = { 80 }, --Odyn

	-- Neltharion's Lair
	[91005] = { 20 }, -- Naraxas
	[113537] = { 15 }, -- Emberhusk Dominator

	-- Pandaria Dungeons
	-- Temple of The Jade Serpent
	[59544] = { 50 }, --The Nodding Tiger
	[56732] = { 70, 30 }, -- Liu Flameheart

	-- DF Raid
	[194990] = { 50 }, -- Stormseeker Acolyte, Vault
	[189492] = { 65 }, -- Raszageth, Vault
	[201261] = { 80, 60, 40 }, -- Kazzara, Aberrus
	[201773] = { 50 }, -- Chamber: Eternal Blaze, Aberrus
	[201774] = { 50 }, -- Chamber: Essence of Shadow, Aberrus
	[199659] = { 25 }, -- Assault:Warlord Kagni, Aberrus

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

	-- Kortia (SL)
	[180013] = { 20 }, --Escaped Wilderling, Shadowlands - Korthia
	[179931] = { 80, 60 }, --Relic Breaker krelva, Shadowlands - Korthia

	--Dragon Isles (DF)
	[193532] = { 40 }, --Bazual, The Dreaded Flame - WordBoss

	--Mage Tower
	[116410] = { 33 }, -- Karam Magespear
}

local executeAutoRange = { enable = false, range = 30 }

function mMT:updateAutoRange()
	executeAutoRange.enable = false
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
				executeAutoRange.enable = true
				executeAutoRange.range = 35
			end
		elseif specID == 63 then
			if IsPlayerSpell(269644) then -- Touch
				executeAutoRange.enable = true
				executeAutoRange.range = 30
			end
		end
	elseif class == "WARLOCK" then
		if specID == 265 then
			if IsPlayerSpell(198590) then -- Souldrain
				executeAutoRange.enable = true
				executeAutoRange.range = 20
			end
		elseif specID == 267 then
			if IsPlayerSpell(17877) then -- Shadowburn
				executeAutoRange.enable = true
				executeAutoRange.range = 20
			end
		end
	elseif class == "PRIEST" then
		if IsPlayerSpell(309072) or IsPlayerSpell(32379) then -- ToF or SW:Death
			executeAutoRange.enable = true
			executeAutoRange.range = IsPlayerSpell(309072) and 35 or 20
		end
	elseif class == "WARRIOR" then
		if specID == 72 then
			local execute_Id = (specID == 72) and 280735 or 163201
			local massacre_Id = (specID == 72) and 206315 or 281001
			if IsPlayerSpell(execute_Id) or IsPlayerSpell(massacre_Id) then -- Execute or Massacre
				executeAutoRange.enable = true
				executeAutoRange.range = IsPlayerSpell(massacre_Id) and 35 or 20
			end
		elseif specID == 73 then
			if IsPlayerSpell(163201) then -- Execute
				executeAutoRange.enable = true
				executeAutoRange.range = 20
			end
		end
	elseif class == "HUNTER" then
		if IsPlayerSpell(273887) or ((specID == 255) and IsPlayerSpell(385718)) then
			-- Killer Instinct or Ruthless marauder
			executeAutoRange.enable = true
			executeAutoRange.range = 35
		else
			-- Since Survival has it's own spellId for kill shot
			local killShot_Id = (specID == 255) and 320976 or 53351
			if IsPlayerSpell(killShot_Id) then -- Kill shot
				executeAutoRange.enable = true
				executeAutoRange.range = 20
			end
		end
	elseif class == "ROGUE" then
		if specID == 259 then
			if IsPlayerSpell(328085) or IsPlayerSpell(381798) then -- Blindside or Zoldyck
				executeAutoRange.enable = true
				executeAutoRange.range = 35
			end
		end
	elseif class == "PALADIN" then
		if IsPlayerSpell(24275) then -- Hammer of Wrath
			executeAutoRange.enable = true
			executeAutoRange.range = 20
		end
	elseif class == "MONK" then
		if IsPlayerSpell(322109) and IsPlayerSpell(322113) then -- ToD
			executeAutoRange.enable = true
			executeAutoRange.range = 15
		end
	elseif class == "DEATHKNIGHT" then
		if IsPlayerSpell(343294) then -- Soulreaper
			executeAutoRange.enable = true
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
	local inCombat = InCombatLockdown()

	if db.auto and executeAutoRange.enable then
		range = executeAutoRange.range
	elseif not db.auto then
		range = db.range
	end

	if range and inCombat then
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
	if table.isNamePlate and (table.Health and table.Health.max) then --and executeAutoRange.enable
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
