local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...

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
local IconPath = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\%s.tga:0|t"
local IconString = "|T%s:0|t"
local mTextureSkullGray = format(IconPath, "skull4")
local mTextureSkullBlue = format(IconPath, "skull3")
local mTextureSkullWith = format(IconPath, "skull1")
local mTextureSkullRed = format(IconPath, "skull6")
local mTextureOffline = format(IconPath, "offline")
local TANK_ICON = E:TextureString(E.Media.Textures.Tank, ":16:16")
local HEALER_ICON = E:TextureString(E.Media.Textures.Healer, ":16:16")
local DPS_ICON = E:TextureString(E.Media.Textures.DPS, ":16:16")
local UnitFaction = {}

function mMT:LoadTagSettings()
	if E.db[mPlugin].mRoleSymbols.enable then
		local path = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga"
		TANK_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.tank), ":14:14")
		HEALER_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.heal), ":14:14")
		DPS_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.dd), ":14:14")
	end
end

E:AddTag("mClass", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)

	if c == "rare" then
		return format("%sRare|r", E.db.mMediaTag.cClassRare.color)
	elseif c == "rareelite" then
		return format("%sRare Elite|r", E.db.mMediaTag.cClassRareElite.color)
	elseif c == "elite" then
		return format("%sElite|r", E.db.mMediaTag.cClassElite.color)
	elseif c == "worldboss" then
		return format("%sBoss|r", E.db.mMediaTag.cClassBoss.color)
	end
end)

E:AddTag("mClass:short", "UNIT_CLASSIFICATION_CHANGED", function(unit)
	local c = UnitClassification(unit)

	if c == "rare" then
		return format("%sR|r", E.db.mMediaTag.cClassRare.color)
	elseif c == "rareelite" then
		return format("%sR+|r", E.db.mMediaTag.cClassRareElite.color)
	elseif c == "elite" then
		return format("%s+|r", E.db.mMediaTag.cClassElite.color)
	elseif c == "worldboss" then
		return format("%sB|r", E.db.mMediaTag.cClassBoss.color)
	end
end)

E:AddTag("mStatus:icon", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	if UnitIsAFK(unit) then
		return format(IconString, E.db.mMediaTag.mTags.afkpath)
	elseif UnitIsDND(unit) then
		return format(IconString, E.db.mMediaTag.mTags.dndpath)
	else
		if not UnitIsConnected(unit) then
			return mTextureOffline
		elseif UnitIsDead(unit) then
			return format(IconString, E.db.mMediaTag.mTags.skullpath)
		elseif UnitIsGhost(unit) then
			return format(IconString, E.db.mMediaTag.mTags.ghostpath)
		end
	end
end)

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
				return E.db.mMediaTag.cClassRare.color
			elseif c == "rareelite" then
				return E.db.mMediaTag.cClassRareElite.color
			elseif c == "elite" then
				return E.db.mMediaTag.cClassElite.color
			elseif c == "worldboss" then
				return E.db.mMediaTag.cClassBoss.color
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
			return E.db.mMediaTag.cClassRare.color
		elseif c == "rareelite" then
			return E.db.mMediaTag.cClassRareElite.color
		elseif c == "elite" then
			return E.db.mMediaTag.cClassElite.color
		elseif c == "worldboss" then
			return E.db.mMediaTag.cClassBoss.color
		else
			return _TAGS.classcolor(target)
		end
	end
end)

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
	"mHealth:short:nodeath",
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
	"mHealth:short:icon",
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

