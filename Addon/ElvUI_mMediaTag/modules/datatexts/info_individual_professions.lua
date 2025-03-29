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
local professions = {
	["mMT - Cooking"] = { name = L["Cooking"], icons = { "cooking_a.tga", "cooking_b.tga" } },
	["mMT - Fishing"] = { name = L["Fishing"], icons = { "fishing_a.tga", "fishing_b.tga" } },
	["mMT - Archaeology"] = { name = L["Archaeology"], icons = { "archaeology_a.tga", "archaeology_b.tga" } },
	["mMT - Primary Professions"] = { name = L["Primary Profession"], icons = { "primary_a.tga", "primary_b.tga" } },
	["mMT - Secondary Professions"] = { name = L["Secondary Profession"], icons = { "secondary_a.tga", "secondary_b.tga" } },
}

local player_professions = {}

local function UpdatePlayerProfessions()
	player_professions = {
		["mMT - Cooking"] = select(5, GetProfessions()),
		["mMT - Fishing"] = select(4, GetProfessions()),
		["mMT - Archaeology"] = select(3, GetProfessions()),
		["mMT - Secondary Professions"] = select(2, GetProfessions()),
		["mMT - Primary Professions"] = select(1, GetProfessions()),
	}
end
local function UpdateIcon(name, iconStyle)
	return iconStyle ~= "default" and "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\" .. professions[name].icons[iconStyle == "colored" and 1 or 2]
end

local function UpdateSkillString(skillLevel, maxSkillLevel, skillModifier)
	local skillText = skillModifier ~= 0 and " |cffffffff+|r" .. skillModifier or ""
	return mMT:TC(skillLevel .. "|cffffffff/|r" .. maxSkillLevel, "mark") .. mMT:TC(skillText, "tip")
end

local function GetProfessionInfos(profession)
	local name, icon, skillLevel, maxSkillLevel, _, spellOffset, _, skillModifier = GetProfessionInfo(profession)
	return name, icon, skillLevel, maxSkillLevel, skillModifier, spellOffset + 1
end

local function OnEnter(self)
	if not player_professions[self.name] then UpdatePlayerProfessions() end

	local iconPath = E.db.mMT.datatexts.individual_professions.icon
	local label = mMT:TC(L["Not learned"], "red")
	local profession = player_professions[self.name]

	if profession then
		local name, icon, skillLevel, maxSkillLevel, skillModifier = GetProfessionInfos(profession)
		if iconPath ~= "none" and iconPath ~= "default" then icon = UpdateIcon(self.name, E.db.mMT.datatexts.individual_professions.icon) end
		icon = E:TextureString(icon, ":14:14")
		label = icon .. " " .. mMT:TC(name) .. " " .. (skillLevel ~= maxSkillLevel and UpdateSkillString(skillLevel, maxSkillLevel, skillModifier) or "")
	end

	DT.tooltip:AddLine(mMT:TC(TRADE_SKILLS, "title"))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(label)
	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function OnEvent(self, event)
	if not player_professions[self.name] then UpdatePlayerProfessions() end

	local iconPath = E.db.mMT.datatexts.individual_professions.icon
	local label = L["No Professions"]
	local profession = player_professions[self.name]

	if profession then
		local name, icon, skillLevel, maxSkillLevel, _, spell = GetProfessionInfos(profession)
		professions[self.name].spell = spell

		if iconPath ~= "none" then
			if iconPath ~= "default" then icon = UpdateIcon(self.name, E.db.mMT.datatexts.individual_professions.icon) end
			icon = E:TextureString(icon, ":14:14")

			label = icon .. " " .. format(textString, name) .. " " .. (skillLevel ~= maxSkillLevel and format(valueString, skillLevel) or "")
		else
			label = format(textString, name) .. " " .. (skillLevel ~= maxSkillLevel and format(valueString, skillLevel) or "")
		end
	end

	self.text:SetFormattedText(textString, label)
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
