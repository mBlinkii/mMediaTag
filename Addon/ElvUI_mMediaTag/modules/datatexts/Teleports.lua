local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local tinsert = tinsert
local format = format
local wipe = wipe
local pairs = pairs
local math = math
local string = string
local select = select

--WoW API / Variables
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local IsSpellKnown = IsSpellKnown
local GetItemIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount
local PlayerHasToy = PlayerHasToy
local C_ToyBox = C_ToyBox
local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local GetItemCooldown = C_Item and C_Item.GetItemCooldown or GetItemCooldown
local GetTime = GetTime
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo

--Variables
local mText = L["Teleports"]
local menuFrame = CreateFrame("Frame", "mMediaTag_Teleports_Menu", E.UIParent, "BackdropTemplate")
menuFrame:SetTemplate("Transparent", true)

local Teleports = {
	toys = {
		available = false,
		tps = {
			[228940] = true, --Notorious Thread's Hearthstone
			[110560] = true, --garrison-hearthstone
			[140192] = true, --dalaran-hearthstone
			[140324] = true, -- Mobile Telemancy Beacon
			[142542] = true, -- Tome of Town Portal
			[162973] = true, --greatfather-winters-hearthstone
			[163045] = true, --headless-horsemans-hearthstone
			[165669] = true, --lunar-elders-hearthstone
			[165670] = true, --peddlefeets-lovely-hearthstone
			[165802] = true, --noble-gardeners-hearthstone
			[166746] = true, --fire-eaters-hearthstone
			[166747] = true, --brewfest-revelers-hearthstone
			[168907] = true, --holographic-digitalization-hearthstone
			[172179] = true, --eternal-travelers-hearthstone
			[180290] = true, --night-fae-hearthstone
			[182773] = true, --necrolord-hearthstone
			[183716] = true, -- Venthyr Sinstone
			[184353] = true, --kyrian-hearthstone
			[188952] = true, --dominated-hearthstone
			[190196] = true, --enlightened-hearthstone
			[190237] = true, -- Broker Translocation Matrix
			[193588] = true, --Timewalker's Hearthstone
			[200630] = true, --ohnir-windsages-hearthstone
			[206195] = true, -- Path of the Naaru
			[208704] = true, -- Deepdweller's Earthen Hearthstone
			[209035] = true, -- hearthstone-of-the-flame
			[210455] = true, -- Draenic Hologem
			[211788] = true, -- Tess's Peacebloom
			[212337] = true, -- Stone of the Hearth (Hearthstone 10th Anniversary)
			[43824] = true, -- The Schools of Arcane Magic - Mastery
			[54452] = true, -- Ethereal Portal
			[64488] = true, -- The Innkeeper's Daughter
			[6948] = true, -- Hearthstone
			[93672] = true, -- Dark Portal (Retail)
			[95567] = true, -- Kirin Tor Beacon
			[95568] = true, -- Sunreaver Beacon
		},
	},
	engineering = {
		available = false,
		tps = {
			[87215] = true, --wormhole-generator-pandaria
			[48933] = true, --wormhole-generator-northrend
			[198156] = true, -- Wyrmhole Generator
			[172924] = true, --wormhole-generator-shadowlands
			[168808] = true, --wormhole-generator-zandalar
			[168807] = true, --wormhole-generator-kultiras
			[151652] = true, --wormhole-generator-argus
			[112059] = true, --wormhole-centrifuge
			[30542] = true, --Dimensional Ripper - Area
			[30544] = true, --Ultrasafe Transporter: Toshley's Station
			[18986] = true, --Ultrasafe Transporter: Gadgetzan
			[18984] = true, --Dimensional Ripper - Everlook
			[221966] = true, --wormhole-generator-khaz-algar
		},
	},
	items = {
		available = false,
		tps = {
			[103678] = true, --time-lost-artifact
			[118662] = true, -- Bladespire Relic
			[118663] = true, --relic-of-karabor
			[118907] = true, --pit-fighters-punching-ring
			[118908] = true, --pit-fighters-punching-ring
			[119183] = true, --scroll-of-risky-recall
			[128353] = true, --admirals-compass
			[128502] = true, --hunters-seeking-crystal
			[129276] = true, --beginners-guide-to-dimensional-rifting
			[129929] = true, -- Admiral's Compass
			[138448] = true, --emblem-of-margoss
			[139590] = true, --scroll-of-teleport-ravenholdt
			[139599] = true, --empowered-ring-of-the-kirin-tor
			[140493] = true, -- Adepts's Guide to Dimensional Rifting
			[141013] = true, --scroll-of-town-portal-shalanir
			[141014] = true, --scroll-of-town-portal-sashjtar
			[141015] = true, --scroll-of-town-portal-kaldelar
			[141016] = true, --scroll-of-town-portal-faronaar
			[141017] = true, --scroll-of-town-portal-liantril
			[141605] = true, --flight-masters-whistle
			[142298] = true, --astonishingly-scarlet-slippers
			[142469] = true, --violet-seal-of-the-grand-magus
			[142543] = true, --scroll-of-town-portal
			[144391] = true, --pugilists-powerful-punching-ring
			[144392] = true, -- Pugilist's Powerful Punching Ring (Horde)
			[151016] = true, --fractured-necrolyte-skull
			[166559] = true, -- Commander's Signet of Battle
			[166560] = true, -- Captain's Signet of Command
			[167075] = true, -- Ultrasafe Transporter: Mechagon
			[168862] = true, -- G.E.A.R. Tracking Beacon
			[17690] = true, --frostwolf-insignia-rank-1
			[17691] = true, --stormpike-insignia-rank-1
			[17900] = true, --stormpike-insignia-rank-2
			[17901] = true, --stormpike-insignia-rank-3
			[17902] = true, --stormpike-insignia-rank-4
			[17903] = true, --stormpike-insignia-rank-5
			[17904] = true, --stormpike-insignia-rank-6
			[17905] = true, --frostwolf-insignia-rank-2
			[17906] = true, --frostwolf-insignia-rank-3
			[17907] = true, --frostwolf-insignia-rank-4
			[17908] = true, --frostwolf-insignia-rank-5
			[17909] = true, --frostwolf-insignia-rank-6
			[180817] = true, --cypher-of-relocation
			[184871] = true, --dark-portal 2?
			[18984] = true, --dimensional-ripper-everlook
			[18986] = true, --ultrasafe-transporter-gadgetzan
			[193000] = true, -- Ring-Bound Hourglass
			[219222] = true, --Time-Lost Artifact
			[22589] = true, --atiesh-greatstaff-of-the-guardian
			[22630] = true, --atiesh-greatstaff-of-the-guardian
			[22631] = true, --atiesh-greatstaff-of-the-guardian
			[22632] = true, --atiesh-greatstaff-of-the-guardian
			[28585] = true, --ruby-slippers
			[29796] = true, --socrethars-teleportation-stone
			[30542] = true, --dimensional-ripper-area-52
			[30544] = true, --ultrasafe-transporter-toshleys-station
			[32757] = true, --blessed-medallion-of-karabor
			[35230] = true, --darnarians-scroll-of-teleportation
			[37118] = true, --scroll-of-recall
			[37863] = true, --direbrews-remote
			[40585] = true, --signet-of-the-kirin-tor
			[40586] = true, --band-of-the-kirin-tor
			[43824] = true, --the-schools-of-arcane-magic-mastery
			[44314] = true, --scroll-of-recall-ii
			[44315] = true, --scroll-of-recall-iii
			[44934] = true, --loop-of-the-kirin-tor
			[44935] = true, --ring-of-the-kirin-tor
			[45688] = true, --inscribed-band-of-the-kirin-tor
			[45689] = true, --inscribed-loop-of-the-kirin-tor
			[45690] = true, --inscribed-ring-of-the-kirin-tor
			[45691] = true, --inscribed-signet-of-the-kirin-tor
			[46874] = true, --argent-crusaders-tabard
			[48954] = true, --etched-band-of-the-kirin-tor
			[48955] = true, --etched-loop-of-the-kirin-tor
			[48956] = true, --etched-ring-of-the-kirin-tor
			[48957] = true, --etched-signet-of-the-kirin-tor
			[50287] = true, --boots-of-the-bay
			[51557] = true, --runed-signet-of-the-kirin-tor
			[51558] = true, --runed-loop-of-the-kirin-tor
			[51559] = true, --runed-ring-of-the-kirin-tor
			[51560] = true, --runed-band-of-the-kirin-tor
			[52251] = true, --jainas-locket
			[54452] = true, --ethereal-portal
			[58487] = true, --potion-of-deepholm
			[61379] = true, --gidwins-hearthstone
			[63206] = true, --wrap-of-unity
			[63207] = true, --wrap-of-unity
			[63352] = true, --shroud-of-cooperation
			[63353] = true, --shroud-of-cooperation
			[63378] = true, --hellscreams-reach-tabard
			[63379] = true, --baradins-wardens-tabard
			[64457] = true, --the-last-relic-of-argus
			[65274] = true, --cloak-of-coordination
			[65360] = true, --cloak-of-coordination
			[68808] = true, --heros-hearthstone
			[68809] = true, --veterans-hearthstone
			[6948] = true, --hearthstone
			[92510] = true, --voljins-hearthstone
			[93672] = true, --dark-portal
			[95050] = true, --the-brassiest-knuckle
			[95051] = true, --the-brassiest-knuckle
			[95567] = true, --kirin-tor-beacon
			[95568] = true, --sunreaver-beacon
		},
	},
	spells = {
		available = false,
		tps = {
			[126892] = true, -- zen-pilgrimage
			[18960] = true, -- Moonglade
			[193753] = true, -- dreamwalk
			[193759] = true, -- teleport-hall-of-the-guardian
			[265225] = true, -- Mole Machine
			[312372] = true, -- Return to Camp
			[50977] = true, -- death-gate
			[556] = true, -- astral-recall
		},
	},
	season = {
		available = false,
		tps = {
			-- S2
			[445440] = "CM", -- Cinderbrew Meadery
			[467546] = "CM", -- Cinderbrew Meadery
			[445441] = "DC", -- Darkflame Cleft
			[445444] = "PSF", -- Priory of the Sacred Flame
			[445443] = "ROOK", -- The Rookery
			[1216786] = "OF", --Operation: Floodgate
			[354467] = "TOP", -- Theater of Pain
			[373274] = "MG", -- Mechagon
			[467555] = "TM", -- The MOTHERLODE!!
			[467553] = "TM", -- The MOTHERLODE!!
		},
	},

	tww = {
		available = false,
		tps = {
			[445269] = "SV", -- The Stonevault
			[445414] = "DAWN", -- The Dawnbreaker
			[445416] = "CoT", -- City of Threads
			[445417] = "ARAK", -- Ara-Kara, City of Echoes
			[445440] = "CM", -- Cinderbrew Meadery
			[445441] = "DC", -- Darkflame Cleft
			[445443] = "ROOK", -- The Rookery
			[445444] = "PSF", -- Priory of the Sacred Flame
			[1216786] = "OF", --Operation: Floodgate
		},
	},

	dungeonportals = {
		available = false,
		tps = {
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
	},
	menu = {},
}

local function LeaveFunc(btn)
	GameTooltip:Hide()
end

local function mMenuAdd(tbl, text, time, macro, icon, tooltip, funcOnEnter)
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
	if not E.db.mMT.teleports.anchorCursor and point then
		local left = point and strfind(point, "LEFT")
		anchor = left and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
	end
	return anchor
end

local function mOnEnterItem(btn)
	GameTooltip:SetOwner(btn, getAnchorPoint(menuFrame.pointB))
	GameTooltip:ClearLines()
	GameTooltip:SetItemByID(btn.tooltip)
	GameTooltip:Show()
end

local function mOnEnterSpell(btn)
	GameTooltip:SetOwner(btn, getAnchorPoint(menuFrame.pointB))
	GameTooltip:ClearLines()
	GameTooltip:SetSpellByID(btn.tooltip)
	GameTooltip:Show()
end

local function mGetInfos(TeleportsTable, spell, toy, tip, check)
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
						mMenuAdd(Teleports.menu, text1, text2, "/cast " .. name, texture, i, function(btn)
							mOnEnterSpell(btn)
						end)
					elseif toy then
						mMenuAdd(Teleports.menu, text1, text2, "/usetoy " .. name, texture, i, function(btn)
							mOnEnterItem(btn)
						end)
					else
						mMenuAdd(Teleports.menu, text1, text2, "/use " .. name, texture, i, function(btn)
							mOnEnterItem(btn)
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
	mGetInfos(Teleports.toys, false, true, true, true)
	mGetInfos(Teleports.engineering, false, true, true, true)
	mGetInfos(Teleports.season, true, false, true, true)
	mGetInfos(Teleports.tww, true, false, true, true)
	mGetInfos(Teleports.dungeonportals, true, false, true, true)
	mGetInfos(Teleports.items, false, false, true, true)
	mGetInfos(Teleports.spells, true, false, true, true)
end

local function mUpdateTPList(button)
	CheckIfAvailable()
	local _, _, _, _, _, title = mMT:mColorDatatext()

	wipe(Teleports.menu)
	if Teleports.toys.available and button == "LeftButton" then
		tinsert(Teleports.menu, { text = format("%s%s|r", title, L["Toys"]), isTitle = true, notClickable = true })

		mGetInfos(Teleports.toys, false, true, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if EngineeringCheck() and Teleports.engineering.available and button == "RightButton" then
		tinsert(Teleports.menu, { text = format("%s%s|r", title, L["Engineering"]), isTitle = true, notClickable = true })

		mGetInfos(Teleports.engineering, false, true, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if Teleports.season.available and button == "LeftButton" then
		tinsert(Teleports.menu, { text = format("%s%s|r", title, L["M+ Season"]), isTitle = true, notClickable = true })

		mGetInfos(Teleports.season, true, false, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if Teleports.tww.available and button == "LeftButton" then
		tinsert(Teleports.menu, { text = format("%s%s|r", title, L["TWW Dungeons"]), isTitle = true, notClickable = true })

		mGetInfos(Teleports.tww, true, false, false, false)
	end

	if Teleports.dungeonportals.available and button == "MiddleButton" then
		tinsert(Teleports.menu, { text = format("%s%s|r", title, L["M+ Season"]), isTitle = true, notClickable = true })

		mGetInfos(Teleports.season, true, false, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })

		tinsert(Teleports.menu, { text = format("%s%s|r", title, L["All Dungeon Teleports"]), isTitle = true, notClickable = true })

		mGetInfos(Teleports.dungeonportals, true, false, false, false)
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
	end

	if (Teleports.items.available or Teleports.spells.available) and button == "RightButton" then
		tinsert(Teleports.menu, { text = "", isTitle = true, notClickable = true })
		tinsert(Teleports.menu, { text = format("%s%s|r", title, L["Other"]), isTitle = true, notClickable = true })

		mGetInfos(Teleports.items, false, false, false, false)
		mGetInfos(Teleports.spells, true, false, false, false)
	end
end

local function OnClick(self, button)
	if not InCombatLockdown() then
		mUpdateTPList(button)
		mMT:mDropDown(Teleports.menu, menuFrame, self, 260, 2)
	end
end

local function mTPTooltip()
	CheckIfAvailable()
	if Teleports.toys.available then
		DT.tooltip:AddLine(L["Toys"])
		mGetInfos(Teleports.toys, false, true, true, false)
	end

	if EngineeringCheck() and Teleports.engineering.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Engineering"])
		mGetInfos(Teleports.engineering, false, true, true, false)
	end

	if Teleports.season.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["M+ Season"])
		mGetInfos(Teleports.season, true, false, true, false)
	end

	if Teleports.tww.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["TWW Dungeons"])
		mGetInfos(Teleports.tww, true, false, true, false)
	end

	if Teleports.items.available or Teleports.spells.available then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Other"])
		mGetInfos(Teleports.items, false, false, true, false)
		mGetInfos(Teleports.spells, true, false, true, false)
	end
end

local function OnEnter(self)
	local nhc, hc, myth, mythp, other, title, tip = mMT:mColorDatatext()
	DT.tooltip:ClearLines()
	mTPTooltip()
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["left click to open the small menu."]))
	DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["MIDDLE"]), tip, L["middle click to open the Dungeon Teleports menu."]))
	DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["right click to open the other Teleports menu."]))
	DT.tooltip:Show()
end

local function colorText(value, withe)
	if withe then
		return value
	else
		local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
		return hexColor .. value .. "|r"
	end
end

local function OnEvent(self, event, unit)
	CheckIfAvailable()

	if E.db.mMT.teleports.icon then
		self.text:SetText(format("|T%s:16:16:0:0:64:64|t %s", mMT.Media.TeleportIcons[E.db.mMT.teleports.customicon], colorText(mText, E.db.mMT.teleports.whiteText)))
	else
		self.text:SetText(colorText(mText, E.db.mMT.teleports.whiteText))
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mTeleports", mMT.DatatextString, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
