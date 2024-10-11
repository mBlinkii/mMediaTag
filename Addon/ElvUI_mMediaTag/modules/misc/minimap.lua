local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule("Minimap")
local module = mMT.Modules.Minimap
if not module then return end

local Minimap = _G.Minimap

local aspectRatios = {
	["3:2"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\3-2.tga",
		aspectratio = 1.5,
		offset = 1,
	},
	["4:3"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\4-3.tga",
		aspectratio = 1.33333,
		offset = 2,
	},
	["16:8"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-8.tga",
		aspectratio = 2,
		offset = 1,
	},
	["16:9"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-9.tga",
		aspectratio = 1.77777,
		offset = 1,
	},
	["16:10"] = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\aspectratio\\16-10.tga",
		aspectratio = 1.6,
		offset = 1,
	},
}

function SkinMinimap()
	local aspectRatio = aspectRatios[E.db.mMT.minimap.aspectRatio]
	local width = E.MinimapSize
	local height = width / aspectRatio.aspectratio
	local half = (width - height)

	Minimap:SetSize(width, width)
	M.MapHolder:SetSize(width, height)
	Minimap:SetMaskTexture(aspectRatio.mask)

	-- local function SetOutside(obj, anchor, xOffset, yOffset, anchor2, noScale)
	local yOffset = -ceil(half / 2) + aspectRatio.offset
	Minimap.backdrop:ClearAllPoints()
	Minimap.backdrop:SetOutside(Minimap, 1, yOffset)

    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPLEFT", M.MapHolder, "TOPLEFT", 0, - yOffset + aspectRatio.offset)

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
