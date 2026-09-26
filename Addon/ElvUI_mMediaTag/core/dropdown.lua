local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local _G = _G
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local ToggleFrame = ToggleFrame
local format = format
local strfind = strfind
local tinsert = tinsert
local tremove = tremove

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

local function OnEnter(button)
	button.hoverTex:Show()
	if button.funcOnEnter then button.funcOnEnter(button) end
end

local function OnLeave(button)
	button.hoverTex:Hide()
	if button.funcOnLeave then button.funcOnLeave(button) end
end

-- secure buttons block Hide in combat, so the menu has to be gone before lockdown starts
local function OnCombatStart(frame)
	if frame.timer then
		frame.timer:Cancel()
		frame.timer = nil
	end

	frame:Hide()
end

local function ReleaseButtons(frame)
	for i = #frame.buttons, 1, -1 do
		local btn = frame.buttons[i]
		btn:Hide()
		tinsert(btn.isSecure and frame.securePool or frame.pool, btn)
		frame.buttons[i] = nil
	end
end

local function AcquireButton(frame, secure)
	local btn = tremove(secure and frame.securePool or frame.pool)
	if btn then return btn end

	if secure then
		btn = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
		btn:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
		btn.isSecure = true
	else
		btn = CreateFrame("Button", nil, frame)
	end

	btn.hoverTex = btn:CreateTexture(nil, "OVERLAY")
	btn.hoverTex:SetAllPoints()
	btn.hoverTex:SetTexture([[Interface\Addons\ElvUI_mMediaTag\media\select.tga]])
	btn.hoverTex:SetVertexColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b, 0.5)
	btn.hoverTex:SetBlendMode("BLEND")

	btn.text = btn:CreateFontString(nil, "BORDER")
	btn.text:SetAllPoints()
	btn.text:SetJustifyH("LEFT")

	btn.right_text = btn:CreateFontString(nil, "BORDER")
	btn.right_text:SetAllPoints()
	btn.right_text:SetJustifyH("RIGHT")

	return btn
end

-- entry keys: text, right_tex, color, icon, icon_size, func, funcOnEnter, funcOnLeave, isTitle, macro, attributes, tooltip, notClickable, submenu, list (nested table)
function mMT:DropDown(list, frame, parent, ButtonWidth, HideDelay, submenu)
	local SAVE_HEIGHT = E.db.general.fontSize / 3 + 16
	local BUTTON_HEIGHT, BUTTON_WIDTH = 0, 0
	local font = E.db.general.font
	local fontSize = E.db.general.fontSize
	local fontFlag = E.db.general.fontStyle
	autoHideDelay = HideDelay or 2

	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(format("|CFFE74C3C%s|r", _G.ERR_NOT_IN_COMBAT))
		mMT:Print(format("|CFFE74C3C%s|r", _G.ERR_NOT_IN_COMBAT))
		return
	end

	if not frame.buttons then
		frame.buttons = {}
		frame.pool = {}
		frame.securePool = {}
		frame:SetFrameStrata("DIALOG")
		frame:SetClampedToScreen(true)
		tinsert(_G.UISpecialFrames, frame:GetName())
		frame:RegisterEvent("PLAYER_REGEN_DISABLED")
		frame:SetScript("OnEvent", OnCombatStart)
		frame:Hide()
	end

	ReleaseButtons(frame)

	for i, item in ipairs(list) do
		local btn = AcquireButton(frame, (item.macro or item.attributes) and true or false)
		btn.submenu = item.submenu

		if item.attributes then
			for key, value in pairs(item.attributes) do
				btn:SetAttribute(key, value)
			end
		elseif item.macro then
			btn:SetAttribute("type", "macro")
			btn:SetAttribute("macrotext1", item.macro)
		elseif item.notClickable then
			btn:SetScript("OnClick", nil)
		else
			btn.func = item.func
			btn:SetScript("OnClick", OnClick)
		end

		btn.hoverTex:Hide()
		btn.tooltip = item.tooltip
		btn.funcOnEnter = item.funcOnEnter
		btn.funcOnLeave = item.funcOnLeave
		btn:SetScript("OnEnter", not item.isTitle and OnEnter or nil)
		btn:SetScript("OnLeave", not item.isTitle and OnLeave or nil)

		btn.text:FontTemplate(font, fontSize, fontFlag)
		btn.right_text:FontTemplate(font, fontSize, fontFlag)

		local iconSize = item.icon_size or 14
		local text = item.icon and E:TextureString(item.icon, ":" .. iconSize .. ":" .. iconSize) .. " " .. item.text or item.text or ""
		btn.text:SetText(item.color and format("%s%s|r", item.color, text) or text)
		btn.right_text:SetText(item.right_text or "")

		btn:ClearAllPoints()
		if i == 1 then
			btn:Point("TOPLEFT", frame, "TOPLEFT", PADDING, -PADDING)
		else
			btn:Point("TOPLEFT", frame.buttons[i - 1], "BOTTOMLEFT")
		end

		BUTTON_HEIGHT = max(btn.text:GetStringHeight(), BUTTON_HEIGHT, SAVE_HEIGHT)
		BUTTON_WIDTH = max(btn.text:GetStringWidth() + btn.right_text:GetStringWidth(), BUTTON_WIDTH, ButtonWidth)

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
