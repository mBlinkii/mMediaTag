local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local LSM = E.Libs.LSM
local addon, ns = ...

--Lua functions
local mInsert = table.insert
local format = format
local wipe = wipe

--WoW API / Variables
local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance
local MinimapCluster = _G.MinimapCluster
local Minimap = _G.Minimap
local difficulty = E.Retail and MinimapCluster.InstanceDifficulty
local instance = difficulty and difficulty.Instance or _G.MiniMapInstanceDifficulty
local guild = difficulty and difficulty.Guild or _G.GuildInstanceDifficulty
local challenge = difficulty and difficulty.ChallengeMode or _G.MiniMapChallengeMode

--Variables
local mIDF = nil

local percentValue = {
	[2] = 0,
	[3] = 0.14,
	[4] = 0.28,
	[5] = 0.42,
	[6] = 0.56,
	[7] = 0.71,
	[8] = 0.85,
	[9] = 1,
	[10] = 0.2,
	[11] = 0.4,
	[12] = 0.6,
	[13] = 0.8,
	[14] = 1,
	[15] = 0.2,
	[16] = 0.4,
	[17] = 0.6,
	[18] = 0.8,
	[19] = 1,
	[20] = 0.2,
	[21] = 0.4,
	[22] = 0.6,
	[23] = 0.8,
	[24] = 1,
	[25] = 0.2,
	[26] = 0.4,
	[27] = 0.6,
	[28] = 0.8,
	[29] = 1,
}
local instanceDifficulty = {
	[1] = { c = "|CFF00FC00", d = "N" },
	[2] = { c = "|CFF005AFC", d = "H" },
	[3] = { c = "|CFF00FC00", d = "N" },
	[4] = { c = "|CFF00FC00", d = "N" },
	[5] = { c = "|CFF005AFC", d = "H" },
	[6] = { c = "|CFF005AFC", d = "H" },
	[8] = { c = "|CFFFC9100", d = "M+" },
	[14] = { c = "|CFF00FC00", d = "N" },
	[15] = { c = "|CFF005AFC", d = "H" },
	[16] = { c = "|CFF7E00FC", d = "M" },
	[17] = { c = "|CFFFCDE00", d = "LFR" },
	[23] = { c = "|CFF7E00FC", d = "M" },
	[24] = { c = "|CFF85C1E9", d = "TW" },
	[25] = { c = "|CFFFF0074", d = "PVP" },
	[29] = { c = "|CFFFF0074", d = "PVP" },
	[33] = { c = "|CFF85C1E9", d = "TW" },
	[34] = { c = "|CFFFF0074", d = "PVP" },
	[39] = { c = "|CFF005AFC", d = "H" },
	[40] = { c = "|CFF7E00FC", d = "M" },
	[149] = { c = "|CFF005AFC", d = "H" },
	[151] = { c = "|CFFFCDE00", d = "LFR" },
	[167] = { c = "|CFF00C9FF", d = "TG" },
}

