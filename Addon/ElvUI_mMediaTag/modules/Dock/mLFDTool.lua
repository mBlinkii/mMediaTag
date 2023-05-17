local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--WoW API / Variables
local _G = _G
local IsInInstance = IsInInstance

--Variables
local mText = format("Dock %s", DUNGEONS_BUTTON)
local mTextName = "mLFDTool"
local mInstanceInfoText, keyText, mAffixesText, vaultinforaidText, vaultinfomplusText, vaultinfopvpText =
	{}, {}, {}, {}, {}, {}
local TANK_ICON = E:TextureString(E.Media.Textures.Tank, ":14:14")
local HEALER_ICON = E:TextureString(E.Media.Textures.Healer, ":14:14")
local DPS_ICON = E:TextureString(E.Media.Textures.DPS, ":14:14")

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

local function mLFDTooltip()
	local _, hc, myth, mythp, other, title, tip = mMT:mColorDatatext()

	mInstanceInfoText = mMT:InstanceInfo()
	if mInstanceInfoText then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mInstanceInfoText[1])
		DT.tooltip:AddLine(mInstanceInfoText[2])
		DT.tooltip:AddLine(mInstanceInfoText[3])
	end

	if E.db.mMT.dockdatatext.lfd.keystone then
		keyText = mMT:OwenKeystone()
		if keyText then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(keyText[1])
			DT.tooltip:AddLine(keyText[2])
		end
	end

	if E.db.mMT.dockdatatext.lfd.score then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
	end

	if E.db.mMT.dockdatatext.lfd.affix then
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

	if E.db.mMT.dockdatatext.lfd.greatvault then
		local vaultinfohighest, ok = 0, false
		vaultinforaidText, vaultinfomplusText, vaultinfopvpText, vaultinfohighest, ok = mMT:mGetVaultInfo()
		if ok then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format("%s%s|r", title, GREAT_VAULT_REWARDS))

			if vaultinfohighest then
				DT.tooltip:AddDoubleLine(format(L["%sActual reward:|r"], other), vaultinfohighest or "-")
			end

			if vaultinforaidText[1] then
				DT.tooltip:AddDoubleLine(
					format("%sRaid|r", myth),
					format(
						"%s, %s, %s",
						vaultinforaidText[1] or "-",
						vaultinforaidText[2] or "-",
						vaultinforaidText[3] or "-"
					)
				)
			end

			if vaultinfomplusText[1] then
				DT.tooltip:AddDoubleLine(
					format("%sMyth+|r", mythp),
					format(
						"%s, %s, %s",
						vaultinfomplusText[1] or "-",
						vaultinfomplusText[2] or "-",
						vaultinfomplusText[3] or "-"
					)
				)
			end

			if vaultinfopvpText[1] then
				DT.tooltip:AddDoubleLine(
					format("%sPvP|r", hc),
					format(
						"%s, %s, %s",
						vaultinfopvpText[1] or "-",
						vaultinfopvpText[2] or "-",
						vaultinfopvpText[3] or "-"
					)
				)
			end
		end
		if C_WeeklyRewards.HasAvailableRewards() then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format("%s%s|r", title, GREAT_VAULT_REWARDS_WAITING))
		end
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["left click to open LFD Window"]))
	if E.db.mMT.dockdatatext.lfd.greatvault then
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["right click to open Great Vault Window"]))
	end
end

local function mDockCheckFrame()
	return (PVEFrame and PVEFrame:IsShown())
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

	if E.db.mMT.dockdatatext.tip.enable then
		mLFDTooltip()
		DT.tooltip:Show()
	end
end

local function OnEvent(self, event)
	self.mSettings = {
	Name = mTextName,
	text = {
		special = false,
		textA = true,
		textB = false,
	},
	icon = {
		texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.lfd.icon],
		color = E.db.mMT.dockdatatext.lfd.iconology,
		customcolor = E.db.mMT.dockdatatext.lfd.customcolor,
	},
	Notifications = true,
}

	local mTextString = ""

	if E.db.mMT.dockdatatext.lfd.cta then
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

		if not unavailable then
			mTextString = MakeIconString(tankReward, healerReward, dpsReward)
		else
			mTextString = ""
		end
	end

	local inInstance, _ = IsInInstance()
	local isGroup = IsInGroup()
	local isRaid = IsInRaid()
	local text = nil

	if E.db.mMT.dockdatatext.lfd.difficulty and (inInstance or isGroup) then
		if inInstance then
			text = mMT:DungeonDifficultyShort()
		elseif isGroup then
			text = mMT:InctanceDifficultyDungeon()
		elseif isRaid then
			text = mMT:InctanceDifficultyRaid()
		end
	else
		text = mTextString
	end

	mMT:DockInitialization(self, event, text)

	mMT:ShowHideNotification(
		self,
		(E.db.mMT.dockdatatext.lfd.greatvault and C_WeeklyRewards.HasAvailableRewards()),
		"LFDToolGreatVault"
	)
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
		mMT:mOnClick(self, "CheckFrameLFDTool")
		if E.db.mMT.dockdatatext.lfd.greatvault then
			if button == "LeftButton" then
				_G.ToggleLFDParentFrame()
			else
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
			ToggleLFDParentFrame()
		end
	end
end

DT:RegisterDatatext(
	mTextName,
	"mDock",
	{
		"LFG_UPDATE_RANDOM_INFO",
		"CHALLENGE_MODE_START",
		"CHAT_MSG_SYSTEM",
		"LOADING_SCREEN_DISABLED",
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
