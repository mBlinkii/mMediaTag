local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local _G = _G
--Variables

local Config = {
	name = "mMT_Dock_BlizzardStore",
	localizedName = mMT.DockString .. " " .. BLIZZARD_STORE,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(BLIZZARD_STORE)
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.blizzardstore.icon]
		Config.icon.color = E.db.mMT.dockdatatext.blizzardstore.customcolor and E.db.mMT.dockdatatext.blizzardstore.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self)
	mMT:Dock_Click(self, Config)
	_G.StoreMicroButton:Click()
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
