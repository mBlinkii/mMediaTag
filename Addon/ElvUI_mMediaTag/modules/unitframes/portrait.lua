local E = unpack(ElvUI)

local _G = _G
local SetPortraitTexture = SetPortraitTexture
local UnitExists = UnitExists

local module = mMT.Modules.Portraits
if not module then
	return
end

local settings = {}

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
			SMQ = path .. "smq.tga",
			MO = path .. "moon_c.tga",
		},
		smooth = {
			SQ = path .. "sq_b.tga",
			RO = path .. "ro_b.tga",
			CI = path .. "ci_b.tga",
			CO = path .. "co_b.tga",
			PI = path .. "pi_b.tga",
			RA = path .. "ra_b.tga",
			QA = path .. "qa_b.tga",
			SMQ = path .. "smq.tga",
			MO = path .. "moon_a.tga",
		},
		metal = {
			SQ = path .. "sq_c.tga",
			RO = path .. "ro_c.tga",
			CI = path .. "ci_c.tga",
			CO = path .. "co_c.tga",
			PI = path .. "pi_c.tga",
			RA = path .. "ra_c.tga",
			QA = path .. "qa_c.tga",
			SMQ = path .. "smq.tga",
			MO = path .. "moon_b.tga",
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
			SMQ = nil,
			MO = path .. "ex_mo_c.tga",
		},
		smooth = {
			CI = path .. "ex_a_b.tga",
			SQ = path .. "ex_b_b.tga",
			RO = path .. "ex_b_b.tga",
			PI = path .. "ex_pi_b.tga",
			RA = path .. "ex_ra_b.tga",
			QA = path .. "ex_qa_b.tga",
			SMQ = nil,
			MO = path .. "ex_mo_a.tga",
		},
		metal = {
			CI = path .. "ex_a_c.tga",
			SQ = path .. "ex_b_c.tga",
			RO = path .. "ex_b_c.tga",
			PI = path .. "ex_pi_c.tga",
			RA = path .. "ex_ra_c.tga",
			QA = path .. "ex_qa_c.tga",
			SMQ = nil,
			MO = path .. "ex_mo_b.tga",
		},
		border = {
			CI = path .. "border_ex_a.tga",
			SQ = path .. "border_ex_b.tga",
			RO = path .. "border_ex_b.tga",
			PI = path .. "border_ex_pi.tga",
			RA = path .. "border_ex_ra.tga",
			QA = path .. "border_ex_qa.tga",
			SMQ = nil,
			MO = path .. "border_ex_moon.tga",
		},
		shadow = {
			CI = path .. "shadow_ex_a.tga",
			SQ = path .. "shadow_ex_b.tga",
			RO = path .. "shadow_ex_b.tga",
			PI = path .. "shadow_ex_pi.tga",
			RA = path .. "shadow_ex_ra.tga",
			QA = path .. "shadow_ex_qa.tga",
			SMQ = nil,
			MO = nil,
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
		SMQ = path .. "border_smq.tga",
		MO = path .. "border_moon.tga",
	},
	shadow = {
		SQ = path .. "shadow_sq.tga",
		RO = path .. "shadow_ro.tga",
		CI = path .. "shadow_ci.tga",
		PI = path .. "shadow_pi.tga",
		RA = path .. "shadow_ra.tga",
		QA = path .. "shadow_qa.tga",
		SMQ = path .. "shadow_smq.tga",
		MO = path .. "shadow_moon.tga",
	},
	inner = {
		SQ = path .. "inner_a.tga",
		RO = path .. "inner_a.tga",
		CI = path .. "inner_b.tga",
		PI = path .. "inner_pi.tga",
		RA = path .. "inner_ra.tga",
		QA = path .. "inner_qa.tga",
		SMQ = path .. "inner_smq.tga",
		MO = path .. "inner_b.tga",
	},
	mask = {
		CI = path .. "mask_c.tga",
		PI = path .. "mask_pi.tga",
		RA = path .. "mask_d.tga",
		QA = path .. "mask_qa.tga",
		MO = path .. "mask_c.tga",
		SMQ = path .. "mask_smq.tga",

		A = {
			SQ = path .. "mask_a.tga",
			RO = path .. "mask_a.tga",
		},
		B = {
			SQ = path .. "mask_b.tga",
			RO = path .. "mask_b.tga",
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
	},
}

local function mirrorTexture(texture, mirror)
	if texture.mClass then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = unpack(texture.mCoords)
		if mirror then
			texture:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
		else
			texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
		end
	else
		texture:SetTexCoord(mirror and 1 or 0, mirror and 0 or 1, 0, 1)
	end
