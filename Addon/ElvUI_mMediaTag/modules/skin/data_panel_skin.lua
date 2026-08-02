local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("DataPanelSkin", { "AceHook-3.0" })

local DT = E:GetModule("DataTexts")
local LSM = E.Libs.LSM

local function getColor(setting)
	if setting.style == "custom" then
		return setting.color
	elseif setting.style == "class" then
		return MEDIA.myclass
	elseif setting.style == "darkclass" then
		local c = MEDIA.myclass
		return { r = c.r - 0.3, g = c.g - 0.3, b = c.b - 0.3, a = 1 }
	else
		return { r = 1, g = 1, b = 1, a = 1 }
	end
end

-- SetTemplate calls this instead of its own SetBackdropColor, so the color survives every retemplate
local function BackdropColor(panel)
	local c = panel.mmt_color
	if c then
		panel:SetBackdropColor(c.r, c.g, c.b, c.a)
	end
end

local function ApplyTemplate(panel)
	E.UpdateFrameTemplate(panel)
end

local function ClearSkin(panel)
	if not panel.mmt_skinned then return end

	panel.mmt_skinned = nil
	panel.mmt_color = nil
	panel.callbackBackdropColor = nil
	panel.glossTex = true

	if panel.mmt_border then
		panel.mmt_border = nil
		E:ForceBorderColor(panel)
	end

	ApplyTemplate(panel)
end

local function UpdatePanelInfo(_, name, panel)
	if not panel or not panel.template then return end

	local db = E.db.mMediaTag.data_panel_skin.panels[name]
	if not db or not db.enable then
		ClearSkin(panel)
		return
	end

	-- a string glossTex becomes the bgFile, and E:UpdateFrameTemplate feeds it back on every pass
	panel.glossTex = db.texture.enable and LSM:Fetch("statusbar", db.texture.file) or true

	if db.bg.style ~= "disabled" then
		local c, color = getColor(db.bg), panel.mmt_color or {}
		color.r, color.g, color.b, color.a = c.r, c.g, c.b, db.bg.color.a or 1
		panel.mmt_color = color
		panel.callbackBackdropColor = BackdropColor
	else
		panel.mmt_color = nil
		panel.callbackBackdropColor = nil
	end

	-- ElvUI already forces a transparent border when the panel's own border option is off
	if panel.db and panel.db.border == false then
		panel.mmt_border = nil
	elseif db.border.style ~= "disabled" then
		local c = getColor(db.border)
		E:ForceBorderColor(panel, c.r, c.g, c.b, db.border.color.a or 1)
		panel.mmt_border = true
	else
		E:ForceBorderColor(panel, 0, 0, 0, 1)
		panel.mmt_border = true
	end

	panel.mmt_skinned = true
	ApplyTemplate(panel)
end

local function CheckAndRemoveSettings()
	local cleanList = E.db.mMediaTag.data_panel_skin.panels
	for k in pairs(E.db.mMediaTag.data_panel_skin.panels) do
		if not DT.RegisteredPanels[k] then cleanList[k] = nil end
	end
	E.db.mMediaTag.data_panel_skin.panels = cleanList
end

function module:Initialize()
	local enabled = E.db.mMediaTag.data_panel_skin.enable

	if enabled then
		CheckAndRemoveSettings()

		if not module:IsHooked(DT, "UpdatePanelInfo") then module:SecureHook(DT, "UpdatePanelInfo", UpdatePanelInfo) end
	elseif module:IsHooked(DT, "UpdatePanelInfo") then
		module:Unhook(DT, "UpdatePanelInfo")
	end

	-- panels ElvUI has not templated yet are picked up by the hook on their first update
	for name, panel in pairs(DT.RegisteredPanels) do
		if panel.template then
			if enabled then
				UpdatePanelInfo(DT, name, panel)
			else
				ClearSkin(panel)
			end
		end
	end
end
