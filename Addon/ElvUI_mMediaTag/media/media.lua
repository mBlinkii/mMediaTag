local mMT, DB, M, E, L, MEDIA = unpack(ElvUI_mMediaTag)

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