local shortNames = {
	[2451] = "ULOT", --Uldaman: Legacy of Tyr
	[2515] = "AV", --The Azure Vault
	[2516] = "NO", --The Nokhud Offensive
	[2519] = "NL", --Neltharus
	[2520] = "BH", --Brackenhide Hollow
	[2521] = "RLP", --Ruby Life Pools
	[2526] = "AA", --Algeth'ar Academy
	[2527] = "HOI", --Halls of Infusion
	[2284] = "SD", --Sanguine Depths
	[2285] = "SOA", --Spires of Ascension
	[2286] = "NW", --The Necrotic Wake
	[2287] = "HA", --Halls of Atonement
	[2289] = "PF", --Plaguefall
	[2290] = "MOTS", --Mists of Tirna Scithe
	[2291] = "DOS", --De Other Side
	[2293] = "TOP", --Theater of Pain
	[2441] = "TTVM", --Tazavesh the Veiled Market
	[959] = "SM", --Shado-pan Monastery
	[960] = "TJS", --Temple of the Jade Serpent
	[961] = "SB", --Stormstout Brewery
	[962] = "GOTSS", --Gate of the Setting Sun
	[994] = "MSP", --Mogu'Shan Palace
	[1011] = "SONT", --Siege of Niuzao Temple
	[1182] = "AU", --Auchindoun
	[1175] = "BSM", --Bloodmaul Slag Mines
	[1176] = "SBG", --Shadowmoon Burial Grounds
	[1195] = "ID", --Iron Docks
	[1208] = "GD", --Grimrail Depot
	[1209] = "SR", --Skyreach
	[1279] = "TE", --The Everbloom
	[1358] = "UBS", --Upper Blackrock Spire
	[1456] = "EOA", --Eye of Azshara
	[1458] = "NL", --Neltharion's Lair
	[1466] = "DT", --Darkheart Thicket
	[1477] = "HOV", --Halls of Valor
	[1492] = "MOS", --Maw of Souls
	[1493] = "VOW", --Vault of the Wardens
	[1501] = "BRH", --Black Rook Hold
	[1516] = "TA", --The Arcway
	[1544] = "VH", --Violet Hold
	[1571] = "COS", --Court of Stars
	[1651] = "RTK", --Return to Karazhan
	[1677] = "COEN", --Cathedral of Eternal Night
	[1753] = "SOTT", --Seat of the Triumvirate
	[1594] = "TM", --The MOTHERLODE!!
	[2522] = "VOTI", --Vault of the Incarnates
}

local colors = {
	["mpe"] = { ["color"] = "|cffff003e", ["r"] = 1, ["g"] = 0, ["b"] = 0.24, },
	["mpf"] = { ["color"] = "|cffff003e", ["r"] = 1, ["g"] = 0, ["b"] = 0.24, },
	["hc"] = { ["color"] = "|cff004dff", ["b"] = 1, ["g"] = 0.30, ["r"] = 0, },
	["guild"] = { ["color"] = "|cff94ff00", ["r"] = 0.58, ["g"] = 1, ["b"] = 0, },
	["tw"] = { ["color"] = "|cff00c0ff", ["r"] = 0, ["g"] = 0.75, ["b"] = 1, },
	["mpc"] = { ["color"] = "|cfffff819", ["r"] = 1, ["g"] = 0.97, ["b"] = 0.098, },
	["nhc"] = { ["color"] = "|cff52ff76", ["b"] = 0.46, ["g"] = 1, ["r"] = 0.32, },
	["mpa"] = { ["color"] = "|cff97ffbd", ["r"] = 0.59, ["g"] = 1, ["b"] = 0.74, },
	["mpd"] = { ["color"] = "|cffff8b00", ["r"] = 1, ["g"] = 0.54, ["b"] = 0, },
	["m"] = { ["color"] = "|cffaf00ff", ["g"] = 0, ["r"] = 0.68, ["b"] = 1.00, },
	["name"] = { ["color"] = "|cffffffff", ["r"] = 1, ["g"] = 1, ["b"] = 1, },
	["mp"] = { ["color"] = "|cffff8f00", ["b"] = 0, ["g"] = 0.56, ["r"] = 1, },
	["mpb"] = { ["color"] = "|cff27ff59", ["r"] = 0.15, ["g"] = 1, ["b"] = 0.34, },
	["lfr"] = { ["color"] = "|cff00ffef", ["b"] = 0.93, ["g"] = 1, ["r"] = 0, },
	["tg"] = { ["color"] = "|cff5dffb8", ["r"] = 0.36, ["g"] = 1, ["b"] = 0.72, },
	["pvp"] = { ["color"] = "|cffeb0056", ["r"] = 0.92, ["g"] = 0, ["b"] = 0.33, },
}

