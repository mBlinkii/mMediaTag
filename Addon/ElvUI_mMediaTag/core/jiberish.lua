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

	if not jib_tbl.loaded then
		return jib_tbl
	end

	local version = GetAddOnMetadata("ElvUI_JiberishIcons", "Version")
	local JIB = _G.ElvUI_JiberishIcons and unpack(_G.ElvUI_JiberishIcons)

	if not JIB or not JIB.icons.class.styles or version ~= "1.1.5" then
		jib_tbl.loaded = false
		mMT:Print("|CFFEA1818Error|r:", L["The JiberishUI icons cannot be loaded due to compatibility issues. The version used is incompatible with the supported version."])
		return jib_tbl
	end

	jib_tbl.path = JIB.icons.class.path

	for style, value in pairs(JIB.icons.class.styles) do
		if value and value.name then
			jib_tbl.styles[style] = "Jiberish " .. value.name
		end
	end

	for class, value in pairs(JIB.icons.class.data) do
		if value and value.texCoords then
			jib_tbl.texCoords[class] = value.texCoords
		end
	end

	return jib_tbl
end
