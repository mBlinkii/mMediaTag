local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local specDT = nil
local _G = _G

local config = {
	name = "mMT_Dock_Spec",
	localizedName = "|CFF01EEFFDock|r" .. " " .. _G.TALENTS_BUTTON,
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
		if specDT then specDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	specDT = mMT:GetElvUIDataText("Talent/Loot Specialization")
	if specDT then specDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.spec.style][E.db.mMT.dock.spec.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.spec.custom_color and MEDIA.color.dock.spec or nil

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.specVirtualFrame then
			self.specVirtualFrame = {
				name = "Talent/Loot Specialization",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("Talent/Loot Specialization", self.specVirtualFrame)
		end

		specDT = mMT:GetElvUIDataText("Talent/Loot Specialization")
	end

	if specDT and specDT ~= "Data Broker" then specDT.eventFunc(...) end

	self.text:SetText("")
end

local events = E.Retail and {'PLAYER_TALENT_UPDATE', 'ACTIVE_TALENT_GROUP_CHANGED', 'PLAYER_LOOT_SPEC_UPDATED', 'TRAIT_CONFIG_DELETED', 'TRAIT_CONFIG_UPDATED'} or { 'PLAYER_SPECIALIZATION_CHANGED', 'PLAYER_TALENT_UPDATE', 'ACTIVE_TALENT_GROUP_CHANGED', 'PLAYER_LOOT_SPEC_UPDATED', 'TRAIT_CONFIG_DELETED', 'TRAIT_CONFIG_UPDATED', 'CHAT_MSG_SYSTEM' }
DT:RegisterDatatext( config.name, config.category, events, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
