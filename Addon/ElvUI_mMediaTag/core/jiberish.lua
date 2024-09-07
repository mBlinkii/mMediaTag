local L = mMT.Locales
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
function mMT:JiberishIcons()
	local jib_tbl = {
		loaded = IsAddOnLoaded("ElvUI_JiberishIcons"),
		path = nil,
		styles = {},
		texCoords = {},
	}

	if not jib_tbl.loaded then return jib_tbl end

	local version = GetAddOnMetadata("ElvUI_JiberishIcons", "Version")
	local unknownVersion = version ~= "1.1.5"

	local JIB = _G.ElvUI_JiberishIcons and unpack(_G.ElvUI_JiberishIcons)

    if not JIB then
		jib_tbl.loaded = false
		mMT:Print("|CFFEA1818Error|r:", L["When loading the textures of JiberishUI icons."])
		return jib_tbl
	end

	if JIB and unknownVersion then
		-- load backup settings so that people don't blame me =(
		jib_tbl.path = [[Interface\AddOns\ElvUI_JiberishIcons\Media\Class\]]
		jib_tbl.styles = {
			fabled = "Jiberish Fabled",
			fabledrealm = "Jiberish Fabled Realm",
			fabledpixels = "Jiberish Fabled Pixels",
		}

		jib_tbl.texCoords = {
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

        mMT:Print("|CFFEA1818Info|r:", L["mMediaTag needs an update to support the current version of JiberishUI icons, it is possible that the class icons are not displayed correctly on the portraits."])
        return jib_tbl
    end

	jib_tbl.path = JIB.icons.class.path

	for style, value in pairs(JIB.icons.class.styles) do
		if value and value.name then jib_tbl.styles[style] = "Jiberish " .. value.name end
	end

	for class, value in pairs(JIB.icons.class.data) do
		if value and value.texCoords then jib_tbl.texCoords[class] = value.texCoords end
	end

	return jib_tbl
end
