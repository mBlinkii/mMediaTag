local E = unpack(ElvUI)

-- Cache WoW Globals
local _G = _G
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local LSM = E.Libs.LSM
local ToggleFrame = ToggleFrame
local format = format
local strfind = strfind
local tinsert = tinsert

local autoHideDelay = 2
local PADDING = 10

local function DropDownTimer(menuFrame)
	if not menuFrame:IsMouseOver() then
		menuFrame:Hide()
		menuFrame.timer:Cancel()
		menuFrame.timer = nil

		if menuFrame.isSubmenu and not menuFrame.parent.timer then menuFrame.parent.timer = C_Timer.NewTicker(autoHideDelay, function()
			DropDownTimer(menuFrame.parent)
		end) end
	end
end

-- list = tbl see below
-- text = string, right_tex = string, color = color string for first text, icon = texture, func = function, funcOnEnter = function,
-- funcOnLeave = function, isTitle = boolean, macro = macrotext, tooltip = id or var you can use for the functions, notClickable = boolean,
-- submenu = boolean
function mMT:DropDown(list, frame, parent, ButtonWidth, HideDelay, submenu)
	local SAVE_HEIGHT = E.db.general.fontSize / 3 + 16
	local BUTTON_HEIGHT, BUTTON_WIDTH = 0, 0
	local font = LSM:Fetch("font", E.db.general.font)
	local fontSize = E.db.general.fontSize
	local fontFlag = E.db.general.fontStyle
	autoHideDelay = HideDelay or 2

	if not frame.buttons then
		frame.buttons = {}
		frame:SetFrameStrata("DIALOG")
		frame:SetClampedToScreen(true)
		tinsert(_G.UISpecialFrames, frame:GetName())
		frame:Hide()
	end

	for i, _ in ipairs(frame.buttons) do
		frame.buttons[i]:Hide()
		frame.buttons[i] = nil
	end

	for i, item in ipairs(list) do
		local btn = frame.buttons[i] or (item.macro and CreateFrame("Button", "MacroButton", frame, "SecureActionButtonTemplate") or CreateFrame("Button", nil, frame))
		btn.submenu = item.submenu

		if item.macro then
			btn:SetAttribute("type", "macro")
			btn:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
			btn:SetAttribute("macrotext1", item.macro)
		elseif not item.notClickable then
			local function OnClick(button)
				if button.func then button.func() end

				local buttonParent = button:GetParent()

				if not button.submenu then
					buttonParent:Hide()
				elseif buttonParent.timer then
					buttonParent.timer:Cancel()
					buttonParent.timer = nil
				end
			end

			btn.func = item.func
			btn:SetScript("OnClick", OnClick)
		end

		if not item.isTitle then
			btn.hoverTex = btn.hoverTex or btn:CreateTexture(nil, "OVERLAY")
			btn.hoverTex:SetAllPoints()
			btn.hoverTex:SetTexture([[Interface\AddOns\!mMT_MediaPack\media\textures\k35.tga]] or [[Interface\QuestFrame\UI-QuestTitleHighlight]])
			btn.hoverTex:SetVertexColor(mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, 0.75)
			btn.hoverTex:SetBlendMode("BLEND")
			btn.hoverTex:Hide()

			local function OnLeave(button)
				button.hoverTex:Hide()
				if button.funcOnLeave then button.funcOnLeave(button) end
			end

			local function OnEnter(button)
				button.hoverTex:Show()
				if btn.funcOnEnter then button.funcOnEnter(button) end
			end

			btn.tooltip = item.tooltip
			btn:SetScript("OnEnter", OnEnter)
			btn.funcOnEnter = item.funcOnEnter
			btn:SetScript("OnLeave", OnLeave)
			btn.funcOnLeave = item.funcOnLeave
		end

		btn.text = btn.text or btn:CreateFontString(nil, "BORDER")
		btn.text:SetAllPoints()
		btn.text:FontTemplate(font, fontSize, fontFlag)
		btn.text:SetJustifyH("LEFT")

		btn.right_text = btn.right_text or btn:CreateFontString(nil, "BORDER")
		btn.right_text:SetAllPoints()
		btn.right_text:FontTemplate(font, fontSize, fontFlag)
		btn.right_text:SetJustifyH("RIGHT")

		local text = item.icon and E:TextureString(item.icon, ":14:14") .. " " .. item.text or item.text or ""
		btn.text:SetText(item.color and format("%s%s|r", item.color, text) or text)
		if item.right_text then btn.right_text:SetText(item.right_text) end

		if i == 1 then
			btn:Point("TOPLEFT", frame, "TOPLEFT", PADDING, -PADDING)
		else
			btn:Point("TOPLEFT", frame.buttons[i - 1], "BOTTOMLEFT")
		end

		BUTTON_HEIGHT = max(btn.text:GetStringHeight(), BUTTON_HEIGHT, SAVE_HEIGHT)
		BUTTON_WIDTH = max(btn.text:GetStringWidth() + (btn.right_text and btn.right_text:GetStringWidth() or 0), BUTTON_WIDTH, ButtonWidth)

		frame.buttons[i] = btn
	end

	for _, btn in ipairs(frame.buttons) do
		btn:Show()
		btn:SetHeight(BUTTON_HEIGHT)
		btn:SetWidth(BUTTON_WIDTH + 2)
	end

	frame:SetHeight((#list * BUTTON_HEIGHT + PADDING * 2))
	frame:SetWidth(BUTTON_WIDTH + PADDING * 2)
	frame:ClearAllPoints()

	if parent then
		local point = E:GetScreenQuadrant(parent)
		local bottom = point and strfind(point, "BOTTOM")
		local left = point and strfind(point, "LEFT")

		local anchor1, anchor2

		if submenu then
			anchor1 = (left and "LEFT") or "RIGHT"
			anchor2 = (left and "RIGHT") or "LEFT"
		else
			anchor1 = (bottom and left and "BOTTOMLEFT") or (bottom and "BOTTOMRIGHT") or (left and "TOPLEFT") or "TOPRIGHT"
			anchor2 = (bottom and left and "TOPLEFT") or (bottom and "TOPRIGHT") or (left and "BOTTOMLEFT") or "BOTTOMRIGHT"
		end

		frame:SetPoint(anchor1, parent, anchor2)
		frame.pointA = anchor1
		frame.pointB = anchor2
	else
		frame:SetPoint("LEFT", frame:GetParent(), "RIGHT")
	end

	if submenu then
		frame.isSubmenu = submenu
		frame.parent = parent
	end

	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(format("|CFFE74C3C%s|r", _G.ERR_NOT_IN_COMBAT))
		mMT:Print(format("|CFFE74C3C%s|r", _G.ERR_NOT_IN_COMBAT))
	else
		if not frame.timer then frame.timer = C_Timer.NewTicker(autoHideDelay, function()
			DropDownTimer(frame)
		end) end

		if frame.name ~= submenu then
			frame.name = submenu
			frame:Show()
		else
			ToggleFrame(frame)
		end
	end
end
