local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.N)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.N = hex
			MEDIA.color.N = CreateColorFromHexString(hex)
			MEDIA.color.N.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.H)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.H = hex
			MEDIA.color.H = CreateColorFromHexString(hex)
			MEDIA.color.H.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.M)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.M = hex
			MEDIA.color.M = CreateColorFromHexString(hex)
			MEDIA.color.M.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.PVP)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.PVP = hex
			MEDIA.color.PVP = CreateColorFromHexString(hex)
			MEDIA.color.PVP.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.MP)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.MP = hex
			MEDIA.color.MP = CreateColorFromHexString(hex)
			MEDIA.color.MP.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.LFR)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.LFR = hex
			MEDIA.color.LFR = CreateColorFromHexString(hex)
			MEDIA.color.LFR.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.TW)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.TW = hex
			MEDIA.color.TW = CreateColorFromHexString(hex)
			MEDIA.color.TW.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.QUEST)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.QUEST = hex
			MEDIA.color.QUEST = CreateColorFromHexString(hex)
			MEDIA.color.QUEST.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.SC)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.SC = hex
			MEDIA.color.SC = CreateColorFromHexString(hex)
			MEDIA.color.SC.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.STORY)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.STORY = hex
			MEDIA.color.STORY = CreateColorFromHexString(hex)
			MEDIA.color.STORY.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.DELVE)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.DELVE = hex
			MEDIA.color.DELVE = CreateColorFromHexString(hex)
			MEDIA.color.DELVE.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.FOLLOWER)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.FOLLOWER = hex
			MEDIA.color.FOLLOWER = CreateColorFromHexString(hex)
			MEDIA.color.FOLLOWER.hex = hex
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
			local r, g, b = mMT:HexToRGB(E.db.mMT.media.color.OTHER)
			return r, g, b
		end,
		set = function(info, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMT.media.color.OTHER = hex
			MEDIA.color.OTHER = CreateColorFromHexString(hex)
			MEDIA.color.OTHER.hex = hex
			UpdateDifficultyModules()
		end,
	},
}
