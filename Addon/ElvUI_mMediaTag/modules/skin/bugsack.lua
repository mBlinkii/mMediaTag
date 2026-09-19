local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("BugSackSkin")

-- Credits to Luckyone, adapted from LuckyoneUI (Modules/Skins/Addons/BugSack.lua)

local S = E:GetModule("Skins")

-- Cache WoW Globals
local _G = _G
local format = format
local ipairs = ipairs
local select = select
local unpack = unpack
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local BUTTON_HEIGHT = 24
local TITLE_HEIGHT = 28
local TITLE_INSET = 8

local COLOR_VERSION, COLOR_PATCH, COLOR_PAGE = "|cff86DE2E", "|cff3FC7EB", "|cffFFD800"
local MMT_LABEL = format("%s%s%s:", mMT:TC("m", "blue"), mMT:TC("M", "purple"), mMT:TC("T", "red"))

local function FindTitleFont(parent, justify)
	for i = 1, parent:GetNumRegions() do
		local region = select(i, parent:GetRegions())
		if region and region:IsObjectType("FontString") and region:GetJustifyH() == justify then return region end
	end
end

local function ShiftLeftAnchors(object, inset)
	local points = {}
	for i = 1, object:GetNumPoints() do
		local point, relativeTo, relativePoint, x, y = object:GetPoint(i)
		points[i] = { point, relativeTo, relativePoint, relativePoint:find("LEFT") and inset or x, y }
	end

	object:ClearAllPoints()

	for _, p in ipairs(points) do
		object:SetPoint(unpack(p))
	end
end

local function AddVersionLabel(frame, titleBar)
	local parent = titleBar or frame
	local countLabel = FindTitleFont(parent, "RIGHT")

	if not countLabel then return end

	local _, elvVersion = E:ParseVersionString("ElvUI")
	local class = E:RGBToHex(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b)
	local v = COLOR_VERSION
	local plain = format("%sElvUI:|r %s%s|r  %s %s%s|r  %sPatch:|r %s%s|r", class, v, elvVersion, MMT_LABEL, v, mMT.Version, COLOR_PATCH, v, E.wowpatch)
	local paged = format("%s  %s%s|r", plain, COLOR_PAGE, L["Page:"])

	local label = parent:CreateFontString(nil, titleBar and "OVERLAY" or "ARTWORK")
	label:SetFontObject(countLabel:GetFontObject())
	label:SetTextColor(countLabel:GetTextColor())

	-- an empty count label collapses to zero height, so anchor to the edge its own layout keeps fixed
	if titleBar then
		label:SetPoint("RIGHT", countLabel, "LEFT", -6, 0)
	else
		label:SetPoint("TOPRIGHT", countLabel, "TOPLEFT", -6, 0)
	end

	local function UpdateLabel(_, text)
		label:SetText((text and text ~= "") and paged or plain)
	end

	UpdateLabel(nil, countLabel:GetText())
	hooksecurefunc(countLabel, "SetText", UpdateLabel)
end

local function SkinScrollBar(scrollBar)
	if not scrollBar then return end

	if scrollBar.Back and scrollBar.Forward then
		S:HandleTrimScrollBar(scrollBar)
	elseif scrollBar.GetThumbTexture then
		S:HandleScrollBar(scrollBar)
	end
end

local function SkinBugSackFrame()
	local BugSack, frame = _G.BugSack, _G.BugSackFrame
	if module.isSkinned or not (BugSack and frame) then return end

	module.isSkinned = true

	-- BugSack 12.1.2 builds the retail window from PortraitFrameTemplate, older flavors keep the paperdoll frame
	local titleBar = frame.TitleContainer

	S:HandleFrame(frame)

	-- the portrait sits in PortraitContainer, which StripTextures does not reach
	if frame.PortraitContainer then frame.PortraitContainer:Hide() end

	-- hiding the portrait frees the indent the header keeps for it, so the session and filter labels move to the border
	if titleBar then
		local searchLabel = FindTitleFont(titleBar, "LEFT")
		if searchLabel then ShiftLeftAnchors(searchLabel, TITLE_INSET) end

		for _, child in ipairs({ titleBar:GetChildren() }) do
			if child:IsObjectType("Button") then ShiftLeftAnchors(child, TITLE_INSET) end
		end
	end

	-- HandleFrame strips the title background, so the header needs its own divider
	local divider = frame:CreateTexture(nil, "OVERLAY")
	divider:SetTexture(E.media.blankTex)
	divider:SetVertexColor(unpack(E.media.rgbvaluecolor))

	if titleBar then
		divider:Point("TOPLEFT", titleBar, "BOTTOMLEFT", 8, 0)
		divider:Point("TOPRIGHT", titleBar, "BOTTOMRIGHT", -8, 0)
	else
		divider:Point("TOPLEFT", frame, "TOPLEFT", 8, -TITLE_HEIGHT)
		divider:Point("TOPRIGHT", frame, "TOPRIGHT", -8, -TITLE_HEIGHT)
	end

	divider:Height(1)

	-- the scroll frame is unnamed, only its edit box child carries a global
	local scroll = _G.BugSackScrollText and _G.BugSackScrollText:GetParent()
	SkinScrollBar(scroll and (scroll.ScrollBar or _G.BugSackScrollScrollBar))

	-- the send button is optional, so it stays last in the list to avoid a hole ipairs would stop on
	local prevButton, nextButton = _G.BugSackPrevButton, _G.BugSackNextButton
	for _, button in ipairs({ prevButton, nextButton, _G.BugSackSendButton }) do
		S:HandleButton(button)
		button:Height(BUTTON_HEIGHT)
	end

	if prevButton then
		prevButton:ClearAllPoints()
		prevButton:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 12, 6)
	end

	if nextButton then
		nextButton:ClearAllPoints()
		nextButton:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -12, 6)
	end

	-- anchored by LEFT instead of the template's TOPLEFT, so the row stays put whatever height HandleTab leaves behind
	local anchor
	for _, tab in ipairs({ _G.BugSackTabLast, _G.BugSackTabSession, _G.BugSackTabAll }) do
		S:HandleTab(tab)
		tab:ClearAllPoints()

		if anchor then
			tab:Point("LEFT", anchor, "RIGHT", -5, 0)
		else
			tab:Point("LEFT", frame, "BOTTOMLEFT", 10, -16)
		end

		anchor = tab
	end

	-- the paperdoll frame names none of its close buttons, the OnClick handler is the only marker
	if not frame.CloseButton then
		for _, child in ipairs({ frame:GetChildren() }) do
			if child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack then S:HandleCloseButton(child) end
		end
	end

	if module.db and module.db.version_label then AddVersionLabel(frame, titleBar) end
end

local function RegisterHook()
	if not _G.BugSack then return end

	hooksecurefunc(_G.BugSack, "OpenSack", SkinBugSackFrame)

	if _G.BugSackFrame then SkinBugSackFrame() end
end

function module:Initialize()
	module.db = E.db.mMediaTag.skins.bugsack

	if not (module.db and module.db.enable) or module.isRegistered or not IsAddOnLoaded("BugSack") then return end

	module.isRegistered = true

	-- IsAddOnLoaded returns two values, the parentheses keep the second out of AddCallbackForAddon's bypass slot
	S:AddCallbackForAddon("BugSack", "mMT_BugSackSkin", RegisterHook, (IsAddOnLoaded("BugSack")))
end
