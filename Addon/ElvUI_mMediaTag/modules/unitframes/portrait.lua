local E = unpack(ElvUI)
local _G = _G
local SetPortraitTexture = SetPortraitTexture

local player = {
	enable = true,
	texture = "ROUND5",
	mirror = false,
	size = 90,
	point = "RIGHT",
	relativePoint = "LEFT",
	circle = false,
	x = 0,
	y = 0,
}

local shadow = {
	enable = true,
	inner = true,
	color = { r = 0, g = 0, b = 0, a = 1 },
	innerColor = { r = 0, g = 0, b = 0, a = 1 },
}

local target = {
	enable = true,
	texture = "ROUND5",
	extraEnable = true,
	extra = "EXTRA5",
	mirror = true,
	size = 90,
	point = "LEFT",
	relativePoint = "RIGHT",
	circle = false,
	x = 0,
	y = 0,
}

local party = {
	enable = true,
	texture = "ROUND5",
	mirror = false,
	size = 90,
	point = "RIGHT",
	relativePoint = "LEFT",
	circle = false,
	x = 0,
	y = 0,
}

local general = {
	enable = true,
	combat = false,
	gradient = true,
	default = false,
	ori = "HORIZONTAL",
}

local textures = {
	SQUARE1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\square.tga",
	SQUARE2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\square2.tga",
	SQUARE3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\square3.tga",
	SQUARE4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\square4.tga",
	SQUAREEX1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareextra.tga",
	SQUAREEX2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareextra2.tga",
	SQUAREEX3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareextra3.tga",
	SQUAREEX4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareextra4.tga",
	CLASSICSQ1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareclassic.tga",
	CLASSICSQ2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareclassic2.tga",
	CLASSICSQ3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareclassic3.tga",
	CLASSICSQ4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\squareclassic4.tga",
	ROUND1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\round.tga",
	ROUND2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\round2.tga",
	ROUND3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\round3.tga",
	ROUND4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\round4.tga",
	CLASSICRO1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\roundclassic.tga",
	CLASSICRO2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\roundclassic2.tga",
	CLASSICRO3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\roundclassic3.tga",
	CLASSICRO4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\roundclassic4.tga",
	CIRCLE1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\party.tga",
	CIRCLE2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\party2.tga",
	CIRCLE3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\party3.tga",
	CIRCLE4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\party4.tga",
	EXTRA1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extra.tga",
	EXTRA2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extra2.tga",
	EXTRA3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extra3.tga",
	EXTRA4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extra4.tga",
}

local extraFull = {
	EXTRA1 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extrafull.tga",
	EXTRA2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extrafull2.tga",
	EXTRA3 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extrafull3.tga",
	EXTRA4 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extrafull4.tga",
	EXTRA5 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extrafull5.tga",
	EXTRA6 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\extrafull6.tga",
}

