local E = unpack(ElvUI)

local _G = _G
local SetPortraitTexture = SetPortraitTexture
local UnitExists = UnitExists
local tinsert = tinsert

local module = mMT.Modules.Portraits
if not module then
	return
end

local colors = {}
local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\"
local textures = {
	texture = {
		flat = {
			SQ = path .. "sq_a.tga",
			RO = path .. "ro_a.tga",
			CI = path .. "ci_a.tga",
			CO = path .. "co_a.tga",
			PI = path .. "pi_a.tga",
			RA = path .. "ra_a.tga",
			QA = path .. "qa_a.tga",
			SMQ = path .. "qa_a.tga",
			MO = path .. "moon_c.tga",
			TH = path .. "th_a.tga",
		},
		smooth = {
			SQ = path .. "sq_b.tga",
			RO = path .. "ro_b.tga",
			CI = path .. "ci_b.tga",
			CO = path .. "co_b.tga",
			PI = path .. "pi_b.tga",
			RA = path .. "ra_b.tga",
			QA = path .. "qa_b.tga",
			SMQ = path .. "qa_b.tga",
			MO = path .. "moon_a.tga",
			TH = path .. "th_b.tga",
		},
		metal = {
			SQ = path .. "sq_c.tga",
			RO = path .. "ro_c.tga",
			CI = path .. "ci_c.tga",
			CO = path .. "co_c.tga",
			PI = path .. "pi_c.tga",
			RA = path .. "ra_c.tga",
			QA = path .. "qa_c.tga",
			SMQ = path .. "qa_c.tga",
			MO = path .. "moon_b.tga",
			TH = path .. "th_c.tga",
		},
	},
	extra = {
		flat = {
			CI = path .. "ex_a_a.tga",
			SQ = path .. "ex_b_a.tga",
			RO = path .. "ex_b_a.tga",
			PI = path .. "ex_pi_a.tga",
			RA = path .. "ex_ra_a.tga",
			QA = path .. "ex_qa_a.tga",
			SMQ = path .. "ex_qa_a.tga",
			MO = path .. "ex_mo_c.tga",
			TH = path .. "ex_th_a.tga",
		},
		smooth = {
			CI = path .. "ex_a_b.tga",
			SQ = path .. "ex_b_b.tga",
			RO = path .. "ex_b_b.tga",
			PI = path .. "ex_pi_b.tga",
			RA = path .. "ex_ra_b.tga",
			QA = path .. "ex_qa_b.tga",
			SMQ = path .. "ex_qa_b.tga",
			MO = path .. "ex_mo_a.tga",
			TH = path .. "ex_th_b.tga",
		},
		metal = {
			CI = path .. "ex_a_c.tga",
			SQ = path .. "ex_b_c.tga",
			RO = path .. "ex_b_c.tga",
			PI = path .. "ex_pi_c.tga",
			RA = path .. "ex_ra_c.tga",
			QA = path .. "ex_qa_c.tga",
			SMQ = path .. "ex_qa_c.tga",
			MO = path .. "ex_mo_b.tga",
			TH = path .. "ex_th_c.tga",
		},
		border = {
			CI = path .. "border_ex_a.tga",
			SQ = path .. "border_ex_b.tga",
			RO = path .. "border_ex_b.tga",
			PI = path .. "border_ex_pi.tga",
			RA = path .. "border_ex_ra.tga",
			QA = path .. "border_ex_qa.tga",
			SMQ = path .. "border_ex_qa.tga",
			MO = path .. "border_ex_moon.tga",
			TH = path .. "border_ex_th.tga",
		},
		shadow = {
			CI = path .. "shadow_ex_a.tga",
			SQ = path .. "shadow_ex_b.tga",
			RO = path .. "shadow_ex_b.tga",
			PI = path .. "shadow_ex_pi.tga",
			RA = path .. "shadow_ex_ra.tga",
			QA = path .. "shadow_ex_qa.tga",
			SMQ = path .. "shadow_ex_qa.tga",
			MO = nil,
			TH = path .. "shadow_ex_th.tga",
		},
	},
	border = {
		SQ = path .. "border_sq.tga",
		RO = path .. "border_ro.tga",
		CI = path .. "border_ci.tga",
		CO = path .. "border_co.tga",
		PI = path .. "border_pi.tga",
		RA = path .. "border_ra.tga",
		QA = path .. "border_qa.tga",
		SMQ = path .. "border_qa.tga",
		MO = path .. "border_moon.tga",
		TH = path .. "border_th.tga",
	},
	shadow = {
		SQ = path .. "shadow_sq.tga",
		RO = path .. "shadow_ro.tga",
		CI = path .. "shadow_ci.tga",
		PI = path .. "shadow_pi.tga",
		RA = path .. "shadow_ra.tga",
		QA = path .. "shadow_qa.tga",
		SMQ = path .. "shadow_qa.tga",
		MO = path .. "shadow_moon.tga",
		TH = path .. "shadow_th.tga",
	},
	inner = {
		SQ = path .. "inner_a.tga",
		RO = path .. "inner_a.tga",
		CI = path .. "inner_b.tga",
		PI = path .. "inner_pi.tga",
		RA = path .. "inner_ra.tga",
		QA = path .. "inner_qa.tga",
		SMQ = path .. "inner_qa.tga",
		MO = path .. "inner_b.tga",
		TH = path .. "inner_th.tga",
	},
	mask = {
		CI = path .. "mask_c.tga",
		PI = path .. "mask_pi.tga",
		RA = path .. "mask_d.tga",
		QA = path .. "mask_qa.tga",
		MO = path .. "mask_c.tga",
		SMQ = path .. "mask_qa.tga",
		TH = path .. "mask_th.tga",

		A = {
			SQ = path .. "mask_a.tga",
			RO = path .. "mask_a.tga",
			SQT = path .. "mask_a2.tga",
			ROT = path .. "mask_a2.tga",
		},
		B = {
			SQ = path .. "mask_b.tga",
			RO = path .. "mask_b.tga",
			SQT = path .. "mask_b2.tga",
			ROT = path .. "mask_b2.tga",
		},
	},
	corner = {
		SQ = true,
		RO = true,
		CI = false,
		PI = false,
		RA = false,
		QA = false,
		MO = false,
		SMQ = false,
		TH = false,
	},
	background = {
		[1] = path .. "bg_1.tga",
		[2] = path .. "bg_2.tga",
		[3] = path .. "bg_3.tga",
		[4] = path .. "bg_4.tga",
		[5] = path .. "bg_5.tga",
	},
	enablemasking = {
		SQ = true,
		RO = true,
		CI = false,
		PI = true,
		RA = true,
		QA = false,
		MO = false,
		SMQ = false,
		TH = true,
	},
	custom = {
		texture = "",
		extra = "",
		extraborder = "",
		extrashadow = "",
		border = "",
		shadow = "",
		inner = "",
		mask = "",
		enable = false,
	},
}

