local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
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
local IsSpellKnown = C_SpellBook and C_SpellBook.IsSpellInSpellBook or IsSpellKnown
local GetTime = GetTime
local PlayerHasToy = PlayerHasToy
local math = math
local pairs = pairs
local string = string
local tinsert = tinsert
local ipairs = ipairs
local wipe = wipe
local strfind = strfind
local strlower = strlower
local C_LFGList = C_LFGList
local C_ChallengeMode = C_ChallengeMode
local C_MythicPlus = C_MythicPlus
local format = format
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local select = select
local C_Timer = C_Timer
local CreateFrame = CreateFrame
local C_TooltipInfo = C_TooltipInfo
local GetBindLocation = GetBindLocation
local Item = Item
local ITEM_SPELL_TRIGGER_ONUSE = ITEM_SPELL_TRIGGER_ONUSE

-- Variables
mMT.knownTeleports = {
	favorites = {},
	hearthstones = {},
	toys = {},
	engineering = {},
	items = {},
	spells = {},
	season = {},
	midnight = {},
	tww = {},
	dungeonportals = {},
	mage = {},
	mageportals = {},
}

local textString = ""
local ICON_SIZE = 20
local menus = {}
local teleportsIDs = {
	favorites = {},
	hearthstones = {
		[162973] = "toy", --greatfather-winters-hearthstone
		[163045] = "toy", --headless-horsemans-hearthstone
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
		[208704] = "toy", -- Deepdweller's Earthen Hearthstone
		[209035] = "toy", -- hearthstone-of-the-flame
		[212337] = "toy", -- Stone of the Hearth (Hearthstone 10th Anniversary)
		[228940] = "toy", --Notorious Thread's Hearthstone
		[235016] = "toy", -- Redeployment Module
		[236687] = "toy", -- Explosive Hearthstone toy
		[245970] = "toy", -- P.O.S.T. Master's Express Hearthstone
		[265100] = "toy", -- Corewarden's Hearthstone
		[257736] = "toy", -- Lightcalled Hearthstone
		[263933] = "toy", -- Preyseeker's Hearthstone
	},
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
		[228940] = "toy", --Notorious Thread's Hearthstone
		[235016] = "toy", -- Redeployment Module
		[236687] = "toy", -- Explosive Hearthstone toy
		[245970] = "toy", -- P.O.S.T. Master's Express Hearthstone
		[43824] = "toy", -- The Schools of Arcane Magic - Mastery
		[54452] = "toy", -- Ethereal Portal
		[64488] = "toy", -- The Innkeeper's Daughter
		[6948] = "toy", -- Hearthstone
		[93672] = "toy", -- Dark Portal (Retail)
		[95567] = "toy", -- Kirin Tor Beacon
		[95568] = "toy", -- Sunreaver Beacon
		[265100] = "toy", -- Corewarden's Hearthstone
		[257736] = "toy", -- Lightcalled Hearthstone
		[253629] = "toy", -- Arcantia
		[263933] = "toy", -- Preyseeker's Hearthstone
	},
	engineering = {
		[112059] = "toy", --wormhole-centrifuge
		[151652] = "toy", --wormhole-generator-argus
		[168807] = "toy", --wormhole-generator-kultiras
		[168808] = "toy", --wormhole-generator-zandalar
		[172924] = "toy", --wormhole-generator-shadowlands
		[18984] = "toy", --Dimensional Ripper - Everlook
		[18986] = "toy", --Ultrasafe Transporter: Gadgetzan
		[198156] = "toy", -- Wyrmhole Generator
		[221966] = "toy", --wormhole-generator-khaz-algar
		[30542] = "toy", --Dimensional Ripper - Area
		[30544] = "toy", --Ultrasafe Transporter: Toshley's Station
		[48933] = "toy", --wormhole-generator-northrend
		[87215] = "toy", --wormhole-generator-pandaria
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
		[265225] = "spell", -- Mole Machine
		[312372] = "spell", -- Return to Camp
		[50977] = "spell", -- death-gate
		[556] = "spell", -- astral-recall
	},

	mage = {},
	mageportals = {},

	season = {
		-- midnight s2
		[1286801] = "BV",
		[1286804] = "VA",
		[1286807] = "DON",
		[1286809] = "MR",
		[1286812] = "AOF",
		[1286828] = "TOS",
		[1286831] = "KR",
		[393256] = "RLP",
	},

	tww = {
		-- tww
		[1216786] = "FLOOD",
		[1237215] = "ALDANI",
		[445269] = "SV",
		[445414] = "DAWN",
		[445416] = "COT",
		[445417] = "ARAK",
		[445440] = "BREW",
		[445441] = "DFC",
		[445443] = "ROOK",
		[445444] = "PSF",

		-- tww raid
		[1226482] = "LOU",
		[1239155] = "MFO",
	},

	midnight = {
		-- midnight
		[1254572] = "MT",
		[1254559] = "MC",
		[1254563] = "NPX",
		[1254400] = "WS",
		[1286801] = "BV",
		[1286804] = "VA",
		[1286807] = "DON",
		[1286809] = "MR",
		[1286812] = "AOF",
	},

	dungeonportals = {
		-- midnight
		[1254572] = "MT",
		[1254559] = "MC",
		[1254563] = "NPX",
		[1254400] = "WS",
		[1286801] = "BV",
		[1286804] = "VA",
		[1286807] = "DON",
		[1286809] = "MR",
		[1286812] = "AOF",

		-- tww
		[1216786] = "FLOOD",
		[1237215] = "ALDANI",
		[445269] = "SV",
		[445414] = "DAWN",
		[445416] = "COT",
		[445417] = "ARAK",
		[445440] = "BREW",
		[445441] = "DFC",
		[445443] = "ROOK",
		[445444] = "PSF",

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
		[1286828] = "TOS",
		[1286831] = "KR",

		-- legion
		[424153] = "BRH",
		[393766] = "COS",
		[424163] = "DT",
		[393764] = "HOV",
		[373262] = "KARA",
		[410078] = "NL",
		[1254551] = "SEAT",

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

		--wotlk
		[1254555] = "POS",

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
		[1239155] = "MFO",
	},
}

