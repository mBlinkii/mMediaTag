local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local _G = _G
local LSM = E.Libs.LSM

--Variables
local DEV_TextA = true
local DEV_TextB = true
local DEV_Center = true

local DEV_Notification = true
local DEV_Texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga"
local DEV_CustomColor = false
local DEV_Color = { r = 1, g = 0.8, b = 0.6, a = 0.1 }


local Config = {
	name = "DEVICON",
	localizedName = "Dock" .. L["DEV ICON"],
	text = {
		enable = true,
		center = true,
		a = true, -- first label
		b = true, -- second label
	},
	icon = {
		notification = true,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
	misc = {
		secure = true,
		macroA = "/click EJMicroButton",
		macroB = "/click SpellbookMicroButton",
		funcOnEnter = nil,
		funcOnLeave = nil,
	},
}

local function OnEnter(self, a, b, c, d, e)
	--mMT:Print("ENTER", self, a, b, c, d, e)
	mMT:Dock_OnEnter(self:GetParent(), Config)
end

local function OnLeave(self)
	--mMT:Print("LEAVE")
	mMT:Dock_OnLeave(self:GetParent(), Config)
	--mMT:UpdateNotificationState(self, false)
end

local function OnClick(self)
	mMT:Print(self.mMT and self.mMT.conf)
	mMT:Dock_Click(self, Config)
	mMT:UpdateNotificationState(self, true)
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.text.textA = DEV_TextA
		Config.text.textB = DEV_TextB
		Config.text.center = DEV_Center

		Config.icon.notification = DEV_Notification
		Config.icon.texture = DEV_Texture
		Config.icon.color = DEV_CustomColor and DEV_Color or nil

		Config.misc.funcOnEnter = OnEnter
		Config.misc.funcOnLeave = OnLeave

		mMT:InitializeDockIcon(self, Config, event)
	else
		mMT:Print("ELSE A")
		--mMT:UpdateDockIcon(self, Config)
		mMT:UpdateNotificationState(self, true)
	end

	self.mMT_Dock.TextA:SetText("DEV")
	self.mMT_Dock.TextB:SetText("ICON")
	mMT:UpdateNotificationState(self, true)

end

DT:RegisterDatatext(Config.name, "mDock", {
	"CHARACTER_POINTS_CHANGED",
	"PLAYER_TALENT_UPDATE",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_LOOT_SPEC_UPDATED",
	"GROUP_ROSTER_UPDATE",
	"PLAYER_ENTERING_WORLD",
}, OnEvent, nil, nil, nil, nil, Config.localizedName, nil, nil)
--[[
	DT:RegisterDatatext(name, category, events, onEvent, onUpdate, onClick, onEnter, onLeave, localizedName, objectEvent, applySettings)

	name - name of the datatext (required) [string]
	category - name of the category the datatext belongs to. [string]
	events - must be a table with string values of event names to register [string or table]
	onEvent - function that gets fired when an event gets triggered [function]
	onUpdate - onUpdate script target function [function]
	onClick - function to fire when clicking the datatext [function]
	onEnter - function to fire OnEnter [function]
	onLeave - function to fire OnLeave, if not provided one will be set for you that hides the tooltip. [function]
	localizedName - localized name of the datetext [string]
	objectEvent - register events on an object, using E.RegisterEventForObject instead of panel.RegisterEvent [function]
	applySettings - function that fires when you change the dt settings or update the value color. [function]
]]
