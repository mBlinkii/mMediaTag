local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")
local date = date

mMT.options.args.dock.args.calendar.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Icon"],
		args = {
			icon = {
				order = 2,
				type = "select",
				name = L["Icon"],
				get = function(info)
					return E.db.mMT.dock.calendar.icon
				end,
				set = function(info, value)
					E.db.mMT.dock.calendar.icon = value
					DT:ForceUpdate_DataText("mMT_Dock_Calendar")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.calendar) do
						icons[key] = E:TextureString(icon[date("%d")], ":14:14") .. " " .. mMT:formatText(key, true)
					end
					return icons
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
					return E.db.mMT.dock.calendar.custom_color
				end,
				set = function(info, value)
					E.db.mMT.dock.calendar.custom_color = value
					DT:ForceUpdate_DataText("mMT_Dock_Calendar")
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return not E.db.mMT.dock.calendar.custom_color
				end,
				get = function(info)
					local r, g, b, a = mMT:HexToRGB(E.db.mMT.color.dock.calendar)
					return r, g, b, a
				end,
				set = function(info, r, g, b, a)
					local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
					E.db.mMT.color.dock.calendar = hex
					MEDIA.color.dock.calendar = CreateColorFromHexString(hex)
					DT:ForceUpdate_DataText("mMT_Dock_Calendar")
				end,
			},
		},
	},
}
