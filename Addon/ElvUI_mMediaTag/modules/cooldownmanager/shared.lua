local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:GetModule("CooldownManager")

-- Cache WoW Globals
local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local pairs = pairs
local next = next
local type = type
local wipe = wipe
local tsort = table.sort
local ceil = math.ceil
local floor = math.floor
local min = math.min
local UnitClass = UnitClass
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local C_Timer = C_Timer
local C_Spell_GetSpellCooldown = C_Spell.GetSpellCooldown
local C_Spell_GetSpellCooldownDuration = C_Spell.GetSpellCooldownDuration
local C_Spell_GetSpellChargeDuration = C_Spell.GetSpellChargeDuration
local C_Spell_GetSpellCharges = C_Spell.GetSpellCharges
local C_ActionBar_FindSpellActionButtons = C_ActionBar.FindSpellActionButtons
local FindSpellOverrideByID = C_SpellBook and C_SpellBook.FindSpellOverrideByID
local IsSpellOverlayed = C_SpellActivationOverlay and C_SpellActivationOverlay.IsSpellOverlayed

local LSM = module.LSM
local LCG = module.LCG
local GLOW_KEY = "mMT_CDM"
local PANDEMIC_KEY = "mMT_CDM_Pandemic"
local GLOW_LEVEL = 8
local GLOW_PREFIXES = { "_PixelGlow", "_AutoCastGlow", "_ButtonGlow", "_ProcGlow" }
local COOLDOWN_SWIPE_ALPHA = 0.7
local AURA_SWIPE = { r = 1, g = 0.95, b = 0.57, a = 0.7 }

-- Blizzard exposes its own swipe colors once the viewer addon is loaded
local function BlizzardColor(name, fallback)
	local constants = _G.CooldownViewerConstants
	return (constants and constants[name]) or fallback
end

local glowColor = {}

local function Disabled()
	return module:IsDisabled()
end

local function IgnoreQuadrant() end

function module:CreateContainer(key)
	local info = module.VIEWERS[key]
	local vdb = module:ViewerDB(key)

	local w, h
	if key == "buff_bar" then
		w = vdb and vdb.width or 200
		h = (vdb and vdb.height or 20) * 4
	else
		local iconW = vdb and vdb.width or 30
		local iconH = (vdb and vdb.keep_ratio and iconW) or (vdb and vdb.height or 30)
		w, h = iconW * 8, iconH * 2
	end

	local frame = CreateFrame("Frame", info.mover .. "_Holder", E.UIParent)
	frame:SetSize(w, h)
	frame:SetPoint("TOPLEFT", E.UIParent, "CENTER", 0, 0)
	frame:SetFrameStrata("MEDIUM")
	frame:SetFrameLevel(5)

	E:CreateMover(frame, info.mover .. "_Mover", "mMT " .. info.label, nil, nil, IgnoreQuadrant, "ALL,MMEDIATAG", Disabled, "mMT,cooldownmanager," .. key)

	module.containers[key] = frame
	return frame
end

-- A no-op SetSize can still run the mover hook chain into a protected call while in combat
function module:SetContainerSize(container, w, h)
	if not container then return end
	if container.mmtW == w and container.mmtH == h then return end
	container:SetSize(w, h)
	container.mmtW, container.mmtH = w, h
end

function module:AnchorToMover(key, growth)
	local container = module.containers[key]
	if not container then return end

	local mover = _G[module.VIEWERS[key].mover .. "_Mover"]
	if not mover then return end

	-- Keep the edge the icons grow away from pinned, otherwise the block walks across the screen
	if not InCombatLockdown() and mover:GetPoint() then
		local anchor = (growth == "UP" and "BOTTOM") or (growth == "DOWN" and "TOP") or "CENTER"
		local x = (mover:GetLeft() + mover:GetRight()) / 2
		local y
		if anchor == "BOTTOM" then
			y = mover:GetBottom()
		elseif anchor == "TOP" then
			y = mover:GetTop()
		else
			y = (mover:GetBottom() + mover:GetTop()) / 2
		end

		if x and y then
			mover:ClearAllPoints()
			mover:SetPoint(anchor, _G.UIParent, "BOTTOMLEFT", x, y)
		end
	end

	container:ClearAllPoints()
	if growth == "UP" then
		container:SetPoint("BOTTOM", mover, "BOTTOM")
	elseif growth == "DOWN" then
		container:SetPoint("TOP", mover, "TOP")
	else
		container:SetPoint("CENTER", mover, "CENTER")
	end