end

local function setColor(texture, color, mirror)
	if not texture or not color or not color.a or not color.b then
		return
	end

	if settings.general.gradient and not color.r then
		local a, b = color.a, color.b
		if mirror and (settings.general.ori == "HORIZONTAL") then
			a, b = b, a
		end
		texture:SetGradient(settings.general.ori, a, b)
	elseif color.r then
		texture:SetVertexColor(color.r, color.g, color.b, color.a)
	end
end

local function getColor(unit)
	if settings.general.default then
		return settings.colors.default
	end

	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		return settings.colors[class]
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			return settings.colors[(reaction <= 3) and "enemy" or reaction == 4 and "neutral" or "friendly"]
		else
			return settings.colors.enemy
		end
	end
end

local function UpdateIconBackground(tx, unit, mirror)
	tx:SetTexture(textures.background[settings.general.bgstyle], "CLAMP", "CLAMP", "TRILINEAR")

	local color = settings.shadow.classBG and getColor(unit) or settings.shadow.background
	local bgColor = {}
	local ColorShift = settings.shadow.bgColorShift

	if not color.r then
		bgColor.a = { r = 1, g = 1, b = 1, a = 1 }
		bgColor.a.r = color.a.r - ColorShift
		bgColor.a.g = color.a.g - ColorShift
		bgColor.a.b = color.a.b - ColorShift
		bgColor.a.a = color.a.a

		bgColor.b = { r = 1, g = 1, b = 1, a = 1 }
		bgColor.b.r = color.b.r - ColorShift
		bgColor.b.g = color.b.g - ColorShift
		bgColor.b.b = color.b.b - ColorShift
		bgColor.b.a = color.b.a
	elseif bgColor.r then
		bgColor = { r = 1, g = 1, b = 1, a = 1 }
		bgColor.r = color.r - ColorShift
		bgColor.g = color.g - ColorShift
		bgColor.b = color.b - ColorShift
	end

	setColor(tx, bgColor, mirror)
end

local function SetPortraits(frame, unit, masking, mirror)
	if settings.general.classicons and UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		local IconTexture = "Interface\\WorldStateFrame\\Icons-Classes"
		local coords = CLASS_ICON_TCOORDS[class]
		local style = settings.general.classiconstyle

		if mMT.ElvUI_JiberishIcons.loaded and style ~= "BLIZZARD" then
			coords = class and mMT.ElvUI_JiberishIcons.texCoords[class]
			IconTexture = mMT.ElvUI_JiberishIcons.path .. style
		end

		if coords then
			if #coords == 8 then
				local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = unpack(coords)
				if mirror then
					frame.portrait:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
				else
					frame.portrait:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
				end
			else
				local left, right, top, bottom = unpack(coords)
				frame.portrait:SetTexCoord(mirror and right or left, mirror and left or right, top, bottom)
			end
		end

		frame.portrait:SetTexture(IconTexture)

		if frame.iconbg then
			UpdateIconBackground(frame.iconbg, unit, mirror)
		end

		frame.portrait.mClass = unit
		frame.portrait.mCoords = coords
	else
		if frame.portrait.mClass then
			frame.portrait.mClass = nil
			frame.portrait.mCoords = nil
		end

		mirrorTexture(frame.portrait, mirror)
		SetPortraitTexture(frame.portrait, unit, masking)
	end
end

local function CreatePortraitTexture(frame, name, layer, texture, color, mirror)
	local tmpTexture = frame:CreateTexture(name, "OVERLAY", nil, layer)
	tmpTexture:SetAllPoints(frame)
	tmpTexture:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
	mirrorTexture(tmpTexture, mirror)

	if color then
		setColor(tmpTexture, color, mirror)
	end

	return tmpTexture
end

