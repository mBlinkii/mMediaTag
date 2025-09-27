local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local professionsDT = nil

local config = {
	name = "mMT_Dock_Profession",
	localizedName = "|CFF01EEFFDock|r" .. " " .. TRADE_SKILLS,
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
		if professionsDT then professionsDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	professionsDT = mMT:GetElvUIDataText("mMT - Professions")
	if professionsDT then professionsDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.professions.style][E.db.mMT.dock.professions.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.professions.custom_color and MEDIA.color.dock.professions or nil

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.professionsVirtualFrame then
			self.professionsVirtualFrame = {
				name = "mMT - Professions",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("mMT - Professions", self.professionsVirtualFrame)
		end

		professionsDT = mMT:GetElvUIDataText("mMT - Professions")
	end

	if professionsDT and professionsDT ~= "Data Broker" then professionsDT.eventFunc(...) end

	self.text:SetText("")
end

DT:RegisterDatatext( config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
