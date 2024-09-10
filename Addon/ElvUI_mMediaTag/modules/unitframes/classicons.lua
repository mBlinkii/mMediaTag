local L = mMT.Locales

local type = type
local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\class\\"
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

-- style = texture style, textur = path to the texture, table with texture coords for each class, name = optional name to show in dopdown menu
function mMT:AddClassIcons(style, texture, texCoords, name)
	if type(texCoords) ~= "table" then
		mMT:Print("|CFFEA1818Error|r:", L["The texture coordinates must be passed as a table."])
		return
	end

	if style and texture and texCoords then
		mMT.classIcons[style] = {
            name = name or style,
			texture = texture,
			texCoords = texCoords,
		}
	else
		mMT:Print("|CFFEA1818Error|r:", L["Could not add the texture."])
	end
end

mMT:AddClassIcons("mmt_border", path .. "mmt_border.tga",  textureCoords, "mMT Frame A")
mMT:AddClassIcons("mmt_classcolored_border", path .. "mmt_classcolored_border.tga",  textureCoords, "mMT Frame B")

mMT:AddClassIcons("mmt_transparent", path .. "mmt_transparent.tga",  textureCoords, "mMT Transparent A")
mMT:AddClassIcons("mmt_transparent_shadow", path .. "mmt_transparent_shadow.tga",  textureCoords, "mMT Transparent B")
mMT:AddClassIcons("mmt_transparent_colorboost", path .. "mmt_transparent_colorboost.tga",  textureCoords, "mMT Transparent C")
mMT:AddClassIcons("mmt_transparent_colorboost_shadow", path .. "mmt_transparent_colorboost_shadow.tga",  textureCoords, "mMT Transparent D")

mMT:AddClassIcons("mmt_transparent_outline", path .. "mmt_transparent_outline.tga",  textureCoords, "mMT Transparent Outline A")
mMT:AddClassIcons("mmt_transparent_outline_shadow", path .. "mmt_transparent_outline_shadow.tga",  textureCoords, "mMT Transparent Outline B")
mMT:AddClassIcons("mmt_transparent_outline_colorboost", path .. "mmt_transparent_outline_colorboost.tga",  textureCoords, "mMT Transparent Outline C")
mMT:AddClassIcons("mmt_transparent_outline_shadow_colorboost", path .. "mmt_transparent_outline_shadow_colorboost.tga",  textureCoords, "mMT Transparent Outline D")

mMT:AddClassIcons("BLIZZARD", "Interface\\WorldStateFrame\\Icons-Classes",  CLASS_ICON_TCOORDS, "Blizzard")
