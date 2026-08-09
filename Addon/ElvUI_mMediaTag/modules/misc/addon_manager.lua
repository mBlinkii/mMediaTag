local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AddonManager", { "AceEvent-3.0" })

local S = E:GetModule("Skins")

-- Cache WoW Globals
local _G = _G
local next = next
local pairs = pairs
local tContains = tContains
local ipairs = ipairs
local sort = sort
local tinsert = tinsert
local strfind = strfind
local strlower = strlower
local strmatch = strmatch
local strtrim = strtrim
local strcmputf8i = strcmputf8i
local format = format
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local CreateTreeDataProvider = CreateTreeDataProvider
local UnitGUID = UnitGUID
local ACCEPT = ACCEPT
local CANCEL = CANCEL
local ALL = ALL
local GetNumAddOns = C_AddOns.GetNumAddOns
local GetAddOnName = C_AddOns.GetAddOnName
local GetAddOnTitle = C_AddOns.GetAddOnTitle
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetAddOnSecurity = C_AddOns.GetAddOnSecurity
local GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local IsAddOnLoadable = C_AddOns.IsAddOnLoadable
local EnableAddOn = C_AddOns.EnableAddOn
local DisableAddOn = C_AddOns.DisableAddOn
local SaveAddOns = C_AddOns.SaveAddOns

module.protected = {
	["!mMT_MediaPack"] = true,
	["ElvUI"] = true,
	["ElvUI_Libraries"] = true,
	["ElvUI_Options"] = true,
	["ElvUI_mMediaTag"] = true,
}

local function Settings()
	return E.db.mMediaTag.addon_manager
end

-- nil targets every character, matching Blizzard's "All" entry in the AddonList dropdown
local function GetCharacter()
	return Settings().account and nil or UnitGUID("player")
end

local function IsEnabled(index, character)
	return GetAddOnEnableState(index, character) > Enum.AddOnEnableState.None
end

local function SetState(index, character, enable)
	if enable then
		if AddOnUtil and AddOnUtil.SetEnableStateForAddOnAndDependencies then
			AddOnUtil.SetEnableStateForAddOnAndDependencies(index, character, true)
		else
			EnableAddOn(index, character)
		end
	else
		DisableAddOn(index, character)
	end
end

-- Blizzard drops its secure addons into a hardcoded "Uncategorized" group, mirrored here so the filtered list keeps the same shape
local function GetCategory(index)
	local category = GetAddOnMetadata(index, "Category")
	if not category and GetAddOnSecurity(index) == "SECURE" then category = "Uncategorized" end
	return category
end

function module:GetProfileNames()
	local names = {}
	for name in pairs(DB.addon_manager.profiles) do
		tinsert(names, name)
	end
	sort(names)
	return names
end

function module:GetCategoryNames()
	local seen, names = {}, {}
	for i = 1, GetNumAddOns() do
		local category = GetCategory(i)
		if category and not seen[category] then
			seen[category] = true
			tinsert(names, category)
		end
	end
	sort(names)
	return names
end

function module:GetCurrentSet()
	local character, set = GetCharacter(), {}
	for i = 1, GetNumAddOns() do
		if IsEnabled(i, character) then set[GetAddOnName(i)] = true end
	end
	return set
end

local function ReportBrokenDependencies()
	local character = GetCharacter()
	local broken
	for i = 1, GetNumAddOns() do
		local _, reason = IsAddOnLoadable(i, character)
		if reason == "DEP_DISABLED" then broken = broken and format("%s, %s", broken, GetAddOnName(i)) or GetAddOnName(i) end
	end

	if broken then mMT:Print(L["Addons with disabled dependencies:"], mMT:TC(broken, "yellow")) end
end

function module:SaveProfile(name)
	name = name and strtrim(name) or ""
	if name == "" then return end

	DB.addon_manager.profiles[name] = module:GetCurrentSet()
	DB.addon_manager.last = name
	mMT:Print(L["Addon profile saved:"], mMT:TC(name, "green"))
	module:UpdateBar()
end

function module:DeleteProfile(name)
	if not DB.addon_manager.profiles[name] then return end

	DB.addon_manager.profiles[name] = nil
	if DB.addon_manager.last == name then DB.addon_manager.last = nil end
	module:UpdateBar()
end

function module:ApplyProfile(name)
	local profile = DB.addon_manager.profiles[name]
	if not profile then return end

	local character, protect = GetCharacter(), Settings().protect
	for i = 1, GetNumAddOns() do
		local addon = GetAddOnName(i)
		SetState(i, character, profile[addon] or (protect and module.protected[addon]) or false)
	end

	DB.addon_manager.last = name
	ReportBrokenDependencies()

	-- while the AddonList is open its Okay/Cancel buttons own the save, writing here would break Cancel
	if _G.AddonList and _G.AddonList:IsShown() then
		_G.AddonList_Update()
	else
		SaveAddOns()
		E:StaticPopup_Show("CONFIG_RL")
	end

	module:UpdateBar()