-- hearthstones are found by matching GetBindLocation() in the toy's "Use:" line, so oddly named ones need no list entry.
-- Rescanned every login; toys with a fixed destination (Garrison/Dalaran/Wormhole/...) stay in the lists.
local function IsHearthstoneToy(itemID)
	local bind = GetBindLocation and GetBindLocation()
	if not bind or bind == "" then return false end
	bind = strlower(bind)

	local data = C_TooltipInfo and C_TooltipInfo.GetToyByItemID and C_TooltipInfo.GetToyByItemID(itemID)
	if not (data and data.lines) then return false end

	for _, line in ipairs(data.lines) do
		local text = line.leftText
		-- only the "Use:" line - toys that merely mention the bind location would match too
		if text and strfind(text, ITEM_SPELL_TRIGGER_ONUSE, 1, true) == 1 and strfind(strlower(text), bind, 1, true) then return true end
	end

	return false
end

local function AddDetectedHearthstone(itemID)
	if not itemID or itemID <= 0 then return false end
	if teleportsIDs.hearthstones[itemID] then return false end
	if not PlayerHasToy(itemID) then return false end

	if IsHearthstoneToy(itemID) then
		teleportsIDs.hearthstones[itemID] = "toy"
		teleportsIDs.toys[itemID] = teleportsIDs.toys[itemID] or "toy"
		if DB.DEV then mMT:Print("Hearthstone toy detected:", itemID, tostring((GetItemInfo(itemID)))) end
		return true
	end

	return false
end

-- item data is loaded asynchronously - run the detection once it is available
local updatePending = false
local function DetectHearthstoneWhenLoaded(itemID)
	if not itemID or itemID <= 0 then return end

	local item = Item:CreateFromItemID(itemID)
	if item:IsItemEmpty() then return end

	item:ContinueOnItemLoad(function()
		if AddDetectedHearthstone(itemID) and not updatePending then
			-- debounce: the login scan triggers many callbacks in a short time
			updatePending = true
			C_Timer.After(0.5, function()
				updatePending = false
				if mMT.UpdateTeleports then mMT:UpdateTeleports() end
			end)
		end
	end)
