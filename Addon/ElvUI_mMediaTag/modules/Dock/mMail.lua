local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local HAVE_MAIL_FROM = HAVE_MAIL_FROM
local MAIL_LABEL = MAIL_LABEL

--Variables
local _G = _G

local Config = {
	name = "mMT_Dock_Mail",
	localizedName = mMT.DockString .. " " .. MAIL_LABEL,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:ClearLines()

		local senders = { GetLatestThreeSenders() }
		if not next(senders) then
			return
		end

		DT.tooltip:AddLine(HasNewMail() and HAVE_MAIL_FROM or MAIL_LABEL, 1, 1, 1)
		DT.tooltip:AddLine(" ")

		for _, sender in pairs(senders) do
			DT.tooltip:AddLine(sender)
		end

		DT.tooltip:Show()
	end

	mMT:Dock_OnEnter(self, Config)
end

local function OnEvent(self, event, ...)
		--setup settings
		Config.icon.texture = HasNewMail() and mMT.Media.DockIcons[E.db.mMT.dockdatatext.mail.icon] or "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\noIcon.tga"
		Config.icon.color = E.db.mMT.dockdatatext.achievement.customcolor and E.db.mMT.dockdatatext.achievement.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
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
		_G.ToggleAchievementFrame()
	end
end

DT:RegisterDatatext(Config.name, Config.category, {"MAIL_INBOX_UPDATE", "UPDATE_PENDING_MAIL", "MAIL_CLOSED", "MAIL_SHOW"}, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
