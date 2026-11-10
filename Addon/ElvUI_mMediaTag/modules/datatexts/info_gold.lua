local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local S = E:GetModule("Skins")

local module = mMT:AddModule("Gold")

local _G = _G
local ceil, date, floor, format, ipairs, max, min, pairs, pcall, sort, time, tinsert = ceil, date, floor, format, ipairs, max, min, pairs, pcall, sort, time, tinsert
local CreateFrame = CreateFrame
local GetMoney = GetMoney
local GetTime = GetTime
local IsShiftKeyDown = IsShiftKeyDown
local strjoin, wipe = strjoin, wipe

local DT_NAME = "mMT - Gold"
local KEEP_DAYS = 400
local COLOR_GAIN, COLOR_LOSS, COLOR_MUTED = "|cff73d1a6", "|cfff07d75", "|cff8f99a8"

local SOURCES = {
	{ id = "mail", label = L["Mail"] },
	{ id = "loot", label = L["Loot"] },
	{ id = "vendor_sale", label = L["Vendor sales"] },
	{ id = "vendor_purchase", label = L["Purchases & repairs"] },
	{ id = "trade", label = L["Trade"] },
	{ id = "bank", label = L["Bank"] },
	{ id = "auction", label = L["Auction House"] },
	{ id = "quest", label = L["Quests"] },
	{ id = "unknown", label = L["Unknown"] },
}

local SOURCE_EVENTS = {
	MAIL_SHOW = { "mail", true },
	MAIL_CLOSED = { "mail", false },
	LOOT_OPENED = { "loot", true },
	LOOT_CLOSED = { "loot", false },
	MERCHANT_SHOW = { "merchant", true },
	MERCHANT_CLOSED = { "merchant", false },
	TRADE_SHOW = { "trade", true },
	TRADE_CLOSED = { "trade", false },
	BANKFRAME_OPENED = { "bank", true },
	BANKFRAME_CLOSED = { "bank", false },
	AUCTION_HOUSE_SHOW = { "auction", true },
	AUCTION_HOUSE_CLOSED = { "auction", false },
	QUEST_COMPLETE = { "quest", true },
	QUEST_FINISHED = { "quest", false },
}

module.TEXT_VALUES = { "profit_today", "income_today", "gold", "account", "daily_goal", "goal" }

local eventFrame = CreateFrame("Frame")
local activeSources = {}
local baseline, character, lastPlayTime

-- day keys are cached per offset until midnight
local dayKeys, dayExpires = {}, 0

local function DayKey(offset)
	offset = offset or 0
	local stamp = time()
	if stamp < dayExpires and dayKeys[offset] then return dayKeys[offset] end

	local now = date("*t", stamp)
	if stamp >= dayExpires then
		wipe(dayKeys)
		dayExpires = time({ year = now.year, month = now.month, day = now.day + 1, hour = 0 })
	end

	local key = date("%Y-%m-%d", time({ year = now.year, month = now.month, day = now.day + offset, hour = 12 }))
	dayKeys[offset] = key
	return key
end

local function WeekStart()
	return DayKey(-((date("*t").wday + 5) % 7))
end

local function Money(amount, signed)
	local db = E.db.mMediaTag.datatexts.gold
	local text = E:FormatMoney(amount, db.style, not db.coins)
	if not signed or amount == 0 then return amount < 0 and "-" .. text or text end
	return amount > 0 and COLOR_GAIN .. "+" .. text .. "|r" or COLOR_LOSS .. "-" .. text .. "|r"
end

local function Data()
	return DB.gold
end

local function Today(char)
	local key = DayKey()
	local day = char.days[key]
	if not day then
		day = { income = 0, expenses = 0, sources = {} }
		char.days[key] = day

		local oldest = DayKey(-KEEP_DAYS)
		for dayKey in pairs(char.days) do
			if dayKey < oldest then char.days[dayKey] = nil end
		end
	end
	return day, key
end

local function Sum(char, first, last)
	local income, expenses = 0, 0
	for key, day in pairs(char.days) do
		if key >= first and key <= last then
			income, expenses = income + day.income, expenses + day.expenses
		end
	end
	return income, expenses