local colors = {
	default = {
		a = { r = 1, g = 1, b = 0, a = 1 },
		b = { r = 1, g = 1, b = 0, a = 1 },
	},
	DEATHKNIGHT = {
		a = { r = 0.77, g = 0.12, b = 0.23, a = 1 },
		b = { r = 0.37, g = 0, b = 0, a = 1 },
	},
	DEMONHUNTER = {
		a = { r = 0.64, g = 0.19, b = 0.79, a = 1 },
		b = { r = 0.24, g = 0, b = 0.37, a = 1 },
	},
	DRUID = {
		a = { r = 1.00, g = 0.49, b = 0.04, a = 1 },
		b = { r = 0.6, g = 0.09, b = 0, a = 1 },
	},
	EVOKER = {
		a = { r = 0.20, g = 0.58, b = 0.50, a = 1 },
		b = { r = 0, g = 0.18, b = 0.1, a = 1 },
	},
	HUNTER = {
		a = { r = 0.67, g = 0.83, b = 0.45, a = 1 },
		b = { r = 0.27, g = 0.43, b = 0.05, a = 1 },
	},
	MAGE = {
		a = { r = 0.20, g = 0.78, b = 0.92, a = 1 },
		b = { r = 0, g = 0.38, b = 0.52, a = 1 },
	},
	MONK = {
		a = { r = 0, g = 1.00, b = 0.60, a = 1 },
		b = { r = 0, g = 0.6, b = 0.2, a = 1 },
	},
	PALADIN = {
		a = { r = 0.96, g = 0.55, b = 0.73, a = 1 },
		b = { r = 0.56, g = 0.15, b = 0.43, a = 1 },
	},
	PRIEST = {
		a = { r = 1.00, g = 1.00, b = 1.00, a = 1 },
		b = { r = 0.6, g = 0.6, b = 0.6, a = 1 },
	},
	ROGUE = {
		a = { r = 1.00, g = 0.96, b = 0.41, a = 1 },
		b = { r = 0.6, g = 0.56, b = 0.01, a = 1 },
	},
	SHAMAN = {
		a = { r = 0.00, g = 0.44, b = 0.87, a = 1 },
		b = { r = 0, g = 0.04, b = 0.47, a = 1 },
	},
	WARLOCK = {
		a = { r = 0.53, g = 0.53, b = 0.93, a = 1 },
		b = { r = 0.13, g = 0.13, b = 0.53, a = 1 },
	},
	WARRIOR = {
		a = { r = 0.78, g = 0.61, b = 0.43, a = 1 },
		b = { r = 0.38, g = 0.21, b = 0.03, a = 1 },
	},
	rare = {
		a = { r = 0.51, g = 0.33, b = 0.33, a = 1 },
		b = { r = 0.11, g = 0, b = 0, a = 1 },
	},
	relite = {
		a = { r = 0.67, g = 0.32, b = 0.78, a = 1 },
		b = { r = 0.27, g = 0, b = 0.38, a = 1 },
	},
	elite = {
		a = { r = 1, g = 0.40, b = 0.83, a = 1 },
		b = { r = 0.6, g = 0, b = 0.43, a = 1 },
	},
	enemy = {
		a = { r = 0.77, g = 0.12, b = 0.23, a = 1 },
		b = { r = 0.37, g = 0, b = 0, a = 1 },
	},
	neutral = {
		a = { r = 1.00, g = 0.96, b = 0.41, a = 1 },
		b = { r = 0.6, g = 0.56, b = 0.01, a = 1 },
	},
	friendly = {
		a = { r = 0, g = 1.00, b = 0.60, a = 1 },
		b = { r = 0, g = 0.6, b = 0.2, a = 1 },
	},
}

function mMT:UpdatePortraitSettings()
	player = E.db.mMT.portraits.player
	target = E.db.mMT.portraits.target
	party = E.db.mMT.portraits.party
	general = E.db.mMT.portraits.general
	colors = E.db.mMT.portraits.colors
	shadow = E.db.mMT.portraits.shadow
end

local function setColor(texture, color, mirror)
	if not color then
		color = colors.default
	end

	if general.gradient then
		if mirror and (general.ori == "HORIZONTAL") then
			texture:SetGradient(general.ori, color.b, color.a)
		else
			texture:SetGradient(general.ori, color.a, color.b)
		end
	else
		texture:SetVertexColor(color.a.r, color.a.g, color.a.b, color.a.a)
	end
end

local function getColor(frame, unit)
	if general.default then
		return colors.default
	end
	local isPlayer = UnitIsPlayer(unit)
	if isPlayer then
		local _, class = UnitClass(unit)
		if not (frame.class and not frame.class == class) then
			frame.class = class
			frame.color = colors[class]
		end

		return frame.color
	else
		local reaction = UnitReaction("player", unit)
		if reaction then
			if reaction <= 3 then
				return colors.enemy
			elseif reaction == 4 then
				return colors.neutral
			elseif reaction >= 5 then
				return colors.friendly
			end
		else
			return colors.enemy
		end
	end
end

local function mirrorTexture(texture, mirror)
	if mirror then
		texture:SetTexCoord(1, 0, 0, 1)
	else
		texture:SetTexCoord(0, 1, 0, 1)
	end
end

