local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("NameplateTools", { "AceHook-3.0", "AceEvent-3.0" })

local _G = _G
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

-- Lua globals
local pairs = pairs
local strfind = string.find

-- WoW API
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsUnit = UnitIsUnit
local C_Timer_After = C_Timer.After
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

local refreshPending = false
local function ScheduleRefresh()
	if refreshPending then return end
	refreshPending = true
	C_Timer_After(0.1, function()
		refreshPending = false
		module:RefreshAll()
	end)
end

local function GetHealthBar(unitToken)
	if not unitToken or strfind(unitToken, "Creature", 1, true) or strfind(unitToken, "Player-", 1, true) or strfind(unitToken, "Vehicle", 1, true) then return nil end

	local nameplateFrame = GetNamePlateForUnit(unitToken, false)
	if not nameplateFrame then return nil end
	if nameplateFrame.isForbidden and nameplateFrame:IsForbidden() then return nil end

	local unitFrame = nameplateFrame.unitFrame
	if not unitFrame then return nil end

	return unitFrame.healthBar or unitFrame.Health
end

local function IsQuestMob(unitToken)
	if not UnitExists(unitToken) then return false end

	local nameplateFrame = GetNamePlateForUnit(unitToken, false)
	if not nameplateFrame then return false end
	if nameplateFrame.isForbidden and nameplateFrame:IsForbidden() then return false end

	local unitFrame = nameplateFrame.unitFrame
	if not unitFrame then return false end

	local questIcons = unitFrame.QuestIcons
	return questIcons and questIcons:IsShown() or false
end

local function GetUnitState(unitToken)
	if UnitIsUnit(unitToken, "target") then return "target" end
	if UnitIsUnit(unitToken, "focus") then return "focus" end
	if IsQuestMob(unitToken) then return "quest" end
	return nil
end

local function ApplyState(unitToken, state)
	local healthBar = GetHealthBar(unitToken)
	if not (healthBar and healthBar:IsShown()) then return end

	local cfg = module[state]
	if not cfg then return end

	-- Backup
	if not healthBar.mMT_OrigFlags then
		healthBar.mMT_OrigFlags = {
			colorClass = healthBar.colorClass,
			colorClassNPC = healthBar.colorClassNPC,
			colorReaction = healthBar.colorReaction,
			colorTapping = healthBar.colorTapping,
			colorDisconnect = healthBar.colorDisconnect,
			colorHealth = healthBar.colorHealth,
			colorThreat = healthBar.colorThreat,
			colorClassification = healthBar.colorClassification,
			texture = healthBar:GetStatusBarTexture() and healthBar:GetStatusBarTexture():GetTexture(),
		}
	end

	if healthBar.mMT_State == state then return end

	healthBar:SetColorTapping(false)
	healthBar:SetColorSelection(false)
	healthBar.colorClassification = false
	healthBar.colorReaction = false
	healthBar.colorClass = false
	healthBar.colorClassNPC = false
	healthBar.colorDisconnect = false
	healthBar.colorHealth = false
	if cfg.ignoreThreat then healthBar.colorThreat = false end

	if cfg.changeColor then
		local c = cfg.color
		NP:SetStatusBarColor(healthBar, c.r, c.g, c.b)
		healthBar.mMT_CustomColor = healthBar.mMT_CustomColor or {}
		healthBar.mMT_CustomColor[1] = c.r
		healthBar.mMT_CustomColor[2] = c.g
		healthBar.mMT_CustomColor[3] = c.b
	end

	if cfg.changeTexture and cfg.texture and cfg.texture ~= "" then
		healthBar:SetStatusBarTexture(cfg.texture)
		healthBar.mMT_CustomTexture = cfg.texture
	end

	healthBar.mMT_State = state
end

