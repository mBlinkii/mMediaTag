local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("MailHelper", { "AceEvent-3.0" })
local S = E:GetModule("Skins")

local _G = _G
local format, ipairs, pairs, sort, strlower, tconcat, tinsert, tremove, wipe = format, ipairs, pairs, sort, strlower, table.concat, tinsert, tremove, wipe
local hooksecurefunc = hooksecurefunc

local TAKE_DELAY = 0.15
local MAX_TAKES = 200
local EXPIRE_DAYS = 3
local MAX_RECENT = 10
local MENU_HEIGHT = 400
-- Blizzard only refreshes an overflowing inbox below this size
local MAX_INBOX_SIZE = 100

local session
local snapshot, current = {}, {}
local snapshotMoney = 0
local pendingRecipient
local classTokens

local function FreeBagSlots()
	return _G.C_Container.CalculateTotalNumberOfFreeBagSlots()
end

local function IsBlocked(cod, isGM)
	return isGM or (cod and cod > 0)
end

local function FindMoneyMail()
	for index = 1, _G.GetInboxNumItems() do
		local _, _, _, _, money, cod, _, _, _, _, _, _, isGM = _G.GetInboxHeaderInfo(index)
		if money and money > 0 and not IsBlocked(cod, isGM) then return index end
	end
end

local function TakeSnapshot(target)
	wipe(target)
	local money = 0

	for index = 1, _G.GetInboxNumItems() do
		local _, _, _, _, mailMoney, cod, _, itemCount, _, _, _, _, isGM = _G.GetInboxHeaderInfo(index)
		if not IsBlocked(cod, isGM) then
			money = money + (mailMoney or 0)

			if itemCount and itemCount > 0 then
				for attachment = 1, _G.ATTACHMENTS_MAX_RECEIVE do
					local name, _, _, count = _G.GetInboxItem(index, attachment)
					if name then
						local link = _G.GetInboxItemLink(index, attachment) or name
						target[link] = (target[link] or 0) + (count or 1)
					end
				end
			end
		end
	end

	return money
end

-- takes are async and GetMoney lags behind, so diff the inbox on every update instead of trusting the take calls
local function TrackTakenItems()
	local money = TakeSnapshot(current)
	if snapshotMoney > money then session.money = session.money + snapshotMoney - money end
	snapshotMoney = money

	for link, count in pairs(snapshot) do
		local diff = count - (current[link] or 0)
		if diff > 0 then session.items[link] = (session.items[link] or 0) + diff end
	end

	snapshot, current = current, snapshot
end

local function UpdateOverview()
	local text = module.overview
	if not text then return end

	if not module.db.overview then
		text:Hide()
		return
	end

	local numItems, totalItems = _G.GetInboxNumItems()
	local money, expiring = 0, 0

	for index = 1, numItems do
		local _, _, _, _, mailMoney, cod, daysLeft, _, _, _, _, _, isGM = _G.GetInboxHeaderInfo(index)
		if mailMoney and not IsBlocked(cod, isGM) then money = money + mailMoney end
		if daysLeft and daysLeft < EXPIRE_DAYS then expiring = expiring + 1 end
	end

	local mails = totalItems > numItems and format("%d/%s", numItems, MEDIA.color.red:WrapTextInColorCode(totalItems)) or numItems
	local line = format(L["%s Mails"], mails)
	if money > 0 then line = line .. "  " .. E:FormatMoney(money, "BLIZZARD", false) end
	if expiring > 0 then line = line .. "  " .. MEDIA.color.red:WrapTextInColorCode(format(L["%d expiring"], expiring)) end
	if session and session.waiting then line = line .. "  " .. L["Waiting for more mail"] end

	text:SetText(line)
	text:Show()
end

local function UpdateGoldButton()
	local button = module.goldButton
	if not button then return end

	button:SetShown(module.db.gold_button)

	if session and (session.mode == "gold" or session.waiting) then
		button:SetText(_G.CANCEL)
		button:Enable()
	else
		button:SetText(L["Take Gold"])
		button:SetEnabled(not session and FindMoneyMail() ~= nil)
	end
end

