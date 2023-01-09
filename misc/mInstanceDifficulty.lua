local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
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
	["nhc"] = { ["r"] = 0.67, ["g"] = 0.83, ["b"] = 0.45, ["color"] = "|cffff033e" },
	["hc"] = { ["r"] = 0.53, ["g"] = 0.53, ["b"] = 0.93, ["color"] = "|cffff033e" },
	["m"] = { ["r"] = 1.00, ["g"] = 1.00, ["b"] = 1.00, ["color"] = "|cffff033e" },
	["mp"] = { ["r"] = 0.96, ["g"] = 0.55, ["b"] = 0.73, ["color"] = "|cffff033e" },
	["pvp"] = { ["r"] = 0.20, ["g"] = 0.78, ["b"] = 0.92, ["color"] = "|cffff033e" },
	["lfr"] = { ["r"] = 1.00, ["g"] = 0.96, ["b"] = 0.41, ["color"] = "|cffff033e" },
	["tw"] = { ["r"] = 1.00, ["g"] = 0.49, ["b"] = 0.04, ["color"] = "|cffff033e" },
	["tg"] = { ["r"] = 0.00, ["g"] = 0.44, ["b"] = 0.87, ["color"] = "|cffff033e" },
	["name"] = { ["r"] = 0.78, ["g"] = 0.61, ["b"] = 0.43, ["color"] = "|cffff033e" },
	["guild"] = { ["r"] = 0.78, ["g"] = 0.61, ["b"] = 0.43, ["color"] = "|cffff033e" },
	["mpa"] = { ["r"] = 0.78, ["g"] = 0.61, ["b"] = 0.43, ["color"] = "|cffff033e" },
	["mpb"] = { ["r"] = 0.77, ["g"] = 0.12, ["b"] = 0.23, ["color"] = "|cffff033e" },
	["mpc"] = { ["r"] = 0.00, ["g"] = 1.00, ["b"] = 0.60, ["color"] = "|cffff033e" },
	["mpd"] = { ["r"] = 0.64, ["g"] = 0.19, ["b"] = 0.79, ["color"] = "|cffff033e" },
	["mpe"] = { ["r"] = 0.20, ["g"] = 0.58, ["b"] = 0.50, ["color"] = "|cffff033e" },
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
	}
end

local function GetIconSettings(button)
	local defaults = P.general.minimap.icons[button]
	local profile = E.db.general.minimap.icons[button]

	return profile.position or defaults.position,
		profile.xOffset or defaults.xOffset,
		profile.yOffset or defaults.yOffset
end
local function GetKeystoneLevelandColor()
	local keyStoneLevel, _ = C_ChallengeMode.GetActiveKeystoneInfo()
	if keyStoneLevel == 2 then
		return format("%s%s", colors.mpa.color, keyStoneLevel)
	elseif keyStoneLevel >= 10 then
		local r, g, b = E:ColorGradient(
			keyStoneLevel * 0.1,
			colors.mpa.r,
			colors.mpa.g,
			colors.mpa.b,
			colors.mpb.r,
			colors.mpb.g,
			colors.mpb.b
		)
		return format("%s%s", E:RGBToHex(r, g, b), keyStoneLevel)
	elseif keyStoneLevel >= 15 then
		local r, g, b = E:ColorGradient(
			keyStoneLevel * 0.15,
			colors.mpb.r,
			colors.mpb.g,
			colors.mpb.b,
			colors.mpc.r,
			colors.mpc.g,
			colors.mpc.b
		)
		return format("%s%s", E:RGBToHex(r, g, b), keyStoneLevel)
	elseif keyStoneLevel >= 20 then
		local r, g, b = E:ColorGradient(
			keyStoneLevel * 0.2,
			colors.mpc.r,
			colors.mpc.g,
			colors.mpc.b,
			colors.mpd.r,
			colors.mpd.g,
			colors.mpd.b
		)
		return format("%s%s", E:RGBToHex(r, g, b), keyStoneLevel)
	else
		local r, g, b = E:ColorGradient(
			keyStoneLevel * 0.3,
			colors.mpd.r,
			colors.mpd.g,
			colors.mpd.b,
			colors.mpe.r,
			colors.mpe.g,
			colors.mpe.b
		)
		return format("%s%s", E:RGBToHex(r, g, b), keyStoneLevel)
	end
end

function UpdateDifficulty()
	instance:Hide()
	guild:Hide()
	challenge:Hide()

	local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID =
		GetInstanceInfo()
	local inInstance, _ = IsInInstance()

	if inInstance and name then
		name = shortNames[instanceID] or E:ShortenString(name, 4)

		local difficultyColor = instanceDifficulty[difficultyID] and instanceDifficulty[difficultyID].c or "|CFFFFFFFF"
		local difficultyShort = instanceDifficulty[difficultyID] and instanceDifficulty[difficultyID].d or ""
		local isGuildParty = InGuildParty()
		if
			difficultyID == 8
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
	local Font = GameFontHighlightSmall:GetFont()

	mIDF = CreateFrame("Frame", "m_MinimapInstanceDifficulty", Minimap)
	mIDF:Size(32, 32)
	mIDF:SetPoint(position, Minimap, xOffset, yOffset)
	mIDF.Text = mIDF:CreateFontString("mIDF_Text", "OVERLAY", "GameTooltipText")
	mIDF.Text:SetPoint("CENTER", mIDF, "CENTER")
	mIDF.Text:SetFont(Font, 12)
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
			order = 3,
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
			order = 4,
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
			order = 5,
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
			order = 6,
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
			order = 7,
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
			order = 8,
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
			order = 9,
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
			order = 10,
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
			order = 11,
			type = "header",
			name = L["Other Colors"],
		},
		ID_Color_Name = {
			type = "color",
			order = 12,
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
			order = 13,
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
			order = 14,
			type = "header",
			name = L["M+ Keystone Level"],
		},
		ID_Color_MA = {
			type = "color",
			order = 15,
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
			order = 16,
			name = ">=10",
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
			order = 17,
			name = ">=15",
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
			order = 18,
			name = ">=20",
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
			order = 19,
			name = "<=21",
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
	}
end

mInsert(ns.Config, mInstanceDifficultyOptions)
