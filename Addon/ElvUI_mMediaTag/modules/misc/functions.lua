local E, L = unpack(ElvUI)

--Lua functions
local string = string
local gmatch, gsub, format = gmatch, gsub, format
local wipe = wipe
local strmatch = strmatch
local utf8lower, utf8sub = string.utf8lower, string.utf8sub
local mInsert = table.insert

--WoW API / Variables
local _G = _G

local GetInstanceInfo = GetInstanceInfo
local GetDifficultyInfo = GetDifficultyInfo
local GetRaidDifficultyID = GetRaidDifficultyID
local GetDungeonDifficultyID = GetDungeonDifficultyID

function mMT:mColorGradient(level)
	local r, g, b = E:ColorGradient(level * 0.04, 0, 0.43, 0.86, 0.63, 0.2, 0.93, 0.89, 0.16, 0.31)
	return E:RGBToHex(r, g, b)
end

function mMT:mAbbrev(text)
	local letters, lastWord = "", strmatch(text, ".+%s(.+)$")
	if lastWord then
		for word in gmatch(text, ".-%s") do
			local firstLetter = utf8sub(gsub(word, "^[%s%p]*", ""), 1, 1)
			if firstLetter ~= utf8lower(firstLetter) then
				letters = format("%s%s. ", letters, firstLetter)
			end
		end
		text = format("%s%s", letters, lastWord)
	end
	return text
end

--Color for various Functions
function mMT:mColorDatatext()
	local nhc, hc, myth, mythp, other, titel, tip =
		E.db.mMT.datatextcolors.colornhc.hex,
		E.db.mMT.datatextcolors.colorhc.hex,
		E.db.mMT.datatextcolors.colormyth.hex,
		E.db.mMT.datatextcolors.colormythplus.hex,
		E.db.mMT.datatextcolors.colorother.hex,
		E.db.mMT.datatextcolors.colortitel.hex,
		E.db.mMT.datatextcolors.colortip.hex
	return nhc, hc, myth, mythp, other, titel, tip
end

--Instance Settings Player
function mMT:InstanceInfo()
	local InctanceInfoText = {}
	InctanceInfoText = wipe(InctanceInfoText)
	local DungeonID = GetDungeonDifficultyID()
	local RaidID = GetRaidDifficultyID()
	local DungeonName, _, _, _, _, _, _ = GetDifficultyInfo(DungeonID)
	local RaidName, _, _, _, _, _, _ = GetDifficultyInfo(RaidID)
	local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()

	mInsert(InctanceInfoText, 1, format("%s%s|r", titel, L["Instance difficulty"]))

	if DungeonID == 1 then
		mInsert(InctanceInfoText, 2, format("%s%s:|r %s%s|r", other, DUNGEON_DIFFICULTY, nhc, DungeonName))
	elseif DungeonID == 2 then
		mInsert(InctanceInfoText, 2, format("%s%s:|r %s%s|r", other, DUNGEON_DIFFICULTY, hc, DungeonName))
	elseif DungeonID == 23 then
		mInsert(InctanceInfoText, 2, format("%s%s:|r %s%s|r", other, DUNGEON_DIFFICULTY, myth, DungeonName))
	else
		mInsert(InctanceInfoText, 2, format("%s%s:|r %s%s|r", other, DUNGEON_DIFFICULTY, other, DungeonName))
	end

	if RaidID == 14 then
		mInsert(InctanceInfoText, 3, format("%s%s:|r %s%s|r", other, RAID_DIFFICULTY, nhc, RaidName))
	elseif RaidID == 15 then
		mInsert(InctanceInfoText, 3, format("%s%s:|r %s%s|r", other, RAID_DIFFICULTY, hc, RaidName))
	elseif RaidID == 16 then
		mInsert(InctanceInfoText, 3, format("%s%s:|r %s%s|r", other, RAID_DIFFICULTY, myth, RaidName))
	else
		mInsert(InctanceInfoText, 3, format("%s%s:|r %s%s|r", other, RAID_DIFFICULTY, other, RaidName))
	end

	return InctanceInfoText