end

-- full toy scan on login; the filters are restored afterwards
local function ScanCollectedToys()
	if not (C_ToyBox and C_ToyBox.GetNumFilteredToys and C_ToyBox.GetToyFromIndex) then return end

	local prevCollected = C_ToyBox.GetCollectedShown and C_ToyBox.GetCollectedShown()
	local prevUncollected = C_ToyBox.GetUncollectedShown and C_ToyBox.GetUncollectedShown()
	local prevFilter = C_ToyBox.GetFilterString and C_ToyBox.GetFilterString()

	if C_ToyBox.SetCollectedShown then C_ToyBox.SetCollectedShown(true) end
	if C_ToyBox.SetUncollectedShown then C_ToyBox.SetUncollectedShown(false) end
	if C_ToyBox.SetFilterString then C_ToyBox.SetFilterString("") end
	if C_ToyBox.ForceToyRefilter then C_ToyBox.ForceToyRefilter() end

	local num = C_ToyBox.GetNumFilteredToys() or 0
	for i = 1, num do
		DetectHearthstoneWhenLoaded(C_ToyBox.GetToyFromIndex(i))
	end

	-- restore filter state
	if prevCollected ~= nil and C_ToyBox.SetCollectedShown then C_ToyBox.SetCollectedShown(prevCollected) end
	if prevUncollected ~= nil and C_ToyBox.SetUncollectedShown then C_ToyBox.SetUncollectedShown(prevUncollected) end
	if prevFilter and C_ToyBox.SetFilterString then C_ToyBox.SetFilterString(prevFilter) end
	if C_ToyBox.ForceToyRefilter then C_ToyBox.ForceToyRefilter() end
end

local toyDetectFrame = CreateFrame("Frame")
toyDetectFrame:RegisterEvent("PLAYER_ENTERING_WORLD") -- login (also catches store purchases made while offline)
toyDetectFrame:RegisterEvent("NEW_TOY_ADDED") -- check a newly obtained toy
toyDetectFrame:SetScript("OnEvent", function(_, event, arg1)
	if event == "NEW_TOY_ADDED" then
		DetectHearthstoneWhenLoaded(arg1)
	elseif not toyDetectFrame.scanned then
		toyDetectFrame.scanned = true
		DB.detectedHearthstones = nil -- cleanup: old persistent cache is no longer used
		C_Timer.After(5, ScanCollectedToys)
	end
end)

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
	if IsSpellKnown(spellID) then
		local spellInfo = GetSpellInfo(spellID)
		return spellInfo.name, spellInfo.iconID
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
	local start, duration, text, isActive

	if kind == "spell" then
		local spellCooldownInfo = GetSpellCooldown(id)
		if spellCooldownInfo then
			start = spellCooldownInfo.startTime
			duration = spellCooldownInfo.duration
			isActive = spellCooldownInfo.isActive
		end
	else
		start, duration = GetItemCooldown(id)
	end

	if not start or not duration or E:IsSecretValue(start) or E:IsSecretValue(duration) then return mMT:CooldownStateText(isActive) end

	local cooldown = start + duration - GetTime()

	if cooldown >= 2 then
		local hours = math.floor(cooldown / 3600)
		local minutes = math.floor(cooldown / 60)
		local seconds = string.format("%02.f", math.floor(cooldown - minutes * 60))
		if hours >= 1 then
			minutes = math.floor(mod(cooldown, 3600) / 60)
			text = mMT:TC(hours .. "h " .. minutes .. "m", "red")
		else
			text = mMT:TC(minutes .. "m " .. seconds .. "s", "red")
		end
	elseif cooldown <= 0 then
		text = mMT:TC(L["Ready"], "green")
	end

	return text
end

local function GetSecureAttributes(id, kind)
	if kind == "spell" then return { type = "spell", spell = id } end
	if PlayerHasToy(id) then return { type = "toy", toy = id } end
	return { type = "item", item = "item:" .. id }
end

local function processTeleport(t, category, kindOverride)
	for id, idKind in pairs(t) do
		if id and id ~= "none" then
			local name, icon
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
					attributes = GetSecureAttributes(id, kind),
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

