local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format
local wipe = table.wipe

--WoW API / Variables
local _G = _G
local IsInInstance = IsInInstance
local C_MythicPlus = C_MythicPlus
local C_ChallengeMode = C_ChallengeMode
local GetInstanceInfo = GetInstanceInfo
local UIParentLoadAddOn = UIParentLoadAddOn

local valueString, textString = "", ""
local icons = MEDIA.icons.lfg
-- 	mmt = MEDIA.icon,
-- 	colored = E:TextureString(MEDIA.icons.lfg.lfg01, ":14:14"),
-- 	white = E:TextureString(MEDIA.icons.datatexts.misc.menu_a, ":14:14"),
-- }


local function mSetup(self)
	local isMaxLevel = E:XPIsLevelMax()

	local mInstanceInfo = mMT:InstanceInfo()
	if mInstanceInfo then
		DT.tooltip:AddLine(" ")
		for i = 1, #mInstanceInfo do
			DT.tooltip:AddLine(mInstanceInfo[i])
		end
	end

	local inInstance, _ = IsInInstance()
	if inInstance then
		local infoInstance = mMT:DungeonInfo()
		if infoInstance then
			DT.tooltip:AddLine(" ")
			for i = 1, #infoInstance do
				DT.tooltip:AddLine(infoInstance[i])
			end
		end
	end

	if E.Retail and C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
		local infoMythicPlus = mMT:MythicPlusDungeon()
		if infoMythicPlus then
			DT.tooltip:AddLine(" ")
			for i = 1, #infoMythicPlus do
				DT.tooltip:AddLine(infoMythicPlus[i])
			end
		end
	end

	if E.Retail and E.db.mMT.dungeon.key and isMaxLevel then
		local key = mMT:OwenKeystone()
		if key then
			DT.tooltip:AddLine(" ")
			for i = 1, #key do
				DT.tooltip:AddLine(key[i])
			end
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
			for i = 1, #mAffixes do
				DT.tooltip:AddLine(mAffixes[i])
			end
		end
	end
end

local function OnClick(self, button)
	if button == "LeftButton" then
		PVEFrame_ToggleFrame("GroupFinderFrame", _G.LFDParentFrame)
	elseif E.Retail then
		if not _G.WeeklyRewardsFrame then UIParentLoadAddOn("Blizzard_WeeklyRewards") end
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
	if E.Retail then DT.tooltip:AddLine(format("%s  %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), E.db.mMT.datatextcolors.colortip.hex, L["Click to open Great Vault"])) end
	DT.tooltip:Show()
end

local function OnEvent(self)
	local text = L["Dungeon"]
	if E.db.mMT.datatexts.dungeon.icon ~= "none" then text = E:TextureString(MEDIA.icons.lfg[E.db.mMT.datatexts.dungeon.icon], ":14:14") .. " " .. text end

	if E.db.mMT.datatexts.dungeon.dungeon_name then
		local instanceInfos = mMT:GetDungeonInfo()
		if instanceInfos then
			text = instanceInfos.shortName or instanceInfos.name
		end
	end

	self.text:SetFormattedText(textString, text)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex
	textString = strjoin("", textHex, "%s|r")
	valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

local events = { "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO", "ENCOUNTER_END" }

DT:RegisterDatatext("mMT - Dungeon", mMT.Name, events, OnEvent, nil, nil, nil, nil, L["Dungeon"], nil, ValueColorUpdate)
--DT:RegisterDatatext("mMT - Dungeon", mMT.Name, events, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Dungeon"], nil, ValueColorUpdate)
