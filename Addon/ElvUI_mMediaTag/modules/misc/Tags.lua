local E, L = unpack(ElvUI)

local format, floor, tostring = format, floor, tostring

local CreateTextureMarkup = CreateTextureMarkup
local GetInstanceInfo = GetInstanceInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetTime = GetTime
local IsInInstance = IsInInstance
local IsResting = IsResting
local UnitBattlePetLevel = UnitBattlePetLevel
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitFactionGroup = UnitFactionGroup
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitGUID = UnitGUID
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsAFK = UnitIsAFK
local UnitIsBattlePetCompanion = UnitIsBattlePetCompanion
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsDND = UnitIsDND
local UnitIsGhost = UnitIsGhost
local UnitIsPlayer = UnitIsPlayer
local UnitIsPVP = UnitIsPVP
local UnitIsUnit = UnitIsUnit
local UnitIsWildBattlePet = UnitIsWildBattlePet
local UnitLevel = UnitLevel
local UnitName = UnitName
local TANK, HEALER = TANK, HEALER
local UnitFaction = {}

-- fallback colors
local colors = {
	rare = "|cffffffff",
	relite = "|cffffffff",
	elite = "|cffffffff",
	boss = "|cffffffff",
	afk = "|cffffffff",
	dnd = "|cffffffff",
	zzz = "|cffffffff",
	tank = "|cffffffff",
	heal = "|cffffffff",
	level = "|cffffffff",
}

-- fallback icons
local icons = {
	rare = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	relite = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	elite = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	boss = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	afk = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	dnd = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	dc = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	death = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	ghost = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	pvp = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\pvp.tga"),
	tank = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	heal = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	dd = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	quest = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\quest1.tga"),
}

local BossIDs = {
	-- DF Dungeons
	["189719"] = true,
	["189722"] = true,
	["189727"] = true,
	["189729"] = true,

	["186116"] = true,
	["186120"] = true,
	["186121"] = true,
	["186122"] = true,
	["186124"] = true,
	["186125"] = true,

	["184018"] = true,
	["184124"] = true,
	["184125"] = true,
	["184422"] = true,
	["184580"] = true,
	["184581"] = true,
	["184582"] = true,

	["181861"] = true,
	["189340"] = true,
	["189478"] = true,
	["189901"] = true,

	["188252"] = true,
	["189232"] = true,
	["190484"] = true,
	["190485"] = true,

	["186151"] = true,
	["186338"] = true,
	["186339"] = true,
	["186615"] = true,
	["186616"] = true,

	["186644"] = true,
	["186737"] = true,
	["186738"] = true,
	["186739"] = true,

	["190609"] = true,
	["191736"] = true,
	["194181"] = true,
	["196482"] = true,

	-- S2 Dungeons
	["91003"] = true,
	["91004"] = true,
	["91005"] = true,
	["91007"] = true,

	["126832"] = true,
	["126845"] = true,
	["126847"] = true,
	["126848"] = true,
	["126969"] = true,
	["126983"] = true,

	["133007"] = true,
	["131817"] = true,
	["131383"] = true,
	["131318"] = true,

	["43873"] = true,
	["43875"] = true,
	["43878"] = true,

	-- DF Dawn of the Infinite
	["198997"] = true,
	["198999"] = true,
	["198996"] = true,
	["201788"] = true,
	["201790"] = true,
	["201792"] = true,
	["198933"] = true,
	["198995"] = true,
	["198998"] = true,
	["209207"] = true,
	["209208"] = true,
	["199000"] = true,

	-- DF Worldboss
	["193532"] = true,
	["193533"] = true,
	["193534"] = true,
	["193535"] = true,
	["199853"] = true,
	["203220"] = true,

	-- DF Raid Vault of the Incarnates
	["184972"] = true,
	["184986"] = true,
	["187767"] = true,
	["187768"] = true,
	["187771"] = true,
	["187772"] = true,
	["187967"] = true,
	["189492"] = true,
	["189813"] = true,
	["190245"] = true,
	["190496"] = true,

	-- DF Raid Aberrus
	["199659"] = true,
	["200912"] = true,
	["200913"] = true,
	["200918"] = true,
	["201261"] = true,
	["201320"] = true,
	["201579"] = true,
	["201773"] = true,
	["201774"] = true,
	["201934"] = true,
	["202637"] = true,
	["204223"] = true,
	["205319"] = true,
}