local function UodateColors()
	local db = E.db[mPlugin].mInstanceDifficulty
	instanceDifficulty = {
		[1] = { c = db.nhc.color, d = "N" },
		[2] = { c = db.hc.color, d = "H" },
		[3] = { c = db.nhc.color, d = "N" },
		[4] = { c = db.nhc.color, d = "N" },
		[5] = { c = db.hc.color, d = "H" },
		[6] = { c = db.hc.color, d = "H" },
		[8] = { c = db.mp.color, d = "M+" },
		[14] = { c = db.nhc.color, d = "N" },
		[15] = { c = db.hc.color, d = "H" },
		[16] = { c = db.m.color, d = "M" },
		[17] = { c = db.lfr.color, d = "LFR" },
		[23] = { c = db.m.color, d = "M" },
		[24] = { c = db.tw.color, d = "TW" },
		[25] = { c = db.pvp.color, d = "PVP" },
		[29] = { c = db.pvp.color, d = "PVP" },
		[33] = { c = db.tw.color, d = "TW" },
		[34] = { c = db.pvp.color, d = "PVP" },
		[39] = { c = db.hc.color, d = "H" },
		[40] = { c = db.m.color, d = "M" },
		[149] = { c = db.hc.color, d = "H" },
		[151] = { c = db.lfr.color, d = "LFR" },
		[167] = { c = db.tg.color, d = "TG" },
	}

	colors = {
		["nhc"] = db.nhc,
		["hc"] = db.hc,
		["m"] = db.m,
		["mp"] = db.mp,
		["pvp"] = db.pvp,
		["lfr"] = db.lfr,
		["tw"] = db.tw,
		["tg"] = db.tg,
		["name"] = db.name,
		["guild"] = db.guild,
		["mpa"] = db.mpa,
		["mpb"] = db.mpb,
		["mpc"] = db.mpc,
		["mpd"] = db.mpd,
		["mpe"] = db.mpe,
		["mpf"] = db.mpf,
	}
end

local function ShortName(name)
	local WordA, WordB, WordC, WordD, WordE, WordF, WordG = strsplit(" ", name, 6)

	WordA = WordA and E:ShortenString(WordA, 1) or ""
	WordB = WordB and E:ShortenString(WordB, 1) or ""
	WordC = WordC and E:ShortenString(WordC, 1) or ""
	WordD = WordD and E:ShortenString(WordD, 1) or ""
	WordE = WordE and E:ShortenString(WordE, 1) or ""
	WordF = WordF and E:ShortenString(WordF, 1) or ""
	WordG = WordG and E:ShortenString(WordG, 1) or ""

	return WordA .. WordB .. WordC .. WordD .. WordE .. WordF .. WordG
end

local function GetIconSettings(button)
	local defaults = P.general.minimap.icons[button]
	local profile = E.db.general.minimap.icons[button]

	return profile.position or defaults.position,
		profile.xOffset or defaults.xOffset,
		profile.yOffset or defaults.yOffset
end

local function GetKeystoneLevelandColor()
	local color = {}
	local keyStoneLevel, _ = C_ChallengeMode.GetActiveKeystoneInfo()
	if keyStoneLevel == 2 then
		return format("%s%s|r", colors.mpa.color, keyStoneLevel)
	elseif keyStoneLevel <= 9 then
		color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpa, E.db[mPlugin].mInstanceDifficulty.mpb,
			percentValue[keyStoneLevel])
		return format("%s%s|r", color.color, keyStoneLevel)
	elseif keyStoneLevel <= 14 then
		color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpb, E.db[mPlugin].mInstanceDifficulty.mpc,
			percentValue[keyStoneLevel])
		return format("%s%s|r", color.color, keyStoneLevel)
	elseif keyStoneLevel <= 19 then
		color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpc, E.db[mPlugin].mInstanceDifficulty.mpd,
			percentValue[keyStoneLevel])
		return format("%s%s|r", color.color, keyStoneLevel)
	elseif keyStoneLevel >= 24 then
		color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpd, E.db[mPlugin].mInstanceDifficulty.mpe,
			percentValue[keyStoneLevel])
		return format("%s%s|r", color.color, keyStoneLevel)
	elseif keyStoneLevel >= 29 then
		color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpe, E.db[mPlugin].mInstanceDifficulty.mpf,
			percentValue[keyStoneLevel])
		return format("%s%s|r", color.color, keyStoneLevel)
	else
		return format("%s%s|r", colors.mpf.color, keyStoneLevel)
	end