end

function module:ShouldShow(key)
	local vdb = module:ViewerDB(key)
	if not vdb then return true end

	if module.demoActive and key ~= "custom" then return true end

	-- Hiding a container fires the viewers OnHide, which unregisters UNIT_AURA and stops it filling again
	if key == "custom" and module.emptyViewers[key] then return false end

	local visibility = vdb.visibility or "ALWAYS"
	if visibility == "HIDDEN" then return false end
	if visibility == "FADER" then return true end
	if visibility == "INCOMBAT" and not module.inCombat then return false end
	if visibility == "INPARTY" and not _G.IsInGroup() then return false end
	return true
end

function module:ContainerAlpha(key)
	local vdb = module:ViewerDB(key)
	local alpha = (vdb and vdb.alpha) or 1

	if vdb and vdb.visibility == "FADER" and not module.demoActive then
		local player = _G.ElvUF_Player
		alpha = alpha * ((player and player:GetAlpha()) or 1)
	end

	return alpha
end

local function StopFade(container)
	E:UIFrameFadeRemoveFrame(container)
	container.mmtFadingOut = nil

	if container.mmtHideTimer then
		container.mmtHideTimer:Cancel()
		container.mmtHideTimer = nil
	end
end

local function FinishHide(container)
	container.mmtFadingOut = nil
	container:Hide()
end

-- ElvUIs fader finishes instantly on a hidden frame, so the container stays shown until the fade is done
local function FadeOut(container, fade)
	container.mmtHideTimer = nil
	if not container:IsShown() then return end

	if not fade or fade <= 0 then
		container:Hide()
		return
	end

	container.mmtFadingOut = true
	E:UIFrameFadeOut(container, fade, container:GetAlpha(), 0)
	container.FadeObject.finishedFunc = FinishHide
	container.FadeObject.finishedArg1 = container
end

function module:UpdateContainerShown(key)
	local container = module.containers[key]
	if not container then return end

	local vdb = module:ViewerDB(key)
	local fade = (vdb and vdb.fade_time) or 0
	local alpha = module:ContainerAlpha(key)

	if module:ShouldShow(key) then
		local interrupted = container.mmtFadingOut or container.mmtHideTimer ~= nil
		StopFade(container)

		if not container:IsShown() then
			container:Show()
			container:SetAlpha(0)
			interrupted = true
		end

		if interrupted and fade > 0 then
			E:UIFrameFadeIn(container, fade, container:GetAlpha(), alpha)
		else
			container:SetAlpha(alpha)
		end

		return
	end

	if not container:IsShown() or container.mmtFadingOut or container.mmtHideTimer then return end

	local delay = (vdb and vdb.hide_delay) or 0
	if delay > 0 then
		container.mmtHideTimer = C_Timer.NewTimer(delay, function()
			FadeOut(container, fade)
		end)
	else
		FadeOut(container, fade)
	end
end

function module:UpdateVisibility()
	if module:IsDisabled() then return end

	for key in pairs(module.VIEWERS) do
		if module.containers[key] then
			module:UpdateContainerShown(key)

			-- The container carries the opacity, a second alpha on the viewer would square it
			local viewer = module:GetViewer(key)
			if viewer then viewer:SetAlpha(1) end
		end
	end
end

local function ViewerKey(frame)
	return module.styled[frame] or frame.mmtViewerKey
end

-- LibCustomGlow levels against the frame it is given, and Blizzard hands the bar children absolute
-- levels (Bar 511, Icon 512, DebuffBorder 520), so the anchor has to clear the highest child
local function GlowAnchor(frame)
	local anchor = frame.mmtGlowAnchor
	if not anchor then
		anchor = CreateFrame("Frame", nil, frame)
		anchor:SetAllPoints(frame)
		frame.mmtGlowAnchor = anchor
	end

	local level = frame:GetFrameLevel()
	for _, child in next, { frame:GetChildren() } do
		if child ~= anchor and child:GetFrameLevel() > level then level = child:GetFrameLevel() end
	end

	anchor:SetFrameStrata(frame:GetFrameStrata())
	anchor:SetFrameLevel(level + GLOW_LEVEL)
	return anchor
