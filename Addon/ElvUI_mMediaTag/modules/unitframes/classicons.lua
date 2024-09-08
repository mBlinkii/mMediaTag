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

mMT:AddClassIcons("mmt_bevel", path .. "mmt_class_bevel.tga",  textureCoords, "mMT Bevel")
mMT:AddClassIcons("mmt_clean", path .. "mmt_class_clean.tga",  textureCoords, "mMT Clean")
mMT:AddClassIcons("mmt_withe", path .. "mmt_class_withe.tga",  textureCoords, "mMT Withe")
mMT:AddClassIcons("BLIZZARD", "Interface\\WorldStateFrame\\Icons-Classes",  CLASS_ICON_TCOORDS, "Blizzard")
