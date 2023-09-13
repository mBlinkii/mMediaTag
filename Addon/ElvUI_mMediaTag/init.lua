local E, _, V, P, G = unpack(ElvUI)

local EP = E.Libs.EP
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local tinsert, type = tinsert, type
local print = print

local collectgarbage = collectgarbage
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata

-- Addon Name and Namespace
local addonName, addon = ...
mMT = E:NewModule(addonName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

-- Settings
mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF6559F1m|r|CFF7A4DEFM|r|CFF8845ECe|r|CFFA037E9d|r|CFFA435E8i|r|CFFB32DE6a|r|CFFBC26E5T|r|CFFCB1EE3a|r|CFFDD14E0g|r |CFFFF006C&|r |CFFFF4C00T|r|CFFFF7300o|r|CFFFF9300o|r|CFFFFA800l|r|CFFFFC900s|r"
mMT.NameShort = "|CFF6559F1m|r|CFFA037E9M|r|CFFDD14E0T|r"
mMT.DockString = "|CFF2CD204D|r|CFF1BE43Ao|r|CFF10EE5Cc|r|CFF05FA82k|r"
mMT.Icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon_round.tga:14:14|t"
mMT.IconSquare = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga:14:14|t"
mMT.Modules = {}
mMT.Media = {}
mMT.Config = {}
mMT.DB = {}
mMT.ClassColor = {}
mMT.ElvUI_EltreumUI = {}
mMT.DEVNames = {}
mMT.DevMode = false

local function UpdateModules()
	-- update module settings
end

-- Load Settings
local function LoadSettings()
	E.Options.name = format("%s + %s %s |cff99ff33%s|r", E.Options.name, mMT.IconSquare, mMT.Name, mMT.Version)

	for _, func in pairs(mMT.Config) do
		func()
	end
end

function mMT:Initialize()
	-- Set DB
	mMT.DB = mMTDB

	EP:RegisterPlugin(addonName, LoadSettings)

	-- Register Events
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	if E.db.mMT.afk.enable then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
	end

	if E.Retail then
		if E.db.mMT.instancedifficulty.enable then
			self:RegisterEvent("UPDATE_INSTANCE_INFO")
			self:RegisterEvent("CHALLENGE_MODE_START")
			self:SetupInstanceDifficulty()
		end

		if E.db.mMT.general.keystochat then
			self:RegisterEvent("CHAT_MSG_PARTY")
			self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
			self:RegisterEvent("CHAT_MSG_RAID")
			self:RegisterEvent("CHAT_MSG_RAID_LEADER")
			self:RegisterEvent("CHAT_MSG_GUILD")
		end

		if (E.private.nameplates.enable and E.db.mMT.nameplate.executemarker.auto) or E.db.mMT.interruptoncd.enable then
			self:RegisterEvent("PLAYER_TALENT_UPDATE")
		end
	end

	-- hook ElvUI UpdateAll function
	hooksecurefunc(E, "UpdateAll", UpdateModules)

	-- Initialize main things
	tinsert(E.ConfigModeLayouts, "MMEDIATAG")
	E.ConfigModeLocalizedStrings["MMEDIATAG"] = mMT.Name
end

local function CallbackInitialize()
	mMT:Initialize()
end

function mMT:PLAYER_ENTERING_WORLD(event)
	-- Set DB
	mMT.DB = mMTDB

	-- update defaults
	mMT.ClassColor = mMT:UpdateClassColor()
	mMT.ElvUI_EltreumUI = mMT:CheckEltruism()
	mMT.DEVNames = mMT:GetDevNames()

	-- Change Log
	if E.db.mMT.version ~= mMT.Version then
		E:ToggleOptions()
		E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "changelog")
		E.db.mMT.version = mMT.Version
	end

	-- DevMode
	if mMT.DB.dev.enabled and mMT.DEVNames[UnitName("player")] then
		mMT:Print("|CFFFFC900DEV - Tools:|r |CFF00E360enabld|r")
		mMT.DevMode = true
		mMT:DevTools()
	else
		mMT.DevMode = false
	end

	--  XXX Change this
	mMT:UpdateDockSettings()
	mMT:UpdateTagSettings()
	mMT:TagDeathCount()

	-- Modules only for Retail
	if E.Retail then
		C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
		C_MythicPlus_RequestCurrentAffixes = C_MythicPlus.RequestCurrentAffixes

		C_MythicPlus_RequestMapInfo()
		C_MythicPlus_RequestCurrentAffixes()

		if E.db.mMT.interruptoncd.enable then
			mMT:UpdateInterruptSpell()
		end

		if E.Retail then
			if E.db.mMT.roleicons.enable then
				mMT:mStartRoleSymbols()
			end

			if E.db.mMT.interruptoncd.enable or (E.db.mMT.importantspells.enable and (E.db.mMT.importantspells.np or E.db.mMT.importantspells.uf)) or E.db.mMT.castbarshield.enable then
				mMT:CastbarModuleLoader()
			end

			if E.db.mMT.importantspells.enable and (E.db.mMT.importantspells.np or E.db.mMT.importantspells.uf) then
				mMT:UpdateImportantSpells()
			end

			if E.private.nameplates.enable and (E.db.mMT.nameplate.healthmarker.enable or E.db.mMT.nameplate.executemarker.enable) then
				mMT:StartNameplateTools()
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

	-- Modules for Wrath
	if E.Wrath then
		if E.db.mMT.roleicons.enable then
			mMT:mStartRoleSymbols()
		end
	end

	-- Modules only for all Game Versions
	if E.db.mMT.portraits.general.enable then
		mMT:UpdatePortraitSettings()
		mMT:SetupPortraits()
	end

	if E.db.mMT.afk.enable then
		mMT:RegisterEvent("PLAYER_FLAGS_CHANGED")
	end

	-- Initialize main things
	tinsert(E.ConfigModeLayouts, "MMEDIATAG")
	E.ConfigModeLocalizedStrings["MMEDIATAG"] = mMT.Name

	-- Initialize Modules
	if E.db.mMT.general.greeting then
		mMT:GreetingText()
	end

	if E.db.mMT.tooltip.enable then
		mMT:TipIcon()
	end

	if E.db.mMT.customclasscolors.enable and not (mMT.ElvUI_EltreumUI.gradient or mMT.ElvUI_EltreumUI.dark) then
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

	if E.private.nameplates.enable and (E.db.mMT.nameplate.bordercolor.glow or E.db.mMT.nameplate.bordercolor.border) then
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

	E:Delay(1, collectgarbage, "collect")
end

function mMT:PLAYER_TALENT_UPDATE()
	if E.db.mMT.interruptoncd.enable then
		mMT:UpdateInterruptSpell()
	end

	if E.private.nameplates.enable and E.db.mMT.nameplate.executemarker.auto then
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
		mMT:mMT_AFKScreen()
	end
end

E:RegisterModule(mMT:GetName(), CallbackInitialize)
