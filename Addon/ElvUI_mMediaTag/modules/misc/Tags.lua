local E = unpack(ElvUI)
local L = mMT.Locales

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
local UnitAffectingCombat = UnitAffectingCombat
local UnitFaction = {}

-- fallback colors
local colors = {
	rare = "|cffffffff",
	rareelite = "|cffffffff",
	elite = "|cffffffff",
	worldboss = "|cffffffff",
	afk = "|cffffffff",
	dnd = "|cffffffff",
	zzz = "|cffffffff",
	tank = "|cffffffff",
	heal = "|cffffffff",
	level = "|cffffffff",
	absorbs = "|cffffffff",
}

local CustomRaidTargetIcons = {
	[1] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	[2] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	[3] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	[4] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	[5] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	[6] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	[7] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	[8] = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
}

-- fallback icons
local icons = {
	rare = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	rareelite = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	elite = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	worldboss = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	afk = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	dnd = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	dc = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	death = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	ghost = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	pvp = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\pvp.tga"),
	TANK = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	HEALER = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	DAMAGER = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:15:15|t",
	quest = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\quest1.tga"),
	default = {
		TANK = CreateAtlasMarkup("UI-LFG-RoleIcon-Tank", 16, 16),
		HEALER = CreateAtlasMarkup("UI-LFG-RoleIcon-Healer", 16, 16),
		DAMAGER = CreateAtlasMarkup("UI-LFG-RoleIcon-DPS", 16, 16),
	},
}

local BossIDs = {
	-- DF Dungeons
	["189729"] = true,
	["189727"] = true,
	["189722"] = true,
	["189719"] = true,

	["186125"] = true,
	["186124"] = true,
	["186122"] = true,
	["186121"] = true,
	["186120"] = true,
	["186116"] = true,

	["184582"] = true,
	["184581"] = true,
	["184580"] = true,
	["184422"] = true,
	["184125"] = true,
	["184124"] = true,
	["184018"] = true,

	["189901"] = true,
	["189478"] = true,
	["189340"] = true,
	["181861"] = true,

	["190485"] = true,
	["190484"] = true,
	["189232"] = true,
	["188252"] = true,

	["186616"] = true,
	["186615"] = true,
	["186339"] = true,
	["186338"] = true,
	["186151"] = true,

	["186739"] = true,
	["186738"] = true,
	["186737"] = true,
	["186644"] = true,

	["196482"] = true,
	["194181"] = true,
	["191736"] = true,
	["190609"] = true,

	-- S2 Dungeons
	["91007"] = true,
	["91005"] = true,
	["91004"] = true,
	["91003"] = true,

	["126983"] = true,
	["126969"] = true,
	["126848"] = true,
	["126847"] = true,
	["126845"] = true,
	["126832"] = true,

	["131318"] = true,
	["131383"] = true,
	["131817"] = true,
	["133007"] = true,

	["43878"] = true,
	["43875"] = true,
	["43873"] = true,

	-- S3 Dungeons
	["131527"] = true,
	["131545"] = true,
	["131667"] = true,
	["131823"] = true,
	["131824"] = true,
	["131825"] = true,
	["131863"] = true,
	["131864"] = true,

	["103344"] = true,
	["96512"] = true,
	["99192"] = true,
	["99200"] = true,

	["98542"] = true,
	["98696"] = true,
	["98949"] = true,
	["98965"] = true,
	["98970"] = true,

	["122963"] = true,
	["122965"] = true,
	["122967"] = true,
	["122968"] = true,

	["81522"] = true,
	["82682"] = true,
	["83846"] = true,
	["83892"] = true,
	["83893"] = true,
	["83894"] = true,

	["213770"] = true,
	["40586"] = true,
	["40765"] = true,
	["40788"] = true,
	["40825"] = true,
	["44566"] = true,

	-- DF Dawn of the Infinite
	["198933"] = true,
	["198995"] = true,
	["198996"] = true,
	["198997"] = true,
	["198998"] = true,
	["198999"] = true,
	["199000"] = true,
	["201788"] = true,
	["201790"] = true,
	["201792"] = true,
	["203678"] = true,
	["203679"] = true,
	["203861"] = true,
	["204206"] = true,
	["204449"] = true,
	["208193"] = true,
	["209207"] = true,
	["209208"] = true,

	-- DF Worldboss
	["193532"] = true,
	["193533"] = true,
	["193534"] = true,
	["193535"] = true,
	["199853"] = true,
	["203220"] = true,
	["209574"] = true,

	-- DF Raid Vault of the Incarnates
	["190496"] = true,
	["190245"] = true,
	["189813"] = true,
	["189492"] = true,
	["187967"] = true,
	["187772"] = true,
	["187771"] = true,
	["187768"] = true,
	["187767"] = true,
	["184986"] = true,
	["184972"] = true,

	-- DF Raid Aberrus
	["205319"] = true,
	["204223"] = true,
	["202637"] = true,
	["201934"] = true,
	["201774"] = true,
	["201773"] = true,
	["201579"] = true,
	["201320"] = true,
	["201261"] = true,
	["200918"] = true,
	["200913"] = true,
	["200912"] = true,
	["199659"] = true,

	-- DF Raid Amirdrassil
	["200926"] = true,
	["200927"] = true,
	["204931"] = true,
	["206172"] = true,
	["208363"] = true,
	["208365"] = true,
	["208367"] = true,
	["208445"] = true,
	["208478"] = true,
	["209090"] = true,
	["209333"] = true,
}

