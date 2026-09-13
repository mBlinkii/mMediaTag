local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:GetModule("CooldownManager")

-- Cache WoW Globals
local _G = _G
local ipairs = ipairs
local pairs = pairs
local format = format
local LibStub = LibStub
local C_Spell_GetSpellInfo = C_Spell.GetSpellInfo
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_AddOns_LoadAddOn = C_AddOns.LoadAddOn

local AceGUI = LibStub("AceGUI-3.0")
local CATEGORY = { ESSENTIAL = 0, UTILITY = 1, TRACKED_BUFF = 2, TRACKED_BAR = 3 }

local panels = {}
local spellIDs = {}
local widgets = { glow = {}, bar = {}, state = {} }

local function AnchorPanel(panel, spellID, hookKey)
	local info = C_Spell_GetSpellInfo(spellID)
	panel:SetTitle(format("%s %s", mMT.NameShort, (info and info.name) or spellID))

	panel.frame:ClearAllPoints()
	local settings = _G.CooldownViewerSettings
	if settings and settings:IsShown() then
		panel.frame:SetPoint("TOPLEFT", settings, "TOPRIGHT", 50, 0)
	else
		panel.frame:SetPoint("CENTER", E.UIParent, "CENTER", 0, 100)
	end

	if settings and not settings[hookKey] then
		settings[hookKey] = true
		settings:HookScript("OnHide", function()
			panel:Hide()
		end)
	end

	local alert = _G.CooldownViewerSettingsEditAlert
	if alert then
		if not alert[hookKey] then
			alert[hookKey] = true
			alert:HookScript("OnShow", function()
				panel:Hide()
			end)
		end
		if alert:IsShown() then alert:Hide() end
	end
end

local function NewPanel(title, height)
	local window = AceGUI:Create("Window")
	window:SetTitle(title)
	window:SetWidth(300)
	window:SetHeight(height)
	window:SetLayout("Flow")
	window:EnableResize(false)
	window.frame:SetFrameStrata("DIALOG")
	window:Hide()
	return window
end

local function HideOthers(keep)
	for key, panel in pairs(panels) do
		if key ~= keep and panel then panel:Hide() end
	end
end

local function ForEachActive(key, callback)
	local viewer = module:GetViewer(key)
	if not viewer or not viewer.itemFramePool then return end

	for frame in viewer.itemFramePool:EnumerateActive() do
		if frame and frame:IsShown() then callback(frame) end
	end
end

local function RefreshBuffIconGlow()
	for _, key in ipairs({ "buff_icon", "buff_bar" }) do
		ForEachActive(key, function(frame)
			module:RefreshGlow(frame)
		end)
	end
end

local function RefreshBarColors()
	local vdb = module:ViewerDB("buff_bar")
	if not vdb then return end

	ForEachActive("buff_bar", function(frame)
		module:ApplyBarStyle(frame, vdb)
	end)
end

local function RefreshActiveState()
	for _, key in ipairs({ "essential", "utility" }) do
		ForEachActive(key, function(frame)
			if frame.GetBaseSpellID then module:ApplyActiveState(frame, frame:GetBaseSpellID()) end
		end)
	end
end

local function GlowDB()
	return spellIDs.glow and module:GetOrCreateSpellGlow(spellIDs.glow)
end

