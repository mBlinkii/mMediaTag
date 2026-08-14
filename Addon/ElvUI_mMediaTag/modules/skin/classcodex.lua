local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ClassCodexSkin")

local S = E:GetModule("Skins")

-- Cache WoW Globals
local _G = _G
local ipairs = ipairs
local select = select
local unpack = unpack
local C_Timer = C_Timer
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local COMPENDIUM_TABS = 6
local SWEEP_DELAY = 0.05
local WATCH_INTERVAL = 1

local function Apply(handler, ...)
	for i = 1, select("#", ...) do
		local frame = select(i, ...)
		if frame then handler(S, frame) end
	end
end

-- a DropdownButton does not report its own object type, so match ElvUI's own test: an arrow plus the menu mixin
local function IsDropDown(frame)
	return frame.Arrow and frame.SetupMenu and true
end

-- HandleDropDownBox adds its arrow on every call and forces its own default width, ClassCodex lays the dropdown rows out itself
local function SkinDropDown(dropdown)
	if dropdown.mmt_skinned then return end
	dropdown.mmt_skinned = true

	local width = dropdown:GetWidth()
	S:HandleDropDownBox(dropdown, (width and width > 0) and width or nil)
end

-- ClassCodex repaints its backdrop colors on every state change, so translate them onto the ElvUI backdrop
local function BorderColorProxy(frame, r, g, b, a)
	local backdrop = frame.backdrop
	if not backdrop then return end

	if not (r and g and b) then
		backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	elseif r > 0.9 and g > 0.7 and b < 0.2 then
		backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) -- gold marks the active tab
	elseif r < 0.5 and g > 0.6 and b < 0.5 then
		backdrop:SetBackdropBorderColor(r, g, b, a) -- green marks a row that matches your gear, keep the signal
	else
		backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
end

local function SkinBackdrop(frame, template)
	if frame.mmt_skinned then return end
	frame.mmt_skinned = true

	frame:SetBackdrop(nil)
	frame:CreateBackdrop(template or "Transparent")
	frame.SetBackdropColor = E.noop
	frame.SetBackdropBorderColor = BorderColorProxy
end

-- side tabs, section headers, list rows and the per tab dropdowns are built on demand, so walk the tree instead of naming them
local function SweepFrames(frame)
	for _, child in ipairs({ frame:GetChildren() }) do
		if child ~= frame.backdrop then
			if IsDropDown(child) then
				SkinDropDown(child)
			elseif child.GetBackdrop and child:GetBackdrop() then
				SkinBackdrop(child)
			end

			SweepFrames(child)
		end
	end
end

local function Sweep()
	module.sweepPending = nil

	local panel = _G.ClassCodexPanel
	if panel then SweepFrames(panel) end

	local compendium = _G.ClassCodexCompendium
	if compendium then SweepFrames(compendium) end
end

local function ScheduleSweep()
	if module.sweepPending then return end

	module.sweepPending = true
	E:Delay(SWEEP_DELAY, Sweep)
end

local function SkinPanel()
	local panel = _G.ClassCodexPanel
	if module.panelSkinned or not panel then return end

	module.panelSkinned = true

	panel:SetBackdrop(nil)
	panel:SetTemplate("Transparent")
	panel:HookScript("OnShow", ScheduleSweep)
	panel:HookScript("OnSizeChanged", ScheduleSweep) -- the panel is resized on every content relayout

	ScheduleSweep()
end

local function SkinCompendium()
	local frame = _G.ClassCodexCompendium
	if module.compendiumSkinned or not frame then return end

	module.compendiumSkinned = true

	S:HandlePortraitFrame(frame)

	for i = 1, COMPENDIUM_TABS do
		Apply(S.HandleTab, _G["ClassCodexCompendiumTab" .. i])
	end

	local scroll = _G.ClassCodexCompendiumScroll
	if scroll then
		Apply(S.HandleScrollBar, scroll.ScrollBar or _G.ClassCodexCompendiumScrollScrollBar)

		local child = scroll:GetScrollChild()
		if child then child:HookScript("OnSizeChanged", ScheduleSweep) end
	end

	frame:HookScript("OnShow", ScheduleSweep)
	ScheduleSweep()
end

local function SkinSaveAsPopup()
	local popup = _G.ClassCodexSaveAsLoadoutPopup
	if module.popupSkinned or not popup then return end

	module.popupSkinned = true

	popup:SetBackdrop(nil)
	popup:SetTemplate("Transparent")

	for _, child in ipairs({ popup:GetChildren() }) do
		if child:IsObjectType("EditBox") then
			S:HandleEditBox(child)
		elseif child:IsObjectType("Button") then
			S:HandleButton(child)
		end
	end
end

local function SkinTalentWidget()
	local container = _G.ClassCodexTalentIconContainer
	if module.talentSkinned or not container then return end

	module.talentSkinned = true

	container:StripTextures() -- the rounded Toast-Background atlas
	container:CreateBackdrop("Transparent")
	SweepFrames(container)

	local icon = _G.ClassCodexTalentIcon
	if icon and icon.icon then S:HandleIcon(icon.icon, true) end
end

local function SkinDock()
	local dock = _G.ClassCodexLoadoutDock
	if module.dockSkinned or not dock then return end

	module.dockSkinned = true
	SkinBackdrop(dock)
end

-- compendium, loadout prompt, talent pane widget and dock are built on first use, none of them behind a hookable trigger
local function WatchLazyFrames()
	SkinCompendium()
	SkinSaveAsPopup()
	SkinTalentWidget()
	SkinDock()

	if module.watcher and module.compendiumSkinned and module.popupSkinned and module.talentSkinned and module.dockSkinned then
		module.watcher:Cancel()
		module.watcher = nil
	end
end

function module:Initialize()
	module.db = E.db.mMediaTag.skins.classcodex

	if not (module.db and module.db.enable) or module.isRegistered or not IsAddOnLoaded("ClassCodex") then return end

	module.isRegistered = true

	SkinPanel()
	WatchLazyFrames()

	if not (module.compendiumSkinned and module.popupSkinned and module.talentSkinned and module.dockSkinned) then
		module.watcher = C_Timer.NewTicker(WATCH_INTERVAL, WatchLazyFrames)
	end
end