local function CreatePortrait(parent, conf, unit)
	local texture = nil
	local frame = CreateFrame("Frame", "mMT_Portrait_" .. unit, parent)
	frame:SetSize(conf.size, conf.size)
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)
	frame:SetFrameLevel(parent.Health:GetFrameLevel() + 1)

	if unit == "target" and conf.extraEnable then
		texture = textures[conf.extra]

		if conf.texture:match("CIRCLE%d") then
			texture = extraFull[conf.extra]
		end

		frame.extra = frame:CreateTexture("mMT_Extra", "OVERLAY", nil, -6)
		frame.extra:SetAllPoints(frame)
		frame.extra:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(frame.extra, not conf.mirror)

		if shadow.enable then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadowextra1.tga"

			if conf.texture:match("CIRCLE%d") then
				texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadowextra2.tga"
			end

			frame.extra.shadow = frame:CreateTexture("mMT_Extra", "OVERLAY", nil, -8)
			frame.extra.shadow:SetAllPoints(frame)
			frame.extra.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			frame.extra.shadow:SetVertexColor(shadow.color.r, shadow.color.g, shadow.color.b, shadow.color.a)
			mirrorTexture(frame.extra.shadow, not conf.mirror)
		end

		frame.extra:Hide()
	end

	if shadow.enable then
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadow1.tga"

		if conf.texture:match("CIRCLE%d") then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadow4.tga"
		elseif conf.texture:match("SQUAREEX%d") then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadow3.tga"
		end

		frame.shadow = frame:CreateTexture("mMT_Shadow", "OVERLAY", nil, -4)
		frame.shadow:SetAllPoints(frame)
		frame.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		frame.shadow:SetVertexColor(shadow.color.r, shadow.color.g, shadow.color.b, shadow.color.a)
		mirrorTexture(frame.shadow, conf.mirror)
	end

	if shadow.inner then
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\innershadow1.tga"

		if conf.circle then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\innershadow2.tga"
		end

		frame.InnerShadow = frame:CreateTexture("mMT_innerShadow", "OVERLAY", nil, 2)
		frame.InnerShadow:SetAllPoints(frame)
		frame.InnerShadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		frame.InnerShadow:SetVertexColor(shadow.innerColor.r, shadow.innerColor.g, shadow.innerColor.b, shadow.innerColor.a)
		mirrorTexture(frame.InnerShadow, conf.mirror)
	end

	frame.texture = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 4)
	frame.texture:SetAllPoints(frame)
	frame.texture:SetTexture(textures[conf.texture], "CLAMP", "CLAMP", "TRILINEAR")
	mirrorTexture(frame.texture, conf.mirror)

	local offset = (conf.size / 5.5 * E.perfect)
	frame.portrait = frame:CreateTexture("mMT_Portrait", "OVERLAY", nil, 1)
	frame.portrait:SetPoint("TOPLEFT", offset, -offset)
	frame.portrait:SetPoint("BOTTOMRIGHT", -offset, offset)
	mirrorTexture(frame.portrait, conf.mirror)

	texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\mask1.tga"
	if conf.mirror then
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\mask2.tga"
	elseif conf.circle then
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\mask3.tga"
	end

	frame.mask = frame:CreateMaskTexture()
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	mirrorTexture(frame.mask, true)
	frame.mask:SetAllPoints(frame.portrait)

	return frame
end

local function CheckRareElite(frame, unit)
	local c = UnitClassification(unit)
	local extra = frame.extra
	local color = colors[c]

	if color then
		setColor(extra, color)
		extra.shadow:Show()
		extra:Show()
	else
		extra.shadow:Hide()
		extra:Hide()
	end
end

