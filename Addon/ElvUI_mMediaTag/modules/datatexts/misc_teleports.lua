local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local C_ToyBox = C_ToyBox
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetItemCooldown = C_Item and C_Item.GetItemCooldown or GetItemCooldown
local GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount
local GetItemIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local IsToyUsable = C_ToyBox.IsToyUsable
local GetProfessionInfo = GetProfessionInfo
local GetProfessions = GetProfessions
local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture
local GetTime = GetTime
local IsSpellKnown = IsSpellKnown
local PlayerHasToy = PlayerHasToy
local format = format
local math = math
local pairs = pairs
local select = select
local string = string
local tinsert = tinsert
local wipe = wipe

-- Variables
local valueString = ""
local textString = ""

local menuFrames = {}
local knownTeleports = {
	favorites = {},
	toys = {},
	dungeons = {},
	season = {},
	tww = {},
}
local teleports = {
	favorites = {},
	toys = {
		[110560] = "toy", --garrison-hearthstone
		[140192] = "toy", --dalaran-hearthstone
		[140324] = "toy", -- Mobile Telemancy Beacon
		[142542] = "toy", -- Tome of Town Portal
		[162973] = "toy", --greatfather-winters-hearthstone
		[163045] = "toy", --headless-horsemans-hearthstone
		[165669] = "toy", --lunar-elders-hearthstone
		[165670] = "toy", --peddlefeets-lovely-hearthstone
		[165802] = "toy", --noble-gardeners-hearthstone
		[166746] = "toy", --fire-eaters-hearthstone
		[166747] = "toy", --brewfest-revelers-hearthstone
		[168907] = "toy", --holographic-digitalization-hearthstone
		[172179] = "toy", --eternal-travelers-hearthstone
		[180290] = "toy", --night-fae-hearthstone
		[182773] = "toy", --necrolord-hearthstone
		[183716] = "toy", -- Venthyr Sinstone
		[184353] = "toy", --kyrian-hearthstone
		[188952] = "toy", --dominated-hearthstone
		[190196] = "toy", --enlightened-hearthstone
		[190237] = "toy", -- Broker Translocation Matrix
		[193588] = "toy", --Timewalker's Hearthstone
		[200630] = "toy", --ohnir-windsages-hearthstone
		[206195] = "toy", -- Path of the Naaru
		[208704] = "toy", -- Deepdweller's Earthen Hearthstone
		[209035] = "toy", -- hearthstone-of-the-flame
		[210455] = "toy", -- Draenic Hologem
		[211788] = "toy", -- Tess's Peacebloom
		[212337] = "toy", -- Stone of the Hearth (Hearthstone 10th Anniversary)
		[43824] = "toy", -- The Schools of Arcane Magic - Mastery
		[54452] = "toy", -- Ethereal Portal
		[64488] = "toy", -- The Innkeeper's Daughter
		[6948] = "toy", -- Hearthstone
		[93672] = "toy", -- Dark Portal (Retail)
		[95567] = "toy", -- Kirin Tor Beacon
		[95568] = "toy", -- Sunreaver Beacon
	},
	engineering = {
		[87215] = "toy", --wormhole-generator-pandaria
		[48933] = "toy", --wormhole-generator-northrend
		[198156] = "toy", -- Wyrmhole Generator
		[172924] = "toy", --wormhole-generator-shadowlands
		[168808] = "toy", --wormhole-generator-zandalar
		[168807] = "toy", --wormhole-generator-kultiras
		[151652] = "toy", --wormhole-generator-argus
		[112059] = "toy", --wormhole-centrifuge
		[30542] = "toy", --Dimensional Ripper - Area
		[30544] = "toy", --Ultrasafe Transporter: Toshley's Station
		[18986] = "toy", --Ultrasafe Transporter: Gadgetzan
		[18984] = "toy", --Dimensional Ripper - Everlook
		[221966] = "toy", --wormhole-generator-khaz-algar
	},
	items = {
		[103678] = "item", --time-lost-artifact
		[118662] = "item", -- Bladespire Relic
		[118663] = "item", --relic-of-karabor
		[118907] = "item", --pit-fighters-punching-ring
		[118908] = "item", --pit-fighters-punching-ring
		[119183] = "item", --scroll-of-risky-recall
		[128353] = "item", --admirals-compass
		[128502] = "item", --hunters-seeking-crystal
		[129276] = "item", --beginners-guide-to-dimensional-rifting
		[129929] = "item", -- Admiral's Compass
		[138448] = "item", --emblem-of-margoss
		[139590] = "item", --scroll-of-teleport-ravenholdt
		[139599] = "item", --empowered-ring-of-the-kirin-tor
		[140493] = "item", -- Adepts's Guide to Dimensional Rifting
		[141013] = "item", --scroll-of-town-portal-shalanir
		[141014] = "item", --scroll-of-town-portal-sashjtar
		[141015] = "item", --scroll-of-town-portal-kaldelar
		[141016] = "item", --scroll-of-town-portal-faronaar
		[141017] = "item", --scroll-of-town-portal-liantril
		[141605] = "item", --flight-masters-whistle
		[142298] = "item", --astonishingly-scarlet-slippers
		[142469] = "item", --violet-seal-of-the-grand-magus
		[142543] = "item", --scroll-of-town-portal
		[144391] = "item", --pugilists-powerful-punching-ring
		[144392] = "item", -- Pugilist's Powerful Punching Ring (Horde)
		[151016] = "item", --fractured-necrolyte-skull
		[166559] = "item", -- Commander's Signet of Battle
		[166560] = "item", -- Captain's Signet of Command
		[167075] = "item", -- Ultrasafe Transporter: Mechagon
		[168862] = "item", -- G.E.A.R. Tracking Beacon
		[17690] = "item", --frostwolf-insignia-rank-1
		[17691] = "item", --stormpike-insignia-rank-1
		[17900] = "item", --stormpike-insignia-rank-2
		[17901] = "item", --stormpike-insignia-rank-3
		[17902] = "item", --stormpike-insignia-rank-4
		[17903] = "item", --stormpike-insignia-rank-5
		[17904] = "item", --stormpike-insignia-rank-6
		[17905] = "item", --frostwolf-insignia-rank-2
		[17906] = "item", --frostwolf-insignia-rank-3
		[17907] = "item", --frostwolf-insignia-rank-4
		[17908] = "item", --frostwolf-insignia-rank-5
		[17909] = "item", --frostwolf-insignia-rank-6
		[180817] = "item", --cypher-of-relocation
		[184871] = "item", --dark-portal 2?
		[18984] = "item", --dimensional-ripper-everlook
		[18986] = "item", --ultrasafe-transporter-gadgetzan
		[193000] = "item", -- Ring-Bound Hourglass
		[219222] = "item", --Time-Lost Artifact
		[22589] = "item", --atiesh-greatstaff-of-the-guardian
		[22630] = "item", --atiesh-greatstaff-of-the-guardian
		[22631] = "item", --atiesh-greatstaff-of-the-guardian
		[22632] = "item", --atiesh-greatstaff-of-the-guardian
		[28585] = "item", --ruby-slippers
		[29796] = "item", --socrethars-teleportation-stone
		[30542] = "item", --dimensional-ripper-area-52
		[30544] = "item", --ultrasafe-transporter-toshleys-station
		[32757] = "item", --blessed-medallion-of-karabor
		[35230] = "item", --darnarians-scroll-of-teleportation
		[37118] = "item", --scroll-of-recall
		[37863] = "item", --direbrews-remote
		[40585] = "item", --signet-of-the-kirin-tor
		[40586] = "item", --band-of-the-kirin-tor
		[43824] = "item", --the-schools-of-arcane-magic-mastery
		[44314] = "item", --scroll-of-recall-ii
		[44315] = "item", --scroll-of-recall-iii
		[44934] = "item", --loop-of-the-kirin-tor
		[44935] = "item", --ring-of-the-kirin-tor
		[45688] = "item", --inscribed-band-of-the-kirin-tor
		[45689] = "item", --inscribed-loop-of-the-kirin-tor
		[45690] = "item", --inscribed-ring-of-the-kirin-tor
		[45691] = "item", --inscribed-signet-of-the-kirin-tor
		[46874] = "item", --argent-crusaders-tabard
		[48954] = "item", --etched-band-of-the-kirin-tor
		[48955] = "item", --etched-loop-of-the-kirin-tor
		[48956] = "item", --etched-ring-of-the-kirin-tor
		[48957] = "item", --etched-signet-of-the-kirin-tor
		[50287] = "item", --boots-of-the-bay
		[51557] = "item", --runed-signet-of-the-kirin-tor
		[51558] = "item", --runed-loop-of-the-kirin-tor
		[51559] = "item", --runed-ring-of-the-kirin-tor
		[51560] = "item", --runed-band-of-the-kirin-tor
		[52251] = "item", --jainas-locket
		[54452] = "item", --ethereal-portal
		[58487] = "item", --potion-of-deepholm
		[61379] = "item", --gidwins-hearthstone
		[63206] = "item", --wrap-of-unity
		[63207] = "item", --wrap-of-unity
		[63352] = "item", --shroud-of-cooperation
		[63353] = "item", --shroud-of-cooperation
		[63378] = "item", --hellscreams-reach-tabard
		[63379] = "item", --baradins-wardens-tabard
		[64457] = "item", --the-last-relic-of-argus
		[65274] = "item", --cloak-of-coordination
		[65360] = "item", --cloak-of-coordination
		[68808] = "item", --heros-hearthstone
		[68809] = "item", --veterans-hearthstone
		[6948] = "item", --hearthstone
		[92510] = "item", --voljins-hearthstone
		[93672] = "item", --dark-portal
		[95050] = "item", --the-brassiest-knuckle
		[95051] = "item", --the-brassiest-knuckle
		[95567] = "item", --kirin-tor-beacon
		[95568] = "item", --sunreaver-beacon
	},
	spells = {
		[126892] = "spell", -- zen-pilgrimage
		[18960] = "spell", -- Moonglade
		[193753] = "spell", -- dreamwalk
		[193759] = "spell", -- teleport-hall-of-the-guardian
		[265225] = "spell", -- Mole Machine
		[312372] = "spell", -- Return to Camp
		[50977] = "spell", -- death-gate
		[556] = "spell", -- astral-recall
	},
	season = {
		-- S1
		[354462] = "NW", -- Necrotic Wake
		[354464] = "MIST", -- Mists of Tirna Scithe
		[445269] = "SV", -- The Stonevault
		[445414] = "DAWN", -- The Dawnbreaker
		[445416] = "CoT", -- City of Threads
		[445417] = "ARAK", -- Ara-Kara, City of Echoes
		[445418] = "SIEGE", -- Siege of Boralus - alliance
		[445424] = "GB", -- Grim Batol
		[464256] = "SIEGE", -- Siege of Boralus - horde
	},

	tww = {
		[445269] = "SV", -- The Stonevault
		[445414] = "DAWN", -- The Dawnbreaker
		[445416] = "CoT", -- City of Threads
		[445417] = "ARAK", -- Ara-Kara, City of Echoes
		[445440] = "CM", -- Cinderbrew Meadery
		[445441] = "DC", -- Darkflame Cleft
		[445443] = "ROOK", -- The Rookery
		[445444] = "PSF", -- Priory of the Sacred Flame
	},

	dungeonportals = {
		[131204] = "TJS", -- Temple of the Jade Serpent
		[131205] = "SB", -- Stormstout Brewery
		[131206] = "SPM", -- Shado-Pan Monastery
		[131222] = "MSP", -- Mogu'shan Palace
		[131225] = "GSS", -- Gate of the Setting Sun
		[131228] = "SON", -- Siege of Niuzao
		[131229] = "SM", -- Scarlet Monastery
		[131231] = "SH", -- Scarlet Halls
		[131232] = "SCH", -- Scholomance
		[159895] = "BSM", -- Bloodmaul Slag Mines
		[159896] = "ID", -- Iron Docks
		[159897] = "AUCH", -- Auchindoun
		[159898] = "SKY", -- Skyreach
		[159899] = "SBG", -- Shadowmoon Burial Grounds
		[159900] = "GD", -- Grimrail Depot
		[159901] = "EB", -- The Everbloom
		[159902] = "UBS", -- Upper Blackrock Spire
		[354462] = "NW", -- Necrotic Wake
		[354463] = "PF", -- Plaguefall
		[354464] = "MIST", -- Mists of Tirna Scithe
		[354465] = "HOA", -- Halls of Atonement
		[354466] = "SOA", -- Spires of Ascension
		[354467] = "TOP", -- Theater of Pain
		[354468] = "DOS", -- De Other Side
		[354469] = "SD", -- Sanguine Depths
		[367416] = "TVM", -- Tazavesh, the Veiled Market
		[373190] = "CN", -- Castle Nathria
		[373191] = "SOD", -- Sanctum of Domination
		[373192] = "SotFO", -- Sepulcher of the First Ones
		[373262] = "KZ", -- Karazhan
		[373274] = "MG", -- Mechagon
		[393222] = "ULD", -- Uldaman: Legacy of Tyr
		[393256] = "RLP", -- Ruby Life Pools
		[393262] = "NO", -- Nokhud Offensive
		[393267] = "BH", -- Brackenhide Hollow
		[393273] = "AA", -- Algeth'ar Academy
		[393276] = "NELT", -- Neltharus
		[393279] = "AV", -- Azure Vault
		[393283] = "HOI", -- Halls of Infusion
		[393764] = "HOV", -- Halls of Valor
		[393766] = "COS", -- Court of Stars
		[410071] = "FH", -- Freehold
		[410074] = "UNDR", -- Underrot
		[410078] = "NL", -- Neltharion's Lair
		[410080] = "VP", -- path-of-winds-domain
		[424142] = "TOT", --path-of-the-tidehunter
		[424153] = "BRH", -- Black Rook Hold
		[424163] = "DHT", -- Darkheart Thicket
		[424167] = "WM", -- Waycrest Manor
		[424187] = "AD", -- Atal'Dazar
		[424197] = "DOI", -- Dawn of the Infinite
		[445269] = "SV", -- The Stonevault
		[445414] = "DAWN", -- The Dawnbreaker
		[445416] = "CoT", -- City of Threads
		[445417] = "ARAK", -- Ara-Kara, City of Echoes
		[445418] = "SIEGE", -- Siege of Boralus - alliance
		[445424] = "GB", -- Grim Batol
		[445440] = "CM", -- Cinderbrew Meadery
		[445441] = "DC", -- Darkflame Cleft
		[445443] = "ROOK", -- The Rookery
		[445444] = "PSF", -- Priory of the Sacred Flame
		[464256] = "SIEGE", -- Siege of Boralus - horde
	},
}

