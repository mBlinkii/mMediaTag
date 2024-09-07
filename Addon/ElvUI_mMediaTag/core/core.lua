local E = unpack(ElvUI)
local strjoin = strjoin
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local GetNumAddOns = _G.C_AddOns and _G.C_AddOns.GetNumAddOns or _G.GetNumAddOns
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local EnableAddOn = _G.C_AddOns and _G.C_AddOns.EnableAddOn or _G.EnableAddOn
local DisableAddOn = _G.C_AddOns and _G.C_AddOns.DisableAddOn or _G.DisableAddOn
local GetAddOnInfo = _G.C_AddOns and _G.C_AddOns.GetAddOnInfo or _G.GetAddOnInfo

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
	local class = E:ClassColor(E.myclass)
	local hex = E:RGBToHex(class.r, class.g, class.b)
	local gradient = ((mMT.ElvUI_EltreumUI.loaded and mMT.ElvUI_EltreumUI.colors[E.myclass]) or (mMT.ElvUI_MerathilisUI.loaded and mMT.ElvUI_MerathilisUI.colors[E.myclass]))
		or { a = { r = class.r - 0.2, g = class.g - 0.2, b = class.b - 0.2, a = 1 }, b = { r = class.r + 0.2, g = class.g + 0.2, b = class.b + 0.2, a = 1 } }
	return { class = class, r = class.r, g = class.g, b = class.b, hex = hex, string = strjoin("", hex, "%s|r"), gradient = gradient }
end

function mMT:Update_MP_Settings()
	if IsAddOnLoaded("!mMT_MediaPack") then
		mMTSettings.all = E.db.mMT.mp_textures.all
		mMTSettings.a = E.db.mMT.mp_textures.a
		mMTSettings.b = E.db.mMT.mp_textures.b
		mMTSettings.c = E.db.mMT.mp_textures.c
		mMTSettings.d = E.db.mMT.mp_textures.d
		mMTSettings.e = E.db.mMT.mp_textures.e
		mMTSettings.f = E.db.mMT.mp_textures.f
		mMTSettings.g = E.db.mMT.mp_textures.g
		mMTSettings.h = E.db.mMT.mp_textures.h
		mMTSettings.i = E.db.mMT.mp_textures.i
		mMTSettings.j = E.db.mMT.mp_textures.j
		mMTSettings.k = E.db.mMT.mp_textures.k
		mMTSettings.l = E.db.mMT.mp_textures.l
		mMTSettings.n = E.db.mMT.mp_textures.n
		mMTSettings.m = E.db.mMT.mp_textures.m
		mMTSettings.o = E.db.mMT.mp_textures.o
		mMTSettings.p = E.db.mMT.mp_textures.p
		mMTSettings.q = E.db.mMT.mp_textures.q
		mMTSettings.r = E.db.mMT.mp_textures.r
		mMTSettings.s = E.db.mMT.mp_textures.s
		mMTSettings.t = E.db.mMT.mp_textures.t
	end
end

function mMT:GetDevNames()
	return {
		["Blinkii"] = true,
		["Flinkii"] = true,
		["Raeldan"] = true,
		["Evokii"] = true,
	}
end

function mMT:ClassesTable()
	if E.Retail then
		return { "DEATHKNIGHT", "DEMONHUNTER", "DRUID", "EVOKER", "HUNTER", "MAGE", "MONK", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR" }
	elseif E.Classic then
		return { "HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR" }
	elseif E.Cata then
		return { "HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR", "DEATHKNIGHT" }
	end
end

local debugAddons = {
	["!BugGrabber"] = true,
	["!mMT_MediaPack"] = true,
	["BugSack"] = true,
	["ElvUI"] = true,
	["ElvUI_Libraries"] = true,
	["ElvUI_Options"] = true,
	["ElvUI_mMediaTag"] = true,
}

local safeAddons = {
	["!BugGrabber"] = true,
	["!mMT_MediaPack"] = true,
	["BugSack"] = true,
	["ElvUI"] = true,
	["ElvUI_EltreumUI"] = true,
	["ElvUI_JiberishIcons"] = true,
	["ElvUI_Libraries"] = true,
	["ElvUI_Options"] = true,
	["ElvUI_mMediaTag"] = true,
}

function mMT:SetDebugMode(on, safe)
	local addons = safe and safeAddons or debugAddons
	if on then
		for i = 1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if not addons[name] and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
				mMT.DB.disabledAddons[name] = "|CFFF62A0ADisabled|r"
			end
		end
		SetCVar("scriptErrors", 1)
		ReloadUI()
	elseif not on then
		if next(mMT.DB.disabledAddons) then
			for name in pairs(mMT.DB.disabledAddons) do
				EnableAddOn(name, E.myname)
			end
			wipe(mMT.DB.disabledAddons)
			ReloadUI()
		end
	end
end
