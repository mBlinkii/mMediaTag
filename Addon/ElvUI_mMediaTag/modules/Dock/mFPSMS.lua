local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local _G = _G
local enteredFrame = false
local mText = format("Dock %s", L["FPS/ MS"])
local mTextName = "mFPSMS"
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

local function OnEnter(self, count)
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
		DT.tooltip:AddLine(
			format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["Click left to open the main menu."])
		)
		DT.tooltip:AddLine(
			format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["Right click to open the ElvUI settings."])
		)

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
			local Option = E.db.mMT.dockdatatext.fpsms.option
			local textA = nil
			local color = nil
			if E.db.mMT.dockdatatext.fpsms.color then
				if Option == "fps" then
					textA = framerate
					color = statusColors[fps]
				else
					textA = latency
					color = statusColors[ping]
				end
			else
				if Option == "fps" then
					textA = framerate
				else
					textA = latency
				end
			end
			mMT:mDockSetText(self, textA, E.db.mMT.dockdatatext.fpsms.text, color)
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
		text = {
			onlytext = false,
			spezial = true,
			textA = true,
			textB = true,
		},
		icon = {
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.fpsms.icon],
			color = E.db.mMT.dockdatatext.fpsms.iconcolor,
			customcolor = E.db.mMT.dockdatatext.fpsms.customcolor,
		},
	}

	mMT:DockInitialisation(self, event)
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
			if not _G.GameMenuFrame:IsShown() then
				if not E.Retail then
					if _G.VideoOptionsFrame:IsShown() then
						_G.VideoOptionsFrameCancel:Click()
					elseif _G.AudioOptionsFrame:IsShown() then
						_G.AudioOptionsFrameCancel:Click()
					elseif _G.InterfaceOptionsFrame:IsShown() then
						_G.InterfaceOptionsFrameCancel:Click()
					end
				end

				CloseMenus()
				CloseAllWindows()
				ShowUIPanel(_G.GameMenuFrame)
			else
				HideUIPanel(_G.GameMenuFrame)

				if E.Retail then
					MainMenuMicroButton:SetButtonState("NORMAL")
				else
					MainMenuMicroButton_SetNormal()
				end
			end
		else
			E:ToggleOptions()
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, OnUpdate, OnClick, OnEnter, OnLeave, mText, nil, nil)
