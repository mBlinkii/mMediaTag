local E = unpack(ElvUI)

local NP = E:GetModule("NamePlates")
local LSM = LibStub("LibSharedMedia-3.0")

local HM_NPCs = {
	-------- TWW Dungeons --------
	-- Ara-Kara, City of Echoes
	[214840] = { 30 }, -- Engorged Crawler

	-- Cinderbrew Meadery
	[210265] = { 20 }, -- Worker Bee
	[223497] = { 20 }, -- Worker Bee
	[210271] = { 66, 33 }, -- Brew Master Aldryr

	-- City of Threads
	[219984] = { 50 }, -- Xeph'itik <Expert Perfumer>

	-- Darkflame Cleft
	[208747] = { 55 }, -- The Darkness
	[210818] = { 50 }, -- Lowly Moleherd

	-- The Dawnbreaker
	[211087] = { 50 }, -- Speaker Shadowcrown
	[213885] = { 75, 50, 25 }, -- Nightfall Dark Architect
	[213937] = { 65, 60 }, -- Rasha'nan

	-- Priory of the Sacred Flame
	[206710] = { 25 }, -- Lightspawn
	[207940] = { 50 }, -- Prioress Murrpray

	-- Delves
	[210478] = { 50 }, -- Infected Beast
	[214625] = { 30 }, -- Kobyss Necromancer
	[220130] = { 70, 40 }, -- Speaker Xanventh
	[220710] = { 30 }, -- Leviathan Manipulator
	[220738] = { 75, 50, 25 }, -- Leviathan Caller

	-------- TWW Raids --------

	-- Nerub-ar Palace
	[219778] = { 35 }, -- Queen Ansurek
	[222564] = { 80, 60, 40, 20 }, -- Rupturing Ooze

	-- Liberation of Undermine
	[229953] = { 40 }, -- Mug'Zee
	[230316] = { 80 }, -- Mk II Electro Shocker
	[231531] = { 75 }, -- Territorial Bombshell
	[241526] = { 50 }, -- Chrome King Gallywix

	-------- DF Dungeons --------
	-- Azure Vault
	[186738] = { 75, 50, 25 }, -- Umbrelskul

	-- Brackenhide Hollow
	[185508] = { 15 }, --Claw Fighter
	[185528] = { 15 }, --Trickclaw Mystic
	[185534] = { 15 }, --Bonebolt Hunter
	[186121] = { 4 }, -- Decatriarch Wratheye
	[186122] = { 15 }, --Rira Hackclaw
	[186124] = { 15 }, --Gashtooth
	[186125] = { 15 }, --Tricktotem
	[186206] = { 15 }, --Cruel Bonecrusher
	[186227] = { 20 }, --Monstrous Decay

	-- Dawn of the Infinite
	[198933] = { 90 }, --Iridikron
	[198997] = { 80, 50 }, -- Blight of Galakrond / Ahnzon
	[199000] = { 20, 8 }, -- Deios
	[201792] = { 80, 50 }, -- Ahnzon
	[207638] = { 80, 50 }, -- Blight of Galakrond / Ahnzon
	[207639] = { 80, 50 }, -- Blight of Galakrond / Ahnzon
	[209892] = { 20, 8 }, -- Deios

	--Algeth'ar Academy
	[191736] = { 75, 45 }, --Crawth

	-- Halls of Infusion
	[189719] = { 15 }, -- Watcher Irideus
	[190368] = { 40 }, -- Flamecaller Aymi
	[190407] = { 20 }, -- Aqua Rager
	[189729] = { 60 }, -- Primal Tsunami

	-- Neltharus
	[194816] = { 10 }, -- Forgewrought Monstrosity

	-- Nokhud Offensive
	[186151] = { 60 }, -- Balakar Khan

	-- Ruby Life Pools
	[188252] = { 66, 33 }, --Melidrussa Chillworn
	[190484] = { 50 }, --Kyrakka
	[190485] = { 50 }, --Stormvein
	[193435] = { 50 }, --Kyrakka
	[197697] = { 50 }, -- Flamegullet

	-- Uldaman
	[184020] = { 40 }, -- Hulking Berserker
	[184422] = { 70, 30 }, -- Emberon
	[184580] = { 10 }, -- Olaf
	[184581] = { 10 }, -- Baelog
	[184582] = { 10 }, -- Eric "The Swift"

	-------- SL Dungeons --------
	-- De Other Side
	[164558] = { 80, 60, 40, 20 }, -- Hakkar the Soulflayer

	-- Halls of Atonement
	[164218] = { 70, 40 }, -- Lord Chamberlain

	-- Mists of Tirna Scithe
	[164501] = { 70, 40, 10 }, -- Mistcaller
	[164804] = { 22 }, -- Droman Oulfarran
	[164926] = { 50 }, -- Drust Boughbreaker

	-- Necrotic Wake
	[163121] = { 70 }, -- Stitched Vanguard

	-- Plaguefall
	[164267] = { 66, 33 }, -- Magrave Stradama
	[164967] = { 66, 33 }, -- Doctor Ickus
	[169861] = { 66, 33 }, -- Ickor Bileflesh

	-- Sanguine Depths
	[162099] = { 50 }, -- General Kaal

	-- Spires of Ascension
	[162061] = { 70, 30 }, --Devos

	-- Tazavesh
	[177269] = { 40 }, -- So'leah
	[175806] = { 66, 33 }, -- So'azmi

	-- Theater of Pain
	[164451] = { 40 }, -- Dessia the Decapirator
	[164461] = { 40 }, -- Sathel the Accursed
	[164463] = { 40 }, -- Paceran the Virulent
	[165946] = { 50 }, -- Mordretha

	-------- BFA Dungeons --------

	-- Freehold
	[126832] = { 75 }, -- Skycap'n Kragg
	[126983] = { 60, 30 }, -- Harlan Sweete
	[129699] = { 90, 70, 50, 30 }, -- Ludwig von Tortollan

	-- The MOTHERLODE!!
	[129232] = { 50 }, -- Mogul Razdunk
	[130488] = { 45 }, -- Mech Jockey
	[130653] = { 10 }, -- Wanton Sapper
	[133345] = { 20 }, -- Feckless Assistant

	-- Operation: Mechagon - Workshop
	[144298] = { 30 }, -- Defense Bot Mk III

	-- Siege of Boralus
	[128650] = { 75, 50, 33 }, -- Chopper Redhook
	[129208] = { 66, 33 }, -- Dread Captain Lockwood
	-- [133990] = {10}, -- Scrimshaw Gutter
	[135241] = { 30 }, -- Bilge Rat Pillager
	[135263] = { 30 }, -- Ashvane Spotter
	-- [138002] = {10}, -- Scrimshaw Gutter
	[138255] = { 30 }, -- Ashvane Spotter
	[141939] = { 30 }, -- Ashvane Spotter

	-- Waycrest Manor
	[131527] = { 30 }, -- Lord Waycrest
	[131823] = { 50 }, -- Sister Malady
	[131824] = { 50 }, -- Sister Solena
	[131825] = { 50 }, -- Sister Briar

	-------- WoD Dungeons --------
	-- Grimrail Depot
	[77803] = { 20 }, -- Railmaster Rocketspark
	[79545] = { 60 }, -- Nitrogg Thundertower
	[81236] = { 50 }, -- Grimrail Technician

	-- Iron Docks
	[81297] = { 50 }, -- Dreadfang

	-- Shadowmoon Burial Grounds
	[76057] = { 20 }, -- Carrion Worm

	-------- Legion Dungeons --------
	-- Blackrook Hold
	[98542] = { 50 }, -- Amalgam of Souls
	[98792] = { 65 }, -- Wyrmtongue Scavenger
	[98810] = { 25 }, -- Wrathguard Bladelord
	[98965] = { 20 }, -- Kur'talos Ravencrest

	-- Court of Stars
	[104215] = { 25 }, -- Patrol Captain Gerdo

	-- Darkheart Thicket
	[99192] = { 50 }, -- Shade of Xavius

	-- Halls of Valor
	[94960] = { 10 }, -- Hymdall
	[95674] = { 60 }, -- Fenryr
	[95676] = { 80 }, -- Odyn
	[96574] = { 30 }, -- Stormforged Sentinel
	[97087] = { 30 }, -- Valarjar Champion

	-- Neltharion's Lair
	[91005] = { 20 }, -- Naraxas
	[113537] = { 15 }, -- Emberhusk Dominator

	-------- MoP Dungeons --------
	-- Temple of the Jade Serpent
	[56732] = { 70, 30 }, -- Liu Flameheart
	[59544] = { 50 }, -- The Nodding Tiger

	-------- Cata Dungeons --------
	-- Throne of the Tides
	[40586] = { 60, 30 }, -- Lady Naz'jar
	[40825] = { 25 }, -- Erunak Stonespeaker

	-- Grim Batol
	[40320] = { 50 }, -- Valiona
	[224249] = { 50 }, -- Twilight Lavabender

	-------- DF Raids --------
	-- Vault of the Incarnates
	[187967] = { 5 }, -- Sennarth
	[189492] = { 65 }, -- Raszageth
	[194990] = { 50 }, -- Stormseeker Acolyte

	-- Aberrus, the Shadowed Crucible
	[199659] = { 25 }, -- Warlord Kagni
	[200912] = { 50 }, -- Neldris
	[200913] = { 50 }, -- Thadrion
	[201261] = { 80, 60, 40 }, -- Kazzara
	[201668] = { 60, 35 }, -- Neltharion
	[201773] = { 50 }, -- Eternal Blaze
	[201774] = { 50 }, -- Essence of Shadow
	[203230] = { 50 }, -- Dragonfire Golem

	-- Amirdrassil
	[208445] = { 35 }, -- Larodar
	[209090] = { 75, 50 }, -- Tindral

	-------- Open World --------
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
	if not (spec or class or specID) or specID == 0 then return end

	if class == "MAGE" then
		if specID == 62 then
			if IsPlayerSpell(384581) then -- Arcane pressure
				executeAutoRange.enable = true
				executeAutoRange.range = 35
				executeAutoRange.spell = 384581
			end
		elseif specID == 63 then
			if IsPlayerSpell(2948) then -- Touch
				executeAutoRange.enable = true
				executeAutoRange.range = 30
			end
		end
	elseif class == "WARLOCK" then
		if specID == 265 then
			if IsPlayerSpell(388667) then -- Souldrain
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
		if IsPlayerSpell(32379) then -- ToF or SW:Death
			executeAutoRange.enable = true
			executeAutoRange.range = 20
		end
	elseif class == "WARRIOR" then
		local execute = ((specID == 71) and 281000) or ((specID == 72) and 5308) or 163201
		local massacre = (specID == 72) and 206315 or 281001
		if IsPlayerSpell(execute) or IsPlayerSpell(massacre) then -- Execute or Massacre
			executeAutoRange.enable = true
			executeAutoRange.range = IsPlayerSpell(massacre) and 35 or 20
		end
	elseif class == "HUNTER" then
		if (specID == 255) and IsPlayerSpell(203415) then -- fury of eagle
			executeAutoRange.enable = true
			executeAutoRange.range = IsPlayerSpell(385718) and 35 or 20 -- Ruthless marauder
		elseif (specID == 254) and IsPlayerSpell(204989) then -- Bull's eye
			executeAutoRange.enable = true
			executeAutoRange.range = 20
		else
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
		if IsPlayerSpell(322109) then -- ToD
			executeAutoRange.enable = true
			executeAutoRange.range = 15
			executeAutoRange.monk = not IsPlayerSpell(322113)
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
		if executeAutoRange.monk then
			local playerHealth = UnitHealthMax("player")
			local unitHealth = unit.Health.max

			if executeAutoRange.monk and unitHealth > playerHealth then
				if playerHealth and unitHealth then
					range = (100 / unitHealth) * playerHealth
				else
					range = executeAutoRange.range
				end
			end
		else
			range = executeAutoRange.range
		end
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
	if E.db.mMT.nameplate.healthmarker.inInstance and not (inInstance and instanceType == "party" or instanceType == "raid") then
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
		if E.Retail and db.useDefaults then
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
	if table.isNamePlate and (table.Health and table.Health.max) then
		local percent = math.floor((table.Health.cur or 100) / table.Health.max * 100 + 0.5)

		if E.db.mMT.nameplate.healthmarker.enable then healthMarkers(table, percent) end

		if E.Retail and E.db.mMT.nameplate.executemarker.enable then executeMarker(table, percent) end
	end
end

function mMT:StartNameplateTools()
	hooksecurefunc(NP, "Health_UpdateColor", mNameplateTools)
end
