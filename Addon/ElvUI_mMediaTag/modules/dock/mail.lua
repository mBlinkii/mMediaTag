local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local mailDT = nil

local config = {
	name = "mMT_Dock_Mail",
	localizedName = "|CFF01EEFFDock|r" .. " " .. MAIL_LABEL,
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
		if mailDT then mailDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	mailDT = mMT:GetElvUIDataText("Mail")
	if mailDT then mailDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.mail.style][E.db.mMT.dock.mail.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.mail.custom_color and MEDIA.color.dock.mail or nil

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.mailVirtualFrame then
			self.mailVirtualFrame = {
				name = "Mail",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("Mail", self.mailVirtualFrame)
		end

		mailDT = mMT:GetElvUIDataText("Mail")
	end

	if mailDT and mailDT ~= "Data Broker" then mailDT.eventFunc(...) end

    if HasNewMail() then
		E:Flash(self.mMT_Dock.Icon, 0.5, true)
	else
		E:StopFlash(self.mMT_Dock.Icon, 1)
    end


	self.text:SetText("")
end

DT:RegisterDatatext( config.name, config.category, { "MAIL_INBOX_UPDATE", "UPDATE_PENDING_MAIL", "MAIL_CLOSED", "MAIL_SHOW" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
