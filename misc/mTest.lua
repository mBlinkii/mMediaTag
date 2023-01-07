local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local M = E:GetModule("Minimap")
local addon, ns = ...

--Lua functions
local tinsert = tinsert
local format = format
local wipe = wipe
local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")
local AB = E:GetModule("ActionBars")

local function SetCustomTexture(statusbar, texture, class)
	print(class)
	if class == "PRIEST" then
		statusbar.Health:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag R4"))
	else
		statusbar.Health:SetStatusBarTexture(texture)
	end
end

function FGM(name, tbl, r, g, b, h, k)
	if _G["ElvUF_" .. "Target"] then
		SetCustomTexture(
			_G["ElvUF_" .. "Target"],
			LSM:Fetch("statusbar", "mMediaTag R2"),
			select(2, UnitClass("target"))
		)
	end

	if _G["ElvUF_" .. "Player"] then
		SetCustomTexture(
			_G["ElvUF_" .. "Player"],
			LSM:Fetch("statusbar", "mMediaTag R2"),
			select(2, UnitClass("player"))
		)
	end
end

local GetInstanceInfo, GetDifficultyInfo = GetInstanceInfo, GetDifficultyInfo
local IsInGuild, IsInInstance = IsInGuild, IsInInstance
local InstanceDifficulty = _G.MinimapCluster.InstanceDifficulty
local Instance = InstanceDifficulty.Instance
local ChallengeMode = InstanceDifficulty.ChallengeMode
local Guild = InstanceDifficulty.Guild

local Font = GameFontHighlightSmall:GetFont()

local function GetIconSettings(button)
	local defaults = P.general.minimap.icons[button]
	local profile = E.db.general.minimap.icons[button]

	return profile.scale or defaults.scale,
		profile.position or defaults.position,
		profile.xOffset or defaults.xOffset,
		profile.yOffset or defaults.yOffset
end

local scale, position, xOffset, yOffset = GetIconSettings("difficulty")
local mIDF = CreateFrame("Frame", "SL_MinimapDifficultyFrame", _G.Minimap)
mIDF:Size(32, 32)
mIDF:SetPoint(position, _G.Minimap, xOffset, yOffset)
mIDF.Text = mIDF:CreateFontString("mIDF_Text", "OVERLAY", "GameTooltipText")
mIDF.Text:SetPoint("CENTER", mIDF, "CENTER")
mIDF.Text:SetFont(Font, 12)
mIDF:Hide()

local instanceDifficulty = {
	[1] = { c = "|CFF00FC00", d = "NHC" },
	[2] = { c = "|CFF005AFC", d = "HC" },
	[3] = { c = "|CFF00FC00", d = "NHC" },
	[4] = { c = "|CFF00FC00", d = "NHC" },
	[5] = { c = "|CFF005AFC", d = "HC" },
	[6] = { c = "|CFF005AFC", d = "HC" },
	[8] = { c = "|CFFFC9100", d = "M+" },
	[14] = { c = "|CFF00FC00", d = "NHC" },
	[15] = { c = "|CFF005AFC", d = "HC" },
	[16] = { c = "|CFF7E00FC", d = "M" },
	[17] = { c = "|CFFFCDE00", d = "LFR" },
	[23] = { c = "|CFF7E00FC", d = "M" },
	[24] = { c = "|CFF85C1E9", d = "TW" },
	[25] = { c = "|CFFFF0074", d = "PVP" },
	[29] = { c = "|CFFFF0074", d = "PVP" },
	[33] = { c = "|CFF85C1E9", d = "TW" },
	[34] = { c = "|CFFFF0074", d = "PVP" },
	[39] = { c = "|CFF005AFC", d = "HC" },
	[40] = { c = "|CFF7E00FC", d = "M" },
	[149] = { c = "|CFF005AFC", d = "HC" },
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

local function UpdateSettings()
	if Instance:IsShown() then
		Instance:Hide()
		local inInstance, _ = IsInInstance()
		if inInstance then
			local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID =
				GetInstanceInfo()
			name = shortNames[instanceID] or E:ShortenString(name, 4)
			local difficultyColor = instanceDifficulty[difficultyID] and instanceDifficulty[difficultyID].c
				or "|CFFFFFFFF"
			local difficultyShort = instanceDifficulty[difficultyID] and instanceDifficulty[difficultyID].d or ""
			if C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
				mIDF.Text:SetText(format("%s%s|r +%s", difficultyColor, difficultyShort, mMT:MythPlusDifficultyShort()))
			else
				local difficultyText = format("%s%s|r", difficultyColor, difficultyShort)
				mIDF.Text:SetText(name .. "\n" .. difficultyText .. " " .. instanceGroupSize)
				print(name .. "\n" .. difficultyText .. " " .. instanceGroupSize)
			end
		end
		mIDF:Show()
	else
		mIDF:Hide()
	end
end

--hooksecurefunc(MainMenuMicroButton, "OnUpdate", mmb)
--AB:SecureHook('UpdateMicroButtons')
--hooksecurefunc(UF, "Update_StatusBar", FGM)

--hooksecurefunc(InstanceDifficulty, "Update", UpdateSettings)
