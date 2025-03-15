local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local L = mMT.Locales

--Lua functions
local format = format
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded

function mMT:ConvertDB()
	E.db.mMT.objectivetracker = {
		enable = false,
		bar = {
			fontsize = 12,
			fontpoint = "CENTER",
			elvbg = false,
			gradient = true,
			shadow = true,
			hight = 18,
		},
		font = {
			font = "PT Sans Narrow",
			fontflag = "NONE",
			highlight = 0.4,
			color = {
				title = { class = false, r = 1, g = 0.78, b = 0, hex = "|cffffc700" },
				header = { class = false, r = 1, g = 0.78, b = 0, hex = "|cffffc700" },
				text = { class = false, r = 0.87, g = 0.87, b = 0.87, hex = "|cff00ffa4" },
				failed = { r = 1, g = 0.16, b = 0, hex = "|cffff2800" },
				complete = { r = 0, g = 1, b = 0.27, hex = "|cff00ff45" },
				good = { r = 0.25, g = 1, b = 0.43, hex = "|cff40ff6e" },
				bad = { r = 0.92, g = 0.46, b = 0.1, hex = "|cffeb751a" },
				transit = { r = 1, g = 0.63, b = 0.05, hex = "|cffffa10d" },
			},
			fontsize = {
				header = 14,
				title = 12,
				text = 12,
			},
		},
		settings = {
			questcount = true,
			hidedash = true,
		},
		dungeon = {
			hidedash = true,
			shadow = true,
			difficulty = true,
			color = {
				chest3 = { a = { r = 0, g = 0.54, b = 1, a = 1 }, b = { r = 0, g = 0.71, b = 0.1, a = 1 } },
				chest2 = { a = { r = 1, g = 0.73, b = 0, a = 1 }, b = { r = 1, g = 0.49, b = 0, a = 1 } },
				chest1 = { a = { r = 1, g = 0, b = 0.14, a = 1 }, b = { r = 1, g = 0.33, b = 0, a = 1 } },
			},
		},
		headerbar = {
			enable = true,
			gradient = true,
			shadow = true,
			texture = "Solid",
			color = { r = 1, g = 0.78, b = 0, a = 1 },
			class = true,
		},
	}
end

function mMT:GetElvUIDataText(name)
	local dt = DT.RegisteredDataTexts[name]

	if dt and dt.category ~= "Data Broker" then return dt end
end

function mMT:ConnectVirtualFrameToDataText(dataTextName, virtualFrame)
	local dt = self:GetElvUIDataText(dataTextName)
	if dt.applySettings then dt.applySettings(virtualFrame, E.media.hexvaluecolor) end
end

function GetTableLng(tbl)
	local getN = 0
	for n in pairs(tbl) do
		getN = getN + 1
	end
	return getN
end

local indentColors = {
	[1] = "|CFF00FCB0", --#00FCB0
	[2] = "|CFF00CAFC", --#00CAFC
	[3] = "|CFF0054FC", --#0054FC
	[4] = "|CFF7E00FC", --#7E00FC
}

--string.format("%X", number)

