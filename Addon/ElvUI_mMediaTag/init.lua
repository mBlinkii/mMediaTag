local E, _, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

-- Cache WoW Globals
local _G = _G
local format = format
local CreateFrame = CreateFrame
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local C_Timer_After = C_Timer.After

local addonName, Engine = ...
local mMT = E:NewModule("mMediaTag", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

P.mMediaTag = {}

Engine[1] = mMT -- Addon
Engine[2] = {} -- db
Engine[3] = {} -- modules
Engine[4] = E -- ElvUI
Engine[5] = P.mMediaTag -- ElvUI plugin defaults
Engine[6] = LibStub("AceLocale-3.0"):GetLocale("mMediaTag") -- Locales
Engine[7] = {} -- Media
_G[addonName] = Engine

mMT.Version = GetAddOnMetadata(addonName, "Version")
mMT.Name = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r |CFF404040&|r  |CFFFF9D00Tools|r"
mMT.NameShort = "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r"
mMT.IDs = {}
mMT.defaults = {}
mMT.Changelog = {}

function mMT:InsertOptions()
	E.Options.name = format("%s + %s %s |cff99ff33%s|r", E.Options.name, Engine[7].icon16, mMT.NameShort, mMT.Version)
	E.Options.args.mMT = mMT.options
end

local pendingModules, requeueUpdate = 0, false

local function DrainModules()
	pendingModules = 0

	if requeueUpdate then
		requeueUpdate = false
		mMT:UpdateAll()
	end
end

-- Runs inside E:CoroutineUpdate, which swallows errors and would drop the remaining modules - keep the pcall.
local function InitModule(name, module)
	if module.Initialize then
		local ok, err = pcall(module.Initialize, module)
		if not ok then geterrorhandler()(format("mMediaTag - module '%s' failed to initialize:\n%s", name, err)) end
	end

	pendingModules = pendingModules - 1

	-- ElvUI only drops the finished coroutine a tick later, so stay blocked until then
	if pendingModules == 0 then
		pendingModules = -1
		E:Delay(0.1, DrainModules)
	end
end

function mMT:UpdateAll()
	-- CoroutineUpdate silently discards a second run of the same function, so re-arm once the current one drained.
	if pendingModules ~= 0 then
		requeueUpdate = true
		return
	end

	for _ in pairs(Engine[3]) do
		pendingModules = pendingModules + 1
	end

	if E.CoroutineUpdate then
		E:CoroutineUpdate(InitModule, Engine[3], nil, 1)
	else
		for name, module in pairs(Engine[3]) do
			InitModule(name, module)
		end
	end
end

local waitAttempts = 0
local function WaitForElvUI()
	local watcher = E.CoroutineFrame
	if watcher and watcher:IsShown() and waitAttempts < 50 then
		waitAttempts = waitAttempts + 1
		E:Delay(0.1, WaitForElvUI)
	else
		mMT:UpdateAll()
	end
end

-- E:UpdateAll returns before its work is done and keeps queueing coroutines until 0.24s after; only then is E.CoroutineFrame meaningful.
local function DelayedUpdateAll()
	waitAttempts = 0
	E:Delay(0.3, WaitForElvUI)
end

function mMT:Initialize()
	mMT:RegisterEvent("PLAYER_LOGOUT")

	-- E:Initialize() now runs before plugins load, so P.mMediaTag is missing from a fresh profile - only the current session's profile needs this.
	E.db.mMediaTag = E:CopyDefaults(E.db.mMediaTag or {}, P.mMediaTag)

	EP:RegisterPlugin(addonName, mMT.InsertOptions)

	E:CopyTable(Engine[2], mMT.defaults)
	Engine[2] = E:CopyTable(Engine[2], MMTDATA)
	mMT:UpdateDeveloperState()

	if mMT:GetWeeklyResetTime() then Engine[2].keystones = {} end

	if not mMT.ElvUI_Hooked then
		mMT:SecureHook(E, "UpdateAll", DelayedUpdateAll)
		mMT.ElvUI_Hooked = true
	end

	mMT:UpdateMedia()

	if IsAddOnLoaded("ElvUI_JiberishIcons") then mMT:AddJIIcons() end
	if IsAddOnLoaded("Details") then mMT:AddClassIconsToDetails() end

	if Engine[2].DEV then E:Print(format("%s %s", mMT.NameShort, "|cff99ff33DEV mode active|r")) end

	mMT:UpdateAll()

	tinsert(E.ConfigModeLayouts, "MMEDIATAG")
	E.ConfigModeLocalizedStrings["MMEDIATAG"] = mMT.Name

	-- Set default value for spec icons if the user has the old boolean value
	if E.db.mMediaTag.portraits.misc.spec_icon == true or E.db.mMediaTag.portraits.misc.spec_icon == false then E.db.mMediaTag.portraits.misc.spec_icon = "none" end

	C_Timer_After(2, function()
		if E.db.mMediaTag.version ~= mMT.Version then
			E:ToggleOptions('mMT,changelog')
			E.db.mMediaTag.version = mMT.Version
		end
	end)
end

function mMT:PLAYER_LOGOUT()
	MMTDATA = Engine[2]
end
