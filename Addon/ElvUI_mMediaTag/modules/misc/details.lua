local E = unpack(ElvUI)
local L = mMT.Locales

local detailsEmbedded, detailsToggle

local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\class\\"

local styles = {
	border = {
		name = mMT.NameShort .. "- Border",
		texture = path .. "mmt_border.tga",
	},
	classborder = {
		name = mMT.NameShort .. "- Class Border",
		texture = path .. "mmt_classcolored_border.tga",
	},
	hdborder = {
		name = mMT.NameShort .. "- HD Border",
		texture = path .. "mmt_hd_border.tga",
	},
	hdclassborder = {
		name = mMT.NameShort .. "- HD Class Border",
		texture = path .. "mmt_hd_class.tga",
	},
	hdround = {
		name = mMT.NameShort .. "- HD Round",
		texture = path .. "mmt_hd_round.tga",
	},
	transparent = {
		name = mMT.NameShort .. "- Transparent A",
		texture = path .. "mmt_transparent.tga",
	},
	transparentshadow = {
		name = mMT.NameShort .. "- Transparent B",
		texture = path .. "mmt_transparent_shadow.tga",
	},
	transparentplus = {
		name = mMT.NameShort .. "- Transparent C",
		texture = path .. "mmt_transparent_colorboost.tga",
	},
	transparentshadowplus = {
		name = mMT.NameShort .. "- Transparent D",
		texture = path .. "mmt_transparent_colorboost_shadow.tga",
	},
	outline = {
		name = mMT.NameShort .. "- Outline A",
		texture = path .. "mmt_transparent_outline.tga",
	},
	outlineshadow = {
		name = mMT.NameShort .. "- Outline B",
		texture = path .. "mmt_transparent_outline_shadow.tga",
	},
	outlineplus = {
		name = mMT.NameShort .. "- Outline C",
		texture = path .. "mmt_transparent_outline_colorboost.tga",
	},
	outlineshadowplus = {
		name = mMT.NameShort .. "- Outline D",
		texture = path .. "mmt_transparent_outline_shadow_colorboost.tga",
	},
}

local dropdownIcon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga"

local _G = _G
local mathmax = math.max
local InCombatLockdown = InCombatLockdown
local unpack = unpack
local Details = _G.Details
function mMT:DetailsEmbeddedToggle()
	if detailsEmbedded then
		local chatEmbedded = E.db.mMT.detailsEmbedded.chatEmbedded
		local chat = _G[chatEmbedded .. "Panel"]

		if detailsEmbedded:IsShown() then
			detailsEmbedded:Hide()
			chat:Show()
		else
			detailsEmbedded:Show()
			chat:Hide()
		end
	end
end

