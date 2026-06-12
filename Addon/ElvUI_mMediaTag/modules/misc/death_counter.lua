local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM
local module = mMT:AddModule("DeathCounter", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local CreateFrame = CreateFrame
local format = format
local floor = math.floor
local Minimap = _G.Minimap
local GetDeathCount = C_ChallengeMode.GetDeathCount
local IsChallengeModeActive = C_ChallengeMode.IsChallengeModeActive

local SKULL = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:%d:%d|t"

local function FormatTimeLost(seconds)
	seconds = seconds or 0
	return format("-%d:%02d", floor(seconds / 60), seconds % 60)
end

local function SetCounterText(deaths, timeLost)
	local size = module.db.font.size
	module.death_counter.label:SetText(format("%s %d %s", format(SKULL, size, size), deaths or 0, mMT:TC(FormatTimeLost(timeLost), "red")))
end

local function UpdateCounter()
	local frame = module.death_counter
	if not frame or frame.demo then return end

	if not IsChallengeModeActive() then
		frame:Hide()
		return
	end

	local deaths, timeLost = GetDeathCount()
	SetCounterText(deaths, timeLost)
	frame:Show()
end

function module:Demo()
	if not module.death_counter then return end

	if module.death_counter.demo then
		module.death_counter.demo = false
		UpdateCounter()
	else
		module.death_counter.demo = true
		SetCounterText(3, 15)
		module.death_counter:Show()
	end
end

function module:OnEvent()
	UpdateCounter()
end

function module:Initialize(demo)
	if not E.db.mMediaTag.death_counter.enable then
		if module.death_counter then
			module.death_counter.demo = false
			module.death_counter:Hide()
			if module.isEnabled then
				module:UnregisterAllEvents()
				module.isEnabled = false
			end
		end
		return
	end

	module.db = E.db.mMediaTag.death_counter

	if not module.death_counter then
		module.death_counter = CreateFrame("Button", "mMediaTag_Death_Counter", E.UIParent, "BackdropTemplate")
		module.death_counter:SetFrameStrata("HIGH")
		module.death_counter:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
		module.death_counter:SetSize(64, 22)

		if module.db.background then module.death_counter:SetTemplate("Transparent", true) end

		module.death_counter.label = module.death_counter:CreateFontString(nil, "OVERLAY")
		module.death_counter.label:SetPoint("CENTER", module.death_counter, "CENTER", 0, 0)
		module.death_counter.label:SetTextColor(1, 1, 1, 1)

		module.death_counter:SetScript("OnShow", function(self)
			local width = module.death_counter.label:GetStringWidth() + 16
			local height = module.death_counter.label:GetStringHeight() + 12
			self:SetSize(width, height)
		end)

		E:CreateMover(module.death_counter, "mMediaTag_Death_Counter_Mover", "mMT " .. L["Death Counter"], nil, nil, nil, "ALL,MMEDIATAG", function() return E.db.mMediaTag.death_counter.enable end, "mMT,misc,death_counter")
		module.death_counter:Hide()
	end

	E:SetFont(module.death_counter.label, LSM:Fetch("font", module.db.font.font), module.db.font.size, module.db.font.fontFlag)

	if not module.isEnabled then
		module:RegisterEvent("CHALLENGE_MODE_START", "OnEvent")
		module:RegisterEvent("CHALLENGE_MODE_COMPLETED", "OnEvent")
		module:RegisterEvent("CHALLENGE_MODE_RESET", "OnEvent")
		module:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED", "OnEvent")
		module:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
		module.isEnabled = true
	end

	UpdateCounter()

	if demo then module:Demo() end
end
