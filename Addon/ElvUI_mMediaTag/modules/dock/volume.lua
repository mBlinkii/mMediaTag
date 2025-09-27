local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local volumeDT = nil
local panelText

local config = {
	name = "mMT_Dock_Volume",
	localizedName = "|CFF01EEFFDock|r" .. " " .. L["Volume"],
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
	text = {
		enable = false,
		center = true,
		a = false, -- first label
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)
	if E.db.mMT.dock.tooltip then
		if volumeDT then volumeDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	volumeDT = mMT:GetElvUIDataText("Volume")
	if volumeDT then volumeDT.onClick(self, btn) end
end

local function SetText(_, text)
	if text and text ~= "" then panelText = text end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.volume.style][E.db.mMT.dock.volume.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.volume.custom_color and MEDIA.color.dock.volume or nil
		config.text.enable = E.db.mMT.dock.volume.text
		config.text.a = E.db.mMT.dock.volume.text

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.volumeVirtualFrame then
			self.volumeVirtualFrame = {
				name = "Volume",
				text = {
					SetFormattedText = E.noop,
					SetText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("Volume", self.volumeVirtualFrame)
		end

		volumeDT = mMT:GetElvUIDataText("Volume")

		self:EnableMouseWheel(true)

		panelText = self.text:GetText()
		self.text:SetText("")
		self.text.SetText = SetText
	end

	if volumeDT and volumeDT ~= "Data Broker" then volumeDT.eventFunc(...) end

	if E.db.mMT.dock.volume.text then
		if panelText then
			local pattern, suffix
			if E.db.mMT.dock.volume.colored then
				pattern = "|cFF%x%x%x%x%x%x.-%%|r"
				suffix = ""
			else
				pattern = "|cFF%x%x%x%x%x%x(%d+)%%|r"
				suffix = "%"
			end

			local level = string.match(panelText, pattern)
			if level then self.mMT_Dock.TextA:SetText(level .. suffix) end
		end
	end
end

DT:RegisterDatatext(config.name, config.category, { "CVAR_UPDATE" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
