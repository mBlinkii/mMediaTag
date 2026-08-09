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

local COLOR_VERSION, COLOR_PATCH, COLOR_PAGE = "|cff86DE2E", "|cff3FC7EB", "|cffFFD800"
local MMT_LABEL = format("%s%s%s:", mMT:TC("m", "blue"), mMT:TC("M", "purple"), mMT:TC("T", "red"))

local function AddVersionLabel(frame)
	local countLabel
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region and region:IsObjectType("FontString") and region:GetJustifyH() == "RIGHT" then
			countLabel = region
			break
		end
	end

	if not countLabel then return end

	local _, elvVersion = E:ParseVersionString("ElvUI")
	local class = E:RGBToHex(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b)
	local v = COLOR_VERSION
	local plain = format("%sElvUI:|r %s%s|r  %s %s%s|r  %sPatch:|r %s%s|r", class, v, elvVersion, MMT_LABEL, v, mMT.Version, COLOR_PATCH, v, E.wowpatch)
	local paged = format("%s  %s%s|r", plain, COLOR_PAGE, L["Page:"])

	local label = frame:CreateFontString(nil, "ARTWORK")
	label:SetFontObject(countLabel:GetFontObject())
	label:SetTextColor(countLabel:GetTextColor())

	-- an empty count label collapses to zero height, so anchor to its fixed top edge and not to its center
	label:SetPoint("TOPRIGHT", countLabel, "TOPLEFT", -6, 0)

	local function UpdateLabel(_, text)
		label:SetText((text and text ~= "") and paged or plain)
	end

	UpdateLabel(nil, countLabel:GetText())
	hooksecurefunc(countLabel, "SetText", UpdateLabel)
end

local function SkinBugSackFrame()
	local BugSack, frame = _G.BugSack, _G.BugSackFrame
	if module.isSkinned or not (BugSack and frame) then return end

	module.isSkinned = true

	S:HandleFrame(frame)

	-- HandleFrame strips the title background, so the header needs its own divider
	local divider = frame:CreateTexture(nil, "OVERLAY")
	divider:SetTexture(E.media.blankTex)
	divider:SetVertexColor(unpack(E.media.rgbvaluecolor))
	divider:Point("TOPLEFT", frame, "TOPLEFT", 8, -TITLE_HEIGHT)
	divider:Point("TOPRIGHT", frame, "TOPRIGHT", -8, -TITLE_HEIGHT)
	divider:Height(1)

	if _G.BugSackScrollScrollBar then S:HandleScrollBar(_G.BugSackScrollScrollBar) end

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

	-- BugSack names none of its close buttons, the OnClick handler is the only marker
	for _, child in ipairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack then S:HandleCloseButton(child) end
	end

	if module.db and module.db.version_label then AddVersionLabel(frame) end
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
