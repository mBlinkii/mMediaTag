local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local CastSpell = CastSpell

local spell, profession = nil, nil
local valueString, textString = "", ""
local iconString = "|T%s:14:14:0:0:64:64:5:59:5:59|t"
local customIcons = {
	colored = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\cooking_a.tga",
	white = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\cooking_b.tga",
}

local function UpdateIcon(iconStyle)
	return iconStyle ~= "default" and customIcons[iconStyle]
end

local function UpdateSkillString(skillLevel, maxSkillLevel, skillModifier)
	local skillText = (skillModifier ~= 0) and " |cffffffff+|r" .. skillModifier or ""
	return mMT:SetTextColor(skillLevel .. "|cffffffff/|r" .. maxSkillLevel, "mark") .. mMT:SetTextColor(skillText, "tip")
end

local function OnEnter(self)
	profession = select(5, GetProfessions())
	if profession then
		DT.tooltip:AddLine(mMT:SetTextColor(TRADE_SKILLS, "title"))
		DT.tooltip:AddLine(" ")

		local name, icon, skillLevel, maxSkillLevel, _, _, _, skillModifier = GetProfessionInfo(profession)
		icon = E.db.mMT.datatexts.individual_professions.icon and format(iconString, UpdateIcon(E.db.mMT.datatexts.individual_professions.iconStyle) or icon) or nil

		DT.tooltip:AddDoubleLine((icon and (icon .. " ") or "") .. mMT:SetTextColor(name), UpdateSkillString(skillLevel, maxSkillLevel, skillModifier))
	else
		DT.tooltip:AddLine(mMT:SetTextColor(L["Not learned"], "red"))
	end
	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function OnEvent(self)
	profession = select(5, GetProfessions())
	if profession then
		local name, icon, skillLevel, maxSkillLevel, _, spellOffset = GetProfessionInfo(profession)
		spell = spellOffset + 1

		icon = E.db.mMT.datatexts.individual_professions.icon and format(iconString, UpdateIcon(E.db.mMT.datatexts.individual_professions.iconStyle) or icon) or nil
		self.text:SetText((icon and (icon .. " ") or "") .. format(textString, name) .. " " .. (skillLevel ~= maxSkillLevel and format(valueString, skillLevel) or ""))
	else
		self.text:SetFormattedText(textString, L["No Professions"])
	end
end

local function OnClick()
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	elseif spell then
		CastSpell(spell, "Spell")
	end
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex
	textString, valueString = strjoin("", textHex, "%s|r"), strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mMT - Cooking", mMT.Name, { "TRADE_SKILL_DETAILS_UPDATE", "SKILL_LINES_CHANGED" }, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Cooking"], nil, ValueColorUpdate)
