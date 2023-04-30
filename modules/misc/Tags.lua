local mMT, E, L, V, P, G = unpack((select(2, ...)))

local format, floor, tostring = format, floor, tostring

local CreateTextureMarkup = CreateTextureMarkup
local GetInstanceInfo = GetInstanceInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
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
local UnitReaction = UnitReaction
local TANK, HEALER = TANK, HEALER

-- GLOBALS: ElvUF, Hex, _TAGS
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
	rare = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	relite = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	elite = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	boss = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	afk = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	dnd = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	dc = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	death = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	ghost = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	pvp = format("|T%s:14:14|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\pvp.tga"),
	tank = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	heal = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	dd = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t",
	quest = format("|T%s:14:14|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\quest1.tga"),
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
		rare = format("|T%s:14:14|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.rare]),
		relite = format("|T%s:14:14|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.relite]),
		elite = format("|T%s:14:14|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.elite]),
		boss = format("|T%s:14:14|t", mMT.Media.ClassIcons[E.db.mMT.tags.icons.boss]),
		afk = format("|T%s:14:14|t", mMT.Media.AFKIcons[E.db.mMT.tags.icons.afk]),
		dnd = format("|T%s:14:14|t", mMT.Media.DNDIcons[E.db.mMT.tags.icons.dnd]),
		dc = format("|T%s:14:14|t", mMT.Media.DCIcons[E.db.mMT.tags.icons.dc]),
		death = format("|T%s:14:14|t", mMT.Media.DeathIcons[E.db.mMT.tags.icons.death]),
		ghost = format("|T%s:14:14|t", mMT.Media.GhostIcons[E.db.mMT.tags.icons.ghost]),
		pvp = format("|T%s:14:14|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\pvp.tga"),
		tank = E:TextureString(E.Media.Textures.Tank, ":14:14"),
		heal = E:TextureString(E.Media.Textures.Healer, ":14:14"),
		dd = E:TextureString(E.Media.Textures.DPS, ":14:14"),
		quest = format("|T%s:14:14|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\quest1.tga"),
	}
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

	E:AddTag(
		format("mName:last:onlyininstance:%s", textFormat),
		"UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT",
		function(unit)
			local name = UnitName(unit)
			local inInstance, InstanceType = IsInInstance()
			if name and strfind(name, "%s") then
				name = inInstance and ShortName(name) or E.TagFunctions.Abbrev(name)
			end

			if name then
				return E:ShortenString(name, length)
			end
		end
	)

	E:AddTag(
		format("mName:statusicon:%s", textFormat),
		"UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT",
		function(unit)
			local name = UnitName(unit)
			if
				UnitIsAFK(unit)
				or UnitIsDND(unit)
				or (not UnitIsConnected(unit))
				or (UnitIsDead(unit))
				or (UnitIsGhost(unit))
			then
				return _TAGS["mStatus:icon"](unit)
			elseif name then
				return E:ShortenString(name, length)
			end
		end
	)

	E:AddTag(
		format("mName:status:%s", textFormat),
		"UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT",
		function(unit)
			local name = UnitName(unit)
			if
				UnitIsAFK(unit)
				or UnitIsDND(unit)
				or (not UnitIsConnected(unit))
				or (UnitIsDead(unit))
				or (UnitIsGhost(unit))
			then
				return _TAGS.mStatus(unit)
			elseif name then
				return E:ShortenString(name, length)
			end
		end
	)
end

E:AddTag(
	"mName:statusicon",
	"UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	function(unit)
		local name = UnitName(unit)
		if
			UnitIsAFK(unit)
			or UnitIsDND(unit)
			or (not UnitIsConnected(unit))
			or (UnitIsDead(unit))
			or (UnitIsGhost(unit))
		then
			return _TAGS["mStatus:icon"](unit)
		elseif name then
			return name
		end
	end
)

E:AddTag(
	"mName:status",
	"UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	function(unit)
		local name = UnitName(unit)
		if
			UnitIsAFK(unit)
			or UnitIsDND(unit)
			or (not UnitIsConnected(unit))
			or (UnitIsDead(unit))
			or (UnitIsGhost(unit))
		then
			return _TAGS.mStatus(unit)
		elseif name then
			return name
		end
	end
)

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
	end
)

E:AddTag("mTargetAbbrev", "UNIT_TARGET", function(unit)
	local targetName = UnitName(unit .. "target")
	if targetName then
		return E.TagFunctions.Abbrev(targetName)
	end
end)

-- veryshort = 5, short = 10, medium = 15, long = 20 
E:AddTagInfo("mName:status", mMT.Name .. " " .. L["Name"], L["Replace the Unit name with Status, if applicable."])
E:AddTagInfo("mName:statusicon", mMT.Name .. " " .. L["Name"], L["Replace the Unit name with Status Icon, if applicable."])
E:AddTagInfo("mName:status:veryshort", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:status:short", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:status:medium", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:status:long", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:status.")
E:AddTagInfo("mName:statusicon:veryshort", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:statusicon:short", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:statusicon:medium", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:statusicon:long", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:statusicon.")
E:AddTagInfo("mName:last", mMT.Name .. " " .. L["Name"], L["Displays the last word of the Unit name."])
E:AddTagInfo("mName:last:veryshort", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:short", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:medium", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:long", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last.")
E:AddTagInfo("mName:last:onlyininstance", mMT.Name .. " " .. L["Name"], L["Displays the last word of the Unit name, only in an Instance."])
E:AddTagInfo("mName:last:onlyininstance:veryshort", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")
E:AddTagInfo("mName:last:onlyininstance:short", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")
E:AddTagInfo("mName:last:onlyininstance:medium", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")
E:AddTagInfo("mName:last:onlyininstance:long", mMT.Name .. " " .. L["Name"], L["Shortened version of"] .. " mName:last:onlyininstance.")
E:AddTagInfo("mTargetAbbrev", mMT.Name .. " " .. L["Name"], L["Abbrev Name of Target."])

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

	if c == "rare" then
		return icons.rare
	elseif c == "rareelite" then
		return icons.relite
	elseif c == "elite" then
		return icons.elite
	elseif c == "worldboss" then
		return icons.boss
	end
end)

E:AddTagInfo("mClass", mMT.Name .. " " .. L["Class"], L["Displays the Unit Class."])
E:AddTagInfo("mClass:short", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mClass.")
E:AddTagInfo("mClass:icon", mMT.Name .. " " .. L["Class"], L["Displays the Unit Class Icon."])

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

E:AddTagInfo("mStatus", mMT.Name .. " " .. L["Status"], L["Displays the Unit Status."])
E:AddTagInfo("mStatus:icon", mMT.Name .. " " .. L["Status"], L["Displays the Unit Status Icon."])
E:AddTagInfo("mStatustimer", mMT.Name .. " " .. L["Status"], L["Displays the Unit Status text and time."])
E:AddTagInfo("mAFK", mMT.Name .. " " .. L["Status"], L["Displays the Unit AFK Status."])

E:AddTag(
	"mColor",
	"UNIT_NAME_UPDATE UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_CLASSIFICATION_CHANGED",
	function(unit)
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
	end
)

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

E:AddTagInfo("mColor", mMT.Name .. " " .. L["Color"], L["Unit colors with mMediaTag colors for Rare, Rareelite, Elite and Boss and Classcolors."])
E:AddTagInfo("mColor:target", mMT.Name .. " " .. L["Color"], L["Targetunit colors with mMediaTag colors for Rare, Rareelite, Elite and Boss and Classcolors."])

E:AddTag(
	"mHealth",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
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
	end
)

E:AddTag(
	"mHealth:short",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
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
	end
)

E:AddTag(
	"mHealth:nodeath",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
			end
		end
	end
)

E:AddTag(
	"mHealth:nodeath:short",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if (not UnitIsDead(unit)) or (not UnitIsGhost(unit)) then
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
			end
		end
	end
)

E:AddTag(
	"mHealth:nodeath:current-percent",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
			return ""
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format(
					"%s | %s",
					E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit)),
					E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
				)
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
			end
		end
	end
)

E:AddTag(
	"mHealth:nodeath:short:current-percent",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) then
			return ""
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format(
					"%s | %s",
					E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true),
					E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
				)
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
			end
		end
	end
)