local function PrintTable(tbl, indent, simple, noFunctions, depth)
	indent = indent or " "
    depth = depth or 1
    local colors = "|CFF" .. format("%X", random(50, 200)) .. format("%X", random(50, 200)) .. format("%X", random(50, 200))
    local color = "|CFF" .. format("%X", random(50, 200)) .. format("%X", random(50, 200)) .. format("%X", random(50, 200))
	if type(tbl) == "table" then
		print(color .. indent .. " {|r")
		for entry, value in pairs(tbl) do
			if (type(value) == "table") and not simple then
				PrintTable(value, indent .. indent .. "[" .. entry .. "]", true, noFunctions, depth + 1)
			else
				if type(value) == "table" then
					print(color .. indent .. "|r", "|cff60ffc3 [" .. entry .. "]|r", " > ", value)
				elseif type(value) == "number" then
					print(color .. indent .. "|r", "|cfff5b062 [" .. entry .. "]|r", " = ", value)
				elseif type(value) == "string" then
					print(color .. indent .. "|r", "|cffd56ef5 [" .. entry .. "]|r", " = ", value)
				elseif type(value) == "boolean" then
					print(color .. indent .. "|r", "|cff96e1ff[" .. entry .. "]|r", " = ", (value and "|cffabff87true|r" or "|cffff8787false|r"))
				elseif (type(value) == "function") and not noFunctions then
					print(color .. indent .. "|r", "|cffb5b3f5 [" .. entry .. "]|r", " = ", value)
				elseif type(value) ~= "function" then
					print(color .. indent .. "|r", "|cfffbd7f9 [" .. entry .. "]|r", " = ", value)
				end
			end
		end
		print(color .. indent .. " }|r")
		print(" ")
	else
		print(tostring(tbl))
	end
end

function mMT:DebugPrintTable(tbl, simple, noFunctions)
	if type(tbl) == "table" then
		local tblLength = GetTableLng(tbl)
		mMT:Print(": Table Start >>>", tbl, "Entries:", tblLength, "Options:", "Simple:", simple, "Functions:", noFunctions)
		PrintTable(tbl, "-", (tblLength > 50), noFunctions)
	else
		mMT:Print("Not a Table:", tbl)
	end
end

function mMT:ColorCheck(value)
	if value >= 1 then
		return 1
	elseif value <= 1 then
		return 0
	else
		return value
	end
end

function mMT:ColorFade(colorA, colorB, percent)
	local color = {}
	if colorA and colorA.r and colorA.g and colorA.b and colorB and colorB.r and colorB.g and colorB.b and percent then
		color.r = colorA.r - (colorA.r - colorB.r) * percent
		color.g = colorA.g - (colorA.g - colorB.g) * percent
		color.b = colorA.b - (colorA.b - colorB.b) * percent
		color.color = E:RGBToHex(color.r, color.g, color.b)
		return color
	elseif colorA and colorA.r and colorA.g and colorA.b then
		return colorA
	else
		print("|CFFE74C3CERROR - mMediaTag - COLORFADE|r")
		return { r = 1, g = 1, b = 1, a = 1 }
	end
end

function mMT:Check_ElvUI_EltreumUI()
	return (IsAddOnLoaded("ElvUI_EltreumUI") and E.db.ElvUI_EltreumUI.unitframes.gradientmode.enable)
end

function mMT:mIcon(icon, x, y)
	if icon then return format("|T%s:%s:%s:0:0:64:64:4:60:4:60|t", icon, x or 16, y or 16) end
end

function mMT:mCurrencyLink(id)
	return format("|cffffffff|Hcurrency:%s|h|r", id)
end

function mMT:round(number, decimals)
	if number then
		return (("%%.%df"):format(decimals)):format(number)
	else
		mMT:Print(L["!! ERROR - Round:"] .. " " .. number .. " - " .. decimals)
		return 0
	end
end

function mMT:IsNumber(number)
	if tonumber(number) then
		return true
	else
		return false
	end
end

function mMT:Print(...)
	print(mMT.Name .. ":", ...)
end

function mMT:GetClassColor(unit)
	if UnitIsPlayer(unit) then
		local _, unitClass = UnitClass(unit)
		local cs = E.oUF.colors.class[unitClass]
		return (cs and E:RGBToHex(cs.r, cs.g, cs.b)) or "|cFFcccccc"
	end
end

function mMT:SetElvUIMediaColor()
	local color = E:ClassColor(E.myclass)
	E.db.general.valuecolor["r"] = color.r
	E.db.general.valuecolor["g"] = color.g
	E.db.general.valuecolor["b"] = color.b
	E.db.general.valuecolor["a"] = 1
	E:UpdateAll()
end
