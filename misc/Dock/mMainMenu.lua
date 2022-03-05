local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local DT = E:GetModule("DataTexts");
local addon, ns = ...

--Lua functions
local format = format

--WoW API / Variables
local _G = _G
local GetFramerate = GetFramerate

--Variables
local mText = format("Dock %s", MAINMENU_BUTTON)
local mTextName = "mMainMenu"
local TextColor = mMT:mClassColorString()
local statusColors = {
	'|cff0CD809',
	'|cffE8DA0F',
	'|cffFF9000',
	'|cffD80909'
}

local function mDockCheckFrame()
	return ( GameMenuFrame and GameMenuFrame:IsShown() )
end

function mMT:CheckFrameMainMenu(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function mTip()
	if E.db[mPlugin].mDock.tip.enable then
		local _, _, _, _, other, titel, tip = mMT:mColorDatatext()
		DT.tooltip:ClearLines()
		
		local framerate = GetFramerate()
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local fps = framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4
		local pingHome = latencyHome < 150 and 1 or (latencyHome >= 150 and latencyHome < 300) and 2 or (latencyHome >= 300 and latencyHome < 500) and 3 or 4
		local pingWorld = latencyWorld < 150 and 1 or (latencyWorld >= 150 and latencyWorld < 300) and 2 or (latencyWorld >= 300 and latencyWorld < 500) and 3 or 4
		local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
		DT.tooltip:AddDoubleLine(format("%s%s|r", L["FPS:"], titel), format("%s%d|r %sFPS", statusColors[fps], framerate, other))
		DT.tooltip:AddDoubleLine(format("%s%s|r", L["Home Latency:"], titel), format("%s%d|r %sms", statusColors[pingHome], latencyHome, other))
		DT.tooltip:AddDoubleLine(format("%s%s|r", L["World Latency:"], titel), format("%s%d|r %sms", statusColors[pingWorld], latencyWorld, other))
		DT.tooltip:AddLine(" ")
		if E.db[mPlugin].mDock.mainmenu.sound then
			local VolumeInfo = mMT:VolumeToolTip()
			DT.tooltip:AddDoubleLine(VolumeInfo.name, VolumeInfo.level)
			DT.tooltip:AddLine(" ")
		end
		DT.tooltip:AddDoubleLine(ns.mName, format("%sVer.|r %s%s|r" , titel, other, ns.mVersion))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(format("%s %s%s|r", ns.LeftButtonIcon, tip, L["Click left to open the main menu."]))
		DT.tooltip:AddLine(format("%s %s%s|r", ns.RightButtonIcon, tip, L["Right click to open the ElvUI settings."]))
		if E.db[mPlugin].mDock.mainmenu.sound then
			DT.tooltip:AddLine(format("%s %s%s|r", ns.MiddleButtonIcon, tip, L["Change volume with the mouse wheel"]))
		end
		
		DT.tooltip:Show()
	end
end

local function OnEnter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameMainMenu")

	mTip()
end

local function onMouseWheel(_, delta)
	if E.db[mPlugin].mDock.mainmenu.sound then
		mMT:SetVolume(delta)
		mTip()
	end
end


local wait, count = 20, 0 -- initial delay for update (let the ui load)
local function OnUpdate(self, elapsed)

	wait = wait - elapsed

	if wait < 0 then
		local Option = E.db[mPlugin].mDock.mainmenu.option
		wait = 1

		local framerate = floor(GetFramerate())
		local _, _, _, latency = GetNetStats()

		local fps = framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4
		local ping = latency < 150 and 1 or (latency >= 150 and latency < 300) and 2 or (latency >= 300 and latency < 500) and 3 or 4

        if self.mIcon.TextA and self.mIcon.TextB then
			local Color = E.db[mPlugin].mDock.mainmenu.color
			if Option ~= "none" then
				if  Color == "default" then
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
				self.mIcon.TextB:SetText(E.db[mPlugin].mDock.mainmenu.text)
			end
        end

		if Option == "none" then 
			self.mIcon.TextA:SetText("")
			self.mIcon.TextB:SetText("")
			self:SetScript("OnUpdate", nil)
		end

		if not enteredFrame then return end

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
		IconTexture = E.db[mPlugin].mDock.mainmenu.path,
		Notifications = false,
		Text = true,
		Spezial = true,
	}

	mMT:DockInitialisation(self)

	if E.db[mPlugin].mDock.mainmenu.sound then
		self:EnableMouseWheel(true)
		self:SetScript('OnMouseWheel', onMouseWheel)
	else
		self:EnableMouseWheel(false)
	end
end

local function OnLeave(self)
	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self, button)
	if mMT:CheckCombatLockdown() then
		if button == "LeftButton" then
			mMT:mOnClick(self, "CheckFrameMainMenu")
			if ( not GameMenuFrame:IsShown() ) then
				if ( VideoOptionsFrame:IsShown() ) then
					VideoOptionsFrameCancel:Click();
				elseif ( AudioOptionsFrame:IsShown() ) then
					AudioOptionsFrameCancel:Click();
				elseif ( InterfaceOptionsFrame:IsShown() ) then
					InterfaceOptionsFrameCancel:Click();
				end
				CloseMenus();
				CloseAllWindows()
				ShowUIPanel(GameMenuFrame);
			else
				HideUIPanel(GameMenuFrame);
			end
		elseif button == "MiddleButton" and E.db[mPlugin].mDock.mainmenu.sound then
			mMT:MuteVolume()
		else
			mMT:mOnClick(self, "CheckFrameMainMenu")
			E:ToggleOptionsUI()
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, OnUpdate, OnClick, OnEnter, OnLeave, mText, nil, nil)