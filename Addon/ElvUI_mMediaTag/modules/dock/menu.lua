local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local menuDT = nil

local config = {
	name = "mMT_Dock_Menu",
	localizedName = "|CFF01EEFFDock|r" .. " " .. MAINMENU_BUTTON,
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
		if menuDT then menuDT.onEnter(self) end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)

	if E.db.mMT.dock.tooltip then
		if menuDT then menuDT.onLeave(self) end
		DT.tooltip:Hide()
	end
end

local function OnClick(self, btn)
	Dock:Click(self)
	menuDT = mMT:GetElvUIDataText("mMT - Game menu")
	if menuDT then menuDT.onClick(self, btn) end
end

local function OnUpdate(...)
	if menuDT then menuDT.onUpdate(...) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.menu.style][E.db.mMT.dock.menu.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.menu.custom_color and MEDIA.color.dock.menu or nil

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.menuVirtualFrame then
			self.menuVirtualFrame = {
				name = "mMT - Game menu",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("mMT - Game menu", self.menuVirtualFrame)
		end
		menuDT = mMT:GetElvUIDataText("mMT - Game menu")
	end

	if menuDT and menuDT ~= "Data Broker" then menuDT.eventFunc(...) end

	self.text:SetText("")
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, OnUpdate, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
