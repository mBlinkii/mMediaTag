local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format
local strjoin = strjoin

--WoW API / Variables
local IsInInstance = IsInInstance
local C_MythicPlus = C_MythicPlus
local C_ChallengeMode = C_ChallengeMode

--Variables
local mText = L["Dungeon"]

local function mSetup(self)
	local mInctanceInfo = mMT:InctanceInfo()
	if mInctanceInfo then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(mInctanceInfo[1] or "-")
		DT.tooltip:AddLine(mInctanceInfo[2] or "-")
		DT.tooltip:AddLine(mInctanceInfo[3] or "-")
	end

	local inInstance, _ = IsInInstance()
	if inInstance then
		local infoinInstance = mMT:DungeonInfo()
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(infoinInstance[1] or "-")
		DT.tooltip:AddLine(infoinInstance[2] or "-")
		DT.tooltip:AddLine(infoinInstance[3] or "-")
	end

	if C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
		local infoMythicPlus = mMT:MythicPlusDungeon()
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(infoMythicPlus[1] or "-")
		DT.tooltip:AddLine(infoMythicPlus[2] or "-")
	end

	if E.db[mPlugin].DKeystone then
		local key = mMT:OwenKeystone()
		if key then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(key[1] or "-")
			DT.tooltip:AddLine(key[2] or "-")
		end
	end

	if E.db[mPlugin].Dungeon.score then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
	end

	if E.db[mPlugin].DAffix then
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
	end
end

local function OnClick(self, button)
	DT.tooltip:Hide()
	ToggleLFDParentFrame()
end

local function OnEnter(self)
	mSetup(self)
	DT.tooltip:Show()
end

local function OnEvent(self, event, unit)
	local TextString = mText
	if E.db[mPlugin].Dungeon.showicon then
		TextString = format(
			"|T%s:16:16:0:0:128:128|t %s",
			"Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dungeon.tga",
			mText
		)
	end

	if E.db[mPlugin].DInstancInfoName then
		local inInstance, _ = IsInInstance()
		if inInstance then
			if C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
				self.text:SetText(format("%s +%s", mMT:DungeonInfoName(), mMT:MythPlusDifficultyShort()))
			else
				self.text:SetText(mMT:DungeonInfoName())
			end
		else
			self.text:SetFormattedText(mMT:mClassColorString(), TextString)
		end
	else
		self.text:SetFormattedText(mMT:mClassColorString(), TextString)
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext(
	"mDungeon",
	"mMediaTag",
	{ "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	nil
)
