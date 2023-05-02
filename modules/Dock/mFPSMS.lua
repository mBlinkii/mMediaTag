local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", L["FPS/ MS"])
local mTextName = "mFPSMS"
local TextColor = mMT:mClassColorString()
local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909",
}

local function mDockCheckFrame()
	return (GameMenuFrame and GameMenuFrame:IsShown())
end

function mMT:CheckFrameFPSMS(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameFPSMS")

	if E.db.mMT.dockdatatext.tip.enable then
		local _, _, _, _, other, titel, tip = mMT:mColorDatatext()

		local framerate = GetFramerate()
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local fps = framerate >= 30 and 1
			or (framerate >= 20 and framerate < 30) and 2
			or (framerate >= 10 and framerate < 20) and 3
			or 4
		local pingHome = latencyHome < 150 and 1
			or (latencyHome >= 150 and latencyHome < 300) and 2
			or (latencyHome >= 300 and latencyHome < 500) and 3
			or 4
		local pingWorld = latencyWorld < 150 and 1
			or (latencyWorld >= 150 and latencyWorld < 300) and 2
			or (latencyWorld >= 300 and latencyWorld < 500) and 3
			or 4

		local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
		DT.tooltip:AddDoubleLine(
			format("%s%s|r", L["FPS:"], titel),
			format("%s%d|r %sFPS", statusColors[fps], framerate, other)
		)
		DT.tooltip:AddDoubleLine(
			format("%s%s|r", L["Home Latency:"], titel),
			format("%s%d|r %sms", statusColors[pingHome], latencyHome, other)
		)
		DT.tooltip:AddDoubleLine(
			format("%s%s|r", L["World Latency:"], titel),
			format("%s%d|r %sms", statusColors[pingWorld], latencyWorld, other)
		)
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(mMT.Name, format("%sVer.|r %s%s|r", titel, other, mMT.Version))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["Click left to open the main menu."]))
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["Right click to open the ElvUI settings."]))

		DT.tooltip:Show()
	end
end

local wait, count = 20, 0 -- initial delay for update (let the ui load)
local function OnUpdate(self, elapsed)
	wait = wait - elapsed

	if wait < 0 then
		wait = 1

		local framerate = floor(GetFramerate())
		local _, _, _, latency = GetNetStats()

		local fps = framerate >= 30 and 1
			or (framerate >= 20 and framerate < 30) and 2
			or (framerate >= 10 and framerate < 20) and 3
			or 4
		local ping = latency < 150 and 1
			or (latency >= 150 and latency < 300) and 2
			or (latency >= 300 and latency < 500) and 3
			or 4

		if self.mIcon.TextA and self.mIcon.TextB then
			local Color = E.db.mMT.dockdatatext.fpsms.color
			local Option = E.db.mMT.dockdatatext.fpsms.option

			if Color == "default" then
				if Option == "fps" then
					self.mIcon.TextA:SetText(format("%s%d|r", statusColors[fps], framerate))
				else
					self.mIcon.TextA:SetText(format("%s%d|r", statusColors[ping], latency))
				end
			else
				if Option == "fps" then
					self.mIcon.TextA:SetFormattedText(TextColor, format("%d|r", framerate))
				else
					self.mIcon.TextA:SetFormattedText(TextColor, format("%d|r", latency))
				end
			end
			self.mIcon.TextB:SetText(E.db.mMT.dockdatatext.fpsms.text)
		end

		if not enteredFrame then
			return
		end

		if InCombatLockdown() then
			if count > 3 then
				OnEnter(self)
				count = 0
			else
				OnEnter(self, count)
				count = count + 1
			end
		else
			OnEnter(self)
		end
	end
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.fpsms.icon],
		Notifications = false,
		Text = true,
		Spezial = true,
		IconColor = E.db.mMT.dockdatatext.fpsms.iconcolor,
		CustomColor = E.db.mMT.dockdatatext.fpsms.customcolor,
	}

	mMT:DockInitialisation(self)
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self, button)
	if mMT:CheckCombatLockdown() then
		mMT:mOnClick(self, "CheckFrameFPSMS")
		if button == "LeftButton" then
			if not GameMenuFrame:IsShown() then
				if VideoOptionsFrame:IsShown() then
					VideoOptionsFrameCancel:Click()
				elseif AudioOptionsFrame:IsShown() then
					AudioOptionsFrameCancel:Click()
				elseif InterfaceOptionsFrame:IsShown() then
					InterfaceOptionsFrameCancel:Click()
				end
				CloseMenus()
				CloseAllWindows()
				ShowUIPanel(GameMenuFrame)
			else
				HideUIPanel(GameMenuFrame)
			end
		else
			E:ToggleOptions()
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, OnUpdate, OnClick, OnEnter, OnLeave, mText, nil, nil)
