local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G
local strupper = strupper
local UIParentLoadAddOn = UIParentLoadAddOn

local textString = ""

local function OnClick(self, button)
	if button == "LeftButton" or button == "MiddleButton" then
		_G.ToggleLFDParentFrame()
		if button == "MiddleButton" then _G.PVEFrameTab3:Click() end
	else
		if not _G.WeeklyRewardsFrame then UIParentLoadAddOn("Blizzard_WeeklyRewards") end
		if _G.WeeklyRewardsFrame:IsVisible() then
			_G.WeeklyRewardsFrame:Hide()
		else
			_G.WeeklyRewardsFrame:Show()
		end
	end
end

local function OnEnter(self)
	local instanceInfos = mMT:GetDungeonInfo()

	if instanceInfos then
		DT.tooltip:AddLine(mMT:TC(L["Dungeon Infos:"], "title"))
		DT.tooltip:AddDoubleLine(mMT:TC(L["Name:"]), mMT:TC(instanceInfos.name))

		if instanceInfos.difficultyShort or instanceInfos.difficultyName then
			local difficulty = (instanceInfos.difficultyShort or instanceInfos.difficultyName) .. ((instanceInfos.isChallengeMode and instanceInfos.level) or "")
			DT.tooltip:AddDoubleLine(mMT:TC(L["Difficulty:"]), instanceInfos.difficultyColor:WrapTextInColorCode(difficulty))
		end

		if instanceInfos.isGuildParty then DT.tooltip:AddDoubleLine(mMT:TC(L["Guild Party:"]), mMT:TC(L["Yes"], "green")) end
		DT.tooltip:AddLine(" ")
	end

	local playerDifficultyInfos = mMT:GetPlayerDifficulty()
	if playerDifficultyInfos then
		DT.tooltip:AddLine(mMT:TC(L["Difficulty Infos:"], "title"))
		DT.tooltip:AddDoubleLine(mMT:TC(L["Dungeon:"]), playerDifficultyInfos.dungeon.color:WrapTextInColorCode(playerDifficultyInfos.dungeon.name))
		DT.tooltip:AddDoubleLine(mMT:TC(L["Raid:"]), playerDifficultyInfos.raid.color:WrapTextInColorCode(playerDifficultyInfos.raid.name))
		if E.Retail then DT.tooltip:AddDoubleLine(mMT:TC(L["Legacy Raid:"]), playerDifficultyInfos.legacy.color:WrapTextInColorCode(playerDifficultyInfos.legacy.name)) end
		DT.tooltip:AddLine(" ")
	end

	if E.Retail and E:XPIsLevelMax() then
		local myScore = mMT:GetMyMythicPlusScore()
		local myKeystone = mMT:GetMyKeystone()

		if myKeystone and myScore then
			DT.tooltip:AddLine(mMT:TC(L["My Info"], "title"))
			DT.tooltip:AddDoubleLine(mMT:TC(DUNGEON_SCORE), myScore)
			DT.tooltip:AddDoubleLine(mMT:TC(L["Keystone"]), myKeystone)
			DT.tooltip:AddLine(" ")
		end

		if DB.keystones and next(DB.keystones) then
			DT.tooltip:AddLine(mMT:TC(L["Keystones on your Account"], "title"))
			for _, characters in pairs(DB.keystones) do
				DT.tooltip:AddDoubleLine(characters.name, characters.key)
			end
			DT.tooltip:AddLine(" ")
		end

		local weeklyAffixes = mMT:GetWeeklyAffixes()
		if weeklyAffixes then
			DT.tooltip:AddLine(mMT:TC(L["This week's Affix"], "title"))
			DT.tooltip:AddLine(mMT:TC(weeklyAffixes))
			DT.tooltip:AddLine(" ")
		end

		local vaultInfoRaid, vaultInfoDungeons, vaultInfoWorld = mMT:GetVaultInfo()
		if vaultInfoRaid and vaultInfoDungeons and vaultInfoWorld then
			DT.tooltip:AddLine(mMT:TC(GREAT_VAULT_REWARDS, "title"))
			DT.tooltip:AddDoubleLine(mMT:TC(RAID), mMT:TC(vaultInfoRaid))
			DT.tooltip:AddDoubleLine(mMT:TC(DUNGEONS), mMT:TC(vaultInfoDungeons))
			DT.tooltip:AddDoubleLine(mMT:TC(WORLD), mMT:TC(vaultInfoWorld))
			DT.tooltip:AddLine(" ")
		end
	end

	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. mMT:TC(L["left click to open LFD Frame"], "tip"))
	DT.tooltip:AddLine(MEDIA.rightClick .. " " .. mMT:TC(L["right click to open Great Vault"], "tip"))
	DT.tooltip:Show()
end

local function OnEvent(self)
	local text = L["Dungeon"]
	if E.db.mMT.datatexts.dungeon.icon ~= "none" then text = E:TextureString(MEDIA.icons.lfg[E.db.mMT.datatexts.dungeon.icon], ":14:14") .. " " .. text end

	if E.db.mMT.datatexts.dungeon.dungeon_name then
		local instanceInfos = mMT:GetDungeonInfo()
		if instanceInfos and (instanceInfos.difficultyShort or instanceInfos.difficultyName) then
			local challengeModeInfo = instanceInfos.isChallengeMode and instanceInfos.level
			local delveInfo = instanceInfos.isDelve and "-" .. instanceInfos.level
			local difficulty = (instanceInfos.difficultyShort or instanceInfos.difficultyName) .. ((challengeModeInfo or delveInfo) or "")
			local guild = instanceInfos.isGuild and MEDIA.color.GUILD
			text = strupper(instanceInfos.shortName or instanceInfos.name)
			text = guild and guild:WrapTextInColorCode(text) or text
			text = instanceInfos.difficultyColor:WrapTextInColorCode(difficulty) .. " - " .. text
		end
	end

	self.text:SetFormattedText(textString, text)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	textString = strjoin("", textHex, "%s|r")

	OnEvent(self)
end

local events = { "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO", "ENCOUNTER_END", "SCENARIO_UPDATE", "PLAYER_DIFFICULTY_CHANGED" }

DT:RegisterDatatext("mMT - Dungeon", mMT.Name, events, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Dungeon"], nil, ValueColorUpdate)
