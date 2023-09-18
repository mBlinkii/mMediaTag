local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.ResurrectionIcon
if not module then
	return
end

local function ResurrectionIcon(_, frame)
	frame.ResurrectIndicator:SetTexture(mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.resurrection.icon])
end

function module:Initialize()
	if module.hooked then return end
	hooksecurefunc(UF, "Configure_ResurrectionIcon", ResurrectionIcon)

    module.hooked = true
	module.needReloadUI = true
	module.loaded = true
end
