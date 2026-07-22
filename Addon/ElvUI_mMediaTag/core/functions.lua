local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local format = format
local ipairs = ipairs
local date = date
local gsub = gsub
local print = print
local strmatch = strmatch
local time = time
local tonumber = tonumber
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local GetDungeonDifficultyID = GetDungeonDifficultyID
local GetRaidDifficultyID = GetRaidDifficultyID
local GetApplicationMetric = C_AddOnProfiler.GetApplicationMetric
local GetOverallMetric = C_AddOnProfiler.GetOverallMetric
local GetAddOnMetric = C_AddOnProfiler.GetAddOnMetric
local UnitGUID = UnitGUID
local UnitClassification = UnitClassification
local UnitLevel = UnitLevel
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local UnitIsPlayer = UnitIsPlayer
local strsplit = strsplit
local select = select
local issecretvalue = issecretvalue

local LibDeflate = E.Libs.Deflate
local D = E:GetModule("Distributor")

function mMT:Print(...)
	print(MEDIA.icon16 .. " " .. mMT.Name .. ":", ...)
end

function mMT:AddSettingsIcon(text, icon)
	return format("|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\%s.tga:16:16|t  %s", icon, text)
end

function mMT:UpdateModule(name, arg)
	local module = M[name]
	if module and module.Initialize then module:Initialize(arg) end
end

function mMT:GetModule(name)
	local module = M[name]
	return module and module
end

function mMT:AddModule(name, arg)
	if arg then
		M[name] = mMT:NewModule(name, unpack(arg))
	else
		M[name] = {}
	end
	return M[name]
end

function mMT:TC(text, color)
	color = color or "text"
	return MEDIA.color[color]:WrapTextInColorCode(text)
end

function mMT:GetRGB(color1, color2)
	local c1 = MEDIA.color[color1 or "text"]

	if color2 then
		local c2 = MEDIA.color[color2]
		return c1.r, c1.g, c1.b, c2.r, c2.g, c2.b
	end

	return c1.r, c1.g, c1.b
end

function mMT:HexToRGB(hex)
	if #hex == 6 then hex = "ff" .. hex end

	local a, r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16)

	return r / 255, g / 255, b / 255, a / 255
end

function mMT:FloatToHex(value)
	local scaled = math.max(0, math.min(255, math.floor(value * 255 + 0.5)))
	return string.format("%02X", scaled)
end

function mMT:round(number, decimals)
	if type(number) ~= "number" then
		mMT:Print(L["!! ERROR - Round:"], tostring(number), "-", tostring(decimals))
		return 0
	end

	decimals = type(decimals) == "number" and decimals or 0
	return (("%%.%df"):format(decimals)):format(number)
end

function mMT:GetElvUIDataText(name)
	local dt = DT.RegisteredDataTexts[name]

	if dt and dt.category ~= "Data Broker" then return dt end
end

function mMT:ConnectVirtualFrameToDataText(dataTextName, virtualFrame)
	local dt = self:GetElvUIDataText(dataTextName)
	if not dt or type(dt.applySettings) ~= "function" then return false end
	if dt.applySettings then dt.applySettings(virtualFrame, E.media.hexvaluecolor) end
	return true
end

