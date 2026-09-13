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
	end

	if event == "UNIT_AURA" and unit ~= "player" then return end
	if event == "SPELL_UPDATE_COOLDOWN" then module:ScheduleCustomUpdate() end
	if event == "UPDATE_BINDINGS" or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" then module:ResetKeybinds() end
	module:ScheduleRelayout()
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
	end

	if viewer.OnAcquireItemFrame then hooksecurefunc(viewer, "OnAcquireItemFrame", function()
		module:ScheduleRelayout()
	end) end

	hooksecurefunc(viewer, "RefreshLayout", function()
		if not module:IsDisabled() then module:LayoutContainer(key, true) end
	end)

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

-- ElvUIs own CDM skin runs after ours and resets the text, so every entry point gets a post hook
local function HookElvUISkins()
	local S = E:GetModule("Skins", true)
	if not S then return end

	if S.CooldownManager_UpdateTextContainer then
		hooksecurefunc(S, "CooldownManager_UpdateTextContainer", function(_, frame)
			local vdb = module:ViewerDB(ResolveViewerKey(frame))
			if vdb then module:ApplyCountText(frame, vdb.count_text) end
		end)
	end

	if S.CooldownManager_SkinIcon then
		hooksecurefunc(S, "CooldownManager_SkinIcon", function(_, frame)
			local vdb = module:ViewerDB(ResolveViewerKey(frame))
			if vdb then module:ApplyTextOverrides(frame, vdb, module:GetDB()) end
		end)
	end

	if S.CooldownManager_SkinBar then
		hooksecurefunc(S, "CooldownManager_SkinBar", function(_, frame)
			if ResolveViewerKey(frame) ~= "buff_bar" then return end
			local vdb = module:ViewerDB("buff_bar")
			if vdb then module:ApplyBarStyle(frame, vdb) end
		end)
	end

	if S.CooldownManager_UpdateTextBar then
		hooksecurefunc(S, "CooldownManager_UpdateTextBar", function(_, bar)
			if ResolveViewerKey(bar:GetParent()) ~= "buff_bar" then return end
			local vdb = module:ViewerDB("buff_bar")
			if not vdb then return end
			module:StyleText(bar.Name, vdb.name_text)
			module:StyleText(bar.Duration, vdb.duration_text)
		end)
	end
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

local function Disable()
	for key in pairs(module.VIEWERS) do
		local container = module.containers[key]
		if container then container:Hide() end
	end

	module:HideBlizzardSettings()
	module:HideSpellPanels()
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

	module.isEnabled = true

	C_Timer_After(0, function()
		for key in pairs(module.VIEWERS) do
			if key ~= "custom" and module:IsManaged(key) then
				module:CreateContainer(key)
				HookViewer(key)
				module:LayoutContainer(key, true)
			end
		end

		module:InitCustomTracker()
		HookElvUISkins()
		module:RegisterSpellMenu()

		-- ElvUIs CooldownUpdate hides the countdown numbers again
		hooksecurefunc(E, "CooldownUpdate", function(_, cooldown)
			if cooldown and cooldown.mmtText then cooldown:SetHideCountdownNumbers(false) end
		end)

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

		local player = _G.ElvUF_Player
		if player then
			hooksecurefunc(player, "SetAlpha", function()
				if module.demoActive then return end

				for key in pairs(module.VIEWERS) do
					local vdb = module:ViewerDB(key)
					if vdb and vdb.visibility == "FADER" then module:UpdateContainerShown(key) end
				end
			end)
		end

		HookConfigNavigation()
	end)
end
