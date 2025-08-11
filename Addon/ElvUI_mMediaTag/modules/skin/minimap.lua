local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("MinimapSkin", { "AceHook-3.0" })

local MM = E:GetModule("Minimap")
local Minimap = _G.Minimap

local function SetMinimapSkin()
	if not (module.db and module.db.enable) then return end

	local style = module.db.style
	local cardinal = MEDIA.minimap.cardinal[E.db.mMT.minimap_skin.cardinal]
	local skin = MEDIA.minimap.skin[style]

	local color = (module.db.color == "class") and MEDIA.myclass or MEDIA.color.minimap_skin.color

	if not Minimap.mMT_Minimap_Skin then
		local tex = Minimap:CreateTexture("mMT_Minimap_Skin", "OVERLAY", nil, 2)
		tex:SetAllPoints(Minimap)
		Minimap.mMT_Minimap_Skin = tex
	end

	if E.db.mMT.minimap_skin.cardinal ~= "none" then
		local color_cardinal = (module.db.color_cardinal == "class") and MEDIA.myclass or MEDIA.color.minimap_skin.cardinal
		if not Minimap.mMT_Minimap_Skin_Cardinal then
			local cardinal_texture = Minimap:CreateTexture("mMT_Minimap_Skin_Cardinal", "OVERLAY", nil, 3)
			cardinal_texture:SetAllPoints(Minimap)
			Minimap.mMT_Minimap_Skin_Cardinal = cardinal_texture
		end

		Minimap.mMT_Minimap_Skin_Cardinal:SetTexture(cardinal.texture, "CLAMP", "CLAMP", "TRILINEAR")
		if color then Minimap.mMT_Minimap_Skin_Cardinal:SetVertexColor(color_cardinal.r, color_cardinal.g, color_cardinal.b, color_cardinal.a or 1) end
	elseif Minimap.mMT_Minimap_Skin_Cardinal then
		Minimap.mMT_Minimap_Skin_Cardinal:Hide()
	end

	Minimap.mMT_Minimap_Skin:SetTexture(skin.texture, "CLAMP", "CLAMP", "TRILINEAR")
	if color then Minimap.mMT_Minimap_Skin:SetVertexColor(color.r, color.g, color.b, color.a or 1) end

	if skin.mask then Minimap:SetMaskTexture(skin.mask) end

	if Minimap.backdrop then Minimap.backdrop:Hide() end

	Minimap.mMT_Minimap_Skin:Show()
end

function module:Initialize()
	module.db = E.db.mMT.minimap_skin

	if module.db and module.db.enable then
		if not module.isEnabled then
			hooksecurefunc(MM, "UpdateSettings", SetMinimapSkin)
			E:SetCVar("rotateMinimap", MM.db.rotate and 1 or 0)
			module.isEnabled = true
		end

		SetMinimapSkin()
	elseif Minimap.mMT_Minimap_Skin then
		Minimap.mMT_Minimap_Skin:Hide()

		if Minimap.backdrop then Minimap.backdrop:Show() end

		MM:SetMinimapMask(not MM.db.circle)
		MM:SetMinimapRotate()
	end
end
