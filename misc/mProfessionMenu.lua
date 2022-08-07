local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local tinsert = tinsert
local format = format
local wipe = wipe

--WoW API / Variables
local _G = _G
local GetProfessions = GetProfessions

--Variables
local mText = L["Professions"]
local menuFrame = CreateFrame("Frame", "mProfessionMenu", E.UIParent, "BackdropTemplate")
menuFrame:SetTemplate("Transparent", true)
local ProfessionsList = {}
local ProfessionsColor = {
	[129] = "|CFFF32AFC", -- First Aid
	[164] = "|CFFFAEAAD", -- Blacksmithing
	[165] = "|CFFBD6803", -- Leatherworking
	[171] = "|CFFAAFF00", -- Alchemy
	[182] = "|CFF00FA7D", -- Herbalism
	[185] = "|CFFFDDA16", -- Cooking
	[186] = "|CFFE1CDF7", -- Mining
	[197] = "|CFF46A5F4", -- Tailoring
	[202] = "|CFFFFAB86", -- Engineering
	[333] = "|CFF9386FF", -- Enchanting
	[356] = "|CFF0061FF", -- Fishing
	[393] = "|CFFB94900", -- Skinning
	[755] = "|CFF4D00FF", -- Jewelcrafting
	[773] = "|CFFFEE4E9", -- Inscription
	[794] = "|CFFE4FEF1", -- Archeology
}

local function getProfName(index)
	local name, icon, _, _, _, _, skillLine, _, _, _ = GetProfessionInfo(index)
	return format("%s%s|r", ProfessionsColor[skillLine], name)
end

local function getProfIcon(index)
	if E.db[mPlugin].mProfIcon then
		local _, icon, _, _, _, _, _, _, _, _ = GetProfessionInfo(index)
		return mMT:mIcon(icon) .. "    "
	else
		return ""
	end
end

local function getProfSkill(index)
	local mskillModifier = "none"
	local _, _, _, _, other, titel, tip = mMT:mColorDatatext()
	local _, _, skillLevel, maxSkillLevel, _, _, _, skillModifier, _, _ = GetProfessionInfo(index)

	if skillModifier ~= 0 then
		mskillModifier = format(" %s+%s|r", "|CFF68FF00", skillModifier)
	else
		mskillModifier = ""
	end

	if skillLevel == maxSkillLevel then
		return format("%s[|r%s%s|r%s%s]|r", other, "|CFF3AFF00", skillLevel, mskillModifier, other)
	else
		local color = "|CFF9BFF00"
		local SkillPercent = tonumber(mMT:round(skillLevel / maxSkillLevel * 100))

		if SkillPercent >= 75 then
			color = "|CFF9BFF00"
		elseif SkillPercent >= 50 and SkillPercent <= 75 then
			color = "|CFFF3FF00"
		elseif SkillPercent >= 25 and SkillPercent <= 50 then
			color = "|CFFFFC900"
		elseif SkillPercent >= 0 and SkillPercent <= 25 then
			color = "|CFFFF6800"
		end

		return format(
			"%s[|r%s%s|r%s%s/|r%s%s|r%s]|r",
			other,
			color,
			skillLevel,
			mskillModifier,
			other,
			"|CFF00B9FF",
			maxSkillLevel,
			other
		)
	end
end

local function castProf(index)
	local _, _, _, _, _, spelloffset, _, _, _, _ = GetProfessionInfo(index)
	CastSpell(spelloffset + 1, "Spell")
end

local function InsertList(index, textA, textB, title, spell)
	if spell == nil then
		tinsert(
			ProfessionsList.List,
			index,
			{ lefttext = textA, righttext = textB, isTitle = title, func = function() end }
		)
	else
		tinsert(ProfessionsList.List, index, {
			lefttext = textA,
			righttext = textB,
			isTitle = title,
			func = function()
				castProf(spell)
			end,
		})
	end
end

