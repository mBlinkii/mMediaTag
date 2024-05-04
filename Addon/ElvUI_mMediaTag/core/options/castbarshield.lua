local E, L = unpack(ElvUI)

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.Castbar) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.castbar.args.shield.args = {
		header_castbarshield = {
			order = 1,
			type = "group",
			inline = true,
			name = L["CBS_SHIELD"],
			args = {
				toggle_castbarshield = {
					order = 1,
					type = "toggle",
					name = L["CBS_NI_SHIELD"],
					get = function(info)
						return E.db.mMT.castbarshield.enable
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_castbarshieldnp = {
					order = 2,
					type = "toggle",
					name = L["ALL_EN_NP"],
					get = function(info)
						return E.db.mMT.castbarshield.np
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.np = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_castbarshielduf = {
					order = 3,
					type = "toggle",
					name = L["ALL_EN_UFs"],
					get = function(info)
						return E.db.mMT.castbarshield.uf
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.uf = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_settings = {
			order = 2,
			type = "group",
			inline = true,
			name = L["ALL_SETTINGS"],
			args = {
				toggle_custom = {
					order = 1,
					type = "toggle",
					name = L["ALL_CUSTOM_COLOR"],
					get = function(info)
						return E.db.mMT.castbarshield.custom
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.custom = value
					end,
				},
				color = {
					type = "color",
					order = 2,
					name = L["CBS_ICON_COLOR"],
					hasAlpha = true,
					disabled = function()
						return not E.db.mMT.castbarshield.custom
					end,
					get = function(info)
						local t = E.db.mMT.castbarshield.color
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.castbarshield.color
						t.r, t.g, t.b, t.a = r, g, b, a
					end,
				},
				spacer1 = {
					order = 3,
					type = "description",
					name = "\n",
				},
				toggle_size = {
					order = 4,
					type = "toggle",
					name = L["CBS_AUTO_SIZE"],
					get = function(info)
						return E.db.mMT.castbarshield.auto
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.auto = value
					end,
				},
				range_x = {
					order = 5,
					name = L["Icon size X"],
					type = "range",
					min = 16,
					max = 128,
					step = 2,
					disabled = function()
						return E.db.mMT.castbarshield.auto
					end,
					get = function(info)
						return E.db.mMT.castbarshield.sizeX
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.sizeX = value
					end,
				},
				range_y = {
					order = 6,
					name = L["CBS_SIZE_Y"],
					type = "range",
					min = 16,
					max = 128,
					step = 2,
					disabled = function()
						return E.db.mMT.castbarshield.auto
					end,
					get = function(info)
						return E.db.mMT.castbarshield.sizeY
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.sizeY = value
					end,
				},
				spacer2 = {
					order = 7,
					type = "description",
					name = "\n",
				},
				select_icon = {
					order = 8,
					type = "select",
					name = L["ALL_ICON"],
					get = function(info)
						return E.db.mMT.castbarshield.icon
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.icon = value
					end,
					values = icons,
				},
				spacer3 = {
					order = 9,
					type = "description",
					name = "\n",
				},
				select_anchor = {
					order = 10,
					type = "select",
					name = L["CBS_ICON_POINT"],
					get = function(info)
						return E.db.mMT.castbarshield.anchor
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.anchor = value
					end,
					values = {
						TOP = "TOP",
						BOTTOM = "BOTTOM",
						LEFT = "LEFT",
						RIGHT = "RIGHT",
						CENTER = "CENTER",
					},
				},
				range_posx = {
					order = 12,
					name = L["ALL_POSITION"] .. " X",
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					get = function(info)
						return E.db.mMT.castbarshield.posX
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.posX = value
					end,
				},
				range_posy = {
					order = 13,
					name = L["ALL_POSITION"] .. " Y",
					type = "range",
					min = -256,
					max = 256,
					step = 1,
					get = function(info)
						return E.db.mMT.castbarshield.posY
					end,
					set = function(info, value)
						E.db.mMT.castbarshield.posY = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
