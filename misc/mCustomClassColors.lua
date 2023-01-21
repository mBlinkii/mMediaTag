local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...
local ClassColor = E.oUF.colors.class
local UF = E:GetModule('UnitFrames')

local mInsert = table.insert
local classes = {"HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR", "DEATHKNIGHT", "MONK", "DEMONHUNTER", "EVOKER"}

local function UpdateColors()
    for i, className in ipairs(classes) do
		E.oUF.colors.class[className][1] = E.db[mPlugin].mCustomClassColors.colors[className]["r"]
        E.oUF.colors.class[className][2] = E.db[mPlugin].mCustomClassColors.colors[className]["g"]
        E.oUF.colors.class[className][3] = E.db[mPlugin].mCustomClassColors.colors[className]["b"]
        E.oUF.colors.class[className]["r"] = E.db[mPlugin].mCustomClassColors.colors[className]["r"]
        E.oUF.colors.class[className]["g"] = E.db[mPlugin].mCustomClassColors.colors[className]["g"]
        E.oUF.colors.class[className]["b"] = E.db[mPlugin].mCustomClassColors.colors[className]["b"]
	end
	UF:Update_AllFrames()
end


local function ResetColors()
	for i, className in ipairs(classes) do
		local color = RAID_CLASS_COLORS[className]
		E.db[mPlugin].mCustomClassColors.colors[className]["r"] = RAID_CLASS_COLORS[className]["r"]
        E.db[mPlugin].mCustomClassColors.colors[className]["g"] = RAID_CLASS_COLORS[className]["g"]
        E.db[mPlugin].mCustomClassColors.colors[className]["b"] = RAID_CLASS_COLORS[className]["b"]
		E.oUF.colors.class[className][1] = E.db[mPlugin].mCustomClassColors.colors[className]["r"]
        E.oUF.colors.class[className][2] = E.db[mPlugin].mCustomClassColors.colors[className]["g"]
        E.oUF.colors.class[className][3] = E.db[mPlugin].mCustomClassColors.colors[className]["b"]
        E.oUF.colors.class[className]["r"] = E.db[mPlugin].mCustomClassColors.colors[className]["r"]
        E.oUF.colors.class[className]["g"] = E.db[mPlugin].mCustomClassColors.colors[className]["g"]
        E.oUF.colors.class[className]["b"] = E.db[mPlugin].mCustomClassColors.colors[className]["b"]
	end
	UF:Update_AllFrames()
end

function mMT:SetElvUIMediaColor()
	local _, unitClass = UnitClass("PLAYER")
	local colorDB = E.db[mPlugin].mCustomClassColors.enable and E.db[mPlugin].mCustomClassColors.colors[unitClass] or E:ClassColor(E.myclass, true)
	E.db.general.valuecolor["r"] = colorDB.r
	E.db.general.valuecolor["g"] = colorDB.g
	E.db.general.valuecolor["b"] = colorDB.b
	E.db.general.valuecolor["a"] = 1
end

local function mClassColor(elv, class)
	if not class then
		return
	end

	local color = (E.db[mPlugin].mCustomClassColors.colors and E.db[mPlugin].mCustomClassColors.colors[class])
		or (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class])
		or _G.RAID_CLASS_COLORS[class]
	if type(color) ~= "table" then
		return
	end

	if not color.colorStr then
		color.colorStr = E:RGBToHex(color.r, color.g, color.b, "ff")
	elseif strlen(color.colorStr) == 6 then
		color.colorStr = "ff" .. color.colorStr
	end

	return color
end



function mMT:SetCustomColors()
	UpdateColors()
	hooksecurefunc(E, "ClassColor", mClassColor)
end

local function customclasscolorsOptions()
	E.Options.args.mMediaTag.args.cosmetic.args.customclasscolors.args = {
		colorsheader = {
			order = 1,
			type = "header",
			name = L["Custom Class colors"]
		},
		customcolors = {
			order = 2,
			type = "toggle",
			name = L["Custom Class colors"],
			desc = L["Enable Custom Class colors."],
			get = function(info)
				return E.db[mPlugin].mCustomClassColors.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomClassColors.enable = value
				E:StaticPopup_Show('CONFIG_RL')
			end
		},
		emediacolor = {
			order = 3,
			type = "toggle",
			name = L["Change ElvUI Media color"],
			get = function(info)
				return E.db[mPlugin].mCustomClassColors.emediaenable
			end,
			set = function(info, value)
				E.db[mPlugin].mCustomClassColors.emediaenable = value
				mMT:SetElvUIMediaColor()
				E:StaticPopup_Show('CONFIG_RL')
			end
		},
		updatecolors = {
			order = 4,
			type = "execute",
			name = L["Set Custom colors"],
			desc = L["Set Custom colors"],
			disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			func = function()
				UpdateColors()
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
		resetcolors = {
			order = 5,
			type = "execute",
			name = L["Reset Custom colors"],
			desc = L["Reset Custom colors"],
			func = function()
				ResetColors()
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        classheader = {
			order = 10,
			type = "header",
			name = L["Class colors"]
		},
        HUNTER = {
			type = "color",
			order = 11,
			name = L["HUNTER"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.HUNTER
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.HUNTER
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        WARLOCK = {
			type = "color",
			order = 12,
			name = L["WARLOCK"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.WARLOCK
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.WARLOCK
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        PRIEST = {
			type = "color",
			order = 13,
			name = L["PRIEST"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.PRIEST
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.PRIEST
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        PALADIN = {
			type = "color",
			order = 14,
			name = L["PALADIN"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.PALADIN
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.PALADIN
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        MAGE = {
			type = "color",
			order = 15,
			name = L["MAGE"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.MAGE
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.MAGE
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        ROGUE = {
			type = "color",
			order = 16,
			name = L["ROGUE"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.ROGUE
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.ROGUE
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        DRUID = {
			type = "color",
			order = 17,
			name = L["DRUID"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.DRUID
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.DRUID
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        SHAMAN = {
			type = "color",
			order = 18,
			name = L["SHAMAN"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.SHAMAN
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.SHAMAN
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        WARRIOR = {
			type = "color",
			order = 19,
			name = L["WARRIOR"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.WARRIOR
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.WARRIOR
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        DEATHKNIGHT = {
			type = "color",
			order = 20,
			name = L["DEATHKNIGHT"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.DEATHKNIGHT
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.DEATHKNIGHT
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        MONK = {
			type = "color",
			order = 21,
			name = L["MONK"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.MONK
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.MONK
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        DEMONHUNTER = {
			type = "color",
			order = 22,
			name = L["DEMONHUNTER"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.DEMONHUNTER
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.DEMONHUNTER
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
        EVOKER = {
			type = "color",
			order = 23,
			name = L["EVOKER"],
			hasAlpha = false,
            disabled = function() return not E.db[mPlugin].mCustomClassColors.enable end,
			get = function(info)
				local t = E.db[mPlugin].mCustomClassColors.colors.EVOKER
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCustomClassColors.colors.EVOKER
				t.r, t.g, t.b = r, g, b
				E:StaticPopup_Show('CONFIG_RL')
			end,
		},
	}
end

mInsert(ns.Config, customclasscolorsOptions)