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
end