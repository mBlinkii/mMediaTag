local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("TAGs", { "AceEvent-3.0" })

local UnitName = UnitName
local IsInInstance = IsInInstance
local db = {}
local colors = MEDIA.color.tags
local icons = MEDIA.icons.tags
local UnitFaction = {}

-- NAME
-- FUNCTIONS
local function GetName(unit, length)
	local name = UnitName(unit)
	return name and E:ShortenString(name, length)
end

-- TAGS
E:AddTag("mName:last", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local inInstance = IsInInstance()
	return inInstance and _TAGS["name:last"](unit) or UnitName(unit)
end)
E:AddTagInfo("mName:last", mMT.NameShort .. " " .. L["Name"], L["Returns the name of the unit. If in an instance, it will return the last word of the name."])

E:AddTag("mName:status", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
	local status = _TAGS.mStatus(unit)
	if status then return status end
	local name = UnitName(unit)
	return name and name
end)
E:AddTagInfo("mName:status", mMT.NameShort .. " " .. L["Name"], L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost) or the name of the unit."])

E:AddTag("mName:statusicon", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
	local statusIcon = _TAGS["mStatus:icon"](unit)
	if statusIcon then return statusIcon end
	local name = UnitName(unit)
	return name and name
end)
E:AddTagInfo("mName:statusicon", mMT.NameShort .. " " .. L["Name"], L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost) or the name of the unit."])

for textFormat, length in pairs({ veryshort = 5, short = 10, medium = 15, long = 20 }) do
	E:AddTag("mName:last:" .. textFormat, "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local inInstance = IsInInstance()
		local name = inInstance and _TAGS["name:last"](unit) or UnitName(unit)
		return name and E:ShortenString(name, length)
	end)
	E:AddTagInfo("mName:last:" .. textFormat, mMT.NameShort .. " " .. L["Name"], L["Short Version."])

	E:AddTag("mName:status:" .. textFormat, "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
		local status = _TAGS.mStatus(unit)
		if status then return status end
		return GetName(unit, length)
	end)
	E:AddTagInfo("mName:status:" .. textFormat, mMT.NameShort .. " " .. L["Name"], L["Short Version."])

	E:AddTag("mName:statusicon:" .. textFormat, "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
		local statusIcon = _TAGS["mStatus:icon"](unit)
		if statusIcon then return statusIcon end
		return GetName(unit, length)
	end)
	E:AddTagInfo("mName:statusicon:" .. textFormat, mMT.NameShort .. " " .. L["Name"], L["Short Version."])
end

-- CLASSIFICATION
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
-- FUNCTIONS
local function GetClassification(unit)
	local c = UnitClassification(unit)
	local guid = UnitGUID(unit)
	local npcID = guid and select(6, strsplit("-", guid))
	return (npcID and (mMT.IDs.boss[npcID] or DB.boss_ids[npcID])) and "worldboss" or c
end

local function GetColorString(color)
	return color and ":" .. tostring(color.r * 255) .. ":" .. tostring(color.g * 255) .. ":" .. tostring(color.b * 255) .. "|t"
end

E:AddTag("mClass", "UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = GetClassification(unit)
	if not c then return end

	if args then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then return colors[c] and shortClassificationsLabels[c] and colors[c]:WrapTextInColorCode(shortClassificationsLabels[c]) end
		return -- args set, but no match → show nothing
	end

	return colors[c] and shortClassificationsLabels[c] and colors[c]:WrapTextInColorCode(shortClassificationsLabels[c])
end)
E:AddTagInfo(
	"mClass",
	mMT.NameShort .. " " .. L["Classification"],
	L["Returns the classification of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mClass{rare:elite}] will only show something if the unit is either rare or elite."]
)

E:AddTag("mClass:short", "UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = GetClassification(unit)
	if not c then return end

	if args then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then return colors[c] and classificationsLabels[c] and colors[c]:WrapTextInColorCode(classificationsLabels[c]) end
		return -- args set, but no match → show nothing
	end

	return colors[c] and classificationsLabels[c] and colors[c]:WrapTextInColorCode(classificationsLabels[c])
end)
E:AddTagInfo("mClass:short", mMT.NameShort .. " " .. L["Classification"], L["Short Version."])

