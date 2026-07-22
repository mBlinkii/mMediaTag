local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM
local module = mMT:AddModule("DifficultyInfo", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local CreateFrame = CreateFrame
local Minimap = _G.Minimap
local MinimapCluster = _G.MinimapCluster
local strupper = strupper
local random = random


local function UpdateInfos()
	local mapDifficulty = MinimapCluster.InstanceDifficulty or _G.MiniMapInstanceDifficulty
	local mapDifficultyGuild = _G.GuildInstanceDifficulty
	local mapBattlefieldFrame = _G.MiniMapBattlefieldFrame

	if mapDifficulty then mapDifficulty:Hide() end
	if mapDifficultyGuild then mapDifficultyGuild:Hide() end
	if mapBattlefieldFrame then mapBattlefieldFrame:Hide() end

	local instanceInfos = mMT:GetDungeonInfo()
	if instanceInfos and (instanceInfos.difficultyShort or instanceInfos.difficultyName) then
		local challengeModeInfo = instanceInfos.isChallengeMode and instanceInfos.level
		local delveInfo = instanceInfos.isDelve and " " .. instanceInfos.level
		local difficulty = (instanceInfos.difficultyShort or instanceInfos.difficultyName) .. ((challengeModeInfo or delveInfo) or "")
		local guild = instanceInfos.isGuildParty and MEDIA.color.GUILD
		local text = strupper(instanceInfos.shortName or instanceInfos.name)
		text = guild and guild:WrapTextInColorCode(text) or text
		module.difficulty.lable:SetText(instanceInfos.difficultyColor:WrapTextInColorCode(difficulty) .. "\n" .. text)
		module.difficulty:Show()
	else
		module.difficulty:Hide()
	end
end

function module:Demo(show)
	local demoTexts = {
		"|CFF1EFF00N|r\nROOK",
		"|CFF0070DDH|r\nDOT|r",
		"|CFFA335EEM|r\n|CFF91D900TOP|r",
		"|CFFFF8000M+10|r\nHOI",
		"|CFFE6CC80PVP|r\nDORNOG",
	}
	if not module.difficulty.demo then
		module.difficulty.demo = true
		module.difficulty.lable:SetText(demoTexts[random(1, #demoTexts)])
		module.difficulty:Show()
	else
		module.difficulty.demo = false
		UpdateInfos()
	end
end

function module:Initialize(demo)
	if not E.db.mMediaTag.difficulty_info.enable then
		if module.difficulty then
			module.difficulty:Hide()
			if module.isEnabled then
				module:UnregisterAllEvents()
				module.isEnabled = false
			end
		end
		return
	end

	module.db = E.db.mMediaTag.difficulty_info

	if not module.difficulty then
		module.difficulty = CreateFrame("Button", "mMediaTag_Difficulty_Info", E.UIParent, "BackdropTemplate")
		module.difficulty:SetFrameStrata("HIGH")
		module.difficulty:SetPoint("CENTER", Minimap, "TOPLEFT", 16, -16)
		module.difficulty:SetSize(32, 32)

		if module.db.background then module.difficulty:SetTemplate("Transparent", true) end

		module.difficulty.lable = module.difficulty:CreateFontString(nil, "OVERLAY")
		module.difficulty.lable:SetPoint("CENTER", module.difficulty, "CENTER", 0, 0)
		module.difficulty.lable:SetTextColor(1, 1, 1, 1)

		E:CreateMover(module.difficulty, "mMediaTag_Difficulty_Info_Mover", "mMT " .. L["Difficulty Info"], nil, nil, nil, "ALL,MMEDIATAG", function() return E.db.mMediaTag.difficulty_info.enable end, "mMT,misc,difficulty_info")
		module.difficulty:Hide()
	end

	E:SetFont(module.difficulty.lable, LSM:Fetch("font", module.db.font.font), module.db.font.size, module.db.font.fontFlag)
	module.difficulty.lable:SetJustifyH(module.db.font.justify)

	module.difficulty.lable:ClearAllPoints()
	if module.db.font.justify == "LEFT" then
		module.difficulty.lable:SetPoint("LEFT", module.difficulty, "LEFT", 4, 0)
	elseif module.db.font.justify == "RIGHT" then
		module.difficulty.lable:SetPoint("RIGHT", module.difficulty, "RIGHT", -4, 0)
	else
		module.difficulty.lable:SetPoint("CENTER", module.difficulty, "CENTER", 0, 0)
	end

	if not module.isEnabled then
		module:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
		module:RegisterEvent("UPDATE_INSTANCE_INFO", "OnEvent")
		module:RegisterEvent("CHALLENGE_MODE_START", "OnEvent")
		module:RegisterEvent("SCENARIO_UPDATE", "OnEvent")
		module:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "OnEvent")
		module.isEnabled = true
	end

	UpdateInfos()

	if demo then module:Demo() end
end

function module:OnEvent()
	if not module.difficulty or module.difficulty.demo then return end
	UpdateInfos()
end
