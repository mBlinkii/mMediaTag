local E, _, V, P, G = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

-- Addon Name and Namespace
local addonName, addon = ...

local mMT = E:NewModule(addonName, 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceConsole-3.0')

--Cache Lua / WoW API
local _G = _G
local collectgarbage = collectgarbage
local format = format
local hooksecurefunc = hooksecurefunc
local next = next
local print = print
local tonumber = tonumber

local GetAddOnMetadata = _G.GetAddOnMetadata

addon[1] = mMT
addon[2] = E --ElvUI Engine
addon[3] = L --ElvUI Locales
addon[4] = V --ElvUI PrivateDB
addon[5] = P --ElvUI ProfileDB
addon[6] = G --ElvUI GlobalDB
_G[addonName] = addon

--Constants
mMT.Version = GetAddOnMetadata(addonName, 'Version')
mMT.Name = "|CFF6559F1m|r|CFF7A4DEFM|r|CFF8845ECe|r|CFFA037E9d|r|CFFA435E8i|r|CFFB32DE6a|r|CFFBC26E5T|r|CFFCB1EE3a|r|CFFDD14E0g|r"
mMT.Icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon_round.tga:14:14:0:0|t"
mMT.Config = {}

-- Load Settings
local function GetOptions()
	E.Options.name = format('%s + %s |cff99ff33%.2f|r', E.Options.name, mMT.Name, mMT.Version)

	for _, func in pairs(mMT.Config) do
		func()
	end
end

-- Initialize Addon
function mMT:Initialize()
	EP:RegisterPlugin(addonName, GetOptions)

	if E.Retail then
	end

    E:Delay(1, collectgarbage, "collect")
end

function mMT:PLAYER_ENTERING_WORLD()

end

function mMT:ACTIVE_TALENT_GROUP_CHANGED()

end

function mMT:UPDATE_INSTANCE_INFO()

end

function mMT:CHALLENGE_MODE_START()

end

E:RegisterModule(mMT:GetName())