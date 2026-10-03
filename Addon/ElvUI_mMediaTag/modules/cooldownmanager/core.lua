local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:GetModule("CooldownManager")

-- Cache WoW Globals
local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local type = type
local wipe = wipe
local InCombatLockdown = InCombatLockdown
local GetCVarBool = GetCVarBool
local SetCVar = SetCVar
local C_Timer_After = C_Timer.After

local layoutPending = false
local cvarDisabled = false

local function Relayout()
	layoutPending = false
	if module:IsDisabled() then return end

	for key in pairs(module.VIEWERS) do
		if module:IsManaged(key) then module:LayoutContainer(key, false) end
	end
	module:UpdateVisibility()
end

function module:ScheduleRelayout()
	if layoutPending then return end
	layoutPending = true
	C_Timer_After(0, Relayout)
end

local function OnEvent(event, unit, value)
	-- combat sampling below only needs the players own auras
	if event == "UNIT_AURA" and unit ~= "player" then return end

	if event == "CVAR_UPDATE" then
		if unit ~= "cooldownViewerEnabled" then return end

		if value == "0" then
			cvarDisabled = true
			for key in pairs(module.VIEWERS) do
				local container = module.containers[key]
				if container and module.VIEWERS[key].global then container:Hide() end
			end
			mMT:Print(L["The cooldown manager needs Blizzards cooldown viewer. Enable it again under Options > Gameplay Enhancements."])
		else
			cvarDisabled = false
			module:UpdateVisibility()
			module:ScheduleRelayout()
		end
		return
	end

	if cvarDisabled then return end

	-- PLAYER_REGEN does not fire reliably here, so combat is sampled on every event instead
	local inCombat = InCombatLockdown()
	if inCombat ~= module.inCombat then
		module.inCombat = inCombat
		if inCombat then module:SetDemo(false) end
		module:UpdateVisibility()
		-- missing buffs are only readable outside of combat
		module:ScheduleCustomUpdate()
	end

	-- auras and cooldowns only sample combat here, the viewers are relaid by the item show/hide and layout hooks
	if event == "UNIT_AURA" then
		-- missing buffs of the custom tracker, frozen in combat anyway
		if not inCombat then module:ScheduleCustomUpdate() end
		return
	end
	if event == "SPELL_UPDATE_COOLDOWN" then return module:ScheduleCustomUpdate() end

	if event == "UPDATE_BINDINGS" or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" then module:ResetKeybinds() end
	module:ScheduleRelayout()
end

local hookedItems = {}

-- items show and hide on their own when they turn active or inactive, only then the order changes
local function HookItem(item)
	if not item or hookedItems[item] then return end
	hookedItems[item] = true

	item:HookScript("OnShow", function()
		module:ScheduleRelayout()
	end)
	item:HookScript("OnHide", function()
		module:ScheduleRelayout()
	end)
end

-- Only read the pool, releasing or re-acquiring from addon code taints every later EnumerateActive
local function HookViewer(key)
	local viewer = module:GetViewer(key)
	if not viewer or module.hookedViewers[key] then return end
	module.hookedViewers[key] = true

	local container = module.containers[key]
	if container then
		viewer:ClearAllPoints()
		viewer:SetPoint("CENTER", container, "CENTER", 0, 0)
		viewer:SetParent(container)
	end

	if viewer.itemFramePool then
		hooksecurefunc(viewer.itemFramePool, "Acquire", function()
			module:ScheduleRelayout()
		end)
		hooksecurefunc(viewer.itemFramePool, "Release", function()
			module:ScheduleRelayout()
		end)

		for item in viewer.itemFramePool:EnumerateActive() do
			HookItem(item)
		end
	end

	if viewer.OnAcquireItemFrame then hooksecurefunc(viewer, "OnAcquireItemFrame", function(_, item)
		HookItem(item)
		module:ScheduleRelayout()
	end) end

	hooksecurefunc(viewer, "RefreshLayout", function()
		if not module:IsDisabled() then module:LayoutContainer(key, true) end
	end)

	-- the item grid re-runs its own Layout whenever it gets dirty and puts every icon back to Blizzards
	-- spacing (padding minus 4), which makes enlarged icons overlap until the next event, so ours has to follow it
	local itemContainer = viewer.GetItemContainerFrame and viewer:GetItemContainerFrame()
	if itemContainer and itemContainer.Layout then hooksecurefunc(itemContainer, "Layout", function()
		if not module:IsDisabled() then module:LayoutContainer(key, false) end
	end) end

	local selection = viewer.Selection
	if selection then
		selection:Hide()
		selection:SetAlpha(0)
		hooksecurefunc(selection, "Show", function(self)
			self:Hide()
		end)
	end