local function LeaveFunc(btn)
	GameTooltip:Hide()
end

local function MenuAdd(tbl, text, time, macro, icon, tooltip, funcOnEnter)
	tinsert(tbl, {
		text = text,
		SecondText = time,
		icon = icon,
		isTitle = false,
		tooltip = tooltip,
		macro = macro,
		funcOnEnter = funcOnEnter,
		funcOnLeave = LeaveFunc,
	})
end
local function getAnchorPoint(point)
	local anchor = "ANCHOR_CURSOR"
	if not E.db.mMT.datatexts.anchorCursor and point then
		local left = point and strfind(point, "LEFT")
		anchor = left and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
	end
	return anchor
end

local function OnEnterItem(btn)
	GameTooltip:SetOwner(btn, getAnchorPoint(menuFrame.pointB))
	GameTooltip:ClearLines()
	GameTooltip:SetItemByID(btn.tooltip)
	GameTooltip:Show()
end

local function OnEnterSpell(btn)
	GameTooltip:SetOwner(btn, getAnchorPoint(menuFrame.pointB))
	GameTooltip:ClearLines()
	GameTooltip:SetSpellByID(btn.tooltip)
	GameTooltip:Show()
end

local function GetInfos(TeleportsTable, spell, toy, tip, check)
	for i, v in pairs(TeleportsTable.tps) do
		local texture, name, hasSpell, hasItem = nil, nil, false, 0
		if spell then
			local spellInfo = GetSpellInfo(i)
			texture = GetSpellTexture(i)
			name = spellInfo.name
			hasSpell = IsSpellKnown(i)
		else
			texture = GetItemIcon(i)
			name = GetItemInfo(i)
			hasItem = GetItemCount(i)
		end

		local text1, text2 = nil, nil
		if (texture and name and (hasItem > 0 or (E.Retail and PlayerHasToy(i) and C_ToyBox.IsToyUsable(i)))) or (texture and name and hasSpell) then
			if check then
				TeleportsTable.available = true
			else
				local start, duration = nil, nil

				if spell then
					local spellCooldownInfo = GetSpellCooldown(i)
					start = spellCooldownInfo.startTime
					duration = spellCooldownInfo.duration
				else
					start, duration = GetItemCooldown(i)
				end

				local cooldown = start + duration - GetTime()

				if cooldown >= 2 then
					local hours = math.floor(cooldown / 3600)
					local minutes = math.floor(cooldown / 60)
					local seconds = string.format("%02.f", math.floor(cooldown - minutes * 60))
					if hours >= 1 then
						minutes = math.floor(mod(cooldown, 3600) / 60)
						text1 = "|CFFDB3030" .. name .. "|r"
						text2 = "|CFFDB3030" .. hours .. "h " .. minutes .. "m|r"
					else
						text1 = "|CFFDB3030" .. name .. "|r"
						text2 = "|CFFDB3030" .. minutes .. "m " .. seconds .. "s|r"
					end
				elseif cooldown <= 0 then
					text1 = "|CFFFFFFFF" .. name .. "|r"
					text2 = "|CFF00FF00" .. L["Ready"] .. "|r"
				end

				if text1 and text2 then
					if type(v) == "string" then text1 = "[|CFF00AAFF" .. v .. "|r] " .. text1 end

					if tip then
						DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", texture, text1), text2)
					elseif spell then
						MenuAdd(Teleports.menu, text1, text2, "/cast " .. name, texture, i, function(btn)
							OnEnterSpell(btn)
						end)
					elseif toy then
						MenuAdd(Teleports.menu, text1, text2, "/usetoy " .. name, texture, i, function(btn)
							OnEnterItem(btn)
						end)
					else
						MenuAdd(Teleports.menu, text1, text2, "/use " .. name, texture, i, function(btn)
							OnEnterItem(btn)
						end)
					end
				end
			end
		end
	end
