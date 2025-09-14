local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local pairs = pairs
local CreateColorFromHexString = CreateColorFromHexString
local strjoin = strjoin

local function createColor(hex)
	return CreateColorFromHexString(hex)
end

local function createColorPair(c, g)
	return { c = createColor(c), g = createColor(g) }
end

MEDIA.color = {
	-- tip menu
	title = createColor("FFFFBE19"),
	text = createColor("FFFFFFFF"),
	tip = createColor("FFB2B2B2"),
	mark = createColor("FF38FF92"),

	-- datatext
	override = createColor("FFFFFFFF"),
	gm_text_color = createColor("FFFFFFFF"),
	di_warning = createColor("FFFF7700"),
	di_repair = createColor("FFFA3E3E"),

	-- LFG Invite Info
	line_a = createColor("FF1EFF00"),
	line_b = createColor("FF0070DD"),
	line_c = createColor("FFA335EE"),

	-- colors
	blue = createColor("FF0294FF"),
	purple = createColor("FFBD26E5"),
	red = createColor("FFFF005D"),
	yellow = createColor("FFFF9D00"),
	green = createColor("FF1BFF6B"),
	black = createColor("FF404040"),
	gray = createColor("FF787878"),
	info = createColor("FFFFA7A7"),

	-- difficulty
	N = createColor("FF1EFF00"),
	H = createColor("FF0070DD"),
	M = createColor("FFA335EE"),
	PVP = createColor("FFE6CC80"),
	MP = createColor("FFFF8000"),
	LFR = createColor("FFBE7FE8"),
	TW = createColor("FF00CCFF"),
	QUEST = createColor("FFFFBB00"),
	SC = createColor("FF00FF8C"),
	STORY = createColor("FFE6CC80"),
	DELVE = createColor("FF91D900"),
	FOLLOWER = createColor("FF00FF8C"),
	OTHER = createColor("FF00FFEE"),
	GUILD = createColor("FF91D900"),

	-- portraits
	portraits = {
		misc = {
			death = createColorPair("FFF86767", "FFEC3535"),
			default = createColorPair("FFE6CC80", "FFDAB033"),
			bg = createColor("FF000000"),
		},
		class = {
			DEATHKNIGHT = createColorPair("FFC41E3A", "FF9C182E"),
			DEMONHUNTER = createColorPair("FFA330C9", "FF6F2C91"),
			DRUID = createColorPair("FFFF7C0A", "FF9F5B00"),
			EVOKER = createColorPair("FF33937F", "FF1F6D5B"),
			HUNTER = createColorPair("FFAAD372", "FF7A9A2D"),
			MAGE = createColorPair("FF3FC7EB", "FF2A7F9D"),
			MONK = createColorPair("FF00FF98", "FF009B5B"),
			PALADIN = createColorPair("FFF48CBA", "FFC77399"),
			PRIEST = createColorPair("FFFFFFFF", "FFCDCCCC"),
			ROGUE = createColorPair("FFFFF468", "FFD2CA56"),
			SHAMAN = createColorPair("FF0070DD", "FF005EB8"),
			WARLOCK = createColorPair("FF8788EE", "FF5B5C8A"),
			WARRIOR = createColorPair("FFC69B6D", "FF9B7A57"),
		},
		classification = {
			boss = createColorPair("FFFF2E2E", "FFDA0B0B"),
			elite = createColorPair("FFFF00E6", "FFD001BC"),
			player = createColorPair("FF00FFEE", "FF00C3B6"),
			rare = createColorPair("FFB300FF", "FF9100D0"),
			rareelite = createColorPair("FFA100FF", "FF8500D2"),
		},
		reaction = {
			enemy = createColorPair("FFFF4848", "FFD63A3A"),
			friendly = createColorPair("FF00FE48", "FF00C538"),
			neutral = createColorPair("FFFFD52E", "FFFFC02E"),
		},
	},

	interrupt_on_cd = {
		onCD = createColorPair("FFA200FF", "FFC500BB"),
		inTime = createColorPair("FF00E1FF", "FF0080D6"),
		outOfRange = createColorPair("FFFFA500", "FFD67A00"),
		marker = createColor("FFFFFFFF"),
	},

	castbar_shield = createColor("FFFFFFFF"),
	minimap_skin = { color = createColor("FFFFFFFF"), cardinal = createColor("FFFFFFFF") },

	dock = {
		normal = createColor("FFFFFFFF"),
		hover = createColor("FF00FFFF"),
		clicked = createColor("FFFF00FF"),
		notification = createColor("FF00FF88"),
		font = createColor("FFFFFFFF"),
		store = createColor("FFFFFFFF"),
		achievement = createColor("FFFFFFFF"),
		bags = createColor("FFFFFFFF"),
		character = createColor("FFFFFFFF"),
		collection = createColor("FFFFFFFF"),
		durability = createColor("FFFFFFFF"),
		encounter = createColor("FFFFFFFF"),
		friends = createColor("FFFFFFFF"),
		guild = createColor("FFFFFFFF"),
	},
}

