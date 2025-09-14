local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local friendsDT = nil
local BNGetNumFriends = BNGetNumFriends
local GetNumOnlineFriends = C_FriendList.GetNumOnlineFriends

local config = {
	name = "mMT_Dock_Friends",
	localizedName = "|CFF01EEFFDock|r" .. " " .. L["Friends"],
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
		if friendsDT then friendsDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	local showGold = E.db.mMT.dock.bags.gold
	friendsDT = mMT:GetElvUIDataText("Friends")
	if friendsDT then friendsDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.friends.style][E.db.mMT.dock.friends.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.friends.custom_color and MEDIA.color.dock.friends or nil
		config.text.enable = E.db.mMT.dock.friends.text
		config.text.a = E.db.mMT.dock.friends.text

		Dock:CreateDockIcon(self, config, event)

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

		friendsDT = mMT:GetElvUIDataText("Friends")
	end

	if friendsDT and friendsDT ~= "Data Broker" then friendsDT.eventFunc(...) end

	if E.db.mMT.dock.friends.text then
		local onlineFriends = GetNumOnlineFriends()
		local _, onlineBNFriends = BNGetNumFriends()
		self.mMT_Dock.TextA:SetText(onlineFriends + onlineBNFriends)
	end

	self.text:SetText("")
end

DT:RegisterDatatext( config.name, config.category, { "BN_FRIEND_ACCOUNT_ONLINE", "BN_FRIEND_ACCOUNT_OFFLINE", "BN_FRIEND_INFO_CHANGED", "FRIENDLIST_UPDATE", "CHAT_MSG_SYSTEM", "MODIFIER_STATE_CHANGED" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