end

local function EngineeringCheck()
	local prof1, prof2 = GetProfessions()
	if prof1 then prof1 = select(7, GetProfessionInfo(prof1)) end

	if prof2 then prof2 = select(7, GetProfessionInfo(prof2)) end

	return prof1 == 202 or prof2 == 202
end

local function CheckIfAvailable()
	GetInfos(Teleports.toys, false, true, true, true)
	GetInfos(Teleports.engineering, false, true, true, true)
	GetInfos(Teleports.season, true, false, true, true)
	GetInfos(Teleports.tww, true, false, true, true)
	GetInfos(Teleports.dungeonportals, true, false, true, true)
	GetInfos(Teleports.items, false, false, true, true)
	GetInfos(Teleports.spells, true, false, true, true)
end

local function mUpdateTPList(button)
	CheckIfAvailable()

	wipe(Teleports.menu)
	if Teleports.toys.available and button == "LeftButton" then
		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["Toys"], "title"), isTitle = true, notClickable = true })

		GetInfos(Teleports.toys, false, true, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if EngineeringCheck() and Teleports.engineering.available and button == "RightButton" then
		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["Engineering"], "title"), isTitle = true, notClickable = true })

		GetInfos(Teleports.engineering, false, true, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if Teleports.season.available and button == "LeftButton" then
		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["M+ Season"], "title"), isTitle = true, notClickable = true })

		GetInfos(Teleports.season, true, false, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if Teleports.tww.available and button == "LeftButton" then
		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["TWW Dungeons"], "title"), isTitle = true, notClickable = true })

		GetInfos(Teleports.tww, true, false, false, false)
	end

	if Teleports.dungeonportals.available and button == "MiddleButton" then
		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["M+ Season"], "title"), isTitle = true, notClickable = true })

		GetInfos(Teleports.season, true, false, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })

		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["All Dungeon Teleports"], "title"), isTitle = true, notClickable = true })

		GetInfos(Teleports.dungeonportals, true, false, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if (Teleports.items.available or Teleports.spells.available) and button == "RightButton" then
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["Other"], "title"), isTitle = true, notClickable = true })

		GetInfos(Teleports.items, false, false, false, false)
		GetInfos(Teleports.spells, true, false, false, false)
	end

	-- list = tbl see below
	-- text = string, SecondText = string, color = color string for first text, icon = texture, func = function, funcOnEnter = function,
	-- funcOnLeave = function, isTitle = boolean, macro = macrotext, tooltip = id or var you can use for the functions, notClickable = boolean
