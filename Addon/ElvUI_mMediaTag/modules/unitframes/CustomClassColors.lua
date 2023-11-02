local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")
lCUSTOM_CLASS_COLORS = {}
local function UpdateColors()
	for i, className in ipairs(mMT.Classes) do
		E.oUF.colors.class[className][1] = E.db.mMT.customclasscolors.colors[className]["r"]
		E.oUF.colors.class[className][2] = E.db.mMT.customclasscolors.colors[className]["g"]
		E.oUF.colors.class[className][3] = E.db.mMT.customclasscolors.colors[className]["b"]
		E.oUF.colors.class[className]["r"] = E.db.mMT.customclasscolors.colors[className]["r"]
		E.oUF.colors.class[className]["g"] = E.db.mMT.customclasscolors.colors[className]["g"]
		E.oUF.colors.class[className]["b"] = E.db.mMT.customclasscolors.colors[className]["b"]
	end
	UF:Update_AllFrames()
end

function mMT:SetElvUIMediaColor()
	local _, unitClass = UnitClass("player")
	local colorDB = (E.db.mMT.customclasscolors.enable and not mMT:Check_ElvUI_EltreumUI()) and E.db.mMT.customclasscolors.colors[unitClass] or E:ClassColor(E.myclass, true)
	E.db.general.valuecolor["r"] = colorDB.r
	E.db.general.valuecolor["g"] = colorDB.g
	E.db.general.valuecolor["b"] = colorDB.b
	E.db.general.valuecolor["a"] = 1
	E:UpdateAll()
end

local function mClassColor(elv, class)
	if not class then
		return
	end

	local color = (E.db.mMT.customclasscolors.colors and E.db.mMT.customclasscolors.colors[class]) or (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class]) or _G.RAID_CLASS_COLORS[class]

	if type(color) ~= "table" then
		return
	end

	if not color.colorStr then
		color.colorStr = E:RGBToHex(color.r, color.g, color.b, "ff")
	elseif strlen(color.colorStr) == 6 then
		color.colorStr = "ff" .. color.colorStr
	end

	return color
end

local updateFunctions = {}
-- function _G.CUSTOM_CLASS_COLORS:RegisterCallback(func)
-- 	tinsert(updateFunctions, func)
-- 	mMT:DebugPrintTable(updateFunctions)
-- end

function lCUSTOM_CLASS_COLORS:RegisterCallback(method, handler)
	assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
		assert(type(handler[method]) == "function", "Bad argument #1 to :RegisterCallback (method \"" .. method .. "\" not found)")
		method = handler[method]
	end
	-- assert(not callbacks[method] "Callback already registered!")
	updateFunctions[method] = handler or true
	mMT:DebugPrintTable(updateFunctions)
end

function lCUSTOM_CLASS_COLORS:UnregisterCallback(method, handler)
	assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
		assert(type(handler[method]) == "function", "Bad argument #1 to :UnregisterCallback (method \"" .. method .. "\" not found)")
		method = handler[method]
	end
	-- assert(callbacks[method], "Callback not registered!")
	updateFunctions[method] = nil
	mMT:DebugPrintTable(updateFunctions)
end

function mMT:SetCustomColors()
	UpdateColors()
	--hooksecurefunc(E, "ClassColor", mClassColor)
	_G.lCUSTOM_CLASS_COLORS = E.db.mMT.customclasscolors.colors
end