MEDIA.myclass = E:ClassColor(E.myclass)

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
		MEDIA.color[name].hex = color
	end
end

function mMT:UpdateMedia(arg)
	if arg == "colors" or not arg then
		local classColor = MEDIA.myclass
		MEDIA.myclass.hex = MEDIA.myclass.hex or E:RGBToHex(classColor.r, classColor.g, classColor.b)
		MEDIA.myclass.string = MEDIA.myclass.string or strjoin("", MEDIA.myclass.hex, "%s|r")
		MEDIA.myclass.gradient = MEDIA.myclass.gradient
			or {
				a = { r = classColor.r - 0.2, g = classColor.g - 0.2, b = classColor.b - 0.2, a = 1 },
				b = { r = classColor.r + 0.2, g = classColor.g + 0.2, b = classColor.b + 0.2, a = 1 },
			}
	end

	if arg == "lfg" or not arg then
		for _, key in ipairs({ "line_a", "line_b", "line_c" }) do
			MEDIA.color[key] = CreateColorFromHexString(E.db.mMT.lfg_invite_info.colors[key])
			MEDIA.color[key].hex = E.db.mMT.lfg_invite_info.colors[key]
		end
	end

	if arg == "datatexts" or not arg then
		for _, key in ipairs({ "title", "text", "tip", "mark" }) do
			MEDIA.color[key] = CreateColorFromHexString(E.db.mMT.color[key])
			MEDIA.color[key].hex = E.db.mMT.color[key]
		end

		MEDIA.color.override_text = CreateColorFromHexString(E.db.mMT.datatexts.text.text)
		MEDIA.color.override_text.hex = E.db.mMT.datatexts.text.text
		MEDIA.color.override_value = CreateColorFromHexString(E.db.mMT.datatexts.text.value)
		MEDIA.color.override_value.hex = E.db.mMT.datatexts.text.value
		MEDIA.color.gm_text_color = CreateColorFromHexString(E.db.mMT.datatexts.menu.text_color)
		MEDIA.color.gm_text_color.hex = E.db.mMT.datatexts.menu.text_color
		MEDIA.color.di_warning = CreateColorFromHexString(E.db.mMT.datatexts.durability_itemLevel.color_warning)
		MEDIA.color.di_warning.hex = E.db.mMT.datatexts.durability_itemLevel.color_warning
		MEDIA.color.di_repair = CreateColorFromHexString(E.db.mMT.datatexts.durability_itemLevel.color_repair)
		MEDIA.color.di_repair.hex = E.db.mMT.datatexts.durability_itemLevel.color_repair
	end

	if arg == "difficulty" or not arg then
		for _, key in ipairs({ "N", "H", "M", "PVP", "MP", "LFR", "TW", "QUEST", "SC", "STORY", "DELVE", "FOLLOWER", "OTHER", "GUILD" }) do
			MEDIA.color[key] = CreateColorFromHexString(E.db.mMT.color[key])
			MEDIA.color[key].hex = E.db.mMT.color[key]
		end
	end

	if arg == "portraits" or not arg then
		local function createColorSet(path)
			local set = {}
			for key, val in pairs(path) do
				set[key] = type(val) == "table" and { c = CreateColorFromHexString(val.c), g = CreateColorFromHexString(val.g) } or CreateColorFromHexString(val)
			end
			return set
		end

		MEDIA.color.portraits = nil
		MEDIA.color.portraits = {
			misc = createColorSet(E.db.mMT.color.portraits.misc),
			class = createColorSet(E.db.mMT.color.portraits.class),
			classification = createColorSet(E.db.mMT.color.portraits.classification),
			reaction = createColorSet(E.db.mMT.color.portraits.reaction),
		}
	end

	if arg == "interrupt" or not arg then
		local function createColorSets(path)
			local set = {}

			set = type(path) == "table" and { c = CreateColorFromHexString(path.c), g = CreateColorFromHexString(path.g) } or CreateColorFromHexString(path)

			return set
		end

		MEDIA.color.interrupt_on_cd = {
			onCD = createColorSets(E.db.mMT.color.interrupt_on_cd.onCD),
			inTime = createColorSets(E.db.mMT.color.interrupt_on_cd.inTime),
			outOfRange = createColorSets(E.db.mMT.color.interrupt_on_cd.outOfRange),
			marker = createColorSets(E.db.mMT.color.interrupt_on_cd.marker),
		}
	end

	if arg == "castbar_shield" or not arg then MEDIA.color.castbar_shield = CreateColorFromHexString(E.db.mMT.color.castbar_shield) end

	if arg == "minimap_skin" or not arg then
		MEDIA.color.minimap_skin.color = CreateColorFromHexString(E.db.mMT.color.minimap_skin.color)
		MEDIA.color.minimap_skin.cardinal = CreateColorFromHexString(E.db.mMT.color.minimap_skin.cardinal)
	end

	if arg == "dock" or not arg then
		MEDIA.color.dock.normal = CreateColorFromHexString(E.db.mMT.color.dock.normal)
		MEDIA.color.dock.hover = CreateColorFromHexString(E.db.mMT.color.dock.hover)
		MEDIA.color.dock.clicked = CreateColorFromHexString(E.db.mMT.color.dock.clicked)
		MEDIA.color.dock.notification = CreateColorFromHexString(E.db.mMT.color.dock.notification)
		MEDIA.color.dock.font = CreateColorFromHexString(E.db.mMT.color.dock.font)
		MEDIA.color.dock.font.hex = E.db.mMT.color.dock.font
		MEDIA.color.dock.store = CreateColorFromHexString(E.db.mMT.color.dock.store)
		MEDIA.color.dock.achievement = CreateColorFromHexString(E.db.mMT.color.dock.achievement)
		MEDIA.color.dock.bags = CreateColorFromHexString(E.db.mMT.color.dock.bags)
		MEDIA.color.dock.character = CreateColorFromHexString(E.db.mMT.color.dock.character)
		MEDIA.color.dock.collection = CreateColorFromHexString(E.db.mMT.color.dock.collection)
		MEDIA.color.dock.durability = CreateColorFromHexString(E.db.mMT.color.dock.durability)
		MEDIA.color.dock.encounter = CreateColorFromHexString(E.db.mMT.color.dock.encounter)
		MEDIA.color.dock.friends = CreateColorFromHexString(E.db.mMT.color.dock.friends)
		MEDIA.color.dock.guild = CreateColorFromHexString(E.db.mMT.color.dock.guild)
	end