function mMT:UpdateTagSettings()
	colors = {
		rare = E.db.mMT.tags.colors.rare.hex,
		rareelite = E.db.mMT.tags.colors.relite.hex,
		elite = E.db.mMT.tags.colors.elite.hex,
		worldboss = E.db.mMT.tags.colors.boss.hex,
		afk = E.db.mMT.tags.colors.afk.hex,
		dnd = E.db.mMT.tags.colors.dnd.hex,
		zzz = E.db.mMT.tags.colors.zzz.hex,
		TANK = E.db.mMT.tags.colors.tank.hex,
		HEALER = E.db.mMT.tags.colors.heal.hex,
		level = E.db.mMT.tags.colors.level.hex,
		absorbs = E.db.mMT.tags.colors.absorbs.hex,
	}

	icons.rare = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.rare or "FRUIT3"])
	icons.rareelite = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.relite or "FRUIT4"])
	icons.elite = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.elite or "FRUIT2"])
	icons.worldboss = format("|T%s:15:15:0:2|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.boss or "BOSS1"])
	icons.afk = format("|T%s:15:15:0:2|t", mMT.Media.AFKIcons[E.db.mMT.tags.icons.afk or "AFK17"])
	icons.dnd = format("|T%s:15:15:0:2|t", mMT.Media.DNDIcons[E.db.mMT.tags.icons.dnd or "DND11"])
	icons.dc = format("|T%s:15:15:0:2|t", mMT.Media.DCIcons[E.db.mMT.tags.icons.offline or "DC9"])
	icons.death = format("|T%s:15:15:0:2|t", mMT.Media.DeathIcons[E.db.mMT.tags.icons.death or "DEATH11"])
	icons.ghost = format("|T%s:15:15:0:2|t", mMT.Media.GhostIcons[E.db.mMT.tags.icons.ghost or "GHOST1"])
	icons.pvp = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\pvp.tga")
	icons.TANK = E:TextureString(E.Media.Textures.Tank, ":15:15")
	icons.HEALER = E:TextureString(E.Media.Textures.Healer, ":15:15")
	icons.DAMAGER = E:TextureString(E.Media.Textures.DPS, ":15:15")
	icons.quest = format("|T%s:15:15:0:2|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\quest1.tga")

	CustomRaidTargetIcons[1] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[1] or "TM01"])
	CustomRaidTargetIcons[2] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[2] or "TM02"])
	CustomRaidTargetIcons[3] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[3] or "TM03"])
	CustomRaidTargetIcons[4] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[4] or "TM04"])
	CustomRaidTargetIcons[5] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[5] or "TM05"])
	CustomRaidTargetIcons[6] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[6] or "TM06"])
	CustomRaidTargetIcons[7] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[7] or "TM07"])
	CustomRaidTargetIcons[8] = format("|T%s:15:15:0:2|t", mMT.Media.TargetMarkers[E.db.mMT.tags.targetmarker[8] or "TM08"])

	if E.db.mMT.roleicons.enable then
		if E.db.mMT.roleicons.customtexture then
			icons.TANK = E:TextureString(E.db.mMT.roleicons.customtank, ":15:15")
			icons.HEALER = E:TextureString(E.db.mMT.roleicons.customtheal, ":15:15")
			icons.DAMAGER = E:TextureString(E.db.mMT.roleicons.customdd, ":15:15")
		else
			icons.TANK = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.tank], ":15:15")
			icons.HEALER = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.heal], ":15:15")
			icons.DAMAGER = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.dd], ":15:15")
		end
	end