local function CreateIconBackground(frame, unit, mirror)
	local tmpTexture = frame:CreateTexture("mMT_Background", "OVERLAY", nil, -5)
	tmpTexture:SetAllPoints(frame)
	tmpTexture:SetTexture(textures.background[settings.general.bgstyle], "CLAMP", "CLAMP", "TRILINEAR")

	local color = settings.shadow.classBG and getColor(unit) or settings.shadow.background
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
		mMT:Print("Create Function", "Unit:", unit, "Exists", UnitExists(unit), "Parent Unit:", parent.unit, "Parent Exists:", UnitExists(parent.unit))
	end

	local texture = nil
	unit = UnitExists(unit) and unit or "player"

	-- Portraits Frame
	local frame = CreateFrame("Frame", "mMT_Portrait_" .. unit, parent)
	frame:SetSize(conf.size, conf.size)
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)
	if conf.strata ~= "AUTO" then
		frame:SetFrameStrata(conf.strata)
	end
	frame:SetFrameLevel(conf.level)

	-- Portrait Texture

	texture = textures.texture[settings.general.style][conf.texture]
	frame.texture = CreatePortraitTexture(frame, "mMT_Texture", 4, texture, getColor(unit), conf.mirror)

	-- Unit Portrait
	local offset = GetOffset(conf.size, settings.offset[conf.texture])
	frame.portrait = frame:CreateTexture("mMT_Portrait", "OVERLAY", nil, 1)
	frame.portrait:SetAllPoints(frame)
	frame.portrait:SetPoint("TOPLEFT", 0 + offset, 0 - offset)
	frame.portrait:SetPoint("BOTTOMRIGHT", 0 - offset, 0 + offset)
	frame.portrait:SetTexture(path .. "unknown.tga", "CLAMP", "CLAMP", "TRILINEAR")
	SetPortraits(frame, unit, textures.enablemasking[conf.texture], conf.mirror)
	mirrorTexture(frame.portrait, conf.mirror)

	-- Portrait Mask
	texture = textures.mask[conf.texture] or conf.mirror and textures.mask.B[conf.texture] or textures.mask.A[conf.texture]
	frame.mask = frame:CreateMaskTexture()
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	frame.mask:SetAllPoints(frame)
	frame.portrait:AddMaskTexture(frame.mask)

	-- Class Icon Background
	if settings.general.classicons then
		frame.iconbg = CreateIconBackground(frame, unit, conf.mirror)
		frame.iconbg:AddMaskTexture(frame.mask)
	end

	-- Portrait Shadow
	if settings.shadow.enable then
		texture = textures.shadow[conf.texture]
		frame.shadow = CreatePortraitTexture(frame, "mMT_Shadow", -4, texture, settings.shadow.color, conf.mirror)
	end

	-- Inner Portrait Shadow
	if settings.shadow.inner then
		texture = textures.inner[conf.texture]
		frame.InnerShadow = CreatePortraitTexture(frame, "mMT_innerShadow", 2, texture, settings.shadow.innerColor, conf.mirror)
	end

	-- Portrait Border
	if settings.shadow.border then
		texture = textures.border[conf.texture]
		frame.border = CreatePortraitTexture(frame, "mMT_Border", 2, texture, settings.shadow.borderColor, conf.mirror)
	end

	-- Rare/Elite Texture
	if conf.extraEnable then
		-- Texture
		texture = textures.extra[settings.general.style][conf.texture]
		frame.extra = CreatePortraitTexture(frame, "mMT_Extra", -6, texture, nil, not conf.mirror)

		-- Shadow
		if settings.shadow.enable then
			texture = textures.extra.border[conf.texture]
			frame.extra.shadow = CreatePortraitTexture(frame, "mMT_Extra_Shadow", -8, texture, settings.shadow.color, not conf.mirror)
			frame.extra.shadow:Hide()
		end

		-- Border
		if settings.shadow.border then
			texture = textures.extra.shadow[conf.texture]
			frame.extra.border = CreatePortraitTexture(frame, "mMT_Extra_Border", -4, texture, settings.shadow.borderColorRare, not conf.mirror)
			frame.extra.border:Hide()
		end

		frame.extra:Hide()
	end

	-- Corner
	if settings.general.corner and textures.corner[conf.texture] then
		texture = textures.texture[settings.general.style].CO
		frame.corner = CreatePortraitTexture(frame, "mMT_Corner", 5, texture, getColor(unit), conf.mirror)

		-- Border
		if settings.shadow.border then
			texture = textures.border.CO
			frame.corner.border = CreatePortraitTexture(frame, "mMT_Corner_Border", 6, texture, settings.shadow.borderColor, conf.mirror)
		end
	end

	return frame
end

local function CheckRareElite(frame, unit)
	local c = UnitClassification(unit)
	local color = settings.colors[c]

	if color then
		setColor(frame.extra, color)
		if settings.shadow.enable and frame.extra.shadow then
			frame.extra.shadow:Show()
		end
		if settings.shadow.border and frame.extra.border then
			frame.extra.border:Show()
		end
		frame.extra:Show()
	else
		if settings.shadow.enable and frame.extra.shadow then
			frame.extra.shadow:Hide()
		end
		if settings.shadow.border and frame.extra.border then
			frame.extra.border:Hide()
		end
		frame.extra:Hide()
	end
end