local function BuildGlowPanel()
	local window = NewPanel(format("%s %s", mMT.NameShort, L["Glow Options"]), 340)
	local w = widgets.glow

	local function Add(widget, key)
		window:AddChild(widget)
		w[key] = widget
	end

	local function Slider(label, minimum, maximum, step, key)
		local slider = AceGUI:Create("Slider")
		slider:SetLabel(label)
		slider:SetSliderValues(minimum, maximum, step)
		slider:SetFullWidth(true)
		slider:SetCallback("OnValueChanged", function(_, _, value)
			local db = GlowDB()
			if db then
				db[key] = value
				RefreshBuffIconGlow()
			end
		end)
		Add(slider, key)
	end

	local enable = AceGUI:Create("CheckBox")
	enable:SetLabel(L["Enable Glow"])
	enable:SetFullWidth(true)
	enable:SetCallback("OnValueChanged", function(_, _, value)
		local db = GlowDB()
		if db then
			db.enable = value
			RefreshBuffIconGlow()
		end
	end)
	Add(enable, "enable")

	local style = AceGUI:Create("Dropdown")
	style:SetLabel(L["Type"])
	style:SetList({ pixel = "Pixel", autocast = "Autocast", button = "Button", proc = "Proc" }, { "pixel", "autocast", "button", "proc" })
	style:SetRelativeWidth(0.5)
	style:SetCallback("OnValueChanged", function(_, _, value)
		local db = GlowDB()
		if db then
			db.type = value
			module:UpdateGlowPanel()
			RefreshBuffIconGlow()
		end
	end)
	Add(style, "type")

	local color = AceGUI:Create("ColorPicker")
	color:SetLabel(L["Color"])
	color:SetRelativeWidth(0.5)
	color:SetHasAlpha(true)
	local function colorChanged(_, _, r, g, b, a)
		local db = GlowDB()
		if db then
			db.color.r, db.color.g, db.color.b, db.color.a = r, g, b, a
			RefreshBuffIconGlow()
		end
	end
	color:SetCallback("OnValueChanged", colorChanged)
	color:SetCallback("OnValueConfirmed", colorChanged)
	Add(color, "color")

	Slider(L["Speed"], 0.05, 2, 0.05, "speed")
	Slider(L["Lines"], 1, 20, 1, "lines")
	Slider(L["Thickness"], 1, 8, 1, "thickness")
	Slider(L["Particles"], 1, 16, 1, "particles")
	Slider(L["Scale"], 0.5, 3, 0.1, "scale")

	panels.glow = window
end

function module:UpdateGlowPanel()
	local db = GlowDB()
	if not panels.glow or not db then return end

	local w = widgets.glow
	w.enable:SetValue(db.enable)
	w.type:SetValue(db.type)
	w.color:SetColor(db.color.r, db.color.g, db.color.b, db.color.a or 1)
	w.speed:SetValue(db.speed)
	w.lines:SetValue(db.lines)
	w.thickness:SetValue(db.thickness)
	w.particles:SetValue(db.particles)
	w.scale:SetValue(db.scale)

	w.lines.frame:SetShown(db.type == "pixel")
	w.thickness.frame:SetShown(db.type == "pixel")
	w.particles.frame:SetShown(db.type == "autocast")
	w.scale.frame:SetShown(db.type == "autocast")
	panels.glow:DoLayout()
end

function module:ShowGlowPanel(spellID)
	if not panels.glow then BuildGlowPanel() end
	spellIDs.glow = spellID
	HideOthers("glow")
	AnchorPanel(panels.glow, spellID, "mmtGlowHooked")
	module:UpdateGlowPanel()
	panels.glow:Show()
end

local function BarDB()
	return spellIDs.bar and module:GetOrCreateSpellBarColor(spellIDs.bar)
end

local function BuildBarPanel()
	local window = NewPanel(format("%s %s", mMT.NameShort, L["Bar Colors"]), 180)
	local w = widgets.bar

	local enable = AceGUI:Create("CheckBox")
	enable:SetLabel(L["Enable Custom Colors"])
	enable:SetFullWidth(true)
	enable:SetCallback("OnValueChanged", function(_, _, value)
		local db = BarDB()
		if db then
			db.enable = value
			RefreshBarColors()
		end
	end)
	window:AddChild(enable)
	w.enable = enable

	local foreground = AceGUI:Create("ColorPicker")
	foreground:SetLabel(L["Foreground"])
	foreground:SetRelativeWidth(0.5)
	foreground:SetHasAlpha(false)
	local function fgChanged(_, _, r, g, b)
		local db = BarDB()
		if db then
			db.color.r, db.color.g, db.color.b = r, g, b
			RefreshBarColors()
		end
	end
	foreground:SetCallback("OnValueChanged", fgChanged)
	foreground:SetCallback("OnValueConfirmed", fgChanged)
	window:AddChild(foreground)
	w.color = foreground

	local background = AceGUI:Create("ColorPicker")
	background:SetLabel(L["Background"])
	background:SetRelativeWidth(0.5)
	background:SetHasAlpha(true)
	local function bgChanged(_, _, r, g, b, a)
		local db = BarDB()
		if db then
			db.background.r, db.background.g, db.background.b, db.background.a = r, g, b, a
			RefreshBarColors()
		end
	end
	background:SetCallback("OnValueChanged", bgChanged)
	background:SetCallback("OnValueConfirmed", bgChanged)
	window:AddChild(background)
	w.background = background

	panels.bar = window
