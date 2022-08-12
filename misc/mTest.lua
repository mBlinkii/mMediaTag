local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"

local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')
local LSM = E.Libs.LSM

local ipairs = ipairs
local unpack = unpack
local UnitPlayerControlled = UnitPlayerControlled
local UnitIsTapDenied = UnitIsTapDenied
local UnitClass = UnitClass
local UnitReaction = UnitReaction
local UnitIsConnected = UnitIsConnected
local CreateFrame = CreateFrame
local addon, ns = ...

class = {
	[ 0] = {r = 1.00, g = 0.18, b = 0.18}, -- HOSTILE
	[ 1] = {r = 1.00, g = 0.51, b = 0.20}, -- UNFRIENDLY
	[ 2] = {r = 1.00, g = 0.85, b = 0.20}, -- NEUTRAL
	[ 3] = {r = 0.20, g = 0.71, b = 0.00}, -- FRIENDLY
	[ 5] = {r = 0.40, g = 0.53, b = 1.00}, -- PLAYER_EXTENDED
	[ 6] = {r = 0.40, g = 0.20, b = 1.00}, -- PARTY
	[ 7] = {r = 0.73, g = 0.20, b = 1.00}, -- PARTY_PVP
	[ 8] = {r = 0.20, g = 1.00, b = 0.42}, -- FRIEND
	[ 9] = {r = 0.60, g = 0.60, b = 0.60}, -- DEAD
	[13] = {r = 0.10, g = 0.58, b = 0.28}, -- BATTLEGROUND_FRIENDLY_PVP
}

selection = {
	[ 0] = {r = 1.00, g = 0.18, b = 0.18}, -- HOSTILE
	[ 1] = {r = 1.00, g = 0.51, b = 0.20}, -- UNFRIENDLY
	[ 2] = {r = 1.00, g = 0.85, b = 0.20}, -- NEUTRAL
	[ 3] = {r = 0.20, g = 0.71, b = 0.00}, -- FRIENDLY
	[ 5] = {r = 0.40, g = 0.53, b = 1.00}, -- PLAYER_EXTENDED
	[ 6] = {r = 0.40, g = 0.20, b = 1.00}, -- PARTY
	[ 7] = {r = 0.73, g = 0.20, b = 1.00}, -- PARTY_PVP
	[ 8] = {r = 0.20, g = 1.00, b = 0.42}, -- FRIEND
	[ 9] = {r = 0.60, g = 0.60, b = 0.60}, -- DEAD
	[13] = {r = 0.10, g = 0.58, b = 0.28}, -- BATTLEGROUND_FRIENDLY_PVP
}

tapped = {r = 0.6, g = 0.6, b = 0.6}

reactions = {
	good = {r = .29, g = .68, b = .30},
	neutral = {r = .85, g = .77, b = .36},
	bad = {r = 0.78, g = 0.25, b = 0.25},
}

function NP:Health_UpdateColor(_, unit)
	if not unit or self.unit ~= unit then return end
	local element = self.Health
	local Selection = E.Retail and element.colorSelection and NP:UnitSelectionType(unit, element.considerSelectionInCombatHostile)

	local r, g, b, t
	if element.colorDisconnected and not UnitIsConnected(unit) then
		t = self.colors.disconnected
	elseif element.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
		t = NP.db.colors.tapped
	elseif (element.colorClass and self.isPlayer) or (element.colorClassNPC and not self.isPlayer) or (element.colorClassPet and UnitPlayerControlled(unit) and not self.isPlayer) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif Selection then
		if Selection == 3 then Selection = UnitPlayerControlled(unit) and 5 or 3 end
		t = NP.db.colors.selection[Selection]
	elseif element.colorReaction and UnitReaction(unit, 'player') then
		local reaction = UnitReaction(unit, 'player')
		t = NP.db.colors.reactions[reaction == 4 and 'neutral' or reaction <= 3 and 'bad' or 'good']
		print(4 and 'neutral' or reaction <= 3 and 'bad' or 'good')
	elseif element.colorSmooth then
		r, g, b = self:ColorGradient(element.cur or 1, element.max or 1, unpack(element.smoothGradient or self.colors.smooth))
	elseif element.colorHealth then
		t = NP.db.colors.health
	end

	if t then
		r, g, b = t[1] or t.r, t[2] or t.g, t[3] or t.b
		element.r, element.g, element.b = r, g, b -- save these for the style filter to switch back
	end

	local sf = NP:StyleFilterChanges(self)
	if sf.HealthColor then
		r, g, b = sf.HealthColor.r, sf.HealthColor.g, sf.HealthColor.b
	end

	if b then
		element:GetStatusBarTexture():SetGradient("HORIZONTAL", r-0.4, g-0.4, b-0.4, r, g, b)

		if element.bg then
			element.bg:SetVertexColor(r * NP.multiplier, g * NP.multiplier, b * NP.multiplier)
		end
	end

	if element.PostUpdateColor then
		element:PostUpdateColor(unit, r, g, b)
	end
end