end

function UpdateDifficulty()
	instance:Hide()
	guild:Hide()
	challenge:Hide()

	local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID =
	GetInstanceInfo()
	local inInstance, InstanceType = IsInInstance()

	if inInstance and name then
		name = shortNames[instanceID] or ShortName(name)

		local difficultyColor = instanceDifficulty[difficultyID] and instanceDifficulty[difficultyID].c or "|CFFFFFFFF"
		local difficultyShort = instanceDifficulty[difficultyID] and instanceDifficulty[difficultyID].d or ""
		local isGuildParty = InGuildParty()
		if difficultyID == 8
			and C_MythicPlus.IsMythicPlusActive()
			and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil)
		then
			if isGuildParty then
				mIDF.Text:SetText(
					format(
						"%s%s|r\n%s%s|r %s",
						colors.guild.color,
						name,
						difficultyColor,
						difficultyShort,
						GetKeystoneLevelandColor()
					)
				)
			else
				mIDF.Text:SetText(
					format(
						"%s%s|r\n%s%s|r %s",
						colors.name.color,
						name,
						difficultyColor,
						difficultyShort,
						GetKeystoneLevelandColor()
					)
				)
			end
		elseif InstanceType == "pvp" or InstanceType == "arena" then
			difficultyColor = instanceDifficulty[34] and instanceDifficulty[34].c or "|CFFFFFFFF"
			difficultyShort = instanceDifficulty[34] and instanceDifficulty[34].d or ""
			if isGuildParty then
				mIDF.Text:SetText(
					format(
						"%s%s|r\n%s%s|r",
						colors.guild.color,
						name,
						difficultyColor,
						difficultyShort
					)
				)
			else
				mIDF.Text:SetText(
					format(
						"%s%s|r\n%s%s|r",
						colors.name.color,
						name,
						difficultyColor,
						difficultyShort
					)
				)
			end
		else
			if isGuildParty then
				mIDF.Text:SetText(
					format(
						"%s%s|r\n%s%s|r |CFFF7DC6F%s|r",
						colors.guild.color,
						name,
						difficultyColor,
						difficultyShort,
						instanceGroupSize
					)
				)
			else
				mIDF.Text:SetText(
					format(
						"%s%s|r\n%s%s|r |CFFF7DC6F%s|r",
						colors.name.color,
						name,
						difficultyColor,
						difficultyShort,
						instanceGroupSize
					)
				)
			end
		end

		mIDF:Show()
	else
		mIDF:Hide()
	end
end

function mMT:UpdateText()
	UpdateDifficulty()
end

function mMT:SetupInstanceDifficulty()
	local position, xOffset, yOffset = GetIconSettings("difficulty")
	local Font = LSM:Fetch("font", E.db.general.font)

	mIDF = CreateFrame("Frame", "m_MinimapInstanceDifficulty", E.UIParent)
	mIDF:Size(32, 32)
	mIDF:SetPoint(position, Minimap, xOffset, yOffset)
	mIDF.Text = mIDF:CreateFontString("mIDF_Text", "OVERLAY", "GameTooltipText")
	mIDF.Text:SetPoint("CENTER", mIDF, "CENTER")
	mIDF.Text:SetFont(Font, E.db.general.fontSize or 12)
	mIDF:Hide()

	UodateColors()

	hooksecurefunc(MinimapCluster.InstanceDifficulty, "Update", UpdateDifficulty)
end

