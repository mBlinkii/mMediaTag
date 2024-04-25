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
mMT.ElvUI_JiberishIcons = {}
mMT.DEVNames = {}
mMT.DevMode = false
mMT.CurrentProfile = nil
mMT.firstLoad = 0
mMT.Classes = { "DEATHKNIGHT", "DEMONHUNTER", "DRUID", "EVOKER", "HUNTER", "MAGE", "MONK", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR" }

mMT.Modules.Portraits = {}
mMT.Modules.SummonIcon = {}
mMT.Modules.PhaseIcon = {}
mMT.Modules.ResurrectionIcon = {}
mMT.Modules.ReadyCheckIcons = {}
mMT.Modules.RoleIcons = {}
mMT.Modules.Castbar = {}
mMT.Modules.ImportantSpells = {}
mMT.Modules.InterruptOnCD = {}
mMT.Modules.CosmeticBars = {}
mMT.Modules.QuestIcons = {}
mMT.Modules.ObjectiveTracker = {}
--mMT.Modules.CustomClassColors = {}

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

StaticPopupDialogs["mMT_Reload_Required"] = {
	text = L["Some settings have been changed! For mMediaTag to work properly, a reload of the interface is recommended. Should a reload be performed now?"],
	button1 = L["ReloadUI"],
	button2 = L["Abort"],
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

local function UpdateModuleSettings()
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
	end
end

local function EnableModules()
	-- All Game Versions
	mMT.Modules.ReadyCheckIcons.enable = E.db.mMT.unitframeicons.readycheck.enable
	mMT.Modules.PhaseIcon.enable = E.db.mMT.unitframeicons.phase.enable
	mMT.Modules.ResurrectionIcon.enable = E.db.mMT.unitframeicons.resurrection.enable
	mMT.Modules.SummonIcon.enable = E.db.mMT.unitframeicons.summon.enable
	mMT.Modules.Portraits.enable = E.db.mMT.portraits.general.enable
	mMT.Modules.ImportantSpells.enable = (E.db.mMT.importantspells.enable and (E.db.mMT.importantspells.np or E.db.mMT.importantspells.uf))
	mMT.Modules.CosmeticBars.enable = E.db.mMT.cosmeticbars.enable and not IsAddOnLoaded("ElvUI_NutsAndBolts")
	--mMT.Modules.CustomClassColors.enable = E.db.mMT.classcolors.enable and not (mMT.ElvUI_EltreumUI.gradient or mMT.ElvUI_EltreumUI.dark)

	-- Retail
	if E.Retail then
		mMT.Modules.ObjectiveTracker.enable = E.db.mMT.objectivetracker.enable and (E.private.skins.blizzard.enable and E.private.skins.blizzard.objectiveTracker) and not IsAddOnLoaded("!KalielsTracker")
		mMT.Modules.Castbar.enable = (E.db.mMT.interruptoncd.enable or (E.db.mMT.importantspells.enable and (E.db.mMT.importantspells.np or E.db.mMT.importantspells.uf)) or E.db.mMT.castbarshield.enable)
		mMT.Modules.RoleIcons.enable = E.db.mMT.roleicons.enable
		mMT.Modules.InterruptOnCD.enable = E.db.mMT.interruptoncd.enable
		mMT.Modules.QuestIcons.enable = E.db.mMT.questicons.enable
	end

	-- Wrath
	if E.Retail then
		mMT.Modules.Castbar.enable = (E.db.mMT.interruptoncd.enable or (E.db.mMT.importantspells.enable and (E.db.mMT.importantspells.np or E.db.mMT.importantspells.uf)) or E.db.mMT.castbarshield.enable)
		mMT.Modules.RoleIcons.enable = E.db.mMT.roleicons.enable
	end
end

local function UpdateModules()
	EnableModules()
	local reloadRequired = false
	-- update module settings
	--mMT:Print(" --- UPDATE MODULES --- ")
	-- update every time

	-- check first if is loaded and update this

	-- update all other
	for name, module in pairs(mMT.Modules) do
		if (not module.enable and module.loaded) or module.loaded or module.enable then
			--mMT:Print(name, "Update", module.loaded, "Disable", (not module.enable and module.loaded), "Enable", module.enable)
			if module.Initialize then
				module:Initialize()
			else
				mMT:Print("Module not found:", name, module)
			end

			if module.needReloadUI and ((not module.enable and module.loaded) or (module.loaded and not module.enable)) then
				--mMT:Print("RELOAD REQUIERED")
				reloadRequired = true
			end

			if module.loaded and not module.enable then
				module.loaded = false
			end
		end
	end

	if reloadRequired then
		StaticPopup_Show("mMT_Reload_Required")
	end

	--mMT:Print(" --- END --- ")
end

local function UpdateAllModules()
	UpdateModules()

	--local currentProfile = E.data:GetCurrentProfile()
	--if mMT.CurrentProfile ~= currentProfile then
	--	mMT.CurrentProfile = currentProfile
	--	StaticPopup_Show("mMT_Reload_Required")
	--end
end

-- Load Settings
local function LoadSettings()
	E.Options.name = format("%s + %s %s |cff99ff33%s|r", E.Options.name, mMT.IconSquare, mMT.Name, mMT.Version)

	for _, func in pairs(mMT.Config) do
		func()
	end
end

function mMT:Initialize()
	EP:RegisterPlugin(addonName, LoadSettings)

	-- update defaults
	mMT.ElvUI_EltreumUI = mMT:CheckEltruism()
	mMT.ClassColor = mMT:UpdateClassColor()
	mMT.ElvUI_JiberishIcons = mMT:JiberishIcons()
	mMT.DEVNames = mMT:GetDevNames()
	mMT.Classes = mMT:ClassesTable()

	-- Register Events for Retail
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

		if E.private.nameplates.enable and (E.db.mMT.nameplate.healthmarker.enable or E.db.mMT.nameplate.executemarker.enable) then
			mMT:StartNameplateTools()
		end
	end

	if E.db.mMT.general.emediaenable then
		mMT:SetElvUIMediaColor()
	end

	-- Register Events for all Game Versions
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	if E.db.mMT.afk.enable then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
	end

	-- Modules
	UpdateModuleSettings()
	UpdateModules()

	-- hook ElvUI UpdateAll function
	hooksecurefunc(E, "UpdateAll", UpdateAllModules)

	-- Initialize main things
	tinsert(E.ConfigModeLayouts, "MMEDIATAG")
	E.ConfigModeLocalizedStrings["MMEDIATAG"] = mMT.Name

	mMT.CurrentProfile = E.data:GetCurrentProfile()

	if (E.db.mMT.custombackgrounds.health.enable or E.db.mMT.custombackgrounds.power.enable or E.db.mMT.custombackgrounds.castbar.enable) and not mMT.ElvUI_EltreumUI.dark then
		mMT:CustomBackdrop()
	end

	-- if E.db.mMT.customclasscolors.enable and not (mMT.ElvUI_EltreumUI.gradient or mMT.ElvUI_EltreumUI.dark) then
	-- 	mMT:SetCustomColors()
	-- end

	if E.db.mMT.general.greeting then
		mMT:GreetingText()
	end
end

local function CallbackInitialize()
	mMT:Initialize()
end

function mMT:PLAYER_ENTERING_WORLD(event)
	-- update defaults
	mMT.ElvUI_EltreumUI = mMT:CheckEltruism()
	mMT.ClassColor = mMT:UpdateClassColor()
	mMT.ElvUI_JiberishIcons = mMT:JiberishIcons()
	mMT.DEVNames = mMT:GetDevNames()
	mMT.Classes = mMT:ClassesTable()

	-- Changelog
	if E.db.mMT.version ~= mMT.Version then
		E:ToggleOptions()
		E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "changelog")
		E.db.mMT.version = mMT.Version
	end

	-- ObjectiveTracker DB converter
	if E.db.mMT.objectivetracker.convert < 1 then
		mMT:ConvertDB()
		E.db.mMT.objectivetracker.convert = 1
		mMT:Print(L["The ObjectiveTracker settings have been reset to reflect the latest updates in mMT."])
	end

	-- ImportantSpells DB converter
	if E.db.mMT.importantspells.dbversion < 1 then
		E.db.mMT.importantspells.spells = {}
		E.db.mMT.importantspells.dbversion = 1
		mMT:Print(L["The ImportantSpells IDs and Settings have been reset to reflect the latest updates in mMT."])
	end

	-- DevMode
	if mMT.DB.dev.enabled and mMT.DEVNames[UnitName("player")] then
		mMT:Print("|CFFFFC900DEV - Tools:|r |CFF00E360enabld|r")
		mMT.DevMode = true
		mMT:DevTools()
	else
		mMT.DevMode = false
	end

	-- Modules
	UpdateModuleSettings()
	UpdateModules()

	-- Modules only for Retail
	if E.Retail then
		if E.private.nameplates.enable and E.db.mMT.nameplate.executemarker.auto then
			mMT:updateAutoRange()
		end
	end

	-- Initialize Modules
	if E.db.mMT.tooltip.enable then
		mMT:TipIcon()
	end

	if E.db.mMT.general.emediaenable then
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

	E:Delay(1, collectgarbage, "collect")
end

function mMT:PLAYER_TALENT_UPDATE()
	if mMT.Modules.InterruptOnCD.loaded then
		mMT.Modules.InterruptOnCD:Initialize()
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
