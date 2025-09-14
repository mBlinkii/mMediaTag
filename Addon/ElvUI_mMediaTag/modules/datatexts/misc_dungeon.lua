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
		DT.tooltip:AddLine(L["Dungeon Infos:"], mMT:GetRGB("title"))
		DT.tooltip:AddDoubleLine(L["Name:"], instanceInfos.name, mMT:GetRGB("text", "text"))

		if instanceInfos.difficultyShort or instanceInfos.difficultyName then
			local difficulty = (instanceInfos.difficultyShort or instanceInfos.difficultyName) .. ((instanceInfos.isChallengeMode and instanceInfos.level) or "")
			DT.tooltip:AddDoubleLine(L["Difficulty:"], instanceInfos.difficultyColor:WrapTextInColorCode(difficulty), mMT:GetRGB())
		end

		DT.tooltip:AddDoubleLine(L["Guild Party:"], instanceInfos.isGuildParty and L["Yes"] or L["No"], mMT:GetRGB("text", instanceInfos.isGuildParty and "green" or "red"))
		DT.tooltip:AddLine(" ")
	end

	local playerDifficultyInfos = mMT:GetPlayerDifficulty()
	if playerDifficultyInfos then
		DT.tooltip:AddLine(L["Difficulty Infos:"], mMT:GetRGB("title"))
		DT.tooltip:AddDoubleLine(L["Dungeon:"], playerDifficultyInfos.dungeon.color:WrapTextInColorCode(playerDifficultyInfos.dungeon.name), mMT:GetRGB())
		DT.tooltip:AddDoubleLine(L["Raid:"], playerDifficultyInfos.raid.color:WrapTextInColorCode(playerDifficultyInfos.raid.name), mMT:GetRGB())
		if E.Retail then DT.tooltip:AddDoubleLine(L["Legacy Raid:"], playerDifficultyInfos.legacy.color:WrapTextInColorCode(playerDifficultyInfos.legacy.name), mMT:GetRGB()) end
		DT.tooltip:AddLine(" ")
	end

	if E.Retail and E:XPIsLevelMax() then
		local myScore = mMT:GetMyMythicPlusScore()
		local myKeystone = mMT:GetMyKeystone()

		if myKeystone and myScore then
			DT.tooltip:AddLine(L["My Info"], mMT:GetRGB("title"))
			DT.tooltip:AddDoubleLine(DUNGEON_SCORE, myScore, mMT:GetRGB())
			DT.tooltip:AddDoubleLine(L["Keystone"], myKeystone, mMT:GetRGB())
			DT.tooltip:AddLine(" ")
		end

		if DB.keystones and next(DB.keystones) then
			DT.tooltip:AddLine(L["Keystones on your Account"], mMT:GetRGB("title"))
			for _, characters in pairs(DB.keystones) do
				DT.tooltip:AddDoubleLine(characters.name, characters.key)
			end
			DT.tooltip:AddLine(" ")
		end

		local weeklyAffixes = mMT:GetWeeklyAffixes()
		if weeklyAffixes then
			DT.tooltip:AddLine(L["This week's Affix"], mMT:GetRGB("title"))
			DT.tooltip:AddLine(weeklyAffixes, mMT:GetRGB())
			DT.tooltip:AddLine(" ")
		end

		local vaultInfoRaid, vaultInfoDungeons, vaultInfoWorld = mMT:GetVaultInfo()
		if vaultInfoRaid and vaultInfoDungeons and vaultInfoWorld then
			DT.tooltip:AddLine(GREAT_VAULT_REWARDS, mMT:GetRGB("title"))
			DT.tooltip:AddDoubleLine(RAID, vaultInfoRaid, mMT:GetRGB("text", "text"))
			DT.tooltip:AddDoubleLine(DUNGEONS, vaultInfoDungeons, mMT:GetRGB("text", "text"))
			DT.tooltip:AddDoubleLine(WORLD, vaultInfoWorld, mMT:GetRGB("text", "text"))
			DT.tooltip:AddLine(" ")
		end
	end

	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. L["left click to open LFD Frame"], mMT:GetRGB("tip"))
	DT.tooltip:AddLine(MEDIA.rightClick .. " " .. L["right click to open Great Vault"], mMT:GetRGB("tip"))
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

local events = { "CHALLENGE_MODE_START", "UPDATE_INSTANCE_INFO", "SCENARIO_UPDATE", "PLAYER_DIFFICULTY_CHANGED" }

DT:RegisterDatatext("mMT - Dungeon", mMT.Name, events, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Dungeon"], nil, ValueColorUpdate)