end

MEDIA.icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
MEDIA.icon16 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:16:16|t"
MEDIA.icon32 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:32:32|t"
MEDIA.icon64 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:64:64|t"
MEDIA.logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"
MEDIA.fallback = "Interface\\Addons\\ElvUI_mMediaTag\\media\\fallback.tga"

MEDIA.leftClick = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\system\\left.tga:16:16|t"
MEDIA.rightClick = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\system\\right.tga:16:16|t"
MEDIA.middleClick = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\system\\middle.tga:16:16|t"

MEDIA.blank = "Interface\\Addons\\ElvUI_mMediaTag\\media\\blank.tga"

MEDIA.icons = {}

MEDIA.icons.combat = {
	combat01 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_01.tga",
	combat02 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_02.tga",
	combat03 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_03.tga",
	combat04 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_04.tga",
	combat05 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_05.tga",
	combat06 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_06.tga",
	combat07 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_07.tga",
	combat08 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_08.tga",
	combat09 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_09.tga",
	combat10 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_10.tga",
	combat11 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_11.tga",
	combat12 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_12.tga",
	combat13 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_13.tga",
	combat14 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_14.tga",
	combat15 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_15.tga",
	combat16 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_16.tga",
	combat17 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_17.tga",
	combat18 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_18.tga",
	combat19 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_19.tga",
	combat20 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_20.tga",
	combat21 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_21.tga",
	combat22 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_22.tga",
	combat23 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_18.tga",
	combat24 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_19.tga",
	combat25 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_20.tga",
	combat26 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_4.tga",
	combat27 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_5.tga",
}

