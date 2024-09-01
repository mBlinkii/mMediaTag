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
			[110560] = true, --garrison-hearthstone
			[140192] = true, --dalaran-hearthstone
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
			[193588] = true, --Timewalker's Hearthstone
			[200630] = true, --ohnir-windsages-hearthstone
			[208704] = true, -- Deepdweller's Earthen Hearthstone
			[209035] = true, -- hearthstone-of-the-flame
			[212337] = true, -- Stone of the Hearth (Hearthstone 10th Anniversary)
			[210455] = true, -- Draenic Hologem
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
		},
	},
	items = {
		available = false,
		tps = {
			[6948] = true, --hearthstone
			[95568] = true, --sunreaver-beacon
			[95567] = true, --kirin-tor-beacon
			[95051] = true, --the-brassiest-knuckle
			[95050] = true, --the-brassiest-knuckle
			[93672] = true, --dark-portal
			[92510] = true, --voljins-hearthstone
			[68809] = true, --veterans-hearthstone
			[68808] = true, --heros-hearthstone
			[65360] = true, --cloak-of-coordination
			[65274] = true, --cloak-of-coordination
			[64457] = true, --the-last-relic-of-argus
			[63379] = true, --baradins-wardens-tabard
			[63378] = true, --hellscreams-reach-tabard
			[63353] = true, --shroud-of-cooperation
			[63352] = true, --shroud-of-cooperation
			[63207] = true, --wrap-of-unity
			[63206] = true, --wrap-of-unity
			[61379] = true, --gidwins-hearthstone
			[58487] = true, --potion-of-deepholm
			[54452] = true, --ethereal-portal
			[52251] = true, --jainas-locket
			[51560] = true, --runed-band-of-the-kirin-tor
			[51559] = true, --runed-ring-of-the-kirin-tor
			[51558] = true, --runed-loop-of-the-kirin-tor
			[51557] = true, --runed-signet-of-the-kirin-tor
			[50287] = true, --boots-of-the-bay
			[48957] = true, --etched-signet-of-the-kirin-tor
			[48956] = true, --etched-ring-of-the-kirin-tor
			[48955] = true, --etched-loop-of-the-kirin-tor
			[48954] = true, --etched-band-of-the-kirin-tor
			[46874] = true, --argent-crusaders-tabard
			[45691] = true, --inscribed-signet-of-the-kirin-tor
			[45690] = true, --inscribed-ring-of-the-kirin-tor
			[45689] = true, --inscribed-loop-of-the-kirin-tor
			[45688] = true, --inscribed-band-of-the-kirin-tor
			[44935] = true, --ring-of-the-kirin-tor
			[44934] = true, --loop-of-the-kirin-tor
			[44315] = true, --scroll-of-recall-iii
			[44314] = true, --scroll-of-recall-ii
			[43824] = true, --the-schools-of-arcane-magic-mastery
			[40586] = true, --band-of-the-kirin-tor
			[40585] = true, --signet-of-the-kirin-tor
			[37863] = true, --direbrews-remote
			[37118] = true, --scroll-of-recall
			[35230] = true, --darnarians-scroll-of-teleportation
			[32757] = true, --blessed-medallion-of-karabor
			[30544] = true, --ultrasafe-transporter-toshleys-station
			[30542] = true, --dimensional-ripper-area-52
			[29796] = true, --socrethars-teleportation-stone
			[28585] = true, --ruby-slippers
			[22632] = true, --atiesh-greatstaff-of-the-guardian
			[22631] = true, --atiesh-greatstaff-of-the-guardian
			[22630] = true, --atiesh-greatstaff-of-the-guardian
			[22589] = true, --atiesh-greatstaff-of-the-guardian
			[18986] = true, --ultrasafe-transporter-gadgetzan
			[18984] = true, --dimensional-ripper-everlook
			[184871] = true, --dark-portal 2?
			[180817] = true, --cypher-of-relocation
			[17909] = true, --frostwolf-insignia-rank-6
			[17908] = true, --frostwolf-insignia-rank-5
			[17907] = true, --frostwolf-insignia-rank-4
			[17906] = true, --frostwolf-insignia-rank-3
			[17905] = true, --frostwolf-insignia-rank-2
			[17904] = true, --stormpike-insignia-rank-6
			[17903] = true, --stormpike-insignia-rank-5
			[17902] = true, --stormpike-insignia-rank-4
			[17901] = true, --stormpike-insignia-rank-3
			[17900] = true, --stormpike-insignia-rank-2
			[17691] = true, --stormpike-insignia-rank-1
			[17690] = true, --frostwolf-insignia-rank-1
			[151016] = true, --fractured-necrolyte-skull
			[144391] = true, --pugilists-powerful-punching-ring
			[142543] = true, --scroll-of-town-portal
			[142469] = true, --violet-seal-of-the-grand-magus
			[142298] = true, --astonishingly-scarlet-slippers
			[141605] = true, --flight-masters-whistle
			[141017] = true, --scroll-of-town-portal-liantril
			[141016] = true, --scroll-of-town-portal-faronaar
			[141015] = true, --scroll-of-town-portal-kaldelar
			[141014] = true, --scroll-of-town-portal-sashjtar
			[141013] = true, --scroll-of-town-portal-shalanir
			[139599] = true, --empowered-ring-of-the-kirin-tor
			[139590] = true, --scroll-of-teleport-ravenholdt
			[138448] = true, --emblem-of-margoss
			[129276] = true, --beginners-guide-to-dimensional-rifting
			[128502] = true, --hunters-seeking-crystal
			[128353] = true, --admirals-compass
			[119183] = true, --scroll-of-risky-recall
			[118908] = true, --pit-fighters-punching-ring
			[118907] = true, --pit-fighters-punching-ring
			[118663] = true, --relic-of-karabor
			[103678] = true, --time-lost-artifact
			[219222] = true, --Time-Lost Artifact
		},
	},
	spells = {
		available = false,
		tps = {
			[556] = true, --astral-recall
			[50977] = true, --death-gate
			[193759] = true, --teleport-hall-of-the-guardian
			[193753] = true, --dreamwalk
			[126892] = true, --zen-pilgrimage
			[265225] = true, -- Mole Machine
		},
	},
	season = {
		available = false,
		tps = {
			-- S1
			[442929] = "ARA", --teleport-ara-kara-city-of-echoes
			[442927] = "COT", --teleport-city-of-threads
			[442931] = "DB", --teleport-the-dawnbreaker
			[442926] = "SV", --teleport-the-stonevault
			[272264] = "SOB", --teleport-siege-of-boralus
			[396121] = "GB", --teleport-grim-batol
			[348533] = "true", --teleport-mists-of-tirna-scithe
			[348529] = "NW", --teleport-the-necrotic-wake
		},
	},

	tww = {
		available = false,
		tps = {
			[442929] = "ARA", --teleport-ara-kara-city-of-echoes
			[442927] = "COT", --teleport-city-of-threads
			[442931] = "DB", --teleport-the-dawnbreaker
			[442926] = "SV", --teleport-the-stonevault
			[442932] = "CM", --teleport-cinderbrew-meadery
			[442930] = "DC", --teleport-darkflame-cleft
			[442923] = "POSF", --teleport-priory-of-the-sacred-flame
			[442925] = "ROK", --teleport-the-rookery
		},
	},

	dungeonportals = {
		available = false,
		tps = {
			[131204] = true, --path-of-the-jade-serpent
			[131205] = true, --path-of-the-stout-brew
			[131206] = true, --path-of-the-shado-pan
			[131222] = true, --path-of-the-mogu-king
			[131225] = true, --path-of-the-setting-sun
			[131228] = true, --path-of-the-black-ox
			[131229] = true, --path-of-the-scarlet-mitre
			[131231] = true, --path-of-the-scarlet-blade
			[131232] = true, --path-of-the-necromancer
			[159895] = true, --path-of-the-bloodmaul
			[159896] = true, --path-of-the-iron-prow
			[159897] = true, --path-of-the-vigilant
			[159898] = true, --path-of-the-skies
			[159899] = true, --path-of-the-crescent-moon
			[159900] = true, --path-of-the-dark-rail
			[159901] = "EB", --path-of-the-verdant
			[159902] = true, --path-of-the-burning-mountain
			[354462] = true, --path-of-the-courageous
			[354463] = true, --path-of-the-plagued
			[354464] = true, --path-of-the-misty-forest
			[354465] = true, --path-of-the-sinful-soul
			[354467] = true, --path-of-the-undefeated
			[354468] = true, --path-of-the-scheming-loa
			[354469] = true, --path-of-the-stone-warden
			[367416] = true, --path-of-the-streetwise-merchant
			[373190] = true, --path-of-the-sire
			[373191] = true, --path-of-the-tormented-soul
			[373192] = true, --path-of-the-first-ones
			[373262] = true, --path-of-the-fallen-guardian
			[373274] = true, --path-of-the-scrappy-prince
			[424197] = "DOTI", --teleport-dawn-of-the-infinite
			[393222] = "ULD", --path-of-the-watchers-legacy
			[393256] = "RLP", --path-of-the-clutch-defender
			[393262] = "NO", --path-of-the-windswept-plains
			[393267] = "BH", --path-of-the-rotting-woods
			[393273] = "AA", --path-of-the-draconic-diploma
			[393276] = "NELT", --path-of-the-obsidian-hoard
			[393279] = "AV", --path-of-arcane-secrets
			[393283] = "HOI", --path-of-the-titanic-reservoir
			[393764] = true, --path-of-proven-worth
			[393766] = true, --path-of-the-grand-magistrix
			[410071] = "FH", -- path-of-the-freebooter
			[410074] = "UNDR", -- path-of-festering-rot
			[410078] = "NL", -- path-of-the-earth-warder
			[410080] = "VP", -- path-of-winds-domain
			[424167] = "WM", --path-of-hearts-bane
			[424187] = "AD", --path-of-the-golden-tomb
			[424163] = "DH", --path-of-the-nightmare-lord
			[424153] = "BRH", --path-of-ancient-horrors
			[424142] = "TOT", --path-of-the-tidehunter
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
					if type(v) == "string" then
						text1 = "[|CFF00AAFF" .. v .. "|r] " .. text1
					end

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
	if prof1 then
		prof1 = select(7, GetProfessionInfo(prof1))
	end

	if prof2 then
		prof2 = select(7, GetProfessionInfo(prof2))
	end

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
