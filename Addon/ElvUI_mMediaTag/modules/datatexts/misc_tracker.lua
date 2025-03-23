local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local module = mMT:AddModule("Tracker")

--WoW API / Variables
local _G = _G
local floor = floor
local GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local GetItemInfo = GetItemInfo
local strjoin = strjoin

local valueString = ""
local textString = ""

--Variables
local tracker_default_ids = {
	-- crest
	[2914] = { isCurrency = true, color = "FF84FF4F" },
	[2915] = { isCurrency = true, color = "FF034CF6" },
	[2916] = { isCurrency = true, color = "FFA928FF" },
	[2917] = { isCurrency = true, color = "FFFFA514" },
	[3008] = { isCurrency = true, color = "FF4FFCFF" }, -- valor

	-- tww
	[3089] = { isCurrency = true, color = "FF4FFCFF" }, -- Residual Memories
	[2815] = { isCurrency = true, color = "FFFFAE17" }, -- Resonance Crystals
	[3028] = { isCurrency = true, color = "FFEC46FF" }, -- Restored Coffer Key
	[2803] = { isCurrency = true, color = "FFEC46FF" }, -- Undercoin
	[3056] = { isCurrency = true, color = "FFEC46FF" }, -- Kej

	-- pvp
	[2123] = { isCurrency = true, color = "FFFF4117" }, -- Bloody Tokens
	[1792] = { isCurrency = true, color = "FFFCE03D" }, -- Honor
	[1602] = { isCurrency = true, color = "FFFCE03D" }, -- Conquest

	-- misc
	[2032] = { isCurrency = true, color = "FFF68D03" }, -- Trader's Tender
	[1166] = { isCurrency = true, color = "FF54BAFF" }, -- Timewarped Badge
}

local tracker_ids_db = {}
local is_currency_db = {}

function module:GetItemInfos(id)
	local itemName, itemLink, _, _, _, _, _, itemStackCount, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(id)
	if itemName and itemLink and itemTexture then
		return {
			name = itemName,
			icon = E:TextureString(itemTexture, ":14:14"),
			link = itemLink,
			count = GetItemCount(id, true),
			cap = itemStackCount,
		}
	end
end

function module:GetCurrencyInfos(id)
	local info = GetCurrencyInfo(id)
	if info then
		is_currency_db[id] = true
		return {
			name = info.name,
			icon = E:TextureString(info.iconFileID, ":14:14"),
			link = format("|Hcurrency:%s|h", id),
			count = info.quantity,
			cap = info.maxQuantity,
		}
	end
end

local function OnEvent(self)
	local db = E.db.mMT.datatexts.tracker
	local id = tonumber(self.name)
	local info = (is_currency_db[id] and module:GetCurrencyInfos(id) or module:GetItemInfos(id))
	if info then
		self.tracker_info = info
		local textJustify = self.text:GetJustifyH()
		self.text:SetText(info.name)

		local name, icon, value

		if db.name then name = info.name end

		if db.icon then icon = info.icon end

		if db.short_number and info.count >= 1000 then info.count = E:ShortValue(info.count, 2) end

		value = info.count
		if db.show_max and info.cap > 0 then
			if db.short_number and info.cap >= 1000 then info.cap = E:ShortValue(info.cap, 2) end
			value = format("%s/%s", info.count, info.cap)
		end

		if textJustify == "RIGHT" then
			self.text:SetFormattedText("%s %s%s", format(valueString, value), format(textString, name or ""), icon or "")
		else
			self.text:SetFormattedText("%s%s %s", icon or "", format(textString, name or ""), format(valueString, value))
		end
	end
end

local function OnEnter(self)
	if not self.tracker_info then OnEvent(self) end

	DT.tooltip:ClearLines()

	DT:SetupTooltip(self)
	DT.tooltip:SetHyperlink(self.tracker_info.link)
	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function ValueColorUpdate(self, hex)
	local db = E.db.mMT.datatexts.tracker
	local custom = tracker_ids_db[tonumber(self.name)] and tracker_ids_db[tonumber(self.name)].color
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or db.colored and "|c" .. custom or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or db.colored and "|c" .. custom or hex

	textString = strjoin("", textHex, "%s|r")
	valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

local function LoadIDs()
	tracker_ids_db = {}
	is_currency_db = {}

	if next(E.db.mMT.datatexts.tracker.custom) then
		for id, t in pairs(E.db.mMT.datatexts.tracker.custom) do
			if id then
				local infos = (t.isCurrency and module:GetCurrencyInfos(id) or module:GetItemInfos(id))
				if infos then
					tracker_ids_db[id] = infos
					tracker_ids_db[id].color = t.color
				end
			end
		end
	end

	for id, t in pairs(tracker_default_ids) do
		if id then
			local infos = (t.isCurrency and module:GetCurrencyInfos(id) or module:GetItemInfos(id))
			if infos then
				tracker_ids_db[id] = infos
				tracker_ids_db[id].color = t.color
			end
		end
	end
end

function module:UpdateAll()
	if next(tracker_ids_db) then
		for id, _ in pairs(tracker_ids_db) do
			DT:ForceUpdate_DataText(id)
		end
	end
end

function module:Initialize()
	LoadIDs()

	if next(tracker_ids_db) then
		for id, info in pairs(tracker_ids_db) do
			if not DT.RegisteredDataTexts[id] then
				DT:RegisterDatatext(id, _G.CURRENCY, { "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" }, OnEvent, nil, nil, OnEnter, OnLeave, "mMT - " .. info.name, nil, ValueColorUpdate)
			end
		end
	end
end
