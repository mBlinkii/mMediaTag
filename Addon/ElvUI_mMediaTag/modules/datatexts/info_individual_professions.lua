local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local CastSpell = CastSpell

local valueString, textString = "", ""
local iconString = "|T%s:14:14:0:0:64:64:5:59:5:59|t"
local professions = {
	["mMT - Cooking"] = { name = L["Cooking"], icons = { "cooking_a.tga", "cooking_b.tga" }, profession = select(5, GetProfessions()) },
	["mMT - Fishing"] = { name = L["Fishing"], icons = { "fishing_a.tga", "fishing_b.tga" }, profession = select(4, GetProfessions()) },
	["mMT - Primary Professions"] = { name = L["Primary Profession"], icons = { "primary_a.tga", "primary_b.tga" }, profession = select(1, GetProfessions()) },
	["mMT - Secondary Professions"] = { name = L["Secondary Profession"], icons = { "secondary_a.tga", "secondary_b.tga" }, profession = select(2, GetProfessions()) },
}

local function UpdateIcon(name, iconStyle)
	return iconStyle ~= "default" and "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\" .. professions[name].icons[iconStyle == "colored" and 1 or 2]
end

local function UpdateSkillString(skillLevel, maxSkillLevel, skillModifier)
	local skillText = skillModifier ~= 0 and " |cffffffff+|r" .. skillModifier or ""
	return mMT:SetTextColor(skillLevel .. "|cffffffff/|r" .. maxSkillLevel, "mark") .. mMT:SetTextColor(skillText, "tip")
end

local function GetProfessionInfos(profession)
	local name, icon, skillLevel, maxSkillLevel, _, spellOffset, _, skillModifier = GetProfessionInfo(profession)
	return name, icon, skillLevel, maxSkillLevel, skillModifier, spellOffset + 1
end

local function OnEnter(self)
	local profession = professions[self.name].profession
	if profession then
		DT.tooltip:AddLine(mMT:SetTextColor(TRADE_SKILLS, "title"))
		DT.tooltip:AddLine(" ")
		local name, icon, skillLevel, maxSkillLevel, skillModifier = GetProfessionInfos(profession)
		icon = E.db.mMT.datatexts.individual_professions.icon and format(iconString, UpdateIcon(self.name, E.db.mMT.datatexts.individual_professions.iconStyle) or icon) or nil
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
	local profession = professions[self.name].profession
	if profession then
		local name, icon, skillLevel, maxSkillLevel, _, spell = GetProfessionInfos(profession)
		professions[self.name].spell = spell
		icon = E.db.mMT.datatexts.individual_professions.icon and format(iconString, UpdateIcon(self.name, E.db.mMT.datatexts.individual_professions.iconStyle) or icon) or nil
		self.text:SetText((icon and (icon .. " ") or "") .. format(textString, name) .. " " .. (skillLevel ~= maxSkillLevel and format(valueString, skillLevel) or ""))
	else
		self.text:SetFormattedText(textString, L["No Professions"])
	end
end

local function OnClick(self)
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	elseif professions[self.name].spell then
		CastSpell(professions[self.name].spell, "Spell")
	end
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex
	textString, valueString = strjoin("", textHex, "%s|r"), strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

for name, data in pairs(professions) do
	DT:RegisterDatatext(name, mMT.Name, { "TRADE_SKILL_DETAILS_UPDATE", "SKILL_LINES_CHANGED" }, OnEvent, nil, OnClick, OnEnter, OnLeave, data.name, nil, ValueColorUpdate)
end
