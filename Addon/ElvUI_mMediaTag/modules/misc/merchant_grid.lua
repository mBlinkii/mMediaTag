local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("MerchantGrid")

local _G = _G
local hooksecurefunc = hooksecurefunc

local COLUMNS, ROWS, GAP_X = 4, 5, 12
local DEFAULT_PER_PAGE = 10

-- anchors item 2 and up as a grid, the first item keeps the anchor of Blizzard or ElvUI
local function Layout(count, columns, gapY)
	for i = 2, count do
		local item = _G["MerchantItem" .. i]
		item:ClearAllPoints()

		if (i - 1) % columns == 0 then
			item:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - columns)], "BOTTOMLEFT", 0, -gapY)
		else
			item:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", GAP_X, 0)
		end
	end
end

local function SetFrameWidth(columns)
	local frame = _G.MerchantFrame
	local width = module.width + (columns - 2) * (_G.MerchantItem1:GetWidth() + GAP_X)

	frame:SetWidth(width)
	if _G.MerchantFrameBottomLeftBorder then _G.MerchantFrameBottomLeftBorder:SetWidth(width - (module.width - module.borderWidth)) end
end

local function SetBuyBackAnchor(item)
	local buyback = _G.MerchantBuyBackItem
	local point, _, relativePoint, x, y = unpack(module.buyback)

	buyback:ClearAllPoints()
	buyback:SetPoint(point, item, relativePoint, x, y)
end

-- Blizzard anchors both page buttons to the left frame edge and ElvUI only moves the next one, so center both around the page text
local function SetPageButtons(enable)
	local prevButton, nextButton = _G.MerchantPrevPageButton, _G.MerchantNextPageButton
	prevButton:ClearAllPoints()
	nextButton:ClearAllPoints()

	if enable then
		prevButton:SetPoint("RIGHT", _G.MerchantPageText, "LEFT", -100, 4)
		nextButton:SetPoint("LEFT", _G.MerchantPageText, "RIGHT", 100, 4)
	else
		prevButton:SetPoint(unpack(module.prevPage))
		nextButton:SetPoint(unpack(module.nextPage))
	end
end

local function ApplyMerchant()
	if not module.isEnabled then return end

	for i = DEFAULT_PER_PAGE + 1, COLUMNS * ROWS do
		_G["MerchantItem" .. i]:Show()
	end

	Layout(COLUMNS * ROWS, COLUMNS, 8)
	SetFrameWidth(COLUMNS)
	SetBuyBackAnchor(_G.MerchantItem18)
end

local function ApplyBuyback()
	if not module.isEnabled then return end

	for i = _G.BUYBACK_ITEMS_PER_PAGE + 1, COLUMNS * ROWS do
		_G["MerchantItem" .. i]:Hide()
	end

	Layout(_G.BUYBACK_ITEMS_PER_PAGE, 2, 15)
	SetFrameWidth(2)
end

local function CreateItems()
	for i = _G.BUYBACK_ITEMS_PER_PAGE + 1, COLUMNS * ROWS do
		if not _G["MerchantItem" .. i] then _G.CreateFrame("Frame", "MerchantItem" .. i, _G.MerchantFrame, "MerchantItemTemplate") end
	end
end

function module:Initialize()
	if not _G.MerchantFrame then return end

	local enable = E.db.mMediaTag.merchant_grid.enable
	if not enable and not module.isEnabled then return end

	-- remember the layout of Blizzard or ElvUI once
	if not module.width then
		module.width = _G.MerchantFrame:GetWidth()
		module.borderWidth = _G.MerchantFrameBottomLeftBorder and _G.MerchantFrameBottomLeftBorder:GetWidth() or module.width
		module.buyback = { _G.MerchantBuyBackItem:GetPoint() }
		module.prevPage = { _G.MerchantPrevPageButton:GetPoint() }
		module.nextPage = { _G.MerchantNextPageButton:GetPoint() }
	end

	if enable and not module.hooked then
		CreateItems()
		hooksecurefunc("MerchantFrame_UpdateMerchantInfo", ApplyMerchant)
		hooksecurefunc("MerchantFrame_UpdateBuybackInfo", ApplyBuyback)
		module.hooked = true
	end

	module.isEnabled = enable
	_G.MERCHANT_ITEMS_PER_PAGE = enable and COLUMNS * ROWS or DEFAULT_PER_PAGE
	SetPageButtons(enable)

	if not enable then
		-- back to the two columns of the default layout
		for i = DEFAULT_PER_PAGE + 1, COLUMNS * ROWS do
			local item = _G["MerchantItem" .. i]
			if item then item:Hide() end
		end

		Layout(_G.BUYBACK_ITEMS_PER_PAGE, 2, 15)
		_G.MerchantFrame:SetWidth(module.width)
		if _G.MerchantFrameBottomLeftBorder then _G.MerchantFrameBottomLeftBorder:SetWidth(module.borderWidth) end

		local buyback = module.buyback
		_G.MerchantBuyBackItem:ClearAllPoints()
		_G.MerchantBuyBackItem:SetPoint(buyback[1], buyback[2], buyback[3], buyback[4], buyback[5])
	end

	-- the page count changed, so start on the first page
	_G.MerchantFrame.page = 1
	if _G.MerchantFrame:IsShown() then _G.MerchantFrame_Update() end
end
