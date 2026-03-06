local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("NameplateTools")

local _G = _G
local hooksecurefunc = _G.hooksecurefunc

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local function BackupColor(np)
	if not np.mMT_backupColor then np.mMT_backupColor = { np.Health:GetStatusBarColor() } end
end

local function RestoreColor(np)
	if np.mMT_backupColor then
		NP:SetStatusBarColor(np.Health, unpack(np.mMT_backupColor))
		np.mMT_backupColor = nil
	end
end

local function SetTexture(np, texture)
	np.Health:SetStatusBarTexture(LSM:Fetch("statusbar", texture))
end

local function RestoreTexture(np)
	SetTexture(np, NP.db.statusbar)
end

local function ApplyFocus(np)
	BackupColor(np)
	if module.db.focus.changeTexture then SetTexture(np, module.db.focus.texture) end
	NP:SetStatusBarColor(np.Health, module.focus_color.r, module.focus_color.g, module.focus_color.b)
end

local function ApplyTarget(np)
	BackupColor(np)
	if module.db.target.changeTexture then SetTexture(np, module.db.target.texture) end
	NP:SetStatusBarColor(np.Health, module.target_color.r, module.target_color.g, module.target_color.b)
end

local function CheckConditions(np, focusExists, targetExists)
	local unit = np.unit
	local isFocus = focusExists and UnitIsUnit(unit, "focus")
	local isTarget = targetExists and UnitIsUnit(unit, "target")

	-- Fokus hat immer Priorität über Target
	if E.db.mMediaTag.nameplates.focus.changeTexture or E.db.mMediaTag.nameplates.target.changeTexture then RestoreTexture(np) end

	if NP.mMT_focusTweaks and isFocus and not isTarget then
		ApplyFocus(np)
	elseif NP.mMT_targetTweaks and isTarget then
		ApplyTarget(np)
	else
		RestoreColor(np)
	end
end

local function UpdatePlates()
	local focusExists = UnitExists("focus")
	local targetExists = UnitExists("target")

	for np in pairs(NP.Plates) do
		CheckConditions(np, focusExists, targetExists)
	end
end

local function UpdateHealthBar(self, event, unit)
	if not unit or self.unit ~= unit then return end
	--local element = self.Health

	local focusExists = UnitExists("focus")
	local targetExists = UnitExists("target")

	-- self:HookScript("PLAYER_TARGET_CHANGED", TargetChanged)

	-- print("UpdateHealthBar", self, unit, self.unit)
	-- mMT:DebugPrint(NP, true, true)
	CheckConditions(self, focusExists, targetExists)
end

function module:Initialize()
	module.focusTweaks = E.db.mMediaTag.nameplates.focus.changeColor or E.db.mMediaTag.nameplates.focus.changeTexture
	module.targetTweaks = E.db.mMediaTag.nameplates.target.changeColor or E.db.mMediaTag.nameplates.target.changeTexture

	module.db = E.db.mMediaTag.nameplates

	if module.db.target_glow_color and E.db["nameplates"]["colors"]["glowColor"] then
		E.db["nameplates"]["colors"]["glowColor"]["r"] = MEDIA.myclass.r
		E.db["nameplates"]["colors"]["glowColor"]["g"] = MEDIA.myclass.g
		E.db["nameplates"]["colors"]["glowColor"]["b"] = MEDIA.myclass.b
	end

	if module.focusTweaks or module.targetTweaks then
		module.focus_color = MEDIA.color.nameplates.focus_color
		module.target_color = MEDIA.color.nameplates.target_color

		if not NP.mMT_Tweaks then
			hooksecurefunc(NP, "Health_UpdateColor", UpdateHealthBar)
			NP.mMT_Tweaks = true
		end
	end

	if module.focusTweaks and not NP.mMT_focusTweaks then
		NP:RegisterEvent("PLAYER_FOCUS_CHANGED", UpdatePlates)
		NP.mMT_focusTweaks = true
	elseif not module.focusTweaks and NP.mMT_focusTweaks then
		NP:UnregisterEvent("PLAYER_FOCUS_CHANGED", UpdatePlates)
		NP.mMT_focusTweaks = nil
	end

	if module.targetTweaks and not NP.mMT_targetTweaks then
		NP:RegisterEvent("PLAYER_TARGET_CHANGED", UpdatePlates)
		NP.mMT_targetTweaks = true
	elseif not module.targetTweaks and NP.mMT_targetTweaks then
		NP:UnregisterEvent("PLAYER_TARGET_CHANGED", UpdatePlates)
		NP.mMT_targetTweaks = nil
	end
end