E:AddTag(
	"mHealth:icon",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if
			(UnitIsDead(unit))
			or (UnitIsGhost(unit))
			or (not UnitIsConnected(unit))
			or (UnitIsAFK(unit))
			or (UnitIsDND(unit))
		then
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
	end
)

E:AddTag(
	"mHealth:icon:short",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if
			(UnitIsDead(unit))
			or (UnitIsGhost(unit))
			or (not UnitIsConnected(unit))
			or (UnitIsAFK(unit))
			or (UnitIsDND(unit))
		then
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
	end
)

E:AddTag(
	"mHealth:current-percent",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
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
					return format(
						"%s | %s",
						E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit)),
						E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
					)
				else
					return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
				end
			end
		end
	end
)

E:AddTag(
	"mHealth:current-percent:short",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
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
					return format(
						"%s | %s",
						E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true),
						E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
					)
				else
					return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true)
				end
			end
		end
	end
)

E:AddTag(
	"mHealth:NoAFK",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
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
)

E:AddTag(
	"mHealth:NoAFK:short",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
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
)

E:AddTag(
	"mHealth:NoAFK:current-percent",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format(
					"%s | %s",
					E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit)),
					E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
				)
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
			end
		end
	end
)

E:AddTag(
	"mHealth:NoAFK:short:current-percent",
	"UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
	function(unit)
		if (UnitIsDead(unit)) or (UnitIsGhost(unit)) or (not UnitIsConnected(unit)) then
			return _TAGS.mStatus(unit)
		else
			local currentHealth = UnitHealth(unit)
			local deficit = UnitHealthMax(unit) - currentHealth

			if deficit > 0 and currentHealth > 0 then
				return format(
					"%s | %s",
					E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit), nil, true),
					E:GetFormattedText("PERCENT", UnitHealth(unit), UnitHealthMax(unit))
				)
			else
				return E:GetFormattedText("CURRENT", UnitHealth(unit), UnitHealthMax(unit))
			end
		end
	end
)

