-- function Details:AddCustomIconSet(path, dropdownLabel, isSpecIcons, dropdownIcon, dropdownIconTexCoords, dropdownIconSize, dropdownIconColor)
--     --checking the parameters to improve debug for the icon set author
--     assert(self == Details, "Details:AddCustomIconSet() did you used Details.AddCustomIconSet instead of Details:AddCustomIconSet?")
--     assert(type(path) == "string", "Details:AddCustomIconSet() 'path' must be a string.")
--     assert(string.len(path) > 16, "Details:AddCustomIconSet() invalid path.")

--     table.insert(Details222.BarIconSetList,
--         {
--             value = path,
--             label = dropdownLabel or "Missing Label",
--             isSpec = isSpecIcons,
--             icon = dropdownIcon or defaultIconTexture,
--             texcoord = dropdownIconTexCoords or (isSpecIcons and defaultSpecIconCoords or defaultClassIconCoords),
--             iconsize = dropdownIconSize or defaultIconSize,
--             iconcolor = dropdownIconColor
--         }
--     )

--     return true
-- end

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

local dropdownIconTexCoords = {
	WARRIOR = { 0, 0, 0, 0.125, 0.125, 0, 0.125, 0.125 },
	MAGE = { 0.125, 0, 0.125, 0.125, 0.25, 0, 0.25, 0.125 },
	ROGUE = { 0.25, 0, 0.25, 0.125, 0.375, 0, 0.375, 0.125 },
	DRUID = { 0.375, 0, 0.375, 0.125, 0.5, 0, 0.5, 0.125 },
	EVOKER = { 0.5, 0, 0.5, 0.125, 0.625, 0, 0.625, 0.125 },
	HUNTER = { 0, 0.125, 0, 0.25, 0.125, 0.125, 0.125, 0.25 },
	SHAMAN = { 0.125, 0.125, 0.125, 0.25, 0.25, 0.125, 0.25, 0.25 },
	PRIEST = { 0.25, 0.125, 0.25, 0.25, 0.375, 0.125, 0.375, 0.25 },
	WARLOCK = { 0.375, 0.125, 0.375, 0.25, 0.5, 0.125, 0.5, 0.25 },
	PALADIN = { 0, 0.25, 0, 0.375, 0.125, 0.25, 0.125, 0.375 },
	DEATHKNIGHT = { 0.125, 0.25, 0.125, 0.375, 0.25, 0.25, 0.25, 0.375 },
	MONK = { 0.25, 0.25, 0.25, 0.375, 0.375, 0.25, 0.375, 0.375 },
	DEMONHUNTER = { 0.375, 0.25, 0.375, 0.375, 0.5, 0.25, 0.5, 0.375 },
}

local dropdownIcon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga"
function mMT:SetupDetails()
	for _, data in next, styles do
		_G.Details:AddCustomIconSet(data.texture, data.name, false, dropdownIcon, {0, 1, 0, 1})
	end
end