end

function module:StopGlow(frame, key)
	key = key or GLOW_KEY
	local active = module.glowActive[frame]
	if not LCG or not (active and active[key]) then return end
	active[key] = nil

	local target = frame.mmtGlowAnchor or frame
	LCG.PixelGlow_Stop(target, key)
	LCG.AutoCastGlow_Stop(target, key)
	LCG.ButtonGlow_Stop(target)
	LCG.ProcGlow_Stop(target, key)
end

function module:ApplyGlow(frame, glow, key)
	if not LCG or not glow then return end
	key = key or GLOW_KEY

	local active = module.glowActive[frame]
	if not active then
		active = {}
		module.glowActive[frame] = active
	end
	active[key] = true

	local color = glow.color
	if color then
		glowColor[1], glowColor[2], glowColor[3], glowColor[4] = color.r, color.g, color.b, color.a or 1
	else
		glowColor[1], glowColor[2], glowColor[3], glowColor[4] = 0.95, 0.95, 0.32, 1
	end

	local target = GlowAnchor(frame)
	local style = glow.type or "pixel"
	if style == "pixel" then
		LCG.PixelGlow_Start(target, glowColor, glow.lines or 8, glow.speed or 0.25, nil, glow.thickness or 2, 0, 0, nil, key, GLOW_LEVEL)
	elseif style == "autocast" then
		LCG.AutoCastGlow_Start(target, glowColor, glow.particles or 4, glow.speed or 0.25, glow.scale or 1, 0, 0, key, GLOW_LEVEL)
	elseif style == "button" then
		LCG.ButtonGlow_Start(target, glowColor, glow.speed or 0.25, GLOW_LEVEL)
	elseif style == "proc" then
		LCG.ProcGlow_Start(target, { color = glowColor, startAnim = glow.start_anim ~= false, key = key, frameLevel = GLOW_LEVEL })
	end

	-- The pooled glow frame may still carry a strata from an earlier user, so both are pinned here
	for _, prefix in ipairs(GLOW_PREFIXES) do
		local glowFrame = target[prefix .. key]
		if glowFrame then
			glowFrame:SetFrameStrata(target:GetFrameStrata())
			glowFrame:SetFrameLevel(target:GetFrameLevel() + GLOW_LEVEL)
			glowFrame:ClearAllPoints()
			glowFrame:SetPoint("TOPLEFT", target, "TOPLEFT", 0, 0)
			glowFrame:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", 0, 0)
			break
		end
	end
end

-- Buff icons glow for as long as the tracked buff is up, cooldown icons only while the spell procs
local function GlowSettings(frame)
	local key = ViewerKey(frame)
	if key == "buff_icon" or key == "buff_bar" then
		local spellID = frame.GetBaseSpellID and frame:GetBaseSpellID()
		return spellID and module:GetSpellGlow(spellID), true
	end

	local vdb = module:ViewerDB(key)
	return vdb and vdb.glow, false
end

-- 12.1 dropped the SpellActivationAlert child, the proc state now lives in C_SpellActivationOverlay
local function IsOverlayed(frame)
	if not IsSpellOverlayed then return false end

	local spellID = (frame.GetSpellID and frame:GetSpellID()) or (frame.GetBaseSpellID and frame:GetBaseSpellID())
	return (spellID and IsSpellOverlayed(spellID)) or false
end

function module:RefreshGlow(frame)
	local glow, perSpell = GlowSettings(frame)
	if not (glow and glow.enable) then
		module:StopGlow(frame)
		return
	end

	local manager = _G.ActionButtonSpellAlertManager
	if manager and manager.HideAlert then manager:HideAlert(frame) end

	if perSpell or frame.mmtDemoGlow or IsOverlayed(frame) then
		module:ApplyGlow(frame, glow)
	else
		module:StopGlow(frame)
	end
end

-- Blizzard calls RefreshOverlayGlow on every proc change, so the glow needs no polling
function module:HookGlow(frame)
	if module.hookedGlow[frame] or not frame.RefreshOverlayGlow then return end
	module.hookedGlow[frame] = true

	hooksecurefunc(frame, "RefreshOverlayGlow", function(self)
		module:RefreshGlow(self)
	end)
