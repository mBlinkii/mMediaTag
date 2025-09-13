local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock
local Tracker = M.Tracker

local icons = MEDIA.icons.dock

-- Lua functions
local format = format
local GetMountIDs = C_MountJournal.GetMountIDs
local GetMountInfoByID = C_MountJournal.GetMountInfoByID
local GetNumPets = C_PetJournal.GetNumPets
local GetPetInfoByIndex = C_PetJournal.GetPetInfoByIndex
local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetNumLearnedDisplayedToys = C_ToyBox.GetNumLearnedDisplayedToys

-- Variables
local _G = _G

local config = {
	name = "mMT_Dock_CollectionsJournal",
	localizedName = "|CFF01EEFFDock|r" .. " " .. COLLECTIONS,
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function GetOwnedMountCount()
	local count = 0
	local mountIDs = GetMountIDs()
	for i, mountID in ipairs(mountIDs) do
		local _, _, _, _, _, _, _, _, _, hideOnChar, isCollected = GetMountInfoByID(mountID)
		if isCollected and hideOnChar ~= true then count = count + 1 end
	end
	return count
end

local function GetOwnedPetCount()
	local totalPets = GetNumPets()
	local ownedCount = 0

	for i = 1, totalPets do
		local petID = GetPetInfoByIndex(i)
		if petID then
			local isOwned = GetPetInfoByPetID(petID)
			if isOwned then ownedCount = ownedCount + 1 end
		end
	end

	return ownedCount
end

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMT.dock.tooltip then
		local polished_pet_harm = Tracker:GetItemInfos(163036)
		local battle_pet_bandage = Tracker:GetItemInfos(86143)
		DT.tooltip:AddLine(COLLECTIONS, mMT:GetRGB("title"))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Collected"], mMT:GetRGB("title"))
		DT.tooltip:AddDoubleLine(L["Mounts"], GetOwnedMountCount(), mMT:GetRGB("text", "mark"))
		DT.tooltip:AddDoubleLine(L["Pets"], GetOwnedPetCount(), mMT:GetRGB("text", "mark"))
		DT.tooltip:AddDoubleLine(L["Toys"], GetNumLearnedDisplayedToys(), mMT:GetRGB("text", "mark"))

		if polished_pet_harm then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(polished_pet_harm.name, polished_pet_harm.count, mMT:GetRGB("text", "mark"))
		end

		if battle_pet_bandage then
            DT.tooltip:AddDoubleLine(battle_pet_bandage.name, battle_pet_bandage.count, mMT:GetRGB("text", "mark"))
        end

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then
		Dock:Click(self)
		_G.ToggleCollectionsJournal()
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		-- setup settings
		config.icon.texture = icons[E.db.mMT.dock.journal.style][E.db.mMT.dock.journal.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.journal.custom_color and MEDIA.color.dock.journal or nil

		Dock:CreateDockIcon(self, config, event)
	end
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