end

local function ShortName(name)
	local a, b, c, d, e, f, g

	if name and strfind(name, "%s") then
		a, b, c, d, e, f, g = strsplit(" ", name, 6)
		return g or f or e or d or c or b or a or name
	end

	return g or f or e or d or c or b or a or name
end

for textFormat, length in pairs({ veryshort = 5, short = 10, medium = 15, long = 20 }) do
	E:AddTag(format("mName:last:%s", textFormat), "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local name = ShortName(UnitName(unit))

		if name then
			return E:ShortenString(name, length)
		end
	end)

	E:AddTag(format("mName:last:onlyininstance:%s", textFormat), "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local name = UnitName(unit)
		local inInstance, _ = IsInInstance()
		name = name and (inInstance and ShortName(name) or E.TagFunctions.Abbrev(name))

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

E:AddTag("mShowIcon", "UNIT_NAME_UPDATE", function(unit, _, args)
	local tbl, icon = strsplit(":", args or "")

	if tbl and icon and mMT.Media[tbl] and mMT.Media[tbl][icon] then
		return format("|T%s:16:16:0:2|t", mMT.Media[tbl][icon])
	end
end)

E:AddTag("mName:last", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local name = ShortName(UnitName(unit))

	if name then
		return name
	end
end)

E:AddTag("mName:last:onlyininstance", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local name = UnitName(unit)
	local inInstance, _ = IsInInstance()
	name = name and (inInstance and ShortName(name) or E.TagFunctions.Abbrev(name))

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

local classificationNames = {
	full = {
		rare = "Rare",
		rareelite = "Rare Elite",
		elite = "Elite",
		worldboss = "Boss",
	},
	short = {
		rare = "R",
		rareelite = "R+",
		elite = "+",
		worldboss = "B",
	},
}

E:AddTag("mClass", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	return (c and classificationNames.full[c]) and format("%s%s|r", colors[c], classificationNames.full[c]) or ""
end)

E:AddTag("mClass:short", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	return (c and classificationNames.short[c]) and format("%s%s|r", colors[c], classificationNames.short[c]) or ""
end)

E:AddTag("mClass:icon", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	local guid = UnitGUID(unit)
	local npcID = guid and select(6, strsplit("-", guid))

	c = (npcID and BossIDs[npcID]) and "worldboss" or c
	return c and icons[c] or ""
end)

E:AddTag("mClass:icon:boss", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	local guid = UnitGUID(unit)
	local npcID = guid and select(6, strsplit("-", guid))
	c = (npcID and BossIDs[npcID]) and "worldboss" or c

	return (c and c == "worldboss") and icons.worldboss or ""
end)

E:AddTag("mClass:icon:rare", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	return (c and c == "rare" or c == "rareelite") and icons[c] or ""
end)

E:AddTag("mClass:icon:noelite", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	local guid = UnitGUID(unit)
	local npcID = guid and select(6, strsplit("-", guid))
	c = (npcID and BossIDs[npcID]) and "worldboss" or c
	return (c and c ~= "elite") and icons[c] or ""
end)

E:AddTagInfo("mClass", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class."])
E:AddTagInfo("mClass:short", mMT.NameShort .. " " .. L["Class"], L["Shortened version of"] .. " mClass.")
E:AddTagInfo("mClass:icon", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class Icon."])
E:AddTagInfo("mClass:icon:boss", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class Icon, only for Boss NPCs."])
E:AddTagInfo("mClass:icon:rare", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class Icon only for Rare and Rare Elite NPCs."])
E:AddTagInfo("mClass:icon:noelite", mMT.NameShort .. " " .. L["Class"], L["Displays the Unit Class Icon only for Rare and Boss NPCs."])

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

E:AddTag("mColor", "UNIT_NAME_UPDATE UNIT_FACTION UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)
	local unitPlayer = UnitIsPlayer(unit)

	if not unitPlayer then
		local guid = UnitGUID(unit)
		local npcID = guid and select(6, strsplit("-", guid))
		c = (npcID and BossIDs[npcID]) and "worldboss" or c
	end

	return unitPlayer and _TAGS.classcolor(unit) or c and colors[c] or _TAGS.classcolor(unit)
end)

E:AddTag("mColor:rare", "UNIT_NAME_UPDATE UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)

	if c == "rare" then
		return colors.rare
	elseif c == "rareelite" then
		return colors.rareelite
	end
end)

E:AddTag("mColor:target", "UNIT_TARGET", function(unit)
	local target = unit .. "target"
	local c = UnitClassification(target)
	local unitPlayer = UnitIsPlayer(target)

	if not unitPlayer then
		local guid = UnitGUID(unit)
		local npcID = guid and select(6, strsplit("-", guid))
		c = (npcID and BossIDs[npcID]) and "worldboss" or c
	end

	return unitPlayer and _TAGS.classcolor(target) or c and colors[c] or _TAGS.classcolor(target)
end)

E:AddTag("mColor:absorbs", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local absorb = UnitGetTotalAbsorbs(unit) or 0

	if absorb ~= 0 then
		return colors.absorbs or ""
	end
end, not E.Retail)

E:AddTagInfo("mColor", mMT.NameShort .. " " .. L["Color"], L["Unit colors with mMediaTag colors for Rare, Rareelite, Elite and Boss and Classcolors."])
E:AddTagInfo("mColor:rare", mMT.NameShort .. " " .. L["Color"], L["Unit colors with mMediaTag colors for Rare and Rareelite."])
E:AddTagInfo("mColor:target", mMT.NameShort .. " " .. L["Color"], L["Targetunit colors with mMediaTag colors for Rare, Rareelite, Elite and Boss and Classcolors."])
E:AddTagInfo("mColor:absorbs", mMT.NameShort .. " " .. L["Color"], L["Absorbs color."])

local function NoDecimalPercent(min, max, string)
	if string then
		return format("%d", (min / max * 100)) .. string
	else
		return format("%d", (min / max * 100))
	end
end

E:AddTag("mHealth", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
			end
		end
	end
end)

E:AddTag("mHealth:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth
			local absorb = UnitGetTotalAbsorbs(unit) or 0

			if absorb == 0 then
				if deficit > 0 and currentHealth > 0 then
					return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
				else
					return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
				end
			else
				local healthTotalIncludingAbsorbs = UnitHealth(unit) + absorb
				if deficit > 0 and currentHealth > 0 then
					return E:GetFormattedText("PERCENT", healthTotalIncludingAbsorbs, maxHealth)
				else
					return E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth)
				end
			end
		end
	end
end, not E.Retail)

E:AddTag("mHealth:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return NoDecimalPercent(currentHealth, maxHealth, "%")
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
			end
		end
	end
end)

E:AddTag("mHealth:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local maxHealth = UnitHealthMax(unit)
	local deficit = maxHealth - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
	else
		return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
	end
end)

E:AddTag("mHealth:noStatus:ndp", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local maxHealth = UnitHealthMax(unit)
	local deficit = maxHealth - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return NoDecimalPercent(currentHealth, maxHealth, "%")
	else
		return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
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
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
			end
		end
	end
end)

E:AddTag("mHealth:short:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth
			local absorb = UnitGetTotalAbsorbs(unit) or 0

			if absorb == 0 then
				if deficit > 0 and currentHealth > 0 then
					return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
				else
					return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
				end
			else
				local healthTotalIncludingAbsorbs = UnitHealth(unit) + absorb
				if deficit > 0 and currentHealth > 0 then
					return E:GetFormattedText("PERCENT", healthTotalIncludingAbsorbs, maxHealth)
				else
					return E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth, nil, true)
				end
			end
		end
	end
end, not E.Retail)

E:AddTag("mHealth:short:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return NoDecimalPercent(currentHealth, maxHealth, "%")
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
			end
		end
	end
end)

E:AddTag("mHealth:noStatus:short", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local maxHealth = UnitHealthMax(unit)
	local deficit = maxHealth - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
	else
		return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
	end
end)

E:AddTag("mHealth:noStatus:short:ndp", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local maxHealth = UnitHealthMax(unit)
	local deficit = maxHealth - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return NoDecimalPercent(currentHealth, maxHealth, "%")
	else
		return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
	end
end)

E:AddTag("mHealth:nodeath", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:nodeath:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth, "%")
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:nodeath:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:nodeath:short:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth, "%")
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:noStatus:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local maxHealth = UnitHealthMax(unit)
	local deficit = maxHealth - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
	else
		return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
	end
end)

E:AddTag("mHealth:noStatus:current-percent:ndp", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	local maxHealth = UnitHealthMax(unit)
	local deficit = maxHealth - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), NoDecimalPercent(currentHealth, maxHealth, "%"))
	else
		return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
	end
end)