end

local function GetSpellInfos(spellID)
	if IsSpellKnown(spellID) then
		local name, _, texture = GetSpellInfo(spellID)
		return name, texture
	end
end

local function GetItemInfos(itemID)
	if (GetItemCount(itemID) > 0) or (PlayerHasToy(itemID) and IsToyUsable(itemID)) then
		local texture = GetItemIcon(itemID)
		local name = GetItemInfo(itemID)
		return name, texture
	end
end

local function GetCooldownTime(id, kind)
	local start, duration, text

	if kind == "spell" then
		local spellCooldownInfo = GetSpellCooldown(id)
		start = spellCooldownInfo.startTime
		duration = spellCooldownInfo.duration
	else
		start, duration = GetItemCooldown(id)
	end

	local cooldown = start + duration - GetTime()

	if cooldown >= 2 then
		local hours = math.floor(cooldown / 3600)
		local minutes = math.floor(cooldown / 60)
		local seconds = string.format("%02.f", math.floor(cooldown - minutes * 60))
		if hours >= 1 then
			minutes = math.floor(mod(cooldown, 3600) / 60)
			text = mMT:SetTextColor(hours .. "h " .. minutes .. "m", "red")
		else
			text = mMT:SetTextColor(minutes .. "m " .. seconds .. "s", "red")
		end
	elseif cooldown <= 0 then
		text = mMT:SetTextColor(L["Ready"], "green")
	end

	return text
