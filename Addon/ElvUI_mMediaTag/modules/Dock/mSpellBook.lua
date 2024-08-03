local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local PlayerSpellsUtil = _G.PlayerSpellsUtil

--Variables
local _G = _G
local Config = {
	name = "mMT_Dock_SpellBook",
	localizedName = mMT.DockString .. " " .. (PLAYERSPELLS_BUTTON or SPELLBOOK_ABILITIES_BUTTON),
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine((PLAYERSPELLS_BUTTON or SPELLBOOK_ABILITIES_BUTTON))
		DT.tooltip:Show()
	end

	mMT:Dock_OnEnter(self, Config)
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.spellbook.icon]
		Config.icon.color = E.db.mMT.dockdatatext.spellbook.customcolor and E.db.mMT.dockdatatext.spellbook.iconcolor or nil

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
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		if PlayerSpellsUtil then
			PlayerSpellsUtil.ToggleSpellBookFrame()
		else
			ToggleFrame(_G.SpellBookFrame)
		end
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
