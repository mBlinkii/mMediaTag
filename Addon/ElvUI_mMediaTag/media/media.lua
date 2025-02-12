local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local pairs = pairs

MEDIA.color = {}

local colors = {
    blue = "FF0294FF",
    purple = "FFBD26E5",
    red = "FFFF005D",
    yellow = "FFFF9D00",
    green = "FF1BFF6B",
    black = "FF404040"
}

for name, color in pairs(colors) do
    MEDIA.color[name] = CreateColorFromHexString(color)
end


MEDIA.icon = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icon.tga:14:14|t"
MEDIA.icon16 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:16:16|t"
MEDIA.icon32 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:32:32|t"
MEDIA.icon64 = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mmt_16.tga:64:64|t"
MEDIA.logo = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga"

MEDIA.icons = {}

MEDIA.icons.combat = {
    combat01 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_01.tga",
    combat02 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_02.tga",
    combat03 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_03.tga",
    combat04 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_04.tga",
    combat05 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_05.tga",
    combat06 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_06.tga",
    combat07 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_07.tga",
    combat08 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_08.tga",
    combat09 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_09.tga",
    combat10 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_10.tga",
    combat11 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_11.tga",
    combat12 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_12.tga",
    combat13 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_13.tga",
    combat14 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_14.tga",
    combat15 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_15.tga",
    combat16 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_16.tga",
    combat17 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_17.tga",
    combat18 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_18.tga",
    combat19 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_19.tga",
    combat20 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_20.tga",
    combat21 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_21.tga",
    combat22 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\icons\\combat_22.tga",
}
