local E = unpack(ElvUI)
local L = mMT.Locales

--Lua functions
local string = string
local gmatch, gsub, format = gmatch, gsub, format
local wipe = wipe
local strmatch = strmatch
local utf8lower, utf8sub = string.utf8lower, string.utf8sub
local mInsert = table.insert

--WoW API / Variables
local _G = _G

local GetDungeonDifficultyID, GetRaidDifficultyID, GetLegacyRaidDifficultyID = GetDungeonDifficultyID, GetRaidDifficultyID, GetLegacyRaidDifficultyID
local GetInstanceInfo, GetDifficultyInfo = GetInstanceInfo, GetDifficultyInfo

function mMT:BuildMenus()
	mMT.menu = CreateFrame("Frame", "mMediaTag_Main_Menu_Frame", E.UIParent, "BackdropTemplate")
	mMT.menu:SetTemplate("Transparent", true)

	mMT.submenu = CreateFrame("Frame", "mMediaTag_Submenu_Frame", E.UIParent, "BackdropTemplate")
	mMT.submenu:SetTemplate("Transparent", true)
end

function mMT:mColorGradient(level)
	local r, g, b = E:ColorGradient(level * 0.04, 0, 0.43, 0.86, 0.63, 0.2, 0.93, 0.89, 0.16, 0.31)
	return E:RGBToHex(r, g, b)
end

function mMT:mAbbrev(text)
	local letters, lastWord = "", strmatch(text, ".+%s(.+)$")
	if lastWord then
		for word in gmatch(text, ".-%s") do
			local firstLetter = utf8sub(gsub(word, "^[%s%p]*", ""), 1, 1)
			if firstLetter ~= utf8lower(firstLetter) then letters = format("%s%s. ", letters, firstLetter) end
		end
		text = format("%s%s", letters, lastWord)
	end
	return text
end

--Color for various Functions
function mMT:mColorDatatext()
	local nhc, hc, myth, mythp, other, title, tip =
		E.db.mMT.datatextcolors.colornhc.hex,
		E.db.mMT.datatextcolors.colorhc.hex,
		E.db.mMT.datatextcolors.colormyth.hex,
		E.db.mMT.datatextcolors.colormythplus.hex,
		E.db.mMT.datatextcolors.colorother.hex,
		E.db.mMT.datatextcolors.colortitle.hex,
		E.db.mMT.datatextcolors.colortip.hex
	return nhc, hc, myth, mythp, other, title, tip
end

--Instance Settings Player
function mMT:InstanceInfo()
	local DungeonDifficultyID, RaidDifficultyID, LegacyRaidDifficultyID = GetDungeonDifficultyID(), GetRaidDifficultyID(), E.Retail and GetLegacyRaidDifficultyID()
	if not (DungeonDifficultyID or RaidDifficultyID or LegacyRaidDifficultyID) then return end
	local InctanceInfoText = {}
	local nhc, hc, myth, _, other, title = mMT:mColorDatatext()

	table.insert(InctanceInfoText, format("%s%s|r", title, L["Instance Difficulty"]))

	local DifficultyColors = {
		[1] = nhc,
		[2] = hc,
		[3] = nhc,
		[6] = hc,
		[5] = hc,
		[4] = nhc,
		[14] = nhc,
		[15] = hc,
		[16] = myth,
		[23] = myth,
		[38] = nhc,
		[39] = hc,
		[40] = myth,
		[173] = nhc,
		[174] = hc,
		[175] = nhc,
		[193] = nhc,
		[194] = hc,
		[198] = nhc,
		[201] = nhc,
	}

	local function addInstanceInfo(difficultyID, difficultyType)
		local name = select(1, GetDifficultyInfo(difficultyID)) or L["UNKNOWN"] .. " " .. tostring(difficultyID)
		table.insert(InctanceInfoText, format("%s%s:|r %s%s|r", other, difficultyType, DifficultyColors[difficultyID] or other, name))
	end

	if DungeonDifficultyID then
		addInstanceInfo(DungeonDifficultyID, DUNGEON_DIFFICULTY)
	end

	if RaidDifficultyID then
		addInstanceInfo(RaidDifficultyID, RAID_DIFFICULTY)
	end

	if LegacyRaidDifficultyID then
		addInstanceInfo(LegacyRaidDifficultyID, UNIT_FRAME_DROPDOWN_SUBSECTION_TITLE_LEGACY_RAID)
	end

	return InctanceInfoText
end


function mMT:InstanceDifficultyDungeon()
	local DungeonID = GetDungeonDifficultyID()
	local DungeonName = GetDifficultyInfo(DungeonID)
	local nhc, hc, myth, _, other, title = mMT:mColorDatatext()

	local mDifficultyText = ""

	if DungeonName then
		if DungeonID == 1 then
			mDifficultyText = format("%s%s|r", nhc, E:ShortenString(DungeonName, 1))
		elseif DungeonID == 2 then
			mDifficultyText = format("%s%s|r", hc, E:ShortenString(DungeonName, 1))
		elseif DungeonID == 23 then
			mDifficultyText = format("%s%s|r", myth, E:ShortenString(DungeonName, 1))
		else
			mDifficultyText = format("%s%s|r", other, E:ShortenString(DungeonName, 1))
		end
	end

	return mDifficultyText
