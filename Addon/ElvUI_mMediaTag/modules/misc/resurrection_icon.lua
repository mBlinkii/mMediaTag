local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ResurrectionIcon", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")

local function UpdateFrame(frame)
	if not (frame and frame.ResurrectIndicator) then return end
	frame.ResurrectIndicator:SetTexture(module.texture)
end

function module:Initialize()
	if not E.db.mMediaTag.resurrection_icon.enable then return end

	module.texture = MEDIA.icons.resurrection_icon[E.db.mMediaTag.resurrection_icon.icon]

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_ResurrectionIcon", function(_, frame)
			UpdateFrame(frame)
		end)
		module.isEnabled = true
	end

	-- ElvUI's first Configure pass is done by the time the plugin loads, the hook alone
	-- would only take effect on the next UF update.
	mMT:ForEachUFFrame(UpdateFrame)
end