MEDIA.icons.mail = {
	mail01 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_01.tga",
	mail02 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_02.tga",
	mail03 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_03.tga",
	mail04 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_04.tga",
	mail05 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_05.tga",
	mail06 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_06.tga",
	mail07 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_07.tga",
	mail08 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_08.tga",
	mail09 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_09.tga",
	mail10 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\mail\\mail_10.tga",
}

MEDIA.icons.resting = {
	resting01 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_01.tga",
	resting02 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_02.tga",
	resting03 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_03.tga",
	resting04 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_04.tga",
	resting05 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_05.tga",
	resting06 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_06.tga",
	resting07 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_07.tga",
	resting08 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_08.tga",
	resting09 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_09.tga",
	resting10 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\resting\\resting_10.tga",
}

MEDIA.icons.dice = {
	dice01 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\dice\\dice_01.tga",
	dice02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dice\\dice_02.tga",
	dice03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dice\\dice_03.tga",
	dice04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dice\\dice_04.tga",
	dice05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dice\\dice_05.tga",
	dice06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dice\\dice_06.tga",
}

MEDIA.icons.leader = {
	leader01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\leader\\leader_01.tga",
}

MEDIA.icons.lfg = {
	lfg01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_01.tga",
	lfg02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_02.tga",
	lfg03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_03.tga",
	lfg04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_04.tga",
	lfg05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_05.tga",
	lfg06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_06.tga",
	lfg07 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_07.tga",
	lfg08 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_08.tga",
	lfg09 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_09.tga",
}

MEDIA.arrows = {
	arrow01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_01.tga",
	arrow02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_02.tga",
	arrow03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_03.tga",
	arrow04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_04.tga",
	arrow05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_05.tga",
	arrow06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_06.tga",
	arrow07 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_07.tga",
	arrow08 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_08.tga",
	arrow09 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_09.tga",
	arrow10 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_10.tga",
	arrow11 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_11.tga",
	arrow12 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_12.tga",
	arrow13 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_13.tga",
	arrow14 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_14.tga",
	arrow15 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_15.tga",
	arrow16 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_16.tga",
	arrow17 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_17.tga",
	arrow18 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_18.tga",
	arrow19 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_19.tga",
	arrow20 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_20.tga",
	arrow21 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_21.tga",
	arrow22 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_22.tga",
	arrow23 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_23.tga",
	arrow24 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_24.tga",
	arrow25 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_25.tga",
	arrow26 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_26.tga",
	arrow27 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_27.tga",
	arrow28 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_28.tga",
	arrow29 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_29.tga",
	arrow30 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_30.tga",
	arrow31 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_31.tga",
	arrow32 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_32.tga",
	arrow33 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_33.tga",
	arrow34 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_34.tga",
	arrow35 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_35.tga",
	arrow36 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\arrows\\arrow_36.tga",
}