end

local function AccountTotal()
	local data = Data()
	local total = data.warband or 0
	for _, char in pairs(data.characters) do
		total = total + char.money
	end
	return total
end

local function AccountProfitToday()
	local key, profit = DayKey(), 0
	for _, char in pairs(Data().characters) do
		local day = char.days[key]
		if day then profit = profit + day.income - day.expenses end
	end
	return profit
end

-- goals are entered in gold, progress values are copper
local function GoalProgress(kind)
	local goal = (Data().goals[kind] or 0) * 10000
	if goal <= 0 then return end

	local account = E.db.mMediaTag.datatexts.gold.goal_reference == "account"
	local current
	if kind == "daily" then
		local day = Today(character)
		current = account and AccountProfitToday() or day.income - day.expenses
	else
		current = account and AccountTotal() or GetMoney()
	end
	return current, goal, floor(min(100, current * 100 / goal))
end

local function ClassifySource(change)
	local found
	for context in pairs(activeSources) do
		if found then return "unknown" end
		found = context
	end
	if found == "merchant" then return change > 0 and "vendor_sale" or "vendor_purchase" end
	if (found == "loot" or found == "quest") and change < 0 then return "unknown" end
	return found or "unknown"
end

local function UpdateWarband()
	if not E.Retail then return end
	local ok, money = pcall(C_Bank.FetchDepositedMoney, Enum.BankType.Account)
	if ok and money then Data().warband = money end
end

local function CheckGoals()
	local goals = Data().goals
	local current, goal = GoalProgress("daily")
	local key = DayKey()
	if current and current >= goal and goals.daily_reached ~= key then
		goals.daily_reached = key
		mMT:Print(format(L["Daily gold goal reached: %s"], Money(goal)))
	end

	current, goal = GoalProgress("target")
	if current and current >= goal and not goals.target_reached then
		goals.target_reached = true
		mMT:Print(format(L["Gold goal reached: %s"], Money(goal)))
	end
end

local function UpdateCharacter()
	local data = Data()
	local key = E.mynameRealm
	character = data.characters[key] or { days = {} }
	data.characters[key] = character
	character.name, character.realm, character.class, character.money = E.myname, E.myrealm, E.myclass, GetMoney()
end

-- online time per day, the base for gold per hour in the history
local function AddPlayTime()
	local now = GetTime()
	if lastPlayTime and now > lastPlayTime then
		local day = Today(character)
		day.time = (day.time or 0) + now - lastPlayTime
	end
	lastPlayTime = now
end

local function RecordMoney()
	AddPlayTime()
	local money = GetMoney()
	local change = baseline and money - baseline or 0
	baseline = money
	character.money = money
	if change == 0 then return end

	local day = Today(character)
	local source = ClassifySource(change)
	local bucket = day.sources[source] or { income = 0, expenses = 0 }
	day.sources[source] = bucket
	if change > 0 then
		day.income, bucket.income = day.income + change, bucket.income + change
	else
		day.expenses, bucket.expenses = day.expenses - change, bucket.expenses - change
	end
	CheckGoals()
end

local function OnTrackerEvent(_, event)
	if SOURCE_EVENTS[event] then
		local context = SOURCE_EVENTS[event]
		activeSources[context[1]] = context[2] or nil
		return
	end

	if event == "PLAYER_ENTERING_WORLD" then
		UpdateCharacter()
		baseline = GetMoney()
		wipe(activeSources)
		UpdateWarband()
	elseif event == "PLAYER_MONEY" then
		RecordMoney()
	elseif event == "ACCOUNT_MONEY" then
		UpdateWarband()
	elseif event == "PLAYER_LOGOUT" then
		AddPlayTime()
		return
	end
	DT:ForceUpdate_DataText(DT_NAME)
	if module.history and module.history:IsShown() then module:RefreshHistory() end
end

