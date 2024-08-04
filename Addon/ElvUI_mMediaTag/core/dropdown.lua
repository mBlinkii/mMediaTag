local E = unpack(ElvUI)

--Lua functions
local tinsert = tinsert
local format = format

--WoW API / Variables
local _G = _G
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local strfind = strfind
local ToggleFrame = ToggleFrame

--Variables
local autoHideDelay = 2
local PADDING = 10
local mDropDownFrame = {}

-- frame hide function for the timer
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
-- text = string, SecondText = string, color = color string for first text, icon = texture, func = function, funcOnEnter = function,
-- funcOnLeave = function, isTitle = boolean, macro = macrotext, tooltip = id or var you can use for the functions, notClickable = boolean
function mMT:mDropDown(list, frame, menuparent, ButtonWidth, HideDelay)
	local SAVE_HEIGHT = (E.db.mMT.general.datatextfontsize or E.db.general.fontSize) / 3 + 16
	local BUTTON_HEIGHT = 0
	local BUTTON_WIDTH = 0

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
		frame.buttons[i] = nil
	end

	for i = 1, #list do
		if not frame.buttons[i] then
			if list[i].macro then
				frame.buttons[i] = CreateFrame("Button", "MacroButton", frame, "SecureActionButtonTemplate")
			else
				frame.buttons[i] = CreateFrame("Button", nil, frame)
			end
		end

		if list[i].macro then
			frame.buttons[i]:SetAttribute("type", "macro")
			frame.buttons[i]:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
			frame.buttons[i]:SetAttribute("macrotext1", list[i].macro)
		else
			if not list[i].notClickable then
				frame.buttons[i].func = list[i].func
				frame.buttons[i]:SetScript("OnClick", OnClick)
			end
		end

		local texture = [[Interface\AddOns\!mMT_MediaPack\media\textures\k35.tga]] or [[Interface\QuestFrame\UI-QuestTitleHighlight]]

		if not list[i].isTitle then
			frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, "OVERLAY")
			frame.buttons[i].hoverTex:SetAllPoints()
			frame.buttons[i].hoverTex:SetTexture(texture)
			frame.buttons[i].hoverTex:SetGradient("HORIZONTAL", { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b, a = 0.75 }, { r = mMT:ColorCheck(mMT.ClassColor.r + 0.4), g = mMT:ColorCheck(mMT.ClassColor.g + 0.4), b = mMT:ColorCheck(mMT.ClassColor.b + 0.4), a = 0.75 })
			frame.buttons[i].hoverTex:SetBlendMode("BLEND")
			frame.buttons[i].hoverTex:Hide()
		end

		if list[i].text then
			frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, "BORDER")
			frame.buttons[i].text:SetAllPoints()
			frame.buttons[i].text:FontTemplate(nil, E.db.mMT.general.datatextfontsize, "")
			frame.buttons[i].text:SetJustifyH("LEFT")
		end

		if list[i].SecondText then
			frame.buttons[i].SecondText = frame.buttons[i]:CreateFontString(nil, "BORDER")
			frame.buttons[i].SecondText:SetAllPoints()
			frame.buttons[i].SecondText:FontTemplate(nil, E.db.mMT.general.datatextfontsize, "")
			frame.buttons[i].SecondText:SetJustifyH("RIGHT")
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

		if list[i].text and frame.buttons[i].text then
			if list[i].color then
				list[i].text = format("%s%s|r", list[i].color, list[i].text)
			end

			if list[i].icon then
				frame.buttons[i].text:SetText(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", list[i].icon, list[i].text) or "")
			else
				frame.buttons[i].text:SetText(list[i].text or "")
			end
		end

		if list[i].SecondText and frame.buttons[i].SecondText then
			frame.buttons[i].SecondText:SetText(list[i].SecondText or "")
		end

		if i == 1 then
			frame.buttons[i]:Point("TOPLEFT", frame, "TOPLEFT", PADDING, -PADDING)
		else
			frame.buttons[i]:Point("TOPLEFT", frame.buttons[i - 1], "BOTTOMLEFT")
		end

		if frame.buttons[i].text then
			local height = frame.buttons[i].text:GetStringHeight()
			local width = frame.buttons[i].text:GetStringWidth()

			if height ~= 0 then
				BUTTON_HEIGHT = (height > BUTTON_HEIGHT) and height or BUTTON_HEIGHT
			end

			if width ~= 0 then
				if frame.buttons[i].SecondText then
					local secondWidth = frame.buttons[i].SecondText:GetStringWidth()

					if secondWidth ~= 0 then
						width = width + secondWidth
					end
				end
				BUTTON_WIDTH = (width > BUTTON_WIDTH) and width or BUTTON_WIDTH
			end
		end
	end

	BUTTON_HEIGHT = BUTTON_HEIGHT > SAVE_HEIGHT and BUTTON_HEIGHT or SAVE_HEIGHT
	BUTTON_WIDTH = BUTTON_WIDTH > ButtonWidth and BUTTON_WIDTH or ButtonWidth

	for i = 1, #list do
		frame.buttons[i]:Show()
		frame.buttons[i]:Height(BUTTON_HEIGHT)
		frame.buttons[i]:Width(BUTTON_WIDTH + 2)
	end

	frame:Height((#list * BUTTON_HEIGHT + PADDING * 2))
	frame:Width(BUTTON_WIDTH + PADDING * 2)
	frame:ClearAllPoints()

	if menuparent then
		local point = E:GetScreenQuadrant(menuparent)
		local bottom = point and strfind(point, "BOTTOM")
		local left = point and strfind(point, "LEFT")

		local anchor1 = (bottom and left and "BOTTOMLEFT") or (bottom and "BOTTOMRIGHT") or (left and "TOPLEFT") or "TOPRIGHT"
		local anchor2 = (bottom and left and "TOPLEFT") or (bottom and "TOPRIGHT") or (left and "BOTTOMLEFT") or "BOTTOMRIGHT"

		frame:Point(anchor1, menuparent, anchor2)
		frame.pointA = anchor1
		frame.pointB = anchor2
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