MEDIA.icons.datatexts = {}

MEDIA.icons.datatexts.combat = {
	combat_01 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_01.tga",
	combat_02 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_02.tga",
	combat_03 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_09.tga",
	combat_04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_4.tga",
	combat_05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_5.tga",
	combat_06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_6.tga",
	combat_07 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_7.tga",
	combat_08 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_07.tga",
	combat_09 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_10.tga",
	combat_10 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_10.tga",
	combat_11 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_11.tga",
	combat_12 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_12.tga",
	combat_13 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_13.tga",
	combat_14 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_14.tga",
	combat_15 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_15.tga",
	combat_16 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_16.tga",
	combat_17 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_17.tga",
	combat_18 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_18.tga",
	combat_19 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_19.tga",
	combat_20 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_20.tga",
	combat_21 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_11.tga",
	combat_22 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_12.tga",
	combat_23 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_13.tga",
	combat_24 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_14.tga",
	combat_25 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_15.tga",
	combat_26 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_16.tga",
	combat_27 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_17.tga",
	combat_28 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat\\combat_18.tga",
}

MEDIA.icons.datatexts.misc = {
	armor = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\armor.tga",
	score = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\score.tga",
	menu_a = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\menu_a.tga",
	menu_b = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\menu_b.tga",
}

MEDIA.icons.datatexts.teleport = {
	teleport01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\teleport_01.tga",
	teleport02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\teleport_02.tga",
	teleport03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\teleport_03.tga",
	teleport04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\teleport_04.tga",
	teleport05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\teleport_05.tga",
	teleport06 = GetItemIcon(6948),
	teleport07 = GetItemIcon(110560),
	teleport08 = GetItemIcon(193588),
}

MEDIA.icons.datatexts.professions = {
	prof_a = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_a.tga",
	prof_b = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_b.tga",
	prof_c = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_c.tga",
	prof_d = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\profession_d.tga",
	prof_e = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\primary_a.tga",
	prof_f = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\primary_b.tga",
	prof_g = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\secondary_a.tga",
	prof_h = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\secondary_b.tga",
}

MEDIA.icons.datatexts.durability = {
	armor_01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\armor.tga",
	armor_02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\armor_b.tga",
	armor_03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\armor_c.tga",
	armor_04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\armor_d.tga",
	shield_01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\shield.tga",
	shield_02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\shield_b.tga",
	shield_03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\shield_c.tga",
}

MEDIA.icons.class = {}

MEDIA.icons.castbar = {
	shield01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\castbar\\shield_01.tga",
	shield02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\castbar\\shield_02.tga",
	shield03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\castbar\\shield_03.tga",
	shield04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\castbar\\shield_04.tga",
	shield05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\castbar\\shield_05.tga",
	sign01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\castbar\\sign_01.tga",
}