local function AddMageTeleports()
	if E.myfaction == "Alliance" then
		teleportsIDs.mage = {
			-- alliance
			[3561] = "spell", -- stormwind
			[3562] = "spell", -- ironforge
			[3565] = "spell", -- darnassus
			[32271] = "spell", -- exodar
			[33690] = "spell", -- shattrath
			[49359] = "spell", -- theramore
			[53140] = "spell", -- dalaran northrend
			[88342] = "spell", -- tol barad
			[132621] = "spell", -- vale of eternal blossoms
			[176248] = "spell", -- Stormshield
			[193759] = "spell", -- hall of the guardian
			[224869] = "spell", -- dalaran broken isles
			[281403] = "spell", -- boralus
			[344587] = "spell", -- oribos
			[395277] = "spell", -- valdrakken
			[446540] = "spell", -- dornogol
			[1259190] = "spell", -- silvermoon city
		}

		teleportsIDs.mageportals = {
			-- alliance
			[10059] = "spell", -- stormwind
			[11416] = "spell", -- ironforge
			[11419] = "spell", -- darnassus
			[32266] = "spell", -- exodar
			[49360] = "spell", -- theramore
			[33691] = "spell", -- shattrath
			[88345] = "spell", -- tol barad
			[120146] = "spell", -- ancient portal dalaran
			[132620] = "spell", -- vale of eternal blossoms
			[176246] = "spell", -- stormshield
			[281400] = "spell", -- boralus

			-- booth
			[53142] = "spell", -- dalaran northrend
			[224871] = "spell", -- dalaran broken isles
			[344597] = "spell", -- oribos
			[395289] = "spell", -- valdrakken
			[446534] = "spell", -- dornogal
			[1259194] = "spell", -- silvermoon city
		}
	else
		teleportsIDs.mage = {
			-- horde
			[10059] = "spell", -- stormwind
			[11416] = "spell", -- ironforge
			[11419] = "spell", -- darnassus
			[32266] = "spell", -- exodar
			[49360] = "spell", -- theramore
			[33691] = "spell", -- shattrath
			[53142] = "spell", -- dalaran northrend
			[88345] = "spell", -- tol barad
			[120146] = "spell", -- ancient portal dalaran
			[132620] = "spell", -- vale of eternal blossoms
			[176246] = "spell", -- stormshield
			[224871] = "spell", -- dalaran broken isles
			[281400] = "spell", -- boralus
			[344597] = "spell", -- oribos
			[395289] = "spell", -- valdrakken
			[446534] = "spell", -- dornogal
			[1259194] = "spell", -- silvermoon city
		}

		teleportsIDs.mageportals = {
			-- horde
			[11417] = "spell", -- orgrimmar
			[11418] = "spell", -- undercity
			[11420] = "spell", -- thunder bluff
			[32267] = "spell", -- silvermoon tbc
			[49361] = "spell", -- stonard
			[35717] = "spell", -- shattrath
			[88346] = "spell", -- tol barad
			[132626] = "spell", -- vale of eternal blossoms
			[176244] = "spell", -- warspear
			[281402] = "spell", -- dazarlor

			-- booth
			[53142] = "spell", -- dalaran northrend
			[224871] = "spell", -- dalaran broken isles
			[344597] = "spell", -- oribos
			[395289] = "spell", -- valdrakken
			[446534] = "spell", -- dornogal
			[1259194] = "spell", -- silvermoon city
		}
	end
end