local TEXTS = {
	profit_today = function()
		local day = Today(character)
		return L["Today"], Money(day.income - day.expenses, true)
	end,
	income_today = function()
		return L["Income"], Money(Today(character).income)
	end,
	gold = function()
		return L["Gold"], Money(GetMoney())
	end,
	account = function()
		return L["Account"], Money(AccountTotal())
	end,
	daily_goal = function()
		local _, _, percent = GoalProgress("daily")
		return L["Daily goal"], percent and percent .. "%" or "-"
	end,
	goal = function()
		local _, _, percent = GoalProgress("target")
		return L["Goal"], percent and percent .. "%" or "-"
	end,
}

local function OnEvent(self)
	-- ElvUI fills its panels before mMT:Initialize has merged MMTDATA
	if not module.initialized then return self.text:SetText(L["Gold"]) end
	local db = E.db.mMediaTag.datatexts.gold
	local label, value = (TEXTS[db.text] or TEXTS.profit_today)()
	if db.label then
		self.text:SetFormattedText("%s %s", format(self.mMT_textString or "%s", label .. ":"), format(self.mMT_valueString or "%s", value))
	else
		self.text:SetText(format(self.mMT_valueString or "%s", value))
	end
end

local ACTIONS = {
	bags = function()
		_G.ToggleAllBags()
	end,
	options = function()
		E:ToggleOptions("mMT,datatexts,info,info_gold")
	end,
	history = function()
		module:ToggleHistory()
	end,
	cycle = function()
		local db = E.db.mMediaTag.datatexts.gold
		for i, value in ipairs(module.TEXT_VALUES) do
			if value == db.text then
				db.text = module.TEXT_VALUES[i % #module.TEXT_VALUES + 1]
				break
			end
		end
		DT:ForceUpdate_DataText(DT_NAME)
	end,
}

module.ACTION_LABELS = {
	none = L["None"],
	bags = L["Bags"],
	options = L["Settings"],
	cycle = L["Next display value"],
	history = L["Day history"],
}

local function OnClick(_, button)
	local db = E.db.mMediaTag.datatexts.gold
	local action = button == "RightButton" and db.right_click or db.left_click
	if IsShiftKeyDown() then action = db.shift_click end
	if ACTIONS[action] then ACTIONS[action]() end
end

local function Line(left, right, r, g, b)
	DT.tooltip:AddDoubleLine(left, right, r or 1, g or 1, b or 1, 1, 1, 1)
end

local function Section(title)
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(title, 0.91, 0.77, 0.47)
end

local function GoalLine(label, kind)
	local current, goal, percent = GoalProgress(kind)
	if not current then return end
	Line(label, format("%s / %s  (%d%%)", Money(current), Money(goal), percent))
end

local function OnEnter(self)
	if not module.initialized then return end
	local db = E.db.mMediaTag.datatexts.gold
	local day, todayKey = Today(character)

	DT.tooltip:ClearLines()
	DT.tooltip:AddLine(mMT.NameShort .. " " .. L["Gold"])

	Section(L["Today"])
	Line(L["Income"], Money(day.income))
	Line(L["Expenses"], Money(day.expenses))
	Line(L["Profit"], Money(day.income - day.expenses, true))

	if db.tooltip_sources then
		local rows = {}
		for _, source in ipairs(SOURCES) do
			local bucket = day.sources[source.id]
			if bucket then tinsert(rows, { label = source.label, income = bucket.income, expenses = bucket.expenses }) end
		end
		if #rows > 0 then
			sort(rows, function(a, b)
				return a.income + a.expenses > b.income + b.expenses
			end)
			Section(L["Sources today"])
			for _, row in ipairs(rows) do
				Line(row.label, (row.income > 0 and Money(row.income, true) or "") .. (row.expenses > 0 and "  " .. Money(-row.expenses, true) or ""), 0.8, 0.82, 0.86)
			end
		end
	end

	if db.tooltip_periods then
		Section(L["Profit"])
		local yesterday = DayKey(-1)
		local income, expenses = Sum(character, yesterday, yesterday)
		Line(L["Yesterday"], Money(income - expenses, true))
		income, expenses = Sum(character, WeekStart(), todayKey)
		Line(L["This week"], Money(income - expenses, true))
		income, expenses = Sum(character, todayKey:sub(1, 8) .. "01", todayKey)
		Line(L["This month"], Money(income - expenses, true))
	end

	local goals = Data().goals
	if (goals.daily or 0) > 0 or (goals.target or 0) > 0 then
		Section(L["Goals"] .. "  " .. COLOR_MUTED .. (db.goal_reference == "account" and L["Account"] or _G.CHARACTER) .. "|r")
		GoalLine(L["Daily goal"], "daily")
		GoalLine(L["Goal"], "target")
	end

	if db.tooltip_characters then
		Section(L["Characters"])
		local list = {}
		for _, char in pairs(Data().characters) do
			tinsert(list, char)
		end
		sort(list, function(a, b)
			return a.money > b.money
		end)
		for _, char in ipairs(list) do
			local color = E:ClassColor(char.class) or { r = 1, g = 1, b = 1 }
			local name = char.realm == E.myrealm and char.name or char.name .. " - " .. char.realm
			Line(name, Money(char.money), color.r, color.g, color.b)
		end
		if Data().warband then Line(L["Warband"], Money(Data().warband)) end
		Line(L["Total"], Money(AccountTotal()), 0.91, 0.77, 0.47)
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(L["Left Click"] .. ":", module.ACTION_LABELS[db.left_click], 0.6, 0.6, 0.6, 0.6, 0.6, 0.6)
	DT.tooltip:AddDoubleLine(L["Right Click"] .. ":", module.ACTION_LABELS[db.right_click], 0.6, 0.6, 0.6, 0.6, 0.6, 0.6)
	if db.shift_click ~= "none" then DT.tooltip:AddDoubleLine(L["Shift Click"] .. ":", module.ACTION_LABELS[db.shift_click], 0.6, 0.6, 0.6, 0.6, 0.6, 0.6) end
	DT.tooltip:Show()
end

local function ValueColorUpdate(self, hex)
	local db = E.db.mMediaTag.datatexts.gold
	local textHex, valueHex
	if db.color_mode == "class" then
		local color = E:ClassColor(E.myclass)
		textHex = E:RGBToHex(color.r, color.g, color.b)
		valueHex = textHex
	elseif db.color_mode == "custom" then
		textHex, valueHex = "|c" .. db.text_color, "|c" .. db.value_color
	else
		textHex, valueHex = mMT:GetDTColorHex(hex)
	end
	self.mMT_textString = strjoin("", textHex, "%s|r")
	self.mMT_valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

local HISTORY_ROWS, DETAIL_LINES, ROW_HEIGHT = 14, 20, 22
local GOLD_R, GOLD_G, GOLD_B = 0.91, 0.77, 0.47

local function DateText(key)
	local year, month, day = key:match("(%d+)-(%d+)-(%d+)")
	return format("%s.%s.%s", day, month, year)
end

local function DayLabel(key)
	if key == DayKey() then return DateText(key) .. "  " .. COLOR_MUTED .. L["Today"] .. "|r" end
	if key == DayKey(-1) then return DateText(key) .. "  " .. COLOR_MUTED .. L["Yesterday"] .. "|r" end
	return DateText(key)
end

local function PlayTimeText(seconds)
	seconds = floor(seconds or 0)
	return format("%d:%02d h", floor(seconds / 3600), floor(seconds % 3600 / 60))
end

local function CharacterName(char)
	return char.realm == E.myrealm and char.name or char.name .. " - " .. char.realm
end

-- the "all" view adds the days of every character together
local function HistoryDays(view)
	local data, today = Data(), DayKey()
	local chars = view == "all" and data.characters or { data.characters[view] }
	local byKey, list = {}, {}
	for _, char in pairs(chars) do
		for key, day in pairs(char.days) do
			if day.income > 0 or day.expenses > 0 or key == today then
				local entry = byKey[key]
				if not entry then
					entry = { key = key, income = 0, expenses = 0, time = 0, sources = {} }
					byKey[key] = entry
					tinsert(list, entry)
				end
				entry.income, entry.expenses, entry.time = entry.income + day.income, entry.expenses + day.expenses, entry.time + (day.time or 0)
				for id, bucket in pairs(day.sources) do
					local sum = entry.sources[id] or { income = 0, expenses = 0 }
					entry.sources[id] = sum
					sum.income, sum.expenses = sum.income + bucket.income, sum.expenses + bucket.expenses
				end
			end
		end
	end
	sort(list, function(a, b)
		return a.key > b.key
	end)
	return list
end

local function CreateText(parent, size, justify)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size or 12)
	text:SetJustifyH(justify or "LEFT")
	return text