E:AddTag("mClass:icon", "UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = GetClassification(unit)
	if not c then return end

	local color = GetColorString(colors[c])

	if args then
		local arg1, arg2, arg3 = strsplit(":", args)
		if c == arg1 or c == arg2 or c == arg3 then return (c and color) and "|T" .. icons[db.classification[c]] .. ":16:16:0:0:16:16:0:16:0:16" .. color or "" end
		return -- args set, but no match → show nothing
	end

	return (c and color) and "|T" .. icons[db.classification[c]] .. ":16:16:0:0:16:16:0:16:0:16" .. color or ""
end)
E:AddTagInfo(
	"mClass:icon",
	mMT.NameShort .. " " .. L["Classification"],
	L["Returns the classification icon of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mClass:icon{rare:elite}] will only show something if the unit is either rare or elite."]
)

-- STATUS
-- FUNCTION

local statusDefinitions = {
	AFK = { check = UnitIsAFK, color = colors.afk, label = L["AFK"], iconKey = "afk" },
	DND = { check = UnitIsDND, color = colors.dnd, label = L["DND"], iconKey = "dnd" },
	Offline = {
		check = function(u)
			return not UnitIsConnected(u)
		end,
		color = colors.dc,
		label = L["Offline"],
		iconKey = "dc",
	},
	Dead = { check = UnitIsDead, color = colors.dead, label = L["Dead"], iconKey = "dead" },
	Ghost = { check = UnitIsGhost, color = colors.ghost, label = L["Ghost"], iconKey = "ghost" },
}

-- TAGS
E:AddTag("mStatus", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end
end)
E:AddTagInfo("mStatus", mMT.NameShort .. " " .. L["Status"], L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost)."])

E:AddTag("mStatus:icon", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then
			local icon = icons[db.status[def.iconKey]]
			local color = GetColorString(def.color)
			return "|T" .. icon .. ":16:16:0:0:16:16:0:16:0:16" .. color
		end
	end
end)
E:AddTagInfo("mStatus:icon", mMT.NameShort .. " " .. L["Status"], L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost)."])

-- COLOR
E:AddTag("mColor", "UNIT_NAME_UPDATE UNIT_FACTION UNIT_CLASSIFICATION_CHANGED", function(unit, _, args)
	local c = GetClassification(unit)
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
	"mColor",
	mMT.NameShort .. " " .. L["Color"],
	L["Returns the color of the unit. Players are colored by class, NPCs by classification. You can specify up to three arguments to display only certain classifications.\nFor example: [mColor{rare:elite}] will only show something if the unit is either rare or elite."]
)

