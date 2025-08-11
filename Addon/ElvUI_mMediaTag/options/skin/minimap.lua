local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.misc.args.minimap_skin.args = {
	toggle_enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMT.minimap_skin.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMT.minimap_skin.enable
		end,
		set = function(info, value)
			E.db.mMT.minimap_skin.enable = value
			M.MinimapSkin:Initialize()
			if value == false then E:StaticPopup_Show("CONFIG_RL") end
		end,
	},
	settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			style = {
				type = "select",
				order = 1,
				name = L["Style"],
				get = function(info)
					return E.db.mMT.minimap_skin.style
				end,
				set = function(info, value)
					E.db.mMT.minimap_skin.style = value
					M.MinimapSkin:Initialize()
				end,
				values = function()
					local t = {}
					for k, v in pairs(MEDIA.minimap.skin) do
						t[k] = v.name
					end
					return t
				end,
			},
			color_style = {
				type = "select",
				order = 2,
				name = L["Color"],
				get = function(info)
					return E.db.mMT.minimap_skin.color
				end,
				set = function(info, value)
					E.db.mMT.minimap_skin.color = value
					M.MinimapSkin:Initialize()
				end,
				values = {
					class = L["Class Color"],
					custom = L["Custom Color"],
				},
			},
			color = {
				type = "color",
				order = 3,
				name = L["Color"],
				disabled = function()
					return E.db.mMT.minimap_skin.color == "class"
				end,
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.color.minimap_skin.color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.color.minimap_skin.color = hex
					mMT:UpdateMedia("minimap_skin")
					M.MinimapSkin:Initialize()
				end,
			},
		},
	},
	cardinal = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Cardinal Icon"],
		args = {
			cardinal = {
				type = "select",
				order = 1,
				name = L["Style"],
				get = function(info)
					return E.db.mMT.minimap_skin.cardinal
				end,
				set = function(info, value)
					E.db.mMT.minimap_skin.cardinal = value
					M.MinimapSkin:Initialize()
				end,
				values = function()
					local t = {}
					for k, v in pairs(MEDIA.minimap.cardinal) do
						t[k] = v.name
					end
					t["none"] = L["None"]
					return t
				end,
			},
			color_style = {
				type = "select",
				order = 2,
				name = L["Color"],
				get = function(info)
					return E.db.mMT.minimap_skin.color_cardinal
				end,
				set = function(info, value)
					E.db.mMT.minimap_skin.color_cardinal = value
					M.MinimapSkin:Initialize()
				end,
				values = {
					class = L["Class Color"],
					custom = L["Custom Color"],
				},
			},
			color = {
				type = "color",
				order = 3,
				name = L["Color"],
				disabled = function()
					return E.db.mMT.minimap_skin.color_cardinal == "class"
				end,
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.color.minimap_skin.cardinal)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.color.minimap_skin.cardinal = hex
					mMT:UpdateMedia("minimap_skin")
					M.MinimapSkin:Initialize()
				end,
			},
		},
	},
}
