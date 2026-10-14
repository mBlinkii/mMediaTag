local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.dock.args.buttons.args.durability.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			percThreshold = {
				order = 1,
				name = L["Threshold"],
				type = "range",
				min = 0,
				max = 100,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.dock.durability.percThreshold
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.durability.percThreshold = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
			},
		},
	},
	icon = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Icon"],
		args = {
			style = {
				order = 1,
				type = "select",
				name = L["Style"],
				get = function(info)
					return E.db.mMediaTag.dock.durability.style
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.durability.style = value
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
					return E.db.mMediaTag.dock.durability.icon
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.durability.icon = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMediaTag.dock.durability.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMediaTag.dock.durability.style]) do
							icons[key] = E:TextureString(icon, ":14:14") .. " " .. mMT:formatText(key)
						end
						return icons
					end
				end,
			},
		},
	},
	text = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Text"],
		args = {
			style = {
				order = 1,
				type = "select",
				name = L["Style"],
				get = function(info)
					return E.db.mMediaTag.dock.durability.text
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.durability.text = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
				values = {
					none = L["None"],
					durability = L["Durability"],
					both = L["Durability / Item level"],
					ilevel = L["Item level"],
				},
			},
		},
	},
	colors = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Colors"],
		args = {
			custom_color = {
				order = 1,
				type = "toggle",
				name = L["Custom Color"],
				desc = L["Use a custom color for the icon."],
				get = function(info)
					return E.db.mMediaTag.dock.durability.custom_color
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.durability.custom_color = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return not E.db.mMediaTag.dock.durability.custom_color
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMediaTag.color.dock.durability)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMediaTag.color.dock.durability = hex
					MEDIA.color.dock.durability = CreateColorFromHexString(hex)
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
			},
		},
	},
}
