local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.CustomClassColors
if not module then
	return
end

local _G = _G
local hooksecurefunc = _G.hooksecurefunc

local function UpdateColors()
	for i, className in ipairs(mMT.Classes) do
		E.oUF.colors.class[className][1] = E.db.mMT.classcolors.colors[className]["r"]
		E.oUF.colors.class[className][2] = E.db.mMT.classcolors.colors[className]["g"]
		E.oUF.colors.class[className][3] = E.db.mMT.classcolors.colors[className]["b"]
		E.oUF.colors.class[className]["r"] = E.db.mMT.classcolors.colors[className]["r"]
		E.oUF.colors.class[className]["g"] = E.db.mMT.classcolors.colors[className]["g"]
		E.oUF.colors.class[className]["b"] = E.db.mMT.classcolors.colors[className]["b"]
	end
	UF:Update_AllFrames()
end

local function ClassColor(_, class)
	if not class then
		return
	end

	local color = E.db.mMT.classcolors.colors[class] or _G.RAID_CLASS_COLORS[class]

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

function module:Initialize()
	UpdateColors()

	if not module.hooked then
		hooksecurefunc(E, "ClassColor", ClassColor)
	end

	module.needReloadUI = true
	module.loaded = true
end