local function ResetState(unitToken)
	local healthBar = GetHealthBar(unitToken)
	if not healthBar or not healthBar.mMT_OrigFlags then return end

	if not healthBar.mMT_State then return end

	local orig = healthBar.mMT_OrigFlags
	healthBar:SetColorTapping(orig.colorTapping)
	healthBar:SetColorSelection(orig.colorTapping)
	healthBar.colorClassification = orig.colorClassification
	healthBar.colorReaction = orig.colorReaction
	healthBar.colorClass = orig.colorClass
	healthBar.colorClassNPC = orig.colorClassNPC
	healthBar.colorDisconnect = orig.colorDisconnect
	healthBar.colorHealth = orig.colorHealth
	healthBar.colorThreat = orig.colorThreat

	if orig.texture then healthBar:SetStatusBarTexture(orig.texture) end

	healthBar.mMT_OrigFlags = nil
	healthBar.mMT_CustomColor = nil
	healthBar.mMT_CustomTexture = nil
	healthBar.mMT_State = nil

	if healthBar.ForceUpdate then healthBar:ForceUpdate() end
end

function module:UpdateUnitColor(unitToken)
	if not unitToken or not UnitExists(unitToken) then return end

	local newState = GetUnitState(unitToken)
	local bar = GetHealthBar(unitToken)
	if not bar then return end

	local oldState = bar.mMT_State
	if newState == oldState then return end

	if newState then
		ApplyState(unitToken, newState)
	else
		ResetState(unitToken)
	end
end

function module:RefreshAll()
	for frame in pairs(NP.Plates) do
		if frame.unit then module:UpdateUnitColor(frame.unit) end
	end
end

local function HookQuestIconsPostUpdate(unitFrame)
	local questIcons = unitFrame and unitFrame.QuestIcons
	if not questIcons or questIcons.mMT_Hooked then return end

	local origPostUpdate = questIcons.PostUpdate
	questIcons.PostUpdate = function(self)
		if origPostUpdate then origPostUpdate(self) end
		local unit = self.__owner and self.__owner.unit
		if unit then module:UpdateUnitColor(unit) end
	end

	questIcons.mMT_Hooked = true
end

local function OnPlateAdded(_, unitToken)
	C_Timer_After(0.05, function()
		local np = GetNamePlateForUnit(unitToken, false)
		if np and np.unitFrame then HookQuestIconsPostUpdate(np.unitFrame) end
		module:UpdateUnitColor(unitToken)
	end)
end

-- local function OnUnitDied(_, unitToken)
-- 	if E:IsSecretValue(unitToken) or not unitToken then return end

-- 	if strfind(unitToken, "Creature", 1, true) or strfind(unitToken, "Player-", 1, true) or strfind(unitToken, "Vehicle", 1, true) then
-- 		local guid = unitToken
-- 		for nameplateFrame in pairs(NP.Plates) do
-- 			if nameplateFrame.unit and UnitGUID(nameplateFrame.unit) == guid then ResetState(nameplateFrame.unit) end
-- 		end
-- 	else
-- 		ResetState(unitToken)
-- 	end
-- end

local function OnTargetOrFocusChanged()
	ScheduleRefresh()
end

local function OnHealthSetColors(_, nameplate)
	local healthBar = nameplate and nameplate.Health
	if not healthBar or not healthBar.mMT_State then return end

	local cfg = module[healthBar.mMT_State]
	if not cfg then return end

	healthBar:SetColorTapping(false)
	healthBar:SetColorSelection(false)
	healthBar.colorClassification = false
	healthBar.colorReaction = false
	healthBar.colorClass = false
	healthBar.colorClassNPC = false
	healthBar.colorDisconnect = false
	if cfg.ignoreThreat then healthBar.colorThreat = false end
end

