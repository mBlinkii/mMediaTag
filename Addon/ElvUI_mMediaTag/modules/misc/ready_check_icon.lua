local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ReadyCheckIcon", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")

local function UpdateFrame(frame)
	local indicator = frame and frame.ReadyCheckIndicator
	if not indicator then return end

	indicator.readyTexture = module.ready
	indicator.notReadyTexture = module.notready
	indicator.waitingTexture = module.waiting
end

function module:Initialize()
	if not E.db.mMediaTag.ready_check_icon.enable then return end

	module.ready = MEDIA.icons.ready_check_icon[E.db.mMediaTag.ready_check_icon.ready]
	module.notready = MEDIA.icons.ready_check_icon[E.db.mMediaTag.ready_check_icon.notready]
	module.waiting = MEDIA.icons.ready_check_icon[E.db.mMediaTag.ready_check_icon.waiting]

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_ReadyCheckIcon", function(_, frame)
			UpdateFrame(frame)
		end)
		module.isEnabled = true
	end

	-- ElvUIs erster Configure-Pass ist beim Plugin-Load durch, der Hook allein
	-- wuerde erst beim naechsten UF-Update greifen.
	mMT:ForEachUFFrame(UpdateFrame)
end
