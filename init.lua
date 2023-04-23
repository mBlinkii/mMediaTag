local E, _, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

-- Addon Name and Namespace
local addonName, addon = ...

local mMT = E:NewModule(addonName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

--Cache Lua / WoW API
local _G = _G
local collectgarbage = collectgarbage
local format = format
local hooksecurefunc = hooksecurefunc
local next = next
local print = print
local tonumber = tonumber

local GetAddOnMetadata = _G.GetAddOnMetadata
local C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
local C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes
local _, unitClass = UnitClass("player")
local class = ElvUF.colors.class[unitClass]

addon[1] = mMT
addon[2] = E --ElvUI Engine
addon[3] = L --ElvUI Locales
addon[4] = V --ElvUI PrivateDB
addon[5] = P --ElvUI ProfileDB
addon[6] = G --ElvUI GlobalDB
_G[addonName] = addon

--Constants
mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name =
	"|CFF6559F1m|r|CFF7A4DEFM|r|CFF8845ECe|r|CFFA037E9d|r|CFFA435E8i|r|CFFB32DE6a|r|CFFBC26E5T|r|CFFCB1EE3a|r|CFFDD14E0g|r"
mMT.Icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon_round.tga:14:14:0:0|t"
mMT.ClassColor = {
	r = class[1],
	g = class[2],
	b = class[3],
	hex = E:RGBToHex(class[1], class[2], class[3]),
	string = strjoin("", E:RGBToHex(class[1], class[2], class[3]), "%s|r"),
}
mMT.Media = {}
mMT.Config = {}

-- Load Settings
local function GetOptions()
	E.Options.name = format("%s + %s |cff99ff33%.2f|r", E.Options.name, mMT.Name, mMT.Version)

	for _, func in pairs(mMT.Config) do
		func()
	end
end

-- Initialize Addon
function mMT:Initialize()
	EP:RegisterPlugin(addonName, GetOptions)

	-- Register Events
	mMT:RegisterEvent("PLAYER_ENTERING_WORLD")
	mMT:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

	-- Initialize main things
	mMT:LoadCommands()

	-- Initialize Modules
	if E.db.mMT.general.greeting then
		mMT:GreetingText()
	end

	if E.db.mMT.tooltip.enable then
		mMT:TipIcon()
	end

	if E.db.mMT.customclasscolors.enable and not mMT:Check_ElvUI_EltreumUI() then
		mMT:SetCustomColors()
	end

	if E.db.mMT.customclasscolors.emediaenable then
		mMT:SetElvUIMediaColor()
	end

	if E.db.mMT.roll.enable then
		mMT:mRoll()
	end

	if E.db.mMT.chat.enable then
		mMT:mChat()
	end

	if E.Retail then
		if E.db.mMT.interruptoncd.enable then
			mMT:mSetupCastbar()
		end

		if E.db.mMT.custombackgrounds.health.enable or E.db.mMT.custombackgrounds.power.enable or E.db.mMT.custombackgrounds.castbar.enable then
			mMT:CustomBackdrop()
		end

		if E.db.mMT.instancedifficulty.enable then
			mMT:SetupInstanceDifficulty()
		end

		if E.db.mMT.roleicons.enable then
			mMT:mStartRoleSmbols()
		end

		if E.db.mMT.general.keystochat then
			mMT:RegisterEvent("CHAT_MSG_PARTY")
			mMT:RegisterEvent("CHAT_MSG_PARTY_LEADER")
			mMT:RegisterEvent("CHAT_MSG_RAID")
			mMT:RegisterEvent("CHAT_MSG_RAID_LEADER")
			mMT:RegisterEvent("CHAT_MSG_GUILD")
		end
	end
end

function mMT:PLAYER_ENTERING_WORLD()
	mMT.ClassColor = {
		r = class[1],
		g = class[2],
		b = class[3],
		hex = E:RGBToHex(class[1], class[2], class[3]),
		string = strjoin("", E:RGBToHex(class[1], class[2], class[3]), "%s|r"),
	}

	if E.Retail then
		C_MythicPlus_RequestMapInfo()
		C_MythicPlus_RequestCurrentAffixes()
	end
end

function mMT:ACTIVE_TALENT_GROUP_CHANGED()
	if E.db.mMT.interruptoncd.enable then
		mMT:UpdateInterruptSpell()
	end
end

function mMT:UPDATE_INSTANCE_INFO() end

function mMT:CHALLENGE_MODE_START() end

function mMT:CHAT_MSG_PARTY(event, text)
	mMT:GetKey("PARTY", text)
end
function mMT:CHAT_MSG_PARTY_LEADER(event, text)
	mMT:GetKey("PARTY", text)
end
function mMT:CHAT_MSG_RAID(event, text)
	mMT:GetKey("RAID", text)
end

function mMT:CHAT_MSG_RAID_LEADER(event, text)
	mMT:GetKey("RAID", text)
end
function mMT:CHAT_MSG_GUILD(event, text)
	mMT:GetKey("GUILD", text)
end

E:RegisterModule(mMT:GetName())
