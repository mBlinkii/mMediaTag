local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.ReadyCheckIcons
if not module then
	return
end

local function ReadyCheckIcons(_, frame)
	frame.ReadyCheckIndicator.readyTexture = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.readycheck.ready]
	frame.ReadyCheckIndicator.notReadyTexture = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.readycheck.notready]
	frame.ReadyCheckIndicator.waitingTexture = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.readycheck.waiting]
end

function module:Initialize()
    if module.hooked then return end
	hooksecurefunc(UF, "Configure_ReadyCheckIcon", ReadyCheckIcons)

    module.hooked = true
	module.needReloadUI = true
	module.loaded = true
end

