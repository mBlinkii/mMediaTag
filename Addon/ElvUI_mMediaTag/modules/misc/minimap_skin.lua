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
	drop = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop.tga",
		extra = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop_extra.tga",
	},
	drop_round = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop_round_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop_round.tga",
		extra = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\drop_extra.tga",
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
		cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\paralelogram_cardinal.tga",
	},
	paralelogram_horizontal = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\paralelogram_horizontal_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\paralelogram_horizontal.tga",
		cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\paralelogram_horizontal_cardinal.tga",
	},
	zickzag = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\zickzag_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\zickzag.tga",
		cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\zickzag_cardinal.tga",
		extra = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\zickzag_extra.tga",
	},
	antique = {
		mask = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\antique_mask.tga",
		texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\antique.tga",
		--cardinal = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\zickzag_cardinal.tga",
		extra = "Interface\\Addons\\ElvUI_mMediaTag\\media\\minimap\\skin\\antique_extra.tga",
	},
}

local function CreateOrUpdateTexture(name, layer, level, texture, color)
	if not Minimap[name] then
		Minimap[name] = Minimap:CreateTexture(name, layer, nil, level)
		Minimap[name]:SetAllPoints(Minimap)
	end
	Minimap[name]:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
	Minimap[name]:Show()
	if color then Minimap[name]:SetVertexColor(color.r, color.g, color.b, color.a or 1) end
end

local function SkinMinimap()
	local skin = E.db.mMT.minimapSkin.custom.enable and E.db.mMT.minimapSkin.custom or skins[E.db.mMT.minimapSkin.skin]

	local color = E.db.mMT.minimapSkin.colors.texture.class and mMT.ClassColor or E.db.mMT.minimapSkin.colors.texture.color
	CreateOrUpdateTexture("mMT_Minimap_Skin", "OVERLAY", 2, skin.texture, color)

	if E.db.mMT.minimapSkin.cardinal and skin.cardinal then
		color = E.db.mMT.minimapSkin.colors.cardinal.class and mMT.ClassColor or E.db.mMT.minimapSkin.colors.cardinal.color
		CreateOrUpdateTexture("mMT_Cardinal", "OVERLAY", 3, skin.cardinal, color)
	else
		if Minimap.mMT_Cardinal then Minimap.mMT_Cardinal:Hide() end
	end

	if E.db.mMT.minimapSkin.effect and skin.extra then
		color = E.db.mMT.minimapSkin.colors.extra.class and mMT.ClassColor or E.db.mMT.minimapSkin.colors.extra.color
		CreateOrUpdateTexture("mMT_Extra", "OVERLAY", 1, skin.extra, color)
	else
		if Minimap.mMT_Extra then Minimap.mMT_Extra:Hide() end
	end

	Minimap:SetMaskTexture(skin.mask)
	Minimap.backdrop:Hide()
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
