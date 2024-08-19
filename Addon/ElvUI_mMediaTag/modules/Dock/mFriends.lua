local E = unpack(ElvUI)
local L = mMT.Locales
local DT = E:GetModule("DataTexts")

--Variables
local friendsdDT = nil
local BNGetNumFriends = BNGetNumFriends
local C_FriendList_GetNumOnlineFriends = C_FriendList.GetNumOnlineFriends

local Config = {
	name = "mMT_Dock_Friends",
	localizedName = mMT.DockString .. " " .. L["Friends"],
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

local function OnLeave(self)
	DT.tooltip:Hide()

	mMT:Dock_OnLeave(self, Config)
end

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)

	if E.db.mMT.dockdatatext.tip.enable then
		if E.db.mMT.dockdatatext.tip.enable and friendsdDT then friendsdDT.onEnter() end
	end
end

local function Click(self, btn)
	mMT:Dock_Click(self, Config)
	friendsdDT = mMT:GetElvUIDataText("Friends")
	if friendsdDT then friendsdDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.friends.icon]
		Config.icon.color = E.db.mMT.dockdatatext.friends.customcolor and E.db.mMT.dockdatatext.friends.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	-- Create virtual frames and connect them to datatexts
	if not self.friendsVirtualFrame then
		self.friendsVirtualFrame = {
			name = "Friends",
			text = {
				SetFormattedText = E.noop,
			},
		}
		mMT:ConnectVirtualFrameToDataText("Friends", self.friendsVirtualFrame)
	end

	friendsdDT = mMT:GetElvUIDataText("Friends")

	if friendsdDT and friendsdDT ~= "Data Broker" then friendsdDT.eventFunc(...) end

	local onlineFriends = C_FriendList_GetNumOnlineFriends()
	local _, numBNetOnline = BNGetNumFriends()

	self.mMT_Dock.TextA:SetText(onlineFriends + numBNetOnline)
	self.text:SetText("")
end

DT:RegisterDatatext(
	Config.name,
	Config.category,
	{ "BN_FRIEND_ACCOUNT_ONLINE", "BN_FRIEND_ACCOUNT_OFFLINE", "BN_FRIEND_INFO_CHANGED", "FRIENDLIST_UPDATE", "CHAT_MSG_SYSTEM", "MODIFIER_STATE_CHANGED" },
	OnEvent,
	nil,
	Click,
	OnEnter,
	OnLeave,
	Config.localizedName,
	nil
)