local function mirrorTexture(texture, mirror, top)
	if texture.mClass then
		local coords = texture.mCoords
		if #coords == 8 then
			texture:SetTexCoord(unpack(mirror and { coords[3], coords[4], coords[7], coords[8], coords[1], coords[2], coords[5], coords[6] } or coords))
		else
			texture:SetTexCoord(unpack(mirror and { coords[2], coords[1], coords[3], coords[4] } or coords))
		end
	else
		texture:SetTexCoord(mirror and 1 or 0, mirror and 0 or 1, top and 1 or 0, top and 0 or 1)
	end
end

local function setColor(texture, color, mirror)
	if not texture or not color or not color.a or not color.b then
		return
	end

	if type(color.a) == "table" and type(color.b) == "table" then
		if E.db.mMT.portraits.general.gradient then
			local a, b = color.a, color.b
			if mirror and (E.db.mMT.portraits.general.ori == "HORIZONTAL") then
				a, b = b, a
			end
			texture:SetGradient(E.db.mMT.portraits.general.ori, a, b)
		else
			texture:SetVertexColor(color.a.r, color.a.g, color.a.b, color.a.a)
		end
	elseif color.r then
		texture:SetVertexColor(color.r, color.g, color.b, color.a)
	else
		mMT:Print("Error! - Portraits Color > ")
		mMT:DebugPrintTable(color)
	end
end

local cachedFaction = {}

