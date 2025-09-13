local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local bagsDT = nil
local GetMoney = GetMoney
local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container.GetContainerNumSlots

local config = {
	name = "mMT_Dock_Bags",
	localizedName = "|CFF01EEFFDock|r" .. " " .. L["Bags"],
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
		b = false, -- second label
	},
}

local function GetBagSlots()
	local freeSlots, usedSlots, totalSlots = 0, 0, 0

	for bag = 0, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(bag)
		if slots and slots > 0 then
			local free = GetContainerNumFreeSlots(bag)
			freeSlots = freeSlots + free
			usedSlots = usedSlots + (slots - free)
			totalSlots = totalSlots + slots
		end
	end

	return freeSlots, usedSlots, totalSlots
end

local function GetGold()
	local money = GetMoney()
	return E:FormatMoney(money, "SHORTINT", false)
end

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMT.dock.tooltip then
		if bagsDT then bagsDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	local showGold = E.db.mMT.dock.bags.gold
	bagsDT = mMT:GetElvUIDataText(showGold and "Gold" or "Bags")
	if bagsDT then bagsDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...
	local textStyle = E.db.mMT.dock.bags.text
	local showGold = E.db.mMT.dock.bags.gold

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.bags.style][E.db.mMT.dock.bags.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.bags.custom_color and MEDIA.color.dock.bags or nil
		config.text.enable = textStyle ~= "none"

		if textStyle ~= "none" then
			config.text.a = true
			config.text.b = (textStyle == "both")
		end

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.bagsVirtualFrame then
			self.bagsVirtualFrame = {
				name = showGold and "Gold" or "Bags",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText(showGold and "Gold" or "Bags", self.bagsVirtualFrame)
		end

		bagsDT = mMT:GetElvUIDataText(showGold and "Gold" or "Bags")
	end

	if bagsDT and bagsDT ~= "Data Broker" then bagsDT.eventFunc(...) end

	if textStyle ~= "none" then
		local myGold, freeSlots, usedSlots, totalSlots

		if textStyle == "money" or textStyle == "both" then myGold = GetGold() end

		if textStyle == "both" or textStyle == "total" or textStyle == "used" or textStyle == "free" then
			freeSlots, usedSlots, totalSlots = GetBagSlots()
		end

		if textStyle == "money" and self.mMT_Dock.TextA then
			self.mMT_Dock.TextA:SetText(myGold)
		elseif textStyle == "both" and self.mMT_Dock.TextA and self.mMT_Dock.TextB then
			self.mMT_Dock.TextA:SetText(myGold)
			self.mMT_Dock.TextB:SetText(freeSlots)
		elseif textStyle == "total" and self.mMT_Dock.TextA then
			self.mMT_Dock.TextA:SetText(usedSlots .. "/" .. totalSlots)
		elseif textStyle == "used" and self.mMT_Dock.TextA then
			self.mMT_Dock.TextA:SetText(usedSlots)
		elseif textStyle == "free" and self.mMT_Dock.TextA then
			self.mMT_Dock.TextA:SetText(freeSlots)
		end
	end

	self.text:SetText("")
end

DT:RegisterDatatext( config.name, config.category, { "BAG_UPDATE", "PLAYER_MONEY", "SEND_MAIL_MONEY_CHANGED", "SEND_MAIL_COD_CHANGED", "PLAYER_TRADE_MONEY", "TRADE_MONEY_CHANGED" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
