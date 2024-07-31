local E = unpack(ElvUI)
local L = mMT.Locales

--Lua functions
local string = string
local format = format
local wipe = wipe
local tinsert = tinsert

--WoW API / Variables
local GetInstanceInfo = GetInstanceInfo
local C_MythicPlus = C_MythicPlus
local GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture
local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown

local totalDurability = 0
local invDurability = {}
local totalRepairCost

local slots = {
	[1] = _G.INVTYPE_HEAD,
	[3] = _G.INVTYPE_SHOULDER,
	[5] = _G.INVTYPE_CHEST,
	[6] = _G.INVTYPE_WAIST,
	[7] = _G.INVTYPE_LEGS,
	[8] = _G.INVTYPE_FEET,
	[9] = _G.INVTYPE_WRIST,
	[10] = _G.INVTYPE_HAND,
	[16] = _G.INVTYPE_WEAPONMAINHAND,
	[17] = _G.INVTYPE_WEAPONOFFHAND,
	[18] = _G.INVTYPE_RANGED,
}

function mMT:GetDurabilityInfo()
	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc, repairCost = (currentDura / maxDura) * 100, 0
			invDurability[index] = perc

			if perc < totalDurability then
				totalDurability = perc
			end

			if E.Retail and E.ScanTooltip.GetTooltipData then
				E.ScanTooltip:SetInventoryItem("player", index)
				E.ScanTooltip:Show()

				local data = E.ScanTooltip:GetTooltipData()
				repairCost = data and data.repairCost
			else
				repairCost = select(3, E.ScanTooltip:SetInventoryItem("player", index))
			end

			totalRepairCost = totalRepairCost + (repairCost or 0)
		end
	end

	local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	local hex = E:RGBToHex(r, g, b)

	return { durability = format("%s%d%%|r", hex, totalDurability), repair = ((totalRepairCost ~= 0) and GetMoneyString(totalRepairCost)) or nil }
end

-- local Currency = {
-- 	info = {
-- 		color = "|CFFFF8000",
-- 		id = 204194,
-- 		name = nil,
-- 		icon = nil,
-- 		link = nil,
-- 		count = nil,
--         cap = nil,
-- 	},
-- 	bag = {
-- 		id = 204078,
-- 		link = nil,
-- 		icon = nil,
-- 		count = nil,
-- 	},
-- 	fragment = {
-- 		id = 2412,
-- 		cap = nil,
-- 		quantity = nil,
-- 	},
-- 	loaded = false,
-- }
function mMT:GetCurrenciesInfo(tbl, item)
	if tbl and tbl.info and tbl.info.id then
		local itemName, itemLink, itemTexture, itemStackCount = nil, nil, nil, nil
		local info = nil

		if item then
			itemName, itemLink, _, _, _, _, _, itemStackCount, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(tbl.info.id)
			if itemName and itemLink and itemTexture then
				tbl.info.name = itemName
				tbl.info.icon = mMT:mIcon(itemTexture, 12, 12)
				tbl.info.link = itemLink
				tbl.info.count = GetItemCount(tbl.info.id, true)
				tbl.info.cap = itemStackCount
				tbl.loaded = true
			end
		else
			info = C_CurrencyInfo_GetCurrencyInfo(tbl.info.id)
			if info then
				tbl.info.name = info.name
				tbl.info.icon = mMT:mIcon(info.iconFileID, 12, 12)
				tbl.info.link = mMT:mCurrencyLink(tbl.info.id)
				tbl.info.count = info.quantity
				tbl.loaded = true
				if not tbl.fragment and info.maxQuantity then
					tbl.info.cap = info.maxQuantity
				end
			end
		end

		if tbl.bag and tbl.bag.id then
			itemName, itemLink, _, _, _, _, _, _, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(tbl.bag.id)
			if itemName and itemLink and itemTexture then
				tbl.bag.link = itemLink
				tbl.bag.icon = mMT:mIcon(itemTexture, 12, 12)
				tbl.bag.count = GetItemCount(tbl.bag.id, true)
			end
		end

		if tbl.fragment and tbl.fragment.id then
			info = C_CurrencyInfo_GetCurrencyInfo(tbl.fragment.id)
			if info then
				tbl.fragment.cap = info.maxQuantity
				tbl.fragment.quantity = info.quantity or 0
			end
		end
	else
		error(L["GetCurrenciesInfo no Table or no ID."])
	end
