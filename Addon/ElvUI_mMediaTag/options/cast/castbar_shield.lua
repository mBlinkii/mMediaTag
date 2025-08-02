local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.unitframes.args.castbar_shield.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMT.castbar_shield.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMT.castbar_shield.enable
		end,
		set = function(info, value)
			E.db.mMT.castbar_shield.enable = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	settings_group = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			texture_select = {
				order = 1,
				type = "select",
				name = L["Style"],
				desc = L["Select a Icon texture"],
				get = function(info)
					return E.db.mMT.castbar_shield.texture
				end,
				set = function(info, value)
					E.db.mMT.castbar_shield.texture = value
					M.CastbarShield:Initialize()
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.castbar) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
			nameplates = {
				order = 2,
				type = "toggle",
				name = L["Nameplates"],
				desc = L["Enable Castbar Shield for Nameplates."],
				get = function(info)
					return E.db.mMT.castbar_shield.nameplates
				end,
				set = function(info, value)
					E.db.mMT.castbar_shield.nameplates = value
					M.CastbarShield:Initialize()
				end,
			},
			unitframes = {
				order = 3,
				type = "toggle",
				name = L["Unitframes"],
				desc = L["Enable Castbar Shield for Unitframes."],
				get = function(info)
					return E.db.mMT.castbar_shield.unitframes
				end,
				set = function(info, value)
					E.db.mMT.castbar_shield.unitframes = value
					M.CastbarShield:Initialize()
				end,
			},
			size_group = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Size Settings"],
				args = {
					auto = {
						order = 1,
						type = "toggle",
						name = L["Auto"],
						desc = L["Enable automatic sizing of the castbar shield."],
						get = function(info)
							return E.db.mMT.castbar_shield.auto
						end,
						set = function(info, value)
							E.db.mMT.castbar_shield.auto = value
							M.CastbarShield:Initialize()
						end,
					},
					size_x = {
						order = 2,
						name = L["Size X"],
						type = "range",
						min = 2,
						max = 256,
						step = 0.2,
						disabled = function()
							return not E.db.mMT.castbar_shield.auto
						end,
						get = function(info)
							return E.db.mMT.castbar_shield.sizeX
						end,
						set = function(info, value)
							E.db.mMT.castbar_shield.sizeX = value
							M.CastbarShield:Initialize()
						end,
					},
					size_y = {
						order = 3,
						name = L["Size Y"],
						type = "range",
						min = 2,
						max = 256,
						step = 0.2,
						disabled = function()
							return not E.db.mMT.castbar_shield.auto
						end,
						get = function(info)
							return E.db.mMT.castbar_shield.sizeY
						end,
						set = function(info, value)
							E.db.mMT.castbar_shield.sizeY = value
							M.CastbarShield:Initialize()
						end,
					},
				},
			},
			anchor_group = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Anchor"],
				args = {
					anchor_select = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						get = function(info)
							return E.db.mMT.castbar_shield.anchor
						end,
						set = function(info, value)
							E.db.mMT.castbar_shield.anchor = value
							M.CastbarShield:Initialize()
						end,
						values = {
							LEFT = "LEFT",
							RIGHT = "RIGHT",
							CENTER = "CENTER",
							TOP = "TOP",
							BOTTOM = "BOTTOM",
						},
					},
					pos_x = {
						order = 2,
						name = L["Offset X"],
						type = "range",
						min = -512,
						max = 512,
						step = 0.1,
						get = function(info)
							return E.db.mMT.castbar_shield.posX
						end,
						set = function(info, value)
							E.db.mMT.castbar_shield.posX = value
							M.CastbarShield:Initialize()
						end,
					},
					pos_y = {
						order = 3,
						name = L["Offset Y"],
						type = "range",
						min = -512,
						max = 512,
						step = 0.1,
						get = function(info)
							return E.db.mMT.castbar_shield.posY
						end,
						set = function(info, value)
							E.db.mMT.castbar_shield.posY = value
							M.CastbarShield:Initialize()
						end,
					},
				},
			},
		},
	},
}