MEDIA.icons.dock = {
	material = {
		account_balance_wallet = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\account_balance_wallet.tga",
		agriculture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\agriculture.tga",
		attach_money = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\attach_money.tga",
		auto_stories = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\auto_stories.tga",
		bomb = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\bomb.tga",
		bookmark = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\bookmark.tga",
		bookmark_heart = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\bookmark_heart.tga",
		bookmark_star = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\bookmark_star.tga",
		book_3 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\book_3.tga",
		book_5 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\book_5.tga",
		book_ribbon = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\book_ribbon.tga",
		box = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\box.tga",
		browse = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\browse.tga",
		brush = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\brush.tga",
		build = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\build.tga",
		calendar_month = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\calendar_month.tga",
		calendar_today = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\calendar_today.tga",
		casino = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\casino.tga",
		chat = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\chat.tga",
		chat_bubble = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\chat_bubble.tga",
		chat_info = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\chat_info.tga",
		chef_hat = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\chef_hat.tga",
		child_care = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\child_care.tga",
		collections_bookmark = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\collections_bookmark.tga",
		comment = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\comment.tga",
		contacts_product = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\contacts_product.tga",
		contact_support = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\contact_support.tga",
		contract = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\contract.tga",
		cookie = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\cookie.tga",
		credit_card = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\credit_card.tga",
		design_services = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\design_services.tga",
		desktop_windows = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\desktop_windows.tga",
		developer_guide = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\developer_guide.tga",
		directions_bike = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\directions_bike.tga",
		directions_bus = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\directions_bus.tga",
		diversity_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\diversity_2.tga",
		diversity_4 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\diversity_4.tga",
		draw = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\draw.tga",
		eco = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\eco.tga",
		editor_choice = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\editor_choice.tga",
		edit_square = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\edit_square.tga",
		emoji_objects = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\emoji_objects.tga",
		emoji_transportation = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\emoji_transportation.tga",
		error = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\error.tga",
		euro = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\euro.tga",
		explore = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\explore.tga",
		face = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\face.tga",
		family_link = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\family_link.tga",
		favorite = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\favorite.tga",
		feedback = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\feedback.tga",
		flag_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\flag_2.tga",
		folder_open = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\folder_open.tga",
		format_paint = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\format_paint.tga",
		forum = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\forum.tga",
		group = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\group.tga",
		groups = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\groups.tga",
		handshake = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\handshake.tga",
		handyman = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\handyman.tga",
		healing = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\healing.tga",
		health_and_safety = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\health_and_safety.tga",
		help = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\help.tga",
		help_center = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\help_center.tga",
		history_edu = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\history_edu.tga",
		home = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\home.tga",
		home_max_dots = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\home_max_dots.tga",
		hourglass = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\hourglass.tga",
		house = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\house.tga",
		import_contacts = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\import_contacts.tga",
		ink_pen = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\ink_pen.tga",
		interests = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\interests.tga",
		inventory_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\inventory_2.tga",
		key = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\key.tga",
		license = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\license.tga",
		local_police = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\local_police.tga",
		loyalty = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\loyalty.tga",
		mail = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\mail.tga",
		map = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\map.tga",
		menu_book = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\menu_book.tga",
		money_bag = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\money_bag.tga",
		mood = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\mood.tga",
		note_alt = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\note_alt.tga",
		not_listed_location = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\not_listed_location.tga",
		package_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\package_2.tga",
		palette = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\palette.tga",
		payments = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\payments.tga",
		person = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\person.tga",
		person_pin_circle = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\person_pin_circle.tga",
		pets = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\pets.tga",
		planet = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\planet.tga",
		public = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\public.tga",
		release_alert = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\release_alert.tga",
		reviews = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\reviews.tga",
		rocket_launch = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\rocket_launch.tga",
		savings = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\savings.tga",
		security = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\security.tga",
		sell = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\sell.tga",
		sentiment_satisfied = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\sentiment_satisfied.tga",
		settings = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\settings.tga",
		shield = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\shield.tga",
		shopping_bag = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\shopping_bag.tga",
		shopping_cart = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\shopping_cart.tga",
		skull = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\skull.tga",
		sms = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\sms.tga",
		sports_esports = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\sports_esports.tga",
		sports_football = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\sports_football.tga",
		star = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\star.tga",
		swords = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\swords.tga",
		thermostat_carbon = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\thermostat_carbon.tga",
		toast = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\toast.tga",
		tools_power_drill = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\tools_power_drill.tga",
		tooltip = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\tooltip.tga",
		topic = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\topic.tga",
		travel_explore = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\travel_explore.tga",
		two_wheeler = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\two_wheeler.tga",
		universal_currency_alt = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\universal_currency_alt.tga",
		visibility = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material\\visibility.tga",
	},
	material_filled = {
		account_balance_wallet = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\account_balance_wallet.tga",
		agriculture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\agriculture.tga",
		attach_money = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\attach_money.tga",
		auto_stories = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\auto_stories.tga",
		bomb = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\bomb.tga",
		bookmark = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\bookmark.tga",
		bookmark_heart = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\bookmark_heart.tga",
		bookmark_star = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\bookmark_star.tga",
		book_3 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\book_3.tga",
		book_5 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\book_5.tga",
		book_ribbon = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\book_ribbon.tga",
		box = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\box.tga",
		browse = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\browse.tga",
		brush = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\brush.tga",
		build = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\build.tga",
		calendar_month = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\calendar_month.tga",
		calendar_today = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\calendar_today.tga",
		casino = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\casino.tga",
		chat = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\chat.tga",
		chat_bubble = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\chat_bubble.tga",
		chat_info = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\chat_info.tga",
		chef_hat = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\chef_hat.tga",
		child_care = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\child_care.tga",
		collections_bookmark = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\collections_bookmark.tga",
		comment = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\comment.tga",
		contacts_product = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\contacts_product.tga",
		contact_support = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\contact_support.tga",
		contract = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\contract.tga",
		cookie = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\cookie.tga",
		credit_card = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\credit_card.tga",
		design_services = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\design_services.tga",
		desktop_windows = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\desktop_windows.tga",
		developer_guide = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\developer_guide.tga",
		directions_bike = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\directions_bike.tga",
		directions_bus = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\directions_bus.tga",
		diversity_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\diversity_2.tga",
		diversity_4 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\diversity_4.tga",
		draw = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\draw.tga",
		eco = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\eco.tga",
		editor_choice = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\editor_choice.tga",
		edit_square = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\edit_square.tga",
		emoji_objects = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\emoji_objects.tga",
		emoji_transportation = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\emoji_transportation.tga",
		error = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\error.tga",
		euro = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\euro.tga",
		explore = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\explore.tga",
		face = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\face.tga",
		family_link = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\family_link.tga",
		favorite = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\favorite.tga",
		feedback = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\feedback.tga",
		flag_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\flag_2.tga",
		folder_open = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\folder_open.tga",
		format_paint = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\format_paint.tga",
		forum = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\forum.tga",
		group = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\group.tga",
		groups = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\groups.tga",
		handshake = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\handshake.tga",
		handyman = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\handyman.tga",
		healing = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\healing.tga",
		health_and_safety = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\health_and_safety.tga",
		help = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\help.tga",
		help_center = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\help_center.tga",
		history_edu = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\history_edu.tga",
		home = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\home.tga",
		home_max_dots = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\home_max_dots.tga",
		hourglass = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\hourglass.tga",
		house = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\house.tga",
		import_contacts = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\import_contacts.tga",
		ink_pen = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\ink_pen.tga",
		interests = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\interests.tga",
		inventory_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\inventory_2.tga",
		key = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\key.tga",
		license = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\license.tga",
		local_police = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\local_police.tga",
		loyalty = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\loyalty.tga",
		mail = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\mail.tga",
		map = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\map.tga",
		menu_book = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\menu_book.tga",
		money_bag = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\money_bag.tga",
		mood = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\mood.tga",
		note_alt = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\note_alt.tga",
		not_listed_location = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\not_listed_location.tga",
		package_2 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\package_2.tga",
		palette = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\palette.tga",
		payments = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\payments.tga",
		person = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\person.tga",
		person_pin_circle = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\person_pin_circle.tga",
		pets = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\pets.tga",
		planet = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\planet.tga",
		public = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\public.tga",
		release_alert = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\release_alert.tga",
		reviews = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\reviews.tga",
		rocket_launch = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\rocket_launch.tga",
		savings = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\savings.tga",
		security = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\security.tga",
		sell = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\sell.tga",
		sentiment_satisfied = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\sentiment_satisfied.tga",
		settings = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\settings.tga",
		shield = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\shield.tga",
		shopping_bag = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\shopping_bag.tga",
		shopping_cart = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\shopping_cart.tga",
		skull = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\skull.tga",
		sms = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\sms.tga",
		sports_esports = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\sports_esports.tga",
		sports_football = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\sports_football.tga",
		star = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\star.tga",
		swords = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\swords.tga",
		thermostat_carbon = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\thermostat_carbon.tga",
		toast = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\toast.tga",
		tools_power_drill = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\tools_power_drill.tga",
		tooltip = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\tooltip.tga",
		topic = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\topic.tga",
		travel_explore = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\travel_explore.tga",
		two_wheeler = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\two_wheeler.tga",
		universal_currency_alt = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\universal_currency_alt.tga",
		visibility = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\material_filled\\visibility.tga",
	},
}

