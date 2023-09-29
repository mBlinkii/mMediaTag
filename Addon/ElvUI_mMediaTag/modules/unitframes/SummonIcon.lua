local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.SummonIcon
if not module then
	return
end

local function SummonIcon(_, frame)
	frame.SummonIndicator.PostUpdate = function(self, status)
		if status == 1 then
			self:SetTexture(mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.summon.available])
		elseif status == 2 then
			self:SetTexture(mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.summon.accepted])
		elseif status == 3 then
			self:SetTexture(mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.summon.rejected])
		end
	end
end

function module:Initialize()
	if module.hooked then
		return
	end

	hooksecurefunc(UF, "Configure_SummonIcon", SummonIcon)

	module.hooked = true
	module.needReloadUI = true
	module.loaded = true
end
