local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--WoW API / Variables
local _G = _G
local GetFramerate = GetFramerate

--Variables
local Config = {
	name = "mMT_Dock_MainMenu",
	localizedName = mMT.DockString .. " " .. MAINMENU_BUTTON,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}
local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909",
}

local function mTip()
	if E.db.mMT.dockdatatext.tip.enable then
		local _, _, _, _, other, title, tip = mMT:mColorDatatext()
		DT.tooltip:ClearLines()

		local framerate = GetFramerate()
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local fps = framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4
		local pingHome = latencyHome < 150 and 1 or (latencyHome >= 150 and latencyHome < 300) and 2 or (latencyHome >= 300 and latencyHome < 500) and 3 or 4
		local pingWorld = latencyWorld < 150 and 1 or (latencyWorld >= 150 and latencyWorld < 300) and 2 or (latencyWorld >= 300 and latencyWorld < 500) and 3 or 4
		_, _, latencyHome, latencyWorld = GetNetStats()
		DT.tooltip:AddDoubleLine(format("%s%s|r", "FPS:", title), format("%s%d|r %sFPS", statusColors[fps], framerate, other))
		DT.tooltip:AddDoubleLine(format("%s%s|r", L["Home Latency:"], title), format("%s%d|r %sms", statusColors[pingHome], latencyHome, other))
		DT.tooltip:AddDoubleLine(format("%s%s|r", L["World Latency:"], title), format("%s%d|r %sms", statusColors[pingWorld], latencyWorld, other))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(mMT.Name, format("%sVer.|r %s%s|r", title, other, mMT.Version))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["Click left to open the main menu."]))
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["Right click to open the ElvUI settings."]))

		DT.tooltip:Show()
	end
end

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)

	mTip()
end

local function OnEvent(self, event)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.mainmenu.icon]
		Config.icon.color = E.db.mMT.dockdatatext.mainmenu.customcolor and E.db.mMT.dockdatatext.mainmenu.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self, button)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		if button == "LeftButton" then
			mMT:Dock_Click(self, Config)
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

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
