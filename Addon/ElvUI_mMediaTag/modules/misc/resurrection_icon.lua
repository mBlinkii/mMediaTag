local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ResurrectionIcon", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")

function module:Initialize()
	if not E.db.mMediaTag.resurrection_icon.enable then return end

	module.texture = MEDIA.icons.resurrection_icon[E.db.mMediaTag.resurrection_icon.icon]

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_ResurrectionIcon", function(_, frame)
			if not (frame and frame.ResurrectIndicator) then return end
			frame.ResurrectIndicator:SetTexture(module.texture)
		end)
		module.isEnabled = true
	end
end
