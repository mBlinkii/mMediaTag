local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local guildDT = nil
local GetNumGuildMembers = GetNumGuildMembers

local config = {
	name = "mMT_Dock_Guild",
	localizedName = "|CFF01EEFFDock|r" .. " " .. L["Guild"],
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
		if guildDT then guildDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	local showGold = E.db.mMT.dock.bags.gold
	guildDT = mMT:GetElvUIDataText("Guild")
	if guildDT then guildDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.guild.style][E.db.mMT.dock.guild.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.guild.custom_color and MEDIA.color.dock.guild or nil
		config.text.enable = E.db.mMT.dock.guild.text
		config.text.a = E.db.mMT.dock.guild.text

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.guildVirtualFrame then
			self.guildVirtualFrame = {
				name = "Guild",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("Guild", self.guildVirtualFrame)
		end

		guildDT = mMT:GetElvUIDataText("Guild")
	end

	if guildDT and guildDT ~= "Data Broker" then guildDT.eventFunc(...) end

	if E.db.mMT.dock.guild.text then
		local onlineGuildMembers = select(2, GetNumGuildMembers())
		self.mMT_Dock.TextA:SetText(onlineGuildMembers)
	end

	self.text:SetText("")
end

DT:RegisterDatatext( config.name, config.category, { "CHAT_MSG_SYSTEM", "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE", "GUILD_MOTD", "MODIFIER_STATE_CHANGED" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