local function UpdatePortrait(frame, conf, unit, parent)
	local texture = nil

	frame:SetSize(conf.size, conf.size)
	frame:ClearAllPoints()
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)

	if unit == "target" and conf.extraEnable then
		texture = textures[conf.extra]
		if conf.texture:match("CIRCLE%d") then
			texture = extraFull[conf.extra]
		end
		frame.extra:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(frame.extra, not conf.mirror)
		frame.extra:Hide()

		if shadow.enable then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadowextra1.tga"

			if conf.texture:match("CIRCLE%d") then
				texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadowextra2.tga"
			end

			frame.extra.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			frame.extra.shadow:SetVertexColor(shadow.color.r, shadow.color.g, shadow.color.b, shadow.color.a)
			mirrorTexture(frame.extra.shadow, not conf.mirror)
			frame.extra.shadow:Hide()
		end

		CheckRareElite(frame, unit)
	end

	if shadow.enable then
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadow1.tga"

		if conf.texture:match("CIRCLE%d") then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadow4.tga"
		elseif conf.texture:match("SQUAREEX%d") then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\shadow3.tga"
		end

		frame.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		frame.shadow:SetVertexColor(shadow.color.r, shadow.color.g, shadow.color.b, shadow.color.a)
		mirrorTexture(frame.shadow, conf.mirror)
	end

	if shadow.inner then
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\innershadow1.tga"

		if conf.circle then
			texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\innershadow2.tga"
		end

		frame.InnerShadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(frame.InnerShadow, conf.mirror)
		frame.InnerShadow:SetVertexColor(shadow.innerColor.r, shadow.innerColor.g, shadow.innerColor.b, shadow.innerColor.a)
	end

	frame.texture:SetTexture(textures[conf.texture], "CLAMP", "CLAMP", "TRILINEAR")
	mirrorTexture(frame.texture, conf.mirror)
	setColor(frame.texture, getColor(frame, unit), conf.mirror)

	local yx = (conf.size / 5.5 * E.perfect)
	frame.portrait:SetPoint("TOPLEFT", yx, -yx)
	frame.portrait:SetPoint("BOTTOMRIGHT", -yx, yx)
	mirrorTexture(frame.portrait, conf.mirror)
	SetPortraitTexture(frame.portrait, unit, (E.Retail and not conf.circle))
end

function mMT:UpdatePortraits()
	if mMT.Portraits.Player then
		UpdatePortrait(mMT.Portraits.Player, player, "player", _G.ElvUF_Player)
	end

	if mMT.Portraits.Target then
		UpdatePortrait(mMT.Portraits.Target, target, "target", _G.ElvUF_Target)
	end

	if mMT.Portraits.Party1 then
		UpdatePortrait(mMT.Portraits.Party1, party, _G.ElvUF_PartyGroup1UnitButton1.unit, _G.ElvUF_PartyGroup1UnitButton1)
		UpdatePortrait(mMT.Portraits.Party2, party, _G.ElvUF_PartyGroup1UnitButton2.unit, _G.ElvUF_PartyGroup1UnitButton2)
		UpdatePortrait(mMT.Portraits.Party3, party, _G.ElvUF_PartyGroup1UnitButton3.unit, _G.ElvUF_PartyGroup1UnitButton3)
		UpdatePortrait(mMT.Portraits.Party4, party, _G.ElvUF_PartyGroup1UnitButton4.unit, _G.ElvUF_PartyGroup1UnitButton4)
		UpdatePortrait(mMT.Portraits.Party5, party, _G.ElvUF_PartyGroup1UnitButton5.unit, _G.ElvUF_PartyGroup1UnitButton5)
	end
