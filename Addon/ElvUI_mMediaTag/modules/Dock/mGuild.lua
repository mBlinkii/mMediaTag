local E = unpack(ElvUI)
local L = mMT.Locales
local DT = E:GetModule("DataTexts")

--Variables
local _G = _G
local select = select
local guildDT = nil

local GetNumGuildMembers = GetNumGuildMembers
local IsInGuild = IsInGuild

local Config = {
	name = "mMT_Dock_Guild",
	localizedName = mMT.DockString .. " " .. L["Guild"],
	category = "mMT-" .. mMT.DockString,
	text = {
		enable = true,
		center = false,
		a = true, -- first label
		b = false, -- second label
	},
	icon = {
		notification = true,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnClick(self, btn)
	mMT:Dock_Click(self, Config)
	mMT:UpdateNotificationState(self, false)

	guildDT = mMT:GetElvUIDataText("Guild")
	if guildDT then guildDT.onClick(self, btn) end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then DT.tooltip:Hide() end

	mMT:Dock_OnLeave(self, Config)
end

local function OnEnter(self, _, noUpdate)
	mMT:Dock_OnEnter(self, Config)

	if E.db.mMT.dockdatatext.tip.enable and IsInGuild() then
		if E.db.mMT.dockdatatext.tip.enable and guildDT then guildDT.onEnter() end
	end
end

local function OnEvent(...)
	local self, event = ...
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.guild.icon]
		Config.icon.color = E.db.mMT.dockdatatext.guild.customcolor and E.db.mMT.dockdatatext.guild.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	-- Create virtual frames and connect them to datatexts
	if not self.guildVirtualFrame then
		self.guildVirtualFrame = {
			name = "Guild",
			text = {
				SetFormattedText = E.noop,
				SetText = E.noop,
			},
			GetScript = function()
				return E.noop
			end,
			IsMouseOver = function()
				return false
			end,
		}
		mMT:ConnectVirtualFrameToDataText("Guild", self.guildVirtualFrame)
	end

	guildDT = mMT:GetElvUIDataText("Guild")

	if guildDT and guildDT ~= "Data Broker" then guildDT.eventFunc(...) end

	if IsInGuild() then
		local guildCount = (select(2, GetNumGuildMembers()))
		self.mMT_Dock.TextA:SetText(guildCount or "")
	else
		self.mMT_Dock.TextA:SetText("")
	end

	if _G.GuildMicroButton and _G.GuildMicroButton.NotificationOverlay then
		local isShown = _G.GuildMicroButton.NotificationOverlay:IsShown()
		mMT:UpdateNotificationState(self, isShown)
	else
		mMT:UpdateNotificationState(self, false)
	end
	self.text:SetText("")
end

DT:RegisterDatatext(
	Config.name,
	Config.category,
	{ "CHAT_MSG_SYSTEM", "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE", "GUILD_MOTD", "MODIFIER_STATE_CHANGED" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	Config.localizedName,
	nil,
	nil
)