end

--Dungeon Difficulty
function mMT:DungeonDifficultyShort()
	local _, _, instanceDifficultyID, difficultyName, _, _, _ = GetInstanceInfo()
	local nhc, hc, myth, mythp, other, _ = mMT:mColorDatatext()

	if instanceDifficultyID == 1 or instanceDifficultyID == 3 or instanceDifficultyID == 4 or instanceDifficultyID == 14 then
		return format("%s%s|r", nhc, "N")
	elseif instanceDifficultyID == 2 or instanceDifficultyID == 5 or instanceDifficultyID == 6 or instanceDifficultyID == 15 or instanceDifficultyID == 39 or instanceDifficultyID == 149 then
		return format("%s%s|r", hc, "H")
	elseif instanceDifficultyID == 23 or instanceDifficultyID == 16 or instanceDifficultyID == 40 then
		return format("%s%s|r", myth, "M")
	elseif instanceDifficultyID == 8 then
		local keyStoneLevel, _ = C_ChallengeMode.GetActiveKeystoneInfo()
		local r, g, b = E:ColorGradient(keyStoneLevel * 0.06, 0.1, 1, 0.1, 1, 1, 0.1, 1, 0.1, 0.1)
		if keyStoneLevel ~= nil and C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
			return format("%sM|r%s+%s|r", mythp, E:RGBToHex(r, g, b), keyStoneLevel)
		else
			return format("%s%s|r", mythp, "M+")
		end
	elseif instanceDifficultyID == 24 then
		return format("%s%s|r", "|CFF85C1E9", E:ShortenString(difficultyName, 1))
	elseif instanceDifficultyID == 167 then
		return format("%s%s|r", "|CFFF4D03F", E:ShortenString(difficultyName, 1))
	else
		return format("%s%s|r", other, E:ShortenString(difficultyName, 1))
	end
end

-- professions
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

-- list = tbl see below
-- text = string, Secondtext = string, color = color string for first text, icon = texture, func = function, funcOnEnter = function,
-- funcOnLeave = function, isTitle = bolean, macro = macrotext, tooltip = id or var you can use for the functions, notClickable = bolean

local function getProfSkill(skillLevel, maxSkillLevel, skillModifier)
	local text = nil
	local sm = nil
	local colorTip = E.db.mMT.datatextcolors.colorother.hex

	if skillModifier ~= 0 then
		sm = format(" %s+%s|r", "|CFF68FF00", skillModifier)
	end

	if skillLevel == maxSkillLevel then
		text = format("%s[|r%s%s|r%s%s]|r", colorTip, "|CFF3AFF00", skillLevel, sm or "", colorTip)
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

		text = format("%s[|r%s%s|r%s%s/|r%s%s|r%s]|r", colorTip, color, skillLevel, sm or "", colorTip, "|CFF00B9FF", maxSkillLevel, colorTip)
	end

	return text
end

local function GetProfInfo(prof)
	local name, icon, skillLevel, maxSkillLevel, _, spelloffset, skillLine, skillModifier, _, _ = GetProfessionInfo(prof)
	return { name = name, color = ProfessionsColor[skillLine], icon = icon, skill = getProfSkill(skillLevel, maxSkillLevel, skillModifier), spell = spelloffset }
end

local function BuildProfTable()
	local prof1, prof2, arch, fish, cook, firstaid = GetProfessions()
	local tbl = {
		main = {},
		secondary = {},
		nomain = false,
		nosecondary = false,
		cook = false,
		firstaid = false,
	}

	if not prof1 and prof2 then
		tbl.nomain = true
	else
		if prof1 then
			tinsert(tbl.main, 1, GetProfInfo(prof1))
		end

		if prof2 then
			tinsert(tbl.main, 2, GetProfInfo(prof2))
		end

		tbl.nomain = false
	end

	if not arch and not fish and not cook and not firstaid then
		tbl.nosecondary = true
	else
		if arch then
			tinsert(tbl.secondary, 1, GetProfInfo(arch))
		end

		if fish then
			tinsert(tbl.secondary, 2, GetProfInfo(fish))
		end

		if cook then
			tinsert(tbl.secondary, 3, GetProfInfo(cook))
			tbl.cook = true
		end

		if firstaid then
			tinsert(tbl.secondary, 3, GetProfInfo(firstaid))
			tbl.firstaid = true
		end

		tbl.nosecondary = false
	end

	return tbl
