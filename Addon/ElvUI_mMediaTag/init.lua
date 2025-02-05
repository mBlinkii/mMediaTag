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

Engine[1] = mMT     -- Addon
Engine[2] = E:CopyTable({}, mMT.defaults)   -- db
Engine[3] = {}      -- modules
Engine[4] = E       -- ElvUI
Engine[5] = P.mMT   -- ElvUI Profile DB
Engine[6] = LibStub("AceLocale-3.0"):GetLocale("mMediaTag") -- Locales
Engine[7] = {}     -- Media
_G[addonName] = Engine

Engine[7].icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
Engine[7].icon16 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:16:16|t"
Engine[7].icon32 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:32:32|t"
Engine[7].icon64 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:64:64|t"
Engine[7].logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"

mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r |CFF404040&|r  |CFFFF9D00Tools|r"
mMT.NameShort = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r"
mMT.defaults = {}
mMT.Changelog = {}

function mMT:InsertOptions()
    E.Options.name = format("%s + %s %s|cff99ff33%s|r", E.Options.name, Engine[7].icon16, mMT.NameShort, mMT.Version)
    E.Options.args.mMT = mMT.options
end

function mMT:Initialize()
    mMT:RegisterEvent("PLAYER_LOGOUT")

    Engine[2] = E:CopyTable(Engine[2], MMTDATA)

    EP:RegisterPlugin(addonName, mMT.InsertOptions)
end

function mMT:PLAYER_LOGOUT()
    MMTDATA = Engine[2]
end

E:RegisterModule(mMT:GetName())
