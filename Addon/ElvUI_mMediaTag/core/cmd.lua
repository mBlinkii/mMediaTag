local mMT, M, F, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local pairs = pairs
local ReloadUI = ReloadUI
local strlower = strlower
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local GetNumAddOns = _G.C_AddOns and _G.C_AddOns.GetNumAddOns or _G.GetNumAddOns
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local EnableAddOn = _G.C_AddOns and _G.C_AddOns.EnableAddOn or _G.EnableAddOn
local DisableAddOn = _G.C_AddOns and _G.C_AddOns.DisableAddOn or _G.DisableAddOn
local GetAddOnInfo = _G.C_AddOns and _G.C_AddOns.GetAddOnInfo or _G.GetAddOnInfo

local debugAddons = {
	["!BugGrabber"] = true,
	["!mMT_MediaPack"] = true,
	["BugSack"] = true,
	["ElvUI"] = true,
	["ElvUI_Libraries"] = true,
	["ElvUI_Options"] = true,
	["ElvUI_mMediaTag"] = true,
}

local safeAddons = {
	["!BugGrabber"] = true,
	["!mMT_MediaPack"] = true,
	["BugSack"] = true,
	["ElvUI"] = true,
	["ElvUI_EltreumUI"] = true,
	["ElvUI_JiberishIcons"] = true,
	["ElvUI_Libraries"] = true,
	["ElvUI_Options"] = true,
	["ElvUI_mMediaTag"] = true,
}

local function SetDebugMode(on, safe)
	local addons = safe and safeAddons or debugAddons
	if on then
		for i = 1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if not addons[name] and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
				mMT.db.global.disabledAddons[name] = i
			end
		end
		SetCVar("scriptErrors", 1)
		ReloadUI()
	elseif not on then
		E:SetCVar("scriptProfile", 0)
		E:SetCVar("scriptErrors", 0)

		if next(mMT.db.global.disabledAddons) then
			for name in pairs(mMT.db.global.disabledAddons) do
				EnableAddOn(name, E.myname)
			end
			wipe(mMT.db.global.disabledAddons)
			ReloadUI()
		end
	end
end

-- Command functions
local function PrintHelp()
	F:Print("Available commands:")
	F:Print(MEDIA.color.purple:WrapTextInColorCode("/mmt"), MEDIA.color.green:WrapTextInColorCode("help"), "- Show this help message")
	F:Print(MEDIA.color.purple:WrapTextInColorCode("/mmt"), MEDIA.color.green:WrapTextInColorCode("version"), "- Show the current version")
	F:Print(MEDIA.color.purple:WrapTextInColorCode("/mmt"), MEDIA.color.green:WrapTextInColorCode("debug"), "- Toggle debug mode")
	F:Print(MEDIA.color.purple:WrapTextInColorCode("/mmt"), MEDIA.color.green:WrapTextInColorCode("debug safe"), "- Toggle debug mode with safe addons")
end

local function PrintVersion()
	F:Print("Version:", MEDIA.color.green:WrapTextInColorCode(mMT.Version))
end

-- Command handler
local function CommandHandler(msg)
	local command = strlower(msg)
	if command == "help" then
		PrintHelp()
	elseif command == "version" then
		PrintVersion()
	elseif command == "debug" or command == "debug safe" then
		F:DebugPrintTable(mMT.db)
		mMT.db.global.debugMode = not mMT.db.global.debugMode
		SetDebugMode(mMT.db.global.debugMode, command == "debug safe")
	else
		if not InCombatLockdown() then
			E:ToggleOptions("mMT")
			HideUIPanel(_G["GameMenuFrame"])
		end
	end
end

-- Register slash command
SLASH_MMT1 = "/mmt"
SlashCmdList["MMT"] = CommandHandler