end

local function castProf(spell)
	CastSpell(spell + 1, "Spell")
end

local function InsertInTable(tbl, textA, textB, title, icon, color, spell)
	if spell then
		tinsert(tbl, {
			text = textA,
			Secondtext = textB,
			color = color,
			icon = icon,
			isTitle = title,
			notClickable = title,
			func = function()
				castProf(spell)
			end,
		})
	else
		-- text = string, Secondtext = string, color = color string for first text, icon = texture, func = function, funcOnEnter = function,
		-- funcOnLeave = function, isTitle = bolean, macro = macrotext, tooltip = id or var you can use for the functions, notClickable = bolean
		tinsert(tbl, { text = textA, Secondtext = textB, isTitle = title, notClickable = title, func = function() end })
	end
end

local function GetFireCD()
	local start, duration
	if C_Spell then
		local spellCooldownInfo = GetSpellCooldown(818)
		start = spellCooldownInfo.startTime
		duration = spellCooldownInfo.duration
	else
		start, duration = GetSpellCooldown(818)
	end

	local cooldown = start + duration - GetTime()
	if cooldown <= 0 then
		return ""
	else
		local minutes = math.floor(cooldown / 60)
		local seconds = string.format("%02.f", math.floor(cooldown - minutes * 60))
		return "|cffdb3030" .. minutes .. "m " .. seconds .. "s|r"
	end
end

function mMT:GetProfessions(tooltip)
	local MenuTable = {}
	local ProfTable = BuildProfTable()
	local textA = ""

	if not ProfTable.nomain or not ProfTable.nosecondary then
		if ProfTable.nomain then
			textA = "|CFFE74C3C" .. L["No Main Professions"] .. "|r"
			InsertInTable(MenuTable, textA, nil, true)
		else
			textA = E.db.mMT.datatextcolors.colortitle.hex .. L["Main Professions"] .. "|r"
			InsertInTable(MenuTable, textA, nil, true)

			for i, prof in pairs(ProfTable.main) do
				InsertInTable(MenuTable, prof.name, prof.skill, false, prof.icon, prof.color, prof.spell)
			end
		end

		if ProfTable.nosecondary then
			InsertInTable(MenuTable, "", nil, true)
			textA = "|CFFE74C3C" .. L["No Secondary Professions"] .. "|r"
			InsertInTable(MenuTable, textA, nil, true)
		else
			InsertInTable(MenuTable, "", nil, true)
			textA = E.db.mMT.datatextcolors.colortitle.hex .. L["Secondary Professions"] .. "|r"
			InsertInTable(MenuTable, textA, nil, true)

			for i, prof in pairs(ProfTable.secondary) do
				InsertInTable(MenuTable, prof.name, prof.skill, false, prof.icon, prof.color, prof.spell)
			end
		end

		if not tooltip then
			InsertInTable(MenuTable, "", nil, true)
			textA = E.db.mMT.datatextcolors.colortitle.hex .. L["Others"] .. "|r"
			InsertInTable(MenuTable, textA, nil, true)
			tinsert(MenuTable, { text = format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", "136241", TRADE_SKILLS), color = "|CFFBC26E5", isTitle = false, func = function() ToggleProfessionsBook() end })

			if ProfTable.cook and IsSpellKnown(818) then
				local texture = GetSpellTexture(818)
				local spellInfo = GetSpellInfo(818)
				local name = spellInfo.name or ""
				tinsert(MenuTable, {
					text = format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", texture, name),
					Secondtext = GetFireCD(),
					color = "|CFFFF9B00",
					isTitle = false,
					macro = "/cast " .. name,
				})
			end
		end
		return MenuTable
	end
end