E:AddTag("mHealth:nodeath:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return ""
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:nodeath:current-percent:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return ""
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), NoDecimalPercent(currentHealth, maxHealth, "%"))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:nodeath:short:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return ""
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:nodeath:short:current-percent:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
		return ""
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), NoDecimalPercent(currentHealth, maxHealth, "%"))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:icon", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:icon:ndp:nosign", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:icon:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth, "%")
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:icon:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:icon:short:ndp:nosign", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:icon:short:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) or (UnitIsAFK(unit)) or (UnitIsDND(unit)) then
		return _TAGS["mStatus:icon"](unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth, "%")
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
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
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
			end
		end
	end
end)

E:AddTag("mHealth:current-percent:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth
			local absorb = UnitGetTotalAbsorbs(unit) or 0

			if absorb == 0 then
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
				else
					return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
				end
			else
				local healthTotalIncludingAbsorbs = UnitHealth(unit) + absorb
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth), E:GetFormattedText("PERCENT", healthTotalIncludingAbsorbs, maxHealth))
				else
					return E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth)
				end
			end
		end
	end
end, not E.Retail)

E:AddTag("mHealth:current-percent:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), NoDecimalPercent(currentHealth, maxHealth, "%"))
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
			end
		end
	end
end)

E:AddTag("mHealth:current-percent:ndp:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth
			local absorb = UnitGetTotalAbsorbs(unit) or 0

			if absorb == 0 then
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), NoDecimalPercent(currentHealth, maxHealth, "%"))
				else
					return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
				end
			else
				local healthTotalIncludingAbsorbs = UnitHealth(unit) + absorb
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth), NoDecimalPercent(healthTotalIncludingAbsorbs, maxHealth, "%"))
				else
					return E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth)
				end
			end
		end
	end
