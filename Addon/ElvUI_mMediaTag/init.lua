local E, _, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

local _G = _G
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
mMT.Name = GetAddOnMetadata(addonName, "Title")
mMT.Changelog = {}

media.icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
media.logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"

function mMT:InsertOptions()
    E.Options.name = format("%s + %s %s |cff99ff33%s|r", E.Options.name, media.icon, mMT.Name, mMT.Version)
    E.Options.args.mMT = mMT.options
end

function mMT:Initialize()
	EP:RegisterPlugin(addonName, mMT.InsertOptions)
end

E:RegisterModule(mMT:GetName())
