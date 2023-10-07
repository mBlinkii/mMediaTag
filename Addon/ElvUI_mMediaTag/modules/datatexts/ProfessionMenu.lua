local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local wipe = wipe

--WoW API / Variables
local _G = _G

--Variables
local mText = TRADE_SKILLS
local menuFrame = CreateFrame("Frame", "mProfessionMenu", E.UIParent, "BackdropTemplate")
menuFrame:SetTemplate("Transparent", true)
local menuList = {}

local function OnClick(self, button)
	wipe(menuList)
	menuList = mMT:GetProfessions()
	if menuList then
		mMT:mDropDown(menuList, menuFrame, self, 200, 2)
	else
		_G.UIErrorsFrame:AddMessage(format(L["%s: |CFFE74C3CNo professions available!|r"], mMT.Name))
		mMT:Print(format(L["%s: |CFFE74C3CNo professions available!|r"], mMT.Name))
	end
end

local function OnEnter(self)
	wipe(menuList)
	menuList = mMT:GetProfessions()

	DT.tooltip:AddLine(TRADE_SKILLS)
	DT.tooltip:AddLine(" ")
	if menuList then
		for i = 1, #menuList do
			if not menuList[i].isTitle and not (menuList[i].text == TRADE_SKILLS) then
				DT.tooltip:AddDoubleLine((mMT:mIcon(menuList[i].icon) or "") .. "  " .. menuList[i].color .. menuList[i].text .. "|r", menuList[i].Secondtext)
			end
		end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["left click to open the menu."]))
	else
		DT.tooltip:AddLine(format("%s%s|r", "|CFFE74C3C", L["No Professions|r"]))
	end
	DT.tooltip:Show()
end

local function OnEvent(self, event, unit)
	local TextString = mText
	if E.db.mMT.profession.icon then
		TextString = format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\profession.tga:16:16:0:0:64:64|t %s", mText)
	end

	local hex = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
	local string = strjoin("", hex, "%s|r")

	self.text:SetFormattedText(string, TextString)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mProfessions", "mMediaTag", "TRADE_SKILL_DETAILS_UPDATE", OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