local function UpdatePortraitTexture(tx, texture, color, mirror)
	if tx then
		tx:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(tx, mirror)

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
	frame:SetSize(conf.size, conf.size)
	frame:ClearAllPoints()
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)
	if conf.strata ~= "AUTO" then
		frame:SetFrameStrata(conf.strata)
	end
	frame:SetFrameLevel(conf.level)

	-- Portrait Texture
	texture = textures.texture[settings.general.style][conf.texture]
	UpdatePortraitTexture(frame.texture, texture, getColor(unit), conf.mirror)

	-- Unit Portrait
	local offset = GetOffset(conf.size, settings.offset[conf.texture])
	frame.portrait:SetPoint("TOPLEFT", 0 + offset, 0 - offset)
	frame.portrait:SetPoint("BOTTOMRIGHT", 0 - offset, 0 + offset)
	mirrorTexture(frame.portrait, conf.mirror)

	-- Portrait Mask
	texture = textures.mask[conf.texture] or conf.mirror and textures.mask.B[conf.texture] or textures.mask.A[conf.texture]
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

	-- Portrait Shadow
	if settings.shadow.enable then
		texture = textures.shadow[conf.texture]
		if frame.shadow then
			UpdatePortraitTexture(frame.shadow, texture, settings.shadow.color, conf.mirror)
			frame.shadow:Show()
		else
			frame.shadow = CreatePortraitTexture(frame, "mMT_Shadow", -4, texture, settings.shadow.color, conf.mirror)
		end
	elseif not settings.shadow.enable and frame.shadow then
		frame.shadow:Hide()
	end

	-- Inner Portrait Shadow
	if settings.shadow.inner then
		texture = textures.inner[conf.texture]
		if frame.InnerShadow then
			UpdatePortraitTexture(frame.InnerShadow, texture, settings.shadow.innerColor, conf.mirror)
			frame.InnerShadow:Show()
		else
			frame.InnerShadow = CreatePortraitTexture(frame, "mMT_innerShadow", 2, texture, settings.shadow.innerColor, conf.mirror)
		end
	elseif not settings.shadow.inner and frame.InnerShadow then
		frame.InnerShadow:Hide()
	end

	-- Portrait Border
	if settings.shadow.border then
		texture = textures.border[conf.texture]
		if frame.border then
			UpdatePortraitTexture(frame.border, texture, settings.shadow.borderColor, conf.mirror)
			frame.border:Show()
		else
			frame.border = CreatePortraitTexture(frame, "mMT_Border", 2, texture, settings.shadow.borderColor, conf.mirror)
		end
	elseif not settings.shadow.border and frame.border then
		frame.border:Hide()
	end

	-- Class Icon Background
	if settings.general.classicons then
		if frame.iconbg then
			UpdateIconBackground(frame.iconbg, unit, conf.mirror)
			if settings.shadow.enable then
				frame.shadow:Show()
			end
		else
			frame.iconbg = CreateIconBackground(frame, unit, conf.mirror)
		end
	elseif frame.iconbg and not settings.general.classicons then
		frame.iconbg:Hide()
	end

	-- Rare/Elite Texture
	if conf.extraEnable then
		-- Texture
		texture = textures.extra[settings.general.style][conf.texture]
		if frame.extra then
			UpdatePortraitTexture(frame.extra, texture, nil, not conf.mirror)
		else
			frame.extra = CreatePortraitTexture(frame, "mMT_Extra", -6, texture, nil, not conf.mirror)
		end

		-- Shadow
		if settings.shadow.enable then
			texture = textures.extra.shadow[conf.texture]
			if frame.extra.shadow then
				UpdatePortraitTexture(frame.extra.shadow, texture, settings.shadow.color, not conf.mirror)
			else
				frame.extra.shadow = CreatePortraitTexture(frame, "mMT_Extra_Shadow", -8, texture, settings.shadow.color, not conf.mirror)
				frame.extra.shadow:Hide()
			end
		elseif not settings.shadow.enable and frame.extra.shadow then
			frame.extra.shadow:Hide()
		end

		-- Border
		if settings.shadow.border then
			texture = textures.extra.border[conf.texture]
			if frame.extra.border then
				UpdatePortraitTexture(frame.extra.border, texture, settings.shadow.borderColorRare, not conf.mirror)
			else
				frame.extra.border = CreatePortraitTexture(frame, "mMT_Extra_Border", -4, texture, settings.shadow.borderColorRare, not conf.mirror)
				frame.extra.border:Hide()
			end
		elseif not settings.shadow.border and frame.extra.border then
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
	if settings.general.corner and textures.corner[conf.texture] then
		texture = textures.texture[settings.general.style].CO
		if frame.corner then
			UpdatePortraitTexture(frame.corner, texture, getColor(unit), conf.mirror)
			frame.corner:Show()
		else
			frame.corner = CreatePortraitTexture(frame, "mMT_Corner", 5, texture, getColor(unit), conf.mirror)
		end

		-- Border
		if settings.shadow.border then
			texture = textures.border.CO
			if frame.corner.border then
				UpdatePortraitTexture(frame.corner.border, texture, settings.shadow.borderColor, conf.mirror)
				frame.corner.border:Show()
			else
				frame.corner.border = CreatePortraitTexture(frame, "mMT_Corner_Border", 6, texture, settings.shadow.borderColor, conf.mirror)
			end
		elseif frame.corner.border then
			frame.corner.border:Hide()
		end
	elseif not (settings.general.corner and textures.corner[conf.texture]) and frame.corner then
		if frame.corner.border then
			frame.corner.border:Hide()
		end

		frame.corner:Hide()
	end