local function getColor(unit)
	local defaultColor = colors.default

	if E.db.mMT.portraits.general.default then
		return defaultColor
	end

	if UnitIsPlayer(unit) or (E.Retail and UnitInPartyIsAI(unit)) then
		if E.db.mMT.portraits.general.reaction then
			local playerFaction = cachedFaction.player or select(1, UnitFactionGroup("player"))
			cachedFaction.player = playerFaction
			local unitFaction = cachedFaction[UnitGUID(unit)] or select(1, UnitFactionGroup(unit))
			cachedFaction[UnitGUID(unit)] = unitFaction

			return colors[(playerFaction == unitFaction) and "friendly" or "enemy"]
		else
			local _, class = UnitClass(unit)
			return colors[class]
		end
	else
		local reaction = UnitReaction(unit, "player")
		return colors[reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly") or "enemy"]
	end
end

local function adjustColor(color, shift)
	return {
		r = color.r - shift,
		g = color.g - shift,
		b = color.b - shift,
		a = color.a,
	}
end

local function UpdateIconBackground(tx, unit, mirror)
	tx:SetTexture(textures.background[E.db.mMT.portraits.general.bgstyle], "CLAMP", "CLAMP", "TRILINEAR")

	local color = E.db.mMT.portraits.shadow.classBG and getColor(unit) or E.db.mMT.portraits.shadow.background
	local bgColor = { r = 1, g = 1, b = 1, a = 1 }
	local ColorShift = E.db.mMT.portraits.shadow.bgColorShift

	if not color.r then
		bgColor.a = adjustColor(color.a, ColorShift)
		bgColor.b = adjustColor(color.b, ColorShift)
	else
		bgColor = adjustColor(color, ColorShift)
	end

	setColor(tx, bgColor, mirror)
end

local function SetPortraits(frame, unit, masking, mirror)
	if E.db.mMT.portraits.general.classicons and UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		local coords = CLASS_ICON_TCOORDS[class]
		local style = E.db.mMT.portraits.general.classiconstyle

		if mMT.ElvUI_JiberishIcons.loaded and style ~= "BLIZZARD" then
			coords = class and mMT.ElvUI_JiberishIcons.texCoords[class]
			frame.portrait:SetTexture(mMT.ElvUI_JiberishIcons.path .. style)
		else
			frame.portrait:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		end

		if frame.iconbg then
			UpdateIconBackground(frame.iconbg, unit, mirror)
		end

		frame.portrait.mClass = unit
		frame.portrait.mCoords = coords

		if coords then
			mirrorTexture(frame.portrait, mirror)
		end
	else
		if frame.portrait.mClass then
			frame.portrait.mClass = nil
			frame.portrait.mCoords = nil
		end

		mirrorTexture(frame.portrait, mirror)
		SetPortraitTexture(frame.portrait, unit, masking)
	end
end

local function CreatePortraitTexture(frame, name, layer, texture, color, mirror, top)
	local tmpTexture = frame:CreateTexture(name, "OVERLAY", nil, layer)
	tmpTexture:SetAllPoints(frame)
	tmpTexture:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
	mirrorTexture(tmpTexture, mirror, top)

	if color then
		setColor(tmpTexture, color, mirror)
	end

	return tmpTexture
end

local function CreateIconBackground(frame, unit, mirror, flippe)
	local tmpTexture = frame:CreateTexture("mMT_Background", "OVERLAY", nil, -5)
	tmpTexture:SetAllPoints(frame)
	tmpTexture:SetTexture(textures.background[E.db.mMT.portraits.general.bgstyle], "CLAMP", "CLAMP", "TRILINEAR")

	local color = flippe and { r = 0, g = 0, b = 0, a = 1 } or (E.db.mMT.portraits.shadow.classBG and getColor(unit) or E.db.mMT.portraits.shadow.background)
	setColor(tmpTexture, color, mirror)

	return tmpTexture
end

local function GetOffset(size, offset)
	if offset == 0 or not offset then
		return 0
	else
		return ((size / offset) * E.perfect)
	end
end

local function CreatePortrait(parent, conf, unit)
	if mMT.DevMode then
		mMT:Print("Create Function", "Unit:", unit, "Exists", UnitExists(unit), "Parent Unit:", parent and parent.unit or "Error", "Parent Exists:", parent and UnitExists(parent.unit) or "Error")
	end
	mMT:Print(parent, conf, unit, conf.size)

	local texture = nil

	-- Portraits Frame
	local frame = CreateFrame("Button", "mMT_Portrait_" .. unit, parent, "SecureUnitButtonTemplate")
	frame:SetSize(conf.size, conf.size)
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)
	if conf.strata ~= "AUTO" then
		frame:SetFrameStrata(conf.strata)
	end
	frame:SetFrameLevel(conf.level)

	-- Portrait Texture
	unit = UnitExists(unit) and unit or "player"
	texture = textures.custom.enable and textures.custom.texture or textures.texture[E.db.mMT.portraits.general.style][conf.texture]
	frame.texture = CreatePortraitTexture(frame, "mMT_Texture", 4, texture, getColor(unit), conf.mirror, conf.flippe)

	-- Unit Portrait
	local offset = GetOffset(conf.size, textures.custom.enable and E.db.mMT.portraits.offset.CUSTOM or E.db.mMT.portraits.offset[conf.texture])
	frame.portrait = frame:CreateTexture("mMT_Portrait", "OVERLAY", nil, 1)
	frame.portrait:SetAllPoints(frame)
	frame.portrait:SetPoint("TOPLEFT", 0 + offset, 0 - offset)
	frame.portrait:SetPoint("BOTTOMRIGHT", 0 - offset, 0 + offset)
	frame.portrait:SetTexture(path .. "unknown.tga", "CLAMP", "CLAMP", "TRILINEAR")
	SetPortraits(frame, unit, (textures.enablemasking[conf.texture] and not conf.flippe), conf.mirror)
	mirrorTexture(frame.portrait, conf.mirror)

	-- Portrait Mask
	texture = textures.custom.enable and (conf.mirror and textures.custom.maskb or textures.custom.mask) or (textures.mask[conf.texture] or conf.mirror and textures.mask.B[conf.flippe and conf.texture .. "T" or conf.texture] or textures.mask.A[conf.flippe and conf.texture .. "T" or conf.texture])
	frame.mask = frame:CreateMaskTexture()
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	frame.mask:SetAllPoints(frame)
	frame.portrait:AddMaskTexture(frame.mask)

	-- Class Icon Background
	if E.db.mMT.portraits.general.classicons or conf.flippe then
		frame.iconbg = CreateIconBackground(frame, unit, conf.mirror, (conf.flippe and not E.db.mMT.portraits.general.classicons))
		frame.iconbg:AddMaskTexture(frame.mask)
	end

	-- Portrait Shadow
	if E.db.mMT.portraits.shadow.enable then
		texture = textures.custom.enable and textures.custom.shadow or textures.shadow[conf.texture]
		frame.shadow = CreatePortraitTexture(frame, "mMT_Shadow", -4, texture, E.db.mMT.portraits.shadow.color, conf.mirror, conf.flippe)
	end

	-- Inner Portrait Shadow
	if E.db.mMT.portraits.shadow.inner then
		texture = textures.custom.enable and textures.custom.inner or textures.inner[conf.texture]
		frame.InnerShadow = CreatePortraitTexture(frame, "mMT_innerShadow", 2, texture, E.db.mMT.portraits.shadow.innerColor, conf.mirror, conf.flippe)
	end

	-- Portrait Border
	if E.db.mMT.portraits.shadow.border then
		texture = textures.custom.enable and textures.custom.border or textures.border[conf.texture]
		frame.border = CreatePortraitTexture(frame, "mMT_Border", 2, texture, E.db.mMT.portraits.shadow.borderColor, conf.mirror, conf.flippe)
	end

	-- Rare/Elite Texture
	if conf.extraEnable then
		-- Texture
		texture = textures.custom.enable and textures.custom.extra or textures.extra[E.db.mMT.portraits.general.style][conf.texture]
		frame.extra = CreatePortraitTexture(frame, "mMT_Extra", -6, texture, nil, not conf.mirror, conf.flippe)

		-- Shadow
		if E.db.mMT.portraits.shadow.enable then
			texture = textures.custom.enable and textures.custom.extrashadow or textures.extra.border[conf.texture]
			frame.extra.shadow = CreatePortraitTexture(frame, "mMT_Extra_Shadow", -8, texture, E.db.mMT.portraits.shadow.color, not conf.mirror, conf.flippe)
			frame.extra.shadow:Hide()
		end

		-- Border
		if E.db.mMT.portraits.shadow.border then
			texture = textures.custom.enable and textures.custom.extraborder or textures.extra.shadow[conf.texture]
			frame.extra.border = CreatePortraitTexture(frame, "mMT_Extra_Border", -4, texture, E.db.mMT.portraits.shadow.borderColorRare, not conf.mirror, conf.flippe)
			frame.extra.border:Hide()
		end

		frame.extra:Hide()
	end

	-- Corner
	if ((not textures.custom.enable) and E.db.mMT.portraits.general.corner) and textures.corner[conf.texture] then
		texture = textures.texture[E.db.mMT.portraits.general.style].CO
		frame.corner = CreatePortraitTexture(frame, "mMT_Corner", 5, texture, getColor(unit), conf.mirror, conf.flippe)

		-- Border
		if E.db.mMT.portraits.shadow.border then
			texture = textures.border.CO
			frame.corner.border = CreatePortraitTexture(frame, "mMT_Corner_Border", 6, texture, E.db.mMT.portraits.shadow.borderColor, conf.mirror, conf.flippe)
		end
	end

	return frame
