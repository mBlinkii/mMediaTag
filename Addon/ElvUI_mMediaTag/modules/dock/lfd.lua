local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

-- code is partially based on ElvUI's Durability and Itemlevel datatext

local icons = MEDIA.icons.dock
local lfdDT = nil
local IsInInstance = IsInInstance
local IsInGroup = IsInGroup
local GetNumRandomDungeons = GetNumRandomDungeons
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetNumRFDungeons = GetNumRFDungeons
local GetLFGRoleShortageRewards = GetLFGRoleShortageRewards
local GetRFDungeonInfo = GetRFDungeonInfo
local TANK_ICON = E:TextureString(E.Media.Textures.Tank, ":14:14")
local HEALER_ICON = E:TextureString(E.Media.Textures.Healer, ":14:14")
local DPS_ICON = E:TextureString(E.Media.Textures.DPS, ":14:14")

local config = {
	name = "mMT_Dock_LFD",
	localizedName = "|CFF01EEFFDock|r" .. " " .. DUNGEONS_BUTTON,
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
	text = {
		enable = false,
		center = true,
		a = false, -- first label
	},
}

local function MakeIconString(tank, healer, damage)
	local str = ""
	if tank then str = str .. TANK_ICON end
	if healer then str = str .. HEALER_ICON end
	if damage then str = str .. DPS_ICON end

	return str
end

local function GetCallToTheArmsInfos()
	local tankReward = false
	local healerReward = false
	local dpsReward = false
	local unavailable = true

	--Dungeons
	for i = 1, GetNumRandomDungeons() do
		local id = GetLFGRandomDungeonInfo(i)
		for x = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
			local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
			if eligible and forTank and itemCount > 0 then
				tankReward = true
				unavailable = false
			end
			if eligible and forHealer and itemCount > 0 then
				healerReward = true
				unavailable = false
			end
			if eligible and forDamage and itemCount > 0 then
				dpsReward = true
				unavailable = false
			end
		end
	end

	--LFR
	for i = 1, GetNumRFDungeons() do
		local id = GetRFDungeonInfo(i)
		for x = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
			local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
			if eligible and forTank and itemCount > 0 then
				tankReward = true
				unavailable = false
			end
			if eligible and forHealer and itemCount > 0 then
				healerReward = true
				unavailable = false
			end
			if eligible and forDamage and itemCount > 0 then
				dpsReward = true
				unavailable = false
			end
		end
	end

	return not unavailable and MakeIconString(tankReward, healerReward, dpsReward)
end

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMT.dock.tooltip then
		if lfdDT then lfdDT.onEnter() end
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self, btn)
	Dock:Click(self)
	lfdDT = mMT:GetElvUIDataText("mMT - Dungeon")
	if lfdDT then lfdDT.onClick(self, btn) end
end

local function OnEvent(...)
	local self, event = ...

	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.lfd.style][E.db.mMT.dock.lfd.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.lfd.custom_color and MEDIA.color.dock.lfd or nil
		config.text.enable = E.db.mMT.dock.lfd.text
		config.text.a = E.db.mMT.dock.lfd.text

		Dock:CreateDockIcon(self, config, event)

		-- Create virtual frames and connect them to datatexts
		if not self.lfdVirtualFrame then
			self.lfdVirtualFrame = {
				name = "mMT - Dungeon",
				text = {
					SetFormattedText = E.noop,
				},
			}
			mMT:ConnectVirtualFrameToDataText("mMT - Dungeon", self.lfdVirtualFrame)
		end

		lfdDT = mMT:GetElvUIDataText("mMT - Dungeon")
	end

	if lfdDT and lfdDT ~= "Data Broker" then lfdDT.eventFunc(...) end

	if E.db.mMT.dock.lfd.text then
		local isInInstance = IsInInstance()
		local isInGroup = IsInGroup()
		local text = ""

		-- CTA info outside the instance
		if E.Retail and E.db.mMT.dock.lfd.call_to_the_Arms and not isInInstance then text = GetCallToTheArmsInfos() or "" end

		-- In instance: Show dungeon info
		if isInInstance then
			local info = mMT:GetDungeonInfo()
			if info and (info.difficultyShort or info.difficultyName) then
				local levelSuffix = info.isChallengeMode and info.level or (info.isDelve and "-" .. info.level) or ""
				local difficulty = (info.difficultyShort or info.difficultyName) .. levelSuffix
				local name = strupper(info.shortName or info.name)
				if info.isGuild then name = MEDIA.color.GUILD:WrapTextInColorCode(name) end
				text = info.difficultyColor:WrapTextInColorCode(difficulty) .. " - " .. name
			end

		-- In group, but not in instance
		elseif isInGroup then
			local difficulty, raid = mMT:GetInstanceDifficulty()
			if difficulty then text = (raid and L["Raid"] .. " - " or "") .. difficulty end
		end

		-- Fallback if nothing has been set
		self.mMT_Dock.TextA:SetText(text)
	end

	self.text:SetText("")
end

DT:RegisterDatatext( config.name, config.category, { "CHALLENGE_MODE_START", "UPDATE_INSTANCE_INFO", "SCENARIO_UPDATE", "PLAYER_DIFFICULTY_CHANGED", "LFG_UPDATE_RANDOM_INFO", "GROUP_ROSTER_UPDATE" }, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil )
