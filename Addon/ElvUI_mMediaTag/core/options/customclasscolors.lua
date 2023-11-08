local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local loaded = false

local function configTable()
	loaded = (IsAddOnLoaded("!mMT_ClassColors"))
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
						return loaded
					end,
					set = function(info, value)
						if loaded then
							DisableAddOn("!mMT_ClassColors")
						else
							EnableAddOn("!mMT_ClassColors")
						end
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				emediacolor = {
					order = 3,
					type = "toggle",
					name = L["Change ElvUI Media color"],
					get = function(info)
						return E.db.mMT.general.emediaenable
					end,
					set = function(info, value)
						E.db.mMT.general.emediaenable = value
						mMT:SetElvUIMediaColor()
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
						return not loaded
					end,
					func = function()
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:UpdateColors()
							E:StaticPopup_Show("CONFIG_RL")
						end
					end,
				},
				resetcolors = {
					order = 6,
					type = "execute",
					name = L["Reset Custom colors"],
					desc = L["Reset Custom colors"],
					disabled = function()
						return not loaded
					end,
					func = function()
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:ResetColors()
							E:StaticPopup_Show("CONFIG_RL")
						end
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
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.HUNTER or { r = 0.66666668653488, g = 0.82745105028152, b = 0.44705885648727 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("HUNTER", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				WARLOCK = {
					type = "color",
					order = 12,
					name = L["WARLOCK"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.WARLOCK or { r = 0.77647066116333, g = 0.60784316062927, b = 0.42745101451874 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("WARLOCK", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				PRIEST = {
					type = "color",
					order = 13,
					name = L["PRIEST"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.PRIEST or { r = 1, g = 1, b = 1 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("PRIEST", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				PALADIN = {
					type = "color",
					order = 14,
					name = L["PALADIN"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.PALADIN or { r = 0.95686280727386, g = 0.54901963472366, b = 0.7294117808342 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("PALADIN", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				MAGE = {
					type = "color",
					order = 15,
					name = L["MAGE"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.MAGE or { r = 0.24705883860588, g = 0.78039222955704, b = 0.9215686917305 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("MAGE", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				ROGUE = {
					type = "color",
					order = 16,
					name = L["ROGUE"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.ROGUE or { r = 1, g = 0.95686280727386, b = 0.4078431725502 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("ROGUE", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				DRUID = {
					type = "color",
					order = 17,
					name = L["DRUID"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.DRUID or { r = 1, g = 0.48627454042435, b = 0.039215687662363 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("DRUID", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				SHAMAN = {
					type = "color",
					order = 18,
					name = L["SHAMAN"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.SHAMAN or { r = 0, g = 0.43921571969986, b = 0.8666667342186 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("SHAMAN", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				WARRIOR = {
					type = "color",
					order = 19,
					name = L["WARRIOR"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.WARRIOR or { r = 0.77647066116333, g = 0.60784316062927, b = 0.42745101451874 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("WARRIOR", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				DEATHKNIGHT = {
					type = "color",
					order = 20,
					name = L["DEATHKNIGHT"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.DEATHKNIGHT or { r = 0.76862752437592, g = 0.11764706671238, b = 0.22745099663734 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("DEATHKNIGHT", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				MONK = {
					type = "color",
					order = 21,
					name = L["MONK"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.MONK or { r = 0, g = 1, b = 0.59607845544815 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("MONK", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				DEMONHUNTER = {
					type = "color",
					order = 22,
					name = L["DEMONHUNTER"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.DEMONHUNTER or { r = 0.63921570777893, g = 0.18823531270027, b = 0.78823536634445 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("DEMONHUNTER", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
				EVOKER = {
					type = "color",
					order = 23,
					name = L["EVOKER"],
					hasAlpha = false,
					disabled = function()
						return not loaded
					end,
					get = function(info)
						local t = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.EVOKER or { r = 0.20000001788139, g = 0.57647061347961, b = 0.49803924560547 }
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						if CUSTOM_CLASS_COLORS then
							CUSTOM_CLASS_COLORS:SetColor("EVOKER", r, g, b)
							CUSTOM_CLASS_COLORS:UpdateColors()
						end
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