end

local function GetNameString(name, icon) end

local function UpdateTeleports()
	for _, value in ipairs(teleports.favorites) do
		if value then
			local name, icon, kind
			if value.type == "item" or value.type ~= "toy" then
				kind = "item"
				name, icon = GetSpellInfos(value.id)
			else
				kind = "spell"
				name, icon = GetItemInfos(value.id)
			end

			if name then knownTeleports.favorites[value.id] = {
				name = GetNameString(name, icon),
				cooldown = GetCooldownTime(value.id, kind),
				type = kind,
				short_name = value.name,
			} end
		end
	end

	for i, v in pairs(TeleportsTable.tps) do
		local texture, name, hasSpell, hasItem = nil, nil, false, 0
		if spell then
			local spellInfo = GetSpellInfo(i)
			texture = GetSpellTexture(i)
			name = spellInfo.name
			hasSpell = IsSpellKnown(i)
		else
			texture = GetItemIcon(i)
			name = GetItemInfo(i)
			hasItem = GetItemCount(i)
		end

		local text1, text2 = nil, nil
		if (texture and name and (hasItem > 0 or (E.Retail and PlayerHasToy(i) and C_ToyBox.IsToyUsable(i)))) or (texture and name and hasSpell) then
			if check then
				TeleportsTable.available = true
			else
				local start, duration = nil, nil

				if spell then
					local spellCooldownInfo = GetSpellCooldown(i)
					start = spellCooldownInfo.startTime
					duration = spellCooldownInfo.duration
				else
					start, duration = GetItemCooldown(i)
				end

				local cooldown = start + duration - GetTime()

				if cooldown >= 2 then
					local hours = math.floor(cooldown / 3600)
					local minutes = math.floor(cooldown / 60)
					local seconds = string.format("%02.f", math.floor(cooldown - minutes * 60))
					if hours >= 1 then
						minutes = math.floor(mod(cooldown, 3600) / 60)
						text1 = "|CFFDB3030" .. name .. "|r"
						text2 = "|CFFDB3030" .. hours .. "h " .. minutes .. "m|r"
					else
						text1 = "|CFFDB3030" .. name .. "|r"
						text2 = "|CFFDB3030" .. minutes .. "m " .. seconds .. "s|r"
					end
				elseif cooldown <= 0 then
					text1 = "|CFFFFFFFF" .. name .. "|r"
					text2 = "|CFF00FF00" .. L["Ready"] .. "|r"
				end

				if text1 and text2 then
					if type(v) == "string" then text1 = "[|CFF00AAFF" .. v .. "|r] " .. text1 end

					if tip then
						DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", texture, text1), text2)
					elseif spell then
						MenuAdd(Teleports.menu, text1, text2, "/cast " .. name, texture, i, function(btn)
							OnEnterSpell(btn)
						end)
					elseif toy then
						MenuAdd(Teleports.menu, text1, text2, "/usetoy " .. name, texture, i, function(btn)
							OnEnterItem(btn)
						end)
					else
						MenuAdd(Teleports.menu, text1, text2, "/use " .. name, texture, i, function(btn)
							OnEnterItem(btn)
						end)
					end
				end
			end
		end
	end
