local E = unpack(ElvUI)
local L = mMT.Locales
local LSM = E.Libs.LSM

local lfg_icons = {
	lfg01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_01.tga",
	lfg02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_02.tga",
	lfg03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_03.tga",
	lfg04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_04.tga",
	lfg05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_05.tga",
	lfg06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_06.tga",
	lfg07 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_07.tga",
	lfg08 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_08.tga",
	lfg09 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lfg\\lfg_09.tga",
}

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.misc.args.lfg_invite_info.args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enabled"],
			get = function(info)
				return E.db.mMT.lfg_invite_info.enable
			end,
			set = function(info, value)
				E.db.mMT.lfg_invite_info.enable = value
				mMT:UpdateModule("LFGInviteInfo")
			end,
		},
		demo = {
			order = 2,
			type = "execute",
			name = L["Show Frame"],
			func = function()
				mMT:UpdateModule("LFGInviteInfo", "demo")
			end,
		},
		font = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Font"],
			args = {
				font = {
					type = "select",
					dialogControl = "LSM30_Font",
					order = 1,
					name = L["Font"],
					values = LSM:HashTable("font"),
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						return E.db.mMT.lfg_invite_info.font.font
					end,
					set = function(info, value)
						E.db.mMT.lfg_invite_info.font.font = value
						mMT:UpdateModule("LFGInviteInfo")
					end,
				},
				fontflag = {
					type = "select",
					order = 2,
					name = L["Font contour"],
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						return E.db.mMT.lfg_invite_info.font.fontflag
					end,
					set = function(info, value)
						E.db.mMT.lfg_invite_info.font.fontflag = value
						mMT:UpdateModule("LFGInviteInfo")
					end,
					values = {
						NONE = "None",
						OUTLINE = "Outline",
						THICKOUTLINE = "Thick",
						SHADOW = "|cff888888Shadow|r",
						SHADOWOUTLINE = "|cff888888Shadow|r Outline",
						SHADOWTHICKOUTLINE = "|cff888888Shadow|r Thick",
						MONOCHROME = "|cFFAAAAAAMono|r",
						MONOCHROMEOUTLINE = "|cFFAAAAAAMono|r Outline",
						MONOCHROMETHICKOUTLINE = "|cFFAAAAAAMono|r Thick",
					},
				},
				font_size = {
					order = 5,
					name = L["Font size, top line"],
					type = "range",
					min = 8,
					max = 64,
					step = 1,
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						return E.db.mMT.lfg_invite_info.font.size
					end,
					set = function(info, value)
						E.db.mMT.lfg_invite_info.font.size = value
						mMT:UpdateModule("LFGInviteInfo")
					end,
				},
				font_size2 = {
					order = 6,
					name = L["Font size, bottom line"],
					type = "range",
					min = 8,
					max = 64,
					step = 1,
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						return E.db.mMT.lfg_invite_info.font.size2
					end,
					set = function(info, value)
						E.db.mMT.lfg_invite_info.font.size2 = value
						mMT:UpdateModule("LFGInviteInfo")
					end,
				},
			},
		},
		settings = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
				background = {
					order = 1,
					type = "toggle",
					name = L["Background"],
					get = function(info)
						return E.db.mMT.lfg_invite_info.background
					end,
					set = function(info, value)
						E.db.mMT.lfg_invite_info.background = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				color_line_a = {
					type = "color",
					order = 2,
					name = L["First line color"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						local r, g, b = mMT:HexToRGB(E.db.mMT.lfg_invite_info.colors.line_a)
						return r, g, b
					end,
					set = function(info, r, g, b)
						local hex = E:RGBToHex(r, g, b, "ff")
						E.db.mMT.lfg_invite_info.colors.line_a = hex

						mMT:UpdateModule("LFGInviteInfo")
					end,
				},
				color_line_b = {
					type = "color",
					order = 3,
					name = L["Second line color"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						local r, g, b = mMT:HexToRGB(E.db.mMT.lfg_invite_info.colors.line_b)
						return r, g, b
					end,
					set = function(info, r, g, b)
						local hex = E:RGBToHex(r, g, b, "ff")
						E.db.mMT.lfg_invite_info.colors.line_b = hex
						mMT:UpdateModule("LFGInviteInfo")
					end,
				},
				color_line_c = {
					type = "color",
					order = 4,
					name = L["Third line color"],
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						local r, g, b = mMT:HexToRGB(E.db.mMT.lfg_invite_info.colors.line_c)
						return r, g, b
					end,
					set = function(info, r, g, b)
						local hex = E:RGBToHex(r, g, b, "ff")
						E.db.mMT.lfg_invite_info.colors.line_c = hex
						mMT:UpdateModule("LFGInviteInfo")
					end,
				},
				delay = {
					order = 5,
					name = L["Fade out delay"],
					type = "range",
					min = 2,
					max = 120,
					step = 1,
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						return E.db.mMT.lfg_invite_info.delay
					end,
					set = function(info, value)
						E.db.mMT.lfg_invite_info.delay = value
						mMT:UpdateModule("LFGInviteInfo")
					end,
				},
				style = {
					type = "select",
					order = 6,
					name = L["Style"],
					disabled = function()
						return not E.db.mMT.lfg_invite_info.enable
					end,
					get = function(info)
						return E.db.mMT.lfg_invite_info.icon
					end,
					set = function(info, value)
						E.db.mMT.lfg_invite_info.icon = value
						mMT:UpdateModule("LFGInviteInfo")
					end,
					values = function()
						local icons = {}
						for key, icon in pairs(lfg_icons) do
							icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
						end

						icons["none"] = L["None"]
						return icons
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
