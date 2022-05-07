local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local DT = E:GetModule("DataTexts");
local addon, ns = ...

--Lua functions
local select = select
local format = format
local strjoin = strjoin

--WoW API / Variables
local _G = _G
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemInfo = GetContainerItemInfo
local GetItemSpell = GetItemSpell
local C_CurrencyInfo = C_CurrencyInfo
local IsAddOnLoaded = IsAddOnLoaded

--Variables
local displayString, lastPanel = "", nil
local mText = format("mMediaTag %s", L["Anima"])
local mTextName = "mAnima"
local mCurrencyID = 1813
local hideCurrency = false

local function mBagCheck()
	local mAmount = 0
	local Animas = {
		[347555] = 3,
		[345706] = 5,
		[336327] = 35,
		[336456] = 250,
	}

	for bagID = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(bagID)
		for slot=1, slots do
			local itemID = select(10,GetContainerItemInfo(bagID,slot))
			local itemCount = select(2,GetContainerItemInfo(bagID,slot))
			local _,spellID = GetItemSpell(itemID)
			if spellID and Animas[spellID] then
				mAmount = mAmount + (Animas[spellID]*itemCount)
			end
		end
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
		
		if E.db[mPlugin].mAnima.hide and CurrencValue == 0 then
			hideCurrency = true
		else
			hideCurrency = false
		end

		if not hideCurrency then
			if E.db[mPlugin].mAnima.name then
				if TextJustify == "RIGHT" then 
					name = " " .. info.name
				else
					name = info.name .. " "
				end
			end
		
			if E.db[mPlugin].mAnima.icon then
				if TextJustify == "RIGHT" then
					name = format("%s %s", name, mMT:mIcon(info.iconFileID))
				else
					name = format("%s %s", mMT:mIcon(info.iconFileID), name)
				end
			end
		
			if E.db[mPlugin].mAnima.short then
				CurrencValue = E:ShortValue(info.quantity, 2)
				maxValue = E:ShortValue(info.maxQuantity, 2)
			end
		
			if E.db[mPlugin].mAnima.showmax then
				CurrencValue = CurrencValue .. " / " .. maxValue
			end
		
			if E.db[mPlugin].mAnima.bag then
				local AnmimBag = mBagCheck()
				if AnmimBag then
					if AnmimBag >= 1 then
						if E.db[mPlugin].mAnima.short then
							CurrencValue = CurrencValue .. " (+" .. E:ShortValue(AnmimBag, 2) .. ")"
						else
							CurrencValue = CurrencValue .. " (+" .. AnmimBag .. ")"
						end
					end
				end
			end
		
			local CurrencyTextSring = displayString

			if E.db[mPlugin].mAnima.style == "color" then
				if TextJustify == "RIGHT" then
					CurrencyTextSring = "|CFF3390FF%s|r%s"
				else
					CurrencyTextSring = "%s|CFF3390FF%s|r"
				end
			elseif E.db[mPlugin].mAnima.style == "white" then
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
	displayString = strjoin('', '%s', hex, '%s|r')
	
	if lastPanel ~= nil then
		OnEvent(lastPanel, "ELVUI_COLOR_UPDATE")
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext(mTextName, _G.CURRENCY, {'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE', 'ITEM_PUSH', 'BAG_UPDATE', 'ANIMA_DIVERSION_CLOSE'}, OnEvent, nil, nil, OnEnter, OnLeave, mText, ValueColorUpdate)