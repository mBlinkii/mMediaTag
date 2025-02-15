local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local pairs = pairs
local CreateColorFromHexString = CreateColorFromHexString
local strjoin = strjoin

MEDIA.color = {}

local colors = {
	blue = "FF0294FF",
	purple = "FFBD26E5",
	red = "FFFF005D",
	yellow = "FFFF9D00",
	green = "FF1BFF6B",
	black = "FF404040",
	info = "FFFFA7A7",
}

MEDIA.classColor = E:ClassColor(E.myclass)

for name, color in pairs(colors) do
	MEDIA.color[name] = CreateColorFromHexString(color)
end

function mMT:UpdateMedia()
	local classColor = MEDIA.classColor
	if not MEDIA.classColor.hex then MEDIA.classColor.hex = E:RGBToHex(classColor.r, classColor.g, classColor.b) end

	if not MEDIA.classColor.string then MEDIA.classColor.string = strjoin("", MEDIA.classColor.hex, "%s|r") end

	if not MEDIA.classColor.gradient then
		MEDIA.classColor.gradient =
		{ a = { r = classColor.r - 0.2, g = classColor.g - 0.2, b = classColor.b - 0.2, a = 1 }, b = { r = classColor.r + 0.2, g = classColor.g + 0.2, b = classColor.b + 0.2, a = 1 } }
	end
end

MEDIA.icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
MEDIA.icon16 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:16:16|t"
MEDIA.icon32 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:32:32|t"
MEDIA.icon64 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:64:64|t"
MEDIA.logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"

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
