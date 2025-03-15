local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local _G = _G
local menuFrame = CreateFrame("Frame", "mProfessionMenu", E.UIParent, "BackdropTemplate")
menuFrame:SetTemplate("Transparent", true)
local menuList = {}
local Config = {
	name = "mMT_Dock_Profession",
	localizedName = mMT.DockString .. " " .. TRADE_SKILLS,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
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
	mMT:Dock_OnEnter(self, Config)
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
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

	mMT:Dock_Click(self, Config)
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.profession.icon]
		Config.icon.color = E.db.mMT.dockdatatext.profession.customcolor and E.db.mMT.dockdatatext.profession.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
