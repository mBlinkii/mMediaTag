local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--WoW API / Variables
local _G = _G
local C_CurrencyInfo = C_CurrencyInfo

--Variables
local mText = format("mMediaTag %s", L["Conquest"])
local mTextName = "mConquest"
local mCurrencyID = 1602
local hideCurrency = false

local function OnEnter(self)
	if not hideCurrency then
		DT:SetupTooltip(self)
		DT.tooltip:SetHyperlink(mMT:mCurrencyLink(mCurrencyID))
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	local info = C_CurrencyInfo.GetCurrencyInfo(mCurrencyID)
	local TextJustify = self.text:GetJustifyH()
	if info then
		local name = ""
		local CurrencyValue, maxValue = info.quantity, info.maxQuantity

		if E.db.mMT.datatextcurrency.hide and CurrencyValue == 0 then
			hideCurrency = true
		else
			hideCurrency = false
		end

		if not hideCurrency then
			if E.db.mMT.datatextcurrency.name then
				if TextJustify == "RIGHT" then
					name = " " .. info.name
				else
					name = info.name .. " "
				end
			end

			if E.db.mMT.datatextcurrency.icon then
				if TextJustify == "RIGHT" then
					name = format("%s %s", name, mMT:mIcon(info.iconFileID, 12, 12))
				else
					name = format("%s %s", mMT:mIcon(info.iconFileID, 12, 12), name)
				end
			end

			if E.db.mMT.datatextcurrency.short then
				CurrencyValue = E:ShortValue(info.quantity, 2)
				maxValue = E:ShortValue(info.maxQuantity, 2)
			end

			if E.db.mMT.datatextcurrency.showmax then
				CurrencyValue = CurrencyValue .. " / " .. maxValue
			end

			local CurrencyTextString = "%s" .. mMT.ClassColor.string

			if TextJustify == "RIGHT" then
				CurrencyTextString = mMT.ClassColor.string .. "%s"
			end

			if E.db.mMT.datatextcurrency.style == "color" then
				if TextJustify == "RIGHT" then
					CurrencyTextString = "|CFFC9913C%s|r%s"
				else
					CurrencyTextString = "%s|CFFC9913C%s|r"
				end
			elseif E.db.mMT.datatextcurrency.style == "white" then
				CurrencyTextString = "|CFFFFFFFF%s%s|r"
			end

			if TextJustify == "RIGHT" then
				self.text:SetFormattedText(CurrencyTextString, CurrencyValue, name)
			else
				self.text:SetFormattedText(CurrencyTextString, name, CurrencyValue)
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
	mTextName,
	_G.CURRENCY,
	{ "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" },
	OnEvent,
	nil,
	nil,
	OnEnter,
	OnLeave,
	mText,
	nil
)