end

local function SortNodes(aNode, bNode)
	local a, b = aNode:GetData(), bNode:GetData()
	if a.category and b.category then
		return strcmputf8i(a.category, b.category) < 0
	elseif a.addonIndex and b.addonIndex then
		return a.addonIndex < b.addonIndex
	end
	return a.category ~= nil
end

local function ShouldOverride()
	return DB.addon_manager.filter ~= "all"
end

-- Blizzard rebuilds the tree from scratch in AddonList_Update, so the own filter has to replace the provider afterwards
local function RebuildList()
	local AddonList = _G.AddonList
	local character = GetCharacter()
	local wanted = strmatch(DB.addon_manager.filter, "^cat:(.+)$")
	local status = not wanted and DB.addon_manager.filter or "all"
	local search = strlower(AddonList.SearchBox:GetText() or "")
	local provider = CreateTreeDataProvider()
	local nodes = {}

	for i = 1, GetNumAddOns() do
		local name = GetAddOnName(i)
		local title = GetAddOnTitle(i) or name
		local category = GetCategory(i)
		local enabled = IsEnabled(i, character)
		local match = search == "" or strfind(strlower(title), search, 1, true) or strfind(strlower(name), search, 1, true)

		if match and (status == "all" or (status == "enabled") == enabled) and (not wanted or category == wanted) then
			if category then
				local node = nodes[category]
				if not node then
					node = provider:Insert({ category = category })
					node:SetCollapsed(_G.g_addonCategoriesCollapsed and _G.g_addonCategoriesCollapsed[category])
					nodes[category] = node
				end
				node:Insert({ addonIndex = i })
			else
				provider:Insert({ addonIndex = i })
			end
		end
	end

	provider:SetSortComparator(SortNodes)
	AddonList.ScrollBox:SetDataProvider(provider, ScrollBoxConstants.RetainScrollPosition)
end

E.PopupDialogs.MMT_ADDON_PROFILE_SAVE = {
	text = L["Name of the addon profile:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	editBoxWidth = 260,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	-- ElvUIStaticPopupTemplate blanks Blizzard's OnLoad, so the popup never gets its DIALOG strata and stays behind the AddonList (HIGH)
	OnShow = function(self, data)
		self:SetFrameStrata("FULLSCREEN_DIALOG")
		self.editBox:SetText(data or "")
		self.editBox:SetFocus()
	end,
	OnHide = function(self)
		self:SetFrameStrata("DIALOG")
	end,
	OnAccept = function(self)
		module:SaveProfile(self.editBox:GetText())
	end,
	EditBoxOnEnterPressed = function(self)
		module:SaveProfile(self:GetText())
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
}

local function IsProfileSelected(name)
	return DB.addon_manager.last == name
end

local function IsFilterSelected(value)
	return DB.addon_manager.filter == value
end

local function SetFilter(value)
	DB.addon_manager.filter = value
	if _G.AddonList:IsShown() then _G.AddonList_Update() end
end

local function GenerateProfileMenu(_, rootDescription)
	rootDescription:SetTag("MENU_MMT_ADDON_PROFILES")
	rootDescription:CreateTitle(format("%s %s", MEDIA.icon16, L["Addon Profiles"]))

	local profiles = module:GetProfileNames()
	for _, name in ipairs(profiles) do
		rootDescription:CreateRadio(name, IsProfileSelected, function()
			module:ApplyProfile(name)
		end, name)
	end

	rootDescription:CreateDivider()
	rootDescription:CreateButton(L["Save Current State"], function()
		E:StaticPopup_Show("MMT_ADDON_PROFILE_SAVE", nil, nil, DB.addon_manager.last)
	end)

	if next(profiles) then
		local delete = rootDescription:CreateButton(L["Delete Profile"])
		for _, name in ipairs(profiles) do
			delete:CreateButton(name, function()
				module:DeleteProfile(name)
			end)
		end
	end

	rootDescription:CreateDivider()
	rootDescription:CreateButton(L["Settings"], function()
		E:ToggleOptions("mMT,misc,addon_manager")
	end)
end

local function GenerateFilterMenu(_, rootDescription)
	rootDescription:SetTag("MENU_MMT_ADDON_FILTER")
	rootDescription:CreateRadio(ALL, IsFilterSelected, SetFilter, "all")
	rootDescription:CreateRadio(L["Enabled"], IsFilterSelected, SetFilter, "enabled")
	rootDescription:CreateRadio(L["Disabled"], IsFilterSelected, SetFilter, "disabled")

	local categories = module:GetCategoryNames()
	if next(categories) then
		rootDescription:CreateDivider()
		local category = rootDescription:CreateButton(L["Category"])
		for _, name in ipairs(categories) do
			category:CreateRadio(name, IsFilterSelected, SetFilter, format("cat:%s", name))
		end
	end
end

-- without an own selection text the buttons would concatenate every selected radio, submenus included
local function ProfileText()
	return DB.addon_manager.last or L["Addon Profiles"]
end

local function FilterText()
	local filter = DB.addon_manager.filter
	return strmatch(filter, "^cat:(.+)$") or (filter == "enabled" and L["Enabled"]) or (filter == "disabled" and L["Disabled"]) or L["Filter"]
end

function module:UpdateBar()
	if not module.bar then return end

	-- a saved category filter goes stale as soon as the last addon of that category is gone
	local category = strmatch(DB.addon_manager.filter, "^cat:(.+)$")
	if category and not tContains(module:GetCategoryNames(), category) then DB.addon_manager.filter = "all" end

	module.protectCheck:SetChecked(Settings().protect)
	module.accountCheck:SetChecked(Settings().account)
	module.profileDropdown:GenerateMenu()
	module.filterDropdown:GenerateMenu()
end

local function CreateDropdown(bar, name, width, selectionText, generator)
	local dropdown = CreateFrame("DropdownButton", name, bar, "WowStyle1DropdownTemplate")
	dropdown:Height(22)
	dropdown:SetSelectionText(selectionText)
	dropdown:SetupMenu(generator)
	S:HandleDropDownBox(dropdown, width)

	return dropdown
end

local function CreateCheckBox(bar, key, label, tooltip)
	local check = CreateFrame("CheckButton", nil, bar, "UICheckButtonTemplate")
	S:HandleCheckBox(check)
	check:Size(22)

	check:SetScript("OnClick", function(self)
		Settings()[key] = self:GetChecked() and true or false
		if _G.AddonList:IsShown() then _G.AddonList_Update() end
	end)

	check:SetScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_TOP")
		_G.GameTooltip:AddLine(label, mMT:GetRGB("title"))
		_G.GameTooltip:AddLine(tooltip, mMT:GetRGB("tip"), true)
		_G.GameTooltip:Show()
	end)

	check:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	check.label = bar:CreateFontString(nil, "OVERLAY")
	check.label:FontTemplate(nil, 12)
	check.label:SetText(label)

	return check
