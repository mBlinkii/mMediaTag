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
local tracker_demo_item = {
	[225557] = { isCurrency = false, color = "FF034CF6" },
	[3090] = { isCurrency = true, color = "FFF68D03" },
	[3108] = { isCurrency = true, color = "FF034CF6" },
}

local tracker_ids_db = {}
local is_currency_db = {}

local function GetItemInfos(id)
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

local function GetCurrencyInfos(id)
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
	local info = (is_currency_db[id] and GetCurrencyInfos(id) or GetItemInfos(id))
	if info then
		self.tracker_info = info
		local textJustify = self.text:GetJustifyH()
		self.text:SetText(info.name)

		local name, icon

		if not db.hide_if_zero then
			if db.name then name = info.name end

			if db.icon then icon = info.icon end

			if db.short_number and info.count >= 1000 then info.count = E:ShortValue(info.count, 2) end

			if textJustify == "RIGHT" then
				self.text:SetFormattedText("%s %s%s", format(valueString, info.count), format(textString, name or ""), icon or "")
			else
				self.text:SetFormattedText("%s%s %s", icon or "", format(textString, name or ""), format(valueString, info.count))
			end
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
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or db.colored and "|c" .. tracker_ids_db[tonumber(self.name)].color or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or db.colored and "|c" .. tracker_ids_db[tonumber(self.name)].color or hex

	textString = strjoin("", textHex, "%s|r")
	valueString = strjoin("", valueHex, "%s|r")
	print(format(textString, "TEXT"), format(valueString, "VALUE"))
	OnEvent(self)
end

local function LoadIDs()
	print("custom ids")
	local custom_ids = tracker_demo_item --E.db.mMT.datatexts.tracker.custom
	if next(custom_ids) then
		for id, t in pairs(custom_ids) do
			print(id, t.isCurrency)
			if id then
				local infos = (t.isCurrency and GetCurrencyInfos(id) or GetItemInfos(id))
				if infos then
					tracker_ids_db[id] = infos
					tracker_ids_db[id].color = t.color
				end
			end
		end
	end
end

function module:UpdateAll()
	if next(tracker_ids_db) then
		print("update dt")
		for id, info in pairs(tracker_ids_db) do
			DT:ForceUpdate_DataText(id)
		end
	end
end

function module:Initialize()
	print("hmms start?")
	LoadIDs()

	if next(tracker_ids_db) then
		print("register dt")
		for id, info in pairs(tracker_ids_db) do
			print("add dt", id, info)
			DT:RegisterDatatext(id, _G.CURRENCY, { "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" }, OnEvent, nil, nil, OnEnter, OnLeave, "mMT - " .. info.name, nil, ValueColorUpdate)
		end
	end
end
