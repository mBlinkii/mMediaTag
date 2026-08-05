local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("SummonIcon", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")

local function PostUpdate(frame, status)
	if status == 0 then return end

	if status == 1 then
		frame:SetTexture(module.available.texture)
		frame:SetVertexColor(module.available.color.r, module.available.color.g, module.available.color.b)
	elseif status == 2 then
		frame:SetTexture(module.accepted.texture)
		frame:SetVertexColor(module.accepted.color.r, module.accepted.color.g, module.accepted.color.b)
	elseif status == 3 then
		frame:SetTexture(module.rejected.texture)
		frame:SetVertexColor(module.rejected.color.r, module.rejected.color.g, module.rejected.color.b)
	end
end

local function UpdateFrame(frame)
	local indicator = frame and frame.SummonIndicator
	if not indicator then return end
	if not indicator.PostUpdate then indicator.PostUpdate = PostUpdate end
end

function module:Initialize()
	if not E.db.mMediaTag.summon_icon.enable then return end

	module.available = { texture = MEDIA.icons.summon_icon[E.db.mMediaTag.summon_icon.available], color = MEDIA.color.summon_icon.available }
	module.accepted = { texture = MEDIA.icons.summon_icon[E.db.mMediaTag.summon_icon.accepted], color = MEDIA.color.summon_icon.accepted }
	module.rejected = { texture = MEDIA.icons.summon_icon[E.db.mMediaTag.summon_icon.rejected], color = MEDIA.color.summon_icon.rejected }

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_SummonIcon", function(_, frame)
			UpdateFrame(frame)
		end)
		module.isEnabled = true
	end

	-- ElvUI's first Configure pass is already done when mMT initializes, the hook alone would wait for the next UF update.
	mMT:ForEachUFFrame(UpdateFrame)
end