end

local function CreateButton(parent, width, label)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(width, 22)
	button:SetText(label)
	S:HandleButton(button)
	return button
end

local MONTHS = {
	_G.FULLDATE_MONTH_JANUARY,
	_G.FULLDATE_MONTH_FEBRUARY,
	_G.FULLDATE_MONTH_MARCH,
	_G.FULLDATE_MONTH_APRIL,
	_G.FULLDATE_MONTH_MAY,
	_G.FULLDATE_MONTH_JUNE,
	_G.FULLDATE_MONTH_JULY,
	_G.FULLDATE_MONTH_AUGUST,
	_G.FULLDATE_MONTH_SEPTEMBER,
	_G.FULLDATE_MONTH_OCTOBER,
	_G.FULLDATE_MONTH_NOVEMBER,
	_G.FULLDATE_MONTH_DECEMBER,
}
local ICON_EXPANDED = E:TextureString(E.Media.Textures.MinusButton, ":14:14") .. " "
local ICON_COLLAPSED = E:TextureString(E.Media.Textures.PlusButton, ":14:14") .. " "

-- only the current month starts expanded
local function IsExpanded(frame, month)
	local expanded = frame.expanded[month]
	if expanded == nil then return month == DayKey():sub(1, 7) end
	return expanded
end

local function MonthText(month)
	local year, number = month:match("(%d+)-(%d+)")
	return format("%s %s", MONTHS[tonumber(number)] or number, year)