end

local function ResolveViewerKey(frame)
	if not frame then return nil end

	local key = module.styled[frame] or frame.mmtViewerKey
	if key then return key end

	local parent = frame:GetParent()
	return parent and (module.styled[parent] or parent.mmtViewerKey) or nil
end

-- ElvUIs skin merge (after 15.26) moved the CDM skin functions from S:CooldownManager_* into the skin storage, both layouts are supported
local ELVUI_SKIN_FUNCS = {
	container = { "UpdateTextContainer", "CooldownManager_UpdateTextContainer" },
	icon = { "SkinIcon", "CooldownManager_SkinIcon" },
	bar = { "SkinBar", "CooldownManager_SkinBar" },
	textBar = { "UpdateTextBar", "CooldownManager_UpdateTextBar" },
}

local function HookElvUISkin(S, which, hook)
	local storage = S.addonStorage and S.addonStorage.Blizzard_CooldownViewer
	local data = storage and storage.data
	local names = ELVUI_SKIN_FUNCS[which]

	if data and data[names[1]] then
		hooksecurefunc(data, names[1], hook)
	elseif S[names[2]] then
		hooksecurefunc(S, names[2], hook)
	end
end

-- ElvUIs own CDM skin runs after ours and resets the text, so every entry point gets a post hook
local function HookElvUISkins()
	local S = E:GetModule("Skins", true)
	if not S then return end

	HookElvUISkin(S, "container", function(_, frame)
		local key = ResolveViewerKey(frame)
		local vdb = module:ViewerDB(key)
		if not vdb then return end

		-- on bars the container is the bar icon, its count uses the stacks text
		if key == "buff_bar" then
			if vdb.stacks ~= false then module:ApplyCountText(frame, vdb.stacks_text) end
		else
			module:ApplyCountText(frame, vdb.count_text)
		end
	end)

	HookElvUISkin(S, "icon", function(_, frame)
		local key = ResolveViewerKey(frame)
		if key == "buff_bar" then return end
		local vdb = module:ViewerDB(key)
		if vdb then module:ApplyTextOverrides(frame, vdb, module:GetDB()) end
	end)

	HookElvUISkin(S, "bar", function(_, frame)
		if ResolveViewerKey(frame) ~= "buff_bar" then return end
		local vdb = module:ViewerDB("buff_bar")
		if vdb then module:ApplyBarStyle(frame, vdb) end
	end)

	HookElvUISkin(S, "textBar", function(_, bar)
		if ResolveViewerKey(bar:GetParent()) ~= "buff_bar" then return end
		local vdb = module:ViewerDB("buff_bar")
		if not vdb then return end
		module:StyleText(bar.Name, vdb.name_text)
		module:StyleText(bar.Duration, vdb.duration_text)
	end)
end

local configOpen = false
local hookedConfigFrames = {}

local function HookConfigClose()
	local ACD = E.Libs.AceConfigDialog
	local frame = ACD and ACD.OpenFrames and ACD.OpenFrames.ElvUI
	if not frame or not frame.frame or hookedConfigFrames[frame.frame] then return end

	hookedConfigFrames[frame.frame] = true
	frame.frame:HookScript("OnHide", function()
		configOpen = false
		module:HideBlizzardSettings()
		module:SetDemo(false)
		module:HideSpellPanels()
	end)
end

local function HandleGroupChange(appName, isCDM)
	if appName ~= "ElvUI" then return end
	HookConfigClose()

	if isCDM and not configOpen then
		configOpen = true
		module:ShowBlizzardSettings()
	elseif not isCDM and configOpen then
		configOpen = false
		module:HideBlizzardSettings()
		module:SetDemo(false)
		module:HideSpellPanels()
	end
end

local function HookConfigNavigation()
	local ACD = E.Libs.AceConfigDialog
	if not ACD or module.configHooked then return end
	module.configHooked = true

	hooksecurefunc(ACD, "SelectGroup", function(_, appName, ...)
		local isCDM = false
		for i = 1, select("#", ...) do
			if select(i, ...) == "cooldownmanager" then
				isCDM = true
				break
			end
		end
		HandleGroupChange(appName, isCDM)
	end)

	hooksecurefunc(ACD, "FeedGroup", function(_, appName, _, _, _, path)
		if appName ~= "ElvUI" or type(path) ~= "table" or #path == 0 then return end

		local inAddon, isCDM = false, false
		for i = 1, #path do
			if path[i] == "mMT" then inAddon = true end
			if path[i] == "cooldownmanager" then isCDM = true end
		end

		if inAddon and not isCDM and #path < 2 then return end
		if not inAddon and not configOpen then return end

		HandleGroupChange(appName, isCDM)
	end)
