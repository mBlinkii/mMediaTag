local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local pcall = pcall
local UnitIsUnit = UnitIsUnit

local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local HIGHLIGHT_MODULES = {
	{ moduleName = "NP-TargetHighlight", configName = "target", updateMethod = "UpdateTarget" },
	{ moduleName = "NP-FocusHighlight", configName = "focus", updateMethod = "UpdateFocus" },
	{ moduleName = "NP-QuestHighlight", configName = "quest", updateMethod = "UpdateQuest" },
}

mMT.NameplateUtils = mMT.NameplateUtils or {}
local Utils = mMT.NameplateUtils

function Utils:Initialize()
	if self.initialized then return end

	local border = E.db and E.db.general and E.db.general.bordercolor
	if border then
		self.defaultBorderColor = {
			r = border.r,
			g = border.g,
			b = border.b,
			a = border.a,
		}
	end

	self.defaultHealthTexture = LSM:Fetch("statusbar", NP.db.statusbar)

	self.initialized = true
end

function Utils:GetHealthBar(nameplate)
	return nameplate and nameplate.Health
end

function Utils:GetPlateByUnit(unit)
	if not unit then return nil end

	local success, plate = pcall(GetNamePlateForUnit, unit)
	if not success or not plate then return nil end

	local nameplate = plate.unitFrame
	if not nameplate or not nameplate.UpdateAllElements or nameplate.widgetsOnly then return nil end

	return nameplate
end

function Utils:GetDefaultHealthTexture()
	return self.defaultHealthTexture
end

function Utils:IsModuleActive(nameplate, moduleName, unitToken, requireColor, blockedBy)
	if blockedBy and self:IsModuleActive(nameplate, blockedBy.moduleName, blockedBy.unitToken, blockedBy.requireColor) then
		return false
	end

	local module = M[moduleName]
	local config = module and module[moduleName == "NP-TargetHighlight" and "target" or moduleName == "NP-FocusHighlight" and "focus" or "quest"]
	return config and config.enable and (not requireColor or config.changeColor) and nameplate and nameplate.unit and UnitIsUnit(nameplate.unit, unitToken)
end

function Utils:RefreshPlate(nameplate)
	if not (nameplate and nameplate.unit) then return end

	for _, moduleInfo in ipairs(HIGHLIGHT_MODULES) do
		local module = M[moduleInfo.moduleName]
		local config = module and module[moduleInfo.configName]
		if config and config.enable then
			module[moduleInfo.updateMethod](module, nameplate)
		end
	end
end

function Utils:GetColorOverrideConfig(module, nameplate, blockedBy)
	local cfg = module
	if not cfg then return nil end
	if not blockedBy or not self:IsModuleActive(nameplate, blockedBy.moduleName, blockedBy.unitToken, false, blockedBy.blockedBy) then
		return cfg
	end
	if not cfg.changeColor or self:IsModuleActive(nameplate, blockedBy.moduleName, blockedBy.unitToken, true, blockedBy.blockedBy) then
		return nil
	end

	local effective = cfg.colorOnlyConfig or {}
	cfg.colorOnlyConfig = effective
	effective.enable = true
	effective.changeColor = true
	effective.changeBorder = false
	effective.changeTexture = false
	effective.texture = nil
	effective.color = cfg.color
	effective.borderColor = cfg.borderColor
	effective.ignoreThreat = cfg.ignoreThreat
	return effective
end

function Utils:IsGoodThreat(nameplate)
	local threatStatus = nameplate and nameplate.threatStatus
	if not threatStatus then return true end

	local threatIndicator = nameplate and nameplate.ThreatIndicator
	if not threatIndicator then return true end

	local _, goodColor = NP:GetThreatSituationColor(threatIndicator, threatStatus)
	return goodColor
end

function Utils:ShouldApplyCustomColor(nameplate, cfg)
	if not (cfg and cfg.changeColor) then return false end
	if cfg.ignoreThreat then return true end
	return self:IsGoodThreat(nameplate)
end

function Utils:HasActiveHighlight(healthBar)
	return healthBar and (healthBar.mMT_IsTargetHighlighted or healthBar.mMT_IsFocusHighlighted or healthBar.mMT_IsQuestHighlighted)
end

function Utils:GetOwnerNameplate(healthBar)
	return healthBar and (healthBar.mMT_TargetOwner or healthBar.mMT_FocusOwner or healthBar.mMT_QuestOwner or healthBar.__owner)
end

function Utils:GetModuleConfig(healthBar, activeKey, configKey, moduleName, configName)
	if not (healthBar and healthBar[activeKey]) then return nil end

	local module = M[moduleName]
	return (configKey and healthBar[configKey]) or (module and module[configName]) or nil
end

