local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local type = type
local tostring = tostring
local pairs = pairs
local print = print

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
