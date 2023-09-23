local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

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

function mMT:SetCustomColors()
	UpdateColors()
	hooksecurefunc(E, "ClassColor", mClassColor)
end
