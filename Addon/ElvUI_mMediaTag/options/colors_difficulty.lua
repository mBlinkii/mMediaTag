local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local function UpdateDifficultyModules()
	DT:ForceUpdate_DataText("mMT - Dungeon")
end

mMT.options.args.colors.args.difficulty.args = {
	n = {
		order = 1,
		type = "color",
		name = L["N"],
		desc = L["Normal"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.N)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.N = hex
			COLORS.difficulty.N = CreateColorFromHexString(hex)
			COLORS.difficulty.N.hex = hex
			UpdateDifficultyModules()
		end,
	},
	h = {
		order = 2,
		type = "color",
		name = L["H"],
		desc = L["Heroic"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.H)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.H = hex
			COLORS.difficulty.H = CreateColorFromHexString(hex)
			COLORS.difficulty.H.hex = hex
			UpdateDifficultyModules()
		end,
	},
	m = {
		order = 3,
		type = "color",
		name = L["M"],
		desc = L["Mythic"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.M)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.M = hex
			COLORS.difficulty.M = CreateColorFromHexString(hex)
			COLORS.difficulty.M.hex = hex
			UpdateDifficultyModules()
		end,
	},
	pvp = {
		order = 4,
		type = "color",
		name = L["PVP"],
		desc = L["PVP"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.PVP)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.PVP = hex
			COLORS.difficulty.PVP = CreateColorFromHexString(hex)
			COLORS.difficulty.PVP.hex = hex
			UpdateDifficultyModules()
		end,
	},
	mp = {
		order = 5,
		type = "color",
		name = L["M+"],
		desc = L["Mythic+"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.MP)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.MP = hex
			COLORS.difficulty.MP = CreateColorFromHexString(hex)
			COLORS.difficulty.MP.hex = hex
			UpdateDifficultyModules()
		end,
	},
	lfr = {
		order = 6,
		type = "color",
		name = L["LFR"],
		desc = L["LFR"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.LFR)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.LFR = hex
			COLORS.difficulty.LFR = CreateColorFromHexString(hex)
			COLORS.difficulty.LFR.hex = hex
			UpdateDifficultyModules()
		end,
	},
	tw = {
		order = 7,
		type = "color",
		name = L["TW"],
		desc = L["Timewalking"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.TW)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.TW = hex
			COLORS.difficulty.TW = CreateColorFromHexString(hex)
			COLORS.difficulty.TW.hex = hex
			UpdateDifficultyModules()
		end,
	},
	quest = {
		order = 8,
		type = "color",
		name = L["Quest"],
		desc = L["Quest"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.QUEST)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.QUEST = hex
			COLORS.difficulty.QUEST = CreateColorFromHexString(hex)
			COLORS.difficulty.QUEST.hex = hex
			UpdateDifficultyModules()
		end,
	},
	sc = {
		order = 9,
		type = "color",
		name = L["SC"],
		desc = L["Scenario"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.SC)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.SC = hex
			COLORS.difficulty.SC = CreateColorFromHexString(hex)
			COLORS.difficulty.SC.hex = hex
			UpdateDifficultyModules()
		end,
	},
	story = {
		order = 10,
		type = "color",
		name = L["Story"],
		desc = L["Story"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.STORY)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.STORY = hex
			COLORS.difficulty.STORY = CreateColorFromHexString(hex)
			COLORS.difficulty.STORY.hex = hex
			UpdateDifficultyModules()
		end,
	},
	delve = {
		order = 11,
		type = "color",
		name = L["Delve"],
		desc = L["Delve"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.DELVE)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.DELVE = hex
			COLORS.difficulty.DELVE = CreateColorFromHexString(hex)
			COLORS.difficulty.DELVE.hex = hex
			UpdateDifficultyModules()
		end,
	},
	follower = {
		order = 12,
		type = "color",
		name = L["Follower"],
		desc = L["Follower"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.FOLLOWER)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.FOLLOWER = hex
			COLORS.difficulty.FOLLOWER = CreateColorFromHexString(hex)
			COLORS.difficulty.FOLLOWER.hex = hex
			UpdateDifficultyModules()
		end,
	},
	other = {
		order = 13,
		type = "color",
		name = L["Other"],
		desc = L["Other"],
		hasAlpha = false,
		get = function(info)
			local r, g, b = mMT:HexToRGB(E.db.mMT.colors.difficulty.OTHER)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.colors.difficulty.OTHER = hex
			COLORS.difficulty.OTHER = CreateColorFromHexString(hex)
			COLORS.difficulty.OTHER.hex = hex
			UpdateDifficultyModules()
		end,
	},
}