end

-- Blizzard re-shows the border on every aura refresh, so the hook has to re-read the setting
function module:ApplyDebuffBorder(frame, vdb)
	local border = frame.DebuffBorder
	if not border then return end

	if not frame.mmtBorderHooked then
		frame.mmtBorderHooked = true
		hooksecurefunc(border, "Show", function(self)
			local settings = module:ViewerDB(ViewerKey(frame))
			if settings and not settings.debuff_border then self:Hide() end
		end)
	end

	if not vdb.debuff_border then border:Hide() end
end

local function PaintTextures(frame, r, g, b)
	for _, region in next, { frame:GetRegions() } do
		if region:IsObjectType("Texture") and not region:IsObjectType("MaskTexture") then region:SetVertexColor(r, g, b) end
	end

	for _, child in next, { frame:GetChildren() } do
		PaintTextures(child, r, g, b)
	end
end

-- The setting was a plain boolean in the first build, normalize what may still sit in a profile
local function PandemicStyle(vdb)
	local style = vdb.pandemic
	if style == true then return "blizzard" end
	if style == false then return "none" end
	return style
end

function module:SetPandemic(item, active)
	local vdb = module:ViewerDB(ViewerKey(item))
	local style = vdb and PandemicStyle(vdb)
	if not style then return end

	local icon = item.PandemicIcon
	if icon then
		if style ~= "blizzard" then
			-- Blizzard re-shows its marker on every tick, so hiding has to be re-asserted
			icon:Hide()
		elseif icon.mmtPandemicVersion ~= module.pandemicVersion then
			icon.mmtPandemicVersion = module.pandemicVersion
			icon:SetAlpha(1)

			local color = vdb.pandemic_color
			if color then PaintTextures(icon, color.r, color.g, color.b) end
		end
	end

	if item.mmtPandemic == active and item.mmtPandemicStyle == style then return end
	item.mmtPandemic, item.mmtPandemicStyle = active, style

	if active and style == "glow" then
		module:ApplyGlow(item, vdb.pandemic_glow, PANDEMIC_KEY)
	else
		module:StopGlow(item, PANDEMIC_KEY)
	end
end

function module:HookPandemic(frame)
	if module.hookedPandemic[frame] or not frame.ShowPandemicStateFrame then return end
	module.hookedPandemic[frame] = true

	hooksecurefunc(frame, "ShowPandemicStateFrame", function(self)
		module:SetPandemic(self, true)
	end)

	hooksecurefunc(frame, "HidePandemicStateFrame", function(self)
		module:SetPandemic(self, false)
	end)
end

function module:StyleText(fs, text)
	if not fs or not text then return end

	fs:SetIgnoreParentScale(true)
	fs:ClearAllPoints()
	fs:SetPoint(text.position, text.x, text.y)

	local db = module:GetDB()
	E:SetFont(fs, LSM:Fetch("font", db.font), text.size, db.font_flag)

	if text.class_color then
		local color = E:ClassColor(E.myclass)
		if color then
			fs:SetTextColor(color.r, color.g, color.b)
			return
		end
	end

	fs:SetTextColor(text.color.r, text.color.g, text.color.b)
end

function module:ApplyCountText(frame, text)
	if not text then return end

	module:StyleText(frame.Applications and frame.Applications.Applications, text)
	module:StyleText(frame.Count, text)
	module:StyleText(frame.ChargeCount and frame.ChargeCount.Current, text)
end

-- Park the countdown region on mmtText and clear Cooldown.Text so ElvUI's CooldownText skips its own font pass
function module:ApplyCooldownText(cooldown, text)
	if not cooldown or not text then return end

	cooldown:SetHideCountdownNumbers(cooldown.mmtDemo or false)

	local fs = cooldown.mmtText or cooldown.Text or cooldown:GetRegions()
	if fs and fs.SetTextColor then
		cooldown.mmtText = fs
		cooldown.Text = nil
		module:StyleText(fs, text)
	end
end

