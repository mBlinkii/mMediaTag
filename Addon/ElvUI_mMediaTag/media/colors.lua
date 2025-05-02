local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local pairs = pairs
local CreateColorFromHexString = CreateColorFromHexString
local strjoin = strjoin

COLORS = {
    -- colors
	blue = CreateColorFromHexString("FF0294FF"),
	purple = CreateColorFromHexString("FFBD26E5"),
	red = CreateColorFromHexString("FFFF005D"),
	yellow = CreateColorFromHexString("FFFF9D00"),
	green = CreateColorFromHexString("FF1BFF6B"),
	black = CreateColorFromHexString("FF404040"),
	gray = CreateColorFromHexString("FF787878"),
	info = CreateColorFromHexString("FFFFA7A7"),

	-- datatexts
	datatext = {
		title = CreateColorFromHexString("FFFFBE19"),
		text = CreateColorFromHexString("FFFFFFFF"),
		tip = CreateColorFromHexString("FFB2B2B2"),
		mark = CreateColorFromHexString("FF38FF92"),
		override = CreateColorFromHexString("FFFFFFFF"),
		gm_text_color = CreateColorFromHexString("FFFFFFFF"),
		di_warning = CreateColorFromHexString("FFFF7700"),
		di_repair = CreateColorFromHexString("FFFA3E3E"),
	},

	-- lfg invite info
	lfg = {
		line_a = CreateColorFromHexString("FF1EFF00"),
		line_b = CreateColorFromHexString("FF0070DD"),
		line_c = CreateColorFromHexString("FFA335EE"),
	},

	-- difficulty
	difficulty = {
		N = CreateColorFromHexString("FF1EFF00"),
		H = CreateColorFromHexString("FF0070DD"),
		M = CreateColorFromHexString("FFA335EE"),
		PVP = CreateColorFromHexString("FFE6CC80"),
		MP = CreateColorFromHexString("FFFF8000"),
		LFR = CreateColorFromHexString("FFBE7FE8"),
		TW = CreateColorFromHexString("FF00CCFF"),
		QUEST = CreateColorFromHexString("FFFFBB00"),
		SC = CreateColorFromHexString("FF00FF8C"),
		STORY = CreateColorFromHexString("FFE6CC80"),
		DELVE = CreateColorFromHexString("FF91D900"),
		FOLLOWER = CreateColorFromHexString("FF00FF8C"),
		OTHER = CreateColorFromHexString("FF00FFEE"),
		GUILD = CreateColorFromHexString("FF91D900"),
	},
}

COLORS.myclass = E:ClassColor(E.myclass)

do
	local colors = {
		blue = "FF0294FF",
		purple = "FFBD26E5",
		red = "FFFF005D",
		yellow = "FFFF9D00",
		green = "FF1BFF6B",
		black = "FF404040",
		info = "FFFFA7A7",
	}
	for name, color in pairs(colors) do
		COLORS[name].hex = color
	end
end