local function OnHealthColorUpdate(_, unitFrame)
	if not unitFrame or not unitFrame.unit then return end
	local healthBar = unitFrame.Health
	if not healthBar or not healthBar.mMT_State then return end

	local cfg = module[healthBar.mMT_State]
	if not cfg then return end

	if cfg.changeColor and healthBar.mMT_CustomColor then
		local c = healthBar.mMT_CustomColor
		NP:SetStatusBarColor(healthBar, c[1], c[2], c[3])
	end

	if cfg.changeTexture and healthBar.mMT_CustomTexture then healthBar:SetStatusBarTexture(healthBar.mMT_CustomTexture) end
end

local function OnThreatPostUpdate(threatIndicator, unit, status)
	if not status then return end

	local nameplate = threatIndicator and threatIndicator.__owner
	if not nameplate then return end

	local healthBar = nameplate.Health
	if not healthBar or not healthBar.mMT_State then return end

	local cfg = module[healthBar.mMT_State]
	if not cfg or not cfg.ignoreThreat then return end

	if cfg.changeColor and healthBar.mMT_CustomColor then
		local c = healthBar.mMT_CustomColor
		healthBar:SetStatusBarColor(c[1], c[2], c[3])
	end

	if cfg.changeTexture and healthBar.mMT_CustomTexture then healthBar:SetStatusBarTexture(healthBar.mMT_CustomTexture) end
end

function module:Initialize()
	if not E.private.nameplates.enable then return end
	module.db = E.db.mMediaTag.nameplates

	local db = E.db.mMediaTag.nameplates

	module.focus = {
		enable = db.focus.changeColor or db.focus.changeTexture,
		changeColor = db.focus.changeColor,
		changeTexture = db.focus.changeTexture,
		texture = LSM:Fetch("statusbar", db.focus.texture),
		color = MEDIA.color.nameplates.focus_color,
		ignoreThreat = db.focus.ignoreThreat,
	}

	module.target = {
		enable = db.target.changeColor or db.target.changeTexture,
		changeColor = db.target.changeColor,
		changeTexture = db.target.changeTexture,
		texture = LSM:Fetch("statusbar", db.target.texture),
		color = MEDIA.color.nameplates.target_color,
		ignoreThreat = db.target.ignoreThreat,
	}

	module.quest = {
		enable = db.quest.changeColor or db.quest.changeTexture,
		changeColor = db.quest.changeColor,
		changeTexture = db.quest.changeTexture,
		texture = LSM:Fetch("statusbar", db.quest.texture),
		color = MEDIA.color.nameplates.quest_color,
		ignoreThreat = db.quest.ignoreThreat,
	}

	if module.db.target_glow_color and E.db["nameplates"]["colors"]["glowColor"] then
		E.db["nameplates"]["colors"]["glowColor"]["r"] = MEDIA.myclass.r
		E.db["nameplates"]["colors"]["glowColor"]["g"] = MEDIA.myclass.g
		E.db["nameplates"]["colors"]["glowColor"]["b"] = MEDIA.myclass.b
	end

	if not module.hooked then
		module:SecureHook(NP, "Health_SetColors", OnHealthSetColors)
		module:SecureHook(NP, "Health_UpdateColor", OnHealthColorUpdate)
		module:SecureHook(NP, "ThreatIndicator_PostUpdate", OnThreatPostUpdate)
		module.hooked = true
	end

	if module.quest.enable then
		for nameplateFrame in pairs(NP.Plates) do
			if nameplateFrame.unitFrame then HookQuestIconsPostUpdate(nameplateFrame.unitFrame) end
		end
	end

	if module.focus.enable then module:RegisterEvent("PLAYER_FOCUS_CHANGED", OnTargetOrFocusChanged) end
	if module.target.enable then module:RegisterEvent("PLAYER_TARGET_CHANGED", OnTargetOrFocusChanged) end

	if module.focus.enable or module.target.enable or module.quest.enable then
		module:RegisterEvent("NAME_PLATE_UNIT_ADDED", OnPlateAdded)
		--module:RegisterEvent("UNIT_DIED", OnUnitDied)

		module:RefreshAll()
	end
end