-- Blizzard re-enables swipe and edge whenever a cooldown starts, so both need a standing hook
function module:ApplySwipeOverride(cooldown, db)
	if not cooldown or not db.hide_swipe then return end

	cooldown:SetDrawSwipe(false)
	cooldown:SetDrawEdge(false)

	if module.hookedSwipes[cooldown] then return end
	module.hookedSwipes[cooldown] = true

	hooksecurefunc(cooldown, "SetDrawSwipe", function(self, draw)
		if not draw then return end
		local dir = self.mmtASDir
		local item = self.mmtASItem
		local keepActive = dir and dir.swipe and not dir.showCD and item and item.cooldownSwipeColor and E:NotSecretValue(item.cooldownSwipeColor.r) and item.cooldownSwipeColor.r ~= 0
		if not keepActive and not module:IsDisabled() and module:GetDB().hide_swipe then self:SetDrawSwipe(false) end
	end)

	hooksecurefunc(cooldown, "SetDrawEdge", function(self, draw)
		if draw and not module:IsDisabled() and module:GetDB().hide_swipe then self:SetDrawEdge(false) end
	end)
end

function module:ApplyTextOverrides(frame, vdb, db)
	module:ApplyCountText(frame, vdb.count_text)
	module:ApplyCooldownText(frame.Cooldown, vdb.cooldown_text)
	module:ApplySwipeOverride(frame.Cooldown, db)
end

-- Blizzard tints the swipe with the aura color (r = 1) while the buff runs and black (r = 0) on cooldown
local function IsActivePhase(frame)
	local swipe = frame and frame.cooldownSwipeColor
	return (swipe and E:NotSecretValue(swipe.r) and swipe.r ~= 0) or false
end

-- Charge spells stay castable during their buff, so they must never be greyed; currentCharges is secret, maxCharges is not
local function IsChargeable(spellID)
	if not (spellID and C_Spell_GetSpellCharges) then return false end

	local info = C_Spell_GetSpellCharges((FindSpellOverrideByID and FindSpellOverrideByID(spellID)) or spellID)
	return (info and E:NotSecretValue(info.maxCharges) and info.maxCharges > 1) or false
end

local function PlayerClassColor()
	local _, class = UnitClass("player")
	return class and E:ClassColor(class)
end

local function ResolveActiveState(state)
	local mode = (state and state.mode) or "default"

	if mode == "hide" then
		return { swipe = { 0, 0, 0, COOLDOWN_SWIPE_ALPHA }, showCD = true, desat = true }
	elseif mode == "custom" then
		local dir = { desat = state.desaturate or false }
		local swipe = state.swipe or "aura"

		if swipe == "color" and state.swipe_color then
			local c = state.swipe_color
			dir.swipe = { c.r, c.g, c.b, c.a or COOLDOWN_SWIPE_ALPHA }
		elseif swipe == "class" then
			local c = PlayerClassColor()
			if c then dir.swipe = { c.r, c.g, c.b, COOLDOWN_SWIPE_ALPHA } end
		end

		if state.text_class_color then
			local c = PlayerClassColor()
			if c then dir.text = { c.r, c.g, c.b } end
		elseif state.text_color then
			dir.text = { state.text_color.r, state.text_color.g, state.text_color.b }
		end

		return dir
	end
end

local function AssertActiveState(cooldown, dir)
	if cooldown.mmtASBusy then return end
	cooldown.mmtASBusy = true

	if dir.swipe then
		cooldown:SetSwipeColor(dir.swipe[1], dir.swipe[2], dir.swipe[3], dir.swipe[4])
		if dir.showCD then cooldown:SetDrawSwipe(true) end
	end

	if dir.showCD then
		if cooldown.SetUseAuraDisplayTime then cooldown:SetUseAuraDisplayTime(false) end

		local spellID = cooldown.mmtASSpell
		if spellID and cooldown.SetCooldownFromDurationObject then
			local effectiveID = (FindSpellOverrideByID and FindSpellOverrideByID(spellID)) or spellID
			if cooldown.mmtASChargeable then
				-- GetSpellCooldown reads inactive while a charge is left, the recharge duration object is the only secret-safe source
				local duration = C_Spell_GetSpellChargeDuration and C_Spell_GetSpellChargeDuration(effectiveID)
				if duration then cooldown:SetCooldownFromDurationObject(duration) end
			else
				local info = C_Spell_GetSpellCooldown and C_Spell_GetSpellCooldown(effectiveID)
				if info and info.isActive then
					local duration = C_Spell_GetSpellCooldownDuration and C_Spell_GetSpellCooldownDuration(effectiveID)
					if duration then cooldown:SetCooldownFromDurationObject(duration) end
				end
			end
		end
	end

	if dir.text then
		local fs = cooldown.mmtText or cooldown.Text
		if fs and fs.SetTextColor then
			if not cooldown.mmtASTextOrig then cooldown.mmtASTextOrig = { fs:GetTextColor() } end
			fs:SetTextColor(dir.text[1], dir.text[2], dir.text[3])
		end
	end

	cooldown.mmtASBusy = false