end
function mMT:SetupPortraits()
	if not mMT.Portraits then
		mMT.Portraits = {}
	end

	if player.enable and not mMT.Portraits.Player then
		mMT.Portraits.Player = CreatePortrait(_G.ElvUF_Player, player, "player")
		mMT.Portraits.Player:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "player")
		mMT.Portraits.Player:RegisterEvent("PLAYER_ENTERING_WORLD")
		mMT.Portraits.Player:SetScript("OnEvent", function(self, event)
			SetPortraitTexture(self.portrait, "player", (E.Retail and not player.circle))
			setColor(self.texture, getColor(self, "player"), player.mirror)
		end)
	end

	if target.enable and not mMT.Portraits.Target then
		mMT.Portraits.Target = CreatePortrait(_G.ElvUF_Target, target, "target")
		mMT.Portraits.Target:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "target")
		mMT.Portraits.Target:RegisterEvent("PLAYER_TARGET_CHANGED")
		mMT.Portraits.Target:RegisterEvent("PLAYER_ENTERING_WORLD")
		mMT.Portraits.Target:SetScript("OnEvent", function(self, event)
			SetPortraitTexture(self.portrait, "target", (E.Retail and not target.circle))
			setColor(self.texture, getColor(self, "target"), target.mirror)
			if target.extraEnable then
				CheckRareElite(self, "target")
			else
				self.extra:Hide()
			end
		end)
	end

	if party.enable then
		if not mMT.Portraits.Party1 then
			mMT.Portraits.Party1 = CreatePortrait(_G.ElvUF_PartyGroup1UnitButton1, party, _G.ElvUF_PartyGroup1UnitButton1.unit)
			mMT.Portraits.Party1:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", _G.ElvUF_PartyGroup1UnitButton1.unit)
			mMT.Portraits.Party1:RegisterEvent("PLAYER_ENTERING_WORLD")
			mMT.Portraits.Party1:RegisterEvent("GROUP_ROSTER_UPDATE")
			mMT.Portraits.Party1:SetScript("OnEvent", function(self, event)
				SetPortraitTexture(self.portrait, _G.ElvUF_PartyGroup1UnitButton1.unit, (E.Retail and not party.circle))
				setColor(self.texture, getColor(self, _G.ElvUF_PartyGroup1UnitButton1.unit), party.mirror)
			end)
		end

		if not mMT.Portraits.Party2 then
			mMT.Portraits.Party2 = CreatePortrait(_G.ElvUF_PartyGroup1UnitButton2, party, _G.ElvUF_PartyGroup1UnitButton2.unit)
			mMT.Portraits.Party2:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", _G.ElvUF_PartyGroup1UnitButton2.unit)
			mMT.Portraits.Party2:RegisterEvent("PLAYER_ENTERING_WORLD")
			mMT.Portraits.Party2:RegisterEvent("GROUP_ROSTER_UPDATE")
			mMT.Portraits.Party2:SetScript("OnEvent", function(self, event)
				SetPortraitTexture(self.portrait, _G.ElvUF_PartyGroup1UnitButton2.unit, (E.Retail and not party.circle))
				setColor(self.texture, getColor(self, _G.ElvUF_PartyGroup1UnitButton2.unit), party.mirror)
			end)
		end

		if not mMT.Portraits.Party3 then
			mMT.Portraits.Party3 = CreatePortrait(_G.ElvUF_PartyGroup1UnitButton3, party, _G.ElvUF_PartyGroup1UnitButton3.unit)
			mMT.Portraits.Party3:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", _G.ElvUF_PartyGroup1UnitButton3.unit)
			mMT.Portraits.Party3:RegisterEvent("PLAYER_ENTERING_WORLD")
			mMT.Portraits.Party3:RegisterEvent("GROUP_ROSTER_UPDATE")
			mMT.Portraits.Party3:SetScript("OnEvent", function(self, event)
				SetPortraitTexture(self.portrait, _G.ElvUF_PartyGroup1UnitButton3.unit, (E.Retail and not party.circle))
				setColor(self.texture, getColor(self, _G.ElvUF_PartyGroup1UnitButton3.unit), party.mirror)
			end)
		end

		if not mMT.Portraits.Party4 then
			mMT.Portraits.Party4 = CreatePortrait(_G.ElvUF_PartyGroup1UnitButton4, party, _G.ElvUF_PartyGroup1UnitButton4.unit)
			mMT.Portraits.Party4:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", _G.ElvUF_PartyGroup1UnitButton4.unit)
			mMT.Portraits.Party4:RegisterEvent("PLAYER_ENTERING_WORLD")
			mMT.Portraits.Party4:RegisterEvent("GROUP_ROSTER_UPDATE")
			mMT.Portraits.Party4:SetScript("OnEvent", function(self, event)
				SetPortraitTexture(self.portrait, _G.ElvUF_PartyGroup1UnitButton4.unit, (E.Retail and not party.circle))
				setColor(self.texture, getColor(self, _G.ElvUF_PartyGroup1UnitButton4.unit), party.mirror)
			end)
		end

		if not mMT.Portraits.Party5 then
			mMT.Portraits.Party5 = CreatePortrait(_G.ElvUF_PartyGroup1UnitButton5, party, _G.ElvUF_PartyGroup1UnitButton5.unit)
			mMT.Portraits.Party5:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", _G.ElvUF_PartyGroup1UnitButton5.unit)
			mMT.Portraits.Party5:RegisterEvent("PLAYER_ENTERING_WORLD")
			mMT.Portraits.Party5:RegisterEvent("GROUP_ROSTER_UPDATE")
			mMT.Portraits.Party5:SetScript("OnEvent", function(self, event)
				SetPortraitTexture(self.portrait, _G.ElvUF_PartyGroup1UnitButton5.unit, (E.Retail and not party.circle))
				setColor(self.texture, getColor(self, _G.ElvUF_PartyGroup1UnitButton5.unit), party.mirror)
			end)
		end
	end
end
