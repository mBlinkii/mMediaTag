local E = unpack(ElvUI)

local _G = _G
local SetPortraitTexture = SetPortraitTexture

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
			EA = path .. "ex_a_a.tga",
			EB = path .. "ex_b_a.tga",
		},
		smooth = {
			SQ = path .. "sq_b.tga",
			RO = path .. "ro_b.tga",
			CI = path .. "ci_b.tga",
			CO = path .. "co_b.tga",
			PI = path .. "pi_b.tga",
			EA = path .. "ex_a_b.tga",
			EB = path .. "ex_b_b.tga",
		},
		metal = {
			SQ = path .. "sq_c.tga",
			RO = path .. "ro_c.tga",
			CI = path .. "ci_c.tga",
			CO = path .. "co_c.tga",
			PI = path .. "pi_c.tga",
			EA = path .. "ex_a_c.tga",
			EB = path .. "ex_b_c.tga",
		},
	},
	border = {
		SQ = path .. "border_sq.tga",
		RO = path .. "border_ro.tga",
		CI = path .. "border_ci.tga",
		CO = path .. "border_co.tga",
		PI = path .. "border_pi.tga",
		EA = path .. "border_ex_a.tga",
		EB = path .. "border_ex_b.tga",
	},
	shadow = {
		SQ = path .. "shadow_sq.tga",
		RO = path .. "shadow_ro.tga",
		CI = path .. "shadow_ci.tga",
		PI = path .. "shadow_PI.tga",
		EA = path .. "shadow_ex_a.tga",
		EB = path .. "shadow_ex_b.tga",
	},
	inner = {
		SQ = path .. "inner_a.tga",
		RO = path .. "inner_a.tga",
		CI = path .. "inner_b.tga",
		PI = path .. "inner_b.tga",
	},
	mask = {
		CI = path .. "mask_c.tga",
		PI = path .. "mask_c.tga",
		A = {
			SQ = path .. "mask_a.tga",
			RO = path .. "mask_a.tga",
		},
		B = {
			SQ = path .. "mask_b.tga",
			RO = path .. "mask_b.tga",
		},
	},
}

local function setColor(texture, color, mirror)
	if not texture or not color then
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

local function getColor(frame, unit)
	if settings.general.default then
		return settings.colors.default
	end
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if frame.class ~= class then
			frame.class = class
			frame.color = settings.colors[class]
		end
		return frame.color
	else
		local reaction = UnitReaction("player", unit)
		if reaction then
			return settings.colors[reaction <= 3 and "enemy" or reaction == 4 and "neutral" or "friendly"]
		else
			return settings.colors.enemy
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
	texture = textures.texture[settings.general.style][conf.texture]
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
	SetPortraitTexture(frame.portrait, unit, not (conf.texture == "CI"))

	-- Portrait Mask
	texture = textures.mask[conf.texture] or conf.mirror and textures.mask.B[conf.texture] or textures.mask.A[conf.texture]
	frame.mask = frame:CreateMaskTexture()
	frame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	frame.mask:SetAllPoints(frame)
	frame.portrait:AddMaskTexture(frame.mask)

	-- Portrait Shadow
	if settings.shadow.enable then
		texture = textures.shadow[conf.texture]
		frame.shadow = frame:CreateTexture("mMT_Shadow", "OVERLAY", nil, -4)
		frame.shadow:SetAllPoints(frame)
		frame.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.shadow, settings.shadow.color)
		mirrorTexture(frame.shadow, conf.mirror)
	end

	-- Inner Portrait Shadow
	if settings.shadow.inner then
		texture = textures.inner[conf.texture]
		frame.InnerShadow = frame:CreateTexture("mMT_innerShadow", "OVERLAY", nil, 2)
		frame.InnerShadow:SetAllPoints(frame)
		frame.InnerShadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.InnerShadow, settings.shadow.innerColor)
		mirrorTexture(frame.InnerShadow, conf.mirror)
	end

	-- Portrait Border
	if settings.shadow.border then
		texture = textures.border[conf.texture]
		frame.border = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 6)
		frame.border:SetAllPoints(frame)
		frame.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.border, settings.shadow.borderColor)
		mirrorTexture(frame.border, conf.mirror)
	end

	-- Rare/Elite Texture
	if unit == "target" and settings.target.enable and conf.extraEnable then
		-- Texture
		texture = (conf.texture == "CI") and textures.texture[settings.general.style]["EA"] or textures.texture[settings.general.style]["EB"]
		frame.extra = frame:CreateTexture("mMT_Extra", "OVERLAY", nil, -6)
		frame.extra:SetAllPoints(frame)
		frame.extra:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(frame.extra, not conf.mirror)

		-- Shadow
		if settings.shadow.enable then
			texture = (conf.texture == "CI") and textures.shadow.EA or textures.shadow.EB
			frame.extra.shadow = frame:CreateTexture("mMT_Extra", "OVERLAY", nil, -8)
			frame.extra.shadow:SetAllPoints(frame.extra)
			frame.extra.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.shadow, settings.shadow.color)
			mirrorTexture(frame.extra.shadow, not conf.mirror)
			frame.extra.shadow:Hide()
		end

		-- Border
		if settings.shadow.border then
			texture = (conf.texture == "CI") and textures.border.EA or textures.border.EB
			frame.extra.border = frame:CreateTexture("mMT_Border_Extra", "OVERLAY", nil, -4)
			frame.extra.border:SetAllPoints(frame.extra)
			frame.extra.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.border, settings.shadow.borderColorRare)
			mirrorTexture(frame.extra.border, not conf.mirror)
			frame.extra.border:Hide()
		end

		frame.extra:Hide()
	end

	-- Corner
	if settings.general.corner and (conf.texture ~= "CI") then
		texture = textures.texture[settings.general.style].CO
		frame.corner = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 5)
		frame.corner:SetAllPoints(frame)
		frame.corner:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.corner, getColor(frame, unit), conf.mirror)
		mirrorTexture(frame.corner, conf.mirror)

		-- Border
		if settings.shadow.border then
			texture = textures.border.CO
			frame.corner.border = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 6)
			frame.corner.border:SetAllPoints(frame.corner)
			frame.corner.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.corner.border, settings.shadow.borderColor)
			mirrorTexture(frame.corner.border, conf.mirror)
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

