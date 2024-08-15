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

function mMT:CheckEltruism()
	local elt_tbl = {
		loaded = IsAddOnLoaded("ElvUI_EltreumUI"),
		gradient = false,
		dark = false,
		colors = nil,
	}

	if elt_tbl.loaded then
		local db = E.db.ElvUI_EltreumUI.unitframes.gradientmode
		elt_tbl.gradient = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and db and db.enable
		elt_tbl.dark = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.darkmode

		elt_tbl.colors = {
			["WARRIOR"] = {
				a = { r = db.warriorcustomcolorR1, g = db.warriorcustomcolorG1, b = db.warriorcustomcolorB1, a = 1 },
				b = { r = db.warriorcustomcolorR2, g = db.warriorcustomcolorG2, b = db.warriorcustomcolorB2, a = 1 },
			},
			["PALADIN"] = {
				a = { r = db.paladincustomcolorR1, g = db.paladincustomcolorG1, b = db.paladincustomcolorB1, a = 1 },
				b = { r = db.paladincustomcolorR2, g = db.paladincustomcolorG2, b = db.paladincustomcolorB2, a = 1 },
			},
			["HUNTER"] = {
				a = { r = db.huntercustomcolorR1, g = db.huntercustomcolorG1, b = db.huntercustomcolorB1, a = 1 },
				b = { r = db.huntercustomcolorR2, g = db.huntercustomcolorG2, b = db.huntercustomcolorB2, a = 1 },
			},
			["ROGUE"] = {
				a = { r = db.roguecustomcolorR1, g = db.roguecustomcolorG1, b = db.roguecustomcolorB1, a = 1 },
				b = { r = db.roguecustomcolorR2, g = db.roguecustomcolorG2, b = db.roguecustomcolorB2, a = 1 },
			},
			["PRIEST"] = {
				a = { r = db.priestcustomcolorR1, g = db.priestcustomcolorG1, b = db.priestcustomcolorB1, a = 1 },
				b = { r = db.priestcustomcolorR2, g = db.priestcustomcolorG2, b = db.priestcustomcolorB2, a = 1 },
			},
			["DEATHKNIGHT"] = {
				a = { r = db.deathknightcustomcolorR1, g = db.deathknightcustomcolorG1, b = db.deathknightcustomcolorB1, a = 1 },
				b = { r = db.deathknightcustomcolorR2, g = db.deathknightcustomcolorG2, b = db.deathknightcustomcolorB2, a = 1 },
			},
			["SHAMAN"] = {
				a = { r = db.shamancustomcolorR1, g = db.shamancustomcolorG1, b = db.shamancustomcolorB1, a = 1 },
				b = { r = db.shamancustomcolorR2, g = db.shamancustomcolorG2, b = db.shamancustomcolorB2, a = 1 },
			},
			["MAGE"] = {
				a = { r = db.magecustomcolorR1, g = db.magecustomcolorG1, b = db.magecustomcolorB1, a = 1 },
				b = { r = db.magecustomcolorR2, g = db.magecustomcolorG2, b = db.magecustomcolorB2, a = 1 },
			},
			["WARLOCK"] = {
				a = { r = db.warlockcustomcolorR1, g = db.warlockcustomcolorG1, b = db.warlockcustomcolorB1, a = 1 },
				b = { r = db.warlockcustomcolorR2, g = db.warlockcustomcolorG2, b = db.warlockcustomcolorB2, a = 1 },
			},
			["MONK"] = {
				a = { r = db.monkcustomcolorR1, g = db.monkcustomcolorG1, b = db.monkcustomcolorB1, a = 1 },
				b = { r = db.monkcustomcolorR2, g = db.monkcustomcolorG2, b = db.monkcustomcolorB2, a = 1 },
			},
			["DRUID"] = {
				a = { r = db.druidcustomcolorR1, g = db.druidcustomcolorG1, b = db.druidcustomcolorB1, a = 1 },
				b = { r = db.druidcustomcolorR2, g = db.druidcustomcolorG2, b = db.druidcustomcolorB2, a = 1 },
			},
			["DEMONHUNTER"] = {
				a = { r = db.demonhuntercustomcolorR1, g = db.demonhuntercustomcolorG1, b = db.demonhuntercustomcolorB1, a = 1 },
				b = { r = db.demonhuntercustomcolorR2, g = db.demonhuntercustomcolorG2, b = db.demonhuntercustomcolorB2, a = 1 },
			},
			["EVOKER"] = {
				a = { r = db.evokercustomcolorR1, g = db.evokercustomcolorG1, b = db.evokercustomcolorB1, a = 1 },
				b = { r = db.evokercustomcolorR2, g = db.evokercustomcolorG2, b = db.evokercustomcolorB2, a = 1 },
			},
			["friendly"] = { a = { r = db.npcfriendlyR1, g = db.npcfriendlyG1, b = db.npcfriendlyB1, a = 1 }, b = { r = db.npcfriendlyR2, g = db.npcfriendlyG2, b = db.npcfriendlyB2, a = 1 } },
			["neutral"] = { a = { r = db.npcneutralR1, g = db.npcneutralG1, b = db.npcneutralB1, a = 1 }, b = { r = db.npcneutralR2, g = db.npcneutralG2, b = db.npcneutralB2, a = 1 } },
			["enemy"] = { a = { r = db.npchostileR1, g = db.npchostileG1, b = db.npchostileB1, a = 1 }, b = { r = db.npchostileR2, g = db.npchostileG2, b = db.npchostileB2, a = 1 } },
		}
	end

	return elt_tbl
