local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")

mMT.options.args.dock.args.achievement.args = {
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
					return E.db.mMT.dock.achievement.style
				end,
				set = function(info, value)
					E.db.mMT.dock.achievement.style = value
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
					return E.db.mMT.dock.achievement.icon
				end,
				set = function(info, value)
					E.db.mMT.dock.achievement.icon = value
					DT:LoadDataTexts()
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMT.dock.achievement.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMT.dock.achievement.style]) do
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
					return E.db.mMT.dock.achievement.custom_color
				end,
				set = function(info, value)
					E.db.mMT.dock.achievement.custom_color = value
					DT:LoadDataTexts()
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return not E.db.mMT.dock.achievement.custom_color
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.color.dock.achievement)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.color.dock.achievement = hex
					MEDIA.color.dock.achievement = CreateColorFromHexString(hex)
					DT:LoadDataTexts()
				end,
			},
		},
	},
}
