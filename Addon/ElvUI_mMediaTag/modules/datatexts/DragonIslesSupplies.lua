local mMT, E, L, V, P, G = unpack((select(2, ...)))

local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local strjoin = strjoin

--WoW API / Variables
local _G = _G
local C_CurrencyInfo = C_CurrencyInfo

--Variables
local mTextName = "mDragonIslesSupplies"
local mCurrencyID = 2003
local info = C_CurrencyInfo.GetCurrencyInfo(mCurrencyID)
local mText = format("mMediaTag %s", info.name)
local hideCurrency = false

local function OnEnter(self)
	if not hideCurrency then
		DT:SetupTooltip(self)
		DT.tooltip:SetHyperlink(mMT:mCurrencyLink(mCurrencyID))
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	info = C_CurrencyInfo.GetCurrencyInfo(mCurrencyID)
	local TextJustify = self.text:GetJustifyH()
	if info then
		local name = ""
		local CurrencValue = info.quantity

		if E.db.mMT.datatextcurrency.hide and CurrencValue == 0 then
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
				CurrencValue = E:ShortValue(info.quantity, 2)
			end

			local CurrencyTextSring = "%s" .. mMT.ClassColor.string
			
			if TextJustify == "RIGHT" then
				CurrencyTextSring = mMT.ClassColor.string .. "%s"
			end

			if E.db.mMT.datatextcurrency.style == "color" then
				if TextJustify == "RIGHT" then
					CurrencyTextSring = "|CFF0873B9%s|r%s"
				else
					CurrencyTextSring = "%s|CFF0873B9%s|r"
				end
			elseif E.db.mMT.datatextcurrency.style == "white" then
				CurrencyTextSring = "|CFFFFFFFF%s%s|r"
			end

			if TextJustify == "RIGHT" then
				self.text:SetFormattedText(CurrencyTextSring, CurrencValue, name)
			else
				self.text:SetFormattedText(CurrencyTextSring, name, CurrencValue)
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