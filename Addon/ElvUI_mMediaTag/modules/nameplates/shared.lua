local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local pcall = pcall

local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

mMT.NameplateUtils = mMT.NameplateUtils or {}
local Utils = mMT.NameplateUtils

function Utils:Initialize()
	local border = E.db and E.db.general and E.db.general.bordercolor
	if border then
		self.defaultBorderColor = self.defaultBorderColor or {}
		self.defaultBorderColor.r = border.r
		self.defaultBorderColor.g = border.g
		self.defaultBorderColor.b = border.b
		self.defaultBorderColor.a = border.a
	end
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

function Utils:GetDefaultHealthTexture(defaultTexture)
	return defaultTexture or LSM:Fetch("statusbar", NP.db.statusbar) or E.media.normTex
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

function Utils:StoreOriginalState(healthBar, state)
	if healthBar[state.originalKey] then return end

	healthBar[state.originalKey] = {
		postUpdateColor = healthBar.PostUpdateColor,
	}
end

function Utils:ReapplyCustomStyle(nameplate, healthBar, cfg, state)
	if self:ShouldApplyCustomColor(nameplate, cfg) and healthBar[state.colorKey] then
		local color = healthBar[state.colorKey]
		NP:SetStatusBarColor(healthBar, color[1], color[2], color[3])
	end

	if cfg.changeTexture and healthBar[state.textureKey] then healthBar:SetStatusBarTexture(healthBar[state.textureKey]) end
end

function Utils:ApplyHighlightStyle(nameplate, cfg, state, postUpdateColor)
	local healthBar = self:GetHealthBar(nameplate)
	if not (healthBar and cfg and cfg.enable) then return end

	self:StoreOriginalState(healthBar, state)
	healthBar[state.ownerKey] = nameplate
	healthBar.PostUpdateColor = postUpdateColor

	if cfg.changeColor then
		local color = cfg.color
		NP:SetStatusBarColor(healthBar, color.r, color.g, color.b)
		healthBar[state.colorKey] = healthBar[state.colorKey] or {}
		healthBar[state.colorKey][1] = color.r
		healthBar[state.colorKey][2] = color.g
		healthBar[state.colorKey][3] = color.b
	end

	if cfg.changeBorder and healthBar.backdrop then
		local borderColor = cfg.borderColor or cfg.color
		healthBar.backdrop:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, 1)
		healthBar.backdrop[state.borderKey] = true
	end

	if cfg.changeTexture and cfg.texture and cfg.texture ~= "" then
		healthBar:SetStatusBarTexture(cfg.texture)
		healthBar[state.textureKey] = cfg.texture
	end

	healthBar[state.activeKey] = true
end

function Utils:UpdateTargetIndicator(nameplate)
	if not (nameplate and nameplate.TargetIndicator) then return end

	NP:Update_TargetIndicator(nameplate)
	if nameplate.TargetIndicator.ForceUpdate then nameplate.TargetIndicator:ForceUpdate() end
end

function Utils:ResetHighlightStyle(nameplate, state, defaultTexture, afterReset)
	local healthBar = self:GetHealthBar(nameplate)
	if not (healthBar and healthBar[state.activeKey]) then return end

	local original = healthBar[state.originalKey]
	if original then healthBar.PostUpdateColor = original.postUpdateColor end

	NP:Update_Health(nameplate)
	healthBar:SetStatusBarTexture(self:GetDefaultHealthTexture(defaultTexture))

	if healthBar.backdrop and healthBar.backdrop[state.borderKey] then
		local border = self.defaultBorderColor
		if border then
			healthBar.backdrop:SetBackdropBorderColor(border.r, border.g, border.b, border.a)
		else
			healthBar.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		end
		healthBar.backdrop[state.borderKey] = nil
	end

	healthBar[state.originalKey] = nil
	healthBar[state.colorKey] = nil
	healthBar[state.textureKey] = nil
	healthBar[state.ownerKey] = nil
	healthBar[state.activeKey] = nil

	if nameplate.UpdateElement then
		nameplate:UpdateElement("Health")
	elseif healthBar.ForceUpdate then
		healthBar:ForceUpdate()
	end

	if afterReset then afterReset(nameplate, healthBar) end
end