end

local function CheckRareElite(frame, unit)
	local c = UnitClassification(unit)
	local color = colors[c]

	if color then
		setColor(frame.extra, color)
		if E.db.mMT.portraits.shadow.enable and frame.extra.shadow then
			frame.extra.shadow:Show()
		end
		if E.db.mMT.portraits.shadow.border and frame.extra.border then
			frame.extra.border:Show()
		end
		frame.extra:Show()
	else
		if E.db.mMT.portraits.shadow.enable and frame.extra.shadow then
			frame.extra.shadow:Hide()
		end
		if E.db.mMT.portraits.shadow.border and frame.extra.border then
			frame.extra.border:Hide()
		end
		frame.extra:Hide()
	end
end

local function UpdatePortraitTexture(tx, texture, color, mirror, top)
	if tx then
		tx:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(tx, mirror, top)

		if color then
			setColor(tx, color, mirror)
		end
	end
end

local function UpdatePortrait(frame, conf, unit, parent)
	if mMT.DevMode then
		mMT:Print("Create Update", "Unit:", unit, "Exists", UnitExists(unit), "Parent Unit:", parent.unit, "Parent Exists:", UnitExists(parent.unit))
	end

	local texture = nil
	unit = UnitExists(unit) and unit or "player"

	-- Portraits Frame
	if not InCombatLockdown() then
		frame:SetSize(conf.size, conf.size)
		frame:ClearAllPoints()
		frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)

		if conf.strata ~= "AUTO" then
			frame:SetFrameStrata(conf.strata)
		end
		frame:SetFrameLevel(conf.level)
	end

	-- Portrait Texture
	texture = textures.custom.enable and textures.custom.texture or textures.texture[E.db.mMT.portraits.general.style][conf.texture]
	UpdatePortraitTexture(frame.texture, texture, getColor(unit), conf.mirror, conf.flippe)

	-- Unit Portrait
	local offset = GetOffset(conf.size, textures.custom.enable and E.db.mMT.portraits.offset.CUSTOM or E.db.mMT.portraits.offset[conf.texture])
	frame.portrait:SetPoint("TOPLEFT", 0 + offset, 0 - offset)
	frame.portrait:SetPoint("BOTTOMRIGHT", 0 - offset, 0 + offset)

	-- Portrait Mask
	texture = textures.custom.enable and (conf.mirror and textures.custom.maskb or textures.custom.mask) or (textures.mask[conf.texture] or conf.mirror and textures.mask.B[conf.flippe and conf.texture .. "T" or conf.texture] or textures.mask.A[conf.flippe and conf.texture .. "T" or conf.texture])
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

	-- Portrait Shadow
	if E.db.mMT.portraits.shadow.enable then
		texture = textures.custom.enable and textures.custom.shadow or textures.shadow[conf.texture]
		if frame.shadow then
			UpdatePortraitTexture(frame.shadow, texture, E.db.mMT.portraits.shadow.color, conf.mirror, conf.flippe)
			frame.shadow:Show()
		else
			frame.shadow = CreatePortraitTexture(frame, "mMT_Shadow", -4, texture, E.db.mMT.portraits.shadow.color, conf.mirror, conf.flippe)
		end
	elseif not E.db.mMT.portraits.shadow.enable and frame.shadow then
		frame.shadow:Hide()
	end

	-- Inner Portrait Shadow
	if E.db.mMT.portraits.shadow.inner then
		texture = textures.custom.enable and textures.custom.inner or textures.inner[conf.texture]
		if frame.InnerShadow then
			UpdatePortraitTexture(frame.InnerShadow, texture, E.db.mMT.portraits.shadow.innerColor, conf.mirror, conf.flippe)
			frame.InnerShadow:Show()
		else
			frame.InnerShadow = CreatePortraitTexture(frame, "mMT_innerShadow", 2, texture, E.db.mMT.portraits.shadow.innerColor, conf.mirror, conf.flippe)
		end
	elseif not E.db.mMT.portraits.shadow.inner and frame.InnerShadow then
		frame.InnerShadow:Hide()
	end

	-- Portrait Border
	if E.db.mMT.portraits.shadow.border then
		texture = textures.custom.enable and textures.custom.border or textures.border[conf.texture]
		if frame.border then
			UpdatePortraitTexture(frame.border, texture, E.db.mMT.portraits.shadow.borderColor, conf.mirror, conf.flippe)
			frame.border:Show()
		else
			frame.border = CreatePortraitTexture(frame, "mMT_Border", 2, texture, E.db.mMT.portraits.shadow.borderColor, conf.mirror, conf.flippe)
		end
	elseif not E.db.mMT.portraits.shadow.border and frame.border then
		frame.border:Hide()
	end

	-- Class Icon Background
	if E.db.mMT.portraits.general.classicons or conf.flippe then
		if frame.iconbg then
			UpdateIconBackground(frame.iconbg, unit, conf.mirror)
			if E.db.mMT.portraits.shadow.enable then
				frame.shadow:Show()
			end
		else
			frame.iconbg = CreateIconBackground(frame, unit, conf.mirror, (conf.flippe and not E.db.mMT.portraits.general.classicons))
			frame.iconbg:AddMaskTexture(frame.mask)
		end
	elseif frame.iconbg and not E.db.mMT.portraits.general.classicons then
		frame.iconbg:Hide()
	end

	-- Rare/Elite Texture
	if conf.extraEnable then
		-- Texture
		texture = textures.custom.enable and textures.custom.extra or textures.extra[E.db.mMT.portraits.general.style][conf.texture]
		if frame.extra then
			UpdatePortraitTexture(frame.extra, texture, nil, not conf.mirror, conf.flippe)
		else
			frame.extra = CreatePortraitTexture(frame, "mMT_Extra", -6, texture, nil, not conf.mirror, conf.flippe)
		end

		-- Shadow
		if E.db.mMT.portraits.shadow.enable then
			texture = textures.custom.enable and textures.custom.extrashadow or textures.extra.shadow[conf.texture]
			if frame.extra.shadow then
				UpdatePortraitTexture(frame.extra.shadow, texture, E.db.mMT.portraits.shadow.color, not conf.mirror, conf.flippe)
			else
				frame.extra.shadow = CreatePortraitTexture(frame, "mMT_Extra_Shadow", -8, texture, E.db.mMT.portraits.shadow.color, not conf.mirror, conf.flippe)
				frame.extra.shadow:Hide()
			end
		elseif not E.db.mMT.portraits.shadow.enable and frame.extra.shadow then
			frame.extra.shadow:Hide()
		end

		-- Border
		if E.db.mMT.portraits.shadow.border then
			texture = textures.custom.enable and textures.custom.extraborder or textures.extra.border[conf.texture]
			if frame.extra.border then
				UpdatePortraitTexture(frame.extra.border, texture, E.db.mMT.portraits.shadow.borderColorRare, not conf.mirror, conf.flippe)
			else
				frame.extra.border = CreatePortraitTexture(frame, "mMT_Extra_Border", -4, texture, E.db.mMT.portraits.shadow.borderColorRare, not conf.mirror, conf.flippe)
				frame.extra.border:Hide()
			end
		elseif not E.db.mMT.portraits.shadow.border and frame.extra.border then
			frame.extra.border:Hide()
		end

		CheckRareElite(frame, unit)
	elseif not conf.extraEnable and frame.extra then
		if frame.extra.shadow then
			frame.extra.shadow:Hide()
		end

		if frame.extra.border then
			frame.extra.border:Hide()
		end

		frame.extra:Hide()
	end

	-- Corner
	if ((not textures.custom.enable) and E.db.mMT.portraits.general.corner) and textures.corner[conf.texture] then
		texture = textures.texture[E.db.mMT.portraits.general.style].CO
		if frame.corner then
			UpdatePortraitTexture(frame.corner, texture, getColor(unit), conf.mirror, conf.flippe)
			frame.corner:Show()
		else
			frame.corner = CreatePortraitTexture(frame, "mMT_Corner", 5, texture, getColor(unit), conf.mirror, conf.flippe)
		end

		-- Border
		if E.db.mMT.portraits.shadow.border then
			texture = textures.border.CO
			if frame.corner.border then
				UpdatePortraitTexture(frame.corner.border, texture, E.db.mMT.portraits.shadow.borderColor, conf.mirror, conf.flippe)
				frame.corner.border:Show()
			else
				frame.corner.border = CreatePortraitTexture(frame, "mMT_Corner_Border", 6, texture, E.db.mMT.portraits.shadow.borderColor, conf.mirror, conf.flippe)
			end
		elseif frame.corner.border then
			frame.corner.border:Hide()
		end
	elseif frame.corner then
		if frame.corner.border then
			frame.corner.border:Hide()
		end

		frame.corner:Hide()
	end