function mMT:DetailsEmbedded()
	local chatEmbedded = E.db.mMT.detailsEmbedded.chatEmbedded
	local detailsWindows = Details:GetOpenedWindowsAmount()
	local windows = mathmax(detailsWindows, E.db.mMT.detailsEmbedded.windows)

	if not detailsEmbedded then
		local chat = _G[chatEmbedded .. "Panel"]

		detailsEmbedded = CreateFrame("Frame", "mMT_DetailsEmbedded_Frame", UIParent, "BackdropTemplate")

		if E.db.mMT.detailsEmbedded.toggle then detailsToggle = CreateFrame("Button", "mMT_DetailsEmbedded_ToggleButton", UIParent, "BackdropTemplate") end

		local chatHeight, chatWidth = chat:GetHeight(), chat:GetWidth()
		if windows > 2 then chatHeight = chatHeight * 2 end

		local backdrop = chat.backdrop:GetBackdrop()
		local bbr, bbg, bbb, bba = chat.backdrop:GetBackdropBorderColor()
		local bdr, bdg, bdb, bda = chat.backdrop:GetBackdropColor()

		if detailsToggle then
			detailsToggle:SetBackdrop(backdrop)
			detailsToggle:SetBackdropBorderColor(bbr, bbg, bbb, bba)
			detailsToggle:SetBackdropColor(bdr, bdg, bdb, bda)
			detailsToggle:SetSize(20, chatHeight)
			detailsToggle:SetAlpha(0)

			detailsToggle:SetPoint(
				(chatEmbedded == "RightChat") and "BOTTOMRIGHT" or "BOTTOMLEFT",
				detailsEmbedded,
				(chatEmbedded == "RightChat") and "BOTTOMLEFT" or "BOTTOMRIGHT",
				(chatEmbedded == "RightChat") and -2 or 2,
				0
			)

			detailsToggle.backdropColor = { bdr, bdg, bdb, bda }
			detailsToggle.backdropBorderColor = { bbr, bbg, bbb, bba }

			detailsToggle:RegisterForClicks("AnyDown")
			detailsToggle:SetScript("OnClick", function()
				mMT:DetailsEmbeddedToggle()
			end)

			detailsToggle:SetScript("OnEnter", function(self)
				E:UIFrameFadeIn(self, 0.5, 0, 1)
				self:SetBackdropBorderColor(mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, 1)
				_G.GameTooltip:SetOwner(detailsToggle, "ANCHOR_CURSOR")
				_G.GameTooltip:AddLine(L["Details embedded toggle"])
				_G.GameTooltip:AddLine(" ")
				_G.GameTooltip:AddLine(L["Click to hide Details frames."])
				_G.GameTooltip:Show()
			end)

			detailsToggle:SetScript("OnLeave", function(self)
				E:UIFrameFadeOut(self, 0.5, 1, 0)
				self:SetBackdropBorderColor(unpack(self.backdropBorderColor))
				_G.GameTooltip:Hide()
			end)
		end

		local hide = E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "LEFT" or E.db.chat.panelBackdrop == "RIGHT"
		detailsEmbedded:SetBackdrop(backdrop)
		detailsEmbedded:SetBackdropBorderColor(bbr, bbg, bbb, hide and 0 or bba)
		detailsEmbedded:SetBackdropColor(bdr, bdg, bdb, hide and 0 or bda)

		detailsEmbedded:SetSize(chatWidth, chatHeight)

		for i = 1, chat:GetNumPoints() do
			local point, _, relativePoint, xOfs, yOfs = chat:GetPoint(i)
			detailsEmbedded:SetPoint(point, chat, relativePoint, xOfs, yOfs)
		end

		-- Chat Panel Background Texture
		if chat.tex then
			local texture = (chatEmbedded == "RightChat") and E.db.chat.panelBackdropNameRight or E.db.chat.panelBackdropNameLeft
			detailsEmbedded.tex = detailsEmbedded:CreateTexture(nil, 'OVERLAY')
			detailsEmbedded.tex:ClearAllPoints()
			detailsEmbedded.tex:SetPoint("TOPLEFT", chat, "TOPLEFT", 1, -1)
			detailsEmbedded.tex:SetPoint("BOTTOMRIGHT", chat, "BOTTOMRIGHT", -1, 1)
			detailsEmbedded.tex:SetTexture(texture)

			local a = E.db.general.backdropfadecolor.a or 0.5
			detailsEmbedded.tex:SetAlpha(a)
		end

		if windows > 1 then
			local windowsWidth = (windows == 1) and chatWidth or chatWidth / 2
			local windowsHeight = (windows <= 2) and chatHeight or chatHeight / 2
			local points = { "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT", "TOPRIGHT" }
			local offsets = { { 1, 1 }, { -1, 1 }, { 1, -1 }, { -1, -1 } }

			for i = 1, windows do
				local x_offset, y_offset = unpack(offsets[i])
				detailsEmbedded["Window" .. i] = CreateFrame("Frame", "mMT_DetailsEmbedded_Window" .. i, detailsEmbedded)
				detailsEmbedded["Window" .. i]:SetSize(((windows == 3 and i == 3) and chatWidth or windowsWidth) - 2, windowsHeight - 2)
				detailsEmbedded["Window" .. i]:SetPoint(points[i], detailsEmbedded, x_offset, y_offset)
			end
		end

		if E.db.mMT.detailsEmbedded.combatHide then
			local delay = E.db.mMT.detailsEmbedded.hideDelay

			local function AutoHide()
				if not InCombatLockdown() then mMT:DetailsEmbeddedToggle() end
			end

			detailsEmbedded:RegisterEvent("PLAYER_REGEN_DISABLED")
			detailsEmbedded:RegisterEvent("PLAYER_REGEN_ENABLED")
			detailsEmbedded:SetScript("OnEvent", function(_, event)
				if event == "PLAYER_REGEN_DISABLED" then
					if not detailsEmbedded:IsShown() then mMT:DetailsEmbeddedToggle() end
				elseif event == "PLAYER_REGEN_ENABLED" then
					if detailsEmbedded:IsShown() then E:Delay(delay, AutoHide) end
				end
			end)
		end

		detailsEmbedded:SetFrameStrata("BACKGROUND")

		chat:Hide()
		detailsEmbedded:Show()
	end

	local i = 1
	for _, instance in Details:ListInstances() do
		if i > windows then break end

		local detailsWindow = instance:IsEnabled() and instance
		if detailsWindow then
			detailsWindow:UngroupInstance()
			detailsWindow.baseframe:ClearAllPoints()

			local embeddedWindow = windows > 1 and detailsEmbedded["Window" .. i] or detailsEmbedded
			detailsWindow.baseframe:SetParent(embeddedWindow)

			for _, frame in ipairs({ detailsWindow.rowframe, detailsWindow.windowSwitchButton }) do
				frame:SetParent(detailsWindow.baseframe)
				frame:ClearAllPoints()
				frame:SetAllPoints()
			end

			local topOffset = detailsWindow.toolbar_side == 1 and -20 or 0
			local bottomOffset = (detailsWindow.show_statusbar and 14 or 0) + (detailsWindow.toolbar_side == 2 and 20 or 0)

			detailsWindow.baseframe:SetPoint("TOPLEFT", embeddedWindow, "TOPLEFT", 0, topOffset + Details.chat_tab_embed.y_offset)
			detailsWindow.baseframe:SetPoint("BOTTOMRIGHT", embeddedWindow, "BOTTOMRIGHT", Details.chat_tab_embed.x_offset, bottomOffset)

			detailsWindow:LockInstance(true)
			detailsWindow:SaveMainWindowPosition()
			i = i + 1
		end
	end
end

function mMT:SetupDetails()
	if E.db.mMT.detailsEmbedded.chatEmbedded ~= "DISABLE" then mMT:DetailsEmbedded() end

	for _, data in next, styles do
		_G.Details:AddCustomIconSet(data.texture, data.name, false, dropdownIcon, { 0, 1, 0, 1 })
	end
end
