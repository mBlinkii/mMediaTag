local E = unpack(ElvUI)
local L = mMT.Locales
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local C_ToyBox = C_ToyBox
local GameTooltip = GameTooltip
local GetItemCooldown = C_Item and C_Item.GetItemCooldown or GetItemCooldown
local GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount
local GetItemIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local IsToyUsable = C_ToyBox.IsToyUsable
local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local GetTime = GetTime
local IsSpellKnown = IsSpellKnown
local PlayerHasToy = PlayerHasToy
local math = math
local pairs = pairs
local string = string
local tinsert = tinsert

-- Variables
local textString = ""

local menus = {}
mMT.knownTeleports = {
	favorites = {},
	toys = {},
	engineering = {},
	items = {},
	spells = {},
	season = {},
	tww = {},
	dungeonportals = {},
}
local teleportsIDs = {
	favorites = {},
	toys = {
		[228940] = "toy", --Notorious Thread's Hearthstone
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
		[236687] = "toy", -- Explosive Hearthstone toy
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
		[159224] = "item", -- Zuldazar Hearthstone item
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
		[208822] = "item", -- Brewfest Reveler's Hearthstone item
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
		-- tww s2
		[445440] = "BREW",
		[467546] = "BREW",
		[445441] = "DFC",
		[445444] = "PSF",
		[445443] = "ROOK",
		[1216786] = "FLOOD",
		[467555] = "ML",
		[467553] = "ML",
		[354467] = "TOP",
		[373274] = "WORK",

		-- tww s1
		-- [445417] = "ARAK",
		-- [445416] = "COT",
		-- [445414] = "DAWN",
		-- [445269] = "SV",
		-- [354464] = "MISTS",
		-- [354462] = "NW",
		-- [445418] = "SIEGE",
		-- [464256] = "SIEGE",
		-- [445424] = "GB",
	},

	tww = {
		-- tww
		[445417] = "ARAK",
		[445440] = "BREW",
		[445416] = "COT",
		[445441] = "DFC",
		[445414] = "DAWN",
		[1216786] = "FLOOD",
		[445444] = "PSF",
		[445443] = "ROOK",
		[445269] = "SV",

		-- tww raid
		[1226482] = "LOU",
	},

	dungeonportals = {
		-- tww
		[445417] = "ARAK",
		[445440] = "BREW",
		[445416] = "COT",
		[445441] = "DFC",
		[445414] = "DAWN",
		[1216786] = "FLOOD",
		[445444] = "PSF",
		[445443] = "ROOK",
		[445269] = "SV",

		-- df
		[393273] = "AA",
		[393279] = "AV",
		[393267] = "BH",
		[393283] = "HOI",
		[393276] = "NELTH",
		[393262] = "NO",
		[393256] = "RLP",
		[393222] = "ULD",
		[424197] = "DOTI",

		-- sl
		[354468] = "DOS",
		[354465] = "HOA",
		[354464] = "MISTS",
		[354462] = "NW",
		[354463] = "PF",
		[354469] = "SD",
		[354466] = "SOA",
		[354467] = "TOP",
		[367416] = "TAZ",

		-- bfa
		[424187] = "AD",
		[410071] = "FH",
		[373274] = "MECHA",
		[467555] = "ML",
		[467553] = "ML",
		[445418] = "SIEGE",
		[464256] = "SIEGE",
		[410074] = "UNDR",
		[424167] = "WM",

		-- legion
		[424153] = "BRH",
		[393766] = "COS",
		[424163] = "DT",
		[393764] = "HOV",
		[373262] = "KARA",
		[410078] = "NL",

		-- wod
		[159897] = "AUCH",
		[159895] = "BSM",
		[159901] = "EB",
		[159900] = "GD",
		[159896] = "ID",
		[159899] = "SBG",
		[159898] = "SR",
		[159902] = "UBRS",

		-- mop
		[131225] = "GOTSS",
		[131222] = "MSP",
		[131232] = "SCHOLO",
		[131231] = "SH",
		[131229] = "SM",
		[131228] = "SNT",
		[131206] = "SPM",
		[131205] = "SSB",
		[131204] = "TJS",

		-- cata
		[445424] = "GB",
		[424142] = "TOTT",
		[410080] = "VP",

		-- sl raid
		[373190] = "CN",
		[373191] = "SOD",
		[373192] = "STFO",

		-- df raid
		[432254] = "VOTI",
		[432257] = "ATSC",
		[432258] = "ATDH",

		-- tww raid
		[1226482] = "LOU",
	},
}