E:AddTag("mColor:target", "UNIT_TARGET", function(unit, _, args)
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
E:AddTagInfo("mColor:target", mMT.NameShort .. " " .. L["Color"], L["Same as mColor, but only for the units target."])

-- Health
-- FUNCTION
local function GetSmartHealth(unit, short)
	local current = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	local percent = current / max * 100

	if current > 0 and current < max then
		return (percent < db.healthThreshold1) and format("%.1f", percent) or (percent < db.healthThreshold2) and format("%.2f", percent) or format("%.0f", percent)
	else
		return E:GetFormattedText("CURRENT", current, max, nil, short)
	end
end

local function GetAbsorbHealth(unit, short)
	local current = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	local absorb = UnitGetTotalAbsorbs(unit) or 0
	local total = current + absorb
	local percent = total / max * 100

	if current > 0 and current < max then
		return (percent < db.healthThreshold1) and format("%.1f", percent) or (percent < db.healthThreshold2) and format("%.2f", percent) or format("%.0f", percent)
	else
		return E:GetFormattedText("CURRENT", total, max, nil, short)
	end
end

local function GetCurrentPercentHealth(unit, short)
	local current = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	local deficit = max - current
	local percent = current / max * 100

	if deficit > 0 and current > 0 then
		return format(
			"%s | %s",
			E:GetFormattedText("CURRENT", current, max, nil, short),
			(percent < db.healthThreshold1) and format("%.1f", percent) or (percent < db.healthThreshold2) and format("%.2f", percent) or format("%.0f", percent)
		)
	else
		return E:GetFormattedText("CURRENT", current, max, nil, short)
	end
end

-- TAGS
E:AddTag("mHealth", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end

	return GetSmartHealth(unit, false)
end)
E:AddTagInfo(
	"mHealth",
	mMT.NameShort .. " " .. L["Health"],
	L["Returns the current health of the unit (changes between max health and percent in combat) or it will return the status (AFK, DND, Offline, Dead, Ghost)."]
)

E:AddTag("mHealth:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end

	return GetSmartHealth(unit, true)
end)
E:AddTagInfo("mHealth:short", mMT.NameShort .. " " .. L["Health"], L["Short Version."])

E:AddTag("mHealth:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end

	return GetAbsorbHealth(unit, false)
end, not E.Retail)
E:AddTagInfo(
	"mHealth:absorbs",
	mMT.NameShort .. " " .. L["Health"],
	L["Returns the current health of the unit (changes between max health and percent in combat) including absorbs or it will return the status (AFK, DND, Offline, Dead, Ghost)."]
)

E:AddTag("mHealth:short:absorbs", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end

	return GetAbsorbHealth(unit, true)
end, not E.Retail)
E:AddTagInfo("mHealth:short:absorbs", mMT.NameShort .. " " .. L["Health"], L["Short Version."])

E:AddTag("mHealth:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	return GetSmartHealth(unit, false)
end)
E:AddTagInfo("mHealth:noStatus", mMT.NameShort .. " " .. L["Health"], L["Returns the current health of the unit (changes between max health and percent in combat). Does not return status."])

E:AddTag("mHealth:short:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	return GetSmartHealth(unit, true)
end)
E:AddTagInfo("mHealth:short:noStatus", mMT.NameShort .. " " .. L["Health"], L["Short Version."])

E:AddTag("mHealth:absorbs:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end

	return GetAbsorbHealth(unit, true)
end, not E.Retail)
E:AddTagInfo("mHealth:absorbs:noStatus", mMT.NameShort .. " " .. L["Health"], L["Short Version"])

E:AddTag("mHealth:short:absorbs:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	return GetAbsorbHealth(unit, false)
end, not E.Retail)
E:AddTagInfo("mHealth:short:absorbs:noStatus", mMT.NameShort .. " " .. L["Health"], L["Short Version."])

E:AddTag("mHealth:current-percent", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end

	return GetCurrentPercentHealth(unit, false)
end)
E:AddTagInfo("mHealth:current-percent", mMT.NameShort .. " " .. L["Health"], L["Returns the current health and percent of the unit or it will return the status (AFK, DND, Offline, Dead, Ghost)."])

E:AddTag("mHealth:current-percent:short", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
	for _, def in pairs(statusDefinitions) do
		if def.check(unit) then return def.color:WrapTextInColorCode(def.label) end
	end

	return GetCurrentPercentHealth(unit, true)
end)
E:AddTagInfo("mHealth:current-percent:short", mMT.NameShort .. " " .. L["Health"], L["Short Version."])

E:AddTag("mHealth:current-percent:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	return GetCurrentPercentHealth(unit, false)
end)
E:AddTagInfo(
	"mHealth:current-percent:noStatus",
	mMT.NameShort .. " " .. L["Health"],
	L["Returns the current health and percent of the unit or it will return the status (AFK, DND, Offline, Dead, Ghost)."]
)

E:AddTag("mHealth:current-percent:short:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	return GetCurrentPercentHealth(unit, true)
end)
E:AddTagInfo("mHealth:current-percent:short:noStatus", mMT.NameShort .. " " .. L["Health"], L["Short Version."])

-- DEATH
-- FUNCTION
local UnitDeathCount, instanceID, instanceType = {}, "", "none"

local function TagDeathCount()
	local instanceInfo = { GetInstanceInfo() }
	local iID, iType = tostring(instanceInfo[8]), tostring(instanceInfo[2])

	if instanceType == "none" and iType ~= "none" then
		instanceType = iType
	elseif instanceType ~= "none" and iType == "none" and UnitFaction then
		UnitFaction = {}
	end

	if iID ~= instanceID then
		instanceID = iID
		UnitDeathCount = {}
	end
end

local function UpdateDeathCount(unit)
	if not UnitIsPlayer(unit) then return end

	local guid = UnitGUID(unit)
	if not guid then return end

	local isDead = UnitIsDead(unit) or UnitIsGhost(unit)
	local data = UnitDeathCount[guid]

	if isDead then
		if not data then
			UnitDeathCount[guid] = { true, 1 }
		elseif not data[1] then
			data[1], data[2] = true, data[2] + 1
		end
	else
		if data then data[1] = false end
	end

	return data and data[2] >= 1 and data[2] or nil
end

E:AddTag("mDeathCount", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then return end
	return UpdateDeathCount(unit)
end)
E:AddTagInfo("mDeathCount", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the number of times the player has died since you entered the instance. Resets when you leave the instance."])

E:AddTag("mDeathCount:onlyDeath", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then return end
	local count = UpdateDeathCount(unit)
	if UnitIsDead(unit) or UnitIsGhost(unit) then return count end
end)
E:AddTagInfo("mDeathCount:onlyDeath", mMT.NameShort .. " " .. L["Miscellaneous"], L["Same as mDeathCount, but only shows the count while the player is dead."])

-- ROlE ICON
local roleColors = {
	TANK = colors.tank,
	HEALER = colors.healer,
	DPS = colors.dps,
}

local roleIcons = {
	TANK = icons.tank,
	HEALER = icons.healer,
	DPS = icons.dps,
}

local roleIconsBlizz = {
	TANK = CreateAtlasMarkup("UI-LFG-RoleIcon-Tank", 16, 16),
	HEALER = CreateAtlasMarkup("UI-LFG-RoleIcon-Healer", 16, 16),
	DAMAGER = CreateAtlasMarkup("UI-LFG-RoleIcon-DPS", 16, 16),
}

local roleNames = {
	TANK = L["Tank"],
	HEALER = L["Healer"],
	DPS = L["DPS"],
}

E:AddTag("mRole", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = (E.Retail or E.Mists) and UnitGroupRolesAssigned(unit)
	return unitRole and roleColors[unitRole]:WrapTextInColorCode(roleNames[unitRole]) or ""
end)
E:AddTagInfo("mRole", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role of the unit (Tank, Healer, DPS)."])

E:AddTag("mRole:icon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = (E.Retail or E.Mists) and UnitGroupRolesAssigned(unit)
	return unitRole and E:TextureString(roleIcons[unitRole], ":14:14") or ""
end)
E:AddTagInfo("mRole:icon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

E:AddTag("mRole:icon:blizz", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = (E.Retail or E.Mists) and UnitGroupRolesAssigned(unit)
	return unitRole and roleIconsBlizz[unitRole] or ""
end)
E:AddTagInfo("mRole:icon:blizz", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

E:AddTag("mRole:target", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = (E.Retail or E.Mists) and UnitGroupRolesAssigned(unit .. "target")
	return unitRole and roleColors[unitRole]:WrapTextInColorCode(roleNames[unitRole]) or ""
end)
E:AddTagInfo("mRole:target", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role of the unit (Tank, Healer, DPS)."])

E:AddTag("mRole:target:icon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = (E.Retail or E.Mists) and UnitGroupRolesAssigned(unit .. "target")
	return unitRole and E:TextureString(roleIcons[unitRole], ":14:14") or ""
end)
E:AddTagInfo("mRole:target:icon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

E:AddTag("mRole:target:icon:blizz", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local unitRole = (E.Retail or E.Mists) and UnitGroupRolesAssigned(unit .. "target")
	return unitRole and roleIconsBlizz[unitRole] or ""
end)
E:AddTagInfo("mRole:target:icon:blizz", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the role icon of the unit (Tank, Healer, DPS)."])

-- LEVEL
E:AddTag("mLevel", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return colors.resting:WrapTextInColorCode("Zzz")
	else
		local level = UnitLevel(unit)
		if not E.Classic and (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)) then
			return UnitBattlePetLevel(unit)
		elseif level > 0 then
			return level
		else
			return colors.worldboss:WrapTextInColorCode("??")
		end
	end
end)
E:AddTagInfo("mLevel", mMT.NameShort .. " " .. L["Level"], L["Returns the level of the unit. If the unit is at max level. If the player is resting, it will return a Zzz."])

E:AddTag("mLevel:smart", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return colors.resting:WrapTextInColorCode("Zzz")
	else
		local level = UnitEffectiveLevel(unit)
		if not E.Classic and (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)) then
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
	"mLevel:smart",
	mMT.NameShort .. " " .. L["Level"],
	L["Returns the level of the unit. If the unit is at max level or the same level as you, it will return nothing. If the player is resting, it will return a Zzz."]
)

-- PVP & FACTION
-- FUNCTIONS
local function GetFactionData(unit)
	if not UnitIsPlayer(unit) then return end

	local guid = UnitGUID(unit)
	if not guid then return end

	if not UnitFaction[guid] then
		local factionGroup = UnitFactionGroup(unit)
		if factionGroup then UnitFaction[guid] = {
			CreateTextureMarkup("Interface\\FriendsFrame\\PlusManz-" .. factionGroup, 16, 16, 16, 16, 0, 1, 0, 1, 0, 0),
			factionGroup,
		} end
	end

	return UnitFaction[guid], guid
end

E:AddTag("mPvP:icon", "UNIT_FACTION", function(unit)
	local factionGroup = UnitFactionGroup(unit)
	if (UnitIsPVP(unit)) and (factionGroup == "Horde" or factionGroup == "Alliance") then return E:TextureString(icons[db.misc.pvp], ":14:14") end
end)
E:AddTagInfo("mPvP:icon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns a PvP icon if the unit is flagged for PvP and belongs to either the Horde or Alliance faction."])

E:AddTag("mFaction", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	if data and (data[2] == "Horde" or data[2] == "Alliance") then return data[2] end
end)
E:AddTagInfo("mFaction", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the faction of the unit (Horde or Alliance)."])

E:AddTag("mFaction:icon", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	return data and data[1]
end)
E:AddTagInfo("mFaction:icon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the faction icon of the unit (Horde or Alliance)."])

E:AddTag("mFaction:opposite", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	local factionPlayer = UnitFactionGroup("Player")
	if data and (data[2] == "Horde" or data[2] == "Alliance") and data[2] ~= factionPlayer then return data[2] end
end)
E:AddTagInfo("mFaction:opposite", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the faction of the unit (Horde or Alliance), but only if it's the opposite faction of the player."])

E:AddTag("mFaction:icon:opposite", "UNIT_FACTION", function(unit)
	local data = GetFactionData(unit)
	local factionPlayer = UnitFactionGroup("Player")
	if data and (data[2] == "Horde" or data[2] == "Alliance") and data[2] ~= factionPlayer then return data[1] end
end)
E:AddTagInfo("mFaction:icon:opposite", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the faction icon of the unit (Horde or Alliance), but only if it's the opposite faction of the player."])

-- POWER & QUEST
E:AddTag("mPower", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT", function(unit)
	if UnitAffectingCombat(unit) then return _TAGS.perpp(unit) end
end)
E:AddTagInfo("mPower", mMT.NameShort .. " " .. L["Power"], L["Returns the current power percent of the unit, but only while in combat."])

E:AddTag("mQuestIcon", "QUEST_LOG_UPDATE", function(unit)
	if UnitIsPlayer(unit) then return end
	local isQuest = E.TagFunctions.GetQuestData(unit, "title", "FFFFFFFF")
	if isQuest then
		local icon = icons[db.misc.quest]
		local color = GetColorString(colors.quest)
		return "|T" .. icon .. ":16:16:0:0:16:16:0:16:0:16" .. color
	end
end)
E:AddTagInfo("mQuestIcon", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns a quest icon if the unit is a quest mob."])

-- TARGET ICONS
-- FUNCTIONS
local function CountTargets(unit, prefix, count)
	local amount = 0
	for i = 1, count do
		if UnitIsUnit(prefix .. i .. "target", unit) then amount = amount + 1 end
	end
	if UnitIsUnit("playertarget", unit) then amount = amount + 1 end
	return amount > 0 and amount or nil
end

local function GetPartyTargets(unit)
	return CountTargets(unit, "party", GetNumGroupMembers() - 1)
end

local function GetRaidTargets(unit)
	return CountTargets(unit, "raid", GetNumGroupMembers())
end

-- Generiert Icon-Strings für Spieler, die ein Ziel anvisieren
local function GetPartyTargetsIcons(unit, icon)
	local result = ""

	local function AddIcon(source)
		local _, class = UnitClass(source)
		local color = RAID_CLASS_COLORS[class]
		if not color then return end

		local colorString = GetColorString(color)
		local iconString = "|T" .. icon .. ":16:16:0:0:16:16:0:16:0:16" .. colorString

		if iconString then result = iconString .. result end
	end

	for i = 1, GetNumGroupMembers() - 1 do
		if UnitIsUnit("party" .. i .. "target", unit) then AddIcon("party" .. i) end
	end

	if UnitIsUnit("playertarget", unit) then AddIcon("player") end

	return result ~= "" and result or ""
end

-- TARGET ICONS & RAIDMARKERS
E:AddTag("mTargetingPlayers", 2, function(unit)
	if InCombatLockdown() and UnitAffectingCombat(unit) then return IsInRaid() and GetRaidTargets(unit) or IsInGroup() and GetPartyTargets(unit) end
end)
E:AddTagInfo("mTargetingPlayers", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the number of players currently targeting the unit, but only while in combat."])

E:AddTag("mTargetingPlayers:icons", 2, function(unit)
	if InCombatLockdown() and UnitAffectingCombat(unit) and IsInGroup() then return GetPartyTargetsIcons(unit, icons[db.misc.targeting]) end
end)
E:AddTagInfo("mTargetingPlayers:icons", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns icons of players currently targeting the unit, but only while in combat."])

E:AddTag("mRaidTargetMarkers", "RAID_TARGET_UPDATE", function(unit)
	local index = GetRaidTargetIndex(unit)
		local icon = icons[db.raidtargetmarkers[index]]
		local color = GetColorString(colors[index])
		return "|T" .. icon .. ":16:16:0:0:16:16:0:16:0:16" .. color
end)
E:AddTagInfo("mRaidTargetMarkers", mMT.NameShort .. " " .. L["Miscellaneous"], L["Returns the raid target marker icon of the unit."])

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
		local tag = format("%s:%s", "mClassIcon", style)
		E:AddTag(tag, "UNIT_NAME_UPDATE", function(unit, _, args)
			if not (UnitIsPlayer(unit) or (E.Retail and UnitInPartyIsAI(unit))) then return end

			local _, class = UnitClass(unit)
			if not class then return end

			local size = strsplit(":", args or "")
			size = tonumber(size)
			size = (size and (size >= 16 and size <= 128)) and size or 64

			local classIconStrings = MEDIA.icons.class.icons.custom[style] and MEDIA.icons.class.icons.custom[style].texString[class]  or MEDIA.icons.class.data[class].texString
			local textureFile = MEDIA.icons.class.icons.custom[style] and MEDIA.icons.class.icons.custom[style].texture or MEDIA.icons.class.icons.mmt[style].texture
			if textureFile and classIconStrings then return format("|T%s:%s:%s:0:0:1024:1024:%s|t", textureFile, size, size, classIconStrings) end
		end)
		E:AddTagInfo(tag, mMT.NameShort .. " " .. L["Icons"], L["Returns the class icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mClassIcon:style{32}"] )
	end
end

function module:Initialize()
	db = E.db.mMT.tags

	roleColors = {
		TANK = colors.tank,
		HEALER = colors.healer,
		DPS = colors.dps,
	}

	roleIcons = {
		TANK = db.misc.tank,
		HEALER = db.misc.healer,
		DPS = db.misc.dps,
	}

	if not module.initialized then
		module:RegisterEvent("PLAYER_ENTERING_WORLD")
		module:RegisterEvent("UPDATE_INSTANCE_INFO")
		module.initialized = true
	end
end

function module:PLAYER_ENTERING_WORLD(_, text)
	db = E.db.mMT.tags

	roleColors = {
		TANK = colors.tank,
		HEALER = colors.healer,
		DPS = colors.dps,
	}

	roleIcons = {
		TANK = db.misc.tank,
		HEALER = db.misc.healer,
		DPS = db.misc.dps,
	}
end

function module:UPDATE_INSTANCE_INFO(_, text)
	TagDeathCount()
end
