local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G
local floor = floor

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

local function OnEnter(self)
	if Currency.loaded then mMT:GetCurrenciesInfo(Currency) end

	DT.tooltip:ClearLines()
	if not hide then
		DT:SetupTooltip(self)
		DT.tooltip:SetHyperlink(Currency.info.link)
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	local TextJustify = self.text:GetJustifyH()
	mMT:GetCurrenciesInfo(Currency)

	hide = (E.db.mMT.datatextcurrency.hide and Currency.info.count == 0)

	if Currency.loaded then
		local name = nil
		local icon = nil
		local bagCount = nil
		local color = mMT.ClassColor.hex

		if not hide then
			if E.db.mMT.datatextcurrency.name then name = Currency.info.name end

			if E.db.mMT.datatextcurrency.icon then icon = Currency.info.icon end

			if E.db.mMT.datatextcurrency.short and Currency.info.count >= 1000 then Currency.info.count = E:ShortValue(Currency.info.count, 2) end

			if E.db.mMT.datatextcurrency.style == "color" then
				color = Currency.info.color
			elseif E.db.mMT.datatextcurrency.style == "white" then
				color = "|CFFFFFFFF"
			end

			if TextJustify == "RIGHT" then
				self.text:SetFormattedText("%s%s %s %s|r%s", color, bagCount or "", Currency.info.count, name or "", icon or "")
			else
				self.text:SetFormattedText("%s%s%s %s %s|r", icon or "", color, name or "", Currency.info.count, bagCount or "")
			end
		end
	else
		self.text:SetText("|CFFE74C3CERROR!|r")
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mMT_CarvedHarbingerCrest", _G.CURRENCY, { "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" }, OnEvent, nil, nil, OnEnter, OnLeave, "mMT - Carved Crest", nil)