MEDIA.minimap = {
	skin = {
		blizz_portrait = {
			name = L["Blizzard Portrait"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait_mask.tga",
		},
		blizz_portrait_v2 = {
			name = L["Blizzard Portrait v2"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait_v2.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait_v2_mask.tga",
		},
		blizz_portrait_v3 = {
			name = L["Blizzard Portrait v3"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait_v3.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait_v3_mask.tga",
		},
		blizz_portrait_v4 = {
			name = L["Blizzard Portrait v4"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait_v4.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\blizz_portrait_v4_mask.tga",
		},
		circle = {
			name = L["Circle"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\circle.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\circle_mask.tga",
		},
		diamond = {
			name = L["Diamond"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\diamond.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\diamond_mask.tga",
		},
		hexagon = {
			name = L["Hexagon"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\hexagon.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\hexagon_mask.tga",
		},
		octagon = {
			name = L["Octagon"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\octagon.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\octagon_mask.tga",
		},
		parallelogram = {
			name = L["Parallelogram"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\parallelogram.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\parallelogram_mask.tga",
		},
		parallelogram_v2 = {
			name = L["Parallelogram v2"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\parallelogram_v2.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\parallelogram_v2_mask.tga",
		},
		parallelogram_v3 = {
			name = L["Parallelogram v3"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\parallelogram_v3.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\parallelogram_v3_mask.tga",
		},
		square = {
			name = L["Square"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\square.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\square_mask.tga",
		},
		square_round = {
			name = L["Square Rounded"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\square_round.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\square_round.tga",
		},
		window = {
			name = L["Window"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\window.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\window_mask.tga",
		},
		zigzag = {
			name = L["Zigzag"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\zigzag.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\zigzag_mask.tga",
		},
		zigzag_v2 = {
			name = L["Zigzag v2"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\zigzag_v2.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\zigzag_v2_mask.tga",
		},
	},
	cardinal = {
		cardinal_v1 = {
			name = L["Cardinal v1"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\cardinal_v1.tga",
		},
		cardinal_v2 = {
			name = L["Cardinal v2"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\cardinal_v2.tga",
		},
		cardinal_v3 = {
			name = L["Cardinal v3"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\cardinal_v3.tga",
		},
		cardinal_v4 = {
			name = L["Cardinal v4"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\cardinal_v4.tga",
		},
		cardinal_v5 = {
			name = L["Cardinal v5"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\cardinal_v5.tga",
		},
		cardinal_v6 = {
			name = L["Cardinal v6"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\cardinal_v6.tga",
		},
		cardinal_v7 = {
			name = L["Cardinal v7"],
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\minimap\\cardinal_v7.tga",
		},
	},
}
