local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G
local floor = floor

--Variables
local hide = false
local Currency = {
	info = {
		color = "|CFF1EFF00",
		id = 204193,
		name = nil,
		icon = nil,
		link = nil,
		count = nil,
		cap = nil,
	},
	bag = {
		id = 204075,
		link = nil,
		icon = nil,
		count = nil,
	},
	fragment = {
		id = 2409,
		cap = nil,
		quantity = nil,
	},
	loaded = false,
}

local FRAGMENTS_EARNED = gsub(_G.ITEM_UPGRADE_FRAGMENTS_TOTAL, "%s*|c.+$", "")
local function OnEnter(self)
	if Currency.loaded then
		mMT:GetCurrenciesInfo(Currency, true)
	end

	DT.tooltip:ClearLines()
	if not hide then
		DT:SetupTooltip(self)
		DT.tooltip:SetHyperlink(Currency.info.link)
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(FRAGMENTS_EARNED .. " " ..  (Currency.bag.icon or "") .. " |CFFFFFFFF" .. Currency.fragment.quantity .. "/" .. Currency.fragment.cap .. "|r")
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	local TextJustify = self.text:GetJustifyH()
	mMT:GetCurrenciesInfo(Currency, true)

	hide = (E.db.mMT.datatextcurrency.hide and Currency.info.count == 0)

	if Currency.loaded then
		local name = nil
		local icon = nil
		local bagCount = nil
		local color = mMT.ClassColor.hex

		if not hide then
			if E.db.mMT.datatextcurrency.name then
				name = Currency.info.name
			end

			if E.db.mMT.datatextcurrency.icon then
				icon = Currency.info.icon
			end

			if E.db.mMT.datatextcurrency.short and Currency.info.count >= 1000 then
				Currency.info.count = E:ShortValue(Currency.info.count, 2)
			end

			if E.db.mMT.datatextcurrency.style == "color" then
				color = Currency.info.color
			elseif E.db.mMT.datatextcurrency.style == "white" then
				color = "|CFFFFFFFF"
			end

			if E.db.mMT.datatextcurrency.bag then
				bagCount = floor((Currency.bag.count or 0) / 15)
				if bagCount ~= 0 then
					bagCount = "|CFFFFFFFF[|r" .. bagCount .. "|CFFFFFFFF]|r"
				else
					bagCount = nil
				end
			end

			if TextJustify == "RIGHT" then
				self.text:SetFormattedText(
					"%s%s %s %s|r%s",
					color,
					bagCount or "",
					Currency.info.count,
					name or "",
					icon or ""
				)
			else
				self.text:SetFormattedText(
					"%s%s%s %s %s|r",
					icon or "",
					color,
					name or "",
					Currency.info.count,
					bagCount or ""
				)
			end
		end
	else
		self.text:SetText("|CFFE74C3CERROR!|r")
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext(
	"mWhelpling",
	_G.CURRENCY,
	{ "BAG_UPDATE", "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" },
	OnEvent,
	nil,
	nil,
	OnEnter,
	OnLeave,
	"mMediaTag Whelpling's Shadowflame Crest",
	nil
)
