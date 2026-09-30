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

-- the icon shows the day of month, a session running past midnight needs the new one
local function UpdateDay(self)
	local day = date("%d")
	if self.mMT_DockDay == day then return end

	self.mMT_DockDay = day
	config.icon.texture = icons[E.db.mMediaTag.dock.calendar.icon][day] or MEDIA.fallback
	if self.mMT_Dock and self.mMT_Dock.Icon then self.mMT_Dock.Icon:SetTexture(config.icon.texture) end
end

local function OnEnter(self)
	UpdateDay(self)
	Dock:OnEnter(self)

	if E.db.mMediaTag.dock.tooltip then
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine(L["Calendar"], mMT:GetRGB("title"))
		DT.tooltip:AddLine(" ")

		local dateTable = date("*t")
		DT.tooltip:AddDoubleLine(L["Date:"], FormatShortDate(dateTable.day, dateTable.month, dateTable.year), mMT:GetRGB("text", "text"))

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMediaTag.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then _G.GameTimeFrame:Click() end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		self.mMT_DockDay = date("%d")
		config.icon.texture = icons[E.db.mMediaTag.dock.calendar.icon][self.mMT_DockDay] or MEDIA.fallback
		config.icon.color = E.db.mMediaTag.dock.calendar.custom_color and MEDIA.color.dock.calendar or nil

		Dock:CreateDockIcon(self, config, event)
		return
	end

	UpdateDay(self)
end

DT:RegisterDatatext(config.name, config.category, { "PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