end

function module:UpdatePortraits()
	if module.Player then
		UpdatePortrait(module.Player, E.db.mMT.portraits.player, "player", _G.ElvUF_Player)
	end

	if module.Target then
		UpdatePortrait(module.Target, E.db.mMT.portraits.target, "target", _G.ElvUF_Target)
	end

	if module.Pet then
		UpdatePortrait(module.Pet, E.db.mMT.portraits.pet, "pet", _G.ElvUF_Pet)
	end

	if module.Focus then
		UpdatePortrait(module.Focus, E.db.mMT.portraits.focus, "focus", _G.ElvUF_Focus)
	end

	if module.TargetTarget then
		UpdatePortrait(module.TargetTarget, E.db.mMT.portraits.targettarget, "targettarget", _G.ElvUF_TargetTarget)
	end

	if module.Party1 then
		UpdatePortrait(module.Party1, E.db.mMT.portraits.party, _G.ElvUF_PartyGroup1UnitButton1.unit, _G.ElvUF_PartyGroup1UnitButton1)
		UpdatePortrait(module.Party2, E.db.mMT.portraits.party, _G.ElvUF_PartyGroup1UnitButton2.unit, _G.ElvUF_PartyGroup1UnitButton2)
		UpdatePortrait(module.Party3, E.db.mMT.portraits.party, _G.ElvUF_PartyGroup1UnitButton3.unit, _G.ElvUF_PartyGroup1UnitButton3)
		UpdatePortrait(module.Party4, E.db.mMT.portraits.party, _G.ElvUF_PartyGroup1UnitButton4.unit, _G.ElvUF_PartyGroup1UnitButton4)
		UpdatePortrait(module.Party5, E.db.mMT.portraits.party, _G.ElvUF_PartyGroup1UnitButton5.unit, _G.ElvUF_PartyGroup1UnitButton5)
	end

	if module.Arena1 then
		UpdatePortrait(module.Arena1, E.db.mMT.portraits.arena, _G.ElvUF_Arena1.unit, _G.ElvUF_Arena1)
		UpdatePortrait(module.Arena2, E.db.mMT.portraits.arena, _G.ElvUF_Arena2.unit, _G.ElvUF_Arena2)
		UpdatePortrait(module.Arena3, E.db.mMT.portraits.arena, _G.ElvUF_Arena3.unit, _G.ElvUF_Arena3)
		UpdatePortrait(module.Arena4, E.db.mMT.portraits.arena, _G.ElvUF_Arena4.unit, _G.ElvUF_Arena4)
		UpdatePortrait(module.Arena5, E.db.mMT.portraits.arena, _G.ElvUF_Arena5.unit, _G.ElvUF_Arena5)
	end

	if module.Boss1 then
		UpdatePortrait(module.Boss1, E.db.mMT.portraits.boss, _G.ElvUF_Boss1.unit, _G.ElvUF_Boss1)
		UpdatePortrait(module.Boss2, E.db.mMT.portraits.boss, _G.ElvUF_Boss2.unit, _G.ElvUF_Boss2)
		UpdatePortrait(module.Boss3, E.db.mMT.portraits.boss, _G.ElvUF_Boss3.unit, _G.ElvUF_Boss3)
		UpdatePortrait(module.Boss4, E.db.mMT.portraits.boss, _G.ElvUF_Boss4.unit, _G.ElvUF_Boss4)
		UpdatePortrait(module.Boss5, E.db.mMT.portraits.boss, _G.ElvUF_Boss5.unit, _G.ElvUF_Boss5)
		UpdatePortrait(module.Boss6, E.db.mMT.portraits.boss, _G.ElvUF_Boss6.unit, _G.ElvUF_Boss6)
		UpdatePortrait(module.Boss7, E.db.mMT.portraits.boss, _G.ElvUF_Boss7.unit, _G.ElvUF_Boss7)
		UpdatePortrait(module.Boss8, E.db.mMT.portraits.boss, _G.ElvUF_Boss8.unit, _G.ElvUF_Boss8)
	end