function mMT:formatText(input, ignoreSkip)
	local ignore = { filled = true }
	local words = {}

	for word in string.gmatch(input, "[^_]+") do
		table.insert(words, word)
	end

	-- Remove the last word if it is to be ignored
	if not ignoreSkip and ignore[words[#words]] then table.remove(words) end

	-- Format all remaining words
	for i, w in ipairs(words) do
		words[i] = w:sub(1, 1):upper() .. w:sub(2):lower()
	end

	return table.concat(words, " ")
end

function mMT:GetInstanceDifficulty()
	local isRaid = IsInRaid()
	local id = isRaid and GetRaidDifficultyID() or (IsInGroup() and GetDungeonDifficultyID())
	if not id then return end

	local difficultyName = GetDifficultyInfo(id)
	if not difficultyName then return end

	local colorMap = {
		-- Dungeon difficulties
		[1] = MEDIA.color.N, -- Normal
		[2] = MEDIA.color.H, -- Heroic
		[23] = MEDIA.color.M, -- Mythic

		-- Raid difficulties
		[14] = MEDIA.color.N, -- Normal
		[15] = MEDIA.color.H, -- Heroic
		[16] = MEDIA.color.M, -- Mythic
	}

	local color = colorMap[id] or MEDIA.color.OTHER
	local shortName = E:ShortenString(difficultyName, 1)
	return color:WrapTextInColorCode(shortName), isRaid
end

function mMT:GetWeeklyResetTime()
	local secondsUntilReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
	if not secondsUntilReset then return false end
	local lastReset = time() + secondsUntilReset - 604800

	if lastReset > (DB.lastWeeklyReset or 0) + 60 then
		DB.lastWeeklyReset = lastReset
		return true
	end
	return false
end

-- build menu frames
function mMT:BuildMenus()
	mMT.menu = CreateFrame("Frame", "mMediaTag_Main_Menu_Frame", E.UIParent, "BackdropTemplate")
	mMT.menu:SetTemplate("Transparent", true)

	mMT.submenu = CreateFrame("Frame", "mMediaTag_Submenu_Frame", E.UIParent, "BackdropTemplate")
	mMT.submenu:SetTemplate("Transparent", true)
end

-- memory/ cpu usage tooltip
local topAddOns = {}
for i = 1, 5 do
	topAddOns[i] = { value = 0, name = "", cpu = "N/A" }
end

local function GetMemoryString(mem)
	return mem > 1024 and format("%.2f MB", mem / 1024) or format("%.0f KB", mem)
end

local function FormatProfilerPercent(pct)
	if pct >= 1 then
		return format("CPU: %.0f%%", pct)
	elseif pct >= 0.1 then
		return format("CPU: %.1f%%", pct)
	elseif pct >= 0.01 then
		return format("CPU: %.2f%%", pct)
	else
		return "CPU: 0%"
	end
end

local function GetAddonMetricPercent(addonName, metric)
	local appVal = GetApplicationMetric(metric)
	local overallVal = GetOverallMetric(metric)
	local addonVal = GetAddOnMetric(addonName, metric)
	local relativeTotal = appVal - overallVal + addonVal

	if relativeTotal <= 0 then return "N/A" end
	return FormatProfilerPercent((addonVal / relativeTotal) * 100)
end

function mMT:SystemInfo()
	local isProfilerEnabled = C_AddOnProfiler.IsEnabled()

	for _, addon in ipairs(topAddOns) do
		addon.value = 0
	end

	UpdateAddOnMemoryUsage()
	local totalMem, addonCount = 0, C_AddOns.GetNumAddOns()

	for i = 1, addonCount do
		local name, mem = C_AddOns.GetAddOnInfo(i), GetAddOnMemoryUsage(i)
		local cpu = isProfilerEnabled and GetAddonMetricPercent(name, Enum.AddOnProfilerMetric.RecentAverageTime) or "N/A"

		totalMem = totalMem + mem

		for j = 1, 5 do
			if mem > topAddOns[j].value then
				table.insert(topAddOns, j, { name = name, value = mem, cpu = cpu })
				table.remove(topAddOns, 6)
				break
			end
		end
	end

	if totalMem > 0 then
		DT.tooltip:AddDoubleLine(L["AddOn Memory:"], GetMemoryString(totalMem), mMT:GetRGB("text", "text"))

		if isProfilerEnabled then
			local function AddCPUStatistic(label, metric)
				local overall = GetOverallMetric(metric)
				local appOverall = GetApplicationMetric(metric)
				if appOverall > 0 then DT.tooltip:AddDoubleLine(L[label], format("%.2f%%", (overall / appOverall) * 100), mMT:GetRGB("text", "text")) end
			end

			AddCPUStatistic("CPU overall:", Enum.AddOnProfilerMetric.SessionAverageTime)
			AddCPUStatistic("CPU peak:", Enum.AddOnProfilerMetric.PeakTime)
		end

		DT.tooltip:AddLine(" ")
		for _, addon in ipairs(topAddOns) do
			if addon.value > 0 then DT.tooltip:AddDoubleLine(addon.name, addon.cpu .. " - " .. GetMemoryString(addon.value), mMT:GetRGB("text", "text")) end
		end
	end
end

function mMT:MMTSystemInfo()
	local isProfilerEnabled = C_AddOnProfiler.IsEnabled()
	if isProfilerEnabled then
		local memoryUsage = GetMemoryString(GetAddOnMemoryUsage("ElvUI_mMediaTag"))
		local cpuUsage = GetAddonMetricPercent("ElvUI_mMediaTag", Enum.AddOnProfilerMetric.RecentAverageTime)
		DT.tooltip:AddDoubleLine(L["Memory/ CPU usage:"], cpuUsage .. " - " .. memoryUsage, mMT:GetRGB("text", "text"))
	end
end

-- import/ export functions
local exportPrefix = "!mMT!"
function GetImportStringType(dataString)
	return (strmatch(dataString, "^" .. exportPrefix) and "Deflate") or (strmatch(dataString, "^{") and "Table") or ""
end

-- Secret-safe unit classification (WoW 12.x) ----------------------------------

-- Returns the value unchanged, or nil if it is a secret value (WoW 12.x).
-- Secret values must never be compared, concatenated or branched on.
local function SafeValue(value)
	if issecretvalue and issecretvalue(value) then return nil end
	return value
end

-- Extracts the npcID from a creature GUID; returns nil for player GUIDs,
-- missing GUIDs or the secret placeholder (" ").
local function GetNpcID(guid)
	if not guid or guid == " " then return nil end
	return select(6, strsplit("-", guid))
end

local MAX_BOSS_UNITS = 8
local bossTokens = {}
for i = 1, MAX_BOSS_UNITS do
	bossTokens[i] = "boss" .. i
end

-- Secret-safe check whether a unit matches one of the boss1-boss8 unit tokens.
local function IsBossTokenUnit(unit)
	for i = 1, MAX_BOSS_UNITS do
		local token = bossTokens[i]
		if SafeValue(UnitExists(token)) and SafeValue(UnitIsUnit(unit, token)) then return true end
	end
	return false
end

local extraTypes = { rare = true, elite = true, rareelite = true, boss = true }

--- Determines the classification of a unit (secret-safe, WoW 12.x).
-- @param unit        unit token
-- @param isBossFrame optional - true if the frame itself is a boss frame (boss1-bossN)
-- @param isPlayer    optional - true if the unit is a player; determined from the unit if nil
-- @param guid        optional - secret-guarded GUID (placeholder " " if secret); read from the unit if nil
-- @return "boss", "rareelite", "rare", "elite" or nil
function mMT:GetUnitClassification(unit, isBossFrame, isPlayer, guid)
	if not unit then return nil end

	if isPlayer == nil then isPlayer = SafeValue(UnitIsPlayer(unit)) and true or false end
	if guid == nil then guid = SafeValue(UnitGUID(unit)) or " " end

	local npcID = GetNpcID(guid)
	local classification = SafeValue(UnitClassification(unit))
	if classification == "worldboss" then classification = "boss" end

	local isBoss = isBossFrame
		or (npcID and ((mMT.IDs.boss and mMT.IDs.boss[npcID]) or (DB.boss_ids and DB.boss_ids[npcID])))
		or (classification == "boss")
		or (not isPlayer and IsBossTokenUnit(unit))
		or (not isPlayer and SafeValue(UnitLevel(unit)) == -1)

	if isBoss then
		-- learn the npcID for reliable pre-pull detection in future sessions
		if npcID and DB.boss_ids and not DB.boss_ids[npcID] then DB.boss_ids[npcID] = true end
		return "boss"
	end

	return extraTypes[classification] and classification or nil
end

function mMT:GetExportText(profileData, profileType)
	local serialString = D:Serialize(profileData)
	local exportString = D:CreateProfileExport(profileType, profileType, serialString)
	local compressedData = LibDeflate:CompressDeflate(exportString, LibDeflate.compressLevel)
	local printableString = LibDeflate:EncodeForPrint(compressedData)
	local profileExport = printableString and format("%s%s", exportPrefix, printableString) or nil

	return profileExport
end

function mMT:GetImportText(string)
	local profileInfo, profileType, profileData
	local stringType = GetImportStringType(string)
	if stringType == "Deflate" then
		local data = gsub(string, "^" .. exportPrefix, "")
		local decodedData = LibDeflate:DecodeForPrint(data)
		local decompressed = LibDeflate:DecompressDeflate(decodedData)
		if not decompressed then
			mMT:Print(L["Error decompressing data."])
			return
		end

		local serializedData, success
		serializedData, profileInfo = E:SplitString(decompressed, "^^::") -- '^^' indicates the end of the AceSerializer string

		if not profileInfo then
			mMT:Print(L["Error importing profile. String is invalid or corrupted!"])
			return
		end

		serializedData = format("%s%s", serializedData, "^^") --Add back the AceSerializer terminator
		profileType, _ = E:SplitString(profileInfo, "::")
		success, profileData = D:Deserialize(serializedData)

		if not success then
			mMT:Print(L["Error deserializing:"], profileData)
			return
		end
	end

	return profileType, profileData
end
