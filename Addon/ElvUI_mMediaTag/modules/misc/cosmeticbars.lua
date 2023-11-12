local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local _G = _G
local module = mMT.Modules.CosmeticBars
if not module then
	return
end

local LSM = E.Libs.LSM
local function SetColor(panel, setting, border)
	local color = { r = 1, g = 1, b = 1, a = 1 }

	color = { r = 1, g = 1, b = 1, a = 1 }
	if setting.style == "custom" then
		color = setting.color
	else
		color = E:ClassColor(E.myclass)
		if setting.style == "darkclass" then
			color.r = color.r - 0.3
			color.g = color.g - 0.3
			color.b = color.b - 0.3
		end
	end

	if border then
		panel:SetBackdropBorderColor(color.r, color.g, color.b)
	else
		panel:SetBackdropColor(color.r, color.g, color.b, setting.color.a)
	end
end

local function SetBGTexture(panel, file, border)
	local BGInfo = panel.backdropInfo
	panel:SetBackdrop({ bgFile = LSM:Fetch("statusbar", file), edgeSize = BGInfo.edgeSize, edgeFile = BGInfo.edgeFile })

	if border then
		panel:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

local function UpdatePanelColors(_, name, panel)
	if E.db.mMT.cosmeticbars.bars[name] then
		if E.db.mMT.cosmeticbars.bars[name].texture.enable then
			SetBGTexture(panel, E.db.mMT.cosmeticbars.bars[name].texture.file, (E.db.mMT.cosmeticbars.bars[name].border.style == "disabled"))
		end

		if E.db.mMT.cosmeticbars.bars[name].bg.style ~= "disabled" then
			SetColor(panel, E.db.mMT.cosmeticbars.bars[name].bg, false)
		end

		if E.db.mMT.cosmeticbars.bars[name].border.style ~= "disabled" then
			SetColor(panel, E.db.mMT.cosmeticbars.bars[name].border, true)
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
