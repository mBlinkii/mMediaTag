local E, _, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

-- Cache WoW Globals
local _G = _G
local format = format
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded

-- Addon Name and Namespace
local addonName, Engine = ...
local mMT = E:NewModule(addonName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

P.mMT = {}

Engine[1] = mMT -- Addon
Engine[2] = {} -- db
Engine[3] = {} -- modules
Engine[4] = E -- ElvUI
Engine[5] = P.mMT -- ElvUI Profile defaults
Engine[6] = LibStub("AceLocale-3.0"):GetLocale("mMediaTag") -- Locales
Engine[7] = {} -- Media
_G[addonName] = Engine

local media = Engine[7]
media.icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
media.icon16 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:16:16|t"
media.icon32 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:32:32|t"
media.icon64 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:64:64|t"
media.logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"

mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r |CFF404040&|r  |CFFFF9D00Tools|r"
mMT.NameShort = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r"
mMT.defaults = {}
mMT.Changelog = {}

function mMT:InsertOptions()
	E.Options.name = format("%s + %s %s|cff99ff33%s|r", E.Options.name, media.icon16, mMT.NameShort, mMT.Version)
	E.Options.args.mMT = mMT.options
end

function mMT:Update()
	for _, module in pairs(Engine[3]) do
		if module.Initialize then module:Initialize() end
	end
end

function mMT:Initialize()
	mMT:RegisterEvent("PLAYER_LOGOUT")

	EP:RegisterPlugin(addonName, mMT.InsertOptions)

    E:CopyTable(Engine[2], mMT.defaults)
	Engine[2] = E:CopyTable(Engine[2], MMTDATA)

	mMT:Update()

	mMT:Print("JOO")
end

function mMT:PLAYER_LOGOUT()
	MMTDATA = Engine[2]
end

E:RegisterModule(mMT:GetName())
