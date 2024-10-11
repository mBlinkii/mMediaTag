local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule("Minimap")
local module = mMT.Modules.Minimap
if not module then return end

local Minimap = _G.Minimap

local aspectRatios = {
    ["4:3"] = 4 / 3,
    ["16:8"] = 16 / 8,
    ["16:9"] = 16 / 9,
    ["16:10"] = 16 / 10,
    ["15:10"] = 15 / 10,
    ["3:2"] = 3 / 2,
}

function SkinMinimap()
    local aspectRatio = E.db.mMT.minimap.aspectRatio
    local width = E.MinimapSize
    local height = width / aspectRatios[aspectRatio]

    Minimap:SetSize(width, height)
end

function module:Initialize()
    if not module.hooked then
        hooksecurefunc(M, "UpdateSettings", SkinMinimap)
        module.hooked = true
    end

    SkinMinimap()

    module.needReloadUI = true
    module.loaded = true
end
