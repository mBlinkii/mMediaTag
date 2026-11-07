local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local module = mMT:AddModule("Gold")

local _G = _G
local date, floor, format, ipairs, min, pairs, pcall, sort, time, tinsert = date, floor, format, ipairs, min, pairs, pcall, sort, time, tinsert
local GetMoney = GetMoney
local IsShiftKeyDown = IsShiftKeyDown
local strjoin, wipe = strjoin, wipe

local DT_NAME = "mMT - Gold"
local KEEP_DAYS = 62
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
local baseline, character

local function DayKey(offset)
	local now = date("*t")
	return date("%Y-%m-%d", time({ year = now.year, month = now.month, day = now.day + (offset or 0), hour = 12 }))
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

local function RecordMoney()
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
	end
	DT:ForceUpdate_DataText(DT_NAME)
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
	UpdateWarband()

	-- not every flavor knows every event
	for event in pairs(SOURCE_EVENTS) do
		pcall(eventFrame.RegisterEvent, eventFrame, event)
	end
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("PLAYER_MONEY")
	if E.Retail then eventFrame:RegisterEvent("ACCOUNT_MONEY") end
	eventFrame:SetScript("OnEvent", OnTrackerEvent)

	DT:ForceUpdate_DataText(DT_NAME)
end

DT:RegisterDatatext(DT_NAME, mMT.Name, nil, OnEvent, nil, OnClick, OnEnter, nil, L["Gold"], nil, ValueColorUpdate)
