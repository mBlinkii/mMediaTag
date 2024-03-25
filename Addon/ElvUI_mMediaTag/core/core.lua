local E = unpack(ElvUI)
local strjoin = strjoin
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata

-- AddonCompartment Functions
function ElvUI_mMediaTag_OnAddonCompartmentClick()
	E:ToggleOptions("mMT")
end

function ElvUI_mMediaTag_OnAddonCompartmentOnEnter()
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_RIGHT")
	GameTooltip:AddDoubleLine(mMT.Name, format("|CFFF7DC6FVer. %s|r", mMT.Version))
	GameTooltip:Show()
end

function ElvUI_mMediaTag_OnAddonCompartmentOnLeave()
	GameTooltip:Hide()
end

function mMT:UpdateClassColor()
	--local class = mMT.Modules.CustomClassColors.enable and E.db.mMT.classcolors.colors[E.myclass] or E:ClassColor(E.myclass)
	local class = E:ClassColor(E.myclass)
	local hex = E:RGBToHex(class.r, class.g, class.b)
	return { r = class.r, g = class.g, b = class.b, hex = hex, string = strjoin("", hex, "%s|r") }
end

function mMT:CheckEltruism()
	local elt_tbl = {
		loaded = IsAddOnLoaded("ElvUI_EltreumUI"),
		gradient = false,
		dark = false,
	}

	if elt_tbl.loaded then
		elt_tbl.gradient = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.gradientmode and E.db.ElvUI_EltreumUI.unitframes.gradientmode.enable
		elt_tbl.dark = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.darkmode
	end

	return elt_tbl
end

function mMT:JiberishIcons()
	local jib_tbl = {
		version = nil,
		old = true,
		loaded = IsAddOnLoaded("ElvUI_JiberishIcons"),
		path = nil,
		styles = {},
		texCoords = {},
	}

	if jib_tbl.loaded then
		jib_tbl.version = GetAddOnMetadata("ElvUI_JiberishIcons", "Version")

		if jib_tbl.version then
			local major, minor, patch  = strsplit(".", jib_tbl.version, 3)
			jib_tbl.old = tonumber(major) <= 1 and tonumber(minor) == 0 and tonumber(patch) <= 3
		end

		if jib_tbl.old then
			jib_tbl.path = "Interface\\AddOns\\ElvUI_JiberishIcons\\Media\\Icons\\"

			for StyleName, _ in pairs(_G.ElvUI_JiberishIcons.iconStyles) do
				jib_tbl.styles[StyleName] = "Jiberish " .. StyleName
			end

			jib_tbl.texCoords = {
				WARRIOR = { 0, 0.125, 0, 0.125 }, -- '0:128:0:128'
				MAGE = { 0.125, 0.25, 0, 0.125 }, --'128:256:0:128',
				ROGUE = { 0.25, 0.375, 0, 0.125 }, --'256:384:0:128',
				DRUID = { 0.375, 0.5, 0, 0.125 }, -- '384:512:0:128',
				EVOKER = { 0.5, 0.625, 0, 0.125 }, --'512:640:0:128',
				HUNTER = { 0, 0.125, 0.125, 0.25 }, --'0:128:128:256',
				SHAMAN = { 0.125, 0.25, 0.125, 0.25 }, --'128:256:128:256',
				PRIEST = { 0.25, 0.375, 0.125, 0.25 }, --'256:384:128:256',
				WARLOCK = { 0.375, 0.5, 0.125, 0.25 }, --'384:512:128:256',
				PALADIN = { 0, 0.125, 0.25, 0.375 }, --'0:128:256:384',
				DEATHKNIGHT = { 0.125, 0.25, 0.25, 0.375 }, --'128:256:256:384',
				MONK = { 0.25, 0.375, 0.25, 0.375 }, --'256:384:256:384',
				DEMONHUNTER = { 0.375, 0.5, 0.25, 0.375 }, --'384:512:256:384',
			}
		else
			local JIB, _ = unpack(_G.ElvUI_JiberishIcons)
			jib_tbl.path = JIB.classIconPath

			for StyleName, _ in pairs(JIB.iconStyles) do
				jib_tbl.styles[StyleName] = "Jiberish " .. StyleName
			end

			for class, value in pairs(JIB.classIcons) do
				jib_tbl.texCoords[class] = value.texCoords
			end
		end
	end

	return jib_tbl
end

function mMT:GetDevNames()
	return {
		["Blinkii"] = true,
		["Flinkii"] = true,
		["Raeldan"] = true,
	}
end

function mMT:ClassesTable()
	if E.Retail then
		return { "DEATHKNIGHT", "DEMONHUNTER", "DRUID", "EVOKER", "HUNTER", "MAGE", "MONK", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR" }
	elseif E.Classic then
		return { "HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR" }
	elseif E.Wrath then
		return { "HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR", "DEATHKNIGHT" }
	end
end
