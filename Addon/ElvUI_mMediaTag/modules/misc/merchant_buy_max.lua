local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("MerchantBuyMax")
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local GROW = 26
-- offset of the number background from the bottom of the frame set by ElvUI
local BG_BOTTOM = 55

-- makes room for the button at the bottom, the other elements keep their look
local function Resize(frame, grow)
	local offset = grow and GROW or -GROW
	frame:SetHeight(frame:GetHeight() + offset)
	module.grown = grow and frame:GetHeight() or nil

	if frame.BG then frame.BG:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, BG_BOTTOM + (grow and GROW or 0)) end

	for _, key in _G.ipairs({ "OkayButton", "CancelButton" }) do
		local button = frame[key] or _G["StackSplit" .. key:gsub("Button", "") .. "Button"]
		local point, relativeTo, relativePoint, x, y = button:GetPoint()
		button:SetPoint(point, relativeTo, relativePoint, x, y + offset)
	end
end

local function IsMerchantItem(owner)
	if not (owner and _G.MerchantFrame and _G.MerchantFrame.selectedTab == 1) then return end

	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		if owner == _G["MerchantItem" .. i .. "ItemButton"] then return true end
	end
end

local function OnClick()
	local frame = _G.StackSplitFrame

	-- same path as the okay button, so confirmations for costs still show up
	frame.split = frame.maxStack
	local okay = frame.OkayButton or _G.StackSplitOkayButton
	okay:Click()
end

local function CreateButton()
	if module.button then return module.button end

	local button = _G.CreateFrame("Button", "mMT_MerchantBuyMaxButton", _G.StackSplitFrame, "UIPanelButtonTemplate")
	button:SetSize(90, 20)
	button:SetPoint("BOTTOM", _G.StackSplitFrame, "BOTTOM", 0, 10)
	button:SetText(L["Max"])
	button:SetScript("OnClick", OnClick)
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.merchant then S:HandleButton(button) end

	module.button = button
	return button
end

-- the stack frame is shared with bags and bank, so only show the button for vendor items
local function UpdateButton()
	local frame = _G.StackSplitFrame
	local show = module.isEnabled and frame:IsShown() and frame.maxStack and frame.maxStack > 1 and IsMerchantItem(frame.owner)
	if show then
		CreateButton():Show()
		if module.grown ~= frame:GetHeight() then Resize(frame, true) end
	else
		if module.button then module.button:Hide() end
		if module.grown then Resize(frame, false) end
	end
end

function module:Initialize()
	module.isEnabled = E.db.mMediaTag.merchant_buy_max.enable

	if module.isEnabled and not module.hooked then
		hooksecurefunc("MerchantItemButton_OnModifiedClick", UpdateButton)
		_G.StackSplitFrame:HookScript("OnHide", UpdateButton)
		module.hooked = true
	end

	if module.hooked then UpdateButton() end
end