function mMT:Colors(arg)
	if arg == "colors" or not arg then
		local c = COLORS.myclass
		if not COLORS.myclass.hex then COLORS.myclass.hex = E:RGBToHex(c.r, c.g, c.b) end

		if not COLORS.myclass.string then COLORS.myclass.string = strjoin("", COLORS.myclass.hex, "%s|r") end

		if not COLORS.myclass.gradient then
			COLORS.myclass.gradient =
				{ a = { r = c.r - 0.2, g = c.g - 0.2, b = c.b - 0.2, a = 1 }, b = { r = c.r + 0.2, g = c.g + 0.2, b = c.b + 0.2, a = 1 } }
		end
	end

	if arg == "lfg" or not arg then
		COLORS.lfg.line_a = CreateColorFromHexString(E.db.mMT.lfg_invite_info.colors.line_a)
		COLORS.lfg.line_a.hex = E.db.mMT.lfg_invite_info.colors.line_a
		COLORS.lfg.line_b = CreateColorFromHexString(E.db.mMT.lfg_invite_info.colors.line_b)
		COLORS.lfg.line_b.hex = E.db.mMT.lfg_invite_info.colors.line_b
		COLORS.lfg.line_c = CreateColorFromHexString(E.db.mMT.lfg_invite_info.colors.line_c)
		COLORS.lfg.line_c.hex = E.db.mMT.lfg_invite_info.colors.line_c
	end

    if arg == "menu" or not arg then
        COLORS.menu.title = CreateColorFromHexString(E.db.mMT.colors.menu.title)
		COLORS.menu.title.hex = E.db.mMT.colors.menu.title
		COLORS.menu.text = CreateColorFromHexString(E.db.mMT.colors.menu.text)
		COLORS.menu.text.hex = E.db.mMT.colors.menu.text
		COLORS.menu.tip = CreateColorFromHexString(E.db.mMT.colors.menu.tip)
		COLORS.menu.tip.hex = E.db.mMT.colors.menu.tip
		COLORS.menu.mark = CreateColorFromHexString(E.db.mMT.colors.menu.mark)
		COLORS.menu.mark.hex = E.db.mMT.colors.menu.mark
    end

	if arg == "datatexts" or not arg then
		COLORS.datatext.override_text = CreateColorFromHexString(E.db.mMT.datatexts.text.text)
		COLORS.datatext.override_text.hex = E.db.mMT.datatexts.text.text
		COLORS.datatext.override_value = CreateColorFromHexString(E.db.mMT.datatexts.text.value)
		COLORS.datatext.override_value.hex = E.db.mMT.datatexts.text.value
		COLORS.datatext.gm_text_color = CreateColorFromHexString(E.db.mMT.datatexts.menu.text_color)
		COLORS.datatext.gm_text_color.hex = E.db.mMT.datatexts.menu.text_color
		COLORS.datatext.di_warning = CreateColorFromHexString(E.db.mMT.datatexts.durability_itemLevel.color_warning)
		COLORS.datatext.di_warning.hex = E.db.mMT.datatexts.durability_itemLevel.color_warning
		COLORS.datatext.di_repair = CreateColorFromHexString(E.db.mMT.datatexts.durability_itemLevel.color_repair)
		COLORS.datatext.di_repair.hex = E.db.mMT.datatexts.durability_itemLevel.color_repair
	end

	if arg == "difficulty" or not arg then
		COLORS.difficulty.N = CreateColorFromHexString(E.db.mMT.colors.difficulty.N)
        COLORS.difficulty.N.hex = E.db.mMT.colors.difficulty.N
		COLORS.difficulty.H = CreateColorFromHexString(E.db.mMT.colors.difficulty.H)
        COLORS.difficulty.H.hex = E.db.mMT.colors.difficulty.H
		COLORS.difficulty.M = CreateColorFromHexString(E.db.mMT.colors.difficulty.M)
        COLORS.difficulty.M.hex = E.db.mMT.colors.difficulty.M
		COLORS.difficulty.PVP = CreateColorFromHexString(E.db.mMT.colors.difficulty.PVP)
        COLORS.difficulty.PVP.hex = E.db.mMT.colors.difficulty.PVP
		COLORS.difficulty.MP = CreateColorFromHexString(E.db.mMT.colors.difficulty.MP)
        COLORS.difficulty.MP.hex = E.db.mMT.colors.difficulty.MP
		COLORS.difficulty.LFR = CreateColorFromHexString(E.db.mMT.colors.difficulty.LFR)
        COLORS.difficulty.LFR.hex = E.db.mMT.colors.difficulty.LFR
		COLORS.difficulty.TW = CreateColorFromHexString(E.db.mMT.colors.difficulty.TW)
        COLORS.difficulty.TW.hex = E.db.mMT.colors.difficulty.TW
		COLORS.difficulty.QUEST = CreateColorFromHexString(E.db.mMT.colors.difficulty.QUEST)
        COLORS.difficulty.QUEST.hex = E.db.mMT.colors.difficulty.QUEST
		COLORS.difficulty.SC = CreateColorFromHexString(E.db.mMT.colors.difficulty.SC)
        COLORS.difficulty.SC.hex = E.db.mMT.colors.difficulty.SC
		COLORS.difficulty.STORY = CreateColorFromHexString(E.db.mMT.colors.difficulty.STORY)
        COLORS.difficulty.STORY.hex = E.db.mMT.colors.difficulty.STORY
		COLORS.difficulty.DELVE = CreateColorFromHexString(E.db.mMT.colors.difficulty.DELVE)
        COLORS.difficulty.DELVE.hex = E.db.mMT.colors.difficulty.DELVE
		COLORS.difficulty.FOLLOWER = CreateColorFromHexString(E.db.mMT.colors.difficulty.FOLLOWER)
        COLORS.difficulty.FOLLOWER.hex = E.db.mMT.colors.difficulty.FOLLOWER
		COLORS.difficulty.OTHER = CreateColorFromHexString(E.db.mMT.colors.difficulty.OTHER)
        COLORS.difficulty.OTHER.hex = E.db.mMT.colors.difficulty.OTHER
		COLORS.difficulty.GUILD = CreateColorFromHexString(E.db.mMT.colors.difficulty.GUILD)
		COLORS.difficulty.GUILD.hex = E.db.mMT.colors.difficulty.GUILD
	end
end
