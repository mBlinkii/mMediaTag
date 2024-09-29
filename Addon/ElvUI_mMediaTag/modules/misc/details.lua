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
	local windows = E.db.mMT.detailsEmbedded.windows

	if not detailsEmbedded then
		local chat = _G[chatEmbedded .. "Panel"]

		detailsEmbedded = CreateFrame("Frame", "mMT_DetailsEmbedded_Frame", UIParent, "BackdropTemplate")
		detailsEmbedded:SetFrameStrata("BACKGROUND")

		detailsToggle = CreateFrame("Button", "mMT_DetailsEmbedded_ToggleButton", UIParent, "BackdropTemplate")
		detailsToggle:SetFrameStrata("BACKGROUND")

		local chatHeight = chat:GetHeight()
		local chatWidth = chat:GetWidth()

		if windows > 2 then chatHeight = chatHeight * 2 end

		local backdrop = chat.backdrop:GetBackdrop()
		detailsEmbedded:SetBackdrop(backdrop)
		detailsToggle:SetBackdrop(backdrop)

		local r, g, b, a = chat.backdrop:GetBackdropBorderColor()
		detailsEmbedded:SetBackdropBorderColor(r, g, b, a)
		detailsToggle:SetBackdropBorderColor(r, g, b, a)

		r, g, b, a = chat.backdrop:GetBackdropColor()
		detailsEmbedded:SetBackdropColor(r, g, b, a)
		detailsToggle:SetBackdropColor(r, g, b, a)

		detailsEmbedded:SetSize(chatWidth, chatHeight)
		detailsToggle:SetSize(20, chatHeight)
		detailsToggle:SetAlpha(0)

		for i = 1, chat:GetNumPoints() do
			local point, _, relativePoint, xOfs, yOfs = chat:GetPoint(i)
			detailsEmbedded:SetPoint(point, chat, relativePoint, xOfs, yOfs)
		end

		detailsToggle:SetPoint(
			(chatEmbedded == "RightChat") and "BOTTOMRIGHT" or "BOTTOMLEFT",
			detailsEmbedded,
			(chatEmbedded == "RightChat") and "BOTTOMLEFT" or "BOTTOMRIGHT",
			(chatEmbedded == "RightChat") and -2 or 2,
			0
		)

		if windows > 1 then
			local windowsWidth = (windows == 1) and chatWidth or chatWidth / 2
			local windowsHeight = (windows <= 2) and chatHeight or chatHeight / 2
			local points = { "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT", "TOPRIGHT" }
			local offsets = {
				{ 1, 1 },
				{ -1, 1 },
				{ 1, -1 },
				{ -1, -1 },
			}

			for i = 1, windows do
				local x_offset, y_offset = unpack(offsets[i])
				detailsEmbedded["Window" .. i] = CreateFrame("Frame", "mMT_DetailsEmbedded_Window" .. i, detailsEmbedded)
				detailsEmbedded["Window" .. i]:SetSize(((windows == 3 and i == 3) and chatWidth or windowsWidth) - 2, windowsHeight - 2)
				detailsEmbedded["Window" .. i]:SetPoint(points[i], detailsEmbedded, x_offset, y_offset)
				detailsEmbedded["Window" .. i]:CreateBackdrop("Transparent")
			end
		end

		-- Animation Group for Zoom In
		-- local zoomIn = detailsToggle:CreateAnimationGroup()
		-- local zoomInScale = zoomIn:CreateAnimation("Scale")
		-- zoomInScale:SetScale(1, 2)
		-- zoomInScale:SetDuration(1)
		-- zoomInScale:SetSmoothing("OUT")

		-- -- Animation Group for Zoom Out
		-- local zoomOut = detailsToggle:CreateAnimationGroup()
		-- local zoomOutScale = zoomOut:CreateAnimation("Scale")
		-- zoomOutScale:SetScale(1, 0.5)
		-- zoomOutScale:SetDuration(1)
		-- zoomOutScale:SetSmoothing("IN")

		detailsToggle:RegisterForClicks("AnyDown")
		detailsToggle:SetScript("OnClick", function()
			mMT:DetailsEmbeddedToggle()

			if windows >= 3 then
				if detailsEmbedded:IsShown() then
					--if zoomIn:IsPlaying() then zoomIn:Stop() end
					--zoomOut:Play()
					detailsToggle:SetHeight(chatHeight)
				else
					--if zoomOut:IsPlaying() then zoomOut:Stop() end
					--zoomOut:Play()
					detailsToggle:SetHeight(chatHeight / 2)
				end
			end
		end)
		detailsToggle:SetScript("OnEnter", function(self)
			E:UIFrameFadeIn(self, 0.5, 0, 1)
			--if (windows >= 3) and (self:GetHeight() > chatHeight) then
			--if zoomOut:IsPlaying() then zoomOut:Stop() end
			--zoomIn:Play()
			---detailsToggle:SetHeight(chatHeight)
			--end
		end)
		detailsToggle:SetScript("OnLeave", function(self)
			E:UIFrameFadeOut(self, 0.5, 1, 0)
			--if (windows >= 3) and (self:GetHeight() < chatHeight) then
			--if zoomIn:IsPlaying() then zoomIn:Stop() end
			--zoomOut:Play()
			--end
		end)

		chat:Hide()
		detailsEmbedded:Show()
	end

	for i = 1, windows do
		local detailsWindow = Details:GetInstance(i)
		if detailsWindow then
			detailsWindow:UngroupInstance()
			detailsWindow.baseframe:ClearAllPoints()

			local embeddedWindow = windows > 1 and detailsEmbedded["Window" .. i] or detailsEmbedded

			detailsWindow.baseframe:SetParent(embeddedWindow)

			local frames = { detailsWindow.rowframe, detailsWindow.windowSwitchButton }
			for _, frame in ipairs(frames) do
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
		end
	end

	if windows == 2 then
		local instance1 = Details:GetInstance(1)
		local instance2 = Details:GetInstance(2)
		Details:CheckCoupleWindows(instance1, instance2)
	end
end

function mMT:SetupDetails()
	if E.db.mMT.detailsEmbedded.chatEmbedded ~= "DISABLE" then mMT:DetailsEmbedded() end

	for _, data in next, styles do
		_G.Details:AddCustomIconSet(data.texture, data.name, false, dropdownIcon, { 0, 1, 0, 1 })
	end
end
