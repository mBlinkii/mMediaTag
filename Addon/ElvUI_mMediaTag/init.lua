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

Engine[1] = mMT
Engine[2] = {}
Engine[3] = {}
Engine[4] = E
Engine[5] = P.mMT
Engine[6] = LibStub("AceLocale-3.0"):GetLocale("mMediaTag")
Engine[7] = {}
_G[addonName] = Engine

Engine[8].icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
Engine[8].icon16 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:16:16|t"
Engine[8].icon32 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:32:32|t"
Engine[8].icon64 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:64:64|t"
Engine[8].logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"

mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r |CFF404040&|r  |CFFFF9D00Tools|r"
mMT.NameShort = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r"
mMT.db = {}
mMT.defaults = {}
mMT.Changelog = {}

function mMT:InsertOptions()
    mMT.db = LibStub("AceDB-3.0"):New("MMTDATA", mMT.defaults, true)
    E.Options.name = format("%s + %s %s|cff99ff33%s|r", E.Options.name, Engine[8].icon16, mMT.NameShort, mMT.Version)
    E.Options.args.mMT = mMT.options
end

function mMT:Initialize()
    EP:RegisterPlugin(addonName, mMT.InsertOptions)
end

E:RegisterModule(mMT:GetName())
