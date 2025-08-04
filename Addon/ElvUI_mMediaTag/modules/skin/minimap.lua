local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("Minimap", { "AceHook-3.0" })

local MM = E:GetModule("Minimap")

local minimapSkins = {


}

local function AddSkin()
	local skin = module.db.custom.enable and module.db.custom or MEDIA.minimap[E.db.mMT.minimapSkin.skin]

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
	if E.db.mMT.minimap.enable then
		if not module.isEnabled then
			hooksecurefunc(M, "UpdateSettings", AddSkin)
			module.isEnabled = true
		end

		AddSkin()

		module.db = E.db.mMT.minimap
	end
end
