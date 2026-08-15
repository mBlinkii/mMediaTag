local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AuctionatorSkin")

local S = E:GetModule("Skins")

-- Cache WoW Globals
local _G = _G
local ipairs = ipairs
local pairs = pairs
local select = select
local sort = sort
local strfind = strfind
local unpack = unpack
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local TAB_BUTTONS = { "AuctionatorTabs_Shopping", "AuctionatorTabs_Selling", "AuctionatorTabs_Cancelling", "AuctionatorTabs_Auctionator" }

local LEFT_INSET, BUTTON_GAP, SEARCH_GAP = 10, 4, 5
local LIST_TOP, MINI_TAB_HEIGHT, HEADER_GAP, HEADER_TOP, HEADER_TEXT_PAD = -58, 22, 1, -7, 4
local SPLIT_PANEL_TOP = 0 -- Auctionator uses 10, which leaves the two split panels nearly touching
local REFRESH_SIZE = 22
local TABS_CONTAINER_INSET = 2 -- Auctionator's own x offset on the prices tab container

local function Apply(handler, ...)
	for i = 1, select("#", ...) do
		local frame = select(i, ...)
		if frame then handler(S, frame) end
	end
end

-- covers the inset templates and the standalone dialog panels, both wrap their edge in a NineSlice child
local function SkinBackdrop(frame)
	if not frame then return end

	if frame.Bg then frame.Bg:SetAlpha(0) end

	local border = frame.NineSlice or frame.Border
	if border and not border.template then
		border:SetTemplate("Transparent")
		border:SetInside(frame)
	end
end

-- the wrapper only carries the label, the real dropdown button sits one level below it
local function SkinDropDown(wrapper)
	local dropdown = wrapper and wrapper.DropDown
	if not dropdown then return end

	S:HandleDropDownBox(dropdown, dropdown:GetWidth())
end

-- Auctionator sets the vertical offset from its own options, so only the horizontal one is replaced
-- a number is taken as-is, a frame shifts this one onto that frame's left edge plus pad
local function MoveLeft(frame, offset, pad)
	for i = 1, frame:GetNumPoints() do
		local point, relativeTo, relativePoint, x, y = frame:GetPoint(i)
		if point == "TOPLEFT" then
			frame:SetPoint(point, relativeTo, relativePoint, type(offset) == "number" and offset or x + offset:GetLeft() - frame:GetLeft() + (pad or 0), y)
			return
		end
	end
end

-- counterpart to MoveLeft: drops this frame's top edge onto the target's bottom edge
local function MoveTop(frame, target)
	local top, bottom = frame:GetTop(), target and target:GetBottom()
	if not (top and bottom) then return end

	for i = 1, frame:GetNumPoints() do
		local point, relativeTo, relativePoint, x, y = frame:GetPoint(i)
		if point == "TOPLEFT" then
			frame:SetPoint(point, relativeTo, relativePoint, x, y + bottom - top)
			return
		end
	end
end

-- counterpart to MoveTop: lines this frame's centre up with the target's centre
local function MoveMiddle(frame, target)
	if not (frame and target) then return end

	local _, y = frame:GetCenter()
	local _, targetY = target:GetCenter()
	if not (y and targetY) then return end

	local point, relativeTo, relativePoint, x, offset = frame:GetPoint(1)
	if point then frame:SetPoint(point, relativeTo, relativePoint, x, offset + targetY - y) end
end

local function OnGlowEnter(self)
	self.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
end

local function OnGlowLeave(self)
	self.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
end

-- the tab and header templates light their own artwork on mouseover, and not all of it sits on the HIGHLIGHT layer
local function KillHighlight(frame)
	frame:DisableDrawLayer("HIGHLIGHT")

	local highlight = frame.GetHighlightTexture and frame:GetHighlightTexture()
	if highlight then highlight:Kill() end

	for _, region in ipairs({ frame:GetRegions() }) do
		local atlas = region.GetAtlas and region:GetAtlas()
		local file = not atlas and region.GetTexture and region:GetTexture()

		if (atlas and strfind(atlas, "ighlight")) or (type(file) == "string" and strfind(file, "ighlight")) then
			region:Kill()
		end
	end