end

local function AddCastIcon(self, unit, mirror)
	local texture = select(3, UnitCastingInfo(unit))

	self.throttle = texture and true or false

	if not texture then
		texture = select(3, UnitChannelInfo(unit))
	end

	if texture then
		self.portrait:SetTexture(texture)
		if self.portrait.mClass then
			self.portrait.mClass = nil
			self.portrait.mCoords = nil
		end

		mirrorTexture(self.portrait, mirror)
	end
end

local function RemovePortrait(name)
	for _, event in pairs(module[name].unitEvents) do
		module[name]:UnregisterEvent(event)
	end

	for _, event in pairs(module[name].events) do
		module[name]:UnregisterEvent(event)
	end

	module[name]:Hide()
	module[name] = nil
end

local function CastEvents(db, name, remove)
	local castEvents = {
		"UNIT_SPELLCAST_START",
		"UNIT_SPELLCAST_CHANNEL_START",
		"UNIT_SPELLCAST_INTERRUPTED",
		"UNIT_SPELLCAST_SUCCEEDED",
		"UNIT_SPELLCAST_STOP",
	}

	local castEventsRetail = {
		"UNIT_SPELLCAST_EMPOWER_START",
		"UNIT_SPELLCAST_EMPOWER_STOP",
	}

	if remove and module[name] then
		for _, event in pairs(castEvents) do
			module[name]:UnregisterEvent(event)
		end

		if E.Retail then
			for _, event in pairs(castEventsRetail) do
				module[name]:UnregisterEvent(event)
			end
		end
	else
		for _, event in pairs(castEvents) do
			tinsert(db[name].events, event)
		end

		if E.Retail then
			for _, event in pairs(castEventsRetail) do
				tinsert(db[name].unitEvents, event)
			end
		end
	end
