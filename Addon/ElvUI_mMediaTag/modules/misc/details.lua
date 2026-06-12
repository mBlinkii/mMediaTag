local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("DetailsEmbedded", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local InCombatLockdown = InCombatLockdown
local unpack = unpack
local Details = _G.Details
local C_Timer_After = C_Timer.After

local function SetChatFramesShown(chat, shown)
	for _, frameName in ipairs(_G.CHAT_FRAMES) do
		local chatFrame = _G[frameName]
		if chatFrame and chatFrame:GetParent() == chat then chatFrame:SetShown(shown) end
	end
end

function module:DetailsEmbeddedToggle()
	if not module.detailsEmbedded then return end

	local chat = _G[module.mode .. "Panel"]

	if module.detailsEmbedded:IsShown() then
		E:UIFrameFadeOut(module.detailsEmbedded, 0.5, 1, 0)
		SetChatFramesShown(chat, true)

		-- move tooltip
		if E.CreatedMovers.TooltipMover and module.tooltipOrigPoint and not InCombatLockdown() then
			E.CreatedMovers.TooltipMover.mover:ClearAllPoints()
			E.CreatedMovers.TooltipMover.mover:SetPoint(unpack(module.tooltipOrigPoint))
		end

		C_Timer_After(0.5, function()
			module.detailsEmbedded:Hide()
		end)
	else
		E:UIFrameFadeIn(module.detailsEmbedded, 0.5, 0, 1)
		module.detailsEmbedded:Show()
		SetChatFramesShown(chat, false)

		-- move tooltip
		if E.CreatedMovers.TooltipMover and not InCombatLockdown() then
			E.CreatedMovers.TooltipMover.mover:ClearAllPoints()
			E.CreatedMovers.TooltipMover.mover:SetPoint("BOTTOMRIGHT", module.detailsEmbedded, "TOPRIGHT", 0, 0)
		end
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

	local windows = module.windows

	if not module.detailsEmbedded then
		local chatWidth = chat:GetWidth()
		local chatHeight = (windows > 2) and chat:GetHeight() * 2 or chat:GetHeight()

		local embedded = CreateFrame("Frame", "mMT_DetailsEmbedded_Frame", UIParent)

		if module.toggle and not module.detailsToggle then
			local backdrop = chat.backdrop:GetBackdrop()
			local bbr, bbg, bbb, bba = chat.backdrop:GetBackdropBorderColor()
			local bdr, bdg, bdb, bda = chat.backdrop:GetBackdropColor()
			module.detailsToggle = CreateToggleButton(backdrop, embedded, { bbr, bbg, bbb, bba }, { bdr, bdg, bdb, bda }, chatHeight, isRightChat)
		end

		embedded:SetSize(chatWidth, chatHeight)
		embedded:SetPoint((isRightChat and "BOTTOMRIGHT" or "BOTTOMLEFT"), chat)

		if windows > 1 then CreateWindows(embedded, windows, chatWidth, chatHeight) end

		embedded:SetFrameStrata("BACKGROUND")
		embedded:SetFrameLevel(chat:GetFrameLevel() + 2)
		embedded:Show()

		module.detailsEmbedded = embedded
	end

	-- move tooltip
	if E.CreatedMovers.TooltipMover and not InCombatLockdown() then
		module.tooltipOrigPoint = { E.CreatedMovers.TooltipMover.mover:GetPoint() }
		E.CreatedMovers.TooltipMover.mover:ClearAllPoints()
		E.CreatedMovers.TooltipMover.mover:SetPoint("BOTTOMRIGHT", module.detailsEmbedded, "TOPRIGHT", 0, 0)
	end

	if module.detailsEmbedded:IsShown() then SetChatFramesShown(chat, false) end

	EmbedDetailsInstances(module.detailsEmbedded, windows)
end

function module:PLAYER_ENTERING_WORLD()
	C_Timer_After(1, function()
		if module.detailsEmbedded and module.detailsEmbedded:IsShown() then SetChatFramesShown(_G[module.mode .. "Panel"], false) end
	end)
end

function module:Initialize()
	if not Details then return end
	if E.db.mMediaTag.details.mode == "DISABLE" then return end

	module.mode = E.db.mMediaTag.details.mode
	module.windows = E.db.mMediaTag.details.windows
	module.toggle = E.db.mMediaTag.details.toggle

	if not module.isEnabled then
		module:RegisterEvent("PLAYER_ENTERING_WORLD")
		module.isEnabled = true
	end

	DetailsEmbedded()
end
