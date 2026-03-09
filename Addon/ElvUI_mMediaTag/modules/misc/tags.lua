local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("TAGs", { "AceEvent-3.0" })

-- WoW API locals
local UnitHealth = UnitHealth
local UnitIsPlayer = UnitIsPlayer
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitGUID = UnitGUID
local UnitFactionGroup = UnitFactionGroup
local UnitClassification = UnitClassification
local UnitClass = UnitClass
local UnitLevel = UnitLevel
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitIsPVP = UnitIsPVP
local UnitAffectingCombat = UnitAffectingCombat
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsBattlePetCompanion = UnitIsBattlePetCompanion
local UnitIsWildBattlePet = UnitIsWildBattlePet
local UnitBattlePetLevel = UnitBattlePetLevel
local IsResting = IsResting
local GetInstanceInfo = GetInstanceInfo
local CreateAtlasMarkup = CreateAtlasMarkup
local CreateTextureMarkup = CreateTextureMarkup
local strsplit = strsplit
local format = format
local tostring = tostring
local tonumber = tonumber
local pairs = pairs
local next = next
local type = type

-- Module state
local db = {}
local colors = MEDIA.color.tags
local icons = MEDIA.icons.tags

-- Faction cache
local unitFactionCache = {}

-- Classification labels
local shortClassificationsLabels = {
	rare = L["R"],
	rareelite = L["R+"],
	elite = L["+"],
	worldboss = L["B"],
}
local classificationsLabels = {
	rare = L["Rare"],
	rareelite = L["Rare Elite"],
	elite = L["Elite"],
	worldboss = L["Boss"],
}

local classificationsIcons = {
	rare = icons.cs3,
	rareelite = icons.cs5,
	elite = icons.cs6,
	worldboss = icons.cs8,
}

local roleColors = {
	TANK = colors.tank,
	HEALER = colors.healer,
	DAMAGER = colors.dps,
}

local roleIcons = {
	TANK = icons.tank,
	HEALER = icons.healer,
	DAMAGER = icons.dps,
}

local roleIconsBlizz = {
	TANK = CreateAtlasMarkup("UI-LFG-RoleIcon-Tank", 16, 16),
	HEALER = CreateAtlasMarkup("UI-LFG-RoleIcon-Healer", 16, 16),
	DAMAGER = CreateAtlasMarkup("UI-LFG-RoleIcon-DPS", 16, 16),
}

local roleNames = {
	TANK = L["Tank"],
	HEALER = L["Healer"],
	DAMAGER = L["DPS"],
}

local statusDefinitions = {
	AFK = {
		check = function(unit)
			return E:UnitIsAFK(unit)
		end,
		color = colors.afk,
		label = L["AFK"],
		iconKey = "afk",
	},
	DND = {
		check = function(unit)
			return E:UnitIsDND(unit)
		end,
		color = colors.dnd,
		label = L["DND"],
		iconKey = "dnd",
	},
	Offline = {
		check = function(unit)
			return not UnitIsConnected(unit)
		end,
		color = colors.dc,
		label = L["Offline"],
		iconKey = "dc",
	},
	Dead = {
		check = function(unit)
			return UnitIsDead(unit)
		end,
		color = colors.dead,
		label = L["Dead"],
		iconKey = "dead",
	},
	Ghost = {
		check = function(unit)
			return UnitIsGhost(unit)
		end,
		color = colors.ghost,
		label = L["Ghost"],
		iconKey = "ghost",
	},
}

-- Death-count state
local unitDeathCount = {}
local instanceID = ""
local instanceType = "none"

local function GetColorString(color)
	return color and ":" .. tostring(color.r * 255) .. ":" .. tostring(color.g * 255) .. ":" .. tostring(color.b * 255) .. "|t"
end

local function GetFactionData(unit)
	if not UnitIsPlayer(unit) then return end

	local guid = UnitGUID(unit)
	if not guid then return end

	if not unitFactionCache[guid] then
		local factionGroup = UnitFactionGroup(unit)
		if factionGroup then unitFactionCache[guid] = {
			CreateTextureMarkup("Interface\\FriendsFrame\\PlusManz-" .. factionGroup, 16, 16, 16, 16, 0, 1, 0, 1, 0, 0),
			factionGroup,
		} end
	end

	return unitFactionCache[guid], guid
end

local TagDeathCount

local function UpdateDeathCount(unit)
	if not UnitIsPlayer(unit) then return end

	local guid = UnitGUID(unit)
	if not guid then return end

	local isDead = UnitIsDead(unit) or UnitIsGhost(unit)
	local data = unitDeathCount[guid]

	if isDead then
		if not data then
			unitDeathCount[guid] = { true, 1 }
		elseif not data[1] then
			data[1], data[2] = true, data[2] + 1
		end
	else
		if data then data[1] = false end
	end

	return data and data[2] >= 1 and data[2] or nil
