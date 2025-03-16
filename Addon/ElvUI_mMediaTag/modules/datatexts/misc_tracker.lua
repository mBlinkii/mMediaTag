local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local module = mMT:AddModule("Tracker")

--WoW API / Variables
local _G = _G
local floor = floor
local GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local GetItemInfo = GetItemInfo

--Variables
local hide = false
local Currency = {
	info = {
		color = "|CFF034CF6", --#034CF6
		id = 3108,
		name = nil,
		icon = nil,
		link = nil,
		count = nil,
		cap = nil,
	},
	loaded = false,
}

-- local Currency = {
-- 	info = {
-- 		color = "|CFFFF8000",
-- 		id = 204194,
-- 		name = nil,
-- 		icon = nil,
-- 		link = nil,
-- 		count = nil,
--         cap = nil,
-- 	},
-- 	bag = {
-- 		id = 204078,
-- 		link = nil,
-- 		icon = nil,
-- 		count = nil,
-- 	},
-- 	fragment = {
-- 		id = 2412,
-- 		cap = nil,
-- 		quantity = nil,
-- 	},
-- 	loaded = false,
-- }
local tracker_demo_item = {
	[225557] = false,
	[3090] = true,
}

local tracker_ids_db = {}

local is_currency_db = {}

function mMT:GetCurrenciesInfo(tbl, item)
	if tbl and tbl.info and tbl.info.id then
		local itemName, itemLink, itemTexture, itemStackCount = nil, nil, nil, nil
		local info = nil

		if item then
			itemName, itemLink, _, _, _, _, _, itemStackCount, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(tbl.info.id)
			if itemName and itemLink and itemTexture then
				tbl.info.name = itemName
				tbl.info.icon = mMT:mIcon(itemTexture, 12, 12)
				tbl.info.link = itemLink
				tbl.info.count = GetItemCount(tbl.info.id, true)
				tbl.info.cap = itemStackCount
				tbl.loaded = true
			end
		else
			info = C_CurrencyInfo_GetCurrencyInfo(tbl.info.id)
			if info then
				tbl.info.name = info.name
				tbl.info.icon = mMT:mIcon(info.iconFileID, 12, 12)
				tbl.info.link = mMT:mCurrencyLink(tbl.info.id)
				tbl.info.count = info.quantity
				tbl.loaded = true
				if not tbl.fragment and info.maxQuantity then tbl.info.cap = info.maxQuantity end
			end
		end

		if tbl.bag and tbl.bag.id then
			itemName, itemLink, _, _, _, _, _, _, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(tbl.bag.id)
			if itemName and itemLink and itemTexture then
				tbl.bag.link = itemLink
				tbl.bag.icon = mMT:mIcon(itemTexture, 12, 12)
				tbl.bag.count = GetItemCount(tbl.bag.id, true)
			end
		end

		if tbl.fragment and tbl.fragment.id then
			info = C_CurrencyInfo_GetCurrencyInfo(tbl.fragment.id)
			if info then
				tbl.fragment.cap = info.maxQuantity
				tbl.fragment.quantity = info.quantity or 0
			end
		end
	else
		error(L["GetCurrenciesInfo no Table or no ID."])
	end
end



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

		local name, icon, color

		if not db.hide_if_zero then
			if db.name then name = info.name end

			if db.icon then icon = info.icon end

			if db.short_number and info.count >= 1000 then info.count = E:ShortValue(Currency.info.count, 2) end

			if db.style == "color" then
				color = info.color
			elseif db.style == "white" then
				color = "|CFFFFFFFF"
			else
			end

			if textJustify == "RIGHT" then
				self.text:SetFormattedText("%s %s %s|r%s", color or "", info.count, name or "", icon or "")
			else
				self.text:SetFormattedText("%s%s%s %s|r", icon or "", color or "", name or "", info.count)
			end
		end
	end
end

local function OnEnter(self)
	if not self.tracker_info then OnEvent(self) end

	DT.tooltip:ClearLines()
	if not hide then
		DT:SetupTooltip(self)
		DT.tooltip:SetHyperlink(self.tracker_info.link)
		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function LoadIDs()
	print("custom ids")
	local custom_ids = tracker_demo_item --E.db.mMT.datatexts.tracker.custom
	if next(custom_ids) then
		for id, isCurrency in pairs(custom_ids) do
			print(id, isCurrency)
			if id then
				local infos = (isCurrency and GetCurrencyInfos(id) or GetItemInfos(id))
				if infos then tracker_ids_db[id] = infos end
			end
		end
	end
end

function module:Initialize()
	print("hmms start?")
	LoadIDs()

	--if tracker_ids_db.loaded then
	for id, info in pairs(tracker_ids_db) do
		print("add dt", id, info)
		DT:RegisterDatatext(id, _G.CURRENCY, { "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" }, OnEvent, nil, nil, OnEnter, OnLeave, mMT.NameShort .. " - " .. info.name, nil)
	end
	--end
end
