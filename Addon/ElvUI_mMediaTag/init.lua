local E, _, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

-- Cache WoW Globals
local _G = _G
local format = format
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded

-- Addon Name and Namespace
local addonName, Engine = ...
local mMT = E:NewModule("mMediaTag", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

P.mMT = {}

Engine[1] = mMT -- Addon
Engine[2] = {} -- db
Engine[3] = {} -- modules
Engine[4] = E -- ElvUI
Engine[5] = P.mMT -- ElvUI plugin defaults
Engine[6] = LibStub("AceLocale-3.0"):GetLocale("mMediaTag") -- Locales
Engine[7] = {} -- Media
_G[addonName] = Engine

mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r |CFF404040&|r  |CFFFF9D00Tools|r"
mMT.NameShort = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r"
mMT.IDs = {}
mMT.defaults = {}
mMT.Changelog = {}

function mMT:InsertOptions()
	E.Options.name = format("%s + %s %s|cff99ff33%s|r", E.Options.name, Engine[7].icon16, mMT.NameShort, mMT.Version)
	E.Options.args.mMT = mMT.options
end

function mMT:UpdateAll()
	for _, module in pairs(Engine[3]) do
		if module.Initialize then module:Initialize() end
	end
end

local function StaggeredUpdateAll()
	E:Delay(1, mMT.UpdateAll)
end

function mMT:Initialize()
	mMT:RegisterEvent("PLAYER_LOGOUT")

	EP:RegisterPlugin(addonName, mMT.InsertOptions)

	E:CopyTable(Engine[2], mMT.defaults)
	Engine[2] = E:CopyTable(Engine[2], MMTDATA)

	if not mMT.ElvUI_Hooked then
		mMT:SecureHook(E, "StaggeredUpdateAll", StaggeredUpdateAll)
		mMT.ElvUI_Hooked = true
	end

	-- build menu frames

	mMT.menu = CreateFrame("Frame", "mMediaTag_Main_Menu_Frame", E.UIParent, "BackdropTemplate")
	mMT.menu:SetTemplate("Transparent", true)

	mMT.submenu = CreateFrame("Frame", "mMediaTag_Submenu_Frame", E.UIParent, "BackdropTemplate")
	mMT.submenu:SetTemplate("Transparent", true)

	mMT:UpdateAll()
	mMT:UpdateMedia()
end

function mMT:PLAYER_LOGOUT()
	MMTDATA = Engine[2]
end

E:RegisterModule(mMT:GetName())
