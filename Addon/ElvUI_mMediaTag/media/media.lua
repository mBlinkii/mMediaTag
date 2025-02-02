local mMT, db, M, F, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

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