end

function module:ShowBarColorPanel(spellID)
	if not panels.bar then BuildBarPanel() end
	spellIDs.bar = spellID
	HideOthers("bar")
	AnchorPanel(panels.bar, spellID, "mmtBarColorHooked")

	local db = BarDB()
	if db then
		widgets.bar.enable:SetValue(db.enable)
		widgets.bar.color:SetColor(db.color.r, db.color.g, db.color.b, 1)
		widgets.bar.background:SetColor(db.background.r, db.background.g, db.background.b, db.background.a or 0.5)
	end

	panels.bar:Show()
end

local function StateDB()
	return spellIDs.state and module:GetOrCreateSpellActiveState(spellIDs.state)
end

local function UpdateStateControls()
	local db = StateDB()
	if not db then return end

	local w = widgets.state
	local custom = db.mode == "custom"
	w.swipe:SetDisabled(not custom)
	w.swipe_color:SetDisabled(not custom or db.swipe ~= "color")
	w.text_color:SetDisabled(not custom)
	w.text_class_color:SetDisabled(not custom)
	w.desaturate:SetDisabled(not custom)
end

local function BuildStatePanel()
	local window = NewPanel(format("%s %s", mMT.NameShort, L["Active State"]), 340)
	local w = widgets.state

	local mode = AceGUI:Create("Dropdown")
	mode:SetLabel(L["Mode"])
	mode:SetList({ default = L["Default"], hide = L["Hide"], custom = L["Customize"] }, { "default", "hide", "custom" })
	mode:SetFullWidth(true)
	mode:SetCallback("OnValueChanged", function(_, _, value)
		local db = StateDB()
		if db then
			db.mode = value
			UpdateStateControls()
			RefreshActiveState()
		end
	end)
	window:AddChild(mode)
	w.mode = mode

	local swipe = AceGUI:Create("Dropdown")
	swipe:SetLabel(L["Swipe"])
	swipe:SetList({ aura = L["Keep"], color = L["Solid Color"], class = L["Class Color"] }, { "aura", "color", "class" })
	swipe:SetFullWidth(true)
	swipe:SetCallback("OnValueChanged", function(_, _, value)
		local db = StateDB()
		if db then
			db.swipe = value
			UpdateStateControls()
			RefreshActiveState()
		end
	end)
	window:AddChild(swipe)
	w.swipe = swipe

	local swipeColor = AceGUI:Create("ColorPicker")
	swipeColor:SetLabel(L["Swipe Color"])
	swipeColor:SetFullWidth(true)
	swipeColor:SetHasAlpha(true)
	local function swipeChanged(_, _, r, g, b, a)
		local db = StateDB()
		if db then
			db.swipe_color.r, db.swipe_color.g, db.swipe_color.b, db.swipe_color.a = r, g, b, a
			RefreshActiveState()
		end
	end
	swipeColor:SetCallback("OnValueChanged", swipeChanged)
	swipeColor:SetCallback("OnValueConfirmed", swipeChanged)
	window:AddChild(swipeColor)
	w.swipe_color = swipeColor

	local textColor = AceGUI:Create("ColorPicker")
	textColor:SetLabel(L["Active Text Color"])
	textColor:SetRelativeWidth(0.6)
	textColor:SetHasAlpha(false)
	local function textChanged(_, _, r, g, b)
		local db = StateDB()
		if db then
			db.text_color.r, db.text_color.g, db.text_color.b = r, g, b
			RefreshActiveState()
		end
	end
	textColor:SetCallback("OnValueChanged", textChanged)
	textColor:SetCallback("OnValueConfirmed", textChanged)
	window:AddChild(textColor)
	w.text_color = textColor

	local textClass = AceGUI:Create("CheckBox")
	textClass:SetLabel(L["Class"])
	textClass:SetRelativeWidth(0.4)
	textClass:SetCallback("OnValueChanged", function(_, _, value)
		local db = StateDB()
		if db then
			db.text_class_color = value
			RefreshActiveState()
		end
	end)
	window:AddChild(textClass)
	w.text_class_color = textClass

	local desaturate = AceGUI:Create("CheckBox")
	desaturate:SetLabel(L["Desaturate icon while active"])
	desaturate:SetFullWidth(true)
	desaturate:SetCallback("OnValueChanged", function(_, _, value)
		local db = StateDB()
		if db then
			db.desaturate = value
			RefreshActiveState()
		end
	end)
	window:AddChild(desaturate)
	w.desaturate = desaturate

	local note = AceGUI:Create("Label")
	note:SetText(mMT:TC(L["The active text color applies only while the buff is running, afterwards the normal cooldown text returns."], "gray"))
	note:SetFullWidth(true)
	window:AddChild(note)

	panels.state = window