end

local function UpdateMenus()
	-- add favorites
	if E.db.mMT.datatexts.teleports.favorites.enable then
		for _, key in ipairs({ "a", "b", "c", "d" }) do
			local favorite = E.db.mMT.datatexts.teleports.favorites[key]
			if favorite ~= nil then teleports.favorites[favorite] = true end
		end
	end

	UpdateTeleports()

	-- main menu
	if E.db.mMT.datatexts.teleports.favorites.enable then
		tinsert(Teleports.menu, { text = mMT:SetTextColor(L["Favorite"], "title"), isTitle = true, notClickable = true })
		for _, item in ipairs(E.db.mMT.datatexts.teleports.favorites) do
		end
	end
end

local function OnClick(self, button)
	if not InCombatLockdown() then
		if not menuFrames.build then
			menuFrames.menu = CreateFrame("Frame", "mMediaTag_Teleports_Menu", E.UIParent, "BackdropTemplate")
			menuFrames.menu:SetTemplate("Transparent", true)

			menuFrames.dungeons = CreateFrame("Frame", "mMediaTag_Teleports_Dungeons", E.UIParent, "BackdropTemplate")
			menuFrames.dungeons:SetTemplate("Transparent", true)

			menuFrames.season = CreateFrame("Frame", "mMediaTag_Teleports_Season", E.UIParent, "BackdropTemplate")
			menuFrames.season:SetTemplate("Transparent", true)

			menuFrames.toys = CreateFrame("Frame", "mMediaTag_Teleports_Toys", E.UIParent, "BackdropTemplate")
			menuFrames.toys:SetTemplate("Transparent", true)

			menuFrames.misc = CreateFrame("Frame", "mMediaTag_Teleports_Misc", E.UIParent, "BackdropTemplate")
			menuFrames.misc:SetTemplate("Transparent", true)

			menuFrames.build = true
		end

		UpdateMenus()
	end

	if not InCombatLockdown() then
		mUpdateTPList(button)
		local test = {}
		tinsert(test, {
			text = "test dungeons",
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(Teleports.menu, menuFrame_dungeons, menuFrame, 260, 2, true)
			end,
		})
		tinsert(test, {
			text = "test misc",
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(Teleports.menu, menuFrame_misc, menuFrame, 260, 2, true)
			end,
		})
		mMT:DropDown(test, menuFrame, self, 260, 2)
	end
