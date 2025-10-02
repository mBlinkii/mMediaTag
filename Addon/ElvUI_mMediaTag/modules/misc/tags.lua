local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("TAGS", { "AceEvent-3.0" })

local UnitName = UnitName
local IsInInstance = IsInInstance
local db = {}
local colors = MEDIA.color.tags
local icons = MEDIA.icons.tags

-- NAME
-- FUNCTIONS
local function GetLastName(unit)
	local inInstance = IsInInstance()
	return inInstance and _TAGS["name:last"](unit) or UnitName(unit)
end

local function GetStatusTextOrName(unit, length)
	if UnitIsAFK(unit) or UnitIsDND(unit) or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return _TAGS.mStatus(unit) end
	local name = UnitName(unit)
	return name and E:ShortenString(name, length)
end

local function GetStatusIconOrShortName(unit, length)
	if UnitIsAFK(unit) or UnitIsDND(unit) or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return _TAGS["mStatus:icon"](unit) end
	local name = UnitName(unit)
	return name and E:ShortenString(name, length)
end

-- TAGS
E:AddTag("mName:last", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	return GetLastName(unit)
end)
E:AddTagInfo("mName:last", mMT.NameShort .. " " .. L["Name"], L["Returns the name of the unit. If in an instance, it will return the last word of the name."])

E:AddTag("mName:status", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
	if UnitIsAFK(unit) or UnitIsDND(unit) or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return _TAGS.mStatus(unit) end
	local name = UnitName(unit)
	return name and name
end)
E:AddTagInfo("mName:status", mMT.NameShort .. " " .. L["Name"], L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost) or the name of the unit."])

E:AddTag("mName:statusicon", "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
	if UnitIsAFK(unit) or UnitIsDND(unit) or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return _TAGS.mStatus(unit) end
	local name = UnitName(unit)
	return name and name
end)
E:AddTagInfo("mName:statusicon", mMT.NameShort .. " " .. L["Name"], L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost) or the name of the unit."])

for textFormat, length in pairs({ veryshort = 5, short = 10, medium = 15, long = 20 }) do
	E:AddTag("mName:last:" .. textFormat, "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
		local name = GetLastName(unit)
		return name and E:ShortenString(name, length)
	end)
	E:AddTagInfo("mName:last:" .. textFormat, mMT.NameShort .. " " .. L["Name"], L["Short Version."])

	E:AddTag("mName:status:" .. textFormat, "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
		return GetStatusTextOrName(unit, length)
	end)
	E:AddTagInfo("mName:status:" .. textFormat, mMT.NameShort .. " " .. L["Name"], L["Short Version."])

	E:AddTag("mName:statusicon:" .. textFormat, "UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH", function(unit)
		return GetStatusIconOrShortName(unit, length)
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
E:AddTagInfo("mHealth:short", mMT.NameShort .. " " .. L["Health"], L["Short Version"])

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
E:AddTagInfo("mHealth:short:absorbs", mMT.NameShort .. " " .. L["Health"], L["Short Version"])

E:AddTag("mHealth:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	return GetSmartHealth(unit, false)
end)
E:AddTagInfo("mHealth:noStatus", mMT.NameShort .. " " .. L["Health"], L["Returns the current health of the unit (changes between max health and percent in combat). Does not return status."])

E:AddTag("mHealth:short:noStatus", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	return GetSmartHealth(unit, true)
end)
E:AddTagInfo("mHealth:short:noStatus", mMT.NameShort .. " " .. L["Health"], L["Short Version"])

E:AddTag("mHealth:ndp", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
	return GetSmartHealth(unit, false)
end)
E:AddTagInfo("mHealth:noStatus", mMT.NameShort .. " " .. L["Health"], L["Returns the current health of the unit (changes between max health and percent in combat). Does not return status."])

function module:Initialize()
	db = E.db.mMT.tags
	module:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function module:PLAYER_ENTERING_WORLD(_, text)
	db = E.db.mMT.tags
end
