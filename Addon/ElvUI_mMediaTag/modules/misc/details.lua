local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("DetailsEmbedded")

-- Cache WoW Globals
local _G = _G
local mathmax = math.max
local InCombatLockdown = InCombatLockdown
local unpack = unpack
local Details = _G.Details
local C_Timer_After = C_Timer.After

function module:DetailsEmbeddedToggle()
	if not module.detailsEmbedded then return end

	local chat = _G[module.mode .. "Panel"]

	if module.detailsEmbedded:IsShown() then
		E:UIFrameFadeOut(module.detailsEmbedded, 0.5, 1, 0)
        chat:Show()
		C_Timer_After(0.5, function()
			module.detailsEmbedded:Hide()
		end)
	else
		E:UIFrameFadeIn(module.detailsEmbedded, 0.5, 0, 1)
		module.detailsEmbedded:Show()
		chat:Hide()
	end
end

local function CreateToggleButton(backdrop, parent, borderColor, backdropColor, height, isRightChat)
	local btn = CreateFrame("Button", "mMT_DetailsEmbedded_ToggleButton", UIParent, "BackdropTemplate")
	btn:SetBackdrop(backdrop)
	btn:SetBackdropBorderColor(unpack(borderColor))
	btn:SetBackdropColor(unpack(backdropColor))
	btn:SetSize(20, height)
	btn:SetAlpha(0)

	local anchor = isRightChat and "BOTTOMRIGHT" or "BOTTOMLEFT"
	local relAnchor = isRightChat and "BOTTOMLEFT" or "BOTTOMRIGHT"
	local xOfs = isRightChat and -2 or 2
	btn:SetPoint(anchor, parent, relAnchor, xOfs, 0)

	btn.savedBorderColor = borderColor
	btn.savedBackdropColor = backdropColor

	btn:RegisterForClicks("AnyDown")

	btn:SetScript("OnClick", function()
		module:DetailsEmbeddedToggle()
	end)

	btn:SetScript("OnEnter", function(self)
		E:UIFrameFadeIn(self, 0.5, 0, 1)
		self:SetBackdropBorderColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b, 1)
		local tt = _G.GameTooltip
		tt:SetOwner(self, "ANCHOR_CURSOR")
		tt:AddLine(L["Details embedded toggle"])
		tt:AddLine(" ")
		tt:AddLine(L["Click to hide Details frames."])
		tt:Show()
	end)

	btn:SetScript("OnLeave", function(self)
		E:UIFrameFadeOut(self, 0.5, 1, 0)
		self:SetBackdropBorderColor(unpack(self.savedBorderColor))
		_G.GameTooltip:Hide()
	end)

	return btn
end

local WINDOW_POINTS = { "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT", "TOPRIGHT" }
local WINDOW_OFFSETS = { { 1, 1 }, { -1, 1 }, { 1, -1 }, { -1, -1 } }

local function CreateWindows(parent, windows, chatWidth, chatHeight)
	local winWidth = chatWidth / 2
	local winHeight = (windows <= 2) and chatHeight or chatHeight / 2

	for i = 1, windows do
		local xOfs, yOfs = unpack(WINDOW_OFFSETS[i])
		local w = (windows == 3 and i == 3) and chatWidth or winWidth

		local frame = CreateFrame("Frame", "mMT_DetailsEmbedded_Window" .. i, parent)
		frame:SetSize(w - 2, winHeight - 2)
		frame:SetPoint(WINDOW_POINTS[i], parent, xOfs, yOfs)
		parent["Window" .. i] = frame
	end
end

local function EmbedDetailsInstances(embedded, windows)
	local xOfs = Details.chat_tab_embed.x_offset
	local yOfs = Details.chat_tab_embed.y_offset
	local i = 1

	for _, instance in Details:ListInstances() do
		if i > windows then break end

		if instance:IsEnabled() then
			instance:UngroupInstance()

			local target = (windows > 1) and embedded["Window" .. i] or embedded
			local base = instance.baseframe

			base:ClearAllPoints()
			base:SetParent(target)

			for _, child in ipairs({ instance.rowframe, instance.windowSwitchButton }) do
				child:SetParent(base)
				child:ClearAllPoints()
				child:SetAllPoints()
			end

			local topOfs = (instance.toolbar_side == 1) and -20 or 0
			local bottomOfs = (instance.show_statusbar and 14 or 0) + (instance.toolbar_side == 2 and 20 or 0)

			base:SetPoint("TOPLEFT", target, "TOPLEFT", 0, topOfs + yOfs)
			base:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", xOfs, bottomOfs)

			instance:LockInstance(true)
			instance:SaveMainWindowPosition()
			i = i + 1
		end
	end
end

local function DetailsEmbedded()
	local mode = module.mode
	local isRightChat = (mode == "RightChat")
	local chat = _G[mode .. "Panel"]

	module.isRightChat = isRightChat

	local openCount = Details:GetOpenedWindowsAmount()
	local windows = mathmax(openCount, module.windows)

	if not module.detailsEmbedded then
		local chatWidth = chat:GetWidth()
		local chatHeight = (windows > 2) and chat:GetHeight() * 2 or chat:GetHeight()

		local backdrop = chat.backdrop:GetBackdrop()
		local bbr, bbg, bbb, bba = chat.backdrop:GetBackdropBorderColor()
		local bdr, bdg, bdb, bda = chat.backdrop:GetBackdropColor()

		local embedded = CreateFrame("Frame", "mMT_DetailsEmbedded_Frame", UIParent, "BackdropTemplate")

		if module.toggle then module.detailsToggle = module.detailsToggle or CreateToggleButton(backdrop, embedded, { bbr, bbg, bbb, bba }, { bdr, bdg, bdb, bda }, chatHeight, isRightChat) end

		local panelBd = E.db.chat.panelBackdrop
		local hideBackdrop = panelBd == "HIDEBOTH" or panelBd == "LEFT" or panelBd == "RIGHT"
		local bdAlpha = hideBackdrop and 0 or bba
		local bgAlpha = hideBackdrop and 0 or bda

		embedded:SetBackdrop(backdrop)
		embedded:SetBackdropBorderColor(bbr, bbg, bbb, bdAlpha)
		embedded:SetBackdropColor(bdr, bdg, bdb, bgAlpha)
		embedded:SetSize(chatWidth, chatHeight)
		embedded:SetAllPoints(chat)

		if chat.tex then
			local texPath = isRightChat and E.db.chat.panelBackdropNameRight or E.db.chat.panelBackdropNameLeft

			local tex = embedded:CreateTexture(nil, "OVERLAY")
			embedded.tex = tex
			tex:SetPoint("TOPLEFT", chat, "TOPLEFT", 1, -1)
			tex:SetPoint("BOTTOMRIGHT", chat, "BOTTOMRIGHT", -1, 1)
			tex:SetTexture(texPath)
			tex:SetAlpha(E.db.general.backdropfadecolor.a or 0.5)
		end

		if windows > 1 then CreateWindows(embedded, windows, chatWidth, chatHeight) end

		embedded:SetFrameStrata("BACKGROUND")

		chat:Hide()
		embedded:Show()

		module.detailsEmbedded = embedded
	end

	EmbedDetailsInstances(module.detailsEmbedded, windows)
end

function module:Initialize()
	if not Details then return end
	if E.db.mMediaTag.details.mode == "DISABLE" then return end

	module.mode = E.db.mMediaTag.details.mode
	module.windows = E.db.mMediaTag.details.windows
	module.toggle = E.db.mMediaTag.details.toggle

	DetailsEmbedded()
end