function mMT:UpdateTeleports()
	AddMageTeleports()

	if E.db.mMediaTag.datatexts.teleports.favorites.enable then
		mMT.knownTeleports.favorites = {}
		teleportsIDs.favorites = {}
		-- add favorites
		for _, key in pairs({ "a", "b", "c", "d" }) do
			local favorite = E.db.mMediaTag.datatexts.teleports.favorites[key]
			if favorite and favorite.id ~= "none" then teleportsIDs.favorites[favorite.id] = favorite.kind end
		end
		processTeleport(teleportsIDs.favorites, "favorites")
	end

	processTeleport(teleportsIDs.engineering, "engineering")
	processTeleport(teleportsIDs.items, "items")
	processTeleport(teleportsIDs.spells, "spells")
	processTeleport(teleportsIDs.toys, "toys")
	processTeleport(teleportsIDs.hearthstones, "hearthstones")

	processTeleport(teleportsIDs.dungeonportals, "dungeonportals", "spell")
	processTeleport(teleportsIDs.season, "season", "spell")
	processTeleport(teleportsIDs.midnight, "midnight", "spell")
	processTeleport(teleportsIDs.tww, "tww", "spell")

	processTeleport(teleportsIDs.mage, "mage", "spell")
	processTeleport(teleportsIDs.mageportals, "mageportals", "spell")

	mMT.knownTeleports.other = mMT.knownTeleports.items.available or mMT.knownTeleports.spells.available
end

local seasonChallengeMaps = {
	-- midnight s2
	[1286801] = 584, -- BV - The Blinding Vale
	[1286804] = 585, -- VA - Voidscar Arena
	[1286807] = 586, -- DON - Den of Nalorakk
	[1286809] = 587, -- MR - Murder Row
	[1286812] = 588, -- AOF - Altar of Fangs
	[1286828] = 250, -- TOS - Temple of Sethraliss
	[1286831] = 249, -- KR - Kings' Rest
	[393256] = 399, -- RLP - Ruby Life Pools
}

-- season teleport into this instance (GetInstanceInfo instanceID or activity mapID), nil when there is none or it is not learned
function mMT:GetSeasonTeleport(instanceMapID)
	if not instanceMapID then return end

	for spellID, challengeMapID in pairs(seasonChallengeMaps) do
		if select(6, C_ChallengeMode.GetMapUIInfo(challengeMapID)) == instanceMapID then return IsSpellKnown(spellID) and spellID or nil end
	end
end

-- instance the season teleport leads into
function mMT:GetSeasonTeleportMapID(spellID)
	local challengeMapID = seasonChallengeMaps[spellID]
	return challengeMapID and select(6, C_ChallengeMode.GetMapUIInfo(challengeMapID))
end

-- any learned season teleport, for previews
function mMT:GetAnySeasonTeleport()
	for spellID in pairs(seasonChallengeMaps) do
		if IsSpellKnown(spellID) then return spellID end
	end
end

-- activityIDs is a secret table on M+ search results; indexing or branching on a secret throws, only issecretvalue may probe it.
local function PlainValue(value)
	if not E:IsSecretValue(value) then return value end
end

-- instance mapID of a search result or entry, the same value GetInstanceInfo reports as instanceID
local function GetActivityMapID(info)
	info = PlainValue(info)
	if not info then return end

	local ids = PlainValue(info.activityIDs)
	local activityID = (ids and PlainValue(ids[1])) or PlainValue(info.activityID)
	local activityInfo = activityID and C_LFGList.GetActivityInfoTable(activityID)
	return activityInfo and PlainValue(activityInfo.mapID)
end

local function GetSearchResultMapID(resultID)
	return GetActivityMapID(C_LFGList.GetSearchResultInfo(resultID))
end

-- the newest listing or accepted invite wins, so a key relisted after a run replaces the old one
local lfgTargetMapID
-- resultID -> mapID, read while applying because the leader usually delists before the group zones in
local pendingApps = {}

local function SeedLFGTarget()
	lfgTargetMapID = C_LFGList.HasActiveEntryInfo() and GetActivityMapID(C_LFGList.GetActiveEntryInfo()) or nil
	if lfgTargetMapID then return end

	for _, resultID in ipairs(C_LFGList.GetApplications() or {}) do
		local appStatus = PlainValue(select(2, C_LFGList.GetApplicationInfo(resultID)))
		if appStatus == "inviteaccepted" then
			lfgTargetMapID = GetSearchResultMapID(resultID)
			if lfgTargetMapID then return end
		elseif appStatus == "applied" or appStatus == "invited" then
			pendingApps[resultID] = GetSearchResultMapID(resultID)
		end
	end
end