local function LoadProfessions()
	local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
	local _, _, _, _, other, titel, tip = mMT:mColorDatatext()
	wipe(ProfessionsList)
	local Index = 1

	ProfessionsList["Loaded"] = false
	ProfessionsList["Index"] = Index
	ProfessionsList["NoProfession"] = (
		(archaeology == nil)
		and (cooking == nil)
		and (fishing == nil)
		and (prof1 == nil)
		and (prof2 == nil)
	)
	ProfessionsList["NoMainProfession"] = ((prof1 == nil) and (prof2 == nil))
	ProfessionsList["NoSecondaryProfession"] = ((archaeology == nil) and (cooking == nil) and (fishing == nil))
	ProfessionsList["List"] = {}

	if not ProfessionsList.NoProfession then
		if ProfessionsList.NoMainProfession then
			InsertList(Index, format("%s%s|r", "|CFFE74C3C", L["No Main Professions"]), nil, true, nil)
			Index = Index + 1
		else
			InsertList(Index, format("%s%s|r", titel, L["Main Professions"]), nil, true, nil)
			Index = Index + 1

			if prof1 ~= nil then
				InsertList(
					Index,
					format("%s%s%s|r", getProfIcon(prof1), other, getProfName(prof1)),
					getProfSkill(prof1),
					false,
					prof1
				)
				Index = Index + 1
			end

			if prof2 ~= nil then
				InsertList(
					Index,
					format("%s%s%s|r", getProfIcon(prof2), other, getProfName(prof2)),
					getProfSkill(prof2),
					false,
					prof2
				)
				Index = Index + 1
			end
		end

		InsertList(Index, "", nil, true, nil)
		Index = Index + 1

		if (archaeology == nil) and (cooking == nil) and (firstAid == nil) and (fishing == nil) then
			InsertList(Index, format("%s%s|r", "|CFFE74C3C", L["No Secondary Professions"]), nil, true, nil)
			Index = Index + 1
		else
			InsertList(Index, format("%s%s|r", titel, L["Secondary Professions"]), nil, true, nil)
			Index = Index + 1

			if archaeology ~= nil then
				InsertList(
					Index,
					format("%s%s%s|r", getProfIcon(archaeology), other, getProfName(archaeology)),
					getProfSkill(archaeology),
					false,
					archaeology
				)
				Index = Index + 1
			end

			if cooking ~= nil then
				InsertList(
					Index,
					format("%s%s%s|r", getProfIcon(cooking), other, getProfName(cooking)),
					getProfSkill(cooking),
					false,
					cooking
				)
				Index = Index + 1
			end

			if fishing ~= nil then
				InsertList(
					Index,
					format("%s%s%s|r", getProfIcon(fishing), other, getProfName(fishing)),
					getProfSkill(fishing),
					false,
					fishing
				)
				Index = Index + 1
			end
		end
		ProfessionsList["Index"] = Index - 1
	end
end

local function mLoadTooltip()
	local _, _, _, _, other, titel, tip = mMT:mColorDatatext()

	LoadProfessions()

	if ProfessionsList.NoProfession then
		DT.tooltip:AddLine(format("%s%s|r", "|CFFE74C3C", L["No Professions|r"]))
	else
		for i = 1, ProfessionsList.Index, 1 do
			if not ProfessionsList.List[i].isTitle then
				DT.tooltip:AddDoubleLine(ProfessionsList.List[i].lefttext, ProfessionsList.List[i].righttext)
			end
		end
	end

	DT.tooltip:AddLine(L[" "])
	DT.tooltip:AddLine(format("%s %s%s|r", ns.RightButtonIcon, tip, L["left click to open the menu."]))
	DT.tooltip:AddLine(format("%s %s%s|r", ns.RightButtonIcon, tip, L["right click to open the profession window."]))
end

local function OnClick(self, button)
	DT.tooltip:Hide()
	if button == "LeftButton" then
		if ProfessionsList.NoProfession then
			_G.UIErrorsFrame:AddMessage(format(L["%s: %sNo professions available!|r"], ns.mName, ns.mColor5))
			print(format(L["%s: %sNo professions available!|r"], ns.mName, ns.mColor5))
		else
			LoadProfessions()
			mMT:mDropDown(ProfessionsList.List, menuFrame, self, 200, 2)
		end
	else
		if mMT:CheckCombatLockdown() then
			if not SpellBookFrame:IsShown() then
				ShowUIPanel(SpellBookFrame)
			else
				HideUIPanel(SpellBookFrame)
			end
		end
	end
end

local function OnEnter(self)
	DT.tooltip:AddLine(L["Professions"])
	mLoadTooltip()
	DT.tooltip:Show()
end

local function OnEvent(self, event, unit)
	local TextString = mText
	if E.db[mPlugin].ProfessionMenu.showicon then
		TextString = format(
			"|T%s:16:16:0:0:128:128|t %s",
			"Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\profession.tga",
			mText
		)
	end

	self.text:SetFormattedText(mMT:mClassColorString(), TextString)
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mProfessions", "mMediaTag", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)
