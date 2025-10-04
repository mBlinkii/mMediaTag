local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")

mMT.options.args.dock.args.character.args = {
	icon = {
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
					return E.db.mMT.dock.character.style
				end,
				set = function(info, value)
					E.db.mMT.dock.character.style = value
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
					return E.db.mMT.dock.character.icon
				end,
				set = function(info, value)
					E.db.mMT.dock.character.icon = value
					DT:ForceUpdate_DataText("mMT_Dock_Character")
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMT.dock.character.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMT.dock.character.style]) do
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
					return E.db.mMT.dock.character.custom_color
				end,
				set = function(info, value)
					E.db.mMT.dock.character.custom_color = value
					DT:ForceUpdate_DataText("mMT_Dock_Character")
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return not E.db.mMT.dock.character.custom_color
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMT.color.dock.character)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMT.color.dock.character = hex
					MEDIA.color.dock.character = CreateColorFromHexString(hex)
					DT:ForceUpdate_DataText("mMT_Dock_Character")
				end,
			},
		},
	},
    settings = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			text = {
				order = 1,
				type = "toggle",
				name = L["Text"],
				desc = L["Show durability percentage as text."],
				get = function(info)
					return E.db.mMT.dock.character.text
				end,
				set = function(info, value)
					E.db.mMT.dock.character.text = value
					DT:ForceUpdate_DataText("mMT_Dock_Character")
				end,
			},
            percThreshold = {
				order = 2,
				name = L["Threshold"],
				type = "range",
				min = 0,
				max = 100,
				step = 1,
				get = function(info)
					return E.db.mMT.dock.character.percThreshold
				end,
				set = function(info, value)
					E.db.mMT.dock.character.percThreshold = value
					DT:ForceUpdate_DataText("mMT_Dock_Character")
				end,
			},
		},
	},
}
