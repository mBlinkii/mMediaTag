local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\class\\"

local styles = {
	border = {
		name = mMT.NameShort .. "- Border",
		texture = path .. "mmt_border.tga",
	},
	classborder = {
		name = mMT.NameShort .. "- Class Border",
		texture = path .. "mmt_classcolored_border.tga",
	},
	hdborder = {
		name = mMT.NameShort .. "- HD Border",
		texture = path .. "mmt_hd_border.tga",
	},
	hdclassborder = {
		name = mMT.NameShort .. "- HD Class Border",
		texture = path .. "mmt_hd_class.tga",
	},
	hdround = {
		name = mMT.NameShort .. "- HD Round",
		texture = path .. "mmt_hd_round.tga",
	},
	transparent = {
		name = mMT.NameShort .. "- Transparent A",
		texture = path .. "mmt_transparent.tga",
	},
	transparentshadow = {
		name = mMT.NameShort .. "- Transparent B",
		texture = path .. "mmt_transparent_shadow.tga",
	},
	transparentplus = {
		name = mMT.NameShort .. "- Transparent C",
		texture = path .. "mmt_transparent_colorboost.tga",
	},
	transparentshadowplus = {
		name = mMT.NameShort .. "- Transparent D",
		texture = path .. "mmt_transparent_colorboost_shadow.tga",
	},
	outline = {
		name = mMT.NameShort .. "- Outline A",
		texture = path .. "mmt_transparent_outline.tga",
	},
	outlineshadow = {
		name = mMT.NameShort .. "- Outline B",
		texture = path .. "mmt_transparent_outline_shadow.tga",
	},
	outlineplus = {
		name = mMT.NameShort .. "- Outline C",
		texture = path .. "mmt_transparent_outline_colorboost.tga",
	},
	outlineshadowplus = {
		name = mMT.NameShort .. "- Outline D",
		texture = path .. "mmt_transparent_outline_shadow_colorboost.tga",
	},
}

local dropdownIcon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga"
function mMT:SetupDetails()
	for _, data in next, styles do
		_G.Details:AddCustomIconSet(data.texture, data.name, false, dropdownIcon, {0, 1, 0, 1})
	end
end
