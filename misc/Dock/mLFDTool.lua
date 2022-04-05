local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local DT = E:GetModule("DataTexts");
local addon, ns = ...

--Lua functions
local format = format

--WoW API / Variables
local IsInInstance = IsInInstance

--Variables
local mText = format("Dock %s", DUNGEONS_BUTTON)
local mTextName = "mLFDTool"
local mInctanceInfoText, keyText, mAffixesText, vaultinforaidText, vaultinfomplusText, vaultinfopvpText = {}, {}, {}, {}, {}, {}
local TANK_ICON = E:TextureString(E.Media.Textures.Tank, ':14:14')
local HEALER_ICON = E:TextureString(E.Media.Textures.Healer, ':14:14')
local DPS_ICON = E:TextureString(E.Media.Textures.DPS, ':14:14')
local lastPanel = nil

local function MakeIconString(tank, healer, damage)
	if E.db[mPlugin].mRoleSymbols.enable then
		local path = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga"
		TANK_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.tank), ':14:14')
		HEALER_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.heal), ':14:14')
		DPS_ICON = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.dd), ':14:14')
	end

	local str = ''
	if tank then
		str = str..TANK_ICON
	end
	if healer then
		str = str..HEALER_ICON
	end
	if damage then
		str = str..DPS_ICON
	end

	return str
end


local function mLFDTooltip()
	local _, hc, myth, mythp, other, titel, tip = mMT:mColorDatatext()
	
	mInctanceInfoText = mMT:InctanceInfo()
	if mInctanceInfoText then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mInctanceInfoText[1])
		DT.tooltip:AddLine(mInctanceInfoText[2])
		DT.tooltip:AddLine(mInctanceInfoText[3])
	end
	
	if E.db[mPlugin].mDock.lfd.keystone then
		keyText = mMT:OwenKeystone()
		if keyText then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(keyText[1])
			DT.tooltip:AddLine(keyText[2])
		end 
		
	end

	if E.db[mPlugin].mDock.lfd.score then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
	end
	
	if E.db[mPlugin].mDock.lfd.affix then
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
	
	if E.db[mPlugin].mDock.lfd.greatvault then
		local vaultinfohighest, ok = 0, false
		vaultinforaidText, vaultinfomplusText, vaultinfopvpText, vaultinfohighest, ok = mMT:mGetVaultInfo()
		if ok then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format("%s%s|r", titel, GREAT_VAULT_REWARDS))
			
			if vaultinfohighest then
				DT.tooltip:AddDoubleLine(format(L["%sActual reward:|r"], other), vaultinfohighest or "-")
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
			DT.tooltip:AddLine(format("%s%s|r", titel, GREAT_VAULT_REWARDS_WAITING))
		end
	end
	
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s %s%s|r", ns.LeftButtonIcon, tip, L["left click to open LFD Window"]))
	if E.db[mPlugin].mDock.lfd.greatvault then
		DT.tooltip:AddLine(format("%s %s%s|r", ns.RightButtonIcon, tip, L["right click to open Great Vault Window"]))
	end
end

local function mDockCheckFrame()
	return ( PVEFrame and PVEFrame:IsShown() )
end

function mMT:CheckFrameLFDTool(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

function mMT:LFDToolGreatVault(self)
	if not C_WeeklyRewards.HasAvailableRewards() then
		mMT:NotificationTimer(self, true)
	end
end

local function OnEnter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameLFDTool")

	if E.db[mPlugin].mDock.tip.enable then
		mLFDTooltip()
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event)
	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.lfd.path,
		Notifications = true,
		Text = true,
		Spezial = false,
	}

	local mTextString = ""

	if E.db[mPlugin].mDock.lfd.cta then
		local tankReward = false
		local healerReward = false
		local dpsReward = false
		local unavailable = true

		--Dungeons
		for i = 1, GetNumRandomDungeons() do
			local id = GetLFGRandomDungeonInfo(i)
			for x = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible and forTank and itemCount > 0 then tankReward = true; unavailable = false end
				if eligible and forHealer and itemCount > 0 then healerReward = true; unavailable = false end
				if eligible and forDamage and itemCount > 0 then dpsReward = true; unavailable = false end
			end
		end

		--LFR
		for i = 1, GetNumRFDungeons() do
			local id = GetRFDungeonInfo(i)
			for x = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible and forTank and itemCount > 0 then tankReward = true; unavailable = false end
				if eligible and forHealer and itemCount > 0 then healerReward = true; unavailable = false end
				if eligible and forDamage and itemCount > 0 then dpsReward = true; unavailable = false end
			end
		end

		if not unavailable then
			mTextString = MakeIconString(tankReward, healerReward, dpsReward)
		else
			mTextString = ""
		end
	end

	mMT:DockInitialisation(self)

	mMT:ShowHideNotification(self, (E.db[mPlugin].mDock.lfd.greatvault and C_WeeklyRewards.HasAvailableRewards()), "LFDToolGreatVault")

	local inInstance, _ = IsInInstance()
	local isGroup = IsInGroup()
	local isRaid = IsInRaid()

	if E.db[mPlugin].mDock.lfd.difficulty and (inInstance or isGroup) then
		if inInstance then
			self.mIcon.TextA:SetText(mMT:DungeonDifficultyShort())
		elseif isGroup then
			self.mIcon.TextA:SetText(mMT:InctanceDifficultyDungeon())
		elseif isRaid then
			self.mIcon.TextA:SetText(mMT:InctanceDifficultyRaid())
		end
	else
		self.mIcon.TextA:SetText(mTextString)
	end

	lastPanel = self
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
		mMT:mOnClick(self, "CheckFrameLFDTool")
		if E.db[mPlugin].mDock.lfd.greatvault then
			if button == "LeftButton" then
				ToggleLFDParentFrame()
			else
				if not WeeklyRewardsFrame then
					LoadAddOn("Blizzard_WeeklyRewards")
				end
				if WeeklyRewardsFrame:IsVisible() then
					WeeklyRewardsFrame:Hide()
				else
					WeeklyRewardsFrame:Show()
				end
			end
		else
			ToggleLFDParentFrame()
		end
	end
end

DT:RegisterDatatext(mTextName, "mDock", {"LFG_UPDATE_RANDOM_INFO", "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO"}, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)