local function UpdatePortrait(frame, conf, unit, parent)
	local texture = nil

	-- Portraits Frame
	frame:SetSize(conf.size, conf.size)
	frame:ClearAllPoints()
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)
	frame:SetFrameLevel(parent.Health:GetFrameLevel() + 1)

	-- Portrait Texture
	texture = textures.texture[settings.general.style][conf.texture]
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
	if settings.shadow.enable and frame.shadow then
		texture = textures.shadow[conf.texture]
		frame.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.shadow, settings.shadow.color)
		mirrorTexture(frame.shadow, conf.mirror)
	end

	-- Inner Portrait Shadow
	if settings.shadow.inner and frame.InnerShadow then
		texture = textures.inner[conf.texture]
		frame.InnerShadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.InnerShadow, settings.shadow.innerColor)
		mirrorTexture(frame.InnerShadow, conf.mirror)
	end

	-- Portrait Border
	if settings.shadow.border and frame.border then
		texture = textures.border[conf.texture]
		frame.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.border, settings.shadow.borderColor)
		mirrorTexture(frame.border, conf.mirror)
	end

	-- Rare/Elite Texture
	if unit == "target" and conf.extraEnable and frame.extra then
		-- Texture
		texture = (conf.texture == "CI") and textures.texture[settings.general.style]["EA"] or textures.texture[settings.general.style]["EB"]
		frame.extra:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		mirrorTexture(frame.extra, not conf.mirror)

		-- Shadow
		if settings.shadow.enable and frame.extra.shadow then
			texture = (conf.texture == "CI") and textures.shadow.EA or textures.shadow.EB
			frame.extra.shadow:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.shadow, settings.shadow.color)
			mirrorTexture(frame.extra.shadow, not conf.mirror)
		end

		-- Border
		if settings.shadow.border and frame.extra.border then
			texture = (conf.texture == "CI") and textures.border.EA or textures.border.EB
			frame.extra.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.extra.border, settings.shadow.borderColorRare)
			mirrorTexture(frame.extra.border, not conf.mirror)
		end

		CheckRareElite(frame, unit)
	end

	-- Corner
	if settings.general.corner and frame.corner and (conf.texture ~= "CI") then
		texture = textures.texture[settings.general.style].CO
		frame.corner:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		setColor(frame.corner, getColor(frame, unit), conf.mirror)
		mirrorTexture(frame.corner, conf.mirror)

		-- Border
		if settings.shadow.border and frame.corner.border then
			texture = textures.border.CO
			frame.corner.border:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
			setColor(frame.corner.border, settings.shadow.borderColor)
			mirrorTexture(frame.corner.border, conf.mirror)
		end
		frame.corner:Show()
		frame.corner.border:Show()
	elseif frame.corner then
		frame.corner:Hide()
		frame.corner.border:Hide()
	end
