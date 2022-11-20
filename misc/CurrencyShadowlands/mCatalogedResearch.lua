local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local select = select
local format = format
local strjoin = strjoin

--WoW API / Variables
local _G = _G
local C_CurrencyInfo = C_CurrencyInfo

--Variables
local displayString, lastPanel = "", nil
local mText = format("mMediaTag %s", L["Cataloged Research"])
local mTextName = "mCatalogedResearch"
local mCurrencyID = 1931
local hideCurrency = false

local mResearch = {
		[186685] = 1,
		[187322] = 8,
		[187457] = 8,
		[187324] = 8,
		[187323] = 8,
		[187460] = 8,
		[187458] = 8,
		[187459] = 8,
		[187465] = 48,
		[187327] = 48,
		[187463] = 48,
		[187325] = 48,
		[187326] = 48,
		[187462] = 48,
		[187478] = 48,
		[187336] = 100,
		[187466] = 100,
		[187332] = 100,
		[187328] = 100,
		[187334] = 100,
		[187330] = 150,
		[187329] = 150,
		[187467] = 150,
		[187331] = 150,
		[187311] = 300,
		[187333] = 300,
		[187350] = 300,
		[187335] = 300,
	}

local function mBagCheck()
	local mAmount = 0

	for itemID, mValue in pairs(mResearch) do
		local mCount = GetItemCount(itemID, true)
		mAmount = mAmount + mCount * mValue
	end

	return mAmount
end

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
		local CurrencValue, maxValue = info.quantity, info.maxQuantity

		if E.db[mPlugin].mCatalogedResearch.hide and CurrencValue == 0 then
			hideCurrency = true
		else
			hideCurrency = false
		end

		if not hideCurrency then
			if E.db[mPlugin].mCatalogedResearch.name then
				if TextJustify == "RIGHT" then
					name = " " .. info.name
				else
					name = info.name .. " "
				end
			end

			if E.db[mPlugin].mCatalogedResearch.icon then
				if TextJustify == "RIGHT" then
					name = format("%s %s", name, mMT:mIcon(info.iconFileID))
				else
					name = format("%s %s", mMT:mIcon(info.iconFileID), name)
				end
			end

			if E.db[mPlugin].mCatalogedResearch.short then
				CurrencValue = E:ShortValue(info.quantity, 2)
				maxValue = E:ShortValue(info.maxQuantity, 2)
			end

			if E.db[mPlugin].mCatalogedResearch.showmax then
				CurrencValue = CurrencValue .. " / " .. maxValue
			end

			if E.db[mPlugin].mCatalogedResearch.bag then
				local ResearchBag = mBagCheck()
				if ResearchBag then
					if ResearchBag >= 1 then
						if E.db[mPlugin].mCatalogedResearch.short then
							CurrencValue = CurrencValue .. " (+" .. E:ShortValue(ResearchBag, 2) .. ")"
						else
							CurrencValue = CurrencValue .. " (+" .. ResearchBag .. ")"
						end
					end
				end
			end

			local CurrencyTextSring = displayString

			if E.db[mPlugin].mCatalogedResearch.style == "color" then
				if TextJustify == "RIGHT" then
					CurrencyTextSring = "|CFF87FC0B%s|r%s"
				else
					CurrencyTextSring = "%s|CFF87FC0B%s|r"
				end
			elseif E.db[mPlugin].mCatalogedResearch.style == "white" then
				CurrencyTextSring = "|CFFFFFFFF%s%s|r"
			end

			if TextJustify == "RIGHT" then
				self.text:SetFormattedText(CurrencyTextSring, CurrencValue, name ~= "" and name)
			else
				self.text:SetFormattedText(CurrencyTextSring, name ~= "" and name, CurrencValue)
			end
		end
	else
		self.text:SetText("|CFFE74C3CERROR!|r")
	end

	lastPanel = self
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s", hex, "%s|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel, "ELVUI_COLOR_UPDATE")
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext(
	mTextName,
	_G.CURRENCY,
	{ "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE", "BAG_UPDATE_DELAYED" },
	OnEvent,
	nil,
	nil,
	OnEnter,
	OnLeave,
	mText,
	ValueColorUpdate
)