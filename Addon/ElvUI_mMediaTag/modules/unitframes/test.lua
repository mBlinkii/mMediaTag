local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")
local NP = E:GetModule('NamePlates')

local module = mMT.Modules.test
if not module then
	return
end

local settings = {
	enable = true,
	color = {
		all = false,
		Multiplier = {
			r = 0.2,
			g = 0.3,
			b = 0.5,
			allA = 0.50,
			allB = 0.80,
		},
	},
}

local function build_color(color, multi, prefix)
	-- local multimax = settings.color.Multiplier.allA
	-- local multimin = settings.color.Multiplier.allB

	-- if mod then
	-- 	if color.r == color.g and color.g == color.b then
	-- 		return { r = color.r * multi, g = color.g * multi, b = color.b * multi, a = color.a or 1 }
	-- 	elseif color.r > color.g and color.r > color.b then
	-- 		return { r = color.r * multimax, g = color.g * multimin, b = color.b * multimin, a = color.a or 1 }
	-- 	elseif color.g > color.b then
	-- 		return { r = color.r * multimin, g = color.g * multimax, b = color.b * multimin, a = color.a or 1 }
	-- 	else
	-- 		return { r = color.r * multimin, g = color.g * multimin, b = color.b * multimax, a = color.a or 1 }
	-- 	end
	-- else
	-- 	return { r = color.r, g = color.g, b = color.b, a = color.a or 1 }
	-- end

	-- if settings.color.all then
	-- 	return { r = color.r * multi, g = color.g * multi, b = color.b * multi, a = color.a or 1 }
	-- else
	-- 	if mod then
	-- 		if (color.r == color.g and color.g == color.b) then
	-- 			return { r = color.r * multi, g = color.g * multi, b = color.b * multi, a = color.a or 1 }
	-- 		else
	-- 			return { r = color.r * settings.color.Multiplier.r, g = color.g * settings.color.Multiplier.g, b = color.b * settings.color.Multiplier.b, a = color.a or 1 }
	-- 		end
	-- 	else
	-- 		return { r = color.r, g = color.g, b = color.b, a = color.a or 1 }
	-- 	end
	-- end

	mMT:Print(prefix)
	if prefix == "minus" then
		return { r = color.r - multi, g = color.g - multi, b = color.b - multi, a = color.a or 1 }
	else
		return { r = color.r + multi, g = color.g + multi, b = color.b + multi, a = color.a or 1 }
	end
end

local function Set_Gradient(bar, color, oriantation)
	if bar and color then
		local color_A = build_color(color, E.db.mMT.gradient.color.a.value, E.db.mMT.gradient.color.a.prefix)
		local color_B = build_color(color, E.db.mMT.gradient.color.b.value, E.db.mMT.gradient.color.b.prefix)
		if oriantation == "LEFT" then
			bar:SetGradient("HORIZONTAL", color_A, color_B)
		else
			bar:SetGradient("HORIZONTAL", color_B, color_A)
		end
	end
end

local function UF_Gradient_Health(self, unit, r, g, b)
	--mMT:Print(unit)
	local parent = self:GetParent()
	if parent then
		if not b then
			local colors = E.db.unitframe.colors
			r, g, b = colors.health.r, colors.health.g, colors.health.b
		end

		local statusbar = (parent and parent.Health) and parent.Health:GetStatusBarTexture() or nil
		Set_Gradient(statusbar, { r = r, g = g, b = b, a = 1 }, parent.ORIENTATION)
	end
end

local function UF_Gradient_Power(self, unit, r, g, b)
	--mMT:Print(unit)
	local parent = self:GetParent()
	if parent and b then
		local statusbar = (parent and parent.Power) and parent.Power:GetStatusBarTexture() or nil
		Set_Gradient(statusbar, { r = r, g = g, b = b, a = 1 }, parent.ORIENTATION)
	end
end

local function NP_Gradient_Health(self, unit, r, g, b)
	mMT:Print(self, unit, r, g, b)
	-- local parent = self:GetParent()
	-- if parent and b then
	-- 	local statusbar = (parent and parent.Power) and parent.Power:GetStatusBarTexture() or nil
	-- 	Set_Gradient(statusbar, { r = r, g = g, b = b, a = 1 }, parent.ORIENTATION)
	-- end
end

local function UF_Gradient_Castbar(self, unit)
	local parent = self.__owner
	local db = parent and parent.db
	if not db or not db.castbar then
		return
	end
	local r, g, b = UF.GetInterruptColor(self, db, unit)

	if parent and b then
		local statusbar = (parent and parent.Castbar) and parent.Castbar:GetStatusBarTexture() or nil
		Set_Gradient(statusbar, { r = r, g = g, b = b, a = 1 }, parent.ORIENTATION)
	end
end

function module:Initialize()
	settings = E.db.mMT.gradient

	if not module.hooked then
		hooksecurefunc(UF, "PostUpdateHealthColor", UF_Gradient_Health)
		hooksecurefunc(UF, "PostUpdatePowerColor", UF_Gradient_Power)
		hooksecurefunc(UF, "PostCastInterruptible", UF_Gradient_Castbar)
		hooksecurefunc(UF, "PostCastFail", UF_Gradient_Castbar)
		hooksecurefunc(UF, "PostCastStart", UF_Gradient_Castbar)
		--hooksecurefunc(NP, "PostUpdateColor", NP_Gradient_Health)
	end

	module.hooked = true
	module.needReloadUI = true
	module.loaded = true
end
