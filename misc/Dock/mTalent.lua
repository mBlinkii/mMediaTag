local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

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

local active = ""
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
	if E.db[mPlugin].mDock.tip.enable then
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
		DT.tooltip:AddLine(format("%s %s%s|r", ns.LeftButtonIcon, tip, L["Left Click: Show Talent Specialization UI"]))
		DT.tooltip:AddLine(
			format("%s %s%s|r", ns.MiddleButtonIcon, tip, L["Middle Click: Change Talent Specialization"])
		)
		DT.tooltip:AddLine(format("%s %s%s|r", ns.RightButtonIcon, tip, L["Right Click: Change Loot Specialization"]))
		DT.tooltip:Show()
	end
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self)
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.talent.path,
		Notifications = false,
		Text = E.db[mPlugin].mDock.talent.showrole,
		Spezial = false,
	}

	mMT:DockInitialisation(self)

	if E.db[mPlugin].mRoleSymbols.enable then
		local path = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga"
		TANK_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.tank), ":14:14")
		HEALER_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.heal), ":14:14")
		DPS_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.dd), ":14:14")
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

	if E.db[mPlugin].mDock.talent.showrole then
		if IsInGroup() then
			local Role = UnitGroupRolesAssigned("PLAYER")

			if Role == "TANK" then
				self.mIcon.TextA:SetText(TANK_ICON)
			elseif Role == "HEALER" then
				self.mIcon.TextA:SetText(HEALER_ICON)
			else
				self.mIcon.TextA:SetText(DPS_ICON)
			end
		end
	end
end

local function OnLeave(self)
	if E.db[mPlugin].mDock.tip.enable then
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
			if not _G.PlayerTalentFrame then
				_G.LoadAddOn("Blizzard_TalentUI")
			end
			if not _G.PlayerTalentFrame:IsShown() then
				ShowUIPanel(_G.PlayerTalentFrame)
			else
				HideUIPanel(_G.PlayerTalentFrame)
			end
		elseif button == "MiddleButton" then
			DT:SetEasyMenuAnchor(DT.EasyMenu, self)
			_G.EasyMenu(specList, DT.EasyMenu, nil, nil, nil, "MENU")
		else
			local _, specName = GetSpecializationInfo(specIndex)
			menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, specName)

			DT:SetEasyMenuAnchor(DT.EasyMenu, self)
			_G.EasyMenu(menuList, DT.EasyMenu, nil, nil, nil, "MENU")
		end
	end
end

DT:RegisterDatatext(
	mTextName,
	"mDock",
	{
		"CHARACTER_POINTS_CHANGED",
		"PLAYER_TALENT_UPDATE",
		"ACTIVE_TALENT_GROUP_CHANGED",
		"PLAYER_LOOT_SPEC_UPDATED",
		"GROUP_ROSTER_UPDATE",
	},
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	nil
)