local function mInstanceDifficultyOptions()
	E.Options.args.mMediaTag.args.cosmetic.args.instancedifficulty.args = {
		ID_Enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.db[mPlugin].mInstanceDifficulty.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mInstanceDifficulty.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		ID_Spacer = {
			order = 2,
			type = "description",
			name = "\n\n",
		},
		ID_Header_Difficultys = {
			order = 3,
			type = "header",
			name = L["Difficultys Colors"],
		},
		ID_Color_NHC = {
			type = "color",
			order = 4,
			name = "NHC",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.nhc
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.nhc
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_HC = {
			type = "color",
			order = 5,
			name = "HC",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.hc
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.hc
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_M = {
			type = "color",
			order = 6,
			name = "M",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.m
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.m
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_MP = {
			type = "color",
			order = 7,
			name = "M+",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.mp
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.mp
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_LFR = {
			type = "color",
			order = 8,
			name = "LFR",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.lfr
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.lfr
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_PVP = {
			type = "color",
			order = 9,
			name = "PVP",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.pvp
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.pvp
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_TW = {
			type = "color",
			order = 10,
			name = "TW",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.tw
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.tw
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_TG = {
			type = "color",
			order = 11,
			name = "TG",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.tg
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.tg
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Header_Other = {
			order = 12,
			type = "header",
			name = L["Other Colors"],
		},
		ID_Color_Name = {
			type = "color",
			order = 13,
			name = L["Instance Name"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.name
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.name
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_Guild = {
			type = "color",
			order = 14,
			name = L["Guild Group"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.guild
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.guild
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Header_Keylevel = {
			order = 15,
			type = "header",
			name = L["M+ Keystone Level"],
		},
		ID_Color_MA = {
			type = "color",
			order = 16,
			name = "+2",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.mpa
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.mpa
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_MB = {
			type = "color",
			order = 17,
			name = "<=9",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.mpb
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.mpb
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_MC = {
			type = "color",
			order = 18,
			name = "<=14",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.mpc
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.mpc
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_MD = {
			type = "color",
			order = 19,
			name = "<=19",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.mpd
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.mpd
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_ME = {
			type = "color",
			order = 20,
			name = "<=24",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.mpe
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.mpe
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Color_MF = {
			type = "color",
			order = 21,
			name = "<=29",
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mInstanceDifficulty.mpf
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mInstanceDifficulty.mpf
				t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
				UodateColors()
			end,
		},
		ID_Header_Example = {
			order = 30,
			type = "header",
			name = L["Example"],
		},
		ID_Header_Test = {
			order = 31,
			type = "description",
			name = function()
				local tmpText = ""
				tmpText = "[DIFFICULTY] = " ..
					colors.nhc.color .. "N |r" .. " - " .. colors.hc.color .. "H |r" .. " - " .. colors.m.color .. "M |r "
				tmpText = tmpText ..
					colors.lfr.color .. "LFR |r" .. " - " .. colors.tw.color .. "TW |r" .. " - " .. colors.tg.color .. "TG |r "
				tmpText = tmpText .. colors.pvp.color .. "PVP |r" .. " - " .. colors.mp.color .. "M+ |r\n"
				tmpText = tmpText .. "[OTHERS] = " .. colors.name.color .. "NAME |r" .. " - " .. colors.guild.color .. "GUILD |r\n\n"
				tmpText = tmpText .. "[KEYLEVELS]\n"
				local color = {}
				for i = 2, 29, 1 do
					if i <= 9 then
						color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpa, E.db[mPlugin].mInstanceDifficulty.mpb, percentValue[i
							])
					elseif i <= 14 then
						color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpb, E.db[mPlugin].mInstanceDifficulty.mpc, percentValue[i
							])
					elseif i <= 19 then
						color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpc, E.db[mPlugin].mInstanceDifficulty.mpd, percentValue[i
							])
					elseif i <= 24 then
						color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpd, E.db[mPlugin].mInstanceDifficulty.mpe, percentValue[i
							])
					elseif i <= 29 then
						color = mMT:ColorFade(E.db[mPlugin].mInstanceDifficulty.mpe, E.db[mPlugin].mInstanceDifficulty.mpf, percentValue[i
							])
					end
					color = E:RGBToHex(color.r, color.g, color.b)
					tmpText = tmpText .. color .. tostring(i) .. "|r "
				end

				tmpText = tmpText .. "\n\n\n[DEMO]\n" .. colors.name.color .. "HOV |r\n" .. colors.m.color .. "M|r |CFFF7DC6F5|r"

				return tmpText
			end,
		},
	}
end

mInsert(ns.Config, mInstanceDifficultyOptions)
