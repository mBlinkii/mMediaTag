local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("DataPanelSkin", { "AceHook-3.0" })

local DT = E:GetModule("DataTexts")
local LSM = E.Libs.LSM

local function getColor(setting)
	if setting.style == "custom" then
		return setting.color
	elseif setting.style == "class" then
		return MEDIA.classColor
	elseif setting.style == "darkclass" then
		local c = MEDIA.classColor
		return { r = c.r - 0.3, g = c.g - 0.3, b = c.b - 0.3, a = 1 }
	else
		return { r = 1, g = 1, b = 1, a = 1 }
	end
end

local function UpdatePanelInfo(_, name, panel)
	local db = panel.mmt_db or E.db.mMT.data_panel_skin.panels[name]
	if not db then return end

	if not db.enable then return end

	if db.texture.enable and panel.backdropInfo then
		panel:SetBackdrop({ bgFile = LSM:Fetch("statusbar", db.texture.file), edgeSize = panel.backdropInfo.edgeSize, edgeFile = panel.backdropInfo.edgeFile })

		if db.border.style == "disabled" then panel:SetBackdropBorderColor(0, 0, 0, 1) end
	end

	local color = { r = 1, g = 1, b = 1, a = 1 }

	if db.bg.style ~= "disabled" then
		color = getColor(db.bg)
		panel:SetBackdropColor(color.r, color.g, color.b, db.bg.color.a or 1)
	end

	if db.border.style ~= "disabled" then
		color = getColor(db.border)
		panel:SetBackdropBorderColor(color.r, color.g, color.b, db.border.color.a or 1)
	end

	if not panel.db.border then panel:SetBackdropBorderColor(0, 0, 0, 0) end
end

local function CheckAndRemoveSettings()
	local cleanList = E.db.mMT.data_panel_skin.panels
	for k, v in pairs(E.db.mMT.data_panel_skin.panels) do
		if not DT.RegisteredPanels[k] then cleanList[k] = nil end
	end
	E.db.mMT.data_panel_skin.panels = cleanList
end

function module:Initialize()
	print("DataPanelSkin", E.db.mMT.data_panel_skin.enable, module:IsHooked(DT, "UpdatePanelInfo"))
	if E.db.mMT.data_panel_skin.enable then
		CheckAndRemoveSettings()

		if not module:IsHooked(DT, "UpdatePanelInfo") then module:SecureHook(DT, "UpdatePanelInfo", UpdatePanelInfo) end
	elseif module:IsHooked(DT, "UpdatePanelInfo") then
		module:Unhook(DT, "UpdatePanelInfo")
	end
end
