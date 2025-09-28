local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.calendar

local _G = _G
local date = date
local FormatShortDate = FormatShortDate

local config = {
	name = "mMT_Dock_Calendar",
	localizedName = "|CFF01EEFFDock|r" .. " " .. L["Calendar"],
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMT.dock.tooltip then
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine(L["Calendar"], mMT:GetRGB("title"))
		DT.tooltip:AddLine(" ")

        local dateTable = date('*t')
		DT.tooltip:AddDoubleLine(L["Date:"], FormatShortDate(dateTable.day, dateTable.month, dateTable.year), mMT:GetRGB("text", "text"))

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then _G.GameTimeFrame:Click() end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		-- setup settings
		config.icon.texture = icons[E.db.mMT.dock.calendar.icon][date("%d")] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.calendar.custom_color and MEDIA.color.dock.calendar or nil

		Dock:CreateDockIcon(self, config, event)
	end
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
