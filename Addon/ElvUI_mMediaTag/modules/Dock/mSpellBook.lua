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
	misc = {
		secure = true,
		macroA = "/click SpellbookMicroButton",
		-- funcOnEnter = nil,
		-- funcOnLeave = nil,
	},
}

local dock = nil

local function OnEnter()
	if E.db.mMT.dockdatatext.tip.enable and dock then
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(dock, "ANCHOR_CURSOR_RIGHT")
		GameTooltip:AddDoubleLine((PLAYERSPELLS_BUTTON or SPELLBOOK_ABILITIES_BUTTON))
		GameTooltip:Show()
	end

	if dock then mMT:Dock_OnEnter(dock, Config) end
end

local function OnLeave()
	if E.db.mMT.dockdatatext.tip.enable then GameTooltip:Hide() end

	if dock then mMT:Dock_OnLeave(dock, Config) end
end

local function OnClick()
	if dock then
		if mMT:CheckCombatLockdown() then
			mMT:Dock_Click(dock, Config)
			if PlayerSpellsUtil then
				PlayerSpellsUtil.ToggleSpellBookFrame()
			else
				ToggleFrame(_G.SpellBookFrame)
			end
		end
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.spellbook.icon]
		Config.icon.color = E.db.mMT.dockdatatext.spellbook.customcolor and E.db.mMT.dockdatatext.spellbook.iconcolor or nil

		-- 		funcOnEnter = nil,
		-- 		funcOnLeave = nil,
		-- 		funcOnClick = nil,
		Config.misc.funcOnClick = OnClick
		Config.misc.funcOnEnter = OnEnter
		Config.misc.funcOnLeave = OnLeave
		dock = self

		mMT:InitializeDockIcon(self, Config, event)
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, nil, nil, nil, Config.localizedName, nil, nil)
