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

function module:Initialize()
	if not E.db.mMediaTag.phase_icon.enable then return end

	module.blank = [[Interface\AddOns\ElvUI_mMediaTag\media\blank.tga]]
	module.texture = MEDIA.icons.phase_icons[E.db.mMediaTag.phase_icon.icon]
	module.PhaseColors = MEDIA.color.phase_icon

	if not module.isEnabled then
		module:SecureHook(UF, "Configure_PhaseIcon", function(_, frame)
			Configure_PhaseIcon(frame)
		end)

		module:SecureHook(UF, "PostUpdate_PhaseIcon", PostUpdate_PhaseIcon)
		module.isEnabled = true
	end
end