end

TagDeathCount = function()
	local instanceInfo = { GetInstanceInfo() }
	local iID, iType = tostring(instanceInfo[8]), tostring(instanceInfo[2])

	if instanceType == "none" and iType ~= "none" then
		instanceType = iType
	elseif instanceType ~= "none" and iType == "none" and unitFactionCache then
		unitFactionCache = {}
	end

	if iID ~= instanceID then
		instanceID = iID
		unitDeathCount = {}
	end
end

local function RebuildRoleTables()
	roleColors.TANK = colors.tank
	roleColors.HEALER = colors.healer
	roleColors.DAMAGER = colors.dps

	roleIcons.TANK = icons[db.misc.tank]
	roleIcons.HEALER = icons[db.misc.healer]
	roleIcons.DAMAGER = icons[db.misc.dps]
end

local function RebuildClassificationIcons()
	classificationsIcons.rare = icons[db.classification.rare]
	classificationsIcons.rareelite = icons[db.classification.rareelite]
	classificationsIcons.elite = icons[db.classification.elite]
	classificationsIcons.worldboss = icons[db.classification.worldboss]
end

local function RebuildStatusIcons()
	statusDefinitions.AFK.icon = icons[db.status.afk]
	statusDefinitions.DND.icon = icons[db.status.dnd]
	statusDefinitions.Offline.icon = icons[db.status.dc]
	statusDefinitions.Dead.icon = icons[db.status.dead]
	statusDefinitions.Ghost.icon = icons[db.status.ghost]
end

E:AddTag("mMT-classification", "UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = UnitClassification(unit)
	if not c then return end

	if args then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then return colors[c] and classificationsLabels[c] and colors[c]:WrapTextInColorCode(classificationsLabels[c]) end
		return -- args set, but no match → show nothing
	end

	return colors[c] and classificationsLabels[c] and colors[c]:WrapTextInColorCode(classificationsLabels[c])
end)
E:AddTagInfo(
	"mMT-classification",
	mMT.NameShort .. " " .. L["Classification"],
	L["Returns the classification of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification{rare:elite}] will only show something if the unit is either rare or elite."]
)

E:AddTag("mMT-classification:short", "UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = UnitClassification(unit)
	if not c then return end

	if args then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then return colors[c] and shortClassificationsLabels[c] and colors[c]:WrapTextInColorCode(shortClassificationsLabels[c]) end
		return -- args set, but no match → show nothing
	end

	return colors[c] and shortClassificationsLabels[c] and colors[c]:WrapTextInColorCode(shortClassificationsLabels[c])
end)
E:AddTagInfo("mMT-classification:short", mMT.NameShort .. " " .. L["Classification"], L["Short Version."])

E:AddTag("mMT-classification:icon", "UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = UnitClassification(unit)
	if not c then return end

	local color = GetColorString(colors[c])

	if args then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then return (c and color) and "|T" .. classificationsIcons[c] .. ":16:16:0:0:16:16:0:16:0:16" .. color or "" end
		return -- args set, but no match → show nothing
	end

	return (c and color) and "|T" .. classificationsIcons[c] .. ":16:16:0:0:16:16:0:16:0:16" .. color or ""
end)
E:AddTagInfo(
	"mMT-classification:icon",
	mMT.NameShort .. " " .. L["Classification"],
	L["Returns the classification icon of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification:icon{rare:elite}] will only show something if the unit is either rare or elite."]
)

E:AddTag("mMT-status", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end
end)
E:AddTagInfo("mMT-status", mMT.NameShort .. " " .. L["Status"], L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost)."])

E:AddTag("mMT-status:icon", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then
			local icon = def.icon
			local color = GetColorString(def.color)
			return (color and icon) and "|T" .. icon .. ":16:16:0:0:16:16:0:16:0:16" .. color
		end
	end
end)
E:AddTagInfo("mMT-status:icon", mMT.NameShort .. " " .. L["Status"], L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost)."])

E:AddTag("mMT-color", "UNIT_NAME_UPDATE UNIT_FACTION UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = UnitClassification(unit)
	local isPlayer = UnitIsPlayer(unit)

	if args and c then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then
			return "|c" .. colors[c].hex
		else
			return _TAGS.classcolor(unit)
		end
	end

	return isPlayer and _TAGS.classcolor(unit) or colors[c] and "|c" .. colors[c].hex or _TAGS.classcolor(unit)
end)
E:AddTagInfo(
	"mMT-color",
	mMT.NameShort .. " " .. L["Color"],
	L["Returns the color of the unit. Players are colored by class, NPCs by classification. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-color{rare:elite}] will only show something if the unit is either rare or elite."]
)

