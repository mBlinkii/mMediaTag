local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("UnitframeTextures", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")
local LSM = E.Libs.LSM

-- Cache WoW Globals
local ipairs = ipairs
local pairs = pairs
local wipe = wipe

local config, appliedTexture, appliedBackground, appliedPower, dropped, barInfo, hooked = {}, {}, {}, {}, {}, {}, {}
local active = false

local function ElvUITexture(transparent)
	return transparent and E.media.blankTex or LSM:Fetch("statusbar", UF.db.statusbar)
end

-- resolved once per bar, the result only depends on frame layout and survives option changes
local function Resolve(object)
	local parent = object:GetParent()
	local frame = parent and (parent.unitframeType and parent or parent:GetParent())
	local unitType = frame and frame.unitframeType
	local info = false

	if unitType then
		local health, power, castbar = frame.Health, frame.Power, frame.Castbar
		if object == castbar then
			info = { key = "castbar" }
		elseif castbar and object == castbar.bg then
			info = { key = "castbar", bar = castbar }
		elseif object == health then
			info = { key = unitType }
		elseif object == power then
			info = { key = unitType, power = true }
		elseif health and object == health.bg then
			info = { key = unitType, bar = health }
		elseif power and object == power.bg then
			info = { key = unitType, bar = power, power = true }
		end
	end

	barInfo[object] = info
	return info
end

local function ApplyTexture(object)
	if not (active and object) then return end

	local info = barInfo[object]
	if info == nil then info = Resolve(object) end
	if not info then return end

	local settings = config[info.key]
	if not settings or (info.power and not settings.power) then return end

	local texture = info.bar and settings.background or settings.texture
	if not texture then return end

	if not info.bar then
		object:SetStatusBarTexture(texture)
		return
	end

	object:SetTexture(texture)

	-- ElvUI pins the backdrop to the fill texture, so the pattern squeezes as the bar drains, transparent bars need that anchor
	if not info.bar.isTransparent then
		object:ClearAllPoints()
		object:SetAllPoints()
	end
end

-- set directly, going through UF:SetTexture_HealComm would re-enter our own hook
local function PredictionTexture(key)
	local settings = config[key]
	if settings then return settings.texture end
	if dropped[key] then return ElvUITexture(UF.db.colors.transparentHealth) end
end

local function ApplyHealPrediction(prediction)
	if not prediction then return end

	local heal = PredictionTexture("healprediction")
	if heal then
		prediction.healingPlayer:SetStatusBarTexture(heal)
		prediction.healingOther:SetStatusBarTexture(heal)
	end

	local damageAbsorb = PredictionTexture("damageabsorb")
	if damageAbsorb then prediction.damageAbsorb:SetStatusBarTexture(damageAbsorb) end

	local healAbsorb = PredictionTexture("healabsorb")
	if healAbsorb then prediction.healAbsorb:SetStatusBarTexture(healAbsorb) end
end

local function ApplyPowerPrediction(prediction)
	if not prediction then return end

	local settings = config.powerprediction
	local texture = settings and settings.texture or (dropped.powerprediction and ElvUITexture(UF.db.colors.transparentPower))
	if not texture then return end

	if prediction.mainBar then prediction.mainBar:SetStatusBarTexture(texture) end
	if prediction.altBar then prediction.altBar:SetStatusBarTexture(texture) end
end

local function UpdateFrame(frame)
	local health, power, castbar = frame.Health, frame.Power, frame.Castbar

	if health then
		ApplyTexture(health)
		ApplyTexture(health.bg)
	end

	if power then
		ApplyTexture(power)
		ApplyTexture(power.bg)
	end

	if castbar then
		ApplyTexture(castbar)
		ApplyTexture(castbar.bg)
	end

	ApplyHealPrediction(frame.HealthPrediction)
	ApplyPowerPrediction(frame.PowerPrediction)
end

local handlers = {
	Update_StatusBar = function(_, statusBar)
		ApplyTexture(statusBar)
	end,
	-- the transparent path sets the bar itself directly and never reaches Update_StatusBar
	ToggleTransparentStatusBar = function(_, _, statusBar)
		ApplyTexture(statusBar)
	end,
	SetTexture_HealComm = function(_, prediction)
		ApplyHealPrediction(prediction)
	end,
	Configure_PowerPrediction = function(_, frame)
		ApplyPowerPrediction(frame and frame.PowerPrediction)
	end,
}

local function ToggleHook(method, needed)
	if needed and not hooked[method] then
		module:SecureHook(UF, method, handlers[method])
		hooked[method] = true
	elseif not needed and hooked[method] then
		module:Unhook(UF, method)
		hooked[method] = nil
	end
end

local predictionKeys = { healprediction = true, damageabsorb = true, healabsorb = true, powerprediction = true }
local healCommKeys = { "healprediction", "damageabsorb", "healabsorb" }

function module:Initialize()
	local db = E.db.mMediaTag.unitframe_textures
	local bars, repaint = false, false

	wipe(config)
	for key, settings in pairs(db) do
		if settings.enable then
			local background = settings.background_enable and LSM:Fetch("statusbar", settings.background) or nil
			config[key] = { texture = LSM:Fetch("statusbar", settings.texture), background = background, power = settings.power_enable }
		end
	end

	wipe(dropped)
	for key in pairs(appliedTexture) do
		local settings = config[key]
		if not (settings and settings.texture) then dropped[key] = true end
	end

	for key in pairs(appliedBackground) do
		local settings = config[key]
		if not (settings and settings.background) then dropped[key] = true end
	end

	for key in pairs(appliedPower) do
		local settings = config[key]
		if not (settings and settings.power) then dropped[key] = true end
	end

	for key in pairs(dropped) do
		if not predictionKeys[key] then repaint = true end
	end

	wipe(appliedTexture)
	wipe(appliedBackground)
	wipe(appliedPower)
	for key, settings in pairs(config) do
		if settings.texture then appliedTexture[key] = true end
		if settings.background then appliedBackground[key] = true end
		if settings.power then appliedPower[key] = true end
		if not predictionKeys[key] then bars = true end
	end

	local healComm = false
	for _, key in ipairs(healCommKeys) do
		if config[key] then healComm = true end
	end

	active = bars

	-- every hook is installed only while something needs it, an untouched module costs nothing
	ToggleHook("Update_StatusBar", bars)
	ToggleHook("ToggleTransparentStatusBar", bars)
	ToggleHook("SetTexture_HealComm", healComm)
	ToggleHook("Configure_PowerPrediction", config.powerprediction ~= nil)

	-- a dropped bar override needs ElvUI to repaint its own texture, the hook re-applies whatever is still enabled
	if repaint and UF.Initialized then UF:Update_StatusBars() end

	-- dropped only steers the sweep below, leaving it filled would make the hooks repaint what ElvUI already set
	mMT:ForEachUFFrame(UpdateFrame)
	wipe(dropped)
end