end

local function RestoreActiveText(cooldown)
	local orig = cooldown.mmtASTextOrig
	if not orig then return end
	cooldown.mmtASTextOrig = nil

	local fs = cooldown.mmtText or cooldown.Text
	if fs and fs.SetTextColor then fs:SetTextColor(orig[1] or 1, orig[2] or 1, orig[3] or 1, orig[4] or 1) end
end

-- The hooks no-op without a directive, so every mode can share them and ride Blizzard's own untainted ticks
local function EnsureActiveStateHooks(frame, cooldown)
	if not module.hookedActiveState[cooldown] then
		module.hookedActiveState[cooldown] = true
		hooksecurefunc(cooldown, "SetSwipeColor", function(self, r)
			local dir = self.mmtASDir
			if not dir or self.mmtASBusy or type(r) ~= "number" or not E:NotSecretValue(r) then return end
			if r ~= 0 then
				AssertActiveState(self, dir)
			else
				RestoreActiveText(self)
			end
		end)
	end

	if frame.RefreshIconDesaturation and not module.hookedActiveState[frame] then
		module.hookedActiveState[frame] = true
		hooksecurefunc(frame, "RefreshIconDesaturation", function(self)
			local dir = self.Cooldown and self.Cooldown.mmtASDir
			if dir and dir.desat and not self.Cooldown.mmtASChargeable and IsActivePhase(self) then
				local texture = self.GetIconTexture and self:GetIconTexture()
				if texture then texture:SetDesaturated(true) end
			end
		end)
	end
end

function module:ApplyActiveState(frame, spellID)
	local cooldown = frame and frame.Cooldown
	if not cooldown then return end

	EnsureActiveStateHooks(frame, cooldown)

	local dir = ResolveActiveState(spellID and module:GetSpellActiveState(spellID))
	cooldown.mmtASDir = dir
	cooldown.mmtASSpell = (dir and spellID) or nil
	cooldown.mmtASItem = frame
	cooldown.mmtASChargeable = (dir and dir.desat and IsChargeable(spellID)) or nil

	local active = IsActivePhase(frame)

	if dir then
		cooldown.mmtASApplied = true
		if active then
			AssertActiveState(cooldown, dir)
			if frame.GetIconTexture then frame:GetIconTexture():SetDesaturated((dir.desat and not cooldown.mmtASChargeable) or false) end
		end
	elseif cooldown.mmtASApplied then
		-- Only restore once, never on always-default spells, or the aura display fights us on every layout pass
		cooldown.mmtASApplied = nil
		RestoreActiveText(cooldown)
		if cooldown.SetUseAuraDisplayTime then cooldown:SetUseAuraDisplayTime(true) end
		if active then
			local aura = BlizzardColor("ITEM_AURA_COLOR", AURA_SWIPE)
			cooldown:SetSwipeColor(aura.r, aura.g, aura.b, aura.a)
			if frame.GetIconTexture then frame:GetIconTexture():SetDesaturated(false) end
		end
	end
end

local actionKeys, actionKeysBuilt = {}, false

local function BuildActionKeys()
	actionKeysBuilt = true
	wipe(actionKeys)

	for bar = 1, 10 do
		for index = 1, 12 do
			local button = _G["ElvUI_Bar" .. bar .. "Button" .. index]
			local action = button and button._state_action
			if action and button.HotKey then
				local text = button.HotKey:GetText()
				if text and text ~= "" and text ~= _G.RANGE_INDICATOR then actionKeys[action] = text end
			end
		end
	end
end

function module:ResetKeybinds()
	actionKeysBuilt = false
end

function module:GetSpellKeybind(spellID)
	local slots = C_ActionBar_FindSpellActionButtons(spellID)
	if not slots then return nil end

	if not actionKeysBuilt then BuildActionKeys() end

	for _, slot in ipairs(slots) do
		local key = actionKeys[slot]
		if key then return key end
	end