end, not E.Retail)

E:AddTag("mHealth:current-percent:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
			end
		end
	end
end)

E:AddTag("mHealth:current-percent:short:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth
			local absorb = UnitGetTotalAbsorbs(unit) or 0

			if absorb == 0 then
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
				else
					return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
				end
			else
				local healthTotalIncludingAbsorbs = UnitHealth(unit) + absorb
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth, nil, true), E:GetFormattedText("PERCENT", healthTotalIncludingAbsorbs, maxHealth))
				else
					return E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth, nil, true)
				end
			end
		end
	end
end, not E.Retail)

E:AddTag("mHealth:current-percent:short:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), NoDecimalPercent(currentHealth, maxHealth, "%"))
			else
				return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
			end
		end
	end
end)

E:AddTag("mHealth:current-percent:short:ndp:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	else
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			local deficit = maxHealth - currentHealth
			local absorb = UnitGetTotalAbsorbs(unit) or 0

			if absorb == 0 then
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), NoDecimalPercent(currentHealth, maxHealth, "%"))
				else
					return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
				end
			else
				local healthTotalIncludingAbsorbs = UnitHealth(unit) + absorb
				if deficit > 0 and currentHealth > 0 then
					return format("%s | %s", E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth, nil, true), NoDecimalPercent(healthTotalIncludingAbsorbs, maxHealth, "%"))
				else
					return E:GetFormattedText("CURRENT", healthTotalIncludingAbsorbs, maxHealth, nil, true)
				end
			end
		end
	end
end, not E.Retail)

E:AddTag("mHealth:NoAFK", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:NoAFK:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth, "%")
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:NoAFK:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return E:GetFormattedText("PERCENT", currentHealth, maxHealth)
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:NoAFK:short:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return NoDecimalPercent(currentHealth, maxHealth, "%")
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true)
		end
	end
end)

E:AddTag("mHealth:NoAFK:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:NoAFK:current-percent:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth), NoDecimalPercent(currentHealth, maxHealth, "%"))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:NoAFK:short:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), E:GetFormattedText("PERCENT", currentHealth, maxHealth))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:NoAFK:short:current-percent:ndp", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING", function(unit)
	if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
		return _TAGS.mStatus(unit)
	else
		local currentHealth = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		local deficit = maxHealth - currentHealth

		if deficit > 0 and currentHealth > 0 then
			return format("%s | %s", E:GetFormattedText("CURRENT", currentHealth, maxHealth, nil, true), NoDecimalPercent(currentHealth, maxHealth, "%"))
		else
			return E:GetFormattedText("CURRENT", currentHealth, maxHealth)
		end
	end
end)