end

local function SelectView(view)
	local history = module.history
	history.view, history.page, history.selected = view, 1, nil
	module:RefreshHistory()
end

local function OpenCharacterMenu(button)
	if not mMT.menu then mMT:BuildMenus() end
	local menu = { {
		text = L["All characters"],
		func = function()
			SelectView("all")
		end,
	} }
	local list = {}
	for key, char in pairs(Data().characters) do
		tinsert(list, { key = key, char = char })
	end
	sort(list, function(a, b)
		return a.key < b.key
	end)
	for _, entry in ipairs(list) do
		local color = E:ClassColor(entry.char.class) or { r = 1, g = 1, b = 1 }
		tinsert(menu, {
			text = E:RGBToHex(color.r, color.g, color.b) .. CharacterName(entry.char) .. "|r",
			func = function()
				SelectView(entry.key)
			end,
		})
	end
	mMT:DropDown(menu, mMT.menu, button, 200, 2)
end

E.PopupDialogs.MMT_GOLD_DELETE_DAY = {
	text = L["Delete the gold data of %s?"],
	button1 = _G.YES,
	button2 = _G.NO,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self:SetFrameStrata("FULLSCREEN_DIALOG")
	end,
	OnHide = function(self)
		self:SetFrameStrata("DIALOG")
	end,
	OnAccept = function(_, key)
		module:DeleteDay(key)
	end,
}

