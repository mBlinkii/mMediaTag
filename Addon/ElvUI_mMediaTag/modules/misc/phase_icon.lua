local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("PhaseIcon", { "AceHook-3.0" })

local UF = E:GetModule("UnitFrames")
local PhaseReason = Enum.PhaseReason or { Phasing = 0, Sharding = 1, WarMode = 2, ChromieTime = 3, TimerunningHwt = 4 }

local function Configure_PhaseIcon(frame)
	if not (frame and frame.PhaseIndicator) then return end
	frame.PhaseIndicator:SetTexture(module.blank)
	frame.PhaseIndicator.Center:SetTexture(module.texture)
end

local function PostUpdate_PhaseIcon(self, hidden, phaseReason)
	local key = phaseReason == PhaseReason.TimerunningHwt and "TimerunningHwt"
		or phaseReason == PhaseReason.ChromieTime and "ChromieTime"
		or phaseReason == PhaseReason.WarMode and "WarMode"
		or phaseReason == PhaseReason.Sharding and "Sharding"
		or "Phasing"

	local c = module.PhaseColors[key]
	self.Center:SetVertexColor(c.r, c.g, c.b)
	self.Center:SetShown(not hidden)
end

			-- ElvUI snapshots phase.PostUpdate at frame construction and oUF only calls element:PostUpdate(), so hooking the UF table does nothing.
local function HookPhaseIndicator(frame)
	local phase = frame and frame.PhaseIndicator
	if not phase or phase.mMT_PhaseHooked or not phase.PostUpdate then return end

	hooksecurefunc(phase, "PostUpdate", PostUpdate_PhaseIcon)
	phase.mMT_PhaseHooked = true
end

local function UpdateFrame(frame)
	Configure_PhaseIcon(frame)
	HookPhaseIndicator(frame)
end

function module:Initialize()
	if not E.db.mMediaTag.phase_icon.enable then return end

	module.blank = MEDIA.none
	module.texture = MEDIA.icons.phase_icons[E.db.mMediaTag.phase_icon.icon]
	module.PhaseColors = MEDIA.color.phase_icon

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_PhaseIcon", function(_, frame)
			UpdateFrame(frame)
		end)

		module.isEnabled = true
	end

	mMT:ForEachUFFrame(UpdateFrame)
end
