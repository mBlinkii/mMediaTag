local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format
local strjoin = strjoin
local mInsert = table.insert

--WoW API / Variables
local _G = _G
local C_CurrencyInfo = C_CurrencyInfo

--Variables
local displayString = strjoin("", "%s", E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b), "%s|r")
local mTextName = "mElementalOverflow"
local mCurrencyID = 2118
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

		if E.db[mPlugin].mElementalOverflow.hide and CurrencValue == 0 then
			hideCurrency = true
		else
			hideCurrency = false
		end

		if not hideCurrency then
			if E.db[mPlugin].mElementalOverflow.name then
				if TextJustify == "RIGHT" then
					name = " " .. info.name
				else
					name = info.name .. " "
				end
			end

			if E.db[mPlugin].mElementalOverflow.icon then
				if TextJustify == "RIGHT" then
					name = format("%s %s", name, mMT:mIcon(info.iconFileID))
				else
					name = format("%s %s", mMT:mIcon(info.iconFileID), name)
				end
			end

			if E.db[mPlugin].mElementalOverflow.short then
				CurrencValue = E:ShortValue(info.quantity, 2)
			end

			local CurrencyTextSring = displayString

			if E.db[mPlugin].mElementalOverflow.style == "color" then
				if TextJustify == "RIGHT" then
					CurrencyTextSring = "|CFF44FFCD%s|r%s"
				else
					CurrencyTextSring = "%s|CFF44FFCD%s|r"
				end
			elseif E.db[mPlugin].mElementalOverflow.style == "white" then
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
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function OptionsCurrencys()
	E.Options.args.mMediaTag.args.datatext.args.currencys.args.ElementalOverflow.args = {
		ElementalOverflow_Header = {
			order = 100,
			type = "header",
			name = format("|CFF44FFCD%s|r", info.name),
		},
		ElementalOverflow_Color = {
			order = 110,
			type = "select",
			name = L["Color Style"],
			get = function(info)
				return E.db[mPlugin].mElementalOverflow.style
			end,
			set = function(info, value)
				E.db[mPlugin].mElementalOverflow.style = value
				DT:ForceUpdate_DataText("mElementalOverflow")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		ElementalOverflow_Icon = {
			order = 120,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mElementalOverflow.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mElementalOverflow.icon = value
				DT:ForceUpdate_DataText("mElementalOverflow")
			end,
		},
		ElementalOverflow_ShortNumber = {
			order = 130,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mElementalOverflow.short
			end,
			set = function(info, value)
				E.db[mPlugin].mElementalOverflow.short = value
				DT:ForceUpdate_DataText("mElementalOverflow")
			end,
		},
		ElementalOverflow_Name = {
			order = 140,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mElementalOverflow.name
			end,
			set = function(info, value)
				E.db[mPlugin].mElementalOverflow.name = value
				DT:ForceUpdate_DataText("mElementalOverflow")
			end,
		},
		ElementalOverflow_Hide = {
			order = 160,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mElementalOverflow.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mElementalOverflow.hide = value
				DT:ForceUpdate_DataText("mElementalOverflow")
			end,
		},
	}
end

mInsert(ns.Config, OptionsCurrencys)

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