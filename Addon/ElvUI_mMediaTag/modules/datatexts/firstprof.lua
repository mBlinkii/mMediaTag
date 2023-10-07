local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown

--Variables
local mText = L["first Profession"]
local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)

local spell = nil
local function OnEnter(self)
	local profession, secondProfession, _, _, _ = GetProfessions()

	if profession or secondProfession then
		DT.tooltip:AddLine(TRADE_SKILLS)
		DT.tooltip:AddLine(" ")

		if profession then
            local name, icon, skillLevel, maxSkillLevel, _, _, _, skillModifier, _, _ = GetProfessionInfo(profession)
			DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", icon, name), hexColor .. skillLevel .. "|CFFFFFFFF/|r" .. maxSkillLevel .. " +" .. skillModifier .. "|r")
		end

        if secondProfession then
            local name, icon, skillLevel, maxSkillLevel, _, _, _, skillModifier, _, _ = GetProfessionInfo(secondProfession)
			DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", icon, name), hexColor .. skillLevel .. "|CFFFFFFFF/|r" .. maxSkillLevel .. " +" .. skillModifier .. "|r")
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

	local profession, _, _, _, _ = GetProfessions()

	local name, icon, skillLevel, _, _, spellOffset, _, _, _, _ = GetProfessionInfo(profession)

	spell = spellOffset + 1

	self.text:SetText(format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", icon, name) .. " " .. hexColor .. skillLevel .. "|r")
end

local function OnClick()
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	elseif spell then
		CastSpell(spell, "Spell")
	end
end

DT:RegisterDatatext("firstProf", "mMediaTag", "TRADE_SKILL_DETAILS_UPDATE", OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
