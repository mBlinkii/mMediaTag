local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", TALENTS_BUTTON)
local mTextName = "mTalent"

local _G = _G
local ipairs, wipe = ipairs, wipe
local format, next, strjoin = format, next, strjoin
local GetLootSpecialization = GetLootSpecialization
local GetNumSpecializations = GetNumSpecializations
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetTalentInfo = GetTalentInfo
local HideUIPanel = HideUIPanel
local IsShiftKeyDown = IsShiftKeyDown
local SetLootSpecialization = SetLootSpecialization
local SetSpecialization = SetSpecialization
local ShowUIPanel = ShowUIPanel
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT
local C_SpecializationInfo_GetAllSelectedPvpTalentIDs = C_SpecializationInfo.GetAllSelectedPvpTalentIDs
local TANK_ICON = E:TextureString(E.Media.Textures.Tank, ":14:14")
local HEALER_ICON = E:TextureString(E.Media.Textures.Healer, ":14:14")
local DPS_ICON = E:TextureString(E.Media.Textures.DPS, ":14:14")

local active = nil
local activeString = strjoin("", "|cff00FF00", _G.ACTIVE_PETS, "|r")
local inactiveString = strjoin("", "|cffFF0000", _G.FACTION_INACTIVE, "|r")
local menuList = {
	{ text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
	{
		checked = function()
			return GetLootSpecialization() == 0
		end,
		func = function()
			SetLootSpecialization(0)
		end,
	},
}

local specList = {
	{ text = _G.SPECIALIZATION, isTitle = true, notCheckable = true },
}

local function mDockCheckFrame()
	return (PlayerTalentFrame and PlayerTalentFrame:IsShown())
end

function mMT:CheckFrameTalent(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	if E.db.mMT.dockdatatext.tip.enable then
		local _, _, _, _, other, titel, tip = mMT:mColorDatatext()
		local specialization = GetLootSpecialization()
		local sameSpec = specialization == 0 and GetSpecialization()
		local specIndex = DT.SPECIALIZATION_CACHE[sameSpec or specialization]

		if specIndex and specIndex.name then
			DT.tooltip:AddLine(
				format("%s%s|r", titel, format(LOOT_SPECIALIZATION_DEFAULT, format("|CFF00FA7D%s|r", specIndex.name)))
			)

			for i, info in ipairs(DT.SPECIALIZATION_CACHE) do
				DT.tooltip:AddLine(
					strjoin(" ", info.name, mMT:mIcon(info.icon), (i == active and activeString or inactiveString)),
					1,
					1,
					1
				)
			end

			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(
				format(
					"%s%s:|r %s%s|r",
					titel,
					SELECT_LOOT_SPECIALIZATION,
					other,
					sameSpec and format(LOOT_SPECIALIZATION_DEFAULT, format("|CFF00FA7D%s|r", specIndex.name))
						or specIndex.name
				)
			)
		end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(
			format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["Left Click: Show Talent Specialization UI"])
		)
		DT.tooltip:AddLine(
			format(
				"%s %s%s|r",
				mMT:mIcon(mMT.Media.Mouse["MIDDLE"]),
				tip,
				L["Middle Click: Change Talent Specialization"]
			)
		)
		DT.tooltip:AddLine(
			format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["Right Click: Change Loot Specialization"])
		)
		DT.tooltip:Show()
	end
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self)
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		text = {
			spezial = false,
			textA = E.db.mMT.dockdatatext.talent.showrole,
			textB = false,
		},
		icon = {
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.talent.icon],
			color = E.db.mMT.dockdatatext.talent.iconcolor,
			customcolor = E.db.mMT.dockdatatext.talent.customcolor,
		},
	}

	if E.db.mMT.roleicons.enable then
		TANK_ICON = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.tank], ":14:14")
		HEALER_ICON = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.heal], ":14:14")
		DPS_ICON = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.dd], ":14:14")
	end

	if #menuList == 2 then
		for index = 1, GetNumSpecializations() do
			local id, name, _, icon = GetSpecializationInfo(index)
			if id then
				menuList[index + 2] = {
					text = name,
					checked = function()
						return GetLootSpecialization() == id
					end,
					func = function()
						SetLootSpecialization(id)
					end,
				}
				specList[index + 1] = {
					text = format("|T%s:14:14:0:0:64:64:4:60:4:60|t  %s", icon, name),
					checked = function()
						return GetSpecialization() == index
					end,
					func = function()
						SetSpecialization(index)
					end,
				}
			end
		end
	end

	local specIndex = GetSpecialization()
	local specialization = GetLootSpecialization()
	local info = DT.SPECIALIZATION_CACHE[specIndex]

	if info then
		active = specIndex
	end

	local text = nil
	if E.db.mMT.dockdatatext.talent.showrole then
		if IsInGroup() then
			local Role = UnitGroupRolesAssigned("player")

			if Role == "TANK" then
				text = TANK_ICON
			elseif Role == "HEALER" then
				text =  HEALER_ICON
			else
				text = DPS_ICON
			end
		end
	end

	mMT:DockInitialisation(self, event, text)
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self, button)
	if mMT:CheckCombatLockdown() then
		local specIndex = GetSpecialization()
		if not specIndex then
			return
		end

		if button == "LeftButton" then
			_G.ToggleTalentFrame()
		elseif button == "MiddleButton" then
			E:SetEasyMenuAnchor(E.EasyMenu, self)
			_G.EasyMenu(specList, E.EasyMenu, nil, nil, nil, "MENU")
		else
			local _, specName = GetSpecializationInfo(specIndex)
			menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, specName)

			E:SetEasyMenuAnchor(E.EasyMenu, self)
			_G.EasyMenu(menuList, E.EasyMenu, nil, nil, nil, "MENU")
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", {
	"CHARACTER_POINTS_CHANGED",
	"PLAYER_TALENT_UPDATE",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_LOOT_SPEC_UPDATED",
	"GROUP_ROSTER_UPDATE",
}, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
