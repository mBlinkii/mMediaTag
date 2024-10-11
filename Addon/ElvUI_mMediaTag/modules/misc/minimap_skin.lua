local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule("Minimap")
local module = mMT.Modules.MinimapSkin
if not module then return end

local Minimap = _G.Minimap

local skins = {
	circle = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\circle_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\circle.tga",
		cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\circle_cardinal.tga",
	},
	drop_a = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop_a_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop_a.tga",
		--cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\cardinal.tga",
	},
	hexagon = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\hexagon_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\hexagon.tga",
		cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\cardinal_a.tga",
	},
	octagon = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\octagon_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\octagon.tga",
		cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\cardinal_a.tga",
	},
	paralelogram = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\paralelogram_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\paralelogram.tga",
		--cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\cardinal.tga",
	},
}

local function SkinMinimap()
	local skin = skins[E.db.mMT.minimapSkin.skin]

	if not Minimap.mMT_Border then
		Minimap.mMT_Border = Minimap:CreateTexture("mMT_Minimap_Skin", "OVERLAY", nil, 1)
		Minimap.mMT_Border:SetAllPoints(Minimap)
	end

	if skin.cardinal then
		if not Minimap.mMT_Cardinal then
			Minimap.mMT_Cardinal = Minimap:CreateTexture("mMT_Minimap_Cardinal", "OVERLAY", nil, 2)
			Minimap.mMT_Cardinal:SetAllPoints(Minimap)
		end
		Minimap.mMT_Cardinal:SetTexture(skin.cardinal, "CLAMP", "CLAMP", "TRILINEAR")
		Minimap.mMT_Cardinal:Show()
	else
		if Minimap.mMT_Cardinal then
			Minimap.mMT_Cardinal:Hide()
		end
	end

	Minimap:SetMaskTexture(skin.mask)
	Minimap.backdrop:Hide()
	Minimap.mMT_Border:SetTexture(skin.texture, "CLAMP", "CLAMP", "TRILINEAR")
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