local function CreateHistory()
	local frame = CreateFrame("Frame", "mMediaTag_GoldHistory", E.UIParent, "BackdropTemplate")
	frame:SetSize(580, 470)
	frame:SetPoint("CENTER")
	frame:SetTemplate("Transparent")
	frame:SetFrameStrata("HIGH")
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:Hide()
	tinsert(_G.UISpecialFrames, frame:GetName())
	frame.view, frame.page, frame.expanded = E.mynameRealm, 1, {}

	frame.title = CreateText(frame, 14)
	frame.title:SetPoint("TOPLEFT", 12, -12)
	frame.title:SetText(mMT.NameShort .. " " .. L["Day history"])

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	S:HandleCloseButton(close)

	frame.characterButton = CreateButton(frame, 200, "")
	frame.characterButton:SetPoint("TOPRIGHT", -32, -8)
	frame.characterButton:SetScript("OnClick", OpenCharacterMenu)

	local list = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	list:SetTemplate()
	list:SetPoint("TOPLEFT", 10, -40)
	list:SetSize(230, HISTORY_ROWS * ROW_HEIGHT + 8)

	frame.rows = {}
	for i = 1, HISTORY_ROWS do
		local row = CreateFrame("Button", nil, list)
		row:SetSize(222, ROW_HEIGHT)
		row:SetPoint("TOPLEFT", 4, -4 - (i - 1) * ROW_HEIGHT)
		row.selected = row:CreateTexture(nil, "BACKGROUND")
		row.selected:SetAllPoints()
		row.selected:SetColorTexture(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b, 0.35)
		row.highlight = row:CreateTexture(nil, "HIGHLIGHT")
		row.highlight:SetAllPoints()
		row.highlight:SetColorTexture(1, 1, 1, 0.08)
		row.date = CreateText(row)
		row.date:SetPoint("LEFT", 6, 0)
		row.value = CreateText(row, 12, "RIGHT")
		row.value:SetPoint("RIGHT", -6, 0)
		row:SetScript("OnClick", function(self)
			if self.month then
				frame.expanded[self.month] = not IsExpanded(frame, self.month)
			else
				frame.selected = self.key
			end
			module:RefreshHistory()
		end)
		frame.rows[i] = row
	end

	local prev = CreateFrame("Button", nil, frame)
	prev:SetSize(20, 20)
	prev:SetPoint("TOPLEFT", list, "BOTTOMLEFT", 0, -6)
	S:HandleNextPrevButton(prev, "left")
	prev:SetScript("OnClick", function()
		frame.page = max(1, frame.page - 1)
		module:RefreshHistory()
	end)

	local nextButton = CreateFrame("Button", nil, frame)
	nextButton:SetSize(20, 20)
	nextButton:SetPoint("TOPRIGHT", list, "BOTTOMRIGHT", 0, -6)
	S:HandleNextPrevButton(nextButton, "right")
	nextButton:SetScript("OnClick", function()
		frame.page = frame.page + 1
		module:RefreshHistory()
	end)
	frame.prev, frame.next = prev, nextButton

	frame.pageText = CreateText(frame, 12, "CENTER")
	frame.pageText:SetPoint("LEFT", prev, "RIGHT", 4, 0)
	frame.pageText:SetPoint("RIGHT", nextButton, "LEFT", -4, 0)

	local detail = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	detail:SetTemplate()
	detail:SetPoint("TOPLEFT", list, "TOPRIGHT", 8, 0)
	detail:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 100)

	frame.lines = {}
	for i = 1, DETAIL_LINES do
		local left = CreateText(detail)
		left:SetPoint("TOPLEFT", 10, -10 - (i - 1) * 16)
		local right = CreateText(detail, 12, "RIGHT")
		right:SetPoint("TOPRIGHT", -10, -10 - (i - 1) * 16)
		frame.lines[i] = { left = left, right = right }
	end

	frame.deleteButton = CreateButton(detail, 120, L["Delete day"])
	frame.deleteButton:SetPoint("BOTTOMRIGHT", -6, 6)
	frame.deleteButton:SetScript("OnClick", function()
		if frame.selected then E:StaticPopup_Show("MMT_GOLD_DELETE_DAY", DateText(frame.selected), nil, frame.selected) end
	end)

	local summary = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	summary:SetTemplate()
	summary:SetPoint("TOPLEFT", detail, "BOTTOMLEFT", 0, -8)
	summary:SetPoint("BOTTOMRIGHT", -10, 10)

	frame.summary = {}
	for i = 1, 4 do
		local left = CreateText(summary)
		left:SetPoint("TOPLEFT", 10, -8 - (i - 1) * 18)
		local right = CreateText(summary, 12, "RIGHT")
		right:SetPoint("TOPRIGHT", -10, -8 - (i - 1) * 18)
		frame.summary[i] = { left = left, right = right }
	end

	return frame
end

