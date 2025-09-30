local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("TAGS", { "AceEvent-3.0" })

local UnitName = UnitName
local IsInInstance = IsInInstance
local db = {}
local colors = MEDIA.color.tags
local icons = MEDIA.icons.tags

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

-- NAME
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

E:AddTag("mClass", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local labels = {
		rare = L["Rare"],
		rareelite = L["Rare Elite"],
		elite = L["Elite"],
		worldboss = L["Boss"],
	}

	local c = GetClassification(unit)
	return (c and labels[c]) and format("%s%s|r", colors[c], labels[c]) or ""
end)

E:AddTag("mClass:short", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local labels = {
		rare = L["R"],
		rareelite = L["R+"],
		elite = L["+"],
		worldboss = L["B"],
	}

	local c = GetClassification(unit)
	return (c and labels[c]) and format("%s%s|r", colors[c], labels[c]) or ""
end)

E:AddTag("mClass:icon", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = GetClassification(unit)
	local color = GetColorString(colors[c])
	return (c and color) and "|T" .. icons[db.classification[c]] .. ":16:16:0:0:16:16:0:16:0:16" .. color or ""
end)


function module:Initialize()
	db = E.db.mMT.tags
	module:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function module:PLAYER_ENTERING_WORLD(_, text)
	db = E.db.mMT.tags
end
