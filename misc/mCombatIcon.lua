local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)

local addon, ns = ...
local UF = E:GetModule("UnitFrames")
local mInsert = table.insert

local function getIcons()
    return {
        E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat1.tga", ":16:16:0:0:64:64:4:60:4:60") .. "Combat 1",
        E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat2.tga", ":16:16:0:0:64:64:4:60:4:60") .. "Combat 2",
        E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\fire1.tga", ":16:16:0:0:64:64:4:60:4:60") .. "Combat 3",
        E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\fire9.tga", ":16:16:0:0:64:64:4:60:4:60") .. "Combat 4",
        E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lightning7.tga", ":16:16:0:0:64:64:4:60:4:60") .. "Combat 5",
        E:TextureString("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lightning9.tga", ":16:16:0:0:64:64:4:60:4:60") .. "Combat 6",
    }
end

local function setIcons()
    local icons = {
        "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat1.tga",
        "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat2.tga",
        "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\fire1.tga",
        "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\fire9.tga",
        "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lightning7.tga",
        "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lightning9.tga",
    }
    E.db.unitframe.units.player.CombatIcon.customTexture = icons[E.db[mPlugin].mCustomCombatIcons]
	E.db.unitframe.units.target.CombatIcon.customTexture = icons[E.db[mPlugin].mCustomCombatIcons]
    UF:CreateAndUpdateUF("player")
    UF:CreateAndUpdateUF("target")
    UF:TestingDisplay_CombatIndicator(UF["player"])
    UF:TestingDisplay_CombatIndicator(UF["target"])
end

local function CustomCombatiocn()
	E.Options.args.mMediaTag.args.cosmetic.args.customcombaticon.args = {
		combaticonheader = {
			order = 1,
			type = "header",
			name = L["Custom Combat Icons"],
		},
		combaticon = {
			order = 2,
			type = "toggle",
			name = L["Custom Combat Icons"],
			desc = L["This will enable and change the ElvUI combaticons to customicons"],
			get = function(info)
				return (
					E.db.unitframe.units.player.CombatIcon.texture == "CUSTOM"
					and E.db.unitframe.units.target.CombatIcon.texture == "CUSTOM"
				)
			end,
			set = function(info, value)
				if value then
					E.db.unitframe.units.player.CombatIcon.texture = "CUSTOM"
					E.db.unitframe.units.target.CombatIcon.texture = "CUSTOM"
				else
					E.db.unitframe.units.player.CombatIcon.texture = "DEFAULT"
					E.db.unitframe.units.target.CombatIcon.texture = "DEFAULT"
				end
			end,
		},
		combaticontexture = {
			order = 3,
			type = "select",
			name = L["Backdrop Texture"],
			values = function()
                return getIcons()
            end,
			disabled = function()
				return not (
					E.db.unitframe.units.player.CombatIcon.texture == "CUSTOM"
					and E.db.unitframe.units.target.CombatIcon.texture == "CUSTOM"
				)
			end,
			get = function(info)
				return E.db[mPlugin].mCustomCombatIcons
			end,
			set = function(info, value)
                E.db[mPlugin].mCustomCombatIcons = value
                setIcons()
			end,
		},
	}
end

mInsert(ns.Config, CustomCombatiocn)
