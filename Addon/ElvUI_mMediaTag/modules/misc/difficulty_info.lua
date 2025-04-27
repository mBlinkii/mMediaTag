local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM
local module = mMT:AddModule("DifficultyInfo", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local CreateFrame = CreateFrame
local Minimap = _G.Minimap
local MinimapCluster = _G.MinimapCluster
local strupper = strupper

function module:Demo(show)
	if show then
		module.difficulty.lable:SetText("H\nDOT")
		module.difficulty:Show()
	else
		module.difficulty.lable:SetText("")
		module.difficulty:Hide()
	end
end

function module:Initialize(demo)
	if not E.db.mMT.difficulty_info.enable then
		if module.difficulty then
			module.difficulty:Hide()
			if module.isEnabled then
				module.info_screen:UnregisterAllEvents()
				module.isEnabled = false
			end
		end
		return
	end

	module.db = E.db.mMT.difficulty_info

	if not module.difficulty then
		module.difficulty = CreateFrame("Button", "mMediaTag_Difficulty_Info", E.UIParent, "BackdropTemplate")
		module.difficulty:SetFrameStrata("HIGH")
		module.difficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
		module.difficulty:SetSize(32, 32)

		if module.db.background then module.difficulty:SetTemplate("Transparent", true) end

		module.difficulty.lable = module.difficulty:CreateFontString(nil, "OVERLAY")
		module.difficulty.lable:SetPoint("CENTER", module.difficulty, "CENTER", 0, 0)
		module.difficulty.lable:SetTextColor(1, 1, 1, 1)
		module.difficulty.lable:SetJustifyH("CENTER")

		module.difficulty:SetScript("OnShow", function(self)
			local width = module.difficulty.lable:GetStringWidth() + 20
			local height = module.difficulty.lable:GetStringHeight() + 20
			self:SetSize(width, height)
		end)

		E:CreateMover(module.difficulty, "mMediaTag_Difficulty_Info_Mover", "mMT Dungeon Info", nil, nil, nil, "ALL,MMEDIATAG", function() return E.db.mMT.difficulty_info.enable end, "mMT,misc,difficulty_info")
		module.difficulty:Hide()
	end

	E:SetFont(module.difficulty.lable, LSM:Fetch("font", module.db.font.font), module.db.font.size, module.db.font.fontflag)


	if not module.isEnabled then
		module:RegisterEvent("UPDATE_INSTANCE_INFO", module.OnEvent)
		module:RegisterEvent("CHALLENGE_MODE_START", module.OnEvent)
		module:RegisterEvent("SCENARIO_UPDATE",module.OnEvent)
		module:RegisterEvent("PLAYER_DIFFICULTY_CHANGED",module.OnEvent)
		module.isEnabled = true
	end

	module:OnEvent(module.difficulty, "force update")

	if demo then module:Demo(not module.difficulty:IsShown()) end
end

function module:OnEvent(_, event )
	local mapDifficulty = MinimapCluster.InstanceDifficulty or _G.MiniMapInstanceDifficulty
	local mapDifficultyGuild = _G.GuildInstanceDifficulty
	local mapBattlefieldFrame = _G.MiniMapBattlefieldFrame

	if mapDifficulty then mapDifficulty:Hide() end
	if mapDifficultyGuild then mapDifficultyGuild:Hide() end
	if mapBattlefieldFrame then mapBattlefieldFrame:Hide() end

	if event == "UPDATE_INSTANCE_INFO" or event == "CHALLENGE_MODE_START" or event == "SCENARIO_UPDATE" or event == "PLAYER_DIFFICULTY_CHANGED" or event == "force update" then
		local instanceInfos = mMT:GetDungeonInfo()
		if instanceInfos and (instanceInfos.difficultyShort or instanceInfos.difficultyName) then
			local challengeModeInfo = instanceInfos.isChallengeMode and instanceInfos.level
			local delveInfo = instanceInfos.isDelve and " " .. instanceInfos.level
			local difficulty = (instanceInfos.difficultyShort or instanceInfos.difficultyName) .. ((challengeModeInfo or delveInfo) or "")
			local guild = instanceInfos.isGuild and MEDIA.color.GUILD
			local text = strupper(instanceInfos.shortName or instanceInfos.name)
			text = guild and guild:WrapTextInColorCode(text) or text
			module.difficulty.lable:SetText(instanceInfos.difficultyColor:WrapTextInColorCode(difficulty) .. "\n" .. text)
			module.difficulty:Show()
		else
			module.difficulty.lable:SetText("")
			module.difficulty:Hide()
		end
	end
end
