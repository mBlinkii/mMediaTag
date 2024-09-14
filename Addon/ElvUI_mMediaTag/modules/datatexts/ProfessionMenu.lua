local E = unpack(ElvUI)
local L = mMT.Locales

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

local function colorText(value, withe)
	if withe then
		return value
	else
		local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
		return hexColor .. value .. "|r"
	end
end

local function OnClick(self, button)
	wipe(menuList)
	menuList = mMT:GetProfessions()
	if next(menuList) then
		mMT:mDropDown(menuList, menuFrame, self, 200, 2)
	else
		_G.UIErrorsFrame:AddMessage(format("%s: |CFFE74C3C%s|r", mMT.Name, L["No professions available!"]))
		mMT:Print(format("%s: |CFFE74C3C%s|r", mMT.Name, L["No professions available!"]))
	end
end

local function OnEnter(self)
	wipe(menuList)
	menuList = mMT:GetProfessions(true)

	DT.tooltip:AddLine(TRADE_SKILLS)
	DT.tooltip:AddLine(" ")
	if next(menuList) then
		for i = 1, #menuList do
			if not menuList[i].isTitle and not (menuList[i].text == TRADE_SKILLS) then
				DT.tooltip:AddDoubleLine((mMT:mIcon(menuList[i].icon) or "") .. "  " .. menuList[i].color .. menuList[i].text .. "|r", menuList[i].Secondtext)
			end
		end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["left click to open the menu."]))
	else
		DT.tooltip:AddLine(format("%s%s|r", "|CFFE74C3C", L["No Professions"]))
	end
	DT.tooltip:Show()
end

local function OnEvent(self, event, unit)
	local TextString = mText
	if E.db.mMT.profession.icon then
		TextString = format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\profession.tga:16:16:0:0:64:64|t %s", colorText(mText, E.db.mMT.profession.whiteText))
	end

	self.text:SetText(TextString)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mProfessions", mMT.DatatextString, "TRADE_SKILL_DETAILS_UPDATE", OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
