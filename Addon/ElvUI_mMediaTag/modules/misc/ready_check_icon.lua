local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ReadyCheckIcon", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")

function module:Initialize()
	if not E.db.mMediaTag.ready_check_icon.enable then return end

	module.ready = MEDIA.icons.ready_check_icon[E.db.mMediaTag.ready_check_icon.ready]
	module.notready = MEDIA.icons.ready_check_icon[E.db.mMediaTag.ready_check_icon.notready]
	module.waiting = MEDIA.icons.ready_check_icon[E.db.mMediaTag.ready_check_icon.waiting]

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_ReadyCheckIcon", function(_, frame)
			if not (frame and frame.ReadyCheckIndicator) then return end
			frame.ReadyCheckIndicator.readyTexture = module.ready
			frame.ReadyCheckIndicator.notReadyTexture = module.notready
			frame.ReadyCheckIndicator.waitingTexture = module.waiting
		end)
		module.isEnabled = true
	end
end
