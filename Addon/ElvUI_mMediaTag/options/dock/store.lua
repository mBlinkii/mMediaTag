local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")

mMT.options.args.dock.args.store.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Icon"],
		args = {
			style = {
				order = 1,
				type = "select",
				name = L["Style"],
				get = function(info)
					return E.db.mMT.dock.store.style
				end,
				set = function(info, value)
					E.db.mMT.dock.store.style = value
				end,
				values = function()
					local styles = {}
					for key, _ in pairs(MEDIA.icons.dock) do
						styles[key] = key
					end
					return styles
				end,
			},
			icon = {
				order = 2,
				type = "select",
				name = L["Icon"],
				get = function(info)
					return E.db.mMT.dock.store.icon
				end,
				set = function(info, value)
					E.db.mMT.dock.store.icon = value
					DT:ForceUpdate_DataText("mMT_Dock_BlizzardStore")
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMT.dock.store.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMT.dock.store.style]) do
							icons[key] = E:TextureString(icon, ":14:14") .. " " .. mMT:formatText(key)
						end
						return icons
					end
				end,
			},
		},
	},
	color = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Color"],
		args = {
			custom_color = {
				order = 1,
				type = "toggle",
				name = L["Custom Color"],
				desc = L["Use a custom color for the icon."],
				get = function(info)
					return E.db.mMT.dock.store.custom_color
				end,
				set = function(info, value)
					E.db.mMT.dock.store.custom_color = value
					DT:ForceUpdate_DataText("mMT_Dock_BlizzardStore")
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return not E.db.mMT.dock.store.custom_color
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMT.color.dock.store)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMT.color.dock.store = hex
					MEDIA.color.dock.store = CreateColorFromHexString(hex)
					DT:ForceUpdate_DataText("mMT_Dock_BlizzardStore")
				end,
			},
		},
	},
}
