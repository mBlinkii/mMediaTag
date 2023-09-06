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
	border = true,
	borderColor = { r = 0, g = 0, b = 0, a = 1 },
	borderColorRare = { r = 0, g = 0, b = 0, a = 1 },
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
	gradient = true,
	corner = true,
	default = false,
	style = "flat",
	ori = "HORIZONTAL",
}
local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\"
local tx_DB = {
	retail = {
		texture = {
			flat = {
				SQ = path .. "sq_a.tga",
				RO = path .. "ro_a.tga",
				CI = path .. "ci_a.tga",
				CO = path .. "co_a.tga",
				EA = path .. "ex_a_a.tga",
				EB = path .. "ex_b_a.tga",
			},
			smooth = {
				SQ = path .. "sq_b.tga",
				RO = path .. "ro_b.tga",
				CI = path .. "ci_b.tga",
				CO = path .. "co_b.tga",
				EA = path .. "ex_a_b.tga",
				EB = path .. "ex_b_b.tga",
			},
			metal = {
				SQ = path .. "sq_c.tga",
				RO = path .. "ro_c.tga",
				CI = path .. "ci_c.tga",
				CO = path .. "co_c.tga",
				EA = path .. "ex_a_c.tga",
				EB = path .. "ex_b_c.tga",
			},
		},
		border = {
			SQ = path .. "border_sq.tga",
			RO = path .. "border_ro.tga",
			CI = path .. "border_ci.tga",
			CO = path .. "border_co.tga",
			EA = path .. "border_ex_a.tga",
			EB = path .. "border_ex_b.tga",
		},
		shadow = {
			SQ = path .. "shadow_sq.tga",
			RO = path .. "shadow_ro.tga",
			CI = path .. "shadow_ci.tga",
			EA = path .. "shadow_ex_a.tga",
			EB = path .. "shadow_ex_b.tga",
		},
		inner = {
			SQ = path .. "inner_a.tga",
			RO = path .. "inner_a.tga",
			CI = path .. "inner_b.tga",
		},
		mask = {
			CI = path .. "mask_c.tga",
			A = {
				SQ = path .. "mask_a.tga",
				RO = path .. "mask_a.tga",
			},
			B = {
				SQ = path .. "mask_b.tga",
				RO = path .. "mask_b.tga",
			},
		},
	},
	classic = {
		texture = {
			flat = {
				SQ = path .. "sq_a_c.tga",
				RO = path .. "ro_a_c.tga",
				CI = path .. "ci_a.tga",
				CO = path .. "co_a.tga",
				EA = path .. "ex_a_a.tga",
				EB = path .. "ex_b_a.tga",
			},
			smooth = {
				SQ = path .. "sq_b_c.tga",
				RO = path .. "ro_b_c.tga",
				CI = path .. "ci_b.tga",
				CO = path .. "co_b.tga",
				EA = path .. "ex_a_b.tga",
				EB = path .. "ex_b_b.tga",
			},
			metal = {
				SQ = path .. "sq_c_c.tga",
				RO = path .. "ro_c_c.tga",
				CI = path .. "ci_c.tga",
				CO = path .. "co_c.tga",
				EA = path .. "ex_a_c.tga",
				EB = path .. "ex_b_c.tga",
			},
		},
		border = {
			SQ = path .. "border_sq.tga",
			RO = path .. "border_ro.tga",
			CI = path .. "border_ci.tga",
			CO = path .. "border_co.tga",
			EA = path .. "border_ex_a.tga",
			EB = path .. "border_ex_b.tga",
		},
		shadow = {
			SQ = path .. "shadow_sq_c.tga",
			RO = path .. "shadow_ro_c.tga",
			CI = path .. "shadow_ci.tga",
			EA = path .. "shadow_ex_a.tga",
			EB = path .. "shadow_ex_b.tga",
		},
		inner = {
			SQ = path .. "inner_b.tga",
			RO = path .. "inner_b.tga",
			CI = path .. "inner_b.tga",
		},
		mask = {
			SQ = path .. "mask_c.tga",
			RO = path .. "mask_c.tga",
			CI = path .. "mask_c.tga",
		},
	},
}
local textures = tx_DB.retail

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
	color = color or colors.default

	if general.gradient and not color.r then
		local a, b = color.a, color.b
		if mirror and (general.ori == "HORIZONTAL") then
			a, b = b, a
		end
		texture:SetGradient(general.ori, a, b)
	else
		texture:SetVertexColor(color.r, color.g, color.b, color.a)
	end
