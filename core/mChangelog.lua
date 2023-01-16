local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local mSkin = E:GetModule("Skins")
local addon, ns = ...

--Lua functions
local format = format

--Variables
local ChangelogText =
	"## [ver. 2.92.1] - 16.01.2023\n\n### Update\n- |CFFFF7F50###Update|r Datatex for the new ElvUI update\n- |CFFFF7F50###Update|r Removed some Fonts\n- |CFFFF7F50###Update|r Instance difficulty for Minimap update Shortname function\n- |CFFFF7F50###Update|r Instance difficulty for Minimap update HC color\n\n### Added\n- |CFF6495EDNEW|r Tag mName:last & mName:last:onlyininstance"

function mMT:Changelog(opt)
	local Frame = CreateFrame("Frame", "mMediaTagChangelog", E.UIParent, "BackdropTemplate")
	Frame:Point("CENTER")
	Frame:Size(400, 600)
	Frame:CreateBackdrop("Transparent")
	Frame:SetMovable(true)
	Frame:EnableMouse(true)
	Frame:RegisterForDrag("LeftButton")
	Frame:SetScript("OnDragStart", Frame.StartMoving)
	Frame:SetScript("OnDragStop", Frame.StopMovingOrSizing)
	Frame:SetClampedToScreen(true)
	Frame.mLogo = Frame:CreateTexture(nil, "ARTWORK")
	Frame.mLogo:Point("TOPLEFT", 72, -2)
	Frame.mLogo:Point("BOTTOMRIGHT", -72, 534)
	Frame.mLogo:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\logo.tga")

	local Font = GameFontHighlightSmall:GetFont()

	local Label1 = Frame:CreateFontString("ChangelogTitel", "OVERLAY", "GameTooltipText")
	Label1:SetFont(Font, 24)
	Label1:SetPoint("TOPLEFT", 20, -70)
	Label1:SetText(format("|CFF58D68D%s|r", L["Changelog:"]))

	local Label2 = Frame:CreateFontString("ChangelogText", "OVERLAY", "GameTooltipText")
	Label2:SetFont(Font, 14)
	Label2:SetPoint("TOPLEFT", 20, -90)
	Label2:SetWidth(360)
	Label2:SetHeight(500)
	Label2:SetText(ChangelogText)

	local Close = CreateFrame("Button", "CloseButton", Frame, BackdropTemplateMixin and "BackdropTemplate")
	Close:Point("BOTTOM", Frame, "BOTTOM", 0, 10)
	Close:SetText(CLOSE)
	Close:Size(80, 20)
	Close:SetScript("OnClick", function()
		E.db[mPlugin].mPluginVersion = ns.mVersion
		Frame:Hide()

		if opt then
			E:ToggleOptions()
		end
	end)

	local CloseButtonText = Close:CreateFontString("ChangelogText", "OVERLAY", "GameTooltipText")
	CloseButtonText:SetFont(Font, 14)
	CloseButtonText:SetPoint("CENTER")
	CloseButtonText:SetText("|CFFE74C3CClose|r")

	mSkin:HandleButton(Close)

	if opt then
		E:ToggleOptions()
	end
end
