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
local mTextName = "mTimewarpedBadge"
local mCurrencyID = 1166
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
	local info = C_CurrencyInfo.GetCurrencyInfo(mCurrencyID)
	local TextJustify = self.text:GetJustifyH()
	if info then
		local name = ""
		local CurrencValue = info.quantity

		if E.db[mPlugin].mTimewarpedBadge.hide and CurrencValue == 0 then
			hideCurrency = true
		else
			hideCurrency = false
		end

		if not hideCurrency then
			if E.db[mPlugin].mTimewarpedBadge.name then
				if TextJustify == "RIGHT" then
					name = " " .. info.name
				else
					name = info.name .. " "
				end
			end

			if E.db[mPlugin].mTimewarpedBadge.icon then
				if TextJustify == "RIGHT" then
					name = format("%s %s", name, mMT:mIcon(info.iconFileID, 12, 12))
				else
					name = format("%s %s", mMT:mIcon(info.iconFileID, 12, 12), name)
				end
			end

			if E.db[mPlugin].mTimewarpedBadge.short then
				CurrencValue = E:ShortValue(info.quantity, 2)
			end

			local CurrencyTextSring = displayString

			if E.db[mPlugin].mTimewarpedBadge.style == "color" then
				if TextJustify == "RIGHT" then
					CurrencyTextSring = "|CFF0873B9%s|r%s"
				else
					CurrencyTextSring = "%s|CFF0873B9%s|r"
				end
			elseif E.db[mPlugin].mTimewarpedBadge.style == "white" then
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
	E.Options.args.mMediaTag.args.datatext.args.currencys.args.TimewarpedBadge.args = {
		TimewarpedBadge_Header = {
			order = 100,
			type = "header",
			name = format("|CFF0873B9%s|r", info.name),
		},
		TimewarpedBadge_Color = {
			order = 110,
			type = "select",
			name = L["Color Style"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.style
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.style = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		TimewarpedBadge_Icon = {
			order = 120,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.icon = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
		},
		TimewarpedBadge_ShortNumber = {
			order = 130,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.short
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.short = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
		},
		TimewarpedBadge_Name = {
			order = 140,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.name
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.name = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
		},
		TimewarpedBadge_Hide = {
			order = 160,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.hide = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
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
