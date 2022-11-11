local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local tinsert = tinsert
local format = format
local wipe = wipe

--WoW API / Variables
local _G = _G

--Variables
local mText = L["Teleports"]
local index = 1
local menuFrame = CreateFrame("Frame", "mMediaTag_Teleports_Menu", E.UIParent, "BackdropTemplate")
menuFrame:SetTemplate("Transparent", true)

local TeleportsToys = {
	193588, --Timewalker's Hearthstone
	163045, --headless-horsemans-hearthstone
	119211, --golden-hearthstone-card-lord-jaraxxus
	188952, --dominated-hearthstone
	168907, --holographic-digitalization-hearthstone
	172179, --eternal-travelers-hearthstone
	184353, --kyrian-hearthstone
	180290, --night-fae-hearthstone
	182773, --necrolord-hearthstone
	165670, --peddlefeets-lovely-hearthstone
	162973, --greatfather-winters-hearthstone
	166746, --fire-eaters-hearthstone
	200630, --ohnir-windsages-hearthstone
	119210, --hearthstone-board
	165669, --lunar-elders-hearthstone
	166747, --brewfest-revelers-hearthstone
	165802, --noble-gardeners-hearthstone
	118427, --autographed-hearthstone-card
	190196, --enlightened-hearthstone
}

local TeleportsEngineering = {
	48933, --wormhole-generator-northrend
	87215, --wormhole-generator-pandaria
	112059, --wormhole-centrifuge
	151652, --wormhole-generator-argus
	168807,
	--wormhole-generator-kultiras
	168808,
	--wormhole-generator-zandalar
	172924, --wormhole-generator-shadowlands
}