E:AddTag("mMT-color:target", "UNIT_TARGET", function(unit, _, args)
	local target = unit .. "target"
	local c = UnitClassification(target)
	local isPlayer = UnitIsPlayer(target)

	if args and c then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then
			return "|c" .. colors[c].hex
		else
			return _TAGS.classcolor(target)
		end
	end
	return isPlayer and _TAGS.classcolor(target) or colors[c] and "|c" .. colors[c].hex or _TAGS.classcolor(target)
end)
E:AddTagInfo("mMT-color:target", mMT.NameShort .. " " .. L["Color"], L["Same as mMT-color, but only for the units target."])

E:AddTag("mMT-health", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	if UnitAffectingCombat(unit) then
		return _TAGS.perhp(unit)
	else
		return E:AbbreviateNumbers(currentHealth, E.Abbreviate["long"])
	end
end)
E:AddTagInfo("mMT-health", mMT.NameShort .. " " .. L["Health"], L["Returns the current health of the unit (changes between current health and percent in combat)."])

E:AddTag("mMT-health:short", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	local currentHealth = UnitHealth(unit)
	if UnitAffectingCombat(unit) then
		return _TAGS.perhp(unit)
	else
		return E:AbbreviateNumbers(currentHealth, E.Abbreviate["short"])
	end
end)
E:AddTagInfo("mMT-health:short", mMT.NameShort .. " " .. L["Health"], L["Short Version."])