E:AddTag("mHealth:onlypercent-with-absorbs:ndp:nosign", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_ABSORB_AMOUNT_CHANGED UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if status then
		return status
	end

	local absorb = UnitGetTotalAbsorbs(unit) or 0
	if absorb == 0 then
		return NoDecimalPercent(UnitHealth(unit), UnitHealthMax(unit))
	end

	local healthTotalIncludingAbsorbs = UnitHealth(unit) + absorb
	return NoDecimalPercent(healthTotalIncludingAbsorbs, UnitHealthMax(unit))
end, not E.Retail)

E:AddTagInfo("mHealth", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat."])
E:AddTagInfo("mHealth:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth.")
E:AddTagInfo("mHealth:absorbs", mMT.NameShort .. " " .. L["Health"], L["Displays the unit's current health as a percentage with absorb values"])
E:AddTagInfo("mHealth:short:absorbs", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:absorbs.")
E:AddTagInfo("mHealth:icon", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat, with Status Icons."])
E:AddTagInfo("mHealth:icon:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:icon.")
E:AddTagInfo("mHealth:current-percent", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Current Health - Percent in combat."])
E:AddTagInfo("mHealth:current-percent:short", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:current-percent.")
E:AddTagInfo("mHealth:current-percent:absorbs", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Current Health - Percent in combat with absorb values."])
E:AddTagInfo("mHealth:current-percent:short:absorbs", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:current-percent:absorbs.")
E:AddTagInfo("mHealth:nodeath", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat. Without Death Status."])
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

E:AddTagInfo("mHealth:ndp", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat."] .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:short:ndp", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:icon:ndp", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat, with Status Icons."] .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:icon:short:ndp", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:icon." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:current-percent:ndp", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Current Health - Percent in combat."] .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:current-percent:short:ndp", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:current-percent. " .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:current-percent:ndp:absorbs", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Current Health - Percent in combat with absorb values."] .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:current-percent:short:ndp:absorbs", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:current-percent:absorbs " .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:nodeath:ndp", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat. Without Death Status."] .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:nodeath:short:ndp", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:nodeath." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:nodeath:current-percent:ndp", mMT.NameShort .. " " .. L["Health"], L["Same as"] .. " mHealth:current-percent " .. L["and"] .. " mHealth:nodeath " .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:nodeath:short:current-percent:ndp", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:nodeath:current-percent." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:NoAFK:ndp", mMT.NameShort .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat, without AFK Status."] .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:NoAFK:short:ndp", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:NoAFK." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:NoAFK:current-percent:ndp", mMT.NameShort .. " " .. L["Health"], L["Same as"] .. " mHealth:current-percent " .. L["and"] .. " mHealth:NoAFK " .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:NoAFK:short:current-percent:ndp", mMT.NameShort .. " " .. L["Health"], L["Shortened version of"] .. " mHealth:NoAFK:current-percent." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:noStatus:ndp", mMT.NameShort .. " " .. L["Health"], L["no Status version of"] .. " mHealth." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:noStatus:short:ndp", mMT.NameShort .. " " .. L["Health"], L["no Status version of"] .. " mHealth." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:noStatus:current-percent:ndp", mMT.NameShort .. " " .. L["Health"], L["no Status version of"] .. " mHealth." .. L["No decimal values for percentage."])
E:AddTagInfo("mHealth:onlypercent-with-absorbs:ndp:nosign", mMT.NameShort .. " " .. L["Health"], L["Displays the unit's current health as a percentage with absorb values"] .. " " .. L["No decimal values for percentage."], not E.Retail)

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
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit)
	return (UnitRole and (UnitRole == "TANK" or UnitRole == "HEALER")) and format("%s%s|r", colors[UnitRole], UnitRole) or ""
end)

E:AddTag("mRoleIcon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit)
	return UnitRole and icons[UnitRole] or ""
end)

E:AddTag("mRoleIcon:nodd", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit)
	return (UnitRole and (UnitRole == "TANK" or UnitRole == "HEALER")) and icons[UnitRole] or ""
end)

E:AddTag("mRoleIcon:blizz", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit)
	return UnitRole and icons.default[UnitRole] or ""
end)