end

function module:ShowActiveStatePanel(spellID)
	if not panels.state then BuildStatePanel() end
	spellIDs.state = spellID
	HideOthers("state")
	AnchorPanel(panels.state, spellID, "mmtActiveStateHooked")

	local db = StateDB()
	if db then
		local w = widgets.state
		w.mode:SetValue(db.mode)
		w.swipe:SetValue(db.swipe)
		w.swipe_color:SetColor(db.swipe_color.r, db.swipe_color.g, db.swipe_color.b, db.swipe_color.a or 1)
		w.text_color:SetColor(db.text_color.r, db.text_color.g, db.text_color.b, 1)
		w.text_class_color:SetValue(db.text_class_color)
		w.desaturate:SetValue(db.desaturate)
		UpdateStateControls()
	end

	panels.state:Show()
end

function module:HideSpellPanels()
	HideOthers()
end

function module:RegisterSpellMenu()
	if module.menuRegistered or not _G.Menu then return end
	module.menuRegistered = true

	_G.Menu.ModifyMenu("MENU_COOLDOWN_SETTINGS_ITEM", function(owner, rootDescription)
		if module:IsDisabled() or not owner or not owner.GetCooldownInfo then return end

		local info = owner:GetCooldownInfo()
		local category = info and info.category
		if category ~= CATEGORY.ESSENTIAL and category ~= CATEGORY.UTILITY and category ~= CATEGORY.TRACKED_BUFF and category ~= CATEGORY.TRACKED_BAR then return end

		rootDescription:CreateDivider()
		rootDescription:CreateTitle(format("%s %s", mMT.NameShort, L["Cooldown Manager"]))

		local function AddButton(label, handler)
			rootDescription:CreateButton(label, function()
				local spellID = owner.GetBaseSpellID and owner:GetBaseSpellID()
				if spellID then handler(module, spellID) end
			end)
		end

		if category == CATEGORY.TRACKED_BAR then
			AddButton(L["Bar Colors"], module.ShowBarColorPanel)
			AddButton(L["Glow Options"], module.ShowGlowPanel)
		elseif category == CATEGORY.TRACKED_BUFF then
			AddButton(L["Glow Options"], module.ShowGlowPanel)
		else
			AddButton(L["Active State"], module.ShowActiveStatePanel)
		end
	end)
end

-- 12.1 turned the settings frame into a UIPanel, a bare Show leaves it unregistered and mispositioned
function module:ShowBlizzardSettings()
	if not C_AddOns_IsAddOnLoaded("Blizzard_CooldownViewer") then C_AddOns_LoadAddOn("Blizzard_CooldownViewer") end

	local settings = _G.CooldownViewerSettings
	if not settings or settings:IsShown() then return end

	if settings.ShowUIPanel then
		settings:ShowUIPanel()
	else
		settings:Show()
	end

	module:ScheduleRelayout()
end

function module:HideBlizzardSettings()
	local settings = _G.CooldownViewerSettings
	if not settings or not settings:IsShown() then return end

	if _G.HideUIPanel then
		_G.HideUIPanel(settings)
	else
		settings:Hide()
	end

	module:ScheduleRelayout()
end
