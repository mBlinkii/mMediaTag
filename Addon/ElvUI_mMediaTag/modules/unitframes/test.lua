local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.test
if not module then
	return
end

local vP = 0.2

local function Set_Gradient(bar, color, oriantation)
	if bar and color then
		if oriantation == "LEFT" then
			bar:SetGradient("HORIZONTAL", { r = color.r + vP, g = color.g + vP, b = color.b + vP, a = color.a or 1 }, { r = color.r - vP, g = color.g - vP, b = color.b - vP, a = color.a or 1 })
		else
			bar:SetGradient("HORIZONTAL", { r = color.r - vP, g = color.g - vP, b = color.b - vP, a = color.a or 1 }, { r = color.r + vP, g = color.g + vP, b = color.b + vP, a = color.a or 1 })
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
		Set_Gradient(statusbar, { r = r, g = g, b = b }, parent.ORIENTATION)
	end
end

local function UF_Gradient_Power(self, unit, r, g, b)
	--mMT:Print(unit)
	local parent = self:GetParent()
	if parent and b then
		local statusbar = (parent and parent.Power) and parent.Power:GetStatusBarTexture() or nil
		Set_Gradient(statusbar, { r = r, g = g, b = b }, parent.ORIENTATION)
	end
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
		Set_Gradient(statusbar, { r = r, g = g, b = b }, parent.ORIENTATION)
	end
end

function module:Initialize()
	if module.hooked then
		return
	end

	hooksecurefunc(UF, "PostUpdateHealthColor", UF_Gradient_Health)
	hooksecurefunc(UF, "PostUpdatePowerColor", UF_Gradient_Power)
	hooksecurefunc(UF, "PostCastInterruptible", UF_Gradient_Castbar)
	hooksecurefunc(UF, "PostCastFail", UF_Gradient_Castbar)
	hooksecurefunc(UF, "PostCastStart", UF_Gradient_Castbar)

	module.hooked = true
	module.needReloadUI = true
	module.loaded = true
end