local lfgFrame = CreateFrame("Frame")
lfgFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
lfgFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
lfgFrame:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE")
lfgFrame:RegisterEvent("LFG_LIST_JOINED_GROUP")
lfgFrame:RegisterEvent("CHALLENGE_MODE_START")
lfgFrame:RegisterEvent("GROUP_LEFT")
lfgFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
	if event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
		if arg2 == "applied" or arg2 == "invited" then
			pendingApps[arg1] = GetSearchResultMapID(arg1) or pendingApps[arg1]
		elseif arg2 == "inviteaccepted" then
			lfgTargetMapID = pendingApps[arg1] or GetSearchResultMapID(arg1)
			wipe(pendingApps)
		else
			pendingApps[arg1] = nil
		end
	elseif event == "LFG_LIST_JOINED_GROUP" then
		-- the joined group itself is the most reliable source, the same one the LFG invite card reads
		lfgTargetMapID = GetSearchResultMapID(arg1) or pendingApps[arg1] or lfgTargetMapID
		wipe(pendingApps)
	elseif event == "LFG_LIST_ACTIVE_ENTRY_UPDATE" then
		-- keep the target after a full group delists or when the entry can not be read, drop it when a solo listing is removed
		if C_LFGList.HasActiveEntryInfo() then
			lfgTargetMapID = GetActivityMapID(C_LFGList.GetActiveEntryInfo()) or lfgTargetMapID
		elseif not IsInGroup() then
			lfgTargetMapID = nil
		end
	elseif event == "CHALLENGE_MODE_START" then
		-- the running key is matched by instance, the group may have switched keys
		lfgTargetMapID = nil
	elseif event == "GROUP_LEFT" then
		lfgTargetMapID = nil
		wipe(pendingApps)
	elseif arg1 or arg2 then
		SeedLFGTarget()
	end
end)

-- instance fallback survives a reload inside the dungeon, where the group finder data is locked down
local function GetTargetMapID()
	if lfgTargetMapID then return lfgTargetMapID end
	if IsInInstance() then return select(8, GetInstanceInfo()) end
end

-- GetMapUIInfo 6th return (11.2.0) is the instance mapID
local function IsTargetDungeon(targetMapID, id)
	local challengeMapID = targetMapID and seasonChallengeMaps[id]
	return challengeMapID and select(6, C_ChallengeMode.GetMapUIInfo(challengeMapID)) == targetMapID or false
end

local function GetHighlightMapIDs()
	local highlight = E.db.mMediaTag.datatexts.teleports.highlight
	return highlight.current.enable and GetTargetMapID(), highlight.keystone.enable and C_MythicPlus.GetOwnedKeystoneChallengeMapID()
end

-- the current dungeon wins over the own keystone
local function GetHighlightName(targetMapID, keyMapID, id, name)
	local highlight = E.db.mMediaTag.datatexts.teleports.highlight
	if IsTargetDungeon(targetMapID, id) then return format("|c%s%s|r", highlight.current.color, name) end
	if keyMapID and seasonChallengeMaps[id] == keyMapID then return format("|c%s%s|r", highlight.keystone.color, name) end
	return name
end

local function CreateMenuEntry(id, t, name)
	name = name or t.name
	local text = t.short_name and ("[" .. mMT:TC(t.short_name, "mark") .. "] " .. name) or name

	return {
		text = text,
		right_text = t.cooldown,
		icon = t.icon,
		icon_size = ICON_SIZE,
		isTitle = false,
		tooltip = id,
		attributes = t.attributes,
		funcOnEnter = t.onEnter,
		funcOnLeave = LeaveFunc,
	}
end

local function GetRandomTeleportEntry(category)
	local selectedID, selectedTeleport, count
	count = 0
	if not category then return end

	for id, t in pairs(category) do
		if t and type(t) == "table" then
			count = count + 1
			if math.random(count) == 1 then
				selectedID = id
				selectedTeleport = t
			end
		end
	end

	return selectedID, selectedTeleport
end

