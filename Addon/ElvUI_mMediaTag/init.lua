local E = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

-- Addon Name and Namespace
local addonName, addon = ...
mMT = E:NewModule(addonName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

--Cache Lua / WoW API
local _G = _G
local format = format
local GetAddOnMetadata = _G.GetAddOnMetadata
local C_MythicPlus_RequestMapInfo = nil
local C_MythicPlus_RequestCurrentAffixes = nil
local class = E:ClassColor(E.myclass)
local hex = E:RGBToHex(class.r, class.g, class.b)

--Constants
mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF6559F1m|r|CFF7A4DEFM|r|CFF8845ECe|r|CFFA037E9d|r|CFFA435E8i|r|CFFB32DE6a|r|CFFBC26E5T|r|CFFCB1EE3a|r|CFFDD14E0g|r |CFFFF006C&|r |CFFFF4C00T|r|CFFFF7300o|r|CFFFF9300o|r|CFFFFA800l|r|CFFFFC900s|r"
mMT.NameShort = "|CFF6559F1m|r|CFFA037E9M|r|CFFDD14E0T|r"
mMT.DockString = "|CFF2CD204D|r|CFF1BE43Ao|r|CFF10EE5Cc|r|CFF05FA82k|r"
mMT.Icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon_round.tga:14:14|t"
mMT.IconSquare = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t"
mMT.ClassColor = {
	r = class.r,
	g = class.g,
	b = class.b,
	hex = hex,
	string = strjoin("", hex, "%s|r"),
}
mMT.ElvUI_EltreumUI = {
	loaded = IsAddOnLoaded("ElvUI_EltreumUI"),
	gradient = false,
	dark = false,
}
mMT.Media = {}
mMT.Config = {}
mMT.DevMode = false
mMT.DB = {}
mMT.DEVNames = {
	["Blinkii"] = true,
	["Flinkii"] = true,
	["Raeldan"] = true,
}

local defaultDB = {
	mplusaffix = { affixes = nil, season = nil, reset = false, year = nil },
	affix = nil,
	keys = {},
	dev = { enabled = false, frame = { top = nil, left = nil }, unit = {}, zone = {} },
}

local DB_Loader = CreateFrame("FRAME")
DB_Loader:RegisterEvent("PLAYER_LOGOUT")
DB_Loader:RegisterEvent("ADDON_LOADED")

function DB_Loader:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ElvUI_mMediaTag" then
		mMTDB = mMTDB or {}
		mMT.DB = mMTDB
		for k, v in pairs(defaultDB) do
			if mMT.DB[k] == nil then
				mMT.DB[k] = v
			end
		end
	elseif event == "PLAYER_LOGOUT" then
		if mMT.DevMode then
			mMT:SaveFramePos()
			mMT.DB.dev.enabled = mMT.DevMode
		end
		mMTDB = mMT.DB
	end
end

DB_Loader:SetScript("OnEvent", DB_Loader.OnEvent)

if E.Retail then
	C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
	C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes
end

--AddonCompartment
function ElvUI_mMediaTag_OnAddonCompartmentClick()
	E:ToggleOptions("mMT")
end

function ElvUI_mMediaTag_OnAddonCompartmentOnEnter()
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_RIGHT")
	GameTooltip:AddDoubleLine(mMT.Name, format("|CFFF7DC6FVer. %s|r", mMT.Version))
	GameTooltip:Show()
end

function ElvUI_mMediaTag_OnAddonCompartmentOnLeave()
	GameTooltip:Hide()
end

-- Load Settings
local function GetOptions()
	E.Options.name = format("%s + %s %s |cff99ff33%s|r", E.Options.name, mMT.IconSquare, mMT.Name, mMT.Version)

	for _, func in pairs(mMT.Config) do
		func()
	end
end

-- Initialize Addon
function mMT:Initialize()
	if mMT.ElvUI_EltreumUI.loaded then
		mMT.ElvUI_EltreumUI.gradient = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.gradientmode and E.db.ElvUI_EltreumUI.unitframes.gradientmode.enable
		mMT.ElvUI_EltreumUI.dark = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.darkmode
	end

	EP:RegisterPlugin(addonName, GetOptions)
	-- Register Events
	mMT:RegisterEvent("PLAYER_ENTERING_WORLD")

	if E.db.mMT.afk.enable then
		mMT:RegisterEvent("PLAYER_FLAGS_CHANGED")
	end

	-- Initialize main things
	--mMT:LoadCommands()

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

	if E.db.mMT.nameplate.bordercolor.glow or E.db.mMT.nameplate.bordercolor.border then
		mMT:mNamePlateBorderColor()
	end

	if E.db.mMT.unitframeicons.readycheck.enable then
		mMT:SetupReadyCheckIcons()
	end

	if E.db.mMT.unitframeicons.phase.enable then
		mMT:SetupPhaseIcons()
	end

	if E.db.mMT.unitframeicons.resurrection.enable then
		mMT:SetupResurrectionIcon()
	end

	if E.db.mMT.unitframeicons.summon.enable then
		mMT:SetupSummonIcon()
	end

	if (E.db.mMT.custombackgrounds.health.enable or E.db.mMT.custombackgrounds.power.enable or E.db.mMT.custombackgrounds.castbar.enable) and not mMT.ElvUI_EltreumUI.dark then
		mMT:CustomBackdrop()
	end

	if E.Retail then
		if E.db.mMT.interruptoncd.enable or (E.db.mMT.importantspells.enable and (E.db.mMT.importantspells.np or E.db.mMT.importantspells.uf)) or E.db.mMT.castbarshield.enable then
			mMT:CastbarModuleLoader()
		end

		if E.db.mMT.importantspells.enable and (E.db.mMT.importantspells.np or E.db.mMT.importantspells.uf) then
			mMT:UpdateImportantSpells()
		end

		if E.private.nameplates.enable and E.db.mMT.nameplate.healthmarker.enable or E.db.mMT.nameplate.executemarker.enable then
			mMT:StartNameplateTools()
		end

		if E.db.mMT.instancedifficulty.enable then
			mMT:RegisterEvent("UPDATE_INSTANCE_INFO")
			mMT:RegisterEvent("CHALLENGE_MODE_START")
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

		if E.db.mMT.nameplate.executemarker.auto or E.db.mMT.interruptoncd.enable then
			mMT:RegisterEvent("PLAYER_TALENT_UPDATE")
		end

		if (E.db.mMT.objectivetracker.enable or (E.db.mMT.objectivetracker.enable and E.db.mMT.objectivetracker.simple)) and E.private.skins.blizzard.enable and not IsAddOnLoaded("!KalielsTracker") then
			if not E.private.skins.blizzard.objectiveTracker then
				StaticPopupDialogs["mErrorSkin"] = {
					text = L["ElvUI skin must be enabled to activate mMediaTag Quest skins! Should it be enabled?"],
					button1 = L["Yes"],
					button2 = L["No"],
					timeout = 120,
					whileDead = true,
					hideOnEscape = false,
					preferredIndex = 3,
					OnAccept = function()
						E.private.skins.blizzard.objectiveTracker = true
						C_UI.Reload()
					end,
					OnCancel = function()
						E.db.mMT.objectivetracker.enable = false
						C_UI.Reload()
					end,
				}

				StaticPopup_Show("mErrorSkin")
			end

			mMT:InitializemOBT()
		end
	end
end

function mMT:PLAYER_ENTERING_WORLD()
	-- Change Log
	if E.db.mMT.version ~= mMT.Version then
		E:ToggleOptions()
		E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "changelog")
		E.db.mMT.version = mMT.Version
	end

	class = E:ClassColor(E.myclass)
	hex = E:RGBToHex(class.r, class.g, class.b)
	mMT.ClassColor = {
		r = class.r,
		g = class.g,
		b = class.b,
		hex = hex,
		string = strjoin("", hex, "%s|r"),
	}

	if E.Retail then
		C_MythicPlus_RequestMapInfo()
		C_MythicPlus_RequestCurrentAffixes()

		if E.db.mMT.interruptoncd.enable then
			mMT:UpdateInterruptSpell()
		end
	end

	mMT:UpdateDockSettings()
	mMT:UpdateTagSettings()
	mMT:TagDeathCount()

	class = (E.db.mMT.customclasscolors.enable and not mMT:Check_ElvUI_EltreumUI()) and E.db.mMT.customclasscolors.colors[E.myclass] or E:ClassColor(E.myclass)
	hex = E:RGBToHex(class.r, class.g, class.b)

	mMT.ClassColor = {
		r = class.r,
		g = class.g,
		b = class.b,
		hex = hex,
		string = strjoin("", hex, "%s|r"),
	}

	if mMT.DB.dev.enabled and mMT.DEVNames[UnitName("player")] then
		mMT:Print("|CFFFFC900DEV - Tools:|r |CFF00E360enabld|r")
		mMT.DevMode = true
		mMT:DevTools()
	else
		mMT.DevMode = false
	end
end

function mMT:PLAYER_TALENT_UPDATE()
	if E.db.mMT.interruptoncd.enable then
		mMT:UpdateInterruptSpell()
	end

	if E.db.mMT.nameplate.executemarker.auto then
		mMT:updateAutoRange()
	end
end

function mMT:UPDATE_INSTANCE_INFO()
	mMT:UpdateText()
	mMT:TagDeathCount()
end

function mMT:CHALLENGE_MODE_START()
	mMT:UpdateText()
end

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

function mMT:PLAYER_FLAGS_CHANGED(_, unit)
	if E.db.general.afk and unit == "player" and UnitIsAFK(unit) then
		mMT:MaUI_AFKScreen()
	end
end

E:RegisterModule(mMT:GetName())