end

local function mTPTooltip()
	CheckIfAvailable()
	if Teleports.toys.available then
		DT.tooltip:AddLine(mMT:SetTextColor(L["Toys"], "title"))
		GetInfos(Teleports.toys, false, true, true, false)
	end

	if EngineeringCheck() and Teleports.engineering.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mMT:SetTextColor(L["Engineering"], "title"))
		GetInfos(Teleports.engineering, false, true, true, false)
	end

	if Teleports.season.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mMT:SetTextColor(L["M+ Season"], "title"))
		GetInfos(Teleports.season, true, false, true, false)
	end

	if Teleports.tww.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mMT:SetTextColor(L["TWW Dungeons"], "title"))
		GetInfos(Teleports.tww, true, false, true, false)
	end

	if Teleports.items.available or Teleports.spells.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mMT:SetTextColor(L["Other"], "title"))
		GetInfos(Teleports.items, false, false, true, false)
		GetInfos(Teleports.spells, true, false, true, false)
	end
end

local function OnEnter(self)
	DT.tooltip:ClearLines()
	mTPTooltip()
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. mMT:SetTextColor(L["left click to open the small menu."], "tip"))
	DT.tooltip:AddLine(MEDIA.middleClick .. " " .. mMT:SetTextColor(L["middle click to open the Dungeon Teleports menu."], "tip"))
	DT.tooltip:AddLine(MEDIA.rightClick .. " " .. mMT:SetTextColor(L["right click to open the other Teleports menu."], "tip"))
	DT.tooltip:Show()
end

local function OnEvent(self, event, unit)
	CheckIfAvailable()

	if E.db.mMT.datatexts.teleports.icon then
		local icon = E:TextureString(MEDIA.icons.teleport[E.db.mMT.datatexts.teleports.iconTexture], ":14:14")
		self.text:SetFormattedText(textString, icon .. " " .. L["Teleports"])
	else
		self.text:SetFormattedText(textString, L["Teleports"])
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex
	textString = strjoin("", textHex, "%s|r")
	valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mMT - Teleports", mMT.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Teleports"], nil, ValueColorUpdate)