end

function module:UpdatePortraits()
	if module.Player then
		UpdatePortrait(module.Player, settings.player, "player", _G.ElvUF_Player)
	end

	if module.Target then
		UpdatePortrait(module.Target, settings.target, "target", _G.ElvUF_Target)
	end

	if module.Pet then
		UpdatePortrait(module.Pet, settings.pet, "pet", _G.ElvUF_Pet)
	end

	if module.Focus then
		UpdatePortrait(module.Focus, settings.focus, "focus", _G.ElvUF_Focus)
	end

	if module.TargetTarget then
		UpdatePortrait(module.TargetTarget, settings.targettarget, "targettarget", _G.ElvUF_TargetTarget)
	end

	if module.Party1 then
		UpdatePortrait(module.Party1, settings.party, _G.ElvUF_PartyGroup1UnitButton1.unit, _G.ElvUF_PartyGroup1UnitButton1)
		UpdatePortrait(module.Party2, settings.party, _G.ElvUF_PartyGroup1UnitButton2.unit, _G.ElvUF_PartyGroup1UnitButton2)
		UpdatePortrait(module.Party3, settings.party, _G.ElvUF_PartyGroup1UnitButton3.unit, _G.ElvUF_PartyGroup1UnitButton3)
		UpdatePortrait(module.Party4, settings.party, _G.ElvUF_PartyGroup1UnitButton4.unit, _G.ElvUF_PartyGroup1UnitButton4)
		UpdatePortrait(module.Party5, settings.party, _G.ElvUF_PartyGroup1UnitButton5.unit, _G.ElvUF_PartyGroup1UnitButton5)
	end

	if module.Arena1 then
		UpdatePortrait(module.Arena1, settings.arena, _G.ElvUF_Arena1.unit, _G.ElvUF_Arena1)
		UpdatePortrait(module.Arena2, settings.arena, _G.ElvUF_Arena2.unit, _G.ElvUF_Arena2)
		UpdatePortrait(module.Arena3, settings.arena, _G.ElvUF_Arena3.unit, _G.ElvUF_Arena3)
		UpdatePortrait(module.Arena4, settings.arena, _G.ElvUF_Arena4.unit, _G.ElvUF_Arena4)
		UpdatePortrait(module.Arena5, settings.arena, _G.ElvUF_Arena5.unit, _G.ElvUF_Arena5)
	end

	if module.Boss1 then
		UpdatePortrait(module.Boss1, settings.boss, _G.ElvUF_Boss1.unit, _G.ElvUF_Boss1)
		UpdatePortrait(module.Boss2, settings.boss, _G.ElvUF_Boss2.unit, _G.ElvUF_Boss2)
		UpdatePortrait(module.Boss3, settings.boss, _G.ElvUF_Boss3.unit, _G.ElvUF_Boss3)
		UpdatePortrait(module.Boss4, settings.boss, _G.ElvUF_Boss4.unit, _G.ElvUF_Boss4)
		UpdatePortrait(module.Boss5, settings.boss, _G.ElvUF_Boss5.unit, _G.ElvUF_Boss5)
		UpdatePortrait(module.Boss6, settings.boss, _G.ElvUF_Boss6.unit, _G.ElvUF_Boss6)
		UpdatePortrait(module.Boss7, settings.boss, _G.ElvUF_Boss7.unit, _G.ElvUF_Boss7)
		UpdatePortrait(module.Boss8, settings.boss, _G.ElvUF_Boss8.unit, _G.ElvUF_Boss8)
	end
end

