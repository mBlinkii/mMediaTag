local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local _G = _G

--Variables
local Config = {
	name = "mMT_Dock_Calendar",
	localizedName = mMT.DockString .. " " .. L["Calendar"],
	category = "mMT-" .. mMT.DockString,
	text = {
		enable = true,
		center = false,
		a = true, -- first label
		b = false, -- second label
	},
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(L["Calendar"])
		local DateText = ""
		local day, month, year = date("%d"), date("%m"), date("%y")
		local option = E.db.mMT.dockdatatext.calendar.option
		if option == "de" then
			DateText = format("%s.%s.%s", day, month, year)
		elseif option == "us" then
			DateText = format("%s/%s/%s", month, day, year)
		elseif option == "gb" then
			DateText = format("%s/%s/%s", day, month, year)
		end
		DT.tooltip:AddLine(DateText)
		DT.tooltip:Show()
	end

	mMT:Dock_OnEnter(self, Config)
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		local texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.calendar.icon]

		if E.db.mMT.dockdatatext.calendar.dateicon ~= "none" then
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\calendar\\" .. E.db.mMT.dockdatatext.calendar.dateicon .. date("%d") .. ".tga"
		else
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.calendar.icon]
		end

		--setup settings
		Config.text.enable = E.db.mMT.dockdatatext.calendar.text
		Config.text.a = E.db.mMT.dockdatatext.calendar.text
		Config.icon.texture = texture
		Config.icon.color = E.db.mMT.dockdatatext.calendar.customcolor and E.db.mMT.dockdatatext.calendar.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	if E.db.mMT.dockdatatext.calendar.text then
		local option = E.db.mMT.dockdatatext.calendar.option
		local DateText = ""
		local day, month, year = date("%d"), date("%m"), date("%y")
		if E.db.mMT.dockdatatext.calendar.showyear then
			if option == "de" then
				DateText = format("%s.%s.%s", day, month, year)
			elseif option == "us" then
				DateText = format("%s/%s/%s", month, day, year)
			elseif option == "gb" then
				DateText = format("%s/%s/%s", day, month, year)
			end
		else
			if option == "de" then
				DateText = format("%s.%s", day, month)
			elseif option == "us" then
				DateText = format("%s/%s", month, day)
			elseif option == "gb" then
				DateText = format("%s/%s", day, month)
			end
		end
		self.mMT_Dock.TextA:SetText(DateText)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		if E.Retail then
			_G.GameTimeFrame:Click()
		elseif E.Cata then
			_G.Calendar_LoadUI()
			_G.ToggleCalendar()
		end
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