end

local function AddBorderGlow(frame)
	if not (frame and frame.backdrop) or frame.mmt_glow then return end

	frame.mmt_glow = true
	KillHighlight(frame)
	frame:HookScript("OnEnter", OnGlowEnter)
	frame:HookScript("OnLeave", OnGlowLeave)
end

-- PanelTemplates re-anchors the label from the template metrics on every switch, so redo it after each one
local function SkinMiniTabs(container, tabs)
	local function Restyle()
		for _, tab in ipairs(tabs) do
			tab:Height(MINI_TAB_HEIGHT)
			tab.Text:ClearAllPoints()
			tab.Text:Point("CENTER", tab, "CENTER", 0, 0)
		end
	end

	for _, tab in ipairs(tabs) do
		S:HandleTab(tab)
		AddBorderGlow(tab)
	end

	Restyle()
	hooksecurefunc(container, "SetView", Restyle)
end

-- Auctionator gives the refresh button neither a name nor a parentKey, so pick the child that has neither key nor text
local function SkinRefreshButton(parent)
	local keyed = {}
	for _, value in pairs(parent) do
		if type(value) == "table" then keyed[value] = true end
	end

	for _, child in ipairs({ parent:GetChildren() }) do
		if not keyed[child] and child:IsObjectType("Button") and not child:GetText() then
			S:HandleButton(child)
			child:Size(REFRESH_SIZE)
			return
		end
	end
end

local function SkinRadioGroup(group)
	if not group then return end

	for _, child in ipairs({ group:GetChildren() }) do
		Apply(S.HandleRadioButton, child.RadioButton)
	end
end

local function ByLeftEdge(a, b)
	return a:GetLeft() < b:GetLeft()
end