end

function module:ApplyKeybindText(frame, vdb)
	local text = vdb and vdb.keybind_text
	local wanted = vdb and vdb.keybind and text
	local spellID = wanted and frame.GetBaseSpellID and frame:GetBaseSpellID()

	if not wanted or not (spellID or frame.mmtDemoKey) then
		if frame.mmtKeybind then frame.mmtKeybind:SetText("") end
		return
	end

	if not frame.mmtKeybind then
		frame.mmtKeybind = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		frame.mmtKeybind:SetJustifyH("RIGHT")
		frame.mmtKeybind:SetWordWrap(false)
	end

	module:StyleText(frame.mmtKeybind, text)
	frame.mmtKeybind:SetText(frame.mmtDemoKey or (spellID and module:GetSpellKeybind(spellID)) or "")
	frame.mmtKeybind:Show()
end

-- Reading the pool is safe, releasing or acquiring from here would taint every later EnumerateActive
function module:LayoutIconViewer(key, capture, callback)
	local container = module.containers[key]
	local vdb = module:ViewerDB(key)
	local viewer = module:GetViewer(key)
	local demo = module:DemoFrames(key)
	if not container or not vdb or module:IsDisabled() then return end
	if not demo and not (viewer and viewer.itemFramePool) then return end

	local db = module:GetDB()
	local width = E:Scale(vdb.width or 30)
	local height = (vdb.keep_ratio and width) or E:Scale(vdb.height or 30)
	local perRow = vdb.per_row or 12
	local spacing = E:Scale(vdb.spacing or 2)
	local growUp = vdb.growth == "UP"

	local icons = module.frameCache[key]
	if not icons then
		icons = {}
		module.frameCache[key] = icons
	end
	wipe(icons)

	if demo then
		for index = 1, #demo do
			icons[index] = demo[index]
		end
	else
		for frame in viewer.itemFramePool:EnumerateActive() do
			if frame and frame:IsShown() and frame.layoutIndex then icons[#icons + 1] = frame end
		end
		tsort(icons, module.sortFunc)
	end

	local count = #icons
	module.emptyViewers[key] = count == 0
	module:UpdateContainerShown(key)

	if count == 0 then
		module:SetContainerSize(container, perRow * width + (perRow - 1) * spacing, height)
		module:AnchorToMover(key, vdb.growth)
		return
	end

	for _, icon in ipairs(icons) do
		icon:SetScale(1)
		icon:SetSize(width, height)

		if capture or not module.styled[icon] then
			module:ApplyTextOverrides(icon, vdb, db)
			module.styled[icon] = key
			icon.mmtViewerKey = key
		end

		if callback then callback(icon, vdb, db) end

		module:ApplyDebuffBorder(icon, vdb)
		module:HookPandemic(icon)
	end

	local cols = min(count, perRow)
	local rows = ceil(count / perRow)
	local totalWidth = cols * width + (cols - 1) * spacing
	module:SetContainerSize(container, totalWidth, rows * height + (rows - 1) * spacing)

	for index, icon in ipairs(icons) do
		local row = floor((index - 1) / perRow)
		local col = (index - 1) % perRow
		local rowStart = row * perRow + 1
		local rowCount = min(rowStart + perRow - 1, count) - rowStart + 1
		local offset = (totalWidth - (rowCount * width + (rowCount - 1) * spacing)) / 2

		icon:ClearAllPoints()
		if growUp then
			icon:SetPoint("BOTTOMLEFT", container, "BOTTOMLEFT", offset + col * (width + spacing), row * (height + spacing))
		else
			icon:SetPoint("TOPLEFT", container, "TOPLEFT", offset + col * (width + spacing), -row * (height + spacing))
		end
	end

	module:AnchorToMover(key, vdb.growth)
end

function module:LayoutContainer(key, capture)
	if key == "essential" or key == "utility" then
		module:LayoutCooldownIcons(key, capture)
	elseif key == "buff_icon" then
		module:LayoutBuffIcons(capture)
	elseif key == "buff_bar" then
		module:LayoutBuffBars(capture)
	elseif key == "custom" then
		module:LayoutCustomTracker()
	end
end
