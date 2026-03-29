local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock

local _G = _G

local config = {
	name = "mMT_Dock_Housing",
	localizedName = "|CFF01EEFFDock|r" .. " " .. L["Housing"],
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)


	if E.db.mMediaTag.dock.tooltip then
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine(L["Housing"], mMT:GetRGB("title"))

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMediaTag.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then
		if _G.Kiosk.IsEnabled() then return end

		if not _G.KeybindFrames_InQuickKeybindMode() then _G.HousingFramesUtil.ToggleHousingDashboard() end
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		-- setup settings
		config.icon.texture = icons[E.db.mMediaTag.dock.housing.style][E.db.mMediaTag.dock.housing.icon] or MEDIA.fallback
		config.icon.color = E.db.mMediaTag.dock.housing.custom_color and MEDIA.color.dock.housing or nil

		Dock:CreateDockIcon(self, config, event)
	end
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
