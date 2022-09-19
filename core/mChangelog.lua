local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local mSkin = E:GetModule("Skins")
local addon, ns = ...

--Lua functions
local format = format

--Variables
local ChangelogDate = "17.09.2022"
local ChangelogText =
	"## [ver. 2.88] - 17.09.2022\n\n### Update\n- |CFFFE7B2CFIX|r for Profession and Dungeon Datatext Settings\n- |CFFFE7B2CFIX|r for Dock Calendar Icon for WOTLK\n- |CFF58D68DUPDATE|r Tags Target Counter mTargetingPlayers:icons:Party to mTargetingPlayers:icons\n- |CFFE74C3CREMOVED|r Tags mTargetMarkOne, mTargetMarkTwo, mTargetingPlayers:icons:party\n- |CFF58D68DUPDATE|r Combaticons for Party\n\n### Added\n- |CFF3498DBNEW|r Tags for Target Counter mTargetingPlayers:icons:SQ and mTargetingPlayers:icons:Glas\n- |CFF3498DBNEW|r custom Combat Icons settings for custom texture"

function mMT:Changelog(opt)
	local Frame = CreateFrame("Frame", "mMediaTagChangelog", E.UIParent, "BackdropTemplate")
	Frame:Point("CENTER")
	Frame:Size(400, 500)
	Frame:CreateBackdrop("Transparent")
	Frame:SetMovable(true)
	Frame:EnableMouse(true)
	Frame:RegisterForDrag("LeftButton")
	Frame:SetScript("OnDragStart", Frame.StartMoving)
	Frame:SetScript("OnDragStop", Frame.StopMovingOrSizing)
	Frame:SetClampedToScreen(true)
	Frame.mLogo = Frame:CreateTexture(nil, "ARTWORK")
	Frame.mLogo:Point("TOPLEFT", 72, -2)
	Frame.mLogo:Point("BOTTOMRIGHT", -72, 434)
	Frame.mLogo:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\logo.tga")

	local Font = GameFontHighlightSmall:GetFont()

	local Label1 = Frame:CreateFontString(Frame, "OVERLAY", "GameTooltipText")
	Label1:SetFont(Font, 18)
	Label1:SetPoint("TOPRIGHT", -20, -70)
	Label1:SetText(ChangelogDate)

	local Label2 = Frame:CreateFontString(Frame, "OVERLAY", "GameTooltipText")
	Label2:SetFont(Font, 18)
	Label2:SetPoint("TOPLEFT", 20, -70)
	Label2:SetText(format("%s%s|r", ns.mColor6, L["Changelog:"]))

	local Label3 = Frame:CreateFontString(Frame, "OVERLAY", "GameTooltipText")
	Label3:SetFont(Font, 14)
	Label3:SetPoint("TOPLEFT", 20, -100)
	Label3:SetWidth(360)
	Label3:SetText(ChangelogText)

	local Close = CreateFrame("Button", "CloseButton", Frame, "OptionsButtonTemplate, BackdropTemplate")
	Close:Point("BOTTOM", Frame, "BOTTOM", 0, 10)
	Close:SetText(CLOSE)
	Close:Size(80, 20)
	Close:SetScript("OnClick", function()
		E.db[mPlugin].mPluginVersion = ns.mVersion
		Frame:Hide()

		if opt then
			E:ToggleOptionsUI()
		end
	end)

	mSkin:HandleButton(Close)

	if opt then
		E:ToggleOptionsUI()
	end
end