E:AddTag("mMT-deathcount", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then return end
	return UpdateDeathCount(unit)
end)
E:AddTagInfo("mMT-deathcount", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the number of times the player has died since you entered the instance. Resets when you leave the instance."])

E:AddTag("mMT-deathcount:ifdeath", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then return end
	local count = UpdateDeathCount(unit)
	if UnitIsDead(unit) or UnitIsGhost(unit) then return count end
end)
E:AddTagInfo("mMT-deathcount:ifdeath", mMT.NameShort .. " " .. L["Miscellaneous"], L["Same as mMT-deathcount, but only shows the count while the player is dead."])

E:AddTag("mMT-role", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = UnitGroupRolesAssigned(unit)
	return unitRole and roleColors[unitRole]:WrapTextInColorCode(roleNames[unitRole]) or ""
end)
E:AddTagInfo("mMT-role", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role of the unit (Tank, Healer, DPS)."])

E:AddTag("mMT-role:icon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = UnitGroupRolesAssigned(unit)
	return unitRole and E:TextureString(roleIcons[unitRole], ":14:14") or ""
end)
E:AddTagInfo("mMT-role:icon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

E:AddTag("mMT-role:icon:blizz", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = UnitGroupRolesAssigned(unit)
	return unitRole and roleIconsBlizz[unitRole] or ""
end)
E:AddTagInfo("mMT-role:icon:blizz", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

E:AddTag("mMT-role:target", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = UnitGroupRolesAssigned(unit .. "target")
	return unitRole and roleColors[unitRole]:WrapTextInColorCode(roleNames[unitRole]) or ""
end)
E:AddTagInfo("mMT-role:target", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role of the unit (Tank, Healer, DPS)."])

E:AddTag("mMT-role:target:icon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = UnitGroupRolesAssigned(unit .. "target")
	return unitRole and E:TextureString(roleIcons[unitRole], ":14:14") or ""
end)
E:AddTagInfo("mMT-role:target:icon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

E:AddTag("mMT-role:target:icon:blizz", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = UnitGroupRolesAssigned(unit .. "target")
	return unitRole and roleIconsBlizz[unitRole] or ""
end)
E:AddTagInfo("mMT-role:target:icon:blizz", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

E:AddTag("mMT-level", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return colors.resting:WrapTextInColorCode("Zzz")
	else
		local level = UnitLevel(unit)
		if UnitIsWildBattlePet(unit) then
			return UnitBattlePetLevel(unit)
		elseif level > 0 then
			return level
		else
			return colors.worldboss:WrapTextInColorCode("??")
		end
	end
end)
E:AddTagInfo("mMT-level", mMT.NameShort .. " " .. L["Level"], L["Returns the level of the unit. If the unit is at max level. If the player is resting, it will return a Zzz."])

E:AddTag("mMT-level:smart", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return colors.resting:WrapTextInColorCode("Zzz")
	else
		local level = UnitEffectiveLevel(unit)
		if UnitIsBattlePetCompanion(unit) then
			return UnitBattlePetLevel(unit)
		elseif level == UnitEffectiveLevel("player") then
			return nil
		elseif level > 0 then
			return level
		else
			return colors.worldboss:WrapTextInColorCode("??")
		end
	end
end)
E:AddTagInfo(
	"mMT-level:smart",
	mMT.NameShort .. " " .. L["Level"],
	L["Returns the level of the unit. If the unit is at max level or the same level as you, it will return nothing. If the player is resting, it will return a Zzz."]
)

E:AddTag("mMT-pvp", "UNIT_FACTION", function(unit)
	local factionGroup = UnitFactionGroup(unit)
	if UnitIsPVP(unit) and (factionGroup == "Horde" or factionGroup == "Alliance") then return E:TextureString(icons[db.misc.pvp], ":14:14") end
end)
E:AddTagInfo("mMT-pvp", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns a PvP icon if the unit is flagged for PvP and belongs to either the Horde or Alliance faction."])

E:AddTag("mMT-faction", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	if data and (data[2] == "Horde" or data[2] == "Alliance") then return data[2] end
end)
E:AddTagInfo("mMT-faction", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the faction of the unit (Horde or Alliance)."])

E:AddTag("mMT-faction:icon", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	return data and data[1]
end)
E:AddTagInfo("mMT-faction:icon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the faction icon of the unit (Horde or Alliance)."])

E:AddTag("mMT-faction:opposite", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	local factionPlayer = UnitFactionGroup("Player")
	if data and (data[2] == "Horde" or data[2] == "Alliance") and data[2] ~= factionPlayer then return data[2] end
end)
E:AddTagInfo("mMT-faction:opposite", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the faction of the unit (Horde or Alliance), but only if it's the opposite faction of the player."])

E:AddTag("mMT-faction:icon:opposite", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	local factionPlayer = UnitFactionGroup("Player")
	if data and (data[2] == "Horde" or data[2] == "Alliance") and data[2] ~= factionPlayer then return data[1] end
end)
E:AddTagInfo(
	"mMT-faction:icon:opposite",
	mMT.NameShort .. " " .. L["Miscellaneous"],
	L["Returns the faction icon of the unit (Horde or Alliance), but only if it's the opposite faction of the player."]
)

E:AddTag("mMT-power", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	if UnitAffectingCombat(unit) then return _TAGS.perpp(unit) end
end)
E:AddTagInfo("mMT-power", mMT.NameShort .. " " .. L["Power"], L["Returns the current power percent of the unit, but only while in combat."])

E:AddTag("mMT-questicon", "QUEST_LOG_UPDATE", function(unit)
	if UnitIsPlayer(unit) then return end
	local isQuest = _TAGS["quest:title"](unit)
	if isQuest then
		local icon = icons[db.misc.quest]
		local color = GetColorString(colors.quest)
		return (color and icon) and "|T" .. icon .. ":16:16:0:0:16:16:0:16:0:16" .. color
	end
end)
E:AddTagInfo("mMT-questicon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns a quest icon if the unit is a quest mob."])

-- CLASS ICONS
do
	local classIconNames = {}
	for k, v in pairs(MEDIA.icons.class.icons.mmt) do
		if type(v) == "table" then classIconNames[k] = v.name end
	end
	for k, v in pairs(MEDIA.icons.class.icons.custom) do
		if type(v) == "table" and k ~= "BLIZZARD" then classIconNames[k] = v.name end
	end

	for style, _ in next, classIconNames do
		local tag = format("%s:%s", "mMT-classicons", style)
		E:AddTag(tag, "UNIT_NAME_UPDATE", function(unit, _, args)
			if not (UnitIsPlayer(unit) or (E.Retail and UnitInPartyIsAI(unit))) then return end

			local _, class = UnitClass(unit)
			if not class then return end

			local size = strsplit(":", args or "")
			size = tonumber(size)
			size = (size and (size >= 16 and size <= 128)) and size or 64

			local classIconStrings = MEDIA.icons.class.icons.custom[style] and MEDIA.icons.class.icons.custom[style].texString[class] or MEDIA.icons.class.data[class].texString
			local textureFile = MEDIA.icons.class.icons.custom[style] and MEDIA.icons.class.icons.custom[style].texture or MEDIA.icons.class.icons.mmt[style].texture
			if textureFile and classIconStrings then return format("|T%s:%s:%s:0:0:1024:1024:%s|t", textureFile, size, size, classIconStrings) end
		end)
		E:AddTagInfo(tag, mMT.NameShort .. " " .. L["Icons"], L["Returns the class icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mClassIcon:style{32}"])
	end
end

function module:Initialize()
	db = E.db.mMediaTag.tags

	RebuildRoleTables()
	RebuildClassificationIcons()
	RebuildStatusIcons()

	if not module.initialized then
		module:RegisterEvent("PLAYER_ENTERING_WORLD")
		module:RegisterEvent("UPDATE_INSTANCE_INFO")
		module.initialized = true
	end
end

function module:PLAYER_ENTERING_WORLD()
	db = E.db.mMediaTag.tags
	RebuildRoleTables()
end

function module:UPDATE_INSTANCE_INFO()
	TagDeathCount()
end
