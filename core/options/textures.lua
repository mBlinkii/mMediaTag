local mMT, E, L, V, P, G = unpack((select(2, ...)))

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
			args = {
				toggle_all = {
					order = 1,
					type = "toggle",
					name = L["Load All"],
					get = function(info)
						return E.db.mMT.textures.all
					end,
					set = function(info, value)
						E.db.mMT.textures.all = value
						mMT:LoadSeriesAll()
					end,
				},
				execute_disableall = {
					order = 2,
					type = "execute",
					name = L["Disable All"],
					disabled = function()
						return E.db.mMT.textures.all
					end,
					func = function()
						local db = E.db.mMT.textures
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
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.a
					end,
					set = function(info, value)
						E.db.mMT.textures.a = value
						mMT:LoadSeriesA()
					end,
				},
				toggle_b = {
					order = 2,
					type = "toggle",
					name = L["Load Pack"] .. " B",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.b
					end,
					set = function(info, value)
						E.db.mMT.textures.b = value
						mMT:LoadSeriesB()
					end,
				},
				toggle_c = {
					order = 3,
					type = "toggle",
					name = L["Load Pack"] .. " C",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.c
					end,
					set = function(info, value)
						E.db.mMT.textures.c = value
						mMT:LoadSeriesC()
					end,
				},
				toggle_d = {
					order = 4,
					type = "toggle",
					name = L["Load Pack"] .. " D",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.d
					end,
					set = function(info, value)
						E.db.mMT.textures.d = value
						mMT:LoadSeriesD()
					end,
				},
				toggle_e = {
					order = 5,
					type = "toggle",
					name = L["Load Pack"] .. " E",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.e
					end,
					set = function(info, value)
						E.db.mMT.textures.e = value
						mMT:LoadSeriesE()
					end,
				},
				toggle_f = {
					order = 6,
					type = "toggle",
					name = L["Load Pack"] .. " F",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.f
					end,
					set = function(info, value)
						E.db.mMT.textures.f = value
						mMT:LoadSeriesF()
					end,
				},
				toggle_g = {
					order = 7,
					type = "toggle",
					name = L["Load Pack"] .. " G",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.g
					end,
					set = function(info, value)
						E.db.mMT.textures.g = value
						mMT:LoadSeriesG()
					end,
				},
				toggle_h = {
					order = 8,
					type = "toggle",
					name = L["Load Pack"] .. " H",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.h
					end,
					set = function(info, value)
						E.db.mMT.textures.h = value
						mMT:LoadSeriesH()
					end,
				},
				toggle_i = {
					order = 9,
					type = "toggle",
					name = L["Load Pack"] .. " I",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.i
					end,
					set = function(info, value)
						E.db.mMT.textures.i = value
						mMT:LoadSeriesI()
					end,
				},
				toggle_j = {
					order = 10,
					type = "toggle",
					name = L["Load Pack"] .. " J",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.j
					end,
					set = function(info, value)
						E.db.mMT.textures.j = value
						mMT:LoadSeriesJ()
					end,
				},
				toggle_k = {
					order = 11,
					type = "toggle",
					name = L["Load Pack"] .. " K",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.k
					end,
					set = function(info, value)
						E.db.mMT.textures.k = value
						mMT:LoadSeriesK()
					end,
				},
				toggle_l = {
					order = 12,
					type = "toggle",
					name = L["Load Pack"] .. " L",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.l
					end,
					set = function(info, value)
						E.db.mMT.textures.l = value
						mMT:LoadSeriesL()
					end,
				},
				toggle_m = {
					order = 13,
					type = "toggle",
					name = L["Load Pack"] .. " M",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.m
					end,
					set = function(info, value)
						E.db.mMT.textures.m = value
						mMT:LoadSeriesM()
					end,
				},
				toggle_n = {
					order = 14,
					type = "toggle",
					name = L["Load Pack"] .. " N",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.n
					end,
					set = function(info, value)
						E.db.mMT.textures.n = value
						mMT:LoadSeriesN()
					end,
				},
				toggle_o = {
					order = 15,
					type = "toggle",
					name = L["Load Pack"] .. " O",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.o
					end,
					set = function(info, value)
						E.db.mMT.textures.o = value
						mMT:LoadSeriesO()
					end,
				},
				toggle_p = {
					order = 16,
					type = "toggle",
					name = L["Load Pack"] .. " P",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.p
					end,
					set = function(info, value)
						E.db.mMT.textures.p = value
						mMT:LoadSeriesP()
					end,
				},
				toggle_q = {
					order = 17,
					type = "toggle",
					name = L["Load Pack"] .. " Q",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.q
					end,
					set = function(info, value)
						E.db.mMT.textures.q = value
						mMT:LoadSeriesQ()
					end,
				},
				toggle_r = {
					order = 18,
					type = "toggle",
					name = L["Load Pack"] .. " R",
					disabled = function()
						return E.db.mMT.textures.all
					end,
					get = function(info)
						return E.db.mMT.textures.r
					end,
					set = function(info, value)
						E.db.mMT.textures.r = value
						mMT:LoadSeriesR()
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