end

local function getColor(frame, unit)
	if general.default then
		return colors.default
	end
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if frame.class ~= class then
			frame.class = class
			frame.color = colors[class]
		end
		return frame.color
	else
		local reaction = UnitReaction("player", unit)
		if reaction then
			return colors[reaction <= 3 and "enemy" or reaction == 4 and "neutral" or "friendly"]
		else
			return colors.enemy
		end
	end
end

local function mirrorTexture(texture, mirror)
	texture:SetTexCoord(mirror and 1 or 0, mirror and 0 or 1, 0, 1)
end

local function CreatePortrait(parent, conf, unit)
	local texture = nil

	-- Portraits Frame
	local frame = CreateFrame("Frame", "mMT_Portrait_" .. unit, parent)
	frame:SetSize(conf.size, conf.size)
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)
	frame:SetFrameLevel(parent.Health:GetFrameLevel() + 1)

	-- Portrait Texture
	texture = textures.texture[general.style][conf.texture]
	frame.texture = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 4)
	frame.texture:SetAllPoints(frame)
	frame.texture:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
	setColor(frame.texture, getColor(frame, unit), conf.mirror)
	mirrorTexture(frame.texture, conf.mirror)

	-- Unit Portrait
	local offset = (conf.size / 5.5 * E.perfect)
	frame.portrait = frame:CreateTexture("mMT_Portrait", "OVERLAY", nil, 1)
	frame.portrait:SetPoint("TOPLEFT", offset, -offset)
	frame.portrait:SetPoint("BOTTOMRIGHT", -offset, offset)
	mirrorTexture(frame.portrait, conf.mirror)
	SetPortraitTexture(frame.portrait, unit, (E.Retail and not (conf.texture == "CI")))

	-- Portrait Mask
	texture = textures.mask[conf.texture] or conf.mirror and textures.mask.B[conf.texture] or textures.mask.A[conf.texture]
	frame.mask = frame:CreateMaskTexture()
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	frame.mask:SetAllPoints(frame.portrait)

	-- Portrait Shadow
	if shadow.enable then
		texture = textures.shadow[conf.texture]
		frame.shadow = frame:CreateTexture("mMT_Shadow", "OVERLAY", nil, -4)
		frame.shadow:SetAllPoints(frame)
		frame.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.shadow, shadow.color)
		mirrorTexture(frame.shadow, conf.mirror)
	end

	-- Inner Portrait Shadow
	if shadow.inner then
		texture = textures.inner[conf.texture]
		frame.InnerShadow = frame:CreateTexture("mMT_innerShadow", "OVERLAY", nil, 2)
		frame.InnerShadow:SetAllPoints(frame)
		frame.InnerShadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.InnerShadow, shadow.innerColor)
		mirrorTexture(frame.InnerShadow, conf.mirror)
	end

	-- Portrait Border
	if shadow.border then
		texture = textures.border[conf.texture]
		frame.border = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 6)
		frame.border:SetAllPoints(frame)
		frame.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.border, shadow.borderColor)
		mirrorTexture(frame.border, conf.mirror)
	end

	-- Rare/Elite Texture
	if unit == "target" and target.enable and conf.extraEnable then
		-- Texture
		texture = (conf.texture == "CI") and textures.texture[general.style]["EA"] or textures.texture[general.style]["EB"]
		frame.extra = frame:CreateTexture("mMT_Extra", "OVERLAY", nil, -6)
		frame.extra:SetAllPoints(frame)
		frame.extra:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(frame.extra)

		-- Shadow
		if shadow.enable then
			texture = (conf.texture == "CI") and textures.shadow.EA or textures.shadow.EB
			frame.extra.shadow = frame:CreateTexture("mMT_Extra", "OVERLAY", nil, -8)
			frame.extra.shadow:SetAllPoints(frame.extra)
			frame.extra.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.shadow, shadow.color)
			mirrorTexture(frame.extra.shadow)
			frame.extra.shadow:Hide()
		end

		-- Border
		if shadow.border then
			texture = (conf.texture == "CI") and textures.border.EA or textures.border.EB
			frame.extra.border = frame:CreateTexture("mMT_Border_Extra", "OVERLAY", nil, -4)
			frame.extra.border:SetAllPoints(frame.extra)
			frame.extra.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.border, shadow.borderColorRare)
			mirrorTexture(frame.extra.border)
			frame.extra.border:Hide()
		end

		frame.extra:Hide()
	end

	-- Corner
	if general.corner and (conf.texture ~= "CI") then
		texture = textures.texture[general.style].CO
		frame.corner = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 5)
		frame.corner:SetAllPoints(frame)
		frame.corner:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.corner, getColor(frame, unit), conf.mirror)
		mirrorTexture(frame.corner, conf.mirror)

		-- Border
		if shadow.border then
			texture = textures.border.CO
			frame.corner.border = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 6)
			frame.corner.border:SetAllPoints(frame.corner)
			frame.corner.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.corner.border, shadow.borderColor)
			mirrorTexture(frame.corner.border, conf.mirror)
		end
	end

	return frame
