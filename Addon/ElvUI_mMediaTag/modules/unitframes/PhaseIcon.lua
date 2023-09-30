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
	local c = { r = 1, g = 1, b = 1 }
	if E.db.mMT.unitframeicons.phase.color.withe then
		c = { r = 1, g = 1, b = 1 }
	else
		if phaseReason == 3 then -- chromie
			c = PhaseColors.chromie
		elseif phaseReason == 2 then -- warmode
			c = PhaseColors.warmode
		elseif phaseReason == 1 then -- sharding
			c = PhaseColors.sharding
		else -- phasing
			c = PhaseColors.phasing
		end
	end
	self.Center:SetVertexColor(c.r or 1, c.g or 1, c.b or 1)
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

	module.needReloadUI = true
	module.loaded = true
end