end

function mMT:InstanceDifficultyDungeon()
	local DungeonID = GetDungeonDifficultyID()
	local DungeonName, _, _, _, _, _, _ = GetDifficultyInfo(DungeonID)
	local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()

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
	local RaidName, _, _, _, _, _, _ = GetDifficultyInfo(RaidID)
	local nhc, hc, myth, _, other, titel = mMT:mColorDatatext()

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
	local nhc, hc, myth, mythp, other, titel, tip = mMT:mColorDatatext()
	local name, instanceType, instanceDifficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamicInstance =
		GetInstanceInfo()

	mInsert(DungeonInfoText, 1, format("%s%s|r", titel, L["Instance"]))
	mInsert(DungeonInfoText, 2, format("%s%s:|r %s%s|r", other, L["Name"], other, name))

	if
		instanceDifficultyID == 1
		or instanceDifficultyID == 3
		or instanceDifficultyID == 4
		or instanceDifficultyID == 14
	then
		mInsert(
			DungeonInfoText,
			3,
			format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], nhc, difficultyName, maxPlayers)
		)
		mInsert(DungeonInfoText, 4, format("%s%s|r", nhc, mMT:mAbbrev(name)))
	elseif
		instanceDifficultyID == 2
		or instanceDifficultyID == 5
		or instanceDifficultyID == 6
		or instanceDifficultyID == 15
		or instanceDifficultyID == 39
		or instanceDifficultyID == 149
	then
		mInsert(
			DungeonInfoText,
			3,
			format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], hc, difficultyName, maxPlayers)
		)
		mInsert(DungeonInfoText, 4, format("%s%s|r", hc, mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 23 or instanceDifficultyID == 16 or instanceDifficultyID == 40 then
		mInsert(
			DungeonInfoText,
			3,
			format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], myth, difficultyName, maxPlayers)
		)
		mInsert(DungeonInfoText, 4, format("%s%s|r", myth, mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 8 then
		mInsert(
			DungeonInfoText,
			3,
			format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], mythp, difficultyName, maxPlayers)
		)
		mInsert(DungeonInfoText, 4, format("%s%s|r", mythp, mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 24 then
		mInsert(
			DungeonInfoText,
			3,
			format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], "|CFF85C1E9", difficultyName, maxPlayers)
		)
		mInsert(DungeonInfoText, 4, format("%s%s|r", "|CFF85C1E9", mMT:mAbbrev(name)))
	elseif instanceDifficultyID == 167 then
		mInsert(
			DungeonInfoText,
			3,
			format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], "|CFFF4D03F", difficultyName, maxPlayers)
		)
		mInsert(DungeonInfoText, 4, format("%s%s|r", "|CFFF4D03F", mMT:mAbbrev(name)))
	else
		mInsert(
			DungeonInfoText,
			3,
			format("%s%s:|r %s%s|r (%s)", other, L["Difficulty"], other, difficultyName, maxPlayers)
		)
		mInsert(DungeonInfoText, 4, format("%s%s|r", other, mMT:mAbbrev(name)))
	end

	return DungeonInfoText
end

function mMT:DungeonInfoName()
	local nhc, hc, myth, mythp, other, titel, tip = mMT:mColorDatatext()
	local name, instanceType, instanceDifficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamicInstance =
		GetInstanceInfo()

	if
		instanceDifficultyID == 1
		or instanceDifficultyID == 3
		or instanceDifficultyID == 4
		or instanceDifficultyID == 14
	then
		return format("%s%s|r", nhc, mMT:mAbbrev(name))
	elseif
		instanceDifficultyID == 2
		or instanceDifficultyID == 5
		or instanceDifficultyID == 6
		or instanceDifficultyID == 15
		or instanceDifficultyID == 39
		or instanceDifficultyID == 149
	then
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