local function PrintSummary(finished)
	local parts = {}

	if finished.money > 0 then parts[#parts + 1] = E:FormatMoney(finished.money, "BLIZZARD", false) end

	for link, count in pairs(finished.items) do
		parts[#parts + 1] = count > 1 and format("%sx%d", link, count) or link
	end

	if #parts > 0 then mMT:Print(L["Mailbox:"], tconcat(parts, ", ")) end
end

local function FinishSession()
	if not session then return end

	if _G.MailFrame:IsShown() then TrackTakenItems() end
	module.goldButton:SetScript("OnUpdate", nil)

	local finished = session
	session = nil

	if module.db.summary then PrintSummary(finished) end
	UpdateGoldButton()
	UpdateOverview()
end

local function StartSession(mode)
	session = { mode = mode, money = 0, items = {}, takes = 0 }
	snapshotMoney = TakeSnapshot(snapshot)
	UpdateGoldButton()
end

-- an overflowing inbox is refreshed by Blizzard, wait for it and go on
local function PassDone()
	local numItems, totalItems = _G.GetInboxNumItems()

	if module.db.continue and totalItems > numItems and numItems < MAX_INBOX_SIZE then
		session.waiting = numItems
		UpdateGoldButton()
		UpdateOverview()
	else
		FinishSession()
	end
end

local function GoldOnUpdate(self, elapsed)
	self.delay = self.delay - elapsed
	if self.delay > 0 then return end

	self.delay = TAKE_DELAY
	if _G.C_Mail.IsCommandPending() then return end

	local index = FindMoneyMail()
	if index and session.takes < MAX_TAKES then
		session.takes = session.takes + 1
		_G.TakeInboxMoney(index)
	else
		self:SetScript("OnUpdate", nil)
		PassDone()
	end
end

local function StartGold()
	session.waiting = nil
	module.goldButton.delay = 0
	module.goldButton:SetScript("OnUpdate", GoldOnUpdate)
	UpdateGoldButton()
end

local function OnGoldClick()
	if session then
		FinishSession()
	else
		StartSession("gold")
		StartGold()
	end
end

local function OnBlizzardStop()
	if not session or session.mode ~= "all" or session.waiting then return end

	if _G.OpenAllMail:IsVisible() and FreeBagSlots() > 0 then
		PassDone()
	else
		FinishSession()
	end
end

local function OnBlizzardStart()
	if not (module.db and module.db.enable) then return end

	if not session then
		StartSession("all")
	else
		module.goldButton:SetScript("OnUpdate", nil)
		session.mode = "all"
		session.waiting = nil
		UpdateGoldButton()
	end

	-- StartOpening stops right away when there is nothing to open, before this hook runs
	if _G.OpenAllMail:IsEnabled() then OnBlizzardStop() end
end

local function Resume()
	if session.mode == "gold" then
		StartGold()
	elseif _G.OpenAllMail:IsVisible() and FreeBagSlots() > 0 then
		_G.OpenAllMail:Click()
	else
		FinishSession()
	end
end

function module:MAIL_INBOX_UPDATE()
	if session then
		TrackTakenItems()
		if session.waiting and _G.GetInboxNumItems() > session.waiting then Resume() end
	end

	UpdateGoldButton()
	UpdateOverview()
end

function module:MAIL_FAILED()
	if session and session.mode == "gold" then FinishSession() end
end

function module:MAIL_CLOSED()
	FinishSession()
end

local function GetMailDB()
	DB.mail_helper = DB.mail_helper or {}
	DB.mail_helper.alts = DB.mail_helper.alts or {}
	DB.mail_helper.recent = DB.mail_helper.recent or {}
	return DB.mail_helper
end

local function FullName(name)
	if not name or name == "" then return end
	if not name:find("-", 1, true) then name = name .. "-" .. _G.GetNormalizedRealmName() end
	return name
end

local function ConnectedRealms()
	local realms = { [strlower(_G.GetNormalizedRealmName())] = true }
	for _, realm in ipairs(_G.C_AutoComplete.GetAutoCompleteRealms() or {}) do
		realms[strlower(realm)] = true
	end
	return realms
end

local function IsReachable(name, realms)
	return name ~= FullName(E.myname) and realms[strlower(name:match("%-(.+)$"))]
end

-- friends only come with the localized class name
local function GetClassToken(className)
	if not classTokens then
		classTokens = {}
		for token, localized in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
			classTokens[localized] = token
		end
		for token, localized in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
			classTokens[localized] = token
		end
	end
	return className and classTokens[className]
end

local function ColorName(name, class, online)
	local short = _G.Ambiguate(name, "mail")
	if online == false then return _G.DISABLED_FONT_COLOR:WrapTextInColorCode(short) end

	local color = E:ClassColor(class)
	return color and color:WrapTextInColorCode(short) or short
end

local function RegisterCharacter()
	if not _G.GetNormalizedRealmName() then return end
	GetMailDB().alts[FullName(E.myname)] = { class = E.myclass, faction = E.myfaction }
end

local function AddRecent(name)
	local recent = GetMailDB().recent
	for i = #recent, 1, -1 do
		if strlower(recent[i]) == strlower(name) then tremove(recent, i) end
	end

	tinsert(recent, 1, name)
	recent[MAX_RECENT + 1] = nil
end

local function SetRecipient(name)
	_G.SendMailNameEditBox:SetText(_G.Ambiguate(name, "mail"))
	_G.SendMailSubjectEditBox:SetFocus()
end

local function SortByName(a, b)
	return a.name < b.name
end

local function AddGroup(root, title, entries)
	local group = root:CreateButton(title)
	group:SetScrollMode(MENU_HEIGHT)

	for _, entry in ipairs(entries) do
		group:CreateButton(ColorName(entry.name, entry.class, entry.online), SetRecipient, entry.name)
	end

	if #entries == 0 then group:SetEnabled(false) end
end

local function BuildRecipientMenu(_, root)
	local realms = ConnectedRealms()

	local entries = {}
	for name, info in pairs(GetMailDB().alts) do
		if info.faction == E.myfaction and IsReachable(name, realms) then tinsert(entries, { name = name, class = info.class }) end
	end
	sort(entries, SortByName)
	AddGroup(root, L["Alts"], entries)

	entries = {}
	for i = 1, _G.C_FriendList.GetNumFriends() do
		local info = _G.C_FriendList.GetFriendInfoByIndex(i)
		local name = info and FullName(info.name)
		if name and IsReachable(name, realms) then tinsert(entries, { name = name, class = GetClassToken(info.className), online = info.connected }) end
	end
	AddGroup(root, _G.FRIENDS, entries)

	entries = {}
	if _G.IsInGuild() then
		for i = 1, _G.GetNumGuildMembers() do
			local name, _, _, _, _, _, _, _, online, _, class = _G.GetGuildRosterInfo(i)
			name = FullName(name)
			if name and IsReachable(name, realms) then tinsert(entries, { name = name, class = class, online = online }) end
		end
		sort(entries, SortByName)
	end
	AddGroup(root, _G.GUILD, entries)

	entries = {}
	for _, name in ipairs(GetMailDB().recent) do
		if IsReachable(name, realms) then tinsert(entries, { name = name }) end
	end
	AddGroup(root, L["Recently Mailed"], entries)
end

local function OnRecipientClick(self)
	_G.MenuUtil.CreateContextMenu(self, BuildRecipientMenu)
end

function module:MAIL_SEND_SUCCESS()
	if pendingRecipient then AddRecent(pendingRecipient) end
	pendingRecipient = nil
end

local function CreateElements()
	if module.goldButton then return end

	local inbox = _G.InboxFrame

	local button = CreateFrame("Button", "mMT_MailHelperGoldButton", inbox, "UIPanelButtonTemplate")
	button:SetSize(90, 20)
	button:SetPoint("BOTTOMRIGHT", _G.MailItem1, "TOPRIGHT", 0, 4)
	button:SetScript("OnClick", OnGoldClick)
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.mail then S:HandleButton(button, true) end
	module.goldButton = button

	local text = inbox:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, 12)
	text:SetPoint("LEFT", _G.MailItem1, "TOPLEFT", 4, 14)
	text:SetPoint("RIGHT", button, "LEFT", -6, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	module.overview = text

	local recipient = CreateFrame("Button", nil, _G.SendMailFrame)
	recipient:SetSize(18, 18)
	recipient:SetPoint("LEFT", _G.SendMailNameEditBox, "RIGHT", 4, 0)
	S:HandleNextPrevButton(recipient, "down")
	recipient:SetScript("OnClick", OnRecipientClick)
	module.recipientButton = recipient

	hooksecurefunc("SendMail", function(name)
		if module.db and module.db.enable and module.db.recipient_list then pendingRecipient = FullName(name) end
	end)

	hooksecurefunc(_G.OpenAllMail, "StartOpening", OnBlizzardStart)
	hooksecurefunc(_G.OpenAllMail, "StopOpening", OnBlizzardStop)

	-- the overview shows the overflow and would overlap the warning
	_G.InboxTooMuchMail:HookScript("OnShow", function(self)
		if module.db and module.db.enable and module.db.overview then self:Hide() end
	end)
end

function module:Initialize()
	module.db = E.db.mMediaTag.mail_helper

	if not module.db or not module.db.enable then
		FinishSession()
		module:UnregisterAllEvents()
		if module.goldButton then
			module.goldButton:Hide()
			module.overview:Hide()
			module.recipientButton:Hide()
		end
		return
	end

	CreateElements()

	module:RegisterEvent("MAIL_INBOX_UPDATE")
	module:RegisterEvent("MAIL_FAILED")
	module:RegisterEvent("MAIL_CLOSED")
	module:RegisterEvent("MAIL_SEND_SUCCESS")

	RegisterCharacter()
	module.recipientButton:SetShown(module.db.recipient_list)
	UpdateGoldButton()
	UpdateOverview()
end
