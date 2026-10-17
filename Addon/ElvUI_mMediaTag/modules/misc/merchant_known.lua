local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("MerchantKnown")

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local issecretvalue = _G.issecretvalue

-- returns the db key of the color to use for the item
local function GetState(index)
	if not (_G.C_TooltipInfo and _G.C_TooltipInfo.GetMerchantItem) then return end

	local data = _G.C_TooltipInfo.GetMerchantItem(index)
	if not (data and data.lines) then return end

	local state
	for _, line in ipairs(data.lines) do
		if _G.TooltipUtil and _G.TooltipUtil.SurfaceArgs then _G.TooltipUtil.SurfaceArgs(line) end

		local text = line.leftText
		if text and not (issecretvalue and issecretvalue(text)) then
			if text == _G.ITEM_SPELL_KNOWN then return "color" end
			if module.db.appearance and text == _G.TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN then state = "appearanceColor" end
		end
	end

	return state
end

local function UpdateItem(index)
	local merchantButton = _G["MerchantItem" .. index]
	local itemButton = _G["MerchantItem" .. index .. "ItemButton"]
	if not (merchantButton and itemButton and itemButton.hasItem) then return end

	local state = GetState(itemButton:GetID())
	if not state then return end

	local r, g, b = mMT:HexToRGB(module.db[state])
	local name = _G["MerchantItem" .. index .. "Name"]
	if name then name:SetTextColor(r, g, b) end

	if module.db.border and itemButton.SetBackdropBorderColor then itemButton:SetBackdropBorderColor(r, g, b) end

	if module.db.tint then
		_G.SetItemButtonNameFrameVertexColor(merchantButton, r, g, b)
		_G.SetItemButtonTextureVertexColor(itemButton, r, g, b)
	end
end

local function UpdateMerchant()
	if not (module.isEnabled and _G.MerchantFrame and _G.MerchantFrame.selectedTab == 1) then return end

	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		UpdateItem(i)
	end
end

function module:Initialize()
	module.db = E.db.mMediaTag.merchant_known
	module.isEnabled = module.db.enable

	if module.isEnabled and not module.hooked then
		hooksecurefunc("MerchantFrame_UpdateMerchantInfo", UpdateMerchant)
		module.hooked = true
	end

	-- redraw the page so the colors are applied or reverted
	if module.hooked and _G.MerchantFrame and _G.MerchantFrame:IsShown() and _G.MerchantFrame.selectedTab == 1 then _G.MerchantFrame_UpdateMerchantInfo() end
end