E:AddTag("mRoleIcon:blizz:nodd", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit)
	return (UnitRole and (UnitRole == "TANK" or UnitRole == "HEALER")) and icons.default[UnitRole] or ""
end)

E:AddTag("mRoleIcon:target", "UNIT_TARGET UNIT_COMBAT", function(unit)
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit .. "target")
	return UnitRole and icons[UnitRole] or ""
end)

E:AddTag("mRoleIcon:target:blizz", "UNIT_TARGET UNIT_COMBAT", function(unit)
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit .. "target")
	return UnitRole and icons.default[UnitRole] or ""
end)

E:AddTagInfo("mRole", mMT.NameShort .. " " .. L["Misc"], L["Tank and Healer roles as text."])
E:AddTagInfo("mRoleIcon", mMT.NameShort .. " " .. L["Misc"], L["Unit role icon."])
E:AddTagInfo("mRoleIcon", mMT.NameShort .. " " .. L["Misc"], L["Unit role icon, only tank and healer."])
E:AddTagInfo("mRoleIcon:target", mMT.NameShort .. " " .. L["Misc"], L["Targetunit role icon."])
E:AddTagInfo("mRoleIcon:blizz", mMT.NameShort .. " " .. L["Misc"], L["Blizzard Unit role icon."])
E:AddTagInfo("mRoleIcon:blizz", mMT.NameShort .. " " .. L["Misc"], L["Blizzard Unit role icon, only tank and healer."])
E:AddTagInfo("mRoleIcon:target:blizz", mMT.NameShort .. " " .. L["Misc"], L["Blizzard Targetunit role icon."])

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

E:AddTag("mLevel:hidecombat", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING UNIT_COMBAT UNIT_FLAGS", function(unit)
	if unit == "player" and IsResting() then
		return format("%sZzz|r", colors.zzz)
	else
		if not UnitAffectingCombat(unit) then
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

E:AddTag("mLevelSmart:hidecombat", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING UNIT_COMBAT UNIT_FLAGS", function(unit)
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
E:AddTagInfo("mLevel:hidecombat", mMT.NameShort .. " " .. L["Level"], L["Same as"] .. " mLevel" .. L[" hidden in combat."])
E:AddTagInfo("mLevel:hideMax", mMT.NameShort .. " " .. L["Level"], L["Same as"] .. " mLevel" .. L[" hidden at maximum level."])
E:AddTagInfo("mLevelSmart", mMT.NameShort .. " " .. L["Level"], L["Smart Level changes to resting in resting Areas."])
E:AddTagInfo("mLevelSmart:hidecombat", mMT.NameShort .. " " .. L["Level"], L["Same as"] .. " mLevelSmart" .. L[" hidden in combat."])
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

E:AddTag("mPower:percent", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit, power)
	if not power then
		power = _TAGS.perpp(unit)
	end

	if power ~= 0 then
		local Role = ""

		if E.Retail or E.Cata then
			Role = UnitGroupRolesAssigned(unit)
		end

		if Role == "HEALER" then
			if power <= 30 then
				return format("|CFFF7DC6F%s|r", power)
			elseif power <= 8 then -- "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\unitframes\\notready03.tga"
				return format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\unitframes\\notready03.tga:15:15:0:2|t|CFFE74C3C%s|r", power)
			else
				return power
			end
		else
			return power
		end
	end
end)

E:AddTag("mPower:percent:hidefull", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	local power = _TAGS.perpp(unit)
	if power ~= 100 then
		return _TAGS["mPower:percent"](unit, power)
	end
end)

E:AddTag("mPower:percent:heal", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit, power)
	local Role = "HEALER"

	if E.Retail or E.Cata then
		Role = UnitGroupRolesAssigned(unit)
	end

	if Role == "HEALER" then
		if not power then
			power = _TAGS.perpp(unit)
		end

		if power ~= 0 then
			if power <= 30 then
				return format("|CFFF7DC6F%s|r", power)
			elseif power <= 8 then
				return format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\unitframes\\notready03.tga:15:15:0:2|t|CFFE74C3C%s|r", power)
			else
				return power
			end
		end
	end
end)

E:AddTag("mPower:percent:heal:hidefull", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	local power = _TAGS.perpp(unit)
	if power ~= 100 then
		return _TAGS["mPower:percent:heal"](unit, power)
	end
end)

E:AddTag("mPower:percent:combat", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	local power = _TAGS.perpp(unit)
	if UnitAffectingCombat(unit) then
		return _TAGS["mPower:percent"](unit, power)
	end
end)

