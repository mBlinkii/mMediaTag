local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--WoW API / Variables
local _G = _G
local IsInInstance = IsInInstance
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame

--Variables
local mInstanceInfoText, keyText, mAffixesText, vaultinforaidText, vaultinfomplusText, vaultinfopvpText = {}, {}, {}, {}, {}, {}
local TANK_ICON = E:TextureString(E.Media.Textures.Tank, ":14:14")
local HEALER_ICON = E:TextureString(E.Media.Textures.Healer, ":14:14")
local DPS_ICON = E:TextureString(E.Media.Textures.DPS, ":14:14")

local Config = {
	name = "mMT_Dock_LFDTool",
	localizedName = mMT.DockString .. " " .. DUNGEONS_BUTTON,
	category = "mMT-" .. mMT.DockString,
	text = {
		enable = true,
		center = false,
		a = true, -- first label
		b = false, -- second label
	},
	icon = {
		notification = E.Retail,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function MakeIconString(tank, healer, damage)
	if E.db.mMT.roleicons.enable then
		TANK_ICON = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.tank], ":14:14")
		HEALER_ICON = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.heal], ":14:14")
		DPS_ICON = E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.dd], ":14:14")
	end

	local str = ""
	if tank then
		str = str .. TANK_ICON
	end
	if healer then
		str = str .. HEALER_ICON
	end
	if damage then
		str = str .. DPS_ICON
	end

	return str
end

local function getCallToArmsInfo()
	local tankReward = false
	local healerReward = false
	local dpsReward = false
	local unavailable = true
	local text = nil

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

	if not unavailable then
		text = MakeIconString(tankReward, healerReward, dpsReward)
	else
		text = ""
	end

	return text
end

local function mLFDTooltip()
	local _, hc, myth, mythp, other, title, tip = mMT:mColorDatatext()
	local isMaxLevel = E:XPIsLevelMax()

	mInstanceInfoText = mMT:InstanceInfo()
	if mInstanceInfoText then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mInstanceInfoText[1])
		DT.tooltip:AddLine(mInstanceInfoText[2])
		DT.tooltip:AddLine(mInstanceInfoText[3])
	end

	if E.Retail and E.db.mMT.dockdatatext.lfd.keystone and isMaxLevel then
		keyText = mMT:OwenKeystone()
		if keyText then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(keyText[1])
			DT.tooltip:AddLine(keyText[2])
		end
	end

	if E.Retail and E.db.mMT.dockdatatext.lfd.score and isMaxLevel then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
	end

	if E.Retail and E.db.mMT.dockdatatext.lfd.affix then
		mAffixesText = mMT:WeeklyAffixes()
		if mAffixesText then
			DT.tooltip:AddLine(" ")
			if mAffixesText[3] then
				DT.tooltip:AddLine(mAffixesText[3])
			else
				DT.tooltip:AddLine(mAffixesText[1])
				DT.tooltip:AddLine(mAffixesText[2])
			end
		end
	end

	if E.Retail and E.db.mMT.dockdatatext.lfd.greatvault and isMaxLevel then
		local vaultinfohighest, ok = nil, false
		vaultinforaidText, vaultinfomplusText, vaultinfopvpText, vaultinfohighest, ok = mMT:mGetVaultInfo()
		if ok then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format("%s%s|r", title, GREAT_VAULT_REWARDS))

			if vaultinfohighest then
				DT.tooltip:AddDoubleLine(format("%s%s|r", other, L["Actual reward:"]), vaultinfohighest or "-")
			end

			if vaultinforaidText[1] then
				DT.tooltip:AddDoubleLine(format("%sRaid|r", myth), format("%s, %s, %s", vaultinforaidText[1] or "-", vaultinforaidText[2] or "-", vaultinforaidText[3] or "-"))
			end

			if vaultinfomplusText[1] then
				DT.tooltip:AddDoubleLine(format("%sMyth+|r", mythp), format("%s, %s, %s", vaultinfomplusText[1] or "-", vaultinfomplusText[2] or "-", vaultinfomplusText[3] or "-"))
			end

			if vaultinfopvpText[1] then
				DT.tooltip:AddDoubleLine(format("%sPvP|r", hc), format("%s, %s, %s", vaultinfopvpText[1] or "-", vaultinfopvpText[2] or "-", vaultinfopvpText[3] or "-"))
			end
		end
		if C_WeeklyRewards.HasAvailableRewards() then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format("%s%s|r", title, GREAT_VAULT_REWARDS_WAITING))
		end
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["left click to open LFD Window"]))
	if E.Retail and E.db.mMT.dockdatatext.lfd.greatvault then
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["right click to open Great Vault Window"]))
	end
end

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)

	if E.Retail then
		mMT:UpdateNotificationState(self, C_WeeklyRewards.HasAvailableRewards())
	end

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:ClearLines()
		mLFDTooltip()
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.lfd.icon]
		Config.icon.color = E.db.mMT.dockdatatext.lfd.customcolor and E.db.mMT.dockdatatext.lfd.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	local inInstance, _ = IsInInstance()
	local isGroup = IsInGroup()
	local isRaid = IsInRaid()
	local text = nil

	if E.db.mMT.dockdatatext.lfd.cta and not inInstance then
		text = getCallToArmsInfo()
	end

	if E.db.mMT.dockdatatext.lfd.difficulty and (inInstance or isGroup) then
		if inInstance then
			text = mMT:GetDungeonInfo(true, true)
		elseif isGroup then
			text = mMT:InstanceDifficultyDungeon()
		elseif isRaid then
			text = mMT:InstanceDifficultyRaid()
		end
	end

	self.mMT_Dock.TextA:SetText(text or "")

	if E.Retail then
		mMT:UpdateNotificationState(self, C_WeeklyRewards.HasAvailableRewards())
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self, button)
	if E.Retail then
		mMT:UpdateNotificationState(self, C_WeeklyRewards.HasAvailableRewards())
	end

	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		if E.db.mMT.dockdatatext.lfd.greatvault then
			if button == "LeftButton" then
				PVEFrame_ToggleFrame("GroupFinderFrame", _G.LFDParentFrame)
			elseif E.Retail then
				if not _G.WeeklyRewardsFrame then
					LoadAddOn("Blizzard_WeeklyRewards")
				end
				if _G.WeeklyRewardsFrame:IsVisible() then
					_G.WeeklyRewardsFrame:Hide()
				else
					_G.WeeklyRewardsFrame:Show()
				end
			end
		else
			PVEFrame_ToggleFrame("GroupFinderFrame", _G.LFDParentFrame)
		end
	end
end

DT:RegisterDatatext(Config.name, Config.category, { "LFG_UPDATE_RANDOM_INFO", "CHALLENGE_MODE_START", "CHALLENGE_MODE_RESET", "CHALLENGE_MODE_COMPLETED", "GROUP_ROSTER_UPDATE", "CHAT_MSG_LOOT" }, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
