local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local LSM = E.Libs.LSM
local addon, ns = ...

local _, unitClass = UnitClass('player')
local class = ElvUF.colors.class[unitClass]
local DT = E:GetModule('DataTexts')

local function mCreatCosmetics()

    local LeftChatPanel = _G.LeftChatPanel
	LeftChatPanel.mBar = CreateFrame("StatusBar", nil, LeftChatPanel)
	LeftChatPanel.mBar:SetFrameStrata("BACKGROUND")
	LeftChatPanel.mBar:SetSize(LeftChatPanel:GetWidth()-2, 12)
	LeftChatPanel.mBar:SetPoint("TOP", LeftChatPanel, "BOTTOM", 0, -2)
	LeftChatPanel.mBar:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag H1"))
	LeftChatPanel.mBar:SetStatusBarColor(class[1], class[2], class[3], .50)
	LeftChatPanel.mBar:CreateBackdrop()
	LeftChatPanel.mBar.backdrop:SetBackdropColor(class[1], class[2], class[3], .50)

    local RightChatPanel = _G.RightChatPanel
	RightChatPanel.mBar = CreateFrame("StatusBar", nil, RightChatPanel)
	RightChatPanel.mBar:SetFrameStrata("BACKGROUND")
	RightChatPanel.mBar:SetSize(RightChatPanel:GetWidth()-2, 12)
	RightChatPanel.mBar:SetPoint("TOP", RightChatPanel, "BOTTOM", 0, -2)
	RightChatPanel.mBar:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag H1"))
	RightChatPanel.mBar:SetStatusBarColor(class[1], class[2], class[3], .50)
	RightChatPanel.mBar:CreateBackdrop()
	RightChatPanel.mBar.backdrop:SetBackdropColor(class[1], class[2], class[3], .50)

	local DTPanel = DT:FetchFrame("mActionbarBackground")
	DTPanel.mBar = CreateFrame("StatusBar", nil, DTPanel)
	DTPanel.mBar:SetFrameStrata("BACKGROUND")
	DTPanel.mBar:SetSize(DTPanel:GetWidth()-2, 12)
	DTPanel.mBar:SetPoint("TOP", DTPanel, "BOTTOM", 0, -2)
	DTPanel.mBar:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag H1"))
	DTPanel.mBar:SetStatusBarColor(class[1], class[2], class[3], .50)
	DTPanel.mBar:CreateBackdrop()
	DTPanel.mBar.backdrop:SetBackdropColor(class[1], class[2], class[3], .50)
end

function mMT:mStartCosmetics()
    mCreatCosmetics()

	local mTank = 'Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tank4.tga'
	local mDD = 'Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\cookie3.tga'
	local mHeal = 'Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\heal2.tga'

	E.Media.Textures.Tank = mTank
	E.Media.Textures.Healer = mHeal
	E.Media.Textures.DPS = mDD

	local sizeString = ":12:12"

	_G.INLINE_TANK_ICON = E:TextureString(mTank, sizeString)
	_G.INLINE_HEALER_ICON = E:TextureString(mHeal, sizeString)
	_G.INLINE_DAMAGER_ICON = E:TextureString(mDD, sizeString)

	local CH = E:GetModule('Chat')
	CH.RoleIcons = {
		TANK = E:TextureString(mTank, sizeString),
		HEALER = E:TextureString(mHeal, sizeString),
		DAMAGER = E:TextureString(mDD, sizeString),
	}

	local UF = E:GetModule('UnitFrames')
	UF.RoleIconTextures = {
		TANK = mTank,
		HEALER = mHeal,
		DAMAGER = mDD
}
	-- hooksecurefunc(DT, "UpdatePanelInfo", function(DT, panelName, panel)
	-- 	if not panel then return end
	-- 	local db = E.global.datatexts.customPanels[panelName]
	-- 	if not db then return end
	-- 	print(panelName)
	-- 	-- Need to find a way to hide my styling if changing the option from a panel
	-- 	if panel and not panel.mstyled then
	-- 		if db.backdrop then
	-- 			panel:SetBackdropColor(class[1], class[2], class[3], .50)
	-- 		end
	-- 		panel.mstyled = true
	-- 	end
	-- end)
end