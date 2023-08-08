local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local _G = _G
local Config = {
	name = "mMT_Dock_CollectionsJournal",
	localizedName = mMT.DockString .. " " .. COLLECTIONS,
	category = "mMT-" .. mMT.DockString,
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

--Polished Pet Charm
local PPC = {
	info = {
		color = "|CFF58D68D",
		id = 163036,
		name = nil,
		icon = nil,
		link = nil,
		count = nil,
		cap = nil,
	},
	loaded = false,
}
-- Battle Pet Bandage
local BPB = {
	info = {
		color = "|CFF1ABC9C",
		id = 86143,
		name = nil,
		icon = nil,
		link = nil,
		count = nil,
		cap = nil,
	},
	loaded = false,
}

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)
	mMT:GetCurrenciesInfo(PPC, true)

	local numOwned = 0
	local mountIDs = C_MountJournal.GetMountIDs()
	for i, mountID in ipairs(mountIDs) do
		local _, _, _, _, _, _, _, _, _, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
		if isCollected and hideOnChar ~= true then
			numOwned = numOwned + 1
		end
	end

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:AddLine(COLLECTIONS)
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Collected"])
		DT.tooltip:AddDoubleLine(format("|CFF40E0D0%s|r", L["Mounts"]), format("|CFF6495ED%s|r", numOwned))
		DT.tooltip:AddDoubleLine(format("|CFFDE3163%s|r", L["Pets"]), format("|CFF6495ED%s|r", select(2, C_PetJournal.GetNumPets())))
		if PPC.loaded and PPC.info.count ~= 0 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(PPC.info.color .. PPC.info.name .. "|r", "|CFF6495ED" .. PPC.info.count .. "|r")
		end
		if BPB.loaded and BPB.info.count ~= 0 then
			DT.tooltip:AddDoubleLine(BPB.info.color .. BPB.info.name .. "|r", "|CFF6495ED" .. BPB.info.count .. "|r")
		end
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.collection.icon]
		Config.icon.color = E.db.mMT.dockdatatext.collection.customcolor and E.db.mMT.dockdatatext.collection.iconcolor or nil

		mMT:GetCurrenciesInfo(PPC, true)
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
		_G.ToggleCollectionsJournal()
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