function module:Initialize()
	settings = E.db.mMT.portraits

	if settings.general.eltruism and mMT.ElvUI_EltreumUI.loaded then
		settings.colors.WARRIOR = mMT.ElvUI_EltreumUI.colors.WARRIOR
		settings.colors.PALADIN = mMT.ElvUI_EltreumUI.colors.PALADIN
		settings.colors.HUNTER = mMT.ElvUI_EltreumUI.colors.HUNTER
		settings.colors.ROGUE = mMT.ElvUI_EltreumUI.colors.ROGUE
		settings.colors.PRIEST = mMT.ElvUI_EltreumUI.colors.PRIEST
		settings.colors.DEATHKNIGHT = mMT.ElvUI_EltreumUI.colors.DEATHKNIGHT
		settings.colors.SHAMAN = mMT.ElvUI_EltreumUI.colors.SHAMAN
		settings.colors.MAGE = mMT.ElvUI_EltreumUI.colors.MAGE
		settings.colors.WARLOCK = mMT.ElvUI_EltreumUI.colors.WARLOCK
		settings.colors.MONK = mMT.ElvUI_EltreumUI.colors.MONK
		settings.colors.DRUID = mMT.ElvUI_EltreumUI.colors.DRUID
		settings.colors.DEMONHUNTER = mMT.ElvUI_EltreumUI.colors.DEMONHUNTER
		settings.colors.EVOKER = mMT.ElvUI_EltreumUI.colors.EVOKER
		settings.colors.friendly = mMT.ElvUI_EltreumUI.colors.friendly
		settings.colors.neutral = mMT.ElvUI_EltreumUI.colors.neutral
		settings.colors.enemy = mMT.ElvUI_EltreumUI.colors.enemy
	end

	local frames = {
		Player = {
			parent = _G.ElvUF_Player,
			settings = settings.player,
			unit = "player",
			events = {
				"PLAYER_ENTERING_WORLD",
			},
			unitEvents = {
				"UNIT_PORTRAIT_UPDATE",
			},
		},
		Target = {
			parent = _G.ElvUF_Target,
			settings = settings.target,
			unit = "target",
			events = {
				"PLAYER_ENTERING_WORLD",
				"PLAYER_TARGET_CHANGED",
			},
			unitEvents = {
				"UNIT_PORTRAIT_UPDATE",
			},
		},
	}

	if _G.ElvUF_Pet and settings.pet.enable then
		frames["Pet"] = {
			parent = _G.ElvUF_Pet,
			settings = settings.pet,
			unit = "pet",
			events = {
				"PLAYER_ENTERING_WORLD",
			},
			unitEvents = {
				"UNIT_PORTRAIT_UPDATE",
				"UNIT_MODEL_CHANGED",
			},
		}
	end

	if _G.ElvUF_TargetTarget and settings.targettarget.enable then
		frames["TargetTarget"] = {
			parent = _G.ElvUF_TargetTarget,
			settings = settings.targettarget,
			unit = "targettarget",
			events = {
				"PLAYER_ENTERING_WORLD",
				"PLAYER_TARGET_CHANGED",
			},
			unitEvents = {
				"UNIT_PORTRAIT_UPDATE",
				"UNIT_MODEL_CHANGED",
				"UNIT_TARGET",
			},
		}
	end

	if _G.ElvUF_Focus and settings.focus.enable then
		frames["Focus"] = {
			parent = _G.ElvUF_Focus,
			settings = settings.focus,
			unit = "focus",
			events = {
				"PLAYER_ENTERING_WORLD",
				"PLAYER_FOCUS_CHANGED",
			},
			unitEvents = {
				"UNIT_PORTRAIT_UPDATE",
				"UNIT_MODEL_CHANGED",
			},
		}
	end

	if _G.ElvUF_PartyGroup1UnitButton1 and settings.party.enable then
		for i = 1, 5 do
			frames["Party" .. i] = {
				parent = _G["ElvUF_PartyGroup1UnitButton" .. i],
				settings = settings.party,
				unit = _G["ElvUF_PartyGroup1UnitButton" .. i].unit,
				events = {
					"PLAYER_ENTERING_WORLD",
					"GROUP_ROSTER_UPDATE",
					"UNIT_CONNECTION",
				},
				unitEvents = {
					"UNIT_PORTRAIT_UPDATE",
					"UNIT_MODEL_CHANGED",
					"PARTY_MEMBER_ENABLE",
				},
			}
		end
	end

	if _G.ElvUF_Boss1 and settings.boss.enable then
		for i = 1, 8 do
			frames["Boss" .. i] = {
				parent = _G["ElvUF_Boss" .. i],
				settings = settings.boss,
				unit = _G["ElvUF_Boss" .. i].unit,
				events = {
					"PLAYER_ENTERING_WORLD",
					"INSTANCE_ENCOUNTER_ENGAGE_UNIT",
					"UNIT_TARGETABLE_CHANGED",
				},
				unitEvents = {
					"UNIT_PORTRAIT_UPDATE",
					"UNIT_MODEL_CHANGED",
				},
			}
		end
	end

	if _G.ElvUF_Arena1 and settings.arena.enable then
		for i = 1, 5 do
			frames["Arena" .. i] = {
				parent = _G["ElvUF_Arena" .. i],
				settings = settings.arena,
				unit = _G["ElvUF_Arena" .. i].unit,
				events = {
					"PLAYER_ENTERING_WORLD",
					"ARENA_OPPONENT_UPDATE",
					"ARENA_PREP_OPPONENT_SPECIALIZATIONS",
					"UNIT_CONNECTION",
				},
				unitEvents = {
					"UNIT_PORTRAIT_UPDATE",
					"UNIT_MODEL_CHANGED",
					"UNIT_NAME_UPDATE",
				},
			}
		end
	end

	if settings.general.enable then
		for name, unit in pairs(frames) do
			if unit.settings.enable and unit.parent and not module[name] then
				module[name] = CreatePortrait(unit.parent, unit.settings, unit.unit)

				for _, event in pairs(unit.unitEvents) do
					module[name]:RegisterUnitEvent(event, event == "UNIT_TARGET" and "target" or unit.unit)
				end

				for _, event in pairs(unit.events) do
					module[name]:RegisterEvent(event)
				end
			elseif module[name] and not unit.settings.enable then
				for _, event in pairs(unit.unitEvents) do
					module[name]:UnregisterEvent(event)
				end

				for _, event in pairs(unit.events) do
					module[name]:UnregisterEvent(event)
				end

				module[name]:Hide()
				module[name] = nil
			end
		end

		if settings.player.enable and module.Player and not module.Player.ScriptSet then
			module.Player:SetScript("OnEvent", function(self, event)
				if mMT.DevMode then
					mMT:Print("Script Player", "Event:", event, "Unit Exists:", UnitExists("player"))
				end

				if UnitExists("player") then
					SetPortraits(self, "player", textures.enablemasking[settings.player.texture], settings.player.mirror)
					setColor(self.texture, getColor("player"), settings.player.mirror)
					if settings.general.corner and textures.corner[settings.player.texture] then
						setColor(self.corner, getColor("player"), settings.player.mirror)
					end
				end
			end)
			module.Player.ScriptSet = true
		end

		if settings.target.enable and module.Target and not module.Target.ScriptSet then
			module.Target:SetScript("OnEvent", function(self, event)
				if mMT.DevMode then
					mMT:Print("Script Target", "Event:", event, "Unit Exists:", UnitExists("target"))
				end

				if UnitExists("target") then
					SetPortraits(self, "target", textures.enablemasking[settings.target.texture], settings.target.mirror)
					setColor(self.texture, getColor("target"), settings.target.mirror)

					if settings.general.corner and textures.corner[settings.target.texture] then
						setColor(self.corner, getColor("target"), settings.target.mirror)
					end

					if settings.target.extraEnable and self.extra then
						CheckRareElite(self, "target")
					elseif self.extra then
						self.extra:Hide()
					end
				end
			end)
			module.Target.ScriptSet = true
		end

		if settings.pet.enable and module.Pet and not module.Pet.ScriptSet then
			module.Pet:SetScript("OnEvent", function(self, event)
				if mMT.DevMode then
					mMT:Print("Script Pet", "Event:", event, "Unit Exists:", UnitExists("pet"))
				end

				if UnitExists("pet") then
					SetPortraits(self, "pet", textures.enablemasking[settings.pet.texture], settings.pet.mirror)

					setColor(self.texture, getColor("pet"), settings.pet.mirror)
					if settings.general.corner and textures.corner[settings.pet.texture] then
						setColor(self.corner, getColor("pet"), settings.pet.mirror)
					end
				end
			end)
			module.Pet.ScriptSet = true
		end

		if settings.focus.enable and module.Focus and not module.Focus.ScriptSet then
			module.Focus:SetScript("OnEvent", function(self, event)
				if mMT.DevMode then
					mMT:Print("Script Focus", "Event:", event, "Unit Exists:", UnitExists("focus"))
				end

				if UnitExists("focus") then
					SetPortraits(self, "focus", textures.enablemasking[settings.focus.texture], settings.focus.mirror)
					setColor(self.texture, getColor("focus"), settings.focus.mirror)
					if settings.general.corner and textures.corner[settings.focus.texture] then
						setColor(self.corner, getColor("focus"), settings.focus.mirror)
					end

					if settings.focus.extraEnable and self.extra then
						CheckRareElite(self, "focus")
					elseif self.extra then
						self.extra:Hide()
					end
				end
			end)
			module.Focus.ScriptSet = true
		end

		if settings.targettarget.enable and module.TargetTarget and not module.TargetTarget.ScriptSet then
			module.TargetTarget:SetScript("OnEvent", function(self, event)
				if mMT.DevMode then
					mMT:Print("Script Target of Target", "Event:", event, "Unit Exists:", UnitExists("targettarget"))
				end

				if UnitExists("targettarget") then
					SetPortraits(self, "targettarget", textures.enablemasking[settings.targettarget.texture], settings.targettarget.mirror)
					setColor(self.texture, getColor("targettarget"), settings.targettarget.mirror)
					if settings.general.corner and textures.corner[settings.targettarget.texture] then
						setColor(self.corner, getColor("targettarget"), settings.targettarget.mirror)
					end

					if settings.targettarget.extraEnable and self.extra then
						CheckRareElite(self, "targettarget")
					elseif self.extra then
						self.extra:Hide()
					end
				end
			end)
			module.TargetTarget.ScriptSet = true
		end

		if settings.party.enable and module.Party1 and not module.Party1.ScriptSet then
			for i = 1, 5 do
				local frame = _G["ElvUF_PartyGroup1UnitButton" .. i]
				module["Party" .. i]:SetScript("OnEvent", function(self, event)
					if mMT.DevMode then
						mMT:Print("Script Party " .. i, "Event:", event, "Unit:", frame.unit, "Unit Exists:", UnitExists(frame.unit))
					end

					if UnitExists(frame.unit) then
						setColor(self.texture, getColor(frame.unit), settings.party.mirror)
						if settings.general.corner and textures.corner[settings.party.texture] then
							setColor(self.corner, getColor(frame.unit), settings.party.mirror)
						end

						SetPortraits(self, frame.unit, not textures.enablemasking[settings.party.texture], settings.party.mirror)
					end
				end)

				module["Party" .. i].ScriptSet = true
			end
		end

		if settings.boss.enable and module.Boss1 and not module.Boss1.ScriptSet then
			for i = 1, 8 do
				local frame = _G["ElvUF_Boss" .. i]
				module["Boss" .. i]:SetScript("OnEvent", function(self, event)
					if mMT.DevMode then
						mMT:Print("Script Boss " .. i, "Event:", event, "Unit:", frame.unit, "Unit Exists:", UnitExists(frame.unit))
					end

					if UnitExists(frame.unit) then
						setColor(self.texture, getColor(frame.unit), settings.boss.mirror)
						if settings.general.corner and textures.corner[settings.boss.texture] then
							setColor(self.corner, getColor(frame.unit), settings.boss.mirror)
						end

						SetPortraits(self, frame.unit, textures.enablemasking[settings.boss.texture], settings.boss.mirror)
					end
				end)

				module["Boss" .. i].ScriptSet = true
			end
		end

		if settings.arena.enable and module.Arena1 and not module.Arena1.ScriptSet then
			for i = 1, 5 do
				local frame = _G["ElvUF_Arena" .. i]
				module["Arena" .. i]:SetScript("OnEvent", function(self, event)
					if mMT.DevMode then
						mMT:Print("Script Arena " .. i, "Event:", event, "Unit:", frame.unit, "Unit Exists:", UnitExists(frame.unit))
					end

					if UnitExists(frame.unit) then
						setColor(self.texture, getColor(frame.unit), settings.arena.mirror)
						if settings.general.corner and textures.corner[settings.arena.texture] then
							setColor(self.corner, getColor(frame.unit), settings.arena.mirror)
						end

						SetPortraits(self, frame.unit, textures.enablemasking[settings.arena.texture], settings.arena.mirror)
					end
				end)

				module["Arena" .. i].ScriptSet = true
			end
		end

		module:UpdatePortraits()

		module.loaded = true
	else
		for name, unit in pairs(frames) do
			if module[name] then
				for _, event in pairs(unit.unitEvents) do
					module[name]:UnregisterEvent(event)
				end

				for _, event in pairs(unit.events) do
					module[name]:UnregisterEvent(event)
				end

				module[name]:Hide()
				module[name] = nil
			end
		end

		module.loaded = false
	end
end