local function UpdateMenus()
	mMT:UpdateTeleports()

	-- Initialize main menu
	menus.main = {}

	-- Add random menu entry
	if mMT.knownTeleports.hearthstones.available then
		local hearthstoneID, hearthstone = GetRandomTeleportEntry(mMT.knownTeleports.hearthstones)

		if hearthstone then
			tinsert(menus.main, { text = mMT:TC(L["Random"], "title"), isTitle = true, notClickable = true })
			tinsert(menus.main, CreateMenuEntry(hearthstoneID, hearthstone))
			tinsert(menus.main, { text = "", isTitle = true, notClickable = true })
		end
	end

	-- Add favorites menu entry
	if E.db.mMediaTag.datatexts.teleports.favorites.enable and mMT.knownTeleports.favorites.available then
		tinsert(menus.main, { text = mMT:TC(L["Favorite"], "title"), isTitle = true, notClickable = true })
		for id, t in pairs(mMT.knownTeleports.favorites) do
			if t and type(t) == "table" then tinsert(menus.main, CreateMenuEntry(id, t)) end
		end
		tinsert(menus.main, { text = "", isTitle = true, notClickable = true })
	end

	-- Add season portals menu entry
	if mMT.knownTeleports.season.available then
		local targetMapID, keyMapID = GetHighlightMapIDs()

		tinsert(menus.main, { text = mMT:TC(L["M+ Season"], "title"), isTitle = true, notClickable = true })
		for id, t in pairs(mMT.knownTeleports.season) do
			if t and type(t) == "table" then tinsert(menus.main, CreateMenuEntry(id, t, GetHighlightName(targetMapID, keyMapID, id, t.name))) end
		end
	end

	-- Add other portals menu entry
	if mMT.knownTeleports.tww.available or mMT.knownTeleports.dungeonportals.available or mMT.knownTeleports.toys.available or mMT.knownTeleports.engineering.available or mMT.knownTeleports.other then
		tinsert(menus.main, { text = "", isTitle = true, notClickable = true })
		tinsert(menus.main, { text = mMT:TC(L["Other Portals"], "title"), isTitle = true, notClickable = true })
	end

	-- Add midnight dungeon portals
	if mMT.knownTeleports.midnight.available then
		-- build submenu
		menus.midnight = {}

		for id, t in pairs(mMT.knownTeleports.midnight) do
			if t and type(t) == "table" then tinsert(menus.midnight, CreateMenuEntry(id, t)) end
		end

		-- main menu entry for midnight dungeon teleports
		tinsert(menus.main, {
			text = "Midnight",
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.midnight, mMT.submenu, mMT.menu, 260, 2, "midnight_dungeons")
			end,
		})
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
			text = "TWW",
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

	-- Add mage teleports
	if mMT.knownTeleports.mage.available then
		-- build submenu
		menus.mage = {}

		for id, t in pairs(mMT.knownTeleports.mage) do
			if t and type(t) == "table" then tinsert(menus.mage, CreateMenuEntry(id, t)) end
		end

		-- main menu entry for mage teleports
		tinsert(menus.main, {
			text = L["Mage Teleports"],
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.mage, mMT.submenu, mMT.menu, 260, 2, "mage")
			end,
		})
	end

	-- Add mage portals
	if mMT.knownTeleports.mageportals.available then
		-- build submenu
		menus.mageportals = {}

		for id, t in pairs(mMT.knownTeleports.mageportals) do
			if t and type(t) == "table" then tinsert(menus.mageportals, CreateMenuEntry(id, t)) end
		end

		-- main menu entry for mage portals
		tinsert(menus.main, {
			text = L["Mage Portals"],
			right_text = ">>",
			submenu = true,
			func = function(self)
				mMT:DropDown(menus.mageportals, mMT.submenu, mMT.menu, 260, 2, "mageportals")
			end,
		})
	end

	-- Add other entries
	if mMT.knownTeleports.other then
		-- build submenu
		menus.other = {}

		-- items
		if mMT.knownTeleports.items.available then
			tinsert(menus.other, { text = mMT:TC(L["Items"], "title"), isTitle = true, notClickable = true })
			for id, t in pairs(mMT.knownTeleports.items) do
				if t and type(t) == "table" then tinsert(menus.other, CreateMenuEntry(id, t)) end
			end
		end

		-- spells
		if mMT.knownTeleports.spells.available then
			tinsert(menus.other, { text = "", isTitle = true, notClickable = true })
			tinsert(menus.other, { text = mMT:TC(L["Spells"], "title"), isTitle = true, notClickable = true })
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
	if not E:AlertCombat() then
		if not mMT.menu then mMT:BuildMenus() end

		UpdateMenus()
		mMT:DropDown(menus.main, mMT.menu, self, 260, 2)
	end
