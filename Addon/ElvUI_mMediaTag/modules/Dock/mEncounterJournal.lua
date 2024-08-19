local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded

--Variables
local Config = {
	name = "mMT_Dock_EncounterJournal",
	localizedName = mMT.DockString .. " " .. ENCOUNTER_JOURNAL,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
		GameTooltip:AddLine(ENCOUNTER_JOURNAL)
		GameTooltip:Show()
	end

	mMT:Dock_OnEnter(self, Config)
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		GameTooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		if not IsAddOnLoaded("Blizzard_EncounterJournal") then
			UIParentLoadAddOn("Blizzard_EncounterJournal")
		end
		ToggleFrame(_G.EncounterJournal)
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.encounter.icon]
		Config.icon.color = E.db.mMT.dockdatatext.encounter.customcolor and E.db.mMT.dockdatatext.encounter.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