function Utils:ApplyCompositeStyle(nameplate, healthBar)
	local targetCfg = self:GetModuleConfig(healthBar, "mMT_IsTargetHighlighted", nil, "NP-TargetHighlight", "target")
	local focusCfg = self:GetModuleConfig(healthBar, "mMT_IsFocusHighlighted", "mMT_FocusConfig", "NP-FocusHighlight", "focus")
	local questCfg = self:GetModuleConfig(healthBar, "mMT_IsQuestHighlighted", "mMT_QuestConfig", "NP-QuestHighlight", "quest")

	local colorCfg = (targetCfg and targetCfg.changeColor and targetCfg) or (focusCfg and focusCfg.changeColor and focusCfg) or (questCfg and questCfg.changeColor and questCfg)
	local textureCfg = (targetCfg and targetCfg.changeTexture and targetCfg) or (focusCfg and focusCfg.changeTexture and focusCfg) or (questCfg and questCfg.changeTexture and questCfg)
	local borderCfg = (targetCfg and targetCfg.changeBorder and targetCfg) or (focusCfg and focusCfg.changeBorder and focusCfg) or (questCfg and questCfg.changeBorder and questCfg)

	if colorCfg and self:ShouldApplyCustomColor(nameplate, colorCfg) then
		local color = colorCfg.color
		NP:SetStatusBarColor(healthBar, color.r, color.g, color.b)
	end

	if textureCfg and textureCfg.texture and textureCfg.texture ~= "" then
		healthBar:SetStatusBarTexture(textureCfg.texture)
	end

	if borderCfg and healthBar.backdrop then
		local borderColor = borderCfg.borderColor or borderCfg.color
		healthBar.backdrop:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, 1)
	end
end

function Utils:HighlightPostUpdateColor(healthBar, unit, color)
	local original = healthBar and healthBar.mMT_HighlightOriginalPostUpdate
	if original and original ~= self.HighlightPostUpdateColor then
		original(healthBar, unit, color)
	end

	local nameplate = self:GetOwnerNameplate(healthBar)
	if not (nameplate and self:HasActiveHighlight(healthBar)) then return end

	self:ApplyCompositeStyle(nameplate, healthBar)
end

function Utils:ApplyHighlightStyle(nameplate, cfg, state)
	local healthBar = self:GetHealthBar(nameplate)
	if not (healthBar and cfg and cfg.enable) then return end

	healthBar.mMT_HighlightOriginalPostUpdate = healthBar.mMT_HighlightOriginalPostUpdate or healthBar.PostUpdateColor
	healthBar[state.ownerKey] = nameplate
	if state.configKey then
		healthBar[state.configKey] = cfg
	end
	healthBar.PostUpdateColor = self.HighlightPostUpdateColor

	if cfg.changeColor then
		local color = cfg.color
		NP:SetStatusBarColor(healthBar, color.r, color.g, color.b)
	end

	if cfg.changeBorder and healthBar.backdrop then
		local borderColor = cfg.borderColor or cfg.color
		healthBar.backdrop:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, 1)
		healthBar.backdrop[state.borderKey] = true
	elseif healthBar.backdrop and healthBar.backdrop[state.borderKey] then
		local border = self.defaultBorderColor
		if border then
			healthBar.backdrop:SetBackdropBorderColor(border.r, border.g, border.b, border.a)
		end
		healthBar.backdrop[state.borderKey] = nil
	end

	if cfg.changeTexture and cfg.texture and cfg.texture ~= "" then
		healthBar:SetStatusBarTexture(cfg.texture)
	else
		healthBar:SetStatusBarTexture(self:GetDefaultHealthTexture())
	end

	healthBar[state.activeKey] = true
	self:ApplyCompositeStyle(nameplate, healthBar)
end

function Utils:UpdateTargetIndicator(nameplate)
	if not (nameplate and nameplate.TargetIndicator) then return end

	NP:Update_TargetIndicator(nameplate)
	if nameplate.TargetIndicator.ForceUpdate then nameplate.TargetIndicator:ForceUpdate() end
end

function Utils:ResetHighlightStyle(nameplate, state)
	local healthBar = self:GetHealthBar(nameplate)
	if not (healthBar and healthBar[state.activeKey]) then return end

	healthBar[state.ownerKey] = nil
	healthBar[state.activeKey] = nil
	if state.configKey then
		healthBar[state.configKey] = nil
	end

	local hasActiveHighlight = self:HasActiveHighlight(healthBar)
	if hasActiveHighlight then
		healthBar.PostUpdateColor = self.HighlightPostUpdateColor
	else
		healthBar.PostUpdateColor = healthBar.mMT_HighlightOriginalPostUpdate
	end

	NP:Update_Health(nameplate)
	healthBar:SetStatusBarTexture(self:GetDefaultHealthTexture())

	local border = self.defaultBorderColor
	if healthBar.backdrop then
		if border then
			healthBar.backdrop:SetBackdropBorderColor(border.r, border.g, border.b, border.a)
		else
			healthBar.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		end
		healthBar.mMT_TargetBorder = nil
		healthBar.mMT_FocusBorder = nil
		healthBar.mMT_QuestBorder = nil
	end

	if nameplate.UpdateElement then
		nameplate:UpdateElement("Health")
	elseif healthBar.ForceUpdate then
		healthBar:ForceUpdate()
	end

	if hasActiveHighlight then
		self:ApplyCompositeStyle(nameplate, healthBar)
	end
end
