local E = unpack(ElvUI)
local L = mMT.Locales

if not mMTSettings then return end

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.cosmetic.args.textures.args = {
		header_description = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				description_textures = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = L["Here you can enable or disable individual texture packs to speed up the loading of the dropdown menu. Sometimes it may be necessary to do a /rl after enabling or disabling the packs."],
				},
			},
		},
		header_textures = {
			order = 2,
			type = "group",
			inline = true,
			name = L["General"],
			disabled = function()
				return not IsAddOnLoaded("!mMT_MediaPack")
			end,
			args = {
				toggle_all = {
					order = 1,
					type = "toggle",
					name = L["Load All"],
					get = function(info)
						return mMTSettings.textures.all
					end,
					set = function(info, value)
						mMTSettings.textures.all = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				execute_disableall = {
					order = 2,
					type = "execute",
					name = L["Disable All"],
					disabled = function()
						return mMTSettings.textures.all
					end,
					func = function()
						local db = mMTSettings.textures
						db.a = false
						db.b = false
						db.c = false
						db.d = false
						db.e = false
						db.f = false
						db.g = false
						db.h = false
						db.i = false
						db.j = false
						db.k = false
						db.l = false
						db.m = false
						db.n = false
						db.o = false
						db.p = false
						db.q = false
						db.r = false
						db.s = false
						db.t = false
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_texturespacks = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Texture Packs"],
			args = {
				toggle_a = {
					order = 1,
					type = "toggle",
					name = L["Load Pack"] .. " A",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.a
					end,
					set = function(info, value)
						mMTSettings.textures.a = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_b = {
					order = 2,
					type = "toggle",
					name = L["Load Pack"] .. " B",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.b
					end,
					set = function(info, value)
						mMTSettings.textures.b = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_c = {
					order = 3,
					type = "toggle",
					name = L["Load Pack"] .. " C",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.c
					end,
					set = function(info, value)
						mMTSettings.textures.c = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_d = {
					order = 4,
					type = "toggle",
					name = L["Load Pack"] .. " D",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.d
					end,
					set = function(info, value)
						mMTSettings.textures.d = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_e = {
					order = 5,
					type = "toggle",
					name = L["Load Pack"] .. " E",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.e
					end,
					set = function(info, value)
						mMTSettings.textures.e = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_f = {
					order = 6,
					type = "toggle",
					name = L["Load Pack"] .. " F",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.f
					end,
					set = function(info, value)
						mMTSettings.textures.f = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_g = {
					order = 7,
					type = "toggle",
					name = L["Load Pack"] .. " G",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.g
					end,
					set = function(info, value)
						mMTSettings.textures.g = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_h = {
					order = 8,
					type = "toggle",
					name = L["Load Pack"] .. " H",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.h
					end,
					set = function(info, value)
						mMTSettings.textures.h = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_i = {
					order = 9,
					type = "toggle",
					name = L["Load Pack"] .. " I",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.i
					end,
					set = function(info, value)
						mMTSettings.textures.i = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_j = {
					order = 10,
					type = "toggle",
					name = L["Load Pack"] .. " J",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.j
					end,
					set = function(info, value)
						mMTSettings.textures.j = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_k = {
					order = 11,
					type = "toggle",
					name = L["Load Pack"] .. " K",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.k
					end,
					set = function(info, value)
						mMTSettings.textures.k = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_l = {
					order = 12,
					type = "toggle",
					name = L["Load Pack"] .. " L",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.l
					end,
					set = function(info, value)
						mMTSettings.textures.l = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_m = {
					order = 13,
					type = "toggle",
					name = L["Load Pack"] .. " M",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.m
					end,
					set = function(info, value)
						mMTSettings.textures.m = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_n = {
					order = 14,
					type = "toggle",
					name = L["Load Pack"] .. " N",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.n
					end,
					set = function(info, value)
						mMTSettings.textures.n = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_o = {
					order = 15,
					type = "toggle",
					name = L["Load Pack"] .. " O",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.o
					end,
					set = function(info, value)
						mMTSettings.textures.o = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_p = {
					order = 16,
					type = "toggle",
					name = L["Load Pack"] .. " P",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.p
					end,
					set = function(info, value)
						mMTSettings.textures.p = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_q = {
					order = 17,
					type = "toggle",
					name = L["Load Pack"] .. " Q",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.q
					end,
					set = function(info, value)
						mMTSettings.textures.q = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_r = {
					order = 18,
					type = "toggle",
					name = L["Load Pack"] .. " R",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.r
					end,
					set = function(info, value)
						mMTSettings.textures.r = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_s = {
					order = 19,
					type = "toggle",
					name = L["Load Pack"] .. " S",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.s
					end,
					set = function(info, value)
						mMTSettings.textures.s = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_t = {
					order = 20,
					type = "toggle",
					name = L["Load Pack"] .. " T",
					disabled = function()
						return mMTSettings.textures.all
					end,
					get = function(info)
						return mMTSettings.textures.t
					end,
					set = function(info, value)
						mMTSettings.textures.t = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		preview = {
			type = "description",
			name = "",
			order = 4,
			image = function()
				return "Interface\\Addons\\!mMT_MediaPack\\media\\misc\\texture_preview.tga", 512, 256
			end,
		},
	}
end

tinsert(mMT.Config, configTable)
