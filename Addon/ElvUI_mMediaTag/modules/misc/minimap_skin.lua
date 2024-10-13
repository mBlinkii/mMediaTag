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
		--Interface\Addons\ElvUI_mMediaTag\media\portraits\pad\
	},
}

local function SkinMinimap()
	local skin = E.db.mMT.minimapSkin.custom.enable and E.db.mMT.minimapSkin.custom or skins[E.db.mMT.minimapSkin.skin]

	if not Minimap.mMT_Border then
		Minimap.mMT_Border = Minimap:CreateTexture("mMT_Minimap_Skin", "OVERLAY", nil, 2)
		Minimap.mMT_Border:SetAllPoints(Minimap)
	end

	if E.db.mMT.minimapSkin.cardinal and skin.cardinal then
		if not Minimap.mMT_Cardinal then
			Minimap.mMT_Cardinal = Minimap:CreateTexture("mMT_Minimap_Cardinal", "OVERLAY", nil, 3)
			Minimap.mMT_Cardinal:SetAllPoints(Minimap)
		end
		Minimap.mMT_Cardinal:SetTexture(skin.cardinal, "CLAMP", "CLAMP", "TRILINEAR")
		Minimap.mMT_Cardinal:Show()

		local color = E.db.mMT.minimapSkin.colors.cardinal.class and mMT.ClassColor or E.db.mMT.minimapSkin.colors.cardinal.color
		if color then
			Minimap.mMT_Cardinal:SetVertexColor(color.r, color.g, color.b, color.a or 1)
		end
	else
		if Minimap.mMT_Cardinal then
			Minimap.mMT_Cardinal:Hide()
		end
	end

	if E.db.mMT.minimapSkin.effect and skin.extra then
		if not Minimap.mMT_Extra then
			Minimap.mMT_Extra = Minimap:CreateTexture("mMT_Minimap_Extra", "OVERLAY", nil, 1)
			Minimap.mMT_Extra:SetAllPoints(Minimap)
		end
		Minimap.mMT_Extra:SetTexture(skin.extra, "CLAMP", "CLAMP", "TRILINEAR")
		Minimap.mMT_Extra:Show()

		local color = E.db.mMT.minimapSkin.colors.extra.class and mMT.ClassColor or E.db.mMT.minimapSkin.colors.extra.color
		if color then
			Minimap.mMT_Extra:SetVertexColor(color.r, color.g, color.b, color.a or 1)
		end
	else
		if Minimap.mMT_Extra then
			Minimap.mMT_Extra:Hide()
		end
	end

	Minimap:SetMaskTexture(skin.mask)
	Minimap.backdrop:Hide()
	Minimap.mMT_Border:SetTexture(skin.texture, "CLAMP", "CLAMP", "TRILINEAR")
	local color = E.db.mMT.minimapSkin.colors.texture.class and mMT.ClassColor or E.db.mMT.minimapSkin.colors.texture.color
	if color then
		Minimap.mMT_Border:SetVertexColor(color.r, color.g, color.b, color.a or 1)
	end
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
