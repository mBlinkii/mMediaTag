local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local format = format
local print = print
local strmatch = strmatch
local GetApplicationMetric = C_AddOnProfiler.GetApplicationMetric
local GetOverallMetric = C_AddOnProfiler.GetOverallMetric
local GetAddOnMetric = C_AddOnProfiler.GetAddOnMetric

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

function mMT:HexToRGB(hex)
	if #hex == 6 then hex = "ff" .. hex end

	local a, r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16)

	return r / 255, g / 255, b / 255, a / 255
end

function mMT:round(number, decimals)
	if number then
		return (("%%.%df"):format(decimals)):format(number)
	else
		mMT:Print(L["!! ERROR - Round:"] .. " " .. number .. " - " .. decimals)
		return 0
	end
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
		DT.tooltip:AddDoubleLine(mMT:TC(L["AddOn Memory:"]), mMT:TC(GetMemoryString(totalMem)))

		if isProfilerEnabled then
			local function AddCPUStatistic(label, metric)
				local overall = GetOverallMetric(metric)
				local appOverall = GetApplicationMetric(metric)
				if appOverall > 0 then DT.tooltip:AddDoubleLine(mMT:TC(L[label]), mMT:TC(format("%.2f%%", (overall / appOverall) * 100))) end
			end

			AddCPUStatistic("CPU overall:", Enum.AddOnProfilerMetric.SessionAverageTime)
			AddCPUStatistic("CPU peak:", Enum.AddOnProfilerMetric.PeakTime)
		end

		DT.tooltip:AddLine(" ")
		for _, addon in ipairs(topAddOns) do
			if addon.value > 0 then DT.tooltip:AddDoubleLine(mMT:TC(addon.name), mMT:TC(addon.cpu .. " - " .. GetMemoryString(addon.value))) end
		end
	end
end

function mMT:MMTSystemInfo()
	local isProfilerEnabled = C_AddOnProfiler.IsEnabled()
	if isProfilerEnabled then
		local memoryUsage = GetMemoryString(GetAddOnMemoryUsage("ElvUI_mMediaTag"))
		local cpuUsage = GetAddonMetricPercent("ElvUI_mMediaTag", Enum.AddOnProfilerMetric.RecentAverageTime)
		DT.tooltip:AddDoubleLine(mMT:TC(L["Memory/ CPU usage:"]), mMT:TC(cpuUsage .. " - " .. memoryUsage))
	end
end

-- import/ export functions
local exportPrefix = "!mMT!"
function GetImportStringType(dataString)
	return (strmatch(dataString, "^" .. exportPrefix) and "Deflate") or (strmatch(dataString, "^{") and "Table") or ""
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
