local E, L = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.general.args.afk.args = {
		header_afk = {
			order = 1,
			type = "group",
			inline = true,
			name = L["ALL_SETTINGS"],
			args = {
				toggle_afk = {
					order = 1,
					type = "toggle",
					name = L["AFK_SCR"],
					get = function(info)
						return E.db.mMT.afk.enable
					end,
					set = function(info, value)
						E.db.mMT.afk.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_logo = {
					order = 2,
					type = "toggle",
					name = L["AFK_LOGO"],
					get = function(info)
						return E.db.mMT.afk.logo
					end,
					set = function(info, value)
						E.db.mMT.afk.logo = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				toggle_infoscreen = {
					order = 3,
					type = "toggle",
					name = L["AFK_INFO"],
					get = function(info)
						return E.db.mMT.afk.infoscreen
					end,
					set = function(info, value)
						E.db.mMT.afk.infoscreen = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_info = {
			order = 2,
			type = "group",
			inline = true,
			name = L["AFK_INFO"],
			args = {
				toggle_values = {
					order = 2,
					type = "toggle",
					name = L["ALL_VALUE"],
					get = function(info)
						return E.db.mMT.afk.values.enable
					end,
					set = function(info, value)
						E.db.mMT.afk.values.enable = value
					end,
				},
				toggle_attributes = {
					order = 3,
					type = "toggle",
					name = L["AFK_ATRB"],
					get = function(info)
						return E.db.mMT.afk.attributes.enable
					end,
					set = function(info, value)
						E.db.mMT.afk.attributes.enable = value
					end,
				},
				toggle_enhancements = {
					order = 4,
					type = "toggle",
					name = L["AFK_ENH"],
					get = function(info)
						return E.db.mMT.afk.enhancements.enable
					end,
					set = function(info, value)
						E.db.mMT.afk.enhancements.enable = value
					end,
				},
				toggle_progress = {
					order = 5,
					type = "toggle",
					name = L["AFK_PROG"],
					get = function(info)
						return E.db.mMT.afk.progress.enable
					end,
					set = function(info, value)
						E.db.mMT.afk.progress.enable = value
					end,
				},
				toggle_misc = {
					order = 6,
					type = "toggle",
					name = L["ALL_MISC"],
					get = function(info)
						return E.db.mMT.afk.misc.enable
					end,
					set = function(info, value)
						E.db.mMT.afk.misc.enable = value
					end,
				},
				toggle_garbage = {
					order = 7,
					type = "toggle",
					name = L["AFK_GARBAGE"],
					get = function(info)
						return E.db.mMT.afk.garbage
					end,
					set = function(info, value)
						E.db.mMT.afk.garbage = value
					end,
				},
			},
		},
		header_logo = {
			order = 3,
			type = "group",
			inline = true,
			name = L["All_LOGO"],
			args = {
				explanationA = {
					order = 1,
					type = "description",
					name = L["AFK_ATTENTION"],
				},
				explanationB = {
					order = 2,
					type = "description",
					name = L["AFK_SIZE"],
				},
				logo_texture = {
					order = 3,
					name = function()
						if E.db.mMT.afk.texture then
							return L["AFK_LOGO_TEXTURE"] .. "  " .. E:TextureString(E.db.mMT.afk.texture, ":26:102")
						else
							return L["AFK_LOGO_TEXTURE"]
						end
					end,
					type = "input",
					width = "smal",
					disabled = function()
						return not E.db.mMT.afk.logo
					end,
					get = function(info)
						return E.db.mMT.afk.texture
					end,
					set = function(info, value)
						E.db.mMT.afk.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_color = {
			order = 4,
			type = "group",
			inline = true,
			name = L["ALL_COLORS"],
			args = {
				color_title = {
					type = "color",
					order = 1,
					name = L["ALL_TITLE"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.afk.title
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.afk.title
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_values = {
					type = "color",
					order = 2,
					name = L["ALL_VALUE"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.afk.values
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.afk.values
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_attributes = {
					type = "color",
					order = 3,
					name = L["AFK_ATRB"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.afk.attributes
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.afk.attributes
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_enhancements = {
					type = "color",
					order = 4,
					name = L["AFK_ENH"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.afk.enhancements
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.afk.enhancements
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_progress = {
					type = "color",
					order = 5,
					name = L["AFK_PROG"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.afk.progress
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.afk.progress
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_misc = {
					type = "color",
					order = 6,
					name = L["ALL_MISC"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.afk.misc
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.afk.misc
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
