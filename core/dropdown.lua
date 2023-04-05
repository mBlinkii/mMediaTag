local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local LSM = E.Libs.LSM
local addon, ns = ...

--Lua functions
local tinsert = tinsert
local format = format

--WoW API / Variables
local _G = _G
local GetCursorPosition = GetCursorPosition
local InCombatLockdown = InCombatLockdown
local UnitClass = UnitClass
local CreateFrame = CreateFrame
local strfind = strfind
local ToggleFrame = ToggleFrame

-- ElvUI
local ElvUF = ElvUF

--Variables
local autoHideDelay = 2
local PADDING = 10
local BUTTON_HEIGHT = 16
local mDropDownFrame = {}

-- frame hide functon for the timer
function mMT:DropDownTimer()
	mDropDownFrame:Hide()
end

-- on click function
local function OnClick(btn)
	mMT:CancelAllTimers(mDropDownFrame.mTimer) -- cancel timer
	btn:GetParent():Hide() -- hide frame
	if btn.func then -- custom click function
		btn.func()
	end
end

-- on enter function
local function OnEnter(btn)
	mMT:CancelAllTimers(mDropDownFrame.mTimer)
	btn.hoverTex:Show()
	if btn.funcOnEnter then
		btn.funcOnEnter(btn) -- custom on enter function
	end
end

-- on leave function
local function OnLeave(btn)
	mDropDownFrame.mTimer = mMT:ScheduleTimer("DropDownTimer", autoHideDelay) -- start the timer/ autohide delay
	btn.hoverTex:Hide()
	if btn.funcOnLeave then
		btn.funcOnLeave(btn) -- custom on leave function
	end
end

-- list = tbl see below
-- text = string, Secondtext = string, icon = texture, func = function, funcOnEnter = function,
--funcOnLeave = function, isTitle = bolean, macro = macrotext, tooltip = id or var you can use for the functions, notClickable = bolean
function mMT:mDropDown(list, frame, menuparent, ButtonWidth, HideDelay)
	autoHideDelay = HideDelay or 2

	mMT:CancelAllTimers(mDropDownFrame.mTimer)

	if not frame.buttons then
		frame.buttons = {}
		frame:SetFrameStrata("DIALOG")
		frame:SetClampedToScreen(true)
		tinsert(_G.UISpecialFrames, frame:GetName())
		frame:Hide()
	end

	for i = 1, #frame.buttons do
		frame.buttons[i]:Hide()
	end

	for i = 1, #list do
		if not frame.buttons[i] then
			if list[i].macro then
				frame.buttons[i] = CreateFrame("Button", "MacroButton", frame, "SecureActionButtonTemplate")
				frame.buttons[i]:SetAttribute("type", "macro")
				frame.buttons[i]:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
				frame.buttons[i]:SetAttribute("macrotext1", list[i].macro)
			else
				frame.buttons[i] = CreateFrame("Button", nil, frame)

				if not list[i].notClickable then
					frame.buttons[i].func = list[i].func
					frame.buttons[i]:SetScript("OnClick", OnClick)
				end
			end

			local texture = LSM:Fetch("statusbar", E.db[mPlugin].mHoverTexture)
				or [[Interface\QuestFrame\UI-QuestTitleHighlight]]

			if not list[i].isTitle then
				frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, "OVERLAY")
				frame.buttons[i].hoverTex:SetAllPoints()
				frame.buttons[i].hoverTex:SetTexture(texture)

				if E.db[mPlugin].mClassColorHover then
					local _, unitClass = UnitClass("player")
					local class = ElvUF.colors.class[unitClass]
					frame.buttons[i].hoverTex:SetGradient("HORIZONTAL", {r = class[1], g = class[2], b = class[3], a = 0.75},
						{r = mMT:ColorCheck(class[1] + 0.4), g = mMT:ColorCheck(class[2] + 0.4), b = mMT:ColorCheck(class[3] + 0.4), a = 0.75})
				else
					frame.buttons[i].hoverTex:SetColorTexture(0.94, 0.76, 0.05, 0.5)
				end

				frame.buttons[i].hoverTex:SetBlendMode("ADD")
				frame.buttons[i].hoverTex:Hide()
			end

			if list[i].text then
				frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, "BORDER")
				frame.buttons[i].text:SetAllPoints()
				frame.buttons[i].text:FontTemplate(nil, nil, "")
				frame.buttons[i].text:SetJustifyH("LEFT")
			end

			if list[i].Secondtext then
				frame.buttons[i].Secondtext = frame.buttons[i]:CreateFontString(nil, "BORDER")
				frame.buttons[i].Secondtext:SetAllPoints()
				frame.buttons[i].Secondtext:FontTemplate(nil, nil, "")
				frame.buttons[i].Secondtext:SetJustifyH("RIGHT")
			end

			if list[i].tooltip then
				frame.buttons[i].tooltip = list[i].tooltip
			end

			if not list[i].isTitle then
				frame.buttons[i]:SetScript("OnEnter", OnEnter)
				frame.buttons[i].funcOnEnter = list[i].funcOnEnter
				frame.buttons[i]:SetScript("OnLeave", OnLeave)
				frame.buttons[i].funcOnLeave = list[i].funcOnLeave
			end
		end

		if list[i].text and frame.buttons[i].text then
			if list[i].icon then
				frame.buttons[i].text:SetText(
					format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", list[i].icon, list[i].text) or ""
				)
			else
				frame.buttons[i].text:SetText(list[i].text or "")
			end
		end

		if list[i].Secondtext and frame.buttons[i].Secondtext then
			frame.buttons[i].Secondtext:SetText(list[i].Secondtext or "")
		end

		frame.buttons[i]:Show()
		frame.buttons[i]:Height(BUTTON_HEIGHT)
		frame.buttons[i]:Width(ButtonWidth)

		if i == 1 then
			frame.buttons[i]:Point("TOPLEFT", frame, "TOPLEFT", PADDING, -PADDING)
		else
			frame.buttons[i]:Point("TOPLEFT", frame.buttons[i - 1], "BOTTOMLEFT")
		end
	end

	frame:Height((#list * BUTTON_HEIGHT) + PADDING * 2)
	frame:Width(ButtonWidth + PADDING * 2)
	frame:ClearAllPoints()

	if menuparent then
		local point = E:GetScreenQuadrant(menuparent)
		local bottom = point and strfind(point, "BOTTOM")
		local left = point and strfind(point, "LEFT")

		local anchor1 = (bottom and left and "BOTTOMLEFT")
			or (bottom and "BOTTOMRIGHT")
			or (left and "TOPLEFT")
			or "TOPRIGHT"
		local anchor2 = (bottom and left and "TOPLEFT")
			or (bottom and "TOPRIGHT")
			or (left and "BOTTOMLEFT")
			or "BOTTOMRIGHT"

		frame:Point(anchor1, menuparent, anchor2)
	else
		frame:Point("LEFT", frame:GetParent(), "RIGHT")
	end

	mDropDownFrame = frame

	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(format("|CFFE74C3C%s|r", _G.ERR_NOT_IN_COMBAT))
		mMT:Print(format("|CFFE74C3C%s|r", _G.ERR_NOT_IN_COMBAT))
	else
		mDropDownFrame.mTimer = mMT:ScheduleTimer("DropDownTimer", autoHideDelay)
		ToggleFrame(frame)
	end
end