end

function module:Refresh()
	if module:IsDisabled() then return end

	module:RefreshDemo()
	wipe(module.styled)
	module.pandemicVersion = module.pandemicVersion + 1

	for key in pairs(module.VIEWERS) do
		if module:IsManaged(key) then module:LayoutContainer(key, true) end
	end

	module:RefreshCustomTracker()
	module:UpdateVisibility()
end

-- Blizzard's viewers stay parented to our containers until a reload, hiding those would unregister the viewer events
local function Disable()
	local custom = module.containers.custom
	if custom then custom:Hide() end

	module:UnregisterAllEvents()
	module:SetDemo(false)
	module:HideBlizzardSettings()
	module:HideSpellPanels()
	E:StaticPopup_Show("CONFIG_RL")
end

-- Hooks survive a disable, so they are only installed once per session
local function SetupHooks()
	if module.hooksInstalled then return end
	module.hooksInstalled = true

	HookElvUISkins()
	module:RegisterSpellMenu()

	-- ElvUIs CooldownUpdate hides the countdown numbers again
	hooksecurefunc(E, "CooldownUpdate", function(_, cooldown)
		if cooldown and cooldown.mmtText then cooldown:SetHideCountdownNumbers(false) end
	end)

	local player = _G.ElvUF_Player
	if player then
		hooksecurefunc(player, "SetAlpha", function()
			if module.demoActive or module:IsDisabled() then return end

			for key in pairs(module.VIEWERS) do
				local vdb = module:ViewerDB(key)
				if vdb and vdb.visibility == "FADER" then module:UpdateContainerShown(key) end
			end
		end)
	end

	HookConfigNavigation()
end

-- The square ElvUI look of the icons comes from ElvUIs cooldown manager skin, which is off by default. Only that skin is
-- turned on, the main switch for all Blizzard skins stays the users choice. Returns true when a reload is needed.
function module:EnsureElvUISkin()
	local blizzard = E.private.skins and E.private.skins.blizzard
	if not blizzard then return false end

	if not blizzard.enable then
		mMT:Print(L["The mMT cooldown manager needs ElvUIs Blizzard skins for the ElvUI look of its icons, they are turned off under ElvUI > Skins."])
		return false
	end

	if blizzard.cooldownManager then return false end
	blizzard.cooldownManager = true
	return true
end

function module:Initialize()
	if module:IsDisabled() then
		if module.isEnabled then
			module.isEnabled = false
			Disable()
		end
		return
	end

	if module.isEnabled then
		module:Refresh()
		return
	end

	-- The viewers only exist once the CVar was on at load time
	if GetCVarBool("cooldownViewerEnabled") ~= true then
		SetCVar("cooldownViewerEnabled", 1)
		if not _G.EssentialCooldownViewer then
			mMT:Print(L["Blizzards cooldown manager was enabled, a reload is needed."])
			C_Timer_After(1, function()
				E:StaticPopup_Show("CONFIG_RL")
			end)
			return
		end
	end

	if module:EnsureElvUISkin() then
		mMT:Print(L["ElvUIs cooldown manager skin was turned on for the mMT cooldown manager, a reload is needed."])
		C_Timer_After(1, function()
			E:StaticPopup_Show("CONFIG_RL")
		end)
	end

	module.isEnabled = true

	C_Timer_After(0, function()
		-- a profile switch can disable and enable the module again, containers and movers exist only once
		for key in pairs(module.VIEWERS) do
			if key ~= "custom" and module:IsManaged(key) then
				if not module.containers[key] then module:CreateContainer(key) end
				HookViewer(key)
				module:LayoutContainer(key, true)
			end
		end

		module:InitCustomTracker()
		SetupHooks()

		module:RegisterEvent("UNIT_AURA", OnEvent)
		module:RegisterEvent("SPELL_UPDATE_COOLDOWN", OnEvent)
		module:RegisterEvent("SPELLS_CHANGED", OnEvent)
		module:RegisterEvent("UPDATE_BINDINGS", OnEvent)
		module:RegisterEvent("ACTIONBAR_SLOT_CHANGED", OnEvent)
		module:RegisterEvent("ACTIONBAR_PAGE_CHANGED", OnEvent)
		module:RegisterEvent("CVAR_UPDATE", OnEvent)
		module:RegisterEvent("GROUP_ROSTER_UPDATE", function()
			module:UpdateVisibility()
		end)

		module:UpdateVisibility()
	end)
end