function TC(text, color)
	local nhc, hc, myth, mythp, other, title = mMT:mColorDatatext()

	if color == "title" then
		color = title
	elseif color == "mark" then
		color = "|cff20E3F1" -- #20E3F1FF
	elseif color == "green" then
		color = "|cff54F120" -- #54F120FF
	elseif color == "red" then
		color = "|cffF14320" -- #F14320FF
	else
		color = "|cffffffff"
	end
	return format("%s%s|r", color, text)
end

local function LeaveFunc(btn)
	GameTooltip:Hide()
end

local function OnEnterItem(btn)
	GameTooltip:SetOwner(btn, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:SetItemByID(btn.tooltip)
	GameTooltip:Show()
end

local function OnEnterSpell(btn)
	GameTooltip:SetOwner(btn, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:SetSpellByID(btn.tooltip)
	GameTooltip:Show()
end

local function GetSpellInfos(spellID)
	if spellID and spellID ~= "none" then
		if IsSpellKnown(spellID) then
			local spellInfo = GetSpellInfo(spellID)
			return spellInfo.name, spellInfo.iconID
		end
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
			text = TC(hours .. "h " .. minutes .. "m", "red")
		else
			text = TC(minutes .. "m " .. seconds .. "s", "red")
		end
	elseif cooldown <= 0 then
		text = TC(L["Ready"], "green")
	end

	return text
end

local function processTeleport(t, category, kindOverride)
	for id, idKind in pairs(t) do
		if id then
			local name, icon = nil, nil
			local kind = kindOverride or idKind

			-- this is needed because of favorite teleports
			local isDungeonTeleport = (idKind ~= "spell" and idKind ~= "toy" and idKind ~= "item")
			kind = (kind == "item" or kind == "toy") and "item" or "spell"

			if kind == "spell" then
				name, icon = GetSpellInfos(id)
			else
				name, icon = GetItemInfos(id)
			end

			if name then
				mMT.knownTeleports[category].available = true
				mMT.knownTeleports[category][id] = {
					name = name,
					icon = icon,
					kind = idKind,
					cooldown = GetCooldownTime(id, kind),
					short_name = isDungeonTeleport and idKind,
					use = kind == "spell" and ("/cast " .. name) or (kind == "toy" and ("/usetoy " .. name) or ("/use " .. name)),
					onEnter = (kind == "spell") and function(btn)
						OnEnterSpell(btn)
					end or function(btn)
						OnEnterItem(btn)
					end,
				}
			end
		end
	end
end

function mMT:UpdateTeleports()
	if E.db.mMT.datatexts.teleports.favorites.enable then
		mMT.knownTeleports.favorites = {}
		teleportsIDs.favorites = {}
		-- add favorites
		for _, key in pairs({ "a", "b", "c", "d" }) do
			local favorite = E.db.mMT.datatexts.teleports.favorites[key]
			if favorite and favorite.id ~= "none" then teleportsIDs.favorites[favorite.id] = favorite.kind end
		end
		processTeleport(teleportsIDs.favorites, "favorites")
	end

	processTeleport(teleportsIDs.engineering, "engineering")
	processTeleport(teleportsIDs.items, "items")
	processTeleport(teleportsIDs.spells, "spells")
	processTeleport(teleportsIDs.toys, "toys")

	processTeleport(teleportsIDs.dungeonportals, "dungeonportals", "spell")
	processTeleport(teleportsIDs.season, "season", "spell")
	processTeleport(teleportsIDs.tww, "tww", "spell")

	mMT.knownTeleports.other = mMT.knownTeleports.items.available or mMT.knownTeleports.spells.available
end

local function CreateMenuEntry(id, t)
	return {
		text = t.short_name and ("[" .. TC(t.short_name, "mark") .. "] " .. t.name) or t.name,
		right_text = t.cooldown,
		icon = t.icon,
		isTitle = false,
		tooltip = id,
		macro = t.use,
		funcOnEnter = t.onEnter,
		funcOnLeave = LeaveFunc,
	}
end

local function UpdateMenus()
	mMT:UpdateTeleports()

	-- Initialize main menu
	menus.main = {}

	-- Add favorites menu entry
	if E.db.mMT.datatexts.teleports.favorites.enable and mMT.knownTeleports.favorites.available then
		tinsert(menus.main, { text = TC(L["Favorite"], "title"), isTitle = true, notClickable = true })
		for id, t in pairs(mMT.knownTeleports.favorites) do
			if t and type(t) == "table" then tinsert(menus.main, CreateMenuEntry(id, t)) end
		end
		tinsert(menus.main, { text = "", isTitle = true, notClickable = true })
	end

	-- Add season portals menu entry
	if mMT.knownTeleports.season.available then
		tinsert(menus.main, { text = TC(L["M+ Season"], "title"), isTitle = true, notClickable = true })
		for id, t in pairs(mMT.knownTeleports.season) do
			if t and type(t) == "table" then tinsert(menus.main, CreateMenuEntry(id, t)) end
		end
	end

	-- Add other portals menu entry
	if mMT.knownTeleports.tww.available or mMT.knownTeleports.dungeonportals.available or mMT.knownTeleports.toys.available or mMT.knownTeleports.engineering.available or mMT.knownTeleports.other then
		tinsert(menus.main, { text = "", isTitle = true, notClickable = true })
		tinsert(menus.main, { text = TC(L["Other Portals"], "title"), isTitle = true, notClickable = true })
	end

	-- Add tww dungeon portals
	if mMT.knownTeleports.tww.available then
		-- build submenu
		menus.tww = {}

		for id, t in pairs(mMT.knownTeleports.tww) do
			if t and type(t) == "table" then tinsert(menus.tww, CreateMenuEntry(id, t)) end
		end

		-- main menu entry for tww dungeon teleports
		tinsert(menus.main, {
			text = "TWW " .. L["Dungeon Teleports"],
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.tww, mMT.submenu, mMT.menu, 260, 2, "tww_dungeons")
			end,
		})
	end

	-- Add dungeon portals
	if mMT.knownTeleports.dungeonportals.available then
		-- build submenu
		menus.dungeonportals = {}

		for id, t in pairs(mMT.knownTeleports.dungeonportals) do
			if t and type(t) == "table" then tinsert(menus.dungeonportals, CreateMenuEntry(id, t)) end
		end

		-- main menu entry for dungeon teleports
		tinsert(menus.main, {
			text = L["Dungeon Teleports"],
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.dungeonportals, mMT.submenu, mMT.menu, 260, 2, "all_dungeons")
			end,
		})
	end

	-- Add toys
	if mMT.knownTeleports.toys.available then
		-- build submenu
		menus.toys = {}

		for id, t in pairs(mMT.knownTeleports.toys) do
			if t and type(t) == "table" then tinsert(menus.toys, CreateMenuEntry(id, t)) end
		end

		-- main menu entry for toys
		tinsert(menus.main, {
			text = L["Toys"],
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.toys, mMT.submenu, mMT.menu, 260, 2, "toys")
			end,
		})
	end

	-- Add engineering
	if mMT.knownTeleports.engineering.available then
		-- build submenu
		menus.engineering = {}

		for id, t in pairs(mMT.knownTeleports.engineering) do
			if t and type(t) == "table" then tinsert(menus.engineering, CreateMenuEntry(id, t)) end
		end

		-- main menu entry for engineering teleports
		tinsert(menus.main, {
			text = L["Engineering"],
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.engineering, mMT.submenu, mMT.menu, 260, 2, "engineering")
			end,
		})
	end

	-- Add other entries
	if mMT.knownTeleports.other then
		-- build submenu
		menus.other = {}

		-- items
		if mMT.knownTeleports.items.available then
			tinsert(menus.other, { text = TC(L["Items"], "title"), isTitle = true, notClickable = true })
			for id, t in pairs(mMT.knownTeleports.items) do
				if t and type(t) == "table" then tinsert(menus.other, CreateMenuEntry(id, t)) end
			end
		end

		-- spells
		if mMT.knownTeleports.spells.available then
			tinsert(menus.other, { text = "", isTitle = true, notClickable = true })
			tinsert(menus.other, { text = TC(L["Spells"], "title"), isTitle = true, notClickable = true })
			for id, t in pairs(mMT.knownTeleports.spells) do
				if t and type(t) == "table" then tinsert(menus.other, CreateMenuEntry(id, t)) end
			end
		end

		-- main menu entry for other teleports
		tinsert(menus.main, {
			text = L["Other Teleports"],
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.other, mMT.submenu, mMT.menu, 260, 2, "misc")
			end,
		})
	end