E:AddTagInfo("mHealth", mMT.Name .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat."])
E:AddTagInfo("mHealth:short", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mHealth.")
E:AddTagInfo("mHealth:icon", mMT.Name .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat, with Status Icons."])
E:AddTagInfo("mHealth:icon:short", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mHealth:icon.")
E:AddTagInfo("mHealth:current-percent", mMT.Name .. " " .. L["Health"], L["Health changes between maximum Health and Current Health - Percent in combat."])
E:AddTagInfo("mHealth:current-percent:short", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mHealth:current-percent.")
E:AddTagInfo("mHealth:nodeath", mMT.Name .. " " .. L["Health"], L["If the unit is alive, its health will change between maximum health and percentage in combat."])
E:AddTagInfo("mHealth:nodeath:short", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mHealth:nodeath.")
E:AddTagInfo("mHealth:nodeath:current-percent", mMT.Name .. " " .. L["Class"], L["Same as"] .. " mHealth:current-percen " .. L["and"] .. " mHealth:nodeath ")
E:AddTagInfo("mHealth:nodeath:short:current-percent", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mHealth:nodeath:current-percent.")
E:AddTagInfo("mHealth:NoAFK", mMT.Name .. " " .. L["Health"], L["Health changes between maximum Health and Percent in combat, without AFK Status."])
E:AddTagInfo("mHealth:NoAFK:short", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mHealth:NoAFK.")
E:AddTagInfo("mHealth:NoAFK:current-percent", mMT.Name .. " " .. L["Class"], L["Same as"] .. " mHealth:current-percen " .. L["and"] .. " mHealth:NoAFK ")
E:AddTagInfo("mHealth:NoAFK:short:current-percent", mMT.Name .. " " .. L["Class"], L["Shortened version of"] .. " mHealth:NoAFK:current-percent.")

local UnitmDeathCount = {}
local mID = 0
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

E:AddTagInfo("mDeathCount", mMT.Name .. " " .. L["Misc"], L["Death Counter, resets in new Instances."])
E:AddTagInfo("mDeathCount:hide", mMT.Name .. " " .. L["Misc"], L["Displays the Death counter only when the unit is Death, resets in new instances."])
E:AddTagInfo("mDeathCount:color", mMT.Name .. " " .. L["Misc"], L["Death Counter color."])


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
	end

	if Role == "TANK" then
		return icons.tank
	elseif Role == "HEALER" then
		return icons.heal
	elseif Role == "DAMAGER" then
		return icons.dd
	end
end)

E:AddTagInfo("mRole", mMT.Name .. " " .. L["Misc"], L["Tank and Healer roles as text."])
E:AddTagInfo("mRoleIcon", mMT.Name .. " " .. L["Misc"], L["Unit role icon."])
E:AddTagInfo("mRoleIcon:target", mMT.Name .. " " .. L["Misc"], L["Targetunit role icon."])

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


E:AddTagInfo("mLevel", mMT.Name .. " " .. L["Level"], L["Level changes to resting in resting Areas."])
E:AddTagInfo("mLevel:hideMax", mMT.Name .. " " .. L["Level"], L["Same as"] .. " mLevel" .. L[" hidden at maximum level."])
E:AddTagInfo("mLevelSmart", mMT.Name .. " " .. L["Level"], L["Smart Level changes to resting in resting Areas."])
E:AddTagInfo("mLevelSmart:hideMax", mMT.Name .. " " .. L["Level"], L["Same as"] .. " mLevelSmart" .. L[" hidden at maximum level."])

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
				CreateTextureMarkup(
					"Interface\\FriendsFrame\\PlusManz-" .. factionGroup,
					16,
					16,
					16,
					16,
					0,
					1,
					0,
					1,
					0,
					0
				),
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
				CreateTextureMarkup(
					"Interface\\FriendsFrame\\PlusManz-" .. factionGroup,
					16,
					16,
					16,
					16,
					0,
					1,
					0,
					1,
					0,
					0
				),
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
				CreateTextureMarkup(
					"Interface\\FriendsFrame\\PlusManz-" .. factionGroup,
					16,
					16,
					16,
					16,
					0,
					1,
					0,
					1,
					0,
					0
				),
				factionGroup,
			}
		end
	end

	if UnitFaction[guid] then
		if UnitFaction[guid][2] then
			local factionPlayer = UnitFactionGroup("Player")
			if
				(UnitFaction[guid][2] == "Horde" or UnitFaction[guid][2] == "Alliance")
				and (UnitFaction[guid][2] ~= factionPlayer)
			then
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
				CreateTextureMarkup(
					"Interface\\FriendsFrame\\PlusManz-" .. factionGroup,
					16,
					16,
					16,
					16,
					0,
					1,
					0,
					1,
					0,
					0
				),
				factionGroup,
			}
		end
	end

	if UnitFaction[guid] then
		if UnitFaction[guid][1] then
			local factionPlayer = UnitFactionGroup("Player")
			if
				(UnitFaction[guid][2] == "Horde" or UnitFaction[guid][2] == "Alliance")
				and (UnitFaction[guid][2] ~= factionPlayer)
			then
				return UnitFaction[guid][1]
			end
		end
	end
end)

E:AddTagInfo("mPvP:icon", mMT.Name .. " " .. L["Misc"], L["Displays an icon when the unit is flagged for PvP."])
E:AddTagInfo("mFaction:icon", mMT.Name .. " " .. L["Misc"], L["Displays the Faction Icon."])
E:AddTagInfo("mFaction:icon:opposite", mMT.Name .. " " .. L["Misc"], L["Displays the opposite Faction Icon."])
E:AddTagInfo("mFaction:text", mMT.Name .. " " .. L["Misc"], L["Displays the Faction."])
E:AddTagInfo("mFaction:text:opposite", mMT.Name .. " " .. L["Misc"], L["Displays the opposite Faction."])

E:AddTag(
	"mPowerPercent",
	"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE",
	function(unit)
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
	end
)

E:AddTag(
	"mPowerPercent:hidefull",
	"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT",
	function(unit)
		local powerType = UnitPowerType(unit)
		local min = UnitPower(unit, powerType)
		local max = UnitPowerMax(unit, powerType)
		if (min ~= max) and min ~= 0 then
			return _TAGS.mPowerPercent(unit)
		end
	end
)

E:AddTag(
	"mPowerPercent:heal",
	"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE",
	function(unit)
		local Role = "HEALER"

		if E.Retail then
			Role = UnitGroupRolesAssigned(unit)
		end

		if Role == "HEALER" then
			return _TAGS.mPowerPercent(unit)
		end
	end
)


E:AddTag(
	"mPowerPercent:heal:hidefull",
	"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT",
	function(unit)
		local Role = "HEALER"

		if E.Retail then
			Role = UnitGroupRolesAssigned(unit)
		end

		if Role == "HEALER" then
			return _TAGS["mPowerPercent:hidefull"](unit)
		end
	end
)

E:AddTagInfo("mPowerPercent", mMT.Name .. " " .. L["Power"], L["Displays Power/Mana, with a low healer warning."])
E:AddTagInfo("mPowerPercent:hidefull", mMT.Name .. " " .. L["Power"], L["Displays Power/Mana, with a low healer warning, hidden when full."])
E:AddTagInfo("mPowerPercent:heal", mMT.Name .. " " .. L["Power"], L["Displays the healer's Power/Mana, with a low healer warning."])
E:AddTagInfo("mPowerPercent:heal:hidefull", mMT.Name .. " " .. L["Power"], L["Displays the healer's Power/Mana, with a low healer warning, hidden when full."])

E:AddTag("mQuestIcon", "QUEST_LOG_UPDATE", function(unit)
	if UnitIsPlayer(unit) then
		return
	end
	local isQuest = E.TagFunctions.GetQuestData(unit, "title")
	if isQuest then
		return icons.quest
	end
end)

E:AddTagInfo("mQuestIcon", mMT.Name .. " " .. L["Misc"], L["Displays a ! if the Unit is a Quest NPC."])

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

local function GetPartyTargetsIcons(unit, style)
	local ClassString = ""
	for i = 1, GetNumGroupMembers() - 1 do
		if UnitIsUnit("party" .. i .. "target", unit) then
			local _, unitClass = UnitClass("party" .. i)
			ClassString = format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\%s%s.tga:14:14|t", unitClass, style)
				.. ClassString
		end
	end

	if UnitIsUnit("playertarget", unit) then
		local _, unitClass = UnitClass("player")
		ClassString = format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\targetindicator\\%s%s.tga:14:14|t", unitClass, style)
			.. ClassString
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
		return GetPartyTargetsIcons(unit, "_FLAT")
	end
end)

E:AddTag("mTargetingPlayers:icons:Glas", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "_GLAS")
	end
end)

E:AddTag("mTargetingPlayers:icons:SQ", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "_SQ")
	end
end)

E:AddTag("mTargetingPlayers:icons:DIA", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit, "_DIA")
	end
end)

E:AddTagInfo("mTargetingPlayers", mMT.Name .. " " .. L["Misc"], L["Target counter (Party and Raid)."])
E:AddTagInfo("mTargetingPlayers:icons:Flat", mMT.Name .. " " .. L["Misc"], L["Target counter Icon (Flat Circle)."])
E:AddTagInfo("mTargetingPlayers:icons:Glas", mMT.Name .. " " .. L["Misc"], L["Target counter Icon (Glas Circle)."])
E:AddTagInfo("mTargetingPlayers:icons:SQ", mMT.Name .. " " .. L["Misc"], L["Target counter Icon (Flat Square)."])
E:AddTagInfo("mTargetingPlayers:icons:DIA", mMT.Name .. " " .. L["Misc"], L["Target counter Icon (Flat Dimond)."])