local E = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")

local blank = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\unitframes\\blank.tga"
local PhaseColors = {
	chromie = { r = 1, g = 0.9, b = 0.5 },
	warmode = { r = 1, g = 0.3, b = 0.3 },
	sharding = { r = 0.5, g = 1, b = 0.3 },
	phasing = { r = 0.3, g = 0.5, b = 1 },
}
local function ReadyCheckIcons(_, frame)
	frame.ReadyCheckIndicator.readyTexture = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.readycheck.ready]
	frame.ReadyCheckIndicator.notReadyTexture = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.readycheck.notready]
	frame.ReadyCheckIndicator.waitingTexture = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.readycheck.waiting]
end

function mMT:PhaseIconColor(hidden, phaseReason)
	if E.db.mMT.unitframeicons.phase.color.withe then
		self.Center:SetVertexColor(1, 1, 1)
	else
		local c = {r = 1, g = 1, b = 1}
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

local function ResurrectionIcon(_, frame)
	frame.ResurrectIndicator:SetTexture(mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.resurrection.icon])
end

local function PhaseIcon(_, frame)
	frame.PhaseIndicator:SetTexture(blank)
	frame.PhaseIndicator.Center:SetTexture(mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.phase.icon])
end

function mMT:SetupResurrectionIcon()
	hooksecurefunc(UF, "Configure_ResurrectionIcon", ResurrectionIcon)
end
function mMT:SetupReadyCheckIcons()
	hooksecurefunc(UF, "Configure_ReadyCheckIcon", ReadyCheckIcons)
end
function mMT:SetupPhaseIcons()

	E.Media.Textures.PhaseBorder = blank
	E.Media.Textures.PhaseCenter = mMT.Media.UnitframeIcons[E.db.mMT.unitframeicons.phase.icon]
	hooksecurefunc(UF, "Configure_PhaseIcon", PhaseIcon)

	if E.db.mMT.unitframeicons.phase.color.enable then
		PhaseColors = {
			chromie = E.db.mMT.unitframeicons.phase.color.chromie,
			warmode = E.db.mMT.unitframeicons.phase.color.warmode,
			sharding = E.db.mMT.unitframeicons.phase.color.sharding,
			phasing = E.db.mMT.unitframeicons.phase.color.phasing,
		}
		hooksecurefunc(UF, "PostUpdate_PhaseIcon", mMT.PhaseIconColor)
	end
end