local TeleportsItems = {
	6948, --hearthstone
	22630, --atiesh-greatstaff-of-the-guardian
	22631, --atiesh-greatstaff-of-the-guardian
	22632, --atiesh-greatstaff-of-the-guardian
	22589, --atiesh-greatstaff-of-the-guardian
	54452, --ethereal-portal
	93672, --dark-portal
	184871, --dark-portal 2?
	110560, --garrison-hearthstone
	140192, --dalaran-hearthstone
	141605, --flight-masters-whistle
	128353,
	--admirals-compass
	18984, --dimensional-ripper-everlook
	18986, --ultrasafe-transporter-gadgetzan
	30542, --dimensional-ripper-area-52
	30544, --ultrasafe-transporter-toshleys-station
	32757, --blessed-medallion-of-karabor
	40585, --signet-of-the-kirin-tor
	40586, --band-of-the-kirin-tor
	48954, --etched-band-of-the-kirin-tor
	48955, --etched-loop-of-the-kirin-tor
	48956, --etched-ring-of-the-kirin-tor
	48957, --etched-signet-of-the-kirin-tor
	45688, --inscribed-band-of-the-kirin-tor
	45689, --inscribed-loop-of-the-kirin-tor
	45690, --inscribed-ring-of-the-kirin-tor
	45691, --inscribed-signet-of-the-kirin-tor
	44934, --loop-of-the-kirin-tor
	44935, --ring-of-the-kirin-tor
	51557, --runed-signet-of-the-kirin-tor
	51558, --runed-loop-of-the-kirin-tor
	51559, --runed-ring-of-the-kirin-tor
	51560, --runed-band-of-the-kirin-tor
	139599, --empowered-ring-of-the-kirin-tor
	63206, --wrap-of-unity
	63207, --wrap-of-unity
	63352, --shroud-of-cooperation
	63353, --shroud-of-cooperation
	65274, --cloak-of-coordination
	65360, --cloak-of-coordination
	46874, --argent-crusaders-tabard
	63378, --hellscreams-reach-tabard
	63379, --baradins-wardens-tabard
	28585, --ruby-slippers
	32757, --blessed-medallion-of-karabor
	37863, --direbrews-remote
	43824,
	--the-schools-of-arcane-magic-mastery
	50287, --boots-of-the-bay
	52251, --jainas-locket
	64457, --the-last-relic-of-argus
	95050, --the-brassiest-knuckle
	95051, --the-brassiest-knuckle
	103678, --time-lost-artifact
	118663,
	--relic-of-karabor
	118907, --pit-fighters-punching-ring
	118908, --pit-fighters-punching-ring
	129276,
	--beginners-guide-to-dimensional-rifting
	128502,
	--hunters-seeking-crystal
	138448,
	--emblem-of-margoss
	142298, --astonishingly-scarlet-slippers
	142469, --violet-seal-of-the-grand-magus
	144391, --pugilists-powerful-punching-ring
	151016, --fractured-necrolyte-skull
	180817, --cypher-of-relocation
	29796, --socrethars-teleportation-stone
	61379, --gidwins-hearthstone
	68808, --heros-hearthstone
	68809, --veterans-hearthstone
	92510, --voljins-hearthstone
	35230, --darnarians-scroll-of-teleportation
	119183, --scroll-of-risky-recall
	139590, --scroll-of-teleport-ravenholdt
	141015, --scroll-of-town-portal-kaldelar
	141014, --scroll-of-town-portal-sashjtar
	141017, --scroll-of-town-portal-liantril
	141016, --scroll-of-town-portal-faronaar
	141013, --scroll-of-town-portal-shalanir
	142543, --scroll-of-town-portal
	95567, --kirin-tor-beacon
	95568, --sunreaver-beacon
	37118, --scroll-of-recall
	44314, --scroll-of-recall-ii
	44315, --scroll-of-recall-iii
	58487, --potion-of-deepholm
	17690, --frostwolf-insignia-rank-1
	17691, --stormpike-insignia-rank-1
	17900, --stormpike-insignia-rank-2
	17901, --stormpike-insignia-rank-3
	17902, --stormpike-insignia-rank-4
	17903, --stormpike-insignia-rank-5
	17904, --stormpike-insignia-rank-6
	17905, --frostwolf-insignia-rank-2
	17906, --frostwolf-insignia-rank-3
	17907, --frostwolf-insignia-rank-4
	17908, --frostwolf-insignia-rank-5
	17909, --frostwolf-insignia-rank-6
}
local TeleportsSpells = {
	556, --astral-recall
	50977, --death-gate
	126892, --zen-pilgrimage
	193753, --dreamwalk
	193759, --teleport-hall-of-the-guardian
	131204, --path-of-the-jade-serpent
	131205, --path-of-the-stout-brew
	131206, --path-of-the-shado-pan
	131222, --path-of-the-mogu-king
	131225, --path-of-the-setting-sun
	131228, --path-of-the-black-ox
	131229, --path-of-the-scarlet-mitre
	131231, --path-of-the-scarlet-blade
	131232, --path-of-the-necromancer
	159895, --path-of-the-bloodmaul
	159896, --path-of-the-iron-prow
	159897, --path-of-the-vigilant
	159899, --path-of-the-crescent-moon
	159901, --path-of-the-verdant
	159902, --path-of-the-burning-mountain
	354462, --path-of-the-courageous
	354463, --path-of-the-plagued
	354464, --path-of-the-misty-forest
	354465, --path-of-the-sinful-soul
	354467, --path-of-the-undefeated
	354468, --path-of-the-scheming-loa
	354469, --path-of-the-stone-warden
	373190, --path-of-the-sire
	373191, --path-of-the-tormented-soul
	373192, --path-of-the-first-ones
	393222, --path-of-the-watchers-legacy
	393273, --path-of-the-draconic-diploma
	393256, --path-of-the-clutch-defender
	393262, --path-of-the-windswept-plains
	393283, --path-of-the-titanic-reservoir
	393276, --path-of-the-obsidian-hoard
	393279, --path-of-arcane-secrets
	393764, --path-of-proven-worth
	393766, --path-of-the-grand-magistrix
	393267, --path-of-the-rotting-woods
}

local Season_List = {
	367416, --path-of-the-streetwise-merchant
	159900, --path-of-the-dark-rail
	159898, --path-of-the-skies
	373274, --path-of-the-scrappy-prince
	373262, --path-of-the-fallen-guardian
}

local SLDungeons_List = {
	354462, --path-of-the-courageous
	354463, --path-of-the-plagued
	354464, --path-of-the-misty-forest
	354465, --path-of-the-sinful-soul
	354467, --path-of-the-undefeated
	354468, --path-of-the-scheming-loa
	354469, --path-of-the-stone-warden
	367416, --path-of-the-streetwise-merchant
}

local mTP_List = {}

local function LeaveFunc(btn)
	GameTooltip:Hide()
end

local function mMenuAdd(tbl, ind, text, time, macro, icon, tooltip, funcOnEnter)
	tinsert(
		tbl,
		ind,
		{
			text = text,
			Secondtext = time,
			icon = icon,
			isTitle = false,
			tooltip = tooltip,
			macro = macro,
			funcOnEnter = funcOnEnter,
			funcOnLeave = LeaveFunc,
		}
	)
end