end

local function CreateBar()
	local AddonList = _G.AddonList

	local bar = CreateFrame("Frame", "mMediaTag_AddonManagerBar", AddonList, "BackdropTemplate")
	bar:Point("TOPLEFT", AddonList, "BOTTOMLEFT", 0, -2)
	bar:Point("TOPRIGHT", AddonList, "BOTTOMRIGHT", 0, -2)
	bar:Height(32)
	bar:SetTemplate("Transparent")
	module.bar = bar

	module.profileDropdown = CreateDropdown(bar, "mMediaTag_AddonProfileDropdown", 140, ProfileText, GenerateProfileMenu)
	module.profileDropdown:Point("LEFT", bar, "LEFT", 8, 0)

	module.filterDropdown = CreateDropdown(bar, "mMediaTag_AddonFilterDropdown", 130, FilterText, GenerateFilterMenu)
	module.filterDropdown:Point("LEFT", module.profileDropdown, "RIGHT", 6, 0)

	module.accountCheck = CreateCheckBox(bar, "account", L["All Characters"], L["Apply profiles account wide instead of only to the current character."])
	module.accountCheck.label:Point("RIGHT", bar, "RIGHT", -8, 0)
	module.accountCheck:Point("RIGHT", module.accountCheck.label, "LEFT", -2, 0)

	module.protectCheck = CreateCheckBox(bar, "protect", L["Protect ElvUI & mMT"], L["Never disable ElvUI, its libraries and mMediaTag when a profile is applied."])
	module.protectCheck.label:Point("RIGHT", module.accountCheck, "LEFT", -12, 0)
	module.protectCheck:Point("RIGHT", module.protectCheck.label, "LEFT", -2, 0)

	hooksecurefunc("AddonList_Update", function()
		if module.isEnabled and ShouldOverride() then RebuildList() end
	end)
end

function module:ADDON_LOADED(_, addon)
	if addon ~= "Blizzard_AddOnList" then return end

	module:UnregisterEvent("ADDON_LOADED")
	module:Initialize()
end

function module:Initialize()
	if not E.Retail then return end

	module.isEnabled = E.db.mMediaTag.addon_manager.enable

	if not module.isEnabled then
		if module.bar then module.bar:Hide() end
		if _G.AddonList and _G.AddonList:IsShown() then _G.AddonList_Update() end
		return
	end

	if not _G.AddonList then
		module:RegisterEvent("ADDON_LOADED")
		return
	end

	if not module.bar then CreateBar() end

	module.bar:Show()
	module:UpdateBar()
end
