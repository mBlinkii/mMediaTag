
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

local classIconPath = "Interface\\Addons\\ElvUI_mMediaTag\\media\\class\\"
local classIconStrings = {
	WARRIOR = "0:128:0:128",
	MAGE = "128:256:0:128",
	ROGUE = "256:384:0:128",
	DRUID = "384:512:0:128",
	EVOKER = "512:640:0:128",
	HUNTER = "0:128:128:256",
	SHAMAN = "128:256:128:256",
	PRIEST = "256:384:128:256",
	WARLOCK = "384:512:128:256",
	PALADIN = "0:128:256:384",
	DEATHKNIGHT = "128:256:256:384",
	MONK = "256:384:256:384",
	DEMONHUNTER = "384:512:256:384",
}

local classIcons = {
	border = "mmt_border.tga",
	classborder = "mmt_classcolored_border.tga",
	hdborder = "mmt_hd_border.tga",
	hdclassborder = "mmt_hd_class.tga",
	hdround = "mmt_hd_round.tga",
	transparent = "mmt_transparent.tga",
	transparentplus = "mmt_transparent_colorboost.tga",
	transparentshadow = "mmt_transparent_shadow.tga",
	transparentshadowplus = "mmt_transparent_colorboost_shadow.tga",
	outline = "mmt_transparent_outline.tga",
	outlineplus = "mmt_transparent_outline_colorboost.tga",
	outlineshadow = "mmt_transparent_outline_shadow.tga",
	outlineshadowplus = "mmt_transparent_outline_shadow_colorboost.tga",
}

local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\class\\"
local textureCoords = {
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

function mMT:SetupDetails()
    for iconStyle, data in next, classInfo.styles do
        _G.Details:AddCustomIconSet(format('%s%s', classInfo.path, iconStyle), format('%s (Class)', data.name), false)
    end
end