local function SetLine(lines, index, left, right, r, g, b)
	local line = lines[index]
	if not line then return index end
	line.left:SetText(left or "")
	line.left:SetTextColor(r or 0.8, g or 0.82, b or 0.86)
	line.right:SetText(right or "")
	return index + 1
end

function module:RefreshHistory()
	local frame = self.history
	local data = Data()
	if frame.view ~= "all" and not data.characters[frame.view] then frame.view = E.mynameRealm end

	local viewChar = data.characters[frame.view]
	frame.characterButton:SetText(frame.view == "all" and L["All characters"] or (viewChar and CharacterName(viewChar) or ""))

	local days = HistoryDays(frame.view)

	-- days are sorted newest first, so each month header comes right before its days
	local entries, header = {}, nil
	for _, day in ipairs(days) do
		local month = day.key:sub(1, 7)
		if not header or header.month ~= month then
			header = { month = month, income = 0, expenses = 0, count = 0 }
			tinsert(entries, header)
		end
		header.income, header.expenses, header.count = header.income + day.income, header.expenses + day.expenses, header.count + 1
		if IsExpanded(frame, month) then tinsert(entries, day) end
	end

	local pages = max(1, ceil(#entries / HISTORY_ROWS))
	frame.page = min(frame.page, pages)
	frame.pageText:SetFormattedText("%d / %d", frame.page, pages)
	frame.prev:SetEnabled(frame.page > 1)
	frame.next:SetEnabled(frame.page < pages)

	local selected
	for _, day in ipairs(days) do
		if day.key == frame.selected then selected = day end
	end
	if not selected then
		selected = days[1]
		frame.selected = selected and selected.key
	end

	local offset = (frame.page - 1) * HISTORY_ROWS
	for i, row in ipairs(frame.rows) do
		local entry = entries[offset + i]
		row.key, row.month = entry and entry.key, entry and entry.month
		row:SetShown(entry ~= nil)
		if entry and entry.month then
			row.date:SetPoint("LEFT", 6, 0)
			row.date:SetText(format("%s%s  %s(%d)|r", IsExpanded(frame, entry.month) and ICON_EXPANDED or ICON_COLLAPSED, MonthText(entry.month), COLOR_MUTED, entry.count))
			row.date:SetTextColor(GOLD_R, GOLD_G, GOLD_B)
			row.value:SetText(Money(entry.income - entry.expenses, true))
			row.selected:Hide()
		elseif entry then
			row.date:SetPoint("LEFT", 24, 0)
			row.date:SetText(DayLabel(entry.key))
			row.date:SetTextColor(1, 1, 1)
			row.value:SetText(Money(entry.income - entry.expenses, true))
			row.selected:SetShown(entry.key == frame.selected)
		end
	end

	local lines, index = frame.lines, 1
	if selected then
		index = SetLine(lines, index, DayLabel(selected.key), nil, GOLD_R, GOLD_G, GOLD_B)
		index = SetLine(lines, index, L["Income"], Money(selected.income))
		index = SetLine(lines, index, L["Expenses"], Money(selected.expenses))
		index = SetLine(lines, index, L["Profit"], Money(selected.income - selected.expenses, true))
		index = SetLine(lines, index, L["Online time"], PlayTimeText(selected.time))
		index = SetLine(lines, index, L["Gold per hour"], selected.time >= 60 and Money(floor(selected.income * 3600 / selected.time)) or "-")

		local goal = (data.goals.daily or 0) * 10000
		if goal > 0 then
			local profit = selected.income - selected.expenses
			local reached = profit >= goal
			index = SetLine(lines, index, L["Daily goal"], format("%s%d%%|r", reached and COLOR_GAIN or "", floor(min(100, max(0, profit) * 100 / goal))))
		end

		local rows = {}
		for _, source in ipairs(SOURCES) do
			local bucket = selected.sources[source.id]
			if bucket and (bucket.income > 0 or bucket.expenses > 0) then tinsert(rows, { label = source.label, income = bucket.income, expenses = bucket.expenses }) end
		end
		if #rows > 0 then
			sort(rows, function(a, b)
				return a.income + a.expenses > b.income + b.expenses
			end)
			index = SetLine(lines, index, " ")
			index = SetLine(lines, index, L["Sources"], nil, GOLD_R, GOLD_G, GOLD_B)
			for _, row in ipairs(rows) do
				index = SetLine(lines, index, row.label, (row.income > 0 and Money(row.income, true) or "") .. (row.expenses > 0 and "  " .. Money(-row.expenses, true) or ""))
			end
		end
	else
		index = SetLine(lines, index, L["No days recorded yet."])
	end
	for i = index, DETAIL_LINES do
		SetLine(lines, i)
	end
	frame.deleteButton:SetEnabled(selected ~= nil)

	local today, weekStart = DayKey(), WeekStart()
	local monthStart = today:sub(1, 8) .. "01"
	local week, month, all, best = 0, 0, 0, nil
	for _, day in ipairs(days) do
		local profit = day.income - day.expenses
		all = all + profit
		if day.key >= weekStart then week = week + profit end
		if day.key >= monthStart then month = month + profit end
		if day.income > 0 and (not best or profit > best.income - best.expenses) then best = day end
	end
	SetLine(frame.summary, 1, L["This week"], Money(week, true))
	SetLine(frame.summary, 2, L["This month"], Money(month, true))
	SetLine(frame.summary, 3, format(L["All days (%d)"], #days), Money(all, true))
	SetLine(frame.summary, 4, L["Best day"], best and format("%s  %s", DateText(best.key), Money(best.income - best.expenses, true)) or "-")
end

function module:ToggleHistory()
	if not self.history then self.history = CreateHistory() end
	if self.history:IsShown() then
		self.history:Hide()
	else
		self.history.selected = nil
		self:RefreshHistory()
		self.history:Show()
	end
end

function module:DeleteDay(key)
	local frame = self.history
	local data = Data()
	if frame.view == "all" then
		for _, char in pairs(data.characters) do
			char.days[key] = nil
		end
	elseif data.characters[frame.view] then
		data.characters[frame.view].days[key] = nil
	end
	frame.selected = nil
	self:RefreshHistory()
	DT:ForceUpdate_DataText(DT_NAME)
end

function module:SetGoal(kind, gold)
	local goals = Data().goals
	goals[kind] = gold
	if kind == "target" then goals.target_reached = nil end
	if kind == "daily" then goals.daily_reached = nil end
	-- an already met goal stays silent instead of printing right away
	local current, goal = GoalProgress(kind)
	if current and current >= goal then
		if kind == "target" then goals.target_reached = true end
		if kind == "daily" then goals.daily_reached = DayKey() end
	end
	DT:ForceUpdate_DataText(DT_NAME)
end

-- today and character clear the history of this character, all forgets every character, goals are kept
function module:Reset(scope)
	local data = Data()
	if scope == "today" then
		character.days[DayKey()] = nil
	elseif scope == "character" then
		wipe(character.days)
	elseif scope == "all" then
		wipe(data.characters)
		data.warband = nil
		UpdateCharacter()
		UpdateWarband()
	end
	DT:ForceUpdate_DataText(DT_NAME)
end

function module:Initialize()
	if self.initialized then return end
	self.initialized = true

	UpdateCharacter()
	baseline = GetMoney()
	lastPlayTime = GetTime()
	UpdateWarband()
	C_Timer.NewTicker(60, AddPlayTime)

	-- not every flavor knows every event
	for event in pairs(SOURCE_EVENTS) do
		pcall(eventFrame.RegisterEvent, eventFrame, event)
	end
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("PLAYER_MONEY")
	eventFrame:RegisterEvent("PLAYER_LOGOUT")
	if E.Retail then eventFrame:RegisterEvent("ACCOUNT_MONEY") end
	eventFrame:SetScript("OnEvent", OnTrackerEvent)

	DT:ForceUpdate_DataText(DT_NAME)
end

DT:RegisterDatatext(DT_NAME, mMT.Name, nil, OnEvent, nil, OnClick, OnEnter, nil, L["Gold"], nil, ValueColorUpdate)
