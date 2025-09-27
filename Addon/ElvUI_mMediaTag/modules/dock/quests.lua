local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local questsDT = nil

local config = {
	name = "mMT_Dock_Quest",
	localizedName = "|CFF01EEFFDock|r" .. " " .. QUESTLOG_BUTTON,
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
		if questsDT then questsDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	questsDT = mMT:GetElvUIDataText("Quests")
	if questsDT then questsDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.quests.style][E.db.mMT.dock.quests.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.quests.custom_color and MEDIA.color.dock.quests or nil

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.questsVirtualFrame then
			self.questsVirtualFrame = {
				name = "Quests",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("Quests", self.questsVirtualFrame)
		end

		questsDT = mMT:GetElvUIDataText("Quests")
	end

	if questsDT and questsDT ~= "Data Broker" then questsDT.eventFunc(...) end

	self.text:SetText("")
end

DT:RegisterDatatext( config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