end

local throttleEvents = {
	UNIT_SPELLCAST_INTERRUPTED = true,
	UNIT_SPELLCAST_SUCCEEDED = true,
}

local castIconUpdateEvents = {
	UNIT_SPELLCAST_START = true,
	UNIT_SPELLCAST_EMPOWER_START = true,
}

local function UnitEvent(self, event, castUnit)
	if mMT.DevMode then
		mMT:Print("Script:", self.unit, "Event:", event, "Unit Exists:", UnitExists(self.unit))
	end

	local unit = self.unit

	if self.settings.cast then
		self.empowering = (event == "UNIT_SPELLCAST_EMPOWER_START")
	end

	if self.settings.cast and (castUnit == unit) and castIconUpdateEvents[event] then
		AddCastIcon(self, unit, self.settings.mirror)
	else
		if self.settings.cast and throttleEvents[event] then
			if (not self.throttle) or self.empowering then
				return
			end

			self.throttle = false
			self.empowering = false

			SetPortraits(self, unit, (textures.enablemasking[self.settings.texture] and not self.settings.flippe), self.settings.mirror)
		end

		if self.update[event] then
			if UnitExists(unit) then
				if not InCombatLockdown() then
					if self:GetAttribute("unit") ~= unit then
						self:SetAttribute("unit", unit)
					end
				end

				SetPortraits(self, unit, (textures.enablemasking[self.settings.texture] and not self.settings.flippe), self.settings.mirror)
				setColor(self.texture, getColor(unit), self.settings.mirror)

				if E.db.mMT.portraits.general.corner and textures.corner[self.settings.texture] then
					setColor(self.corner, getColor(unit), self.settings.mirror)
				end

				if self.settings.extraEnable and self.extra then
					CheckRareElite(self, unit)
				elseif self.extra then
					self.extra:Hide()
				end
			else
				SetPortraits(self, "player", not (textures.enablemasking[self.settings.texture] and not self.settings.flippe), self.settings.mirror)
			end
		end
	end
end

local function SetCustomTextures()
	local textureFields = { "texture", "extra", "extraborder", "extrashadow", "border", "shadow", "inner", "mask", "maskb" }
	if E.db.mMT.portraits.custom.enable then
		textures.custom.enable = true
		for _, field in ipairs(textureFields) do
			textures.custom[field] = E.db.mMT.portraits.custom[field] ~= "" and E.db.mMT.portraits.custom[field] or nil
		end
		textures.custom.maskb = textures.custom.maskb or textures.custom.mask
	else
		textures.custom.enable = false
		for _, field in ipairs(textureFields) do
			textures.custom[field] = nil
		end
	end
end

local function setColors(sourceColors, targetColors)
	targetColors.default = sourceColors.default
	targetColors.rare = sourceColors.rare
	targetColors.rareelite = sourceColors.rareelite
	targetColors.elite = sourceColors.elite
end

local function ConfigureColors()
	if E.db.mMT.portraits.general.eltruism and mMT.ElvUI_EltreumUI.loaded then
		colors = mMT.ElvUI_EltreumUI.colors
		setColors(E.db.mMT.portraits.colors, colors)
	elseif E.db.mMT.portraits.general.mui and mMT.ElvUI_MerathilisUI.loaded then
		if not colors.inverted then
			for i, tbl in pairs(mMT.ElvUI_MerathilisUI.colors) do
				colors[i] = { a = tbl.b, b = tbl.a }
			end
			colors.inverted = true
		end
		setColors(E.db.mMT.portraits.colors, colors)
	else
		colors = E.db.mMT.portraits.colors
	end
end

local function SetScripts(portrait)
	if not portrait.isBuild then
		for _, event in pairs(portrait.unitEvents) do
			portrait:RegisterUnitEvent(event, event == "UNIT_TARGET" and "target" or portrait.unit)
		end

		for _, event in pairs(portrait.events) do
			portrait:RegisterEvent(event)
		end

		portrait:SetAttribute("unit", portrait.unit)
		portrait:SetAttribute("*type1", "target")
		portrait:SetAttribute("*type2", "togglemenu")
		portrait:SetAttribute("type3", "focus")
		portrait:SetAttribute("toggleForVehicle", true)
		portrait:SetAttribute("ping-receiver", true)
		portrait:RegisterForClicks("AnyUp")
		portrait.isBuild = true
	end
end

local function CreatePortraits(name, unit, parentFrame, unitSettings, events, unitEvents, cast)
	if not module[name] then
		module[name] = CreatePortrait(parentFrame, unitSettings, unit)

		module[name].parent = parentFrame
		module[name].unit = unit
		module[name].events = events
		module[name].unitEvents = unitEvents
		module[name].update = {}

		for _, event in pairs(events) do
			module[name].update[event] = true
		end

		for _, event in pairs(unitEvents) do
			module[name].update[event] = true
		end
	end

	module[name].settings = unitSettings

	local castEvents = { "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_STOP" }
	local empowerEvents = { "UNIT_SPELLCAST_EMPOWER_START", "UNIT_SPELLCAST_EMPOWER_STOP" }

	if cast then
		for _, event in pairs(castEvents) do
			tinsert(module[name].events, event)
		end

		if E.Retail then
			for _, event in pairs(empowerEvents) do
				tinsert(module[name].events, event)
			end
		end
		module[name].castEvents = true
	elseif module[name].castEvents then
		for _, event in pairs(castEvents) do
			module[name]:UnregisterEvent(event)
		end

		if E.Retail then
			for _, event in pairs(empowerEvents) do
				module[name]:UnregisterEvent(event)
			end
		end
	end

	if module[name] and not module[name].scriptsSet then
		module[name]:SetScript("OnEvent", function(self, event, castUnit)
			UnitEvent(self, event, castUnit)
		end)

		SetScripts(module[name])
		module[name].scriptsSet = true
	end

	--mMT:DebugPrintTable(module[name])
