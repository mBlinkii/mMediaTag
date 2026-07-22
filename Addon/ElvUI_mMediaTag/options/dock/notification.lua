local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")

mMT.options.args.dock.args.notification.args = {
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
					return E.db.mMediaTag.dock.notification.style
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.notification.style = value
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
					return E.db.mMediaTag.dock.notification.icon
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.notification.icon = value
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMediaTag.dock.notification.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMediaTag.dock.notification.style]) do
							icons[key] = E:TextureString(icon, ":14:14") .. " " .. mMT:formatText(key)
						end
						return icons
					end
				end,
			},
		},
	},
	color = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Color"],
		args = {
			class = {
				order = 1,
				type = "toggle",
				name = L["ClassColor"],
				desc = L["Use class color for the icon."],
				get = function(info)
					return E.db.mMediaTag.dock.notification.class
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.notification.class = value
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return E.db.mMediaTag.dock.notification.class
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMediaTag.color.dock.notification)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMediaTag.color.dock.notification = hex
					MEDIA.color.dock.notification = CreateColorFromHexString(hex)
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
			auto_size = {
				order = 1,
				type = "toggle",
				name = L["Auto size"],
				get = function(info)
					return E.db.mMediaTag.dock.notification.auto
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.notification.auto = value
				end,
			},
			size = {
				order = 2,
				name = L["Size"],
				type = "range",
				disabled = function()
					return E.db.mMediaTag.dock.notification.auto
				end,
				min = 2,
				max = 256,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.dock.notification.size
				end,
				set = function(info, value)
					E.db.mMediaTag.dock.notification.size = value
				end,
			},
		},
	},
}
