local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("PremadeGroupsFilterSkin")

local S = E:GetModule("Skins")

-- Cache WoW Globals
local _G = _G
local ipairs = ipairs
local pairs = pairs
local select = select
local unpack = unpack
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local DROPDOWN_WIDTH = 145
local MENU_ALPHA = 0.25

local function Apply(handler, ...)
	for i = 1, select("#", ...) do
		local frame = select(i, ...)
		if frame then handler(S, frame) end
	end
end

-- PGF keeps the classic three slice dropdown art, which is what ElvUI's legacy path expects
local function SkinDropDown(dropdown)
	S:HandleDropDownBox(dropdown, DROPDOWN_WIDTH, nil, true)
end

-- the mini panel reuses this key for a plain edit box, the filter panels for a scrolling one
local function SkinExpression(frame)
	if frame:IsObjectType("EditBox") then
		S:HandleEditBox(frame)
		return
	end

	frame:StripTextures()

	if not frame.backdrop then frame:CreateBackdrop("Transparent") end

	Apply(S.HandleTrimScrollBar, frame.ScrollBar)
end

-- PopupMenu_Initialize repaints the border and grows the button pool on every open, so this runs per click
local function SkinPopupMenu(popup)
	if not popup.mmt_skinned then
		popup.mmt_skinned = true
		popup:DisableDrawLayer("BACKGROUND")
		popup:SetTemplate("Transparent")
	end

	popup:SetBackdropBorderColor(unpack(E.media.bordercolor))

	for _, button in ipairs(popup.Buttons or {}) do
		if not button.mmt_skinned then
			button.mmt_skinned = true

			if button.NormalTexture then button.NormalTexture:SetTexture() end

			if button.HighlightTexture then
				local r, g, b = unpack(E.media.rgbvaluecolor)
				button.HighlightTexture:SetColorTexture(r, g, b, MENU_ALPHA)
			end
		end
	end
end

-- PGF keeps its one shared menu frame in a local and reparents it to the row's panel, so find it from there
local function OnDropDownClick(self)
	if not module.popup then
		for _, child in ipairs({ self:GetParent():GetParent():GetParent():GetChildren() }) do
			if child.Buttons then
				module.popup = child
				break
			end
		end
	end

	if module.popup then SkinPopupMenu(module.popup) end
end

local function SkinTree(frame)
	if frame.mmt_skinned then return end
	frame.mmt_skinned = true

	Apply(S.HandleCheckBox, frame.Act)
	Apply(S.HandleEditBox, frame.Min, frame.Max)

	if frame.DropDown then
		SkinDropDown(frame.DropDown)
		frame.DropDown.Button:HookScript("OnClick", OnDropDownClick)
	end

	if frame.Expression then SkinExpression(frame.Expression) end

	-- the select all/none/invert row, the only buttons carrying their own flat background
	if frame.Bg and frame.Label then
		frame.Bg:SetAlpha(0)
		S:HandleButton(frame)
	end

	for _, child in ipairs({ frame:GetChildren() }) do
		SkinTree(child)
	end
end

local function SkinStaticPopup(popup)
	if not popup then return end

	popup:StripTextures()

	if popup.Border then popup.Border:StripTextures() end

	popup:SetTemplate("Transparent")

	Apply(S.HandleButton, popup.Button1, popup.Button2, popup.Button3, popup.Button4)
	Apply(S.HandleEditBox, popup.EditBox)
end

local function SkinPremadeGroupsFilter()
	local dialog = _G.PremadeGroupsFilterDialog
	if module.isSkinned or not dialog then return end

	module.isSkinned = true

	S:HandlePortraitFrame(dialog)

	Apply(S.HandleMaxMinFrame, dialog.MaximizeMinimizeFrame)
	Apply(S.HandleButton, dialog.RefreshButton, dialog.ResetButton, dialog.SettingsButton)
	Apply(S.HandleIcon, dialog.SettingsButton and dialog.SettingsButton.Icon)

	-- every panel is built at load and only anchored on the first category switch, so one sweep covers all of them
	for _, panel in pairs(dialog.panels) do
		SkinTree(panel)
	end

	SkinStaticPopup(_G.PremadeGroupsFilterStaticPopup)
end

function module:Initialize()
	module.db = E.db.mMediaTag.skins.premade_groups_filter

	if not (module.db and module.db.enable) or module.isRegistered or not IsAddOnLoaded("PremadeGroupsFilter") then return end

	module.isRegistered = true

	local dialog = _G.PremadeGroupsFilterDialog
	if not dialog then return end

	dialog:HookScript("OnShow", SkinPremadeGroupsFilter)

	if dialog:IsShown() then SkinPremadeGroupsFilter() end
end
