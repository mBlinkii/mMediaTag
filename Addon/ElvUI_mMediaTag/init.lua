local E, _, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

-- Cache WoW Globals
local _G = _G
local format = format
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded

-- Addon Name and Namespace
local addonName, _ = ...
local mMT = E:NewModule(addonName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

local modules = {}
local functions = {}
local media = {}
local db = MMTDATA or {}
local locales = LibStub("AceLocale-3.0"):GetLocale("mMediaTag")

_G[addonName] = {
    mMT,
    db,
    modules,
    functions,
    E,
    P.mMT,
    locales,
    media
}

-- Settings
mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r |CFF404040&|r  |CFFFF9D00Tools|r"
mMT.NameShort = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r"
mMT.Changelog = {}

media.icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
media.icon16 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:16:16|t"
media.icon32 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:32:32|t"
media.icon64 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:64:64|t"
media.logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"

function mMT:InsertOptions()
    E.Options.name = format("%s + %s %s|cff99ff33%s|r", E.Options.name, media.icon16, mMT.NameShort, mMT.Version)
    E.Options.args.mMT = mMT.options
end

function mMT:Initialize()
    EP:RegisterPlugin(addonName, mMT.InsertOptions)
end

E:RegisterModule(mMT:GetName())
