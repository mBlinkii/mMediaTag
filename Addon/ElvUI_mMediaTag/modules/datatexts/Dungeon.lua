local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local wipe = table.wipe

--WoW API / Variables
local _G = _G
local IsInInstance = IsInInstance
local C_MythicPlus = C_MythicPlus
local C_ChallengeMode = C_ChallengeMode

--Variables
local mText = L["Dungeon"]

local function mSetup(self)
	local isMaxLevel = E:XPIsLevelMax()

	local mInstanceInfo = mMT:InstanceInfo()
	if mInstanceInfo then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mInstanceInfo[1] or "-")
		DT.tooltip:AddLine(mInstanceInfo[2] or "-")
		DT.tooltip:AddLine(mInstanceInfo[3] or "-")
	end

	local inInstance, _ = IsInInstance()
	if inInstance then
		local infoInstance = mMT:DungeonInfo()
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(infoInstance[1] or "-")
		DT.tooltip:AddLine(infoInstance[2] or "-")
		DT.tooltip:AddLine(infoInstance[3] or "-")
	end

	if E.Retail and C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
		local infoMythicPlus = mMT:MythicPlusDungeon()
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(infoMythicPlus[1] or "-")
		DT.tooltip:AddLine(infoMythicPlus[2] or "-")
	end

	if E.Retail and E.db.mMT.dungeon.key and isMaxLevel then
		local key = mMT:OwenKeystone()
		if key then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(key[1] or "-")
			DT.tooltip:AddLine(key[2] or "-")
		end
	end

	if E.Retail and E.db.mMT.dungeon.score and isMaxLevel then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
	end

	if E.Retail and E.db.mMT.dungeon.affix then
		local mAffixes = mMT:WeeklyAffixes()
		if mAffixes then
			DT.tooltip:AddLine(" ")
			if mAffixes[3] then
				DT.tooltip:AddLine(mAffixes[3] or "-")
			else
				DT.tooltip:AddLine(mAffixes[1] or "-")
				DT.tooltip:AddLine(mAffixes[2] or "-")
			end
		end
		mAffixes = wipe(mAffixes)
	end
end

local function OnClick(self, button)
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
end

local function OnEnter(self)
	mSetup(self)
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open LFD Frame"]))
	if E.Retail then
		DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open Great Vault"]))
	end
	DT.tooltip:Show()
end

local function OnEvent(self, event, unit)
	local TextString = mText
	if E.db.mMT.dungeon.icon then
		TextString = format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatext\\dungeon.tga:16:16:0:0:64:64|t %s", mText)
	end

	local hex = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
	local string = strjoin("", hex, "%s|r")

	if E.db.mMT.dungeon.texttoname then
		local inInstance, _ = IsInInstance()
		if inInstance then
			self.text:SetText(mMT:GetDungeonInfo(true, true))
		else
			self.text:SetFormattedText(string, TextString)
		end
	else
		self.text:SetFormattedText(string, TextString)
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mDungeon", "mMediaTag", { "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO" }, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
