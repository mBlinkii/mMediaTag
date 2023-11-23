local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local LAC = LibStub("LibAddonCompat-1.0")

local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown

--Variables
local mText = L["second Profession"]
local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)

local spell = nil

local function colorText(value, withe)
	if withe then
		return value
	else
		return hexColor .. value .. "|r"
	end
end
local function OnEnter(self)
	local profession, secondProfession, _, _, _ = LAC:GetProfessions()

	if profession or secondProfession then
		DT.tooltip:AddLine(TRADE_SKILLS)
		DT.tooltip:AddLine(" ")

		if profession then
			local name, icon, skillLevel, maxSkillLevel, _, _, _, skillModifier, _, _ = LAC:GetProfessionInfo(profession)
			name = format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", icon, name)
			DT.tooltip:AddDoubleLine(name, colorText(skillLevel) .. colorText("/", true) .. colorText(maxSkillLevel) .. colorText(" +", true) .. colorText(skillModifier))
		end

		if secondProfession then
			local name, icon, skillLevel, maxSkillLevel, _, _, _, skillModifier, _, _ = LAC:GetProfessionInfo(secondProfession)
			name = format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", icon, name)
			DT.tooltip:AddDoubleLine(name, colorText(skillLevel) .. colorText("/", true) .. colorText(maxSkillLevel) .. colorText(" +", true) .. colorText(skillModifier))
		end
	else
		DT.tooltip:AddLine(format("%s%s|r", "|CFFE74C3C", L["No Professions|r"]))
	end

	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function OnEvent(self)
	hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)

	local _, profession, _, _, _ = LAC:GetProfessions()

	if profession then
		local name, icon, skillLevel, maxSkillLevel, _, spellOffset, _, _, _, _ = LAC:GetProfessionInfo(profession)
		local isNotMax = not (skillLevel == maxSkillLevel)

		if spellOffset then
			spell = spellOffset + 1
		end

		local text = "%s %s %s"
		icon = E.db.mMT.singleProfession.icon and format("|T%s:14:14:0:0:64:64:5:59:5:59|t", icon) or ""
		text = format(text, icon, colorText(name, E.db.mMT.singleProfession.whiteText), isNotMax and colorText(skillLevel, E.db.mMT.singleProfession.witheValue) or "")

		self.text:SetText(text)
	end
end

local function OnClick()
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	elseif spell then
		CastSpell(spell, "Spell")
	end
end

DT:RegisterDatatext("secondProf", "mMediaTag", "SKILL_LINES_CHANGED", OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