end

local function OnClick(self, button)
	if not InCombatLockdown() then
		if not mMT.menu then mMT:BuildMenus() end

		UpdateMenus()

		mMT:DropDown(menus.main, mMT.menu, self, 260, 2)
	end
end

local function BuildTipIcon(icon)
	return E:TextureString(icon, ":14:14") .. " "
end
local function OnEnter(self)
	mMT:UpdateTeleports()

	DT.tooltip:ClearLines()

	local tipAdded = false

	-- Add favorites menu entry
	if E.db.mMT.datatexts.teleports.favorites.enable and mMT.knownTeleports.favorites.available then
		DT.tooltip:AddLine(TC(L["Favorites"], "title"))
		for _, t in pairs(mMT.knownTeleports.favorites) do
			if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. TC(t.short_name and ("[" .. TC(t.short_name, "mark") .. "] " .. t.name) or t.name), t.cooldown) end
		end
		DT.tooltip:AddLine(" ")
		tipAdded = true
	else
		DT.tooltip:AddLine(TC(L["You can select your favourites in the settings."]))
		DT.tooltip:AddLine(" ")
	end

	-- Add season menu entry
	if mMT.knownTeleports.season.available then
		DT.tooltip:AddLine(TC(L["Season Teleports"], "title"))
		for _, t in pairs(mMT.knownTeleports.season) do
			if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. TC(t.short_name and ("[" .. TC(t.short_name, "mark") .. "] " .. t.name) or t.name), t.cooldown) end
		end
		DT.tooltip:AddLine(" ")
		tipAdded = true
	end

	-- Add season menu entry
	if mMT.knownTeleports.season.available then
		DT.tooltip:AddLine(TC(L["TWW Dungeon Teleports"], "title"))
		for _, t in pairs(mMT.knownTeleports.tww) do
			if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. TC(t.short_name and ("[" .. TC(t.short_name, "mark") .. "] " .. t.name) or t.name), t.cooldown) end
		end
		DT.tooltip:AddLine(" ")
		tipAdded = true
	end

	if not tipAdded and (mMT.knownTeleports.other or mMT.knownTeleports.toys) then
		if mMT.knownTeleports.items.available then
			DT.tooltip:AddLine(TC(L["Items"], "title"))
			for _, t in pairs(mMT.knownTeleports.items) do
				if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. TC(t.name), t.cooldown) end
			end
			DT.tooltip:AddLine(" ")
		end

		if mMT.knownTeleports.toys.available then
			DT.tooltip:AddLine(TC(L["Toys"], "title"))
			for _, t in pairs(mMT.knownTeleports.toys) do
				if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. TC(t.name), t.cooldown) end
			end
			DT.tooltip:AddLine(" ")
		end
	elseif not tipAdded then
		DT.tooltip:AddLine(TC(L["You currently have no important teleports."]))
		DT.tooltip:AddLine(" ")
	end

	DT.tooltip:Show()
end

local function OnEvent(self)
	local iconPath = E.db.mMT.datatexts.teleports.icon
	local label = L["Teleports"]

	if iconPath ~= "none" then label = E:TextureString(mMT.Media.TeleportIcons[iconPath], ":14:14") .. " " .. label end

	self.text:SetFormattedText(textString, label)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.teleports.whiteText and "|cffffffff" or hex
	textString = strjoin("", textHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mTeleports", mMT.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Teleports"], nil, ValueColorUpdate)