end

function module:Initialize()
	-- update texture settings
	SetCustomTextures()

	-- update colors
	ConfigureColors()

	if E.db.mMT.portraits.general.enable then
		if _G.ElvUF_Player and E.db.mMT.portraits.player.enable then
			CreatePortraits("Player", "player", _G.ElvUF_Player, E.db.mMT.portraits.player, { "PLAYER_ENTERING_WORLD" }, { "UNIT_PORTRAIT_UPDATE" }, E.db.mMT.portraits.player.cast)
		elseif module.Player then
			RemovePortrait("Player")
		end

		if _G.ElvUF_Target and E.db.mMT.portraits.target.enable then
			CreatePortraits("Target", "target", _G.ElvUF_Target, E.db.mMT.portraits.target, { "PLAYER_ENTERING_WORLD", "PLAYER_TARGET_CHANGED" }, { "UNIT_PORTRAIT_UPDATE" }, E.db.mMT.portraits.target.cast)
		elseif module.Target then
			RemovePortrait("Target")
		end

		if _G.ElvUF_Pet and E.db.mMT.portraits.pet.enable then
			CreatePortraits("Pet", "pet", _G.ElvUF_Pet, E.db.mMT.portraits.pet, { "PLAYER_ENTERING_WORLD" }, { "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED" })
		elseif module.Pet then
			RemovePortrait("Pet")
		end

		if _G.ElvUF_TargetTarget and E.db.mMT.portraits.targettarget.enable then
			CreatePortraits("TargetTarget", "targettarget", _G.ElvUF_TargetTarget, E.db.mMT.portraits.targettarget, { "PLAYER_ENTERING_WORLD", "PLAYER_TARGET_CHANGED" }, { "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED", "UNIT_TARGET" })
		elseif module.TargetTarget then
			RemovePortrait("TargetTarget")
		end

		if _G.ElvUF_Focus and E.db.mMT.portraits.focus.enable then
			CreatePortraits("Focus", "focus", _G.ElvUF_Focus, E.db.mMT.portraits.focus, { "PLAYER_ENTERING_WORLD", "PLAYER_FOCUS_CHANGED" }, { "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED" }, E.db.mMT.portraits.focus.cast)
		elseif module.Focus then
			RemovePortrait("Focus")
		end

		if _G.ElvUF_PartyGroup1UnitButton1 and E.db.mMT.portraits.party.enable then
			for i = 1, 5 do
				CreatePortraits("Party" .. i, _G["ElvUF_PartyGroup1UnitButton" .. i].unit, _G["ElvUF_PartyGroup1UnitButton" .. i], E.db.mMT.portraits.party, { "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE", "UNIT_CONNECTION" }, { "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED", "PARTY_MEMBER_ENABLE" }, E.db.mMT.portraits.party.cast)
			end
		elseif module.Party1 then
			for i = 1, 5 do
				RemovePortrait("Party" .. i)
			end
		end

		if _G.ElvUF_Boss1 and E.db.mMT.portraits.boss.enable then
			for i = 1, 8 do
				CreatePortraits("Boss" .. i, _G["ElvUF_Boss" .. i].unit, _G["ElvUF_Boss" .. i], E.db.mMT.portraits.boss, { "PLAYER_ENTERING_WORLD", "INSTANCE_ENCOUNTER_ENGAGE_UNIT", "UNIT_TARGETABLE_CHANGED" }, { "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED" }, E.db.mMT.portraits.boss)
			end
		elseif module.Boss1 then
			for i = 1, 8 do
				RemovePortrait("Boss" .. i)
			end
		end

		if _G.ElvUF_Arena1 and E.db.mMT.portraits.arena.enable then
			for i = 1, 5 do
				CreatePortraits("Arena" .. i, _G["ElvUF_Arena" .. i].unit, _G["ElvUF_Arena" .. i], E.db.mMT.portraits.arena, { "PLAYER_ENTERING_WORLD", "ARENA_OPPONENT_UPDATE", "UNIT_CONNECTION" }, { "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED", "UNIT_NAME_UPDATE" }, E.db.mMT.portraits.arena.cast)

				if E.Retail then
					tinsert(module["Arena" .. i].events, "ARENA_PREP_OPPONENT_SPECIALIZATIONS")
				end
			end
		elseif module.Arena1 then
			for i = 1, 5 do
				RemovePortrait("Arena" .. i)
			end
		end

		module:UpdatePortraits()
	else
		-- need fix
		for name, _ in pairs(module) do
			if module[name] then
				for _, event in pairs(module[name].unitEvents) do
					module[name]:UnregisterEvent(event)
				end

				for _, event in pairs(module[name].events) do
					module[name]:UnregisterEvent(event)
				end

				module[name]:Hide()
				module[name] = nil
			end
		end
	end

	module.loaded = E.db.mMT.portraits.general.enable
end
