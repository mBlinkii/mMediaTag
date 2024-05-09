local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert
local percentValue = {
	[2] = 0,
	[3] = 0.14,
	[4] = 0.28,
	[5] = 0.42,
	[6] = 0.56,
	[7] = 0.71,
	[8] = 0.85,
	[9] = 1,
	[10] = 0.2,
	[11] = 0.4,
	[12] = 0.6,
	[13] = 0.8,
	[14] = 1,
	[15] = 0.2,
	[16] = 0.4,
	[17] = 0.6,
	[18] = 0.8,
	[19] = 1,
	[20] = 0.2,
	[21] = 0.4,
	[22] = 0.6,
	[23] = 0.8,
	[24] = 1,
	[25] = 0.2,
	[26] = 0.4,
	[27] = 0.6,
	[28] = 0.8,
	[29] = 1,
}
local function configTable()
	E.Options.args.mMT.args.general.args.instancedifficulty.args = {
		header_ID = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Instance Difficulty"],
			args = {
				ID_Enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.instancedifficulty.enable
					end,
					set = function(info, value)
						E.db.mMT.instancedifficulty.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
                ID_execute = {
                    order = 2,
                    type = "execute",
                    name = L["Position Settings"],
                    func = function()
                        E.Libs.AceConfigDialog:SelectGroup("ElvUI", "maps", "minimap", "icons", "difficulty")
                    end,
                },
                ID_description = {
                    order = 3,
                    type = 'description',
                    name = L["The position settings of Instance Difficulty are controlled by ElvUI in Maps, Minimap, Instance Difficulty."],
                },
                ID_description2 = {
                    order = 4,
                    type = 'description',
                    name = L["After setting the position, the interface must be reloaded once with /rl."],
                },
			},
		},
		ID_Header_Difficultys = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Difficulties Colors"],
			args = {
				ID_Color_NHC = {
					type = "color",
					order = 1,
					name = "NHC",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.nhc
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.nhc
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_HC = {
					type = "color",
					order = 2,
					name = "HC",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.hc
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.hc
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_M = {
					type = "color",
					order = 3,
					name = "M",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.m
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.m
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_MP = {
					type = "color",
					order = 4,
					name = "M+",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.mp
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.mp
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_LFR = {
					type = "color",
					order = 5,
					name = "LFR",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.lfr
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.lfr
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_PVP = {
					type = "color",
					order = 6,
					name = "PVP",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.pvp
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.pvp
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_TW = {
					type = "color",
					order = 7,
					name = "TW",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.tw
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.tw
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_TG = {
					type = "color",
					order = 8,
					name = "TG",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.tg
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.tg
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
			},
		},
		ID_Header_Other = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Other Colors"],
			args = {
				ID_Color_Name = {
					type = "color",
					order = 1,
					name = L["Instance Name"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.name
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.name
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_Guild = {
					type = "color",
					order = 2,
					name = L["Guild Group"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.guild
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.guild
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
			},
		},
		ID_Header_Keylevel = {
			order = 4,
			type = "group",
			inline = true,
			name = L["M+ Keystone Level"],
			args = {
				ID_Color_MA = {
					type = "color",
					order = 1,
					name = "+2",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.mpa
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.mpa
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_MB = {
					type = "color",
					order = 2,
					name = "<=9",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.mpb
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.mpb
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_MC = {
					type = "color",
					order = 3,
					name = "<=14",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.mpc
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.mpc
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_MD = {
					type = "color",
					order = 4,
					name = "<=19",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.mpd
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.mpd
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_ME = {
					type = "color",
					order = 5,
					name = "<=24",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.mpe
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.mpe
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
				ID_Color_MF = {
					type = "color",
					order = 6,
					name = "<=29",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.instancedifficulty.mpf
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.instancedifficulty.mpf
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
						mMT:UpdateColors()
					end,
				},
			},
		},
		ID_Header_Example = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Example"],
			args = {
				ID_Header_Test = {
					order = 1,
					type = "description",
					name = function()
						local tmpText = ""
						tmpText = "[DIFFICULTY] = "
							.. E.db.mMT.instancedifficulty.nhc.color
							.. "N |r"
							.. " - "
							.. E.db.mMT.instancedifficulty.hc.color
							.. "H |r"
							.. " - "
							.. E.db.mMT.instancedifficulty.m.color
							.. "M |r "
						tmpText = tmpText
							.. E.db.mMT.instancedifficulty.lfr.color
							.. "LFR |r"
							.. " - "
							.. E.db.mMT.instancedifficulty.tw.color
							.. "TW |r"
							.. " - "
							.. E.db.mMT.instancedifficulty.tg.color
							.. "TG |r "
						tmpText = tmpText .. E.db.mMT.instancedifficulty.pvp.color .. "PVP |r" .. " - " .. E.db.mMT.instancedifficulty.mp.color .. "M+ |r\n"
						tmpText = tmpText
							.. "[OTHERS] = "
							.. E.db.mMT.instancedifficulty.name.color
							.. "NAME |r"
							.. " - "
							.. E.db.mMT.instancedifficulty.guild.color
							.. "GUILD |r\n\n"
						tmpText = tmpText .. "[KEYLEVELS]\n"
						local color = {}
						for i = 2, 29, 1 do
							if i <= 9 then
								color = mMT:ColorFade(
									E.db.mMT.instancedifficulty.mpa,
									E.db.mMT.instancedifficulty.mpb,
									percentValue[i]
								)
							elseif i <= 14 then
								color = mMT:ColorFade(
									E.db.mMT.instancedifficulty.mpb,
									E.db.mMT.instancedifficulty.mpc,
									percentValue[i]
								)
							elseif i <= 19 then
								color = mMT:ColorFade(
									E.db.mMT.instancedifficulty.mpc,
									E.db.mMT.instancedifficulty.mpd,
									percentValue[i]
								)
							elseif i <= 24 then
								color = mMT:ColorFade(
									E.db.mMT.instancedifficulty.mpd,
									E.db.mMT.instancedifficulty.mpe,
									percentValue[i]
								)
							elseif i <= 29 then
								color = mMT:ColorFade(
									E.db.mMT.instancedifficulty.mpe,
									E.db.mMT.instancedifficulty.mpf,
									percentValue[i]
								)
							end

							local colorString = "|CFFFFFFFF|"
							if color then
								colorString = E:RGBToHex(color.r, color.g, color.b)
							end
							tmpText = tmpText .. colorString .. tostring(i) .. "|r "
						end

						tmpText = tmpText
							.. "\n\n\n[DEMO]\n"
							.. E.db.mMT.instancedifficulty.name.color
							.. "HOV |r\n"
							.. E.db.mMT.instancedifficulty.m.color
							.. "M|r |CFFF7DC6F5|r"

						return tmpText
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