E:AddTag("mStatus", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return _TAGS.mAFK(unit)
	elseif UnitIsDND(unit) then
		return format("[%sDND|r]", E.db.mMediaTag.cGeneralAFK.color)
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

local function mGetClassStatusTexture(class)
	if class == "PRIEST" then
		return 5
	elseif class == "DEATHKNIGHT" then
		return 6
	elseif class == "DEMONHUNTER" then
		return 7
	elseif class == "DRUID" then
		return 8
	elseif class == "HUNTER" then
		return 9
	elseif class == "MAGE" then
		return 10
	elseif class == "MONK" then
		return 11
	elseif class == "PALADIN" then
		return 12
	elseif class == "ROGUE" then
		return 13
	elseif class == "SHAMAN" then
		return 14
	elseif class == "WARLOCK" then
		return 15
	elseif class == "WARRIOR" then
		return 16
	else
		return 1
	end
end

E:AddTag("mStatus:icon:class", "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	local _, unitClass = UnitClass(unit)
	if UnitIsAFK(unit) then
		return format(IconPath, "afk" .. mGetClassStatusTexture(unitClass))
	elseif UnitIsDND(unit) then
		return format(IconPath, "dnd" .. mGetClassStatusTexture(unitClass))
	else
		if not UnitIsConnected(unit) then
			return mTextureOffline
		elseif UnitIsDead(unit) then
			return format(IconString, E.db.mMediaTag.mTags.skullpath)
		elseif UnitIsGhost(unit) then
			return format(IconString, E.db.mMediaTag.mTags.ghostpath)
		end
	end
end)

E:AddTag("mDeath:gray", "UNIT_HEALTH", function(unit)
	if UnitIsDead(unit) then
		return mTextureSkullGray
	elseif UnitIsGhost(unit) then
		return format(IconString, E.db.mMediaTag.mTags.ghostpath)
	end
end)

E:AddTag("mDeath:white", "UNIT_HEALTH", function(unit)
	if UnitIsDead(unit) then
		return mTextureSkullWith
	elseif UnitIsGhost(unit) then
		return format(IconString, E.db.mMediaTag.mTags.ghostpath)
	end
end)

E:AddTag("mDeath:red", "UNIT_HEALTH", function(unit)
	if UnitIsDead(unit) then
		return mTextureSkullRed
	elseif UnitIsGhost(unit) then
		return format(IconString, E.db.mMediaTag.mTags.ghostpath)
	end
end)

E:AddTag("mDeath:blue", "UNIT_HEALTH", function(unit)
	if UnitIsDead(unit) then
		return mTextureSkullBlue
	elseif UnitIsGhost(unit) then
		return format(IconString, E.db.mMediaTag.mTags.ghostpath)
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

local UnitmDeathCount = {}
local mID = 0
local mTyp = "none"
local FramemDeathReset = CreateFrame("Frame")
FramemDeathReset:RegisterEvent("UPDATE_INSTANCE_INFO")
FramemDeathReset:RegisterEvent("PLAYER_ENTERING_WORLD")
FramemDeathReset:SetScript("OnEvent", function(self, event)
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
end)

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

E:AddTag("mDeathCount:text", "UNIT_HEALTH", function(unit)
	if not UnitIsPlayer(unit) then
		return
	end

	return L["Deaths"] .. ": "
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

E:AddTag("mAFK", "PLAYER_FLAGS_CHANGED", function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return format("[%sAFK|r]", E.db.mMediaTag.cGeneralAFK.color)
	end
end)

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
	"mHealth:short-current-percent",
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
	"mHealth:short:nodeath-current-percent",
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
	"mHealth:short-NoAFK",
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
	"mHealth:NoAFK-current-percent",
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
	"mHealth:short-NoAFK-current-percent",
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

E:AddTag("mRole", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local Role = ""

	if MediaTagGameVersion.retail then
		Role = UnitGroupRolesAssigned(unit)
	end

	if Role == "TANK" then
		return format("%s%s|r", E.db.mMediaTag.cGeneralTank.color, TANK)
	elseif Role == "HEALER" then
		return format("%s%s|r", E.db.mMediaTag.cGeneralHeal.color, HEALER)
	end
end)

E:AddTag("mRoleIcon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit)
	local Role = ""

	if MediaTagGameVersion.retail then
		Role = UnitGroupRolesAssigned(unit)
	end

	if Role == "TANK" then
		return TANK_ICON
	elseif Role == "HEALER" then
		return HEALER_ICON
	elseif Role == "DAMAGER" then
		return DPS_ICON
	end
end)

E:AddTag("mRoleIcon:target", "UNIT_TARGET UNIT_COMBAT", function(unit)
	local Role = ""

	if MediaTagGameVersion.retail then
		Role = UnitGroupRolesAssigned(unit .. "target")
	end

	if Role == "TANK" then
		return TANK_ICON
	elseif Role == "HEALER" then
		return HEALER_ICON
	elseif Role == "DAMAGER" then
		return DPS_ICON
	end
end)

E:AddTag("mLevel", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return format("%sZzz|r", E.db.mMediaTag.cGeneralZzz.color)
	else
		local level = UnitLevel(unit)
		if MediaTagGameVersion.retail then
			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
				return UnitBattlePetLevel(unit)
			elseif level > 0 then
				return level
			else
				return format("%s??|r", E.db.mMediaTag.cGeneralLevel.color)
			end
		end
		if level > 0 then
			return level
		else
			return format("%s??|r", E.db.mMediaTag.cGeneralLevel.color)
		end
	end
end)

E:AddTag("mLevelSmart", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
	if unit == "player" and IsResting() then
		return format("%sZzz|r", E.db.mMediaTag.cGeneralZzz.color)
	else
		local level = UnitLevel(unit)
		if MediaTagGameVersion.retail then
			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
				return UnitBattlePetLevel(unit)
			elseif level > 0 then
				return level
			else
				return format("%s??|r", E.db.mMediaTag.cGeneralLevel.color)
			end
		end

		if level == UnitLevel("player") then
			return ""
		elseif level > 0 then
			return level
		else
			return format("%s??|r", E.db.mMediaTag.cGeneralLevel.color)
		end
	end
end)

E:AddTag("mGroup", "GROUP_ROSTER_UPDATE", function(unit)
	local name, server = UnitName(unit)
	if server and server ~= "" then
		name = format("%s-%s", name, server)
	end

	for i = 1, GetNumGroupMembers() do
		local raidName, _, group = GetRaidRosterInfo(i)
		if raidName == name then
			return L["Group "] .. group
		end
	end
end)

E:AddTag("mGroup:short", "GROUP_ROSTER_UPDATE", function(unit)
	local name, server = UnitName(unit)
	if server and server ~= "" then
		name = format("%s-%s", name, server)
	end

	for i = 1, GetNumGroupMembers() do
		local raidName, _, group = GetRaidRosterInfo(i)
		if raidName == name then
			return L["Grp. "] .. group
		end
	end
end)

E:AddTag("mPvP:icon", "UNIT_FACTION", function(unit)
	local factionGroup = UnitFactionGroup(unit)
	if (UnitIsPVP(unit)) and (factionGroup == "Horde" or factionGroup == "Alliance") then
		return CreateTextureMarkup(
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
		)
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

local function mGetTargetTexture(second)
	local _, unitClass = UnitClass("player")
	local mTargetStringOne = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\target%s.tga:16:16:0:0:32:32|t"
	local mTargetStringTwo = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\target%s2.tga:16:16:0:0:32:32|t"

	if second then
		return format(mTargetStringTwo, unitClass)
	else
		return format(mTargetStringOne, unitClass)
	end
end

E:AddTag("mTargetMarkOne", "PLAYER_TARGET_CHANGED", function(unit)
	if UnitIsUnit("target", unit) then
		return mGetTargetTexture(false)
	else
		return ""
	end
end)

E:AddTag("mTargetMarkTwo", "PLAYER_TARGET_CHANGED", function(unit)
	if UnitIsUnit("target", unit) then
		return mGetTargetTexture(true)
	else
		return ""
	end
end)

E:AddTag("mTargetAbbrev", "UNIT_TARGET", function(unit)
	local targetName = UnitName(unit .. "target")
	if targetName then
		return E.TagFunctions.Abbrev(targetName)
	end
end)

E:AddTag(
	"mName:veryshort:statusicon",
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
			return E:ShortenString(name, 5)
		end
	end
)

E:AddTag(
	"mName:short:statusicon",
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
			return E:ShortenString(name, 10)
		end
	end
)

E:AddTag(
	"mName:medium:statusicon",
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
			return E:ShortenString(name, 15)
		end
	end
)

E:AddTag(
	"mName:long:statusicon",
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
			return E:ShortenString(name, 20)
		end
	end
)

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
	"mName:veryshort:status",
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
			return E:ShortenString(name, 5)
		end
	end
)

E:AddTag(
	"mName:short:status",
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
			return E:ShortenString(name, 10)
		end
	end
)

E:AddTag(
	"mName:medium:status",
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
			return E:ShortenString(name, 15)
		end
	end
)

E:AddTag(
	"mName:long:status",
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
			return E:ShortenString(name, 20)
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

E:AddTag(
	"mPowerPercent",
	"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE",
	function(unit)
		local powerType = UnitPowerType(unit)
		local min = UnitPower(unit, powerType)
		local max = UnitPowerMax(unit, powerType)
		if min ~= 0 then
			local Role = ""

			if MediaTagGameVersion.retail then
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
	"mPowerPercent:heal",
	"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE",
	function(unit)
		local Role = "HEALER"

		if MediaTagGameVersion.retail then
			Role = UnitGroupRolesAssigned(unit)
		end

		if Role == "HEALER" then
			return _TAGS.mPowerPercent(unit)
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
	"mPowerPercent:heal-hidefull",
	"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE UNIT_COMBAT",
	function(unit)
		local Role = "HEALER"

		if MediaTagGameVersion.retail then
			Role = UnitGroupRolesAssigned(unit)
		end

		if Role == "HEALER" then
			return _TAGS["mPowerPercent:hidefull"](unit)
		end
	end
)

E:AddTag("mQuestIcon", "QUEST_LOG_UPDATE", function(unit)
	if UnitIsPlayer(unit) then
		return
	end
	local isQuest = E.TagFunctions.GetQuestData(unit, "title")
	if isQuest then
		return format(IconPath, "quest")
	end
end)

local function GetPartyTargets(unit)
	local amount = 0
	for i = 1, GetNumGroupMembers() - 1 do
		local partytarget = "party" .. i .. "target"
		if UnitGUID(partytarget) == UnitGUID(unit) then
			amount = amount + 1
		end
	end

	if UnitGUID("playertarget") == UnitGUID(unit) then
		amount = amount + 1
	end

	if amount ~= 0 then
		return amount
	end
end

local function GetRaidTargets(unit)
	local amount = 0
	for i = 1, GetNumGroupMembers() do
		local raidtarget = "raid" .. i .. "target"
		if UnitGUID(raidtarget) == UnitGUID(unit) then
			amount = amount + 1
		end
	end

	if amount ~= 0 then
		return amount
	end
end

local TargetColorTable = {
	[0] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d0.tga:0|t",
	[1] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d1.tga:0|t",
	[2] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d2.tga:0|t",
	[3] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d3.tga:0|t",
	[4] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d4.tga:0|t",
	[5] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d5.tga:0|t",
	[6] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d6.tga:0|t",
	[7] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d7.tga:0|t",
	[8] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d8.tga:0|t",
	[9] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d9.tga:0|t",
	[10] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d10.tga:0|t",
	[11] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d11.tga:0|t",
	[12] = "|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\d12.tga:0|t",
}

local function GetPartyTargetsIcons(unit)
	local ClassString = ""
	for i = 1, GetNumGroupMembers() - 1 do
		local partytarget = "party" .. i .. "target"
		if UnitGUID(partytarget) == UnitGUID(unit) then
			local _, _, classIndex = UnitClass("party" .. i)
			ClassString = TargetColorTable[classIndex] .. ClassString
		end
	end

	if UnitGUID("playertarget") == UnitGUID(unit) then
		local _, _, classIndex = UnitClass("player")
		ClassString = TargetColorTable[classIndex] .. ClassString
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

E:AddTag("mTargetingPlayers:raid", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInRaid()) then
		return GetRaidTargets(unit)
	end
end)

E:AddTag("mTargetingPlayers:party", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargets(unit)
	end
end)

E:AddTag("mTargetingPlayers:icons:party", 2, function(unit)
	if (InCombatLockdown()) and UnitAffectingCombat(unit) and (IsInGroup()) then
		return GetPartyTargetsIcons(unit)
	end
end)

E:AddTagInfo("mClass", ns.mName, L["Classes are fully written."])
E:AddTagInfo("mClass:short", ns.mName, L["Classes are short written."])

E:AddTagInfo("mColor", ns.mName, L["Colors Text by Class."])
E:AddTagInfo("mColor:target", ns.mName, L["Colors Text by Target Class."])

E:AddTagInfo("mHealth", ns.mName, L["Health changes between Max Health and Percent in fight."])
E:AddTagInfo(
	"mHealth:nodeath",
	ns.mName,
	L["Health changes between Max Health and Percent in fight and no Death Status."]
)
E:AddTagInfo("mHealth:icon", ns.mName, L["Health changes between Max Health and Percent in fight and status icons."])
E:AddTagInfo(
	"mHealth:short",
	ns.mName,
	L["Health changes between Max Health and Percent in fight, with short numbers."]
)
E:AddTagInfo(
	"mHealth:short:nodeath",
	ns.mName,
	L["Health changes between Max Health and Percent in fight, with short numbers and no Death Status."]
)
E:AddTagInfo(
	"mHealth:short:icon",
	ns.mName,
	L["Health changes between Max Health and Percent in fight, with short numbers and status icons."]
)

E:AddTagInfo("mHealth:NoAFK", ns.mName, L["Health changes between Max Health and Percent in fight, without AFK."])
E:AddTagInfo(
	"mHealth:short-NoAFK",
	ns.mName,
	L["Health changes between Max Health and Percent in fight, without AFK, with short numbers."]
)
E:AddTagInfo(
	"mHealth:current-percent",
	ns.mName,
	L["Health changes between Max Health and Current - Percent in fight."]
)
E:AddTagInfo(
	"mHealth:nodeath:current-percent",
	ns.mName,
	L["Health changes between Max Health and Current - Percent in fight and no Death Status."]
)
E:AddTagInfo(
	"mHealth:short-current-percent",
	ns.mName,
	L["Health changes between Max Health and Current - Percent in fight, with short numbers."]
)
E:AddTagInfo(
	"mHealth:short:nodeath-current-percent",
	ns.mName,
	L["Health changes between Max Health and Current - Percent in fight, with short numbers and no Death Status."]
)
E:AddTagInfo(
	"mHealth:NoAFK-current-percent",
	ns.mName,
	L["Health changes between Max Health and Current - Percent in fight, without AFK."]
)
E:AddTagInfo(
	"mHealth:short-NoAFK-current-percent",
	ns.mName,
	L["Health changes between Max Health and Current - Percent in fight, without AFK, with short numbers."]
)

E:AddTagInfo("mPowerPercent", ns.mName, L["Shows Power/Mana, with low healer warning."])
E:AddTagInfo("mPowerPercent:heal", ns.mName, L["Same as mPowerPercent, shows only Healer Power/Mana."])
E:AddTagInfo("mPowerPercent:hidefull", ns.mName, L["Same as mPowerPercent, hides on full Power/Mana."])
E:AddTagInfo("mPowerPercent:hidefull", ns.mName, L["Same as mPowerPercent:heal, hides on full Power/Mana."])

E:AddTagInfo("mStatus", ns.mName, L["Coloured Statustext."])
E:AddTagInfo("mStatus:icon", ns.mName, L["Status icons."])
E:AddTagInfo("mStatustimer", ns.mName, L["Coloured Statustext, with timer for Dead and AFK."])
E:AddTagInfo("mAFK", ns.mName, L["Coloured AFK text."])

E:AddTagInfo("mRole", ns.mName, L["Tank and Heal Role written."])
E:AddTagInfo("mRoleIcon", ns.mName, L["Role Icon."])
E:AddTagInfo("mRoleIcon:target", ns.mName, L["Target role Icon."])

E:AddTagInfo("mLevel", ns.mName, L["Level changes to resting in the City."])
E:AddTagInfo("mLevelSmart", ns.mName, L["Same as mLevel (hides Level if it is equal)."])

E:AddTagInfo("mGroup", ns.mName, L["Group number with full text (Group 3)."])
E:AddTagInfo("mGroup:short", ns.mName, L["Group number with abbreviated text (Grp. 3)."])

E:AddTagInfo("mPvP:icon", ns.mName, L["Shows the faction icon when PvP is active."])

E:AddTagInfo("mTargetAbbrev", ns.mName, L["Shows the Abbrev Target Name."])

E:AddTagInfo("mDeath:gray", ns.mName, L["Death icons."])
E:AddTagInfo("mDeath:white", ns.mName, L["Death icons."])
E:AddTagInfo("mDeath:red", ns.mName, L["Death icons."])
E:AddTagInfo("mDeath:blue", ns.mName, L["Death icons."])

E:AddTagInfo("mDeathCount", ns.mName, L["Death Counter, resets in new Instances."])
E:AddTagInfo("mDeathCount:hide", ns.mName, L["Death Counter, will show if Unit is Dead"])
E:AddTagInfo("mDeathCount:color", ns.mName, L["Death Counter texte color."])
E:AddTagInfo("mDeathCount:text", ns.mName, L["Death Counter text."])
E:AddTagInfo("mDeathCount:hide:text", ns.mName, L["Death Counter Text, will show if Death Counter >=1"])

E:AddTagInfo("mName:status", ns.mName, L["Replace the name of the unit with Status if applicable"])
E:AddTagInfo(
	"mName:veryshort:status",
	ns.mName,
	L["Replace the name of the unit with Status if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)
E:AddTagInfo(
	"mName:short:status",
	ns.mName,
	L["Replace the name of the unit with Status if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)
E:AddTagInfo(
	"mName:medium:status",
	ns.mName,
	L["Replace the name of the unit with Status if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)
E:AddTagInfo(
	"mName:long:status",
	ns.mName,
	L["Replace the name of the unit with Status if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)

E:AddTagInfo("mName:statusicon", ns.mName, L["Replace the name of the unit with Statusicon if applicable"])
E:AddTagInfo(
	"mName:veryshort:statusicon",
	ns.mName,
	L["Replace the name of the unit with Statusicon if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)
E:AddTagInfo(
	"mName:short:statusicon",
	ns.mName,
	L["Replace the name of the unit with Statusicon if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)
E:AddTagInfo(
	"mName:medium:statusicon",
	ns.mName,
	L["Replace the name of the unit with Statusicon if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)
E:AddTagInfo(
	"mName:long:statusicon",
	ns.mName,
	L["Replace the name of the unit with Statusicon if applicable (limited to veryshort = 5, short = 10, medium = 15, long = 20 letters)"]
)

E:AddTagInfo("mStatus:icon:class", ns.mName, L["Statusiocons in Classcolor"])
E:AddTagInfo("mTargetMarkOne", ns.mName, L["Targetmark left side"])
E:AddTagInfo("mTargetMarkTwo", ns.mName, L["Targetmark right side"])

E:AddTagInfo("mQuestIcon", ns.mName, L["Shows a icon if the NPC is a Unit for a Quest."])
--E:AddTagInfo('mQuestIcon:elvui', ns.mName, L['Same as mQuestIcon, hides if ElvUI Quest Icon is showen.'])

E:AddTagInfo("mTargetingPlayers", ns.mName, L["Shows the number of targeting Players a unit"])
E:AddTagInfo("mTargetingPlayers:raid", ns.mName, L["Shows the number of targeting Players a unit only in a Raid"])
E:AddTagInfo("mTargetingPlayers:party", ns.mName, L["Shows the number of targeting Players a unit only in a Party"])
E:AddTagInfo(
	"mTargetingPlayers:icons:party",
	ns.mName,
	L["Shows the number of targeting Players a unit in a Party as Icons"]
)

E:AddTagInfo("mFaction:text", ns.mName, L["Shows the unit faction as a text"])
E:AddTagInfo("mFaction:icon", ns.mName, L["Shows the unit faction as a icon"])