function mMT:UpdateTagSettings()
	colors = {
		rare = E.db.mMT.tags.colors.rare.hex,
		relite = E.db.mMT.tags.colors.relite.hex,
		elite = E.db.mMT.tags.colors.elite.hex,
		boss = E.db.mMT.tags.colors.boss.hex,
		afk = E.db.mMT.tags.colors.afk.hex,
		dnd = E.db.mMT.tags.colors.dnd.hex,
		zzz = E.db.mMT.tags.colors.zzz.hex,
		tank = E.db.mMT.tags.colors.tank.hex,
		heal = E.db.mMT.tags.colors.heal.hex,
		level = E.db.mMT.tags.colors.level.hex,
	}

	icons = {
		rare = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.rare]),
		relite = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.relite]),
		elite = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.elite]),
		boss = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.boss]),
		afk = format("|T%s:15:15:0:2|t", mMT.Media.AFKIcons[E.db.mMT.tags.icons.afk]),
		dnd = format("|T%s:15:15:0:2|t", mMT.Media.DNDIcons[E.db.mMT.tags.icons.dnd]),
		dc = format("|T%s:15:15:0:2|t", mMT.Media.DCIcons[E.db.mMT.tags.icons.offline]),
		death = format("|T%s:15:15:0:2|t", mMT.Media.DeathIcons[E.db.mMT.tags.icons.death]),
		ghost = format("|T%s:15:15:0:2|t", mMT.Media.GhostIcons[E.db.mMT.tags.icons.ghost]),
		pvp = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\pvp.tga"),
		tank = E:TextureString(E.Media.Textures.Tank, ":15:15"),
		heal = E:TextureString(E.Media.Textures.Healer, ":15:15"),
		dd = E:TextureString(E.Media.Textures.DPS, ":15:15"),
		quest = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\quest1.tga"),
	}
	if E.db.mMT.roleicons.enable then
		if E.db.mMT.roleicons.customtexture then
			icons.tank = E:TextureString(E.db.mMT.roleicons.customtank, ":15:15")
			icons.heal = E:TextureString(E.db.mMT.roleicons.customtheal, ":15:15")
			icons.dd = E:TextureString(E.db.mMT.roleicons.customdd, ":15:15")
		else
			icons.tank = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.tank], ":15:15")
			icons.heal = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.heal], ":15:15")
			icons.dd = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.dd], ":15:15")
		end
	end
end

local function ShortName(name)
	local WordA, WordB, WordC, WordD, WordE, WordF, WordG = strsplit(" ", name, 6)
	return WordG or WordF or WordE or WordD or WordC or WordB or WordA or name
end

