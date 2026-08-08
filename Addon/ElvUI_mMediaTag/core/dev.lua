local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local _G = _G
local type = type
local tostring = tostring
local pairs = pairs
local print = print
local strfind = strfind
local collectgarbage = collectgarbage
local debugprofilestop = debugprofilestop
local UnitGUID = UnitGUID

local PROFILER_EXCLUDE = {
	["NP-ExecuteMarker"] = true, -- profiler packs return values into a table, these carry secret health values
}

local DEV_CHARACTERS = {
	["Player-1406-064A6ECF"] = true,
	["Player-604-0AE16F52"] = true,
	["Player-604-0A714DD6"] = true,
	["Player-604-0A47D6B2"] = true,
}

local function GetTableLength(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

local function PrintTable(tbl, indent, simple, noFunctions, depth, parent)
	indent = indent or " "
	depth = depth or 1
	parent = parent or ""

	if type(tbl) == "table" then
		print(indent .. "{")
		for entry, value in pairs(tbl) do
			local currentPath = parent .. (parent ~= "" and "." or "") .. tostring(entry)
			if type(value) == "table" and not simple then
				print(indent .. currentPath .. " = {")
				PrintTable(value, indent .. "    ", depth > 2, noFunctions, depth + 1, currentPath)
				print(indent .. "}")
			elseif E.IsSecretValue(value) then
				print("|cffff8787SecretValue|r: ", value)
			else
				local valueType = type(value)
				local entryColor = "FFFF92BC"
				if valueType == "number" then
					entryColor = "FF8599FF"
				elseif valueType == "string" then
					entryColor = "FFDF6CFF"
				elseif valueType == "boolean" then
					entryColor = "FF74FDF1"
				elseif not noFunctions and valueType == "function" then
					entryColor = "FFF7AE6A"
				elseif valueType == "table" then
					entryColor = "FFA575F7"
				end

				local valueStr = valueType == "boolean" and (value and "|cffabff87true|r" or "|cffff8787false|r") or tostring(value)
				print(indent .. "|c" .. entryColor .. " " .. currentPath .. "|r", " = ", valueStr)
			end
		end
		print(indent .. "}")
	else
		print(tostring(tbl))
	end
end

function mMT:DebugPrint(arg, simple, noFunctions, ...)
	if type(arg) == "table" then
		local tblLength = GetTableLength(arg)
		mMT:Print(": Table Start >>>", arg, "Entries:", tblLength, "Options:", "Simple:", simple, "Functions:", noFunctions)
		PrintTable(arg, nil, simple, noFunctions)
	else
		mMT:Print("Not a Table:", arg, ...)
	end
end

-- oUF only uses a tag's first return; profiler:Wrap packs returns into a table, which secret values must not enter.
local function WrapTag(profiler, tag, func)
	return function(...)
		if not profiler:IsLogging() then return func(...) end

		local time, mem = debugprofilestop(), collectgarbage("count")
		local result = func(...)
		profiler:Log("mMediaTag", "TAGs", tag, debugprofilestop() - time, collectgarbage("count") - mem)

		return result
	end
end

-- Returns nil if FunctionProfiler is missing, 0 if already wrapped, otherwise the number of wrapped functions.
function mMT:EnableProfiling()
	local profiler = _G.NumyFunctionProfiler
	if not profiler or not profiler.Wrap then return end
	if mMT.Profiling then return 0 end

	local count = 0
	for name, module in pairs(M) do
		if not PROFILER_EXCLUDE[name] then
			for key, value in pairs(module) do
				if type(value) == "function" then
					module[key] = profiler:Wrap("mMediaTag", name, key, value)
					count = count + 1
				end
			end
		end
	end

	local Tags = E.oUF and E.oUF.Tags
	if Tags then
		for tag, func in pairs(Tags.Methods) do
			if type(tag) == "string" and type(func) == "function" and strfind(tag, "^mMT%-") then
				Tags.Methods[tag] = WrapTag(profiler, tag, func)
				Tags:RefreshMethods(tag) -- font strings cache a compiled closure per tag string
				count = count + 1
			end
		end
	end

	mMT.Profiling = true
	if not profiler:IsLogging() then profiler:EnableLogging() end

	return count
end

function mMT:GetCurrentPlayerGUID()
	return UnitGUID("player")
end

function mMT:IsDeveloperCharacter()
	local guid = mMT:GetCurrentPlayerGUID()
	return guid and ((DB and DB.customDevGUIDs and DB.customDevGUIDs[guid]) or DEV_CHARACTERS[guid]) or false
end

function mMT:UpdateDeveloperState()
	local isDeveloper = mMT:IsDeveloperCharacter()

	mMT.defaults.DEV = isDeveloper
	DB.DEV = isDeveloper
end

function mMT:AddDeveloperCharacter()
	local guid = mMT:GetCurrentPlayerGUID()
	if not guid then return false end

	DB.customDevGUIDs = DB.customDevGUIDs or {}
	DB.customDevGUIDs[guid] = true
	mMT:UpdateDeveloperState()

	return guid
end