end

function mMT:CheckMerathilisUI()
	local mui_tbl = {
		loaded = IsAddOnLoaded("ElvUI_MerathilisUI"),
		gradient = false,
		custom = false,
		colors = nil,
	}

	if mui_tbl.loaded then
		mui_tbl.gradient = E.db.mui.gradient and E.db.mui.gradient.enable
		mui_tbl.custom = E.db.mui.gradient and E.db.mui.gradient.customColor.enableClass
		local c = mui_tbl.custom and E.db.mui.gradient.customColor or _G.ElvUI_MerathilisUI[2].ClassGradient

		if mui_tbl.custom then
			mui_tbl.colors = {
				["WARRIOR"] = { a = { r = c.warriorcolorR1, g = c.warriorcolorG1, b = c.warriorcolorB1, a = 1 }, b = { r = c.warriorcolorR2, g = c.warriorcolorG2, b = c.warriorcolorB2, a = 1 } },
				["PALADIN"] = { a = { r = c.paladincolorR1, g = c.paladincolorG1, b = c.paladincolorB1, a = 1 }, b = { r = c.paladincolorR2, g = c.paladincolorG2, b = c.paladincolorB2, a = 1 } },
				["HUNTER"] = { a = { r = c.huntercolorR1, g = c.huntercolorG1, b = c.huntercolorB1, a = 1 }, b = { r = c.huntercolorR2, g = c.huntercolorG2, b = c.huntercolorB2, a = 1 } },
				["ROGUE"] = { a = { r = c.roguecolorR1, g = c.roguecolorG1, b = c.roguecolorB1, a = 1 }, b = { r = c.roguecolorR2, g = c.roguecolorG2, b = c.roguecolorB2, a = 1 } },
				["PRIEST"] = { a = { r = c.priestcolorR1, g = c.priestcolorG1, b = c.priestcolorB1, a = 1 }, b = { r = c.priestcolorR2, g = c.priestcolorG2, b = c.priestcolorB2, a = 1 } },
				["DEATHKNIGHT"] = {
					a = { r = c.deathknightcolorR1, g = c.deathknightcolorG1, b = c.deathknightcolorB1, a = 1 },
					b = { r = c.deathknightcolorR2, g = c.deathknightcolorG2, b = c.deathknightcolorB2, a = 1 },
				},
				["SHAMAN"] = { a = { r = c.shamancolorR1, g = c.shamancolorG1, b = c.shamancolorB1, a = 1 }, b = { r = c.shamancolorR2, g = c.shamancolorG2, b = c.shamancolorB2, a = 1 } },
				["MAGE"] = { a = { r = c.magecolorR1, g = c.magecolorG1, b = c.magecolorB1, a = 1 }, b = { r = c.magecolorR2, g = c.magecolorG2, b = c.magecolorB2, a = 1 } },
				["WARLOCK"] = { a = { r = c.warlockcolorR1, g = c.warlockcolorG1, b = c.warlockcolorB1, a = 1 }, b = { r = c.warlockcolorR2, g = c.warlockcolorG2, b = c.warlockcolorB2, a = 1 } },
				["MONK"] = { a = { r = c.monkcolorR1, g = c.monkcolorG1, b = c.monkcolorB1, a = 1 }, b = { r = c.monkcolorR2, g = c.monkcolorG2, b = c.monkcolorB2, a = 1 } },
				["DRUID"] = { a = { r = c.druidcolorR1, g = c.druidcolorG1, b = c.druidcolorB1, a = 1 }, b = { r = c.druidcolorR2, g = c.druidcolorG2, b = c.druidcolorB2, a = 1 } },
				["DEMONHUNTER"] = {
					a = { r = c.demonhuntercolorR1, g = c.demonhuntercolorG1, b = c.demonhuntercolorB1, a = 1 },
					b = { r = c.demonhuntercolorR2, g = c.demonhuntercolorG2, b = c.demonhuntercolorB2, a = 1 },
				},
				["EVOKER"] = { a = { r = c.evokercolorR1, g = c.evokercolorG1, b = c.evokercolorB1, a = 1 }, b = { r = c.evokercolorR2, g = c.evokercolorG2, b = c.evokercolorB2, a = 1 } },
				["friendly"] = { a = { r = c.npcfriendlyR1, g = c.npcfriendlyG1, b = c.npcfriendlyB1, a = 1 }, b = { r = c.npcfriendlyR2, g = c.npcfriendlyG2, b = c.npcfriendlyB2, a = 1 } },
				["neutral"] = { a = { r = c.npcneutralR1, g = c.npcneutralG1, b = c.npcneutralB1, a = 1 }, b = { r = c.npcneutralR2, g = c.npcneutralG2, b = c.npcneutralB2, a = 1 } },
				["enemy"] = { a = { r = c.npchostileR1, g = c.npchostileG1, b = c.npchostileB1, a = 1 }, b = { r = c.npchostileR2, g = c.npchostileG2, b = c.npchostileB2, a = 1 } },
			}
		else
			mui_tbl.colors = {
				["WARRIOR"] = { a = { r = c.WARRIOR.r1, g = c.WARRIOR.g1, b = c.WARRIOR.b1, a = 1 }, b = { r = c.WARRIOR.r2, g = c.WARRIOR.g2, b = c.WARRIOR.b2, a = 1 } },
				["PALADIN"] = { a = { r = c.PALADIN.r1, g = c.PALADIN.g1, b = c.PALADIN.b1, a = 1 }, b = { r = c.PALADIN.r2, g = c.PALADIN.g2, b = c.PALADIN.b2, a = 1 } },
				["HUNTER"] = { a = { r = c.HUNTER.r1, g = c.HUNTER.g1, b = c.HUNTER.b1, a = 1 }, b = { r = c.HUNTER.r2, g = c.HUNTER.g2, b = c.HUNTER.b2, a = 1 } },
				["ROGUE"] = { a = { r = c.ROGUE.r1, g = c.ROGUE.g1, b = c.ROGUE.b1, a = 1 }, b = { r = c.ROGUE.r2, g = c.ROGUE.g2, b = c.ROGUE.b2, a = 1 } },
				["PRIEST"] = { a = { r = c.PRIEST.r1, g = c.PRIEST.g1, b = c.PRIEST.b1, a = 1 }, b = { r = c.PRIEST.r2, g = c.PRIEST.g2, b = c.PRIEST.b2, a = 1 } },
				["DEATHKNIGHT"] = { a = { r = c.DEATHKNIGHT.r1, g = c.DEATHKNIGHT.g1, b = c.DEATHKNIGHT.b1, a = 1 }, b = { r = c.DEATHKNIGHT.r2, g = c.DEATHKNIGHT.g2, b = c.DEATHKNIGHT.b2, a = 1 } },
				["SHAMAN"] = { a = { r = c.SHAMAN.r1, g = c.SHAMAN.g1, b = c.SHAMAN.b1, a = 1 }, b = { r = c.SHAMAN.r2, g = c.SHAMAN.g2, b = c.SHAMAN.b2, a = 1 } },
				["MAGE"] = { a = { r = c.MAGE.r1, g = c.MAGE.g1, b = c.MAGE.b1, a = 1 }, b = { r = c.MAGE.r2, g = c.MAGE.g2, b = c.MAGE.b2, a = 1 } },
				["WARLOCK"] = { a = { r = c.WARLOCK.r1, g = c.WARLOCK.g1, b = c.WARLOCK.b1, a = 1 }, b = { r = c.WARLOCK.r2, g = c.WARLOCK.g2, b = c.WARLOCK.b2, a = 1 } },
				["MONK"] = { a = { r = c.MONK.r1, g = c.MONK.g1, b = c.MONK.b1, a = 1 }, b = { r = c.MONK.r2, g = c.MONK.g2, b = c.MONK.b2, a = 1 } },
				["DRUID"] = { a = { r = c.DRUID.r1, g = c.DRUID.g1, b = c.DRUID.b1, a = 1 }, b = { r = c.DRUID.r2, g = c.DRUID.g2, b = c.DRUID.b2, a = 1 } },
				["DEMONHUNTER"] = { a = { r = c.DEMONHUNTER.r1, g = c.DEMONHUNTER.g1, b = c.DEMONHUNTER.b1, a = 1 }, b = { r = c.DEMONHUNTER.r2, g = c.DEMONHUNTER.g2, b = c.DEMONHUNTER.b2, a = 1 } },
				["EVOKER"] = { a = { r = c.EVOKER.r1, g = c.EVOKER.g1, b = c.EVOKER.b1, a = 1 }, b = { r = c.EVOKER.r2, g = c.EVOKER.g2, b = c.EVOKER.b2, a = 1 } },
				["friendly"] = { a = { r = c.NPCFRIENDLY.r1, g = c.NPCFRIENDLY.g1, b = c.NPCFRIENDLY.b1, a = 1 }, b = { r = c.NPCFRIENDLY.r2, g = c.NPCFRIENDLY.g2, b = c.NPCFRIENDLY.b2, a = 1 } },
				["neutral"] = { a = { r = c.NPCNEUTRAL.r1, g = c.NPCNEUTRAL.g1, b = c.NPCNEUTRAL.b1, a = 1 }, b = { r = c.NPCNEUTRAL.r2, g = c.NPCNEUTRAL.g2, b = c.NPCNEUTRAL.b2, a = 1 } },
				["enemy"] = { a = { r = c.NPCHOSTILE.r1, g = c.NPCHOSTILE.g1, b = c.NPCHOSTILE.b1, a = 1 }, b = { r = c.NPCHOSTILE.r2, g = c.NPCHOSTILE.g2, b = c.NPCHOSTILE.b2, a = 1 } },
			}
		end
	end

	return mui_tbl
end

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

	if not JIB or not JIB.iconStyles or version ~= "1.1.3" then
		jib_tbl.loaded = false
		mMT:Print("|CFFEA1818Error|r: The JiberishUI icons cannot be loaded due to compatibility issues. The version used is incompatible with the supported version.")
		return jib_tbl
	end

	jib_tbl.path = JIB.classIconPath

	for style, value in pairs(JIB.iconStyles) do
		if value and value.name then
			jib_tbl.styles[style] = "Jiberish " .. value.name
		end
	end

	for class, value in pairs(JIB.classData) do
		if value and value.texCoords then
			jib_tbl.texCoords[class] = value.texCoords
		end
	end

	return jib_tbl
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