local function SkinHeaders(container, panel)
	local columns = {}

	for _, header in ipairs({ container:GetChildren() }) do
		if not header.mmt_skinned then
			header.mmt_skinned = true
			header:DisableDrawLayer("BACKGROUND")

			if not header.backdrop then header:CreateBackdrop("Transparent") end

			AddBorderGlow(header)

			-- the outer columns reach past the panel, their label would follow the frame instead of the trimmed backdrop
			local text = header.Text or (header.GetFontString and header:GetFontString())
			if text then
				text:SetWordWrap(false)
				text:ClearAllPoints()
				text:Point("LEFT", header.backdrop, "LEFT", HEADER_TEXT_PAD, 0)
				text:Point("RIGHT", header.backdrop, "RIGHT", -HEADER_TEXT_PAD, 0)
			end
		end

		-- GetChildren follows neither column order nor visibility, hidden columns would poison the outer edges
		if header:IsShown() and header:GetLeft() then columns[#columns + 1] = header end
	end

	sort(columns, ByLeftEdge)

	-- measure against the panel border where there is one, the container reaches past it
	local edge = (panel and panel.NineSlice) or container
	local left, right = edge:GetLeft(), edge:GetRight()

	for i, header in ipairs(columns) do
		local following = columns[i + 1]

		-- the table builder insets the outer columns, stretch them back out and close the inner gaps
		local padLeft = (i == 1 and left) and left - header:GetLeft() or 0
		local padRight = following and (following:GetLeft() - HEADER_GAP - header:GetRight()) or (right and right - header:GetRight()) or 0

		-- SetPoint, not E's Point: these offsets are measured distances and must not run through E:Scale
		header.backdrop:SetPoint("TOPLEFT", padLeft, 0)
		header.backdrop:SetPoint("BOTTOMRIGHT", padRight, -2)
	end
end

local function SkinCells(listing)
	local builder = listing.tableBuilder
	if not (builder and builder.rows) then return end

	for _, row in ipairs(builder.rows) do
		if row.cells then
			for _, cell in ipairs(row.cells) do
				if cell.Icon and not cell.mmt_skinned then
					cell.mmt_skinned = true
					S:HandleIcon(cell.Icon)

					if cell.IconBorder then cell.IconBorder:Kill() end
				end
			end
		end
	end
end

local function SkinResultsListing(listing, panel)
	if not (listing and listing.ScrollArea) then return end

	Apply(S.HandleTrimScrollBar, listing.ScrollArea.ScrollBar)

	local function Restyle(self)
		if self.HeaderContainer then SkinHeaders(self.HeaderContainer, panel) end
		SkinCells(self)
	end

	-- headers appear with the first table build and the row cells come from a pool, so re-check on every pass
	hooksecurefunc(listing, "UpdateTable", Restyle)

	-- ApplyHiding runs after UpdateTable and changes which columns are shown, which moves the outer edges
	hooksecurefunc(listing, "ApplyHiding", Restyle)
end

-- Auctionator starts the panel above the column headers, lift them out so the panel begins below them
local function LiftHeaders(listing, panel)
	local header = listing and listing.HeaderContainer
	if not (header and panel) then return end

	-- ScrollArea keeps its own +15 offset from the header, that is what lines the cells up under the columns
	header:Point("TOPLEFT", listing, "TOPLEFT", 0, HEADER_TOP)

	panel:ClearAllPoints()
	panel:Point("TOPLEFT", header, "BOTTOMLEFT", 0, -2)
	panel:Point("BOTTOMRIGHT", listing, "BOTTOMRIGHT", 0, 2)

	return true
end

local function SkinGroupsView(view)
	if not view then return end

	Apply(S.HandleTrimScrollBar, view.ScrollBar)

	-- item and group frames are pooled, UpdateGroupHeights runs after every layout change
	hooksecurefunc(view, "UpdateGroupHeights", function(self)
		for button in self.buttonPool:EnumerateActive() do
			if not button.mmt_skinned then
				button.mmt_skinned = true
				S:HandleItemButton(button, true)
				Apply(S.HandleIconBorder, button.IconBorder)
			end
		end

		-- HandleCategoriesButtons leaves this template alone, its artwork sits in named regions it never touches
		for group in self.groupPool:EnumerateActive() do
			local title = group.GroupTitle
			if title and not title.mmt_skinned then
				title.mmt_skinned = true
				S:HandleButton(title, true)
			end
		end
	end)
end

local function SkinMoneyInput(frame)
	local input = frame and frame.MoneyInput
	if not input then return end

	Apply(S.HandleEditBox, input.GoldBox, input.SilverBox, input.CopperBox)
end

local function SkinSearchDialog(dialog)
	if not dialog then return end

	S:HandlePortraitFrame(dialog)

	Apply(S.HandleEditBox, dialog.SearchString)
	Apply(S.HandleCheckBox, dialog.IsExact)
	Apply(S.HandleButton, dialog.Finished, dialog.Cancel, dialog.ResetAllButton, dialog.ResetSearchStringButton)

	for _, range in ipairs({ dialog.LevelRange, dialog.ItemLevelRange, dialog.CraftedLevelRange, dialog.PriceRange }) do
		Apply(S.HandleEditBox, range.MinBox, range.MaxBox)
	end

	Apply(S.HandleEditBox, dialog.PurchaseQuantity and dialog.PurchaseQuantity.InputBox)

	for _, container in ipairs({ dialog.QualityContainer, dialog.ExpansionContainer, dialog.TierContainer }) do
		SkinDropDown(container.DropDown)
		Apply(S.HandleButton, container.ResetQualityButton, container.ResetExpansionButton, container.ResetTierButton)
	end
end

local function SkinListDialog(dialog)
	if not dialog then return end

	SkinBackdrop(dialog)
	SkinBackdrop(dialog.Inset)

	-- CloseDialog is the corner X, Close is a plain text button
	Apply(S.HandleCloseButton, dialog.CloseDialog)
	Apply(S.HandleTrimScrollBar, dialog.ScrollBar)
	Apply(S.HandleButton, dialog.Export, dialog.Import, dialog.SelectAll, dialog.UnselectAll, dialog.Dock, dialog.Close)
	Apply(S.HandleEditBox, dialog.Recipient)

	SkinRadioGroup(dialog.ExportOption)
	SkinResultsListing(dialog.ResultsListing, dialog.Inset)
end

local function SkinBuyDialog(dialog)
	if not dialog then return end

	if dialog.Background then dialog.Background:SetAlpha(0) end

	SkinBackdrop(dialog)
	Apply(S.HandleButton, dialog.AcceptButton, dialog.CancelButton, dialog.ContinueButton)
end

local function SkinBuyFrame(frame)
	if not frame then return end

	SkinBackdrop(frame.Inset)
	SkinResultsListing(frame.ResultsListing, frame.Inset)
	SkinRefreshButton(frame)

	Apply(S.HandleButton, frame.BackButton, frame.BuyButton, frame.Buy, frame.Cancel)
	Apply(S.HandleEditBox, frame.QuantityInput)
	Apply(S.HandleIcon, frame.IconAndName and frame.IconAndName.Icon)

	-- listed one by one, not looped: the item frame has only the first dialog and ipairs would stop at the hole
	SkinBuyDialog(frame.BuyDialog)
	SkinBuyDialog(frame.FinalConfirmationDialog)
	SkinBuyDialog(frame.QuantityCheckConfirmationDialog)
	SkinBuyDialog(frame.WidePriceRangeWarningDialog)
end

local function SkinSearchRow(options)
	if not options then return end

	local label, search = options.SearchLabel, options.SearchString
	local reset, button = options.ResetSearchStringButton, options.SearchButton

	Apply(S.HandleEditBox, search)
	Apply(S.HandleButton, reset, button, options.MoreButton, options.AddToListButton)

	-- the whole row hangs off the label, moving it lines the row up with the lists below
	if label then
		label:ClearAllPoints()
		label:Point("TOPLEFT", options, "TOPLEFT", LEFT_INSET, -4)
	end

	if not (search and reset and button) then return end

	-- SetHeight, not E's Height: the value is measured off another frame and must not run through E:Scale
	search:SetHeight(button:GetHeight())

	-- square, because the reset button is a single icon texture that would stretch otherwise
	local size = search:GetHeight()
	reset:Size(size, size)
	reset:ClearAllPoints()
	reset:Point("LEFT", search, "RIGHT", SEARCH_GAP, 0)

	-- Auctionator hangs the row off the reset button's bottom edge with a 3px drop, centre it instead
	button:ClearAllPoints()
	button:Point("LEFT", reset, "RIGHT", SEARCH_GAP, 0)
end

local function SkinShopping(frame)
	SkinSearchRow(frame.SearchOptions)

	local lists = frame.ListsContainer

	-- both containers build Inset and ScrollBar in their OnLoad, not in the template
	for _, container in ipairs({ lists, frame.RecentsContainer }) do
		SkinBackdrop(container.Inset)
		Apply(S.HandleTrimScrollBar, container.ScrollBar)
		container:Point("LEFT", frame, "LEFT", LEFT_INSET, 0)
		container:Point("TOP", frame, "TOP", 0, LIST_TOP)
	end

	-- the mini tabs stand on the container, so a shorter tab is what opens the gap to the search row
	local containerTabs = frame.ContainerTabs
	if containerTabs then
		local listsTab = containerTabs.ListsTab
		SkinMiniTabs(containerTabs, { listsTab, containerTabs.RecentsTab })

		-- the row grows to both sides of the seam between the tabs, so put the seam on the list centre
		if listsTab and lists then
			listsTab:ClearAllPoints()
			listsTab:Point("BOTTOMRIGHT", lists, "TOP", 0, 0)
		end
	end

	Apply(S.HandleButton, frame.NewListButton, frame.ExportButton, frame.ImportButton, frame.ExportCSV)

	-- Auctionator hangs these three off the frame edge instead of the list they belong to
	if lists then
		if frame.NewListButton then
			frame.NewListButton:ClearAllPoints()
			frame.NewListButton:Point("TOPLEFT", lists, "BOTTOMLEFT", 0, -BUTTON_GAP)
		end

		if frame.ExportButton then
			frame.ExportButton:ClearAllPoints()
			frame.ExportButton:Point("TOPRIGHT", lists, "BOTTOMRIGHT", 0, -BUTTON_GAP)
		end
	end

	local inset = frame.ShoppingResultsInset
	local listing = frame.ResultsListing
	SkinBackdrop(inset)
	SkinResultsListing(listing, inset)

	if LiftHeaders(listing, inset) and frame.ExportCSV then
		frame.ExportCSV:ClearAllPoints()
		frame.ExportCSV:Point("TOPRIGHT", inset, "BOTTOMRIGHT", 0, -BUTTON_GAP)
	end

	SkinSearchDialog(frame.itemDialog)
	SkinListDialog(frame.exportDialog)
	SkinListDialog(frame.importDialog)
	SkinListDialog(frame.exportCSVDialog)
	SkinListDialog(frame.itemHistoryDialog)

	SkinBuyFrame(_G.AuctionatorBuyItemFrame)
	SkinBuyFrame(_G.AuctionatorBuyCommodityFrame)
end

local function SkinSelling(frame)
	local sale = frame.SaleItemFrame
	if sale then
		if sale.Icon then
			S:HandleItemButton(sale.Icon, true)
			Apply(S.HandleIconBorder, sale.Icon.IconBorder)
		end

		local quantity = sale.Quantity and sale.Quantity.InputBox
		Apply(S.HandleEditBox, quantity)
		Apply(S.HandleButton, sale.MaxButton, sale.PostButton, sale.SkipButton, sale.PrevButton)

		if quantity and sale.MaxButton then
			quantity:SetHeight(sale.MaxButton:GetHeight())
			MoveMiddle(sale.MaxButton, quantity)
		end

		SkinMoneyInput(sale.Price)
		SkinMoneyInput(sale.BidPrice)
		SkinRadioGroup(sale.Duration)
		SkinRefreshButton(sale)
	end

	local bag = frame.BagListing
	if bag then
		SkinGroupsView(bag.View)
		MoveLeft(bag, LEFT_INSET)
	end

	SkinBackdrop(frame.BagInset)
	SkinBackdrop(frame.HistoricalPriceInset)

	-- with split panels enabled the current prices get a second inset, built in the tab's OnLoad
	local prices = frame.CurrentPricesInset
	SkinBackdrop(prices)

	if prices then
		for _, listing in ipairs({ frame.HistoricalPriceListing, frame.PostingHistoryListing }) do
			listing:Point("TOPLEFT", frame.CurrentPricesListing, "BOTTOMLEFT", 0, SPLIT_PANEL_TOP)
		end
	end

	SkinResultsListing(frame.CurrentPricesListing, prices or frame.HistoricalPriceInset)
	SkinResultsListing(frame.HistoricalPriceListing, frame.HistoricalPriceInset)
	SkinResultsListing(frame.PostingHistoryListing, frame.HistoricalPriceInset)

	LiftHeaders(frame.CurrentPricesListing, prices or frame.HistoricalPriceInset)
	LiftHeaders(frame.HistoricalPriceListing, frame.HistoricalPriceInset)
	LiftHeaders(frame.PostingHistoryListing, frame.HistoricalPriceInset)

	local tabs = frame.PricesTabsContainer
	if tabs then
		SkinMiniTabs(tabs, { tabs.CurrentPricesTab, tabs.PriceHistoryTab, tabs.YourHistoryTab })
		MoveTop(tabs, frame.HistoricalPriceInset)

		-- split panels hide the first tab but leave it holding its slot, which pushes the visible ones right
		local first = tabs.CurrentPricesTab
		if first and not first:IsShown() then first = tabs.PriceHistoryTab end

		local border = frame.HistoricalPriceInset and frame.HistoricalPriceInset.NineSlice
		if first and border and first.backdrop then
			-- line up what is visible: HandleTab and the panel border each inset their own backdrop differently
			local _, _, _, tabPad = first.backdrop:GetPoint(1)
			local _, _, _, panelPad = border:GetPoint(1)

			first:ClearAllPoints()
			first:Point("TOPLEFT", tabs, "TOPLEFT", (panelPad or 0) - (tabPad or 0) - TABS_CONTAINER_INSET, 0)
		end
	end
end

local function SkinCancelling(frame)
	local inset = frame.HistoricalPriceInset

	Apply(S.HandleEditBox, frame.SearchFilter)
	SkinBackdrop(inset)
	SkinResultsListing(frame.ResultsListing, inset)
	LiftHeaders(frame.ResultsListing, inset)

	SkinRefreshButton(frame)

	-- Auctionator lines the search box and the scan buttons up with the window edge, not with the list
	if frame.SearchFilter and inset then MoveLeft(frame.SearchFilter, inset, LEFT_INSET) end

	local scan = frame.UndercutScanContainer
	if scan then
		Apply(S.HandleButton, scan.CancelNextButton, scan.StartScanButton)

		if inset and scan.CancelNextButton then
			scan.CancelNextButton:ClearAllPoints()
			scan.CancelNextButton:Point("TOPRIGHT", inset, "BOTTOMRIGHT", 0, -BUTTON_GAP)
		end
	end
end

local function SkinConfig(frame)
	-- the config tab inherits the inset template itself instead of holding one
	SkinBackdrop(frame)

	Apply(S.HandleButton, frame.ScanButton, frame.OptionsButton)

	for _, link in ipairs({ frame.ContributeLink, frame.DiscordLink, frame.BugReportLink }) do
		Apply(S.HandleEditBox, link.InputBox)
	end
end

local function SkinAuctionator()
	local shopping = _G.AuctionatorShoppingFrame
	if module.isSkinned or not shopping then return end

	module.isSkinned = true

	SkinShopping(shopping)
	if _G.AuctionatorSellingFrame then SkinSelling(_G.AuctionatorSellingFrame) end
	if _G.AuctionatorCancellingFrame then SkinCancelling(_G.AuctionatorCancellingFrame) end
	if _G.AuctionatorConfigFrame then SkinConfig(_G.AuctionatorConfigFrame) end

	-- LibAHTab keeps its tabs out of AuctionHouseFrame.Tabs, so ElvUI's tab pass never sees them
	for _, name in ipairs(TAB_BUTTONS) do
		Apply(S.HandleTab, _G[name])
	end
end

local DIALOG_FUNCTIONS = { "ShowConfirm", "ShowConfirmAlt", "ShowEditBox", "ShowMoney" }

-- Auctionator builds its own dialogs, named AuctionatorDialog1..n and created on first use
local function SkinDialogs()
	local index = 1
	local dialog = _G["AuctionatorDialog" .. index]

	while dialog do
		if not dialog.mmt_skinned then
			dialog.mmt_skinned = true

			dialog:StripTextures() -- the dark background texture and the NineSlice dialog art
			dialog:SetTemplate("Transparent")

			Apply(S.HandleButton, dialog.acceptButton, dialog.altButton, dialog.cancelButton)
			Apply(S.HandleEditBox, dialog.editBox)
		end

		index = index + 1
		dialog = _G["AuctionatorDialog" .. index]
	end
end

local function OnAuctionHouseShow()
	-- Auctionator builds its tab frames inside its own OnShow during the same event, so skin a frame later
	if not module.isSkinned then E:Delay(0, SkinAuctionator) end
end

local function RegisterHook()
	local frame = _G.AuctionHouseFrame
	if not frame then return end

	frame:HookScript("OnShow", OnAuctionHouseShow)

	if frame:IsShown() then OnAuctionHouseShow() end
end

function module:Initialize()
	module.db = E.db.mMediaTag.skins.auctionator

	if not (module.db and module.db.enable) or module.isRegistered or not IsAddOnLoaded("Auctionator") then return end

	module.isRegistered = true

	-- the dialogs announce themselves nowhere, so skin them right after the call that builds them
	local dialogs = _G.Auctionator and _G.Auctionator.Dialogs
	if dialogs then
		for _, name in ipairs(DIALOG_FUNCTIONS) do
			if dialogs[name] then hooksecurefunc(dialogs, name, SkinDialogs) end
		end
	end

	-- IsAddOnLoaded returns two values, the parentheses keep the second out of AddCallbackForAddon's bypass slot
	S:AddCallbackForAddon("Blizzard_AuctionHouseUI", "mMT_AuctionatorSkin", RegisterHook, (IsAddOnLoaded("Blizzard_AuctionHouseUI")))
end
