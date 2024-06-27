local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown

--Variables
local mText = L["second Profession"]
local spell = nil

local function colorText(value, withe)
	if withe then
		return value
	else
		local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
		return hexColor .. value .. "|r"
	end
end
local function OnEnter(self)
	local profession, secondProfession, _, _, _ = GetProfessions()

	if profession or secondProfession then
		DT.tooltip:AddLine(TRADE_SKILLS)
		DT.tooltip:AddLine(" ")

		if profession then
			local name, icon, skillLevel, maxSkillLevel, _, _, _, skillModifier, _, _ = GetProfessionInfo(profession)
			name = format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", icon, name)
			DT.tooltip:AddDoubleLine(name, colorText(skillLevel) .. colorText("/", true) .. colorText(maxSkillLevel) .. colorText(" +", true) .. colorText(skillModifier))
		end

		if secondProfession then
			local name, icon, skillLevel, maxSkillLevel, _, _, _, skillModifier, _, _ = GetProfessionInfo(secondProfession)
			name = format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", icon, name)
			DT.tooltip:AddDoubleLine(name, colorText(skillLevel) .. colorText("/", true) .. colorText(maxSkillLevel) .. colorText(" +", true) .. colorText(skillModifier))
		end
	else
		DT.tooltip:AddLine(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s%s|r", mMT.Media.DockIcons.NOPROF, "|CFFE74C3C", L["No Professions"]))
	end

	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

local function OnEvent(self)
	local _, profession, _, _, _ = GetProfessions()

	if profession then
		local name, icon, skillLevel, maxSkillLevel, _, spellOffset, _, _, _, _ = GetProfessionInfo(profession)
		local isNotMax = not (skillLevel == maxSkillLevel)
		spell = spellOffset + 1

		local text = "%s %s %s"
		icon = E.db.mMT.singleProfession.icon and format("|T%s:14:14:0:0:64:64:5:59:5:59|t", icon) or ""
		text = format(text, icon, colorText(name, E.db.mMT.singleProfession.whiteText), isNotMax and colorText(skillLevel, E.db.mMT.singleProfession.witheValue) or "")

		self.text:SetText(text)
	else
		self.text:SetText(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s|r", mMT.Media.DockIcons.NOPROF, colorText(L["No Professions"], E.db.mMT.singleProfession.whiteText)))
	end
end

local function OnClick()
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	elseif spell then
		CastSpell(spell, "Spell")
	end
end

DT:RegisterDatatext("secondProf", "mMediaTag", { "TRADE_SKILL_DETAILS_UPDATE", "SKILL_LINES_CHANGED" }, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