function NP:ThreatIndicator_PostUpdate(unit, status)
	local nameplate, colors, db = self.__owner, NP.db.colors.threat, NP.db.threat
	local sf = NP:StyleFilterChanges(nameplate)
	if not status and not sf.Scale then
		nameplate.ThreatScale = 1
		NP:ScalePlate(nameplate, 1)
	elseif status and db.enable and db.useThreatColor and not UnitIsTapDenied(unit) then
		NP:Health_SetColors(nameplate, true)
		nameplate.ThreatStatus = status

		local Color, Scale
		if status == 3 then -- securely tanking
			Color = self.offTank and colors.offTankColor or self.isTank and colors.goodColor or colors.badColor
			Scale = self.isTank and db.goodScale or db.badScale
		elseif status == 2 then -- insecurely tanking
			Color = self.offTank and colors.offTankColorBadTransition or self.isTank and colors.badTransition or colors.goodTransition
			Scale = 1
		elseif status == 1 then -- not tanking but threat higher than tank
			Color = self.offTank and colors.offTankColorGoodTransition or self.isTank and colors.goodTransition or colors.badTransition
			Scale = 1
		else -- not tanking at all
			Color = self.isTank and colors.badColor or colors.goodColor
			Scale = self.isTank and db.badScale or db.goodScale
		end

		if sf.HealthColor then
			self.r, self.g, self.b = Color.r, Color.g, Color.b
		else
			nameplate.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", Color.r, Color.g, Color.b, Color.r-0.4, Color.g-0.4, Color.b-0.4)
		end

		if Scale then
			nameplate.ThreatScale = Scale

			if not sf.Scale then
				NP:ScalePlate(nameplate, Scale)
			end
		end
	end
end

-- function NP:StyleFilterClearChanges(frame, HealthColor, PowerColor, Borders, HealthFlash, HealthTexture, Scale, Alpha, NameTag, PowerTag, HealthTag, TitleTag, LevelTag, Portrait, NameOnly, Visibility)
-- 	local db = NP:PlateDB(frame)
-- 	if frame.StyleFilterChanges then
-- 		wipe(frame.StyleFilterChanges)
-- 	end

-- 	if Visibility then
-- 		NP:StyleFilterBaseUpdate(frame, true)
-- 		frame:ClearAllPoints() -- pull the frame back in
-- 		frame:Point('CENTER')
-- 	end
-- 	if HealthColor then
-- 		local h = frame.Health
-- 		if h.r and h.g and h.b then
-- 			--test here
-- 			h:SetStatusBarColor(h.r, h.g, h.b, h.r-0.4, h.g-0.4, h.b-0.4)
-- 			frame.Cutaway.Health:SetVertexColor(h.r * 1.5, h.g * 1.5, h.b * 1.5, 1)
-- 		end
-- 	end
-- 	if PowerColor then
-- 		local pc = NP.db.colors.power[frame.Power.token] or _G.PowerBarColor[frame.Power.token] or FallbackColor
-- 		frame.Power:SetStatusBarColor(pc.r, pc.g, pc.b)
-- 		frame.Cutaway.Power:SetVertexColor(pc.r * 1.5, pc.g * 1.5, pc.b * 1.5, 1)
-- 	end
-- 	if Borders then
-- 		NP:StyleFilterBorderLock(frame.Health.backdrop)

-- 		if frame.Power.backdrop and db.power.enable then
-- 			NP:StyleFilterBorderLock(frame.Power.backdrop)
-- 		end
-- 	end
-- 	if HealthFlash then
-- 		E:StopFlash(frame.HealthFlashTexture)
-- 		frame.HealthFlashTexture:Hide()
-- 	end
-- 	if HealthTexture then
-- 		local tx = LSM:Fetch('statusbar', NP.db.statusbar)
-- 		frame.Health:SetStatusBarTexture(tx)
-- 	end
-- 	if Scale then
-- 		NP:ScalePlate(frame, frame.ThreatScale or 1)
-- 	end
-- 	if Alpha then
-- 		NP:PlateFade(frame, NP.db.fadeIn and 1 or 0, (frame.FadeObject and frame.FadeObject.endAlpha) or 0.5, 1)
-- 	end
-- 	if Portrait then
-- 		NP:Update_Portrait(frame)
-- 		frame.Portrait:ForceUpdate()
-- 	end
-- 	if NameOnly then
-- 		NP:StyleFilterBaseUpdate(frame)
-- 	else -- Only update these if it wasn't NameOnly. Otherwise, it leads to `Update_Tags` which does the job.
-- 		if NameTag then frame:Tag(frame.Name, db.name.format) frame.Name:UpdateTag() end
-- 		if PowerTag then frame:Tag(frame.Power.Text, db.power.text.format) frame.Power.Text:UpdateTag() end
-- 		if HealthTag then frame:Tag(frame.Health.Text, db.health.text.format) frame.Health.Text:UpdateTag() end
-- 		if TitleTag then frame:Tag(frame.Title, db.title.format) frame.Title:UpdateTag() end
-- 		if LevelTag then frame:Tag(frame.Level, db.level.format) frame.Level:UpdateTag() end
-- 	end
-- end

-- function  NP:Health_UpdateColor(_, unit, event, plate)
--     -- print(unit)
--     -- print(r)
--     -- print(g)

--     -- print("_____ EDN")
-- end

--hooksecurefunc(NP, "Health_UpdateColor", mgl)

-- local original_AnAddon_Module_FuncName = AnAddon.Module.FuncName;
-- function AnAddon.Module:FuncName(...)
--   local arg1 = ...; -- Use the vararg expression in case the function signature changes
--   if type(arg1) == "number" and arg1 > 0 then
--     -- Call the original function; because of object calling syntax, 
--     --   pass self as the first argument.
--     return original_AnAddon_Module_FuncName(self, ...);
--   end
-- end