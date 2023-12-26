local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local UF = E:GetModule('UnitFrames')

local function UpdateColors()
    for i, className in ipairs(mMT.Classes) do
		E.oUF.colors.class[className][1] = E.db.mMT.classcolors.colors[className]["r"]
        E.oUF.colors.class[className][2] = E.db.mMT.classcolors.colors[className]["g"]
        E.oUF.colors.class[className][3] = E.db.mMT.classcolors.colors[className]["b"]
        E.oUF.colors.class[className]["r"] = E.db.mMT.classcolors.colors[className]["r"]
        E.oUF.colors.class[className]["g"] = E.db.mMT.classcolors.colors[className]["g"]
        E.oUF.colors.class[className]["b"] = E.db.mMT.classcolors.colors[className]["b"]
	end
	UF:Update_AllFrames()
end

local function ResetColors()
	for i, className in ipairs(mMT.Classes) do
		local color = RAID_CLASS_COLORS[className]
		E.db.mMT.classcolors.colors[className]["r"] = RAID_CLASS_COLORS[className]["r"]
        E.db.mMT.classcolors.colors[className]["g"] = RAID_CLASS_COLORS[className]["g"]
        E.db.mMT.classcolors.colors[className]["b"] = RAID_CLASS_COLORS[className]["b"]
		E.oUF.colors.class[className][1] = E.db.mMT.classcolors.colors[className]["r"]
        E.oUF.colors.class[className][2] = E.db.mMT.classcolors.colors[className]["g"]
        E.oUF.colors.class[className][3] = E.db.mMT.classcolors.colors[className]["b"]
        E.oUF.colors.class[className]["r"] = E.db.mMT.classcolors.colors[className]["r"]
        E.oUF.colors.class[className]["g"] = E.db.mMT.classcolors.colors[className]["g"]
        E.oUF.colors.class[className]["b"] = E.db.mMT.classcolors.colors[className]["b"]
	end
	UF:Update_AllFrames()
end

local function configTable()
	E.Options.args.mMT.args.cosmetic.args.classcolor.args = {
		colorsheader = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Custom Class colors"],
			args = {
				customcolors = {
					order = 2,
					type = "toggle",
					name = L["Custom Class colors"],
					desc = L["Enable Custom Class colors."],
					get = function(info)
						return E.db.mMT.classcolors.enable
					end,
					set = function(info, value)
						E.db.mMT.classcolors.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				spacer1 = {
					order = 4,
					type = "description",
					name = "\n\n",
				},
				updatecolors = {
					order = 5,
					type = "execute",
					name = L["Set Custom colors"],
					desc = L["Set Custom colors"],
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					func = function()
						UpdateColors()
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				resetcolors = {
					order = 6,
					type = "execute",
					name = L["Reset Custom colors"],
					desc = L["Reset Custom colors"],
					func = function()
						ResetColors()
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		classheader = {
			order = 10,
			type = "group",
			inline = true,
			name = L["Class colors"],
			args = {
				HUNTER = {
					type = "color",
					order = 11,
					name = L["HUNTER"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.HUNTER
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.HUNTER
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				WARLOCK = {
					type = "color",
					order = 12,
					name = L["WARLOCK"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.WARLOCK
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.WARLOCK
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				PRIEST = {
					type = "color",
					order = 13,
					name = L["PRIEST"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.PRIEST
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.PRIEST
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				PALADIN = {
					type = "color",
					order = 14,
					name = L["PALADIN"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.PALADIN
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.PALADIN
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				MAGE = {
					type = "color",
					order = 15,
					name = L["MAGE"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.MAGE
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.MAGE
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				ROGUE = {
					type = "color",
					order = 16,
					name = L["ROGUE"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.ROGUE
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.ROGUE
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				DRUID = {
					type = "color",
					order = 17,
					name = L["DRUID"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.DRUID
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.DRUID
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				SHAMAN = {
					type = "color",
					order = 18,
					name = L["SHAMAN"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.SHAMAN
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.SHAMAN
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				WARRIOR = {
					type = "color",
					order = 19,
					name = L["WARRIOR"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.WARRIOR
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.WARRIOR
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				DEATHKNIGHT = {
					type = "color",
					order = 20,
					name = L["DEATHKNIGHT"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.DEATHKNIGHT
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.DEATHKNIGHT
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				MONK = {
					type = "color",
					order = 21,
					name = L["MONK"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.MONK
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.MONK
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				DEMONHUNTER = {
					type = "color",
					order = 22,
					name = L["DEMONHUNTER"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.DEMONHUNTER
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.DEMONHUNTER
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				EVOKER = {
					type = "color",
					order = 23,
					name = L["EVOKER"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.classcolors.enable
					end,
					get = function(info)
						local t = E.db.mMT.classcolors.colors.EVOKER
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.classcolors.colors.EVOKER
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
