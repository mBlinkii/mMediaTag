local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G
local floor = floor

--Variables
local hide = false
local Currency = {
	info = {
		color = "|CFFA928FF", --#A928FF
		id = 2916,
		name = nil,
		icon = nil,
		link = nil,
		count = nil,
		cap = nil,
	},
	loaded = false,
}

local function OnEnter(self)
	if Currency.loaded then
		mMT:GetCurrenciesInfo(Currency)
	end

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

DT:RegisterDatatext("mMT_RunedHarbingerCrest", _G.CURRENCY, { "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" }, OnEvent, nil, nil, OnEnter, OnLeave, "mMT - Runed Harbinger Crest", nil)
