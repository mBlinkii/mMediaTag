local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local pi = math.pi

--Variables
local _G = _G
local Config = {
	name = "mMT_Dock_ItemLevel",
	localizedName = mMT.DockString .. " " .. "ItemLevel",
	category = "mMT-" .. mMT.DockString,
	text = {
		enable = true,
		center = true,
		a = true, -- first label
		b = true, -- second label
	},
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function colorize(num)
	if num >= 0 then
		return 0.1, 1, 0.1
	else
		return E:ColorGradient(-(pi / num), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	end
end

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:ClearLines()
		local avg, avgEquipped, avgPvp = GetAverageItemLevel()
		DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), 1, 1, 1, 0.1, 1, 0.1)
		DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), 1, 1, 1, colorize(avgEquipped - avg))
		DT.tooltip:AddDoubleLine(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT, format("%0.2f", avgPvp), 1, 1, 1, colorize(avgPvp - avg))

		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.itemlevel.icon]
		Config.icon.color = E.db.mMT.dockdatatext.itemlevel.customcolor and E.db.mMT.dockdatatext.itemlevel.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	local _, avgEquipped = GetAverageItemLevel()
	local text = mMT:round(avgEquipped or 0)

	local hex = nil
	if E.db.mMT.dockdatatext.itemlevel.color then
		local r, g, b = GetItemLevelColor()
		hex = E:RGBToHex(r, g, b)
	end

	self.mMT_Dock.TextA:SetText((hex or "") .. text .. "|r")
	self.mMT_Dock.TextB:SetText((E.db.mMT.dockdatatext.itemlevel.color and mMT.ClassColor.hex or "") .. E.db.mMT.dockdatatext.itemlevel.text .. "|r")
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
		_G.ToggleCharacter("PaperDollFrame")
	end
end

DT:RegisterDatatext(Config.name, Config.category, { "UPDATE_INVENTORY_DURABILITY" }, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
