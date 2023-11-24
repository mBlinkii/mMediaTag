local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local _G = _G
local module = mMT.Modules.CosmeticBars
if not module then
	return
end

local LSM = E.Libs.LSM

local function getColor(setting)
	if setting.style == "custom" then
		return setting.color
	elseif setting.style == "class" then
		return mMT.ClassColor
	elseif setting.style == "darkclass" then
		local c = mMT.ClassColor
		return { r = c.r - 0.3, g = c.g - 0.3, b = c.b - 0.3, a = 1 }
	else
		return { r = 1, g = 1, b = 1, a = 1 }
	end
end

local function UpdatePanelColors(_, name, panel)
	local conf = E.db.mMT.cosmeticbars.bars[name]

	if conf then
		if conf.texture.enable and panel.backdropInfo then
			panel:SetBackdrop({ bgFile = LSM:Fetch("statusbar", conf.texture.file), edgeSize = panel.backdropInfo.edgeSize, edgeFile = panel.backdropInfo.edgeFile })

			if conf.border.style == "disabled" then
				panel:SetBackdropBorderColor(0, 0, 0, 1)
			end
		end

		local color = { r = 1, g = 1, b = 1, a = 1 }

		if conf.bg.style ~= "disabled" then
			color = getColor(conf.bg)
			panel:SetBackdropColor(color.r, color.g, color.b, conf.bg.color.a)
		end

		if conf.border.style ~= "disabled" then
			color = getColor(conf.border)
			panel:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end
end

local function CheckAndRemoveSettings()
	local cleanList = E.db.mMT.cosmeticbars.bars
	for k, v in pairs(E.db.mMT.cosmeticbars.bars) do
		if not DT.RegisteredPanels[k] then
			cleanList[k] = nil
		end
	end
	E.db.mMT.cosmeticbars.bars = cleanList
end

local function UpdateDBSettings()
	local defaultDB = {
		bg = { style = "custom", color = { r = 1, g = 1, b = 1, a = 1 } },
		border = { style = "custom", color = { r = 1, g = 1, b = 1 } },
		texture = { enable = false, file = "Solid" },
	}

	for k, v in pairs(E.db.mMT.cosmeticbars.bars) do
		for a, c in pairs(defaultDB) do
			if v[a] == nil then
				v[a] = c
			end
		end
	end
end

function module:Initialize()
	if not module.loaded then
		CheckAndRemoveSettings()
		UpdateDBSettings()
		hooksecurefunc(DT, "UpdatePanelInfo", UpdatePanelColors)
		module.loaded = true
		module.needReloadUI = true

		module.loaded = true
	end
end
