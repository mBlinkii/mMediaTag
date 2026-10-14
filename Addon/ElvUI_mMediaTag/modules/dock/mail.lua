local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock
local mailDT = nil
local GetTime = GetTime
local PlayerHasToy = PlayerHasToy
local IsToyUsable = C_ToyBox.IsToyUsable
local GetToyInfo = C_ToyBox.GetToyInfo
local GetItemCooldown = C_Container.GetItemCooldown
local tinsert = tinsert

-- MOLL-E, Katy's Stampwhistle, Ohuna Perch, Radiant Lynx Whistle, Interdimensional Parcel Signal
local mailboxToys = { 40768, 156833, 194885, 239693, 264695 }

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

local function GetOwnedToys()
	local owned = {}
	for _, toyID in ipairs(mailboxToys) do
		if PlayerHasToy(toyID) and IsToyUsable(toyID) then tinsert(owned, toyID) end
	end
	return owned
end

local function GetRemainingCooldown(toyID)
	local start, duration = GetItemCooldown(toyID)
	if not start or not duration or E:IsSecretValue(start) or E:IsSecretValue(duration) then return end
	return start + duration - GetTime()
end

local function GetCooldownText(toyID)
	local remaining = GetRemainingCooldown(toyID)
	if not remaining then return "" end
	if remaining >= 2 then return mMT:TC(SecondsToTime(remaining, true), "red") end
	return mMT:TC(L["Ready"], "green")
end

local function OnEnterToy(btn)
	GameTooltip:SetOwner(btn, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:SetToyByItemID(btn.tooltip)
	GameTooltip:Show()
end

local function OnLeaveToy()
	GameTooltip:Hide()
end

local function CreateMenuEntry(toyID)
	local _, name, icon = GetToyInfo(toyID)
	if not name then return end

	return {
		text = name,
		right_text = GetCooldownText(toyID),
		icon = icon,
		icon_size = 14,
		tooltip = toyID,
		attributes = { type = "toy", toy = toyID },
		funcOnEnter = OnEnterToy,
		funcOnLeave = OnLeaveToy,
	}
end

-- toys on cooldown are only picked if none is ready
local function GetRandomToy(owned)
	local ready = {}
	for _, toyID in ipairs(owned) do
		local remaining = GetRemainingCooldown(toyID)
		if not remaining or remaining < 2 then tinsert(ready, toyID) end
	end

	local pool = ready[1] and ready or owned
	return pool[random(#pool)]
end

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMediaTag.dock.tooltip then
		if mailDT then mailDT.onEnter() end

		local owned = GetOwnedToys()
		if owned[1] then
			if DT.tooltip:NumLines() == 0 then DT.tooltip:AddLine(MAIL_LABEL, 1, 1, 1) end
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(L["Toys"], mMT:GetRGB("title"))
			for _, toyID in ipairs(owned) do
				local _, name, icon = GetToyInfo(toyID)
				if name then DT.tooltip:AddDoubleLine(E:TextureString(icon, ":14:14") .. " " .. mMT:TC(name), GetCooldownText(toyID)) end
			end
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(MEDIA.leftClick .. " " .. L["left click to open the menu."], mMT:GetRGB("tip"))
			DT.tooltip:Show()
		end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMediaTag.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if E:AlertCombat() then return end

	local owned = GetOwnedToys()
	if not owned[1] then return end

	local menu = {}
	local randomEntry = CreateMenuEntry(GetRandomToy(owned))
	if randomEntry then
		tinsert(menu, { text = mMT:TC(L["Random"], "title"), isTitle = true, notClickable = true })
		tinsert(menu, randomEntry)
		tinsert(menu, { text = "", isTitle = true, notClickable = true })
	end

	tinsert(menu, { text = mMT:TC(L["Toys"], "title"), isTitle = true, notClickable = true })
	for _, toyID in ipairs(owned) do
		local entry = CreateMenuEntry(toyID)
		if entry then tinsert(menu, entry) end
	end

	if not mMT.menu then mMT:BuildMenus() end
	mMT:DropDown(menu, mMT.menu, self, 260, 2)
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		config.icon.texture = icons[E.db.mMediaTag.dock.mail.style][E.db.mMediaTag.dock.mail.icon] or MEDIA.fallback
		config.icon.color = E.db.mMediaTag.dock.mail.custom_color and MEDIA.color.dock.mail or nil

		Dock:CreateDockIcon(self, config, event)

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

DT:RegisterDatatext(config.name, config.category, { "MAIL_INBOX_UPDATE", "UPDATE_PENDING_MAIL", "MAIL_CLOSED", "MAIL_SHOW" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
