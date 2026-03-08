local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("NameplateTools", { "AceHook-3.0", "AceEvent-3.0" })

local _G  = _G
local NP  = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

-- Lua globals
local pairs   = pairs
local strfind = string.find

-- WoW API
local UnitExists          = UnitExists
local UnitGUID            = UnitGUID
local UnitIsUnit          = UnitIsUnit
local C_Timer_After       = C_Timer.After
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

local function GetHealthBar(unitToken)
	-- block this GUIDs
	if not unitToken
		or strfind(unitToken, "Creature", 1, true)
		or strfind(unitToken, "Player-", 1, true)
		or strfind(unitToken, "Vehicle", 1, true)
	then
		return nil
	end

	-- forbidden checks
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
	if not questIcons then return false end

	return questIcons:IsShown()
end

local function GetUnitState(unitToken)
	if UnitIsUnit(unitToken, "target") then return "target" end
	if UnitIsUnit(unitToken, "focus") then return "focus" end
	if IsQuestMob(unitToken) then return "quest" end
	return nil
end

local function ApplyState(unitToken, state)
	local healthBar = GetHealthBar(unitToken)
	if not healthBar then return end

	local cfg = module[state]
	if not cfg then return end

	-- backup elvui flags
	if not healthBar.mMT_OrigFlags then
		healthBar.mMT_OrigFlags = {
			colorClass          = healthBar.colorClass,
			colorClassNPC       = healthBar.colorClassNPC,
			colorReaction       = healthBar.colorReaction,
			colorTapping        = healthBar.colorTapping,
			colorDisconnect     = healthBar.colorDisconnect,
			colorHealth         = healthBar.colorHealth,
			colorThreat         = healthBar.colorThreat,
			colorClassification = healthBar.colorClassification,
			texture             = healthBar:GetStatusBarTexture() and healthBar:GetStatusBarTexture():GetTexture(),
		}
	end

	healthBar:SetColorTapping(false)
	healthBar:SetColorSelection(false)
	healthBar.colorClassification = false
	healthBar.colorReaction       = false
	healthBar.colorClass          = false
	healthBar.colorClassNPC       = false
	healthBar.colorDisconnect     = false
	healthBar.colorHealth         = false
	if cfg.ignoreThreat then
		healthBar.colorThreat = false
	end

	if cfg.changeColor then
		local c = cfg.color
		NP:SetStatusBarColor(healthBar, c.r, c.g, c.b)
		healthBar.mMT_CustomColor = { c.r, c.g, c.b }
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

	local orig = healthBar.mMT_OrigFlags

	-- restore elvui flags
	healthBar:SetColorTapping(orig.colorTapping)
	healthBar:SetColorSelection(orig.colorTapping)
	healthBar.colorClassification = orig.colorClassification
	healthBar.colorReaction       = orig.colorReaction
	healthBar.colorClass          = orig.colorClass
	healthBar.colorClassNPC       = orig.colorClassNPC
	healthBar.colorDisconnect     = orig.colorDisconnect
	healthBar.colorHealth         = orig.colorHealth
	healthBar.colorThreat         = orig.colorThreat

	if orig.texture then healthBar:SetStatusBarTexture(orig.texture) end

	healthBar.mMT_OrigFlags     = nil
	healthBar.mMT_CustomColor   = nil
	healthBar.mMT_CustomTexture = nil
	healthBar.mMT_State         = nil

	if healthBar.ForceUpdate then healthBar:ForceUpdate() end
end

function module:UpdateUnitColor(unitToken)
	if not unitToken or not UnitExists(unitToken) then return end

	local newState = GetUnitState(unitToken)
	local bar = GetHealthBar(unitToken)
	if not bar then return end

	local oldState = bar.mMT_State

	if newState ~= oldState then
		if newState then
			ApplyState(unitToken, newState)
		else
			ResetState(unitToken)
		end
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
		local nameplateFrame = GetNamePlateForUnit(unitToken, false)
		if nameplateFrame and nameplateFrame.unitFrame then
			HookQuestIconsPostUpdate(nameplateFrame.unitFrame)
		end
		module:UpdateUnitColor(unitToken)
	end)
end

local function OnUnitDied(_, unitToken)
	if not unitToken or E:IsSecretValue(unitToken) then return end

	if  strfind(unitToken, "Creature", 1, true) or strfind(unitToken, "Player-", 1, true) or strfind(unitToken, "Vehicle", 1, true) then
		local guid = unitToken
		for nameplateFrame in pairs(NP.Plates) do
			if nameplateFrame.unit and UnitGUID(nameplateFrame.unit) == guid then
				ResetState(nameplateFrame.unit)
			end
		end
	else
		ResetState(unitToken)
	end
end

local function Update()
	module:RefreshAll()
end