end

local function BuildTipIcon(icon)
	return E:TextureString(icon, ":" .. ICON_SIZE .. ":" .. ICON_SIZE) .. " "
end
local function OnEnter(self)
	mMT:UpdateTeleports()

	DT.tooltip:ClearLines()

	local tipAdded = false

	-- Add favorites menu entry
	if E.db.mMediaTag.datatexts.teleports.favorites.enable and mMT.knownTeleports.favorites.available then
		DT.tooltip:AddLine(L["Favorites"], mMT:GetRGB("title"))
		for _, t in pairs(mMT.knownTeleports.favorites) do
			if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. mMT:TC(t.short_name and ("[" .. mMT:TC(t.short_name, "mark") .. "] " .. t.name) or t.name), t.cooldown) end
		end
		DT.tooltip:AddLine(" ")
		tipAdded = true
	else
		DT.tooltip:AddLine(L["You can select your favourites in the settings."], mMT:GetRGB())
		DT.tooltip:AddLine(" ")
	end

	-- Add season menu entry
	if mMT.knownTeleports.season.available then
		local targetMapID, keyMapID = GetHighlightMapIDs()

		DT.tooltip:AddLine(L["Season Teleports"], mMT:GetRGB("title"))
		for id, t in pairs(mMT.knownTeleports.season) do
			if t and type(t) == "table" then
				local name = GetHighlightName(targetMapID, keyMapID, id, t.name)
				DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. mMT:TC(t.short_name and ("[" .. mMT:TC(t.short_name, "mark") .. "] " .. name) or name), t.cooldown)
			end
		end
		DT.tooltip:AddLine(" ")
		tipAdded = true
	end

	-- Add season menu entry
	if mMT.knownTeleports.midnight.available then
		DT.tooltip:AddLine(L["Midnight"], mMT:GetRGB("title"))
		for _, t in pairs(mMT.knownTeleports.midnight) do
			if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. mMT:TC(t.short_name and ("[" .. mMT:TC(t.short_name, "mark") .. "] " .. t.name) or t.name), t.cooldown) end
		end
		DT.tooltip:AddLine(" ")
		tipAdded = true
	end

	if not tipAdded and (mMT.knownTeleports.other or mMT.knownTeleports.toys) then
		if mMT.knownTeleports.items.available then
			DT.tooltip:AddLine(L["Items"], mMT:GetRGB("title"))
			for _, t in pairs(mMT.knownTeleports.items) do
				if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. mMT:TC(t.name), t.cooldown) end
			end
			DT.tooltip:AddLine(" ")
		end

		if mMT.knownTeleports.toys.available then
			DT.tooltip:AddLine(L["Toys"], mMT:GetRGB("title"))
			for _, t in pairs(mMT.knownTeleports.toys) do
				if t and type(t) == "table" then DT.tooltip:AddDoubleLine(BuildTipIcon(t.icon) .. mMT:TC(t.name), t.cooldown) end
			end
			DT.tooltip:AddLine(" ")
		end
	elseif not tipAdded then
		DT.tooltip:AddLine(L["You currently have no important teleports."], mMT:GetRGB())
		DT.tooltip:AddLine(" ")
	end

	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. L["Left click to open the Teleports menu."], mMT:GetRGB("tip"))
	DT.tooltip:Show()
end

local function OnEvent(self)
	local iconPath = E.db.mMediaTag.datatexts.teleports.icon
	local label = L["Teleports"]

	if iconPath ~= "none" then
		label = E:TextureString(MEDIA.icons.datatexts.teleport[iconPath] or "Interface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga", ":" .. ICON_SIZE .. ":" .. ICON_SIZE) .. " " .. label
	end

	self.text:SetFormattedText(textString, label)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMediaTag.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	textString = strjoin("", textHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mMT - Teleports", mMT.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Teleports"], nil, ValueColorUpdate)
