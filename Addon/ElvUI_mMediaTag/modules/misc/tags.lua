local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("TAGs", { "AceEvent-3.0" })

local ElvUF = E.oUF
local Tags = ElvUF.Tags

local UnitName = UnitName
local IsInInstance = IsInInstance
local ScaleTo100 = CurveConstants and CurveConstants.ScaleTo100
local db = {}
local colors = MEDIA.color.tags
local icons = MEDIA.icons.tags
local UnitFaction = {}

local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitHonorLevel = UnitHonorLevel
local UnitIsPlayer = UnitIsPlayer
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitHealthMissing = UnitHealthMissing
local UnitPowerMissing = UnitPowerMissing

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

local function GetColorString(color)
	return color and ":" .. tostring(color.r * 255) .. ":" .. tostring(color.g * 255) .. ":" .. tostring(color.b * 255) .. "|t"
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

			local classIconStrings = MEDIA.icons.class.icons.custom[style] and MEDIA.icons.class.icons.custom[style].texString[class] or MEDIA.icons.class.data[class].texString
			local textureFile = MEDIA.icons.class.icons.custom[style] and MEDIA.icons.class.icons.custom[style].texture or MEDIA.icons.class.icons.mmt[style].texture
			if textureFile and classIconStrings then return format("|T%s:%s:%s:0:0:1024:1024:%s|t", textureFile, size, size, classIconStrings) end
		end)
		E:AddTagInfo(tag, mMT.NameShort .. " " .. L["Icons"], L["Returns the class icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mClassIcon:style{32}"])
	end
end

function module:Initialize()
	db = E.db.mMediaTag.tags

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

	classificationsIcons = {
		rare = icons[db.classification.rare],
		rareelite = icons[db.classification.rareelite],
		elite = icons[db.classification.elite],
		worldboss = icons[db.classification.worldboss],
	}

    statusDefinitions.AFK.icon = icons[db.status.afk]
	statusDefinitions.DND.icon = icons[db.status.dnd]
	statusDefinitions.Offline.icon = icons[db.status.dc]
	statusDefinitions.Dead.icon = icons[db.status.dead]
	statusDefinitions.Ghost.icon = icons[db.status.ghost]


	if not module.initialized then
		module:RegisterEvent("PLAYER_ENTERING_WORLD")
		module:RegisterEvent("UPDATE_INSTANCE_INFO")
		module.initialized = true
	end
end

function module:PLAYER_ENTERING_WORLD(_, text)
	db = E.db.mMediaTag.tags

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
	--TagDeathCount()
end