end

function module:UpdatePortraits()
	if module.Player then
		UpdatePortrait(module.Player, settings.player, "player", _G.ElvUF_Player)
	end

	if module.Target then
		UpdatePortrait(module.Target, settings.target, "target", _G.ElvUF_Target)
	end

	if module.Party1 then
		UpdatePortrait(module.Party1, settings.party, _G.ElvUF_PartyGroup1UnitButton1.unit, _G.ElvUF_PartyGroup1UnitButton1)
		UpdatePortrait(module.Party2, settings.party, _G.ElvUF_PartyGroup1UnitButton2.unit, _G.ElvUF_PartyGroup1UnitButton2)
		UpdatePortrait(module.Party3, settings.party, _G.ElvUF_PartyGroup1UnitButton3.unit, _G.ElvUF_PartyGroup1UnitButton3)
		UpdatePortrait(module.Party4, settings.party, _G.ElvUF_PartyGroup1UnitButton4.unit, _G.ElvUF_PartyGroup1UnitButton4)
		UpdatePortrait(module.Party5, settings.party, _G.ElvUF_PartyGroup1UnitButton5.unit, _G.ElvUF_PartyGroup1UnitButton5)
	end
end

function module:Initialize()
	settings = E.db.mMT.portraits

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

	if _G.ElvUF_PartyGroup1UnitButton1 then
		for i = 1, 5 do
			frames["Party" .. i] = {
				parent = _G["ElvUF_PartyGroup1UnitButton" .. i],
				settings = settings.party,
				unit = _G["ElvUF_PartyGroup1UnitButton" .. i].unit,
				events = {
					"PLAYER_ENTERING_WORLD",
					"PLAYER_TARGET_CHANGED",
					"GROUP_ROSTER_UPDATE",
					"PORTRAITS_UPDATED",
				},
				unitEvents = {
					"UNIT_PORTRAIT_UPDATE",
				},
			}
		end
	end

	if settings.general.enable then
		for name, unit in pairs(frames) do
			if unit.settings.enable and unit.parent and not module[name] then
				module[name] = CreatePortrait(unit.parent, unit.settings, unit.unit)

				for _, event in pairs(unit.unitEvents) do
					module[name]:RegisterUnitEvent(event, unit.unit)
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
				SetPortraitTexture(self.portrait, "player", not (settings.player.texture == "CI"))

				if event == "PLAYER_ENTERING_WORLD" then
					setColor(self.texture, getColor(self, "player"), settings.player.mirror)
					if settings.general.corner and (settings.player.texture ~= "CI") then
						setColor(self.corner, getColor(self, "player"), settings.player.mirror)
					end
				end
			end)
			module.Player.ScriptSet = true
		end

		if settings.target.enable and module.Target and not module.Target.ScriptSet then
			module.Target:SetScript("OnEvent", function(self, event)
				SetPortraitTexture(self.portrait, "target", not (settings.target.texture == "CI"))

				if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
					setColor(self.texture, getColor(self, "target"), settings.target.mirror)

					if settings.general.corner and (settings.target.texture ~= "CI") then
						setColor(self.corner, getColor(self, "target"), settings.target.mirror)
					end

					if settings.target.extraEnable then
						CheckRareElite(self, "target")
					else
						self.extra:Hide()
					end
				end
			end)
			module.Target.ScriptSet = true
		end

		if settings.party.enable and module.Party1 and not module.Party1.ScriptSet then
			for i = 1, 5 do
				local frame = _G["ElvUF_PartyGroup1UnitButton" .. i]
				module["Party" .. i]:SetScript("OnEvent", function(self, event)
					if event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
						setColor(self.texture, getColor(self, frame.unit), settings.party.mirror)
						if settings.general.corner and (settings.party.texture ~= "CI") then
							setColor(self.corner, getColor(self, frame.unit), settings.party.mirror)
						end
					end

					SetPortraitTexture(self.portrait, frame.unit, not (settings.party.texture == "CI"))
				end)

				module["Party" .. i].ScriptSet = true
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