E:AddTag("mPower:percent:heal:combat", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	local power = _TAGS.perpp(unit)
	if UnitAffectingCombat(unit) then
		return _TAGS["mPower:percent:heal"](unit, power)
	end
end)

E:AddTagInfo("mPower:percent", mMT.NameShort .. " " .. L["Power"], L["Displays Power/Mana, with a low healer warning."])
E:AddTagInfo("mPower:percent:hidefull", mMT.NameShort .. " " .. L["Power"], L["Displays Power/Mana, with a low healer warning, hidden when full."])
E:AddTagInfo("mPower:percent:heal", mMT.NameShort .. " " .. L["Power"], L["Displays the healer's Power/Mana, with a low healer warning."])
E:AddTagInfo("mPower:percent:heal:hidefull", mMT.NameShort .. " " .. L["Power"], L["Displays the healer's Power/Mana, with a low healer warning, hidden when full."])
E:AddTagInfo("mPower:percent:combat", mMT.NameShort .. " " .. L["Power"], L["Displays Power/Mana, in combat."])
E:AddTagInfo("mPower:percent:heal:combat", mMT.NameShort .. " " .. L["Power"], L["Displays Power/Mana for Heal only, in combat."])

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
	role = {
		TANK = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\TANK.tga:16:16:0:0:16:16:0:16:0:16",
		HEALER = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\HEAL.tga:16:16:0:0:16:16:0:16:0:16",
		DAMAGER = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\DD.tga:16:16:0:0:16:16:0:16:0:16",
	},
	sticker = {
		TANK = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\stickerTank.tga:16:16:0:0:16:16:0:16:0:16",
		HEALER = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\stickerHeal.tga:16:16:0:0:16:16:0:16:0:16",
		DAMAGER = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\stickerDD.tga:16:16:0:0:16:16:0:16:0:16",
	},
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
				local role = targetTextures.role[UnitGroupRolesAssigned("party" .. i)] or targetTextures.DAMAGER
				local _, unitClass = UnitClass("party" .. i)
				if role and unitClass then
					ClassString = role .. targetStringColors[unitClass] .. ClassString
				end
			end
		end

		if UnitIsUnit("playertarget", unit) then
			local role = targetTextures.role[UnitGroupRolesAssigned("player")] or targetTextures.DAMAGER
			local _, unitClass = UnitClass("player")
			if role and unitClass then
				ClassString = role .. targetStringColors[unitClass] .. ClassString
			end
		end
	else
		for i = 1, GetNumGroupMembers() - 1 do
			if UnitIsUnit("party" .. i .. "target", unit) then
				local _, unitClass = UnitClass("party" .. i)
				if unitClass then
					ClassString = targetTextures[style] .. targetStringColors[unitClass] .. ClassString
				end
			end
		end

		if UnitIsUnit("playertarget", unit) then
			local _, unitClass = UnitClass("player")
			if unitClass then
				ClassString = targetTextures[style] .. targetStringColors[unitClass] .. ClassString
			end
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
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) and (E.Retail or E.Cata) then
		return GetPartyTargetsIcons(unit, "role")
	end
end)

E:AddTag("mTargetMarker", "RAID_TARGET_UPDATE", function(unit)
	local index = GetRaidTargetIndex(unit)
	return CustomRaidTargetIcons[index] or ""
end)

E:AddTagInfo("mTargetMarker", mMT.NameShort .. " " .. L["Misc"], L["mMT Raidtarget marker Icons"])
E:AddTagInfo("mTargetingPlayers", mMT.NameShort .. " " .. L["Misc"], L["Target counter (Party and Raid)."])
E:AddTagInfo("mTargetingPlayers:icons:Flat", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Circle)."])
E:AddTagInfo("mTargetingPlayers:icons:Glas", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Glas Circle)."])
E:AddTagInfo("mTargetingPlayers:icons:SQ", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Square)."])
E:AddTagInfo("mTargetingPlayers:icons:DIA", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Diamond)."])
E:AddTagInfo("mTargetingPlayers:icons:Stop", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Flat Stop shield)."])
E:AddTagInfo("mTargetingPlayers:icons:Role", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Roleicons)."])
E:AddTagInfo("mTargetingPlayers:icons:Sticker", mMT.NameShort .. " " .. L["Misc"], L["Target counter Icon (Roleicons)."])