end

local function CheckRareElite(frame, unit)
	local c = UnitClassification(unit)
	local extra = frame.extra
	local color = colors[c]

	if color then
		setColor(extra, color)
		if shadow.enable then
			extra.shadow:Show()
		end
		if shadow.border then
			frame.extra.border:Show()
		end
		extra:Show()
	else
		if shadow.enable then
			extra.shadow:Hide()
		end
		if shadow.border then
			frame.extra.border:Hide()
		end
		extra:Hide()
	end
end

local function UpdatePortrait(frame, conf, unit, parent)
	local texture = nil

	-- Portraits Frame
	frame:SetSize(conf.size, conf.size)
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)
	frame:SetFrameLevel(parent.Health:GetFrameLevel() + 1)

	-- Portrait Texture
	texture = textures.texture[general.style][conf.texture]
	frame.texture:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
	setColor(frame.texture, getColor(frame, unit), conf.mirror)
	mirrorTexture(frame.texture, conf.mirror)

	-- Unit Portrait
	local offset = (conf.size / 5.5 * E.perfect)
	frame.portrait:SetPoint("TOPLEFT", offset, -offset)
	frame.portrait:SetPoint("BOTTOMRIGHT", -offset, offset)
	mirrorTexture(frame.portrait, conf.mirror)

	-- Portrait Mask
	texture = textures.mask[conf.texture] or conf.mirror and textures.mask.B[conf.texture] or textures.mask.A[conf.texture]
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

	-- Portrait Shadow
	if shadow.enable then
		texture = textures.shadow[conf.texture]
		frame.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.shadow, shadow.color)
		mirrorTexture(frame.shadow, conf.mirror)
	end

	-- Inner Portrait Shadow
	if shadow.inner then
		texture = textures.inner[conf.texture]
		frame.InnerShadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.InnerShadow, shadow.innerColor)
		mirrorTexture(frame.InnerShadow, conf.mirror)
	end

	-- Portrait Border
	if shadow.border then
		texture = textures.border[conf.texture]
		frame.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.border, shadow.borderColor)
		mirrorTexture(frame.border, conf.mirror)
	end

	-- Rare/Elite Texture
	if unit == "target" and conf.extraEnable then
		-- Texture
		texture = (conf.texture == "CI") and textures.texture[general.style]["EA"] or textures.texture[general.style]["EB"]
		frame.extra:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(frame.extra, not conf.mirror)

		-- Shadow
		if shadow.enable then
			texture = (conf.texture == "CI") and textures.shadow.EA or textures.shadow.EB
			frame.extra.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.shadow, shadow.color)
			mirrorTexture(frame.extra.shadow, not conf.mirror)
		end

		-- Border
		if shadow.border then
			texture = (conf.texture == "CI") and textures.border.EA or textures.border.EB
			frame.extra.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.border, shadow.borderColorRare)
			mirrorTexture(frame.extra.border, conf.mirror)
		end

		CheckRareElite(frame, unit)
	end

	-- Corner
	if general.corner and (conf.texture ~= "CI") then
		texture = textures.texture[general.style].CO
		frame.corner:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.corner, getColor(frame, unit), conf.mirror)
		mirrorTexture(frame.corner, conf.mirror)

		-- Border
		if shadow.border then
			texture = textures.border.CO
			frame.corner.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.corner.border, shadow.borderColor)
			mirrorTexture(frame.corner.border, conf.mirror)
		end
	end
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
	textures = E.Retail and tx_DB.retail or tx_DB.classic
	if not mMT.Portraits then
		mMT.Portraits = {}
	end

	if player.enable and not mMT.Portraits.Player then
		mMT.Portraits.Player = CreatePortrait(_G.ElvUF_Player, player, "player")
		mMT.Portraits.Player:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "player")
		mMT.Portraits.Player:RegisterEvent("PLAYER_ENTERING_WORLD")
		mMT.Portraits.Player:SetScript("OnEvent", function(self, event)
			SetPortraitTexture(self.portrait, "player", (E.Retail and not (player.texture == "CI")))
			setColor(self.texture, getColor(self, "player"), player.mirror)
			if general.corner and (player.texture ~= "CI") then
				setColor(self.corner, getColor(self, "player"), player.mirror)
			end
		end)
	end

	if target.enable and not mMT.Portraits.Target then
		mMT.Portraits.Target = CreatePortrait(_G.ElvUF_Target, target, "target")
		mMT.Portraits.Target:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "target")
		mMT.Portraits.Target:RegisterEvent("PLAYER_TARGET_CHANGED")
		mMT.Portraits.Target:RegisterEvent("PLAYER_ENTERING_WORLD")
		mMT.Portraits.Target:SetScript("OnEvent", function(self, event)
			SetPortraitTexture(self.portrait, "target", (E.Retail and not (target.texture == "CI")))
			setColor(self.texture, getColor(self, "target"), target.mirror)
			if general.corner and (target.texture ~= "CI") then
				setColor(self.corner, getColor(self, "target"), target.mirror)
			end
			if target.extraEnable then
				CheckRareElite(self, "target")
			else
				self.extra:Hide()
			end
		end)
	end

	--self:RegisterEvent('UNIT_MODEL_CHANGED', Path)
	--self:RegisterEvent('UNIT_PORTRAIT_UPDATE', Path)
	--self:RegisterEvent('PORTRAITS_UPDATED', Path, true)
	--self:RegisterEvent('UNIT_CONNECTION', Path)
	--self:RegisterEvent('PARTY_MEMBER_ENABLE', Path)

	if party.enable then
		for i = 1, 5 do
			local portrait = "Party" .. i
			local frame = _G["ElvUF_PartyGroup1UnitButton" .. i]
			if not mMT.Portraits[portrait] then
				mMT.Portraits[portrait] = CreatePortrait(frame, party, frame.unit)
				mMT.Portraits[portrait]:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", frame.unit)
				mMT.Portraits[portrait]:RegisterEvent("PLAYER_ENTERING_WORLD")
				mMT.Portraits[portrait]:RegisterEvent("GROUP_ROSTER_UPDATE")
				mMT.Portraits[portrait]:RegisterEvent("UNIT_CONNECTION")
				mMT.Portraits[portrait]:SetScript("OnEvent", function(self, event)
					mMT:Print(event)
					SetPortraitTexture(self.portrait, frame.unit, (E.Retail and not (party.texture == "CI")))
					setColor(self.texture, getColor(self, frame.unit), party.mirror)
				end)
			end
		end
	end
end
