local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local module = mMT.Modules.PhaseIcon
if not module then
	return
end

local blank = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\unitframes\\blank.tga"
local PhaseColors = {
	chromie = { r = 1, g = 0.9, b = 0.5 },
	warmode = { r = 1, g = 0.3, b = 0.3 },
	sharding = { r = 0.5, g = 1, b = 0.3 },
	phasing = { r = 0.3, g = 0.5, b = 1 },
}

function module:PhaseIconColor(hidden, phaseReason)
	if E.db.mMT.unitframeicons.phase.color.withe then
		self.Center:SetVertexColor(1, 1, 1)
	else
		local c = { r = 1, g = 1, b = 1 }
		if phaseReason == 3 then -- chromie, gold
			c = PhaseColors.chromie
			self.Center:SetVertexColor(c.r, c.g, c.b)
		elseif phaseReason == 2 then -- warmode, red
			c = PhaseColors.warmode
			self.Center:SetVertexColor(c.r, c.g, c.b)
		elseif phaseReason == 1 then -- sharding, green
			c = PhaseColors.sharding
			self.Center:SetVertexColor(c.r, c.g, c.b)
		else -- phasing, blue
			c = PhaseColors.phasing
			self.Center:SetVertexColor(c.r, c.g, c.b)
		end
	end
end

local function PhaseIcon(_, frame)
	frame.PhaseIndicator:SetTexture(blank)
	frame.PhaseIndicator.Center:SetTexture(mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.phase.icon])
end

function module:Initialize()
	E.Media.Textures.PhaseBorder = blank
	E.Media.Textures.PhaseCenter = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.phase.icon]

	if not module.hooked_Configure then
		hooksecurefunc(UF, "Configure_PhaseIcon", PhaseIcon)
		module.hooked_Configure = true
	end

	if E.db.mMT.unitframeicons.phase.color.enable then
		PhaseColors = {
			chromie = E.db.mMT.unitframeicons.phase.color.chromie,
			warmode = E.db.mMT.unitframeicons.phase.color.warmode,
			sharding = E.db.mMT.unitframeicons.phase.color.sharding,
			phasing = E.db.mMT.unitframeicons.phase.color.phasing,
		}

		if not module.hooked_PostUpdate then
			hooksecurefunc(UF, "PostUpdate_PhaseIcon", module.PhaseIconColor)
			module.hooked_PostUpdate = true
		end
	end
end
