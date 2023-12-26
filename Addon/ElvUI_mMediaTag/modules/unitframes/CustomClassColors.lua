local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.CustomClassColors
if not module then
	return
end

local orgFunction = nil
local _G = _G
local hooksecurefunc = _G.hooksecurefunc

local function UpdateColors()
	for i, className in ipairs(E.oUF.colors.class) do
        print(i, className)
		E.oUF.colors.class[className][1] = 1
		E.oUF.colors.class[className][2] = 1
		E.oUF.colors.class[className][3] = 1
		E.oUF.colors.class[className]["r"] = 1
		E.oUF.colors.class[className]["g"] = 1
		E.oUF.colors.class[className]["b"] = 1
	end
	UF:Update_AllFrames()
end

function module:Initialize()
	UpdateColors()
	--hooksecurefunc(E, "ClassColor", mClassColor)

	if not orgFunction then
		orgFunction = E.ClassColor
	end

	if not module.hooked then
		function E:ClassColor(class, usePriestColor)
           -- print("ööööööööö", class)
			if not class then
				return
			end

			local color = (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class]) or _G.RAID_CLASS_COLORS[class]
			if type(color) ~= "table" then
				return
			end

			color.r = 1
			color.g = 1
			color.b = 1

			--if not color.colorStr then
				color.colorStr = E:RGBToHex(color.r, color.g, color.b, "ff")
			--elseif strlen(color.colorStr) == 6 then
			--	color.colorStr = "ff" .. color.colorStr
			--end

			--mMT:Print("TEST OK :D")
			--if usePriestColor and class == "PRIEST" and tonumber(color.colorStr, 16) > tonumber(E.PriestColors.colorStr, 16) then
			--	return E.PriestColors
			--else
				return color
			--end
		end
		module.hooked = true
        --mMT:Print("TEST OK :D ---")
	end

	module.needReloadUI = true
	module.loaded = true
end
