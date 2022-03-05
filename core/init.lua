local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:NewModule(mPlugin, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...
local Version = GetAddOnMetadata(addon, "Version")
local LSM = E.Libs.LSM

--Variables
ns.mName 			= "|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r"
ns.mNameClassic 	= "|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r |cffff0066Classic|r"
ns.mVersion 		= Version
ns.mColor1 			= "|CFFFFFFFF"	-- white
ns.mColor2 			= "|CFFF7DC6F" 	-- yellow
ns.mColor3 			= "|CFF8E44AD"	-- purple
ns.mColor4 			= "|CFFFE7B2C" 	-- orange
ns.mColor5 			= "|CFFE74C3C" 	-- red
ns.mColor6 			= "|CFF58D68D" 	-- green
ns.mColor7 			= "|CFF3498DB" 	-- blue
ns.mColor8 			= "|CFFB2BABB" 	-- gray
ns.normal			= "|CFF82E0AA"	-- nomral
ns.Heroic			= "|CFF85C1E9 "	-- HC
ns.Mythic 			= "|CFFBB8FCE"	-- Mythic
ns.LeftButtonIcon 	= format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_l.tga")
ns.RightButtonIcon 	= format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_r.tga")
ns.MiddleButtonIcon = format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_m.tga")
ns.Config			= {}

local _, unitClass = UnitClass('player')
local class = ElvUF.colors.class[unitClass]
local DT = E:GetModule('DataTexts')

function mMT:AddOptions()
	for _, func in pairs(ns.Config) do
		func()
	end
end

function mMT:Initialize()
	-- WoW Version Check
	mMT:mVersionCheck()
	
	-- Load Miscs
	mMT:mMisc()
	
	local LeftChatPanel = _G.LeftChatPanel
	local RightChatPanel = _G.RightChatPanel

	LeftChatPanel.mBar = CreateFrame("StatusBar", nil, LeftChatPanel)
	LeftChatPanel.mBar:SetFrameStrata("BACKGROUND")
	LeftChatPanel.mBar:SetSize(LeftChatPanel:GetWidth()-2, 12)
	LeftChatPanel.mBar:SetPoint("TOP", LeftChatPanel, "BOTTOM", 0, -2)
	LeftChatPanel.mBar:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag H1"))
	LeftChatPanel.mBar:SetStatusBarColor(class[1], class[2], class[3], .50)
	LeftChatPanel.mBar:CreateBackdrop()
	LeftChatPanel.mBar.backdrop:SetBackdropColor(class[1], class[2], class[3], .50)


	RightChatPanel.mBar = CreateFrame("StatusBar", nil, RightChatPanel)
	RightChatPanel.mBar:SetFrameStrata("BACKGROUND")
	RightChatPanel.mBar:SetSize(RightChatPanel:GetWidth()-2, 12)
	RightChatPanel.mBar:SetPoint("TOP", RightChatPanel, "BOTTOM", 0, -2)
	RightChatPanel.mBar:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag H1"))
	RightChatPanel.mBar:SetStatusBarColor(class[1], class[2], class[3], .50)
	RightChatPanel.mBar:CreateBackdrop()
	RightChatPanel.mBar.backdrop:SetBackdropColor(class[1], class[2], class[3], .50)

	-- count = DT.PanelPool.Count
	--local name = 'ElvUI_DTPanel' .. 8

	local DTPanel = DT:FetchFrame("mActionbarBackground")
	DTPanel.mBar = CreateFrame("StatusBar", nil, DTPanel)
	DTPanel.mBar:SetFrameStrata("BACKGROUND")
	DTPanel.mBar:SetSize(DTPanel:GetWidth()-2, 12)
	DTPanel.mBar:SetPoint("TOP", DTPanel, "BOTTOM", 0, -2)
	DTPanel.mBar:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag H1"))
	DTPanel.mBar:SetStatusBarColor(class[1], class[2], class[3], .50)
	DTPanel.mBar:CreateBackdrop()
	DTPanel.mBar.backdrop:SetBackdropColor(class[1], class[2], class[3], .50)

	EP:RegisterPlugin(addon, mMT:AddOptions())
end

E:RegisterModule(mMT:GetName())