local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local _G = _G
local InCombatLockdown = InCombatLockdown
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture
local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local CastSpell = CastSpell

local textString = ""
local dt_icons = {
	prof_a = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_a.tga",
	prof_b = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_b.tga",
	prof_c = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_c.tga",
	prof_d = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_d.tga",
	prof_e = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\primary_a.tga",
	prof_f = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\primary_b.tga",
	prof_g = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\secondary_a.tga",
	prof_h = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\secondary_b.tga",
}

local menu = {}

local function GetProfessionInfos(profession)
	local name, icon, skillLevel, maxSkillLevel, _, spellOffset, _, skillModifier = GetProfessionInfo(profession)
	return name,
		icon,
		spellOffset + 1,
		skillLevel ~= maxSkillLevel and mMT:TC(skillLevel .. "|cffffffff/|r" .. maxSkillLevel, "mark") or "",
		skillModifier ~= 0 and mMT:TC("+" .. skillModifier, "tip") or ""
end

local function GetFireCoolDown()
	local start, duration, text

	if C_Spell then
		local spellCooldownInfo = GetSpellCooldown(818)
		if spellCooldownInfo then
			start = spellCooldownInfo.startTime
			duration = spellCooldownInfo.duration
		end
	else
		start, duration = GetSpellCooldown(818)
	end

	local cooldown = start + duration - GetTime()

	if cooldown >= 2 then
		local hours = math.floor(cooldown / 3600)
		local minutes = math.floor(cooldown / 60)
		local seconds = string.format("%02.f", math.floor(cooldown - minutes * 60))
		if hours >= 1 then
			minutes = math.floor(mod(cooldown, 3600) / 60)
			text = mMT:TC(hours .. "h " .. minutes .. "m", "red")
		else
			text = mMT:TC(minutes .. "m " .. seconds .. "s", "red")
		end
	elseif cooldown <= 0 then
		text = mMT:TC(L["Ready"], "green")
	end

	return text or ""
end

local function UpdatePlayerProfessions(tip)
	local profs = { GetProfessions() }
	local player_professions = { main = {}, secondary = {} }

	local function ProcessProfessions(profArray, target)
		for _, prof in ipairs(profArray) do
			if prof then
				local name, icon, spell, skill, skillModifier = GetProfessionInfos(prof)
				target[prof] = {
					name = name,
					icon = icon,
					spell = spell,
					skill = skill,
					skillModifier = skillModifier,
				}
			end
		end
	end

	-- Handle main professions
	ProcessProfessions({ profs[1], profs[2] }, player_professions.main)

	-- Handle secondary professions
	ProcessProfessions({ profs[3], profs[4], profs[5] }, player_professions.secondary)

	-- Handle extra profession for cooking with specific spell
	if not tip and profs[5] and IsSpellKnown(818) then
		local spellInfo = GetSpellInfo(818)
		local name = spellInfo.name or spellInfo or ""
		player_professions.extra = {
			name = name,
			icon = GetSpellTexture(818),
			spell = name,
			skill = GetFireCoolDown(),
			skillModifier = "",
		}
	end

	return player_professions
end

local function OnEnter(self)
	DT.tooltip:ClearLines()

	local player_professions = UpdatePlayerProfessions(true)

	DT.tooltip:AddLine(mMT:TC(TRADE_SKILLS, "title"))
	DT.tooltip:AddLine(" ")

	local function AddProfessionLines(professions, titleKey)
		if not professions then return end
		DT.tooltip:AddLine(mMT:TC(titleKey, "title"))
		for _, profession in pairs(professions) do
			local name, icon, skill, skillModifier = profession.name, profession.icon, profession.skill, profession.skillModifier
			local lineLeft = E.db.mMT.datatexts.professions.menu_icons and (E:TextureString(icon, ":14:14") .. " " .. name) or name
			local lineRight = skill .. " " .. skillModifier
			DT.tooltip:AddDoubleLine(lineLeft, lineRight, 1, 1, 1, 1, 1, 1)
		end
	end

	if player_professions.main or player_professions.secondary then
		-- Add main professions
		if player_professions.main then
			AddProfessionLines(player_professions.main, L["Main Professions"])
		else
			DT.tooltip:AddLine(mMT:TC(L["No Main Professions"], "red"))
		end

		-- Add secondary professions
		if player_professions.secondary then
			if player_professions.main then DT.tooltip:AddLine(" ") end
			AddProfessionLines(player_professions.secondary, L["Secondary Professions"])
		else
			DT.tooltip:AddLine(mMT:TC(L["No Secondary Professions"], "red"))
		end
	else
		DT.tooltip:AddLine(mMT:TC(L["No Professions"], "red"))
	end

	DT.tooltip:Show()
end

local function UpdateMenu()
	local player_professions = UpdatePlayerProfessions()
	menu = {}

	local function AddProfessionLines(professions, titleKey, noProfessionsKey)
		if not professions then
			tinsert(menu, { text = mMT:TC(noProfessionsKey, "red"), notClickable = true })
			return
		end

		tinsert(menu, { text = mMT:TC(titleKey, "title"), isTitle = true, notClickable = true })
		for _, profession in pairs(professions) do
			local name, icon, spell, skill, skillModifier = profession.name, profession.icon, profession.spell, profession.skill, profession.skillModifier
			tinsert(menu, {
				text = name,
				right_text = skill .. " " .. skillModifier,
				icon = E.db.mMT.datatexts.professions.menu_icons and icon,
				func = function()
					CastSpell(spell, "Spell")
				end,
			})
		end
	end

	-- Add title and spacing
	tinsert(menu, { text = mMT:TC(TRADE_SKILLS, "title"), isTitle = true, notClickable = true })
	tinsert(menu, { text = " ", isTitle = true, notClickable = true })

	-- Add main professions
	if player_professions.main then
		AddProfessionLines(player_professions.main, L["Main Professions"], L["No Main Professions"])
	else
		tinsert(menu, { text = mMT:TC(L["No Main Professions"], "red"), notClickable = true })
	end

	-- Add secondary professions
	if player_professions.secondary then
		if player_professions.main then tinsert(menu, { text = " ", isTitle = true, notClickable = true }) end
		AddProfessionLines(player_professions.secondary, L["Secondary Professions"], L["No Secondary Professions"])
	else
		tinsert(menu, { text = mMT:TC(L["No Secondary Professions"], "red"), notClickable = true })
	end

	-- Add extra professions
	if player_professions.extra then
		tinsert(menu, { text = " ", isTitle = true, notClickable = true })
		tinsert(menu, { text = mMT:TC(L["Miscellaneous"], "title"), isTitle = true, notClickable = true })

		local name, icon, spell, skill = player_professions.extra.name, player_professions.extra.icon, player_professions.extra.spell, player_professions.extra.skill
		tinsert(menu, {
			text = name,
			right_text = skill,
			icon = E.db.mMT.datatexts.professions.menu_icons and icon,
			macro = "/cast " .. name,
		})
	end

	-- Handle no professions case
	if not player_professions.main and not player_professions.secondary and not player_professions.extra then tinsert(menu, { text = mMT:TC(L["No Professions"], "red"), notClickable = true }) end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function OnEvent(self)
	local label = TRADE_SKILLS
	if E.db.mMT.datatexts.professions.icon ~= "none" then
		local icon = dt_icons[E.db.mMT.datatexts.professions.icon]
		if E.db.mMT.datatexts.individual_professions.icon == "auto" then
			local main_profession = select(1, GetProfessions())
			if main_profession then icon = select(2, GetProfessionInfos(main_profession)) end
		end
		icon = E:TextureString(icon, ":14:14")

		label = icon .. " " .. TRADE_SKILLS
	end

	self.text:SetFormattedText(textString, label)
end

local function OnClick(self)
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	else
		if not mMT.menu then mMT:BuildMenus() end

		UpdateMenu()
		mMT:DropDown(menu, mMT.menu, self, 260, 2)
	end
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	textString = strjoin("", textHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mMT - " .. TRADE_SKILLS, mMT.Name, { "TRADE_SKILL_DETAILS_UPDATE", "SKILL_LINES_CHANGED" }, OnEvent, nil, OnClick, OnEnter, OnLeave, TRADE_SKILLS, nil, ValueColorUpdate)
