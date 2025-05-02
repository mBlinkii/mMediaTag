local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

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
local SetCVar = SetCVar
local next = next
local wipe = wipe

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

function mMT:SetDebugMode(on, safe)
	local addons = safe and safeAddons or debugAddons
	if on then
		for i = 1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if not addons[name] and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
				DB.debug.disabledAddons[name] = i
			end
		end
		SetCVar("scriptErrors", 1)
		ReloadUI()
	else
		SetCVar("scriptProfile", 0)
		SetCVar("scriptErrors", 0)
		mMT:Print("Lua errors off.")

		if next(DB.debug.disabledAddons) then
			for name in pairs(DB.debug.disabledAddons) do
				EnableAddOn(name, E.myname)
			end
			wipe(DB.debug.disabledAddons)
			ReloadUI()
		end
	end
end

-- Command functions
local function PrintHelp()
	mMT:Print("Available commands:")
	mMT:Print(COLORS.purple:WrapTextInColorCode("/mmt"), COLORS.green:WrapTextInColorCode("help"), "- Show this help message")
	mMT:Print(COLORS.purple:WrapTextInColorCode("/mmt"), COLORS.green:WrapTextInColorCode("version"), "- Show the current version")
	mMT:Print(COLORS.purple:WrapTextInColorCode("/mmt"), COLORS.green:WrapTextInColorCode("debug"), "- Toggle debug mode")
	mMT:Print(COLORS.purple:WrapTextInColorCode("/mmt"), COLORS.green:WrapTextInColorCode("debug safe"), "- Toggle debug mode with safe addons")
end

local function PrintVersion()
	mMT:Print("Version:", COLORS.green:WrapTextInColorCode(mMT.Version))
end

-- Command handler
local function CommandHandler(msg)
	local command = strlower(msg)
	if command == "help" then
		PrintHelp()
	elseif command == "version" then
		PrintVersion()
	elseif command == "debug" or command == "debug safe" then
		DB.debug.debugMode = not DB.debug.debugMode
		mMT:SetDebugMode(DB.debug.debugMode, command == "debug safe")
	else
		if not E:AlertCombat()  then
			E:ToggleOptions("mMT")
			HideUIPanel(_G["GameMenuFrame"])
		end
	end
end

-- Register slash command
SLASH_MMT1 = "/mmt"
SlashCmdList["MMT"] = CommandHandler
