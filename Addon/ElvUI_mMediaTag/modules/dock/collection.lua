local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
if not mMT.Supports.collections then return end
local DT = E:GetModule("DataTexts")
local Dock = M.Dock
local Tracker = M.Tracker

local icons = MEDIA.icons.dock

-- Lua functions
local GetMountIDs = C_MountJournal.GetMountIDs
local GetMountInfoByID = C_MountJournal.GetMountInfoByID
local GetNumPets = C_PetJournal.GetNumPets
local GetPetInfoByIndex = C_PetJournal.GetPetInfoByIndex
local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetNumLearnedDisplayedToys = C_ToyBox.GetNumLearnedDisplayedToys
local SummonByID = C_MountJournal.SummonByID
local SummonRandomPet = C_PetJournal.SummonRandomPet
local GetSummonedPetGUID = C_PetJournal.GetSummonedPetGUID
local SummonPetByGUID = C_PetJournal.SummonPetByGUID
local tinsert = tinsert

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

	if E.db.mMediaTag.dock.tooltip then
		DT.tooltip:ClearLines()
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

		if battle_pet_bandage then DT.tooltip:AddDoubleLine(battle_pet_bandage.name, battle_pet_bandage.count, mMT:GetRGB("text", "mark")) end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(MEDIA.rightClick .. " " .. L["right click to open the menu."], mMT:GetRGB("tip"))
		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMediaTag.dock.tooltip then DT.tooltip:Hide() end
end

local function JournalEntry(text, tabIndex)
	return {
		text = text,
		func = function()
			_G.ToggleCollectionsJournal(tabIndex)
		end,
	}
end

local function OpenMenu(self)
	local menu = {
		mMT:MenuTitle(L["Random"]),
		{
			text = _G.MOUNTS,
			func = function()
				SummonByID(0)
			end,
		},
		{
			text = _G.PETS,
			func = function()
				SummonRandomPet(true)
			end,
		},
	}

	local petGUID = GetSummonedPetGUID()
	if petGUID then tinsert(menu, {
		text = _G.PET_DISMISS,
		func = function()
			SummonPetByGUID(petGUID)
		end,
	}) end

	tinsert(menu, mMT:MenuSpacer())
	tinsert(menu, mMT:MenuTitle(COLLECTIONS))
	tinsert(menu, JournalEntry(_G.MOUNTS, _G.COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS))
	tinsert(menu, JournalEntry(_G.PETS, _G.COLLECTIONS_JOURNAL_TAB_INDEX_PETS))
	tinsert(menu, JournalEntry(_G.TOY_BOX, _G.COLLECTIONS_JOURNAL_TAB_INDEX_TOYS))
	tinsert(menu, JournalEntry(_G.HEIRLOOMS, _G.COLLECTIONS_JOURNAL_TAB_INDEX_HEIRLOOMS))
	tinsert(menu, JournalEntry(_G.WARDROBE, _G.COLLECTIONS_JOURNAL_TAB_INDEX_APPEARANCES))
	tinsert(menu, JournalEntry(_G.WARBAND_SCENES, _G.COLLECTIONS_JOURNAL_TAB_INDEX_WARBAND_SCENES))

	mMT:ShowMenu(menu, self)
end

local function OnClick(self, btn)
	if not E:AlertCombat() then
		Dock:Click(self)
		if btn == "RightButton" then
			OpenMenu(self)
		else
			_G.ToggleCollectionsJournal()
		end
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		config.icon.texture = icons[E.db.mMediaTag.dock.collection.style][E.db.mMediaTag.dock.collection.icon] or MEDIA.fallback
		config.icon.color = E.db.mMediaTag.dock.collection.custom_color and MEDIA.color.dock.collection or nil

		Dock:CreateDockIcon(self, config, event)
	end
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