local function mOnEnterItem(btn)
	GameTooltip:SetOwner(btn, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:SetItemByID(btn.tooltip)
	GameTooltip:Show()
end

local function mOnEnterSpell(btn)
	GameTooltip:SetOwner(btn, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:SetSpellByID(btn.tooltip)
	GameTooltip:Show()
end

local function mGetInfos(TeleportsTable, spell, ttip)
	for i, v in pairs(TeleportsTable) do
		local texture, name, nametext, hasSpell, hasItem  = false, nil, nil, false, 0
		if spell then
			texture = GetSpellTexture(v)
			name = GetSpellInfo(v)
			hasSpell = IsSpellKnown(v)
		else
			texture = GetItemIcon(v)
			name = GetItemInfo(v)
			hasItem = GetItemCount(v)
		end

		if name and not ttip then
			nametext = name
			name = mMT:mAbbrev(name)
		end

		local text1, text2 = nil, nil
		if (texture and name and (hasItem > 0 or (E.Retail and PlayerHasToy(v) and C_ToyBox.IsToyUsable(v)))) or (texture and name and hasSpell) then
			local start, duration = nil, nil
			if spell then
				start, duration = GetSpellCooldown(v)
			else
				start, duration = GetItemCooldown(v)
			end
			local cooldown = start + duration - GetTime()
			if cooldown >= 2 then
				local hours = math.floor(cooldown / 3600)
				local minutes = math.floor(cooldown / 60)
				local seconds = string.format("%02.f", math.floor(cooldown - minutes * 60))
				if hours >= 1 then
					minutes = math.floor(mod(cooldown, 3600) / 60)
					text1 = "|cffdb3030" .. name .. "|r"
					text2 = "|cffdb3030" .. hours .. "h " .. minutes .. "m|r"
				else
					text1 = "|cffdb3030" .. name .. "|r"
					text2 = "|cffdb3030" .. minutes .. "m " .. seconds .. "s|r"
				end
			elseif cooldown <= 0 then
				text1 = "|cffffffff" .. name .. "|r"
				text2 = "|cff00FF00" .. L["Ready"] .. "|r"
			end

			if text1 and text2 then
				if ttip then
					DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", texture, text1),text2)
				elseif spell then
					mMenuAdd(mTP_List, index, text1, text2, "/cast " .. nametext, texture, v, function(btn)
						mOnEnterSpell(btn)
					end)
					index = index + 1
				else
					mMenuAdd(mTP_List, index, text1, text2, "/use " .. nametext, texture, v, function(btn)
						mOnEnterItem(btn)
					end)
					index = index + 1
				end
			end
		end
	end
end

local function EngineeringCheck()
	local prof1, prof2 = GetProfessions()
	prof1 = select(7, GetProfessionInfo(prof1))
	prof2 = select(7, GetProfessionInfo(prof2))

	return prof1 == 202 or prof2 == 202
end

local menuFrame_Season = CreateFrame("Frame", "mMediaTag_Teleports_Menu_Season", menuFrame, "BackdropTemplate")
menuFrame:SetTemplate("Transparent", true)

local function mUpdateTPList()
	local _, _, _, _, _, titel = mMT:mColorDatatext()
	mTP_List = {}
	index = 1
	tinsert(mTP_List, index, { lefttext = format("%s%s|r", titel, L["Toys"]), isTitle = true })
	index = index + 1

	mGetInfos(TeleportsToys, false, false)

	tinsert(mTP_List, index, { lefttext = "", isTitle = true })
	index = index + 1

	if EngineeringCheck() then
		tinsert(mTP_List, index, { lefttext = format("%s%s|r", titel, L["Engineering"]), isTitle = true })
		index = index + 1
		mGetInfos(TeleportsEngineering, false, false)
	end

	tinsert(mTP_List, index, { lefttext = "", isTitle = true })
	index = index + 1
	tinsert(mTP_List, index, { lefttext = format("%s%s|r", titel, L["Other"]), isTitle = true })
	index = index + 1

	mGetInfos(TeleportsItems, false, false)
	mGetInfos(TeleportsSpells, true, false)
end

local function OnClick(self, button)
	mUpdateTPList()
	mMT:mDropDown(mTP_List, menuFrame, self, 200, 2)
end

local function mTPTooltip()
	DT.tooltip:AddLine(L["Toys"])
	mGetInfos(TeleportsToys, false, true)

	if EngineeringCheck() then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Engineering"])
		mGetInfos(TeleportsEngineering, false, true)
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["M+ Season"])
	mGetInfos(Season_List, true, true)

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["SL Dungeons"])
	mGetInfos(SLDungeons_List, true, true)

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["Other"])
	mGetInfos(TeleportsItems, false, true)
	mGetInfos(TeleportsSpells, true, true)
end

local function OnEnter(self)
	DT.tooltip:ClearLines()
	mTPTooltip()
	DT.tooltip:Show()
end

local function OnEvent(self, event, unit)
	local TextString = mText
	self.text:SetFormattedText(mMT:mClassColorString(), TextString)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mTeleports", "mMediaTag", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