for textFormat, length in pairs({ veryshort = 5, short = 10, medium = 15, long = 20 }) do
	E:AddTag(format("mName:last:%s", textFormat), "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local name = UnitName(unit)
		if name and strfind(name, "%s") then
			name = ShortName(name)
		end

		if name then
			return E:ShortenString(name, length)
		end
	end)

	E:AddTag(format("mName:last:onlyininstance:%s", textFormat), "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local name = UnitName(unit)
		local inInstance, InstanceType = IsInInstance()
		if name and strfind(name, "%s") then
			name = inInstance and ShortName(name) or E.TagFunctions.Abbrev(name)
		end

		if name then
			return E:ShortenString(name, length)
		end
	end)

	E:AddTag(format("mName:statusicon:%s", textFormat), "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local name = UnitName(unit)
		if UnitIsAFK(unit) or UnitIsDND(unit) or (not UnitIsConnected(unit)) or (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
			return _TAGS["mStatus:icon"](unit)
		elseif name then
			return E:ShortenString(name, length)
		end
	end)

	E:AddTag(format("mName:status:%s", textFormat), "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local name = UnitName(unit)
		if UnitIsAFK(unit) or UnitIsDND(unit) or (not UnitIsConnected(unit)) or (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
			return _TAGS.mStatus(unit)
		elseif name then
			return E:ShortenString(name, length)
		end
	end)
end

E:AddTag("mName:statusicon", "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local name = UnitName(unit)
	if UnitIsAFK(unit) or UnitIsDND(unit) or (not UnitIsConnected(unit)) or (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return _TAGS["mStatus:icon"](unit)
	elseif name then
		return name
	end
end)

E:AddTag("mName:status", "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local name = UnitName(unit)
	if UnitIsAFK(unit) or UnitIsDND(unit) or (not UnitIsConnected(unit)) or (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return _TAGS.mStatus(unit)
	elseif name then
		return name
	end
end)

E:AddTag("mName:last", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local name = UnitName(unit)
	if name and strfind(name, "%s") then
		name = ShortName(name)
	end

	if name then
		return name
	end
end)

E:AddTag("mName:last:onlyininstance", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local name = UnitName(unit)
	local inInstance, InstanceType = IsInInstance()
	if name and strfind(name, "%s") then
		name = inInstance and ShortName(name) or E.TagFunctions.Abbrev(name)
	end

	if name then
		return name
	end
end)

E:AddTag("mTarget:abbrev", "UNIT_TARGET", function(unit)
	local targetName = UnitName(unit .. "target")
	if targetName then
		return E.TagFunctions.Abbrev(targetName)
	end
end)

for textFormat, length in pairs({ veryshort = 5, short = 10, medium = 15, long = 20 }) do
	E:AddTag(format("mTarget:abbrev:%s", textFormat), "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local targetName = UnitName(unit .. "target")

		if targetName then
			return E:ShortenString(targetName, length)
		end
	end)
end

E:AddTagInfo("mTarget:abbrev", mMT.NameShort .. " " .. L["Name"], L["Abbrev Name of Target."])
E:AddTagInfo("mTarget:abbrev:veryshort", mMT.NameShort .. " " .. L["Name"], L["Shortened version of abbrev Name of Target."])
E:AddTagInfo("mTarget:abbrev:short", mMT.NameShort .. " " .. L["Name"], L["Shortened version of abbrev Name of Target."])
E:AddTagInfo("mTarget:abbrev:medium", mMT.NameShort .. " " .. L["Name"], L["Shortened version of abbrev Name of Target."])
E:AddTagInfo("mTarget:abbrev:long", mMT.NameShort .. " " .. L["Name"], L["Shortened version of abbrev Name of Target."])

E:AddTagInfo("mName:status", mMT.NameShort .. " " .. L["Name"], L["Replace the Unit name with Status, if applicable."])
E:AddTagInfo("mName:statusicon", mMT.NameShort .. " " .. L["Name"], L["Replace the Unit name with Status Icon, if applicable."])
E:AddTagInfo("mName:status:veryshort", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:status:short", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:status:medium", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:status:long", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:statusicon:veryshort", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:statusicon:short", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:statusicon:medium", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:statusicon:long", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:last", mMT.NameShort .. " " .. L["Name"], L["Displays the last word of the Unit name."])
E:AddTagInfo("mName:last:veryshort", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:short", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:medium", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:long", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:onlyininstance", mMT.NameShort .. " " .. L["Name"], L["Displays the last word of the Unit name, only in an Instance."])
E:AddTagInfo("mName:last:onlyininstance:veryshort", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")
E:AddTagInfo("mName:last:onlyininstance:short", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")
E:AddTagInfo("mName:last:onlyininstance:medium", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")
E:AddTagInfo("mName:last:onlyininstance:long", mMT.NameShort .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")

E:AddTag("mClass", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)

	if c == "rare" then
		return format("%sRare|r", colors.rare)
	elseif c == "rareelite" then
		return format("%sRare Elite|r", colors.relite)
	elseif c == "elite" then
		return format("%sElite|r", colors.elite)
	elseif c == "worldboss" then
		return format("%sBoss|r", colors.boss)
	end
end)

E:AddTag("mClass:short", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)

	if c == "rare" then
		return format("%sR|r", colors.rare)
	elseif c == "rareelite" then
		return format("%sR+|r", colors.relite)
	elseif c == "elite" then
		return format("%s+|r", colors.elite)
	elseif c == "worldboss" then
		return format("%sB|r", colors.boss)
	end
end)

E:AddTag("mClass:icon", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	local guid = UnitGUID(unit)
	local npcID = guid and select(6, strsplit("-", guid))

	if (npcID and BossIDs[npcID]) or c == "worldboss" then
		return icons.boss
	elseif c == "rare" then
		return icons.rare
	elseif c == "rareelite" then
		return icons.relite
	elseif c == "elite" then
		return icons.elite
	end
end)

E:AddTag("mClass:icon:boss", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	local guid = UnitGUID(unit)
	local npcID = guid and select(6, strsplit("-", guid))

	if (npcID and BossIDs[npcID]) or c == "worldboss" then
		return icons.boss
	end
end)

E:AddTag("mClass:icon:rare", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	if c == "rare" then
		return icons.rare
	elseif c == "rareelite" then
		return icons.relite
	end
end)

E:AddTagInfo("mClass", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class."])
E:AddTagInfo("mClass:short", mMT.NameShort .. " " .. L["Class"], L["Shortened version of"] .. " mClass.")
E:AddTagInfo("mClass:icon", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class Icon."])
E:AddTagInfo("mClass:icon:boss", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class Icon only for Boss NPCs."])
E:AddTagInfo("mClass:icon:rare", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class Icon only for Rare and Rare Elite NPCs."])

E:AddTag("mStatus", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	elseif UnitIsDND(unit) then
		return format("[%sDND|r]", colors.dnd)
	else
		if not UnitIsConnected(unit) then
			return L["Offline"]
		elseif UnitIsDead(unit) then
			return L["Dead"]
		elseif UnitIsGhost(unit) then
			return L["Ghost"]
		end
	end
end)

E:AddTag("mStatus:icon", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	if UnitIsAFK(unit) then
		return icons.afk
	elseif UnitIsDND(unit) then
		return icons.dnd
	else
		if not UnitIsConnected(unit) then
			return icons.dc
		elseif UnitIsDead(unit) then
			return icons.death
		elseif UnitIsGhost(unit) then
			return icons.ghost
		end
	end
end)

local unitStatus = {}
E:AddTag("mStatustimer", 1, function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if not guid then
		return
	end

	local status = unitStatus[guid]

	if UnitIsAFK(unit) then
		if not status or status[1] ~= "AFK" then
			unitStatus[guid] = { "AFK", GetTime() }
		end
	elseif UnitIsDND(unit) then
		if not status or status[1] ~= "DND" then
			unitStatus[guid] = { "DND", GetTime() }
		end
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		if not status or status[1] ~= "Dead" then
			unitStatus[guid] = { "Dead", GetTime() }
		end
	elseif not UnitIsConnected(unit) then
		if not status or status[1] ~= "Offline" then
			unitStatus[guid] = { "Offline", GetTime() }
		end
	else
		unitStatus[guid] = nil
	end

	if status ~= unitStatus[guid] then
		status = unitStatus[guid]
	end

	if status then
		local timer = GetTime() - status[2]
		local mins = floor(timer / 60)
		local secs = floor(timer - (mins * 60))
		return format("%01.f:%02.f", mins, secs)
	end
end)

E:AddTag("mAFK", "PLAYER_FLAGS_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return format("[%sAFK|r]", colors.afk)
	end
end)

E:AddTagInfo("mStatus", mMT.NameShort .. " " .. L["Status"], L["Displays the Unit Status."])
E:AddTagInfo("mStatus:icon", mMT.NameShort .. " " .. L["Status"], L["Displays the Unit Status Icon."])
E:AddTagInfo("mStatustimer", mMT.NameShort .. " " .. L["Status"], L["Displays the Unit Status text and time."])
E:AddTagInfo("mAFK", mMT.NameShort .. " " .. L["Status"], L["Displays the Unit AFK Status."])

E:AddTag("mColor", "UNIT_NAME_UPDATE UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	local unitPlayer = UnitIsPlayer(unit)

	if unitPlayer then
		return _TAGS.classcolor(unit)
	else
		if c == "rare" then
			return colors.rare
		elseif c == "rareelite" then
			return colors.relite
		elseif c == "elite" then
			return colors.elite
		elseif c == "worldboss" then
			return colors.boss
		else
			return _TAGS.classcolor(unit)
		end
	end
end)

E:AddTag("mColor:target", "UNIT_TARGET", function(unit)
	local target = unit .. "target"
	local c = UnitClassification(target)
	local unitPlayer = UnitIsPlayer(target)

	if unitPlayer then
		return _TAGS.classcolor(target)
	else
		if c == "rare" then
			return colors.rare
		elseif c == "rareelite" then
			return colors.relite
		elseif c == "elite" then
			return colors.elite
		elseif c == "worldboss" then
			return colors.boss
		else
			return _TAGS.classcolor(target)
		end
	end
end)

E:AddTagInfo("mColor", mMT.NameShort .. " " .. L["Color"], L["Unit colors with mMediaTag colors for Rare, Rareelite, Elite and Boss and Classcolors."])
E:AddTagInfo("mColor:target", mMT.NameShort .. " " .. L["Color"], L["Targetunit colors with mMediaTag colors for Rare, Rareelite, Elite and Boss and Classcolors."])

E:AddTag("mHealth", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
			end
		end
	end
end)

E:AddTag("mHealth:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local deficit = UnitHealthMax(unit) - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
	else
		return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
	end
end)

E:AddTag("mHealth:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
			end
		end
	end
end)

E:AddTag("mHealth:noStatus:short", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local deficit = UnitHealthMax(unit) - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
	else
		return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
	end
end)

E:AddTag("mHealth:nodeath", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
		end
	end
end)

E:AddTag("mHealth:nodeath:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
		end
	end
end)

E:AddTag("mHealth:noStatus:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local deficit = UnitHealthMax(unit) - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return format("%s | %s", E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit)), E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit)))
	else
		return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
	end
end)

E:AddTag("mHealth:nodeath:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return ""
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit)), E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit)))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
		end
	end
end)

E:AddTag("mHealth:nodeath:short:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return ""
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true), E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit)))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
		end
	end
end)

E:AddTag("mHealth:icon", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
		end
	end
end)

E:AddTag("mHealth:icon:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
		end
	end
end)

E:AddTag("mHealth:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format("%s | %s", E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit)), E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit)))
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
			end
		end
	end
end)

E:AddTag("mHealth:current-percent:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format("%s | %s", E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true), E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit)))
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
			end
		end
	end
end)

E:AddTag("mHealth:NoAFK", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
		end
	end
end)

E:AddTag("mHealth:NoAFK:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
		end
	end
end)

E:AddTag("mHealth:NoAFK:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit)), E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit)))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
		end
	end
end)

E:AddTag("mHealth:NoAFK:short:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local deficit = UnitHealthMax(unit) - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true), E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit)))
		else
			return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
		end
	end
end)

E:AddTagInfo("mHealth", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat."])
E:AddTagInfo("mHealth:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth.")
E:AddTagInfo("mHealth:icon", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat, with Status Icons."])
E:AddTagInfo("mHealth:icon:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:icon.")
E:AddTagInfo("mHealth:current-percent", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Current Health - Percent in combat."])
E:AddTagInfo("mHealth:current-percent:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:current-percent.")
E:AddTagInfo("mHealth:nodeath", mMT.NameShort .. " " .. L["Health"], L["If the unit is alive, its health will change between maximum health and percentage in combat."])
E:AddTagInfo("mHealth:nodeath:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:nodeath.")
E:AddTagInfo("mHealth:nodeath:current-percent", mMT.NameShort .. " " .. L["Health"], L["Same as"] .. " mHealth:current-percent " .. L["and"] .. " mHealth:nodeath ")
E:AddTagInfo("mHealth:nodeath:short:current-percent", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:nodeath:current-percent.")
E:AddTagInfo("mHealth:NoAFK", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat, without AFK Status."])
E:AddTagInfo("mHealth:NoAFK:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:NoAFK.")
E:AddTagInfo("mHealth:NoAFK:current-percent", mMT.NameShort .. " " .. L["Health"], L["Same as"] .. " mHealth:current-percent " .. L["and"] .. " mHealth:NoAFK ")
E:AddTagInfo("mHealth:NoAFK:short:current-percent", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:NoAFK:current-percent.")
E:AddTagInfo("mHealth:noStatus", mMT.NameShort .. " " .. L["Health"], L["no Status version of"] .. " mHealth.")
E:AddTagInfo("mHealth:noStatus:short", mMT.NameShort .. " " .. L["Health"], L["no Status version of"] .. " mHealth.")
E:AddTagInfo("mHealth:noStatus:current-percent", mMT.NameShort .. " " .. L["Health"], L["no Status version of"] .. " mHealth.")

local UnitmDeathCount = {}
local mID = ""
local mTyp = "none"
function mMT:TagDeathCount()
	local iniId, typ = tostring(({ GetInstanceInfo() })[8]), tostring(({ GetInstanceInfo() })[2])

	if typ ~= "none" and mTyp == "none" then
		mTyp = typ
	end

	if mTyp ~= "none" and typ == "none" and UnitFaction then
		UnitFaction = {}
	end

	if iniId ~= mID then
		mID = iniId
		UnitmDeathCount = {}
	end
end

E:AddTag("mDeathCount", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if not guid then
		return
	end

	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		if not UnitmDeathCount[guid] then
			UnitmDeathCount[guid] = { true, 1 }
		else
			if UnitmDeathCount[guid][1] ~= true then
				UnitmDeathCount[guid] = { true, UnitmDeathCount[guid][2] + 1 }
			end
		end
	else
		if UnitmDeathCount ~= nil then
			if UnitmDeathCount[guid] ~= nil then
				UnitmDeathCount[guid][1] = false
			end
		end
	end

	if not UnitmDeathCount then
		return
	end

	if UnitmDeathCount[guid] and (UnitmDeathCount[guid][2] >= 1) then
		return UnitmDeathCount[guid][2]
	end
end)

E:AddTag("mDeathCount:hide", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end
	_TAGS.mDeathCount(unit)

	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return _TAGS.mDeathCount(unit)
	end
end)

E:AddTag("mDeathCount:color", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if UnitmDeathCount[guid] then
		local r, g, b = E:ColorGradient(UnitmDeathCount[guid][2] * 0.20, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		return E:RGBToHex(r, g, b)
	end
end)

E:AddTag("mDeathCount:hide:text", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if UnitmDeathCount[guid] then
		if UnitmDeathCount[guid][2] >= 1 then
			return L["Deaths"] .. ": "
		end
	end
end)

E:AddTagInfo("mDeathCount", mMT.NameShort .. " " .. L["Misc"], L["Death Counter, resets in new Instances."])
E:AddTagInfo("mDeathCount:hide", mMT.NameShort .. " " .. L["Misc"], L["Displays the Death counter only when the unit is Death, resets in new instances."])
E:AddTagInfo("mDeathCount:color", mMT.NameShort .. " " .. L["Misc"], L["Death Counter color."])
E:AddTagInfo("mDeathCount:hide:text", mMT.NameShort .. " " .. L["Misc"], L["Displays the Death counter only when the unit is Death and Shows a Text (Death: 7), resets in new instances."])

E:AddTag("mRole", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local Role = ""

	if E.Retail then
		Role = UnitGroupRolesAssigned(unit)
	end

	if Role == "TANK" then
		return format("%s%s|r", colors.tank, TANK)
	elseif Role == "HEALER" then
		return format("%s%s|r", colors.heal, HEALER)
	end
end)

E:AddTag("mRoleIcon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local Role = ""

	if E.Retail then
		Role = UnitGroupRolesAssigned(unit)
	end

	if Role == "TANK" then
		return icons.tank
	elseif Role == "HEALER" then
		return icons.heal
	elseif Role == "DAMAGER" then
		return icons.dd
	end
end)

E:AddTag("mRoleIcon:target", "UNIT_TARGET UNIT_COMBAT", function(unit)
	local Role = ""

	if E.Retail then
		Role = UnitGroupRolesAssigned(unit .. "target")

		if Role == "TANK" then
			return icons.tank
		elseif Role == "HEALER" then
			return icons.heal
		elseif Role == "DAMAGER" then
			return icons.dd
		end
	else
		return ""
	end
end)

E:AddTagInfo("mRole", mMT.NameShort .. " " .. L["Misc"], L["Tank and Healer roles as text."])
E:AddTagInfo("mRoleIcon", mMT.NameShort .. " " .. L["Misc"], L["Unit role icon."])
E:AddTagInfo("mRoleIcon:target", mMT.NameShort .. " " .. L["Misc"], L["Targetunit role icon."])

E:AddTag("mLevel", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return format("%sZzz|r", colors.zzz)
	else
		local level = UnitLevel(unit)
		if E.Retail then
			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
				return UnitBattlePetLevel(unit)
			elseif level > 0 then
				return level
			else
				return format("%s??|r", colors.level)
			end
		end
		if level > 0 then
			return level
		else
			return format("%s??|r", colors.level)
		end
	end
end)

E:AddTag("mLevel:hideMax", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return format("%sZzz|r", colors.zzz)
	else
		local level = UnitLevel(unit)
		if E.Retail then
			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
				return UnitBattlePetLevel(unit)
			elseif level > 0 then
				if unit == "player" then
					if not E:XPIsLevelMax() then
						return level
					end
				else
					return level
				end
			else
				return format("%s??|r", colors.level)
			end
		end
		if level > 0 then
			if unit == "player" then
				if not E:XPIsLevelMax() then
					return level
				end
			else
				return level
			end
		else
			return format("%s??|r", colors.level)
		end
	end
end)

E:AddTag("mLevelSmart", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return format("%sZzz|r", colors.zzz)
	else
		local level = UnitLevel(unit)
		if E.Retail then
			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
				return UnitBattlePetLevel(unit)
			elseif level > 0 then
				return level
			else
				return format("%s??|r", colors.level)
			end
		end

		if level == UnitLevel("player") then
			return ""
		elseif level > 0 then
			return level
		else
			return format("%s??|r", colors.level)
		end
	end
end)

E:AddTag("mLevelSmart:hideMax", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return format("%sZzz|r", colors.zzz)
	else
		local level = UnitLevel(unit)
		if E.Retail then
			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
				return UnitBattlePetLevel(unit)
			elseif level > 0 then
				if unit == "player" then
					if not E:XPIsLevelMax() then
						return level
					end
				else
					return level
				end
			else
				return format("%s??|r", colors.level)
			end
		end

		if level == UnitLevel("player") then
			return ""
		elseif level > 0 then
			if unit == "player" then
				if not E:XPIsLevelMax() then
					return level
				end
			else
				return level
			end
		else
			return format("%s??|r", colors.level)
		end
	end
end)

E:AddTagInfo("mLevel", mMT.NameShort .. " " .. L["Level"], L["Level changes to resting in resting Areas."])
E:AddTagInfo("mLevel:hideMax", mMT.NameShort .. " " .. L["Level"], L["Same as"] .. " mLevel" .. L[" hidden at maximum level."])
E:AddTagInfo("mLevelSmart", mMT.NameShort .. " " .. L["Level"], L["Smart Level changes to resting in resting Areas."])
E:AddTagInfo("mLevelSmart:hideMax", mMT.NameShort .. " " .. L["Level"], L["Same as"] .. " mLevelSmart" .. L[" hidden at maximum level."])

E:AddTag("mPvP:icon", "UNIT_FACTION", function(unit)
	local factionGroup = UnitFactionGroup(unit)
	if (UnitIsPVP(unit)) and (factionGroup == "Horde" or factionGroup == "Alliance") then
		return icons.pvp
	end
end)

E:AddTag("mFaction:icon", "UNIT_FACTION", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if not guid then
		return
	end

	if not UnitFaction[guid] then
		local factionGroup = UnitFactionGroup(unit)
		if factionGroup then
			UnitFaction[guid] = {
				CreateTextureMarkup("Interface\\FriendsFrame\\PlusManz-" .. factionGroup, 16, 16, 16, 16, 0, 1, 0, 1, 0, 0),
				factionGroup,
			}
		end
	end

	if UnitFaction[guid] then
		if UnitFaction[guid][1] then
			return UnitFaction[guid][1]
		end
	end
end)

E:AddTag("mFaction:text", "UNIT_FACTION", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if not guid then
		return
	end

	if not UnitFaction[guid] then
		local factionGroup = UnitFactionGroup(unit)
		if factionGroup then
			UnitFaction[guid] = {
				CreateTextureMarkup("Interface\\FriendsFrame\\PlusManz-" .. factionGroup, 16, 16, 16, 16, 0, 1, 0, 1, 0, 0),
				factionGroup,
			}
		end
	end

	if UnitFaction[guid] then
		if UnitFaction[guid][2] then
			if UnitFaction[guid][2] == "Horde" or UnitFaction[guid][2] == "Alliance" then
				return UnitFaction[guid][2]
			end
		end
	end
end)

E:AddTag("mFaction:text:opposite", "UNIT_FACTION", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if not guid then
		return
	end

	if not UnitFaction[guid] then
		local factionGroup = UnitFactionGroup(unit)
		if factionGroup then
			UnitFaction[guid] = {
				CreateTextureMarkup("Interface\\FriendsFrame\\PlusManz-" .. factionGroup, 16, 16, 16, 16, 0, 1, 0, 1, 0, 0),
				factionGroup,
			}
		end
	end

	if UnitFaction[guid] then
		if UnitFaction[guid][2] then
			local factionPlayer = UnitFactionGroup("Player")
			if (UnitFaction[guid][2] == "Horde" or UnitFaction[guid][2] == "Alliance") and (UnitFaction[guid][2] ~= factionPlayer) then
				return UnitFaction[guid][2]
			end
		end
	end
end)

E:AddTag("mFaction:icon:opposite", "UNIT_FACTION", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	local guid = UnitGUID(unit)

	if not guid then
		return
	end

	if not UnitFaction[guid] then
		local factionGroup = UnitFactionGroup(unit)
		if factionGroup then
			UnitFaction[guid] = {
				CreateTextureMarkup("Interface\\FriendsFrame\\PlusManz-" .. factionGroup, 16, 16, 16, 16, 0, 1, 0, 1, 0, 0),
				factionGroup,
			}
		end
	end

	if UnitFaction[guid] then
		if UnitFaction[guid][1] then
			local factionPlayer = UnitFactionGroup("Player")
			if (UnitFaction[guid][2] == "Horde" or UnitFaction[guid][2] == "Alliance") and (UnitFaction[guid][2] ~= factionPlayer) then
				return UnitFaction[guid][1]
			end
		end
	end
end)

E:AddTagInfo("mPvP:icon", mMT.NameShort .. " " .. L["Misc"], L["Displays an icon when the unit is flagged for PvP."])
E:AddTagInfo("mFaction:icon", mMT.NameShort .. " " .. L["Misc"], L["Displays the Faction Icon."])
E:AddTagInfo("mFaction:icon:opposite", mMT.NameShort .. " " .. L["Misc"], L["Displays the opposite Faction Icon."])
E:AddTagInfo("mFaction:text", mMT.NameShort .. " " .. L["Misc"], L["Displays the Faction."])
E:AddTagInfo("mFaction:text:opposite", mMT.NameShort .. " " .. L["Misc"], L["Displays the opposite Faction."])

E:AddTag("mPowerPercent", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local powerType = UnitPowerType(unit)
	local min = UnitPower(unit, powerType)
	local max = UnitPowerMax(unit, powerType)
	if min ~= 0 then
		local Role = ""

		if E.Retail then
			Role = UnitGroupRolesAssigned(unit)
		end

		if min == max then
			return "100%"
		end

		if Role == "HEALER" then
			local perc = min / max * 100
			if perc <= 30 then
				return format("|CFFF7DC6F%s|r", E:GetFormattedText("PERCENT", min, max))
			elseif perc <= 5 then
				return format("|CFFE74C3C%s|r", E:GetFormattedText("PERCENT", min, max))
			else
				return E:GetFormattedText("PERCENT", min, max)
			end
		else
			return E:GetFormattedText("PERCENT", min, max)
		end
	end
end)

E:AddTag("mPowerPercent:hidefull", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	local powerType = UnitPowerType(unit)
	local min = UnitPower(unit, powerType)
	local max = UnitPowerMax(unit, powerType)
	if (min ~= max) and min ~= 0 then
		return _TAGS.mPowerPercent(unit)
	end
end)

E:AddTag("mPower:percent:hideZero", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	local power = _TAGS.perpp(unit)
	if power ~= 0 then
		return _TAGS.perpp(unit)
	end
end)

E:AddTag("mPowerPercent:heal", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local Role = "HEALER"

	if E.Retail or E.Wrath then
		Role = UnitGroupRolesAssigned(unit)
	end

	if Role == "HEALER" then
		return _TAGS.mPowerPercent(unit)
	end
end)

E:AddTag("mPowerPercent:heal:hidefull", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	local Role = "HEALER"

	if E.Retail or E.Wrath then
		Role = UnitGroupRolesAssigned(unit)
	end

	if Role == "HEALER" then
		return _TAGS["mPowerPercent:hidefull"](unit)
	end
end)

E:AddTagInfo("mPowerPercent", mMT.NameShort .. " " .. L["Power"], L["Displays Power/Mana, with a low healer warning."])
E:AddTagInfo("mPowerPercent:hidefull", mMT.NameShort .. " " .. L["Power"], L["Displays Power/Mana, with a low healer warning, hidden when full."])
E:AddTagInfo("mPowerPercent:heal", mMT.NameShort .. " " .. L["Power"], L["Displays the healer's Power/Mana, with a low healer warning."])
E:AddTagInfo("mPowerPercent:heal:hidefull", mMT.NameShort .. " " .. L["Power"], L["Displays the healer's Power/Mana, with a low healer warning, hidden when full."])
E:AddTagInfo("mPower:percent:hideZero", mMT.NameShort .. " " .. L["Power"], L["Displays Power/Mana, hidden when zero."])

E:AddTag("mQuestIcon", "QUEST_LOG_UPDATE", function(unit)
	if UnitIsPlayer(unit) then
		return
	end
	local isQuest = E.TagFunctions.GetQuestData(unit, "title", Hex)
	if isQuest then
		return icons.quest
	end
end)

E:AddTagInfo("mQuestIcon", mMT.NameShort .. " " .. L["Misc"], L["Displays a ! if the Unit is a Quest NPC."])

local function GetPartyTargets(unit)
	local amount = 0
	for i = 1, GetNumGroupMembers() - 1 do
		if UnitIsUnit("party" .. i .. "target", unit) then
			amount = amount + 1
		end
	end

	if UnitIsUnit("playertarget", unit) then
		amount = amount + 1
	end

	if amount ~= 0 then
		return amount
	end
end

local function GetRaidTargets(unit)
	local amount = 0
	for i = 1, GetNumGroupMembers() do
		if UnitIsUnit("raid" .. i .. "target", unit) then
			amount = amount + 1
		end
	end

	if amount ~= 0 then
		return amount
	end
end

local targetTextures = {
	TANK = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\TANK.tga:16:16:0:0:16:16:0:16:0:16",
	HEALER = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\HEAL.tga:16:16:0:0:16:16:0:16:0:16",
	DAMAGER = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\DD.tga:16:16:0:0:16:16:0:16:0:16",
	STOP = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\STOP.tga:16:16:0:0:16:16:0:16:0:16",
	SQ = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\SQ.tga:16:16:0:0:16:16:0:16:0:16",
	FLAT = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\FLAT.tga:16:16:0:0:16:16:0:16:0:16",
	GLAS = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\GLAS.tga:16:16:0:0:16:16:0:16:0:16",
	DIA = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\DIA.tga:16:16:0:0:16:16:0:16:0:16",
}

local targetStringColors = {}
local function GetPartyTargetsIcons(unit, style)
	if not targetStringColors.build then
		for _, class in ipairs(mMT.Classes) do
			local color = E:ClassColor(class)
			targetStringColors[class] = ":" .. tostring(mMT:round(color.r * 255)) .. ":" .. tostring(mMT:round(color.g * 255)) .. ":" .. tostring(mMT:round(color.b * 255)) .. "|t"
		end

		targetStringColors.build = true
	end

	local ClassString = ""

	if style == "role" then
		for i = 1, GetNumGroupMembers() - 1 do
			if UnitIsUnit("party" .. i .. "target", unit) then
				local role = targetTextures[UnitGroupRolesAssigned("party" .. i)] or targetTextures.DAMAGER
				local _, unitClass = UnitClass("party" .. i)
				ClassString = role .. targetStringColors[unitClass] .. ClassString
			end
		end

		if UnitIsUnit("playertarget", unit) then
			local role = targetTextures[UnitGroupRolesAssigned("player")] or targetTextures.DAMAGER
			local _, unitClass = UnitClass("player")
			ClassString = role .. targetStringColors[unitClass] .. ClassString
		end
	else
		for i = 1, GetNumGroupMembers() - 1 do
			if UnitIsUnit("party" .. i .. "target", unit) then
				local _, unitClass = UnitClass("party" .. i)
				ClassString = targetTextures[style] .. targetStringColors[unitClass] .. ClassString
			end
		end

		if UnitIsUnit("playertarget", unit) then
			local _, unitClass = UnitClass("player")
			ClassString = targetTextures[style] .. targetStringColors[unitClass] .. ClassString
		end
	end

	if ClassString ~= "" then
		return ClassString
	end
end

E:AddTag("mTargetingPlayers", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) then
		if IsInRaid() then
			return GetRaidTargets(unit)
		elseif IsInGroup() then
			return GetPartyTargets(unit)
		end
	end
end)

E:AddTag("mTargetingPlayers:icons:Flat", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "FLAT")
	end
end)

E:AddTag("mTargetingPlayers:icons:Glas", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "GLAS")
	end
end)

E:AddTag("mTargetingPlayers:icons:SQ", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "SQ")
	end
end)

E:AddTag("mTargetingPlayers:icons:DIA", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "DIA")
	end
end)

E:AddTag("mTargetingPlayers:icons:Stop", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "STOP")
	end
end)

E:AddTag("mTargetingPlayers:icons:Role", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) and (E.Retail or E.Wrath) then
		return GetPartyTargetsIcons(unit, "role")
	end
end)

E:AddTagInfo("mTargetingPlayers", mMT.NameShort .. " " .. L["Misc"], L["Target counter (Party and Raid)."])
E:AddTagInfo("mTargetingPlayers:icons:Flat", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Circle)."])
E:AddTagInfo("mTargetingPlayers:icons:Glas", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Glas Circle)."])
E:AddTagInfo("mTargetingPlayers:icons:SQ", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Square)."])
E:AddTagInfo("mTargetingPlayers:icons:DIA", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Diamond)."])
E:AddTagInfo("mTargetingPlayers:icons:Stop", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Stop shield)."])
E:AddTagInfo("mTargetingPlayers:icons:Role", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Roleicons)."])
