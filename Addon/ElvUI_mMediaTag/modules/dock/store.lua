local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local _G = _G

local Config = {
	name = "mMT_Dock_BlizzardStore",
	localizedName = "|CFF01EEFFDock|r" .. " " .. BLIZZARD_STORE,
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)

	--if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(BLIZZARD_STORE)
		DT.tooltip:Show()
	--end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = MEDIA.icons.dock["account_balance_wallet"] --[E.db.mMT.dockdatatext.blizzardstore.icon]
		Config.icon.color = {r = 0.5, g = 1, b = 0.6, a = 1}--E.db.mMT.dockdatatext.blizzardstore.customcolor and E.db.mMT.dockdatatext.blizzardstore.iconcolor or nil

		Dock:CreateDockIcon(self, Config, event)
	end
end

local function OnLeave(self)
	--if E.db.mMT.dockdatatext.tip.enable then DT.tooltip:Hide() end

    DT.tooltip:Hide()
	Dock:OnLeave(self)
end

local function OnClick(self)
	Dock:Click(self)
	_G.StoreMicroButton:Click()
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