end

function mMT:InstanceDifficultyRaid()
	local RaidID = GetRaidDifficultyID()
	local RaidName = RaidID and GetDifficultyInfo(RaidID) or "ERROR"
	local nhc, hc, myth, _, other, title = mMT:mColorDatatext()

	local mDifficultyText = ""

	if RaidID == 14 then
		mDifficultyText = format("%s%s|r", nhc, E:ShortenString(RaidName, 1))
	elseif RaidID == 15 then
		mDifficultyText = format("%s%s|r", hc, E:ShortenString(RaidName, 1))
	elseif RaidID == 16 then
		mDifficultyText = format("%s%s|r", myth, E:ShortenString(RaidName, 1))
	else
		mDifficultyText = format("%s%s|r", other, E:ShortenString(RaidName, 1))
	end

	return mDifficultyText
end

--Instance Informations Dungeon
function mMT:DungeonInfo()
	local DungeonInfoText = {}
	DungeonInfoText = wipe(DungeonInfoText)
	local nhc, hc, myth, mythp, other, title, tip = mMT:mColorDatatext()
	local name, instanceType, instanceDifficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamicInstance = GetInstanceInfo()

	mInsert(DungeonInfoText, 1, format("%s%s|r", title, L["Instance"]))
	mInsert(DungeonInfoText, 2, format("%s%s:|r %s%s|r", other, L["Name"], other, name))

	if instanceDifficultyID == 1 or instanceDifficultyID == 3 or instanceDifficultyID == 4 or instanceDifficultyID == 14 then
		mInsert(DungeonInfoText, 3, format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], nhc, difficultyName, maxPlayers))
		mInsert(DungeonInfoText, 4, format("%s%s|r", nhc, mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 2 or instanceDifficultyID == 5 or instanceDifficultyID == 6 or instanceDifficultyID == 15 or instanceDifficultyID == 39 or instanceDifficultyID == 149 then
		mInsert(DungeonInfoText, 3, format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], hc, difficultyName, maxPlayers))
		mInsert(DungeonInfoText, 4, format("%s%s|r", hc, mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 23 or instanceDifficultyID == 16 or instanceDifficultyID == 40 then
		mInsert(DungeonInfoText, 3, format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], myth, difficultyName, maxPlayers))
		mInsert(DungeonInfoText, 4, format("%s%s|r", myth, mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 8 then
		mInsert(DungeonInfoText, 3, format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], mythp, difficultyName, maxPlayers))
		mInsert(DungeonInfoText, 4, format("%s%s|r", mythp, mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 24 then
		mInsert(DungeonInfoText, 3, format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], "|CFF85C1E9", difficultyName, maxPlayers))
		mInsert(DungeonInfoText, 4, format("%s%s|r", "|CFF85C1E9", mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 167 then
		mInsert(DungeonInfoText, 3, format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], "|CFFF4D03F", difficultyName, maxPlayers))
		mInsert(DungeonInfoText, 4, format("%s%s|r", "|CFFF4D03F", mMT:mAbbrev(name)))
	else
		mInsert(DungeonInfoText, 3, format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], other, difficultyName, maxPlayers))
		mInsert(DungeonInfoText, 4, format("%s%s|r", other, mMT:mAbbrev(name)))
	end

	return DungeonInfoText
end

function mMT:DungeonInfoName()
	local nhc, hc, myth, mythp, other, title, tip = mMT:mColorDatatext()
	local name, instanceType, instanceDifficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamicInstance = GetInstanceInfo()

	if instanceDifficultyID == 1 or instanceDifficultyID == 3 or instanceDifficultyID == 4 or instanceDifficultyID == 14 then
		return format("%s%s|r", nhc, mMT:mAbbrev(name))
	elseif instanceDifficultyID == 2 or instanceDifficultyID == 5 or instanceDifficultyID == 6 or instanceDifficultyID == 15 or instanceDifficultyID == 39 or instanceDifficultyID == 149 then
		return format("%s%s|r", hc, mMT:mAbbrev(name))
	elseif instanceDifficultyID == 23 or instanceDifficultyID == 16 or instanceDifficultyID == 40 then
		return format("%s%s|r", myth, mMT:mAbbrev(name))
	elseif instanceDifficultyID == 8 then
		return format("%s%s|r", mythp, mMT:mAbbrev(name))
	elseif instanceDifficultyID == 24 then
		return format("%s%s|r", "|CFF85C1E9", mMT:mAbbrev(name))
	elseif instanceDifficultyID == 167 then
		return format("%s%s|r", "|CFFF4D03F", mMT:mAbbrev(name))
	else
		return format("%s%s|r", other, mMT:mAbbrev(name))
	end
end