local function OnHealthSetColors(_, nameplate)
	local healthBar = nameplate and nameplate.Health
	if not healthBar or not healthBar.mMT_State then return end

	local cfg = module[healthBar.mMT_State]
	if not cfg then return end

	healthBar:SetColorTapping(false)
	healthBar:SetColorSelection(false)
	healthBar.colorClassification = false
	healthBar.colorReaction       = false
	healthBar.colorClass          = false
	healthBar.colorClassNPC       = false
	healthBar.colorDisconnect     = false

	if cfg.ignoreThreat then
		healthBar.colorThreat = false
	end
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

	if cfg.changeTexture and healthBar.mMT_CustomTexture then
		healthBar:SetStatusBarTexture(healthBar.mMT_CustomTexture)
	end
end

local function OnThreatPostUpdate(threatIndicator, unit, status)
	local nameplate = threatIndicator and threatIndicator.__owner
	if not nameplate then return end
	local healthBar = nameplate.Health
	if not healthBar or not healthBar.mMT_State then return end
	if not status then return end

	local cfg = module[healthBar.mMT_State]
	if not cfg or not cfg.ignoreThreat then return end

	if cfg.changeColor and healthBar.mMT_CustomColor then
		local c = healthBar.mMT_CustomColor
		healthBar:SetStatusBarColor(c[1], c[2], c[3])
	end

	if cfg.changeTexture and healthBar.mMT_CustomTexture then
		healthBar:SetStatusBarTexture(healthBar.mMT_CustomTexture)
	end
end

function module:Initialize()
	module.db = E.db.mMediaTag.nameplates

	module.focus = {
		enable        = E.db.mMediaTag.nameplates.focus.changeColor or E.db.mMediaTag.nameplates.focus.changeTexture,
		changeColor   = E.db.mMediaTag.nameplates.focus.changeColor,
		changeTexture = E.db.mMediaTag.nameplates.focus.changeTexture,
		texture       = LSM:Fetch("statusbar", E.db.mMediaTag.nameplates.focus.texture),
		color         = MEDIA.color.nameplates.focus_color,
		ignoreThreat  = E.db.mMediaTag.nameplates.focus.ignoreThreat,
	}

	module.target = {
		enable        = E.db.mMediaTag.nameplates.target.changeColor or E.db.mMediaTag.nameplates.target.changeTexture,
		changeColor   = E.db.mMediaTag.nameplates.target.changeColor,
		changeTexture = E.db.mMediaTag.nameplates.target.changeTexture,
		texture       = LSM:Fetch("statusbar", E.db.mMediaTag.nameplates.target.texture),
		color         = MEDIA.color.nameplates.target_color,
		ignoreThreat  = E.db.mMediaTag.nameplates.target.ignoreThreat,
	}

	module.quest = {
		enable        = E.db.mMediaTag.nameplates.quest.changeColor or E.db.mMediaTag.nameplates.quest.changeTexture,
		changeColor   = E.db.mMediaTag.nameplates.quest.changeColor,
		changeTexture = E.db.mMediaTag.nameplates.quest.changeTexture,
		texture       = LSM:Fetch("statusbar", E.db.mMediaTag.nameplates.quest.texture),
		color         = MEDIA.color.nameplates.quest_color,
		ignoreThreat  = E.db.mMediaTag.nameplates.quest.ignoreThreat,
	}

	if module.db.target_glow_color and E.db["nameplates"]["colors"]["glowColor"] then
		E.db["nameplates"]["colors"]["glowColor"]["r"] = MEDIA.myclass.r
		E.db["nameplates"]["colors"]["glowColor"]["g"] = MEDIA.myclass.g
		E.db["nameplates"]["colors"]["glowColor"]["b"] = MEDIA.myclass.b
	end

	if not module.hooked then
		module:SecureHook(NP, "Health_SetColors",           OnHealthSetColors)
		module:SecureHook(NP, "Health_UpdateColor",         OnHealthColorUpdate)
		module:SecureHook(NP, "ThreatIndicator_PostUpdate", OnThreatPostUpdate)
		module.hooked = true
	end

	if module.quest.enable then
		for nameplateFrame in pairs(NP.Plates) do
			if nameplateFrame.unitFrame then
				HookQuestIconsPostUpdate(nameplateFrame.unitFrame)
			end
		end
	end

	if module.focus.enable  then module:RegisterEvent("PLAYER_FOCUS_CHANGED",  Update) end
	if module.target.enable then module:RegisterEvent("PLAYER_TARGET_CHANGED", Update) end

	if module.focus.enable or module.target.enable or module.quest.enable then
		module:RegisterEvent("NAME_PLATE_UNIT_ADDED", OnPlateAdded)
		module:RegisterEvent("UNIT_DIED", OnUnitDied)

		module:RefreshAll()
	end
end
