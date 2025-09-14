local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")

mMT.options.args.dock.args.lfd.args = {
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
					return E.db.mMT.dock.lfd.style
				end,
				set = function(info, value)
					E.db.mMT.dock.lfd.style = value
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
					return E.db.mMT.dock.lfd.icon
				end,
				set = function(info, value)
					E.db.mMT.dock.lfd.icon = value
					DT:ForceUpdate_DataText("mMT_Dock_LFD")
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMT.dock.lfd.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMT.dock.lfd.style]) do
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
					return E.db.mMT.dock.lfd.custom_color
				end,
				set = function(info, value)
					E.db.mMT.dock.lfd.custom_color = value
					DT:ForceUpdate_DataText("mMT_Dock_LFD")
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return not E.db.mMT.dock.lfd.custom_color
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.color.dock.lfd)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.color.dock.lfd = hex
					MEDIA.color.dock.lfd = CreateColorFromHexString(hex)
					DT:ForceUpdate_DataText("mMT_Dock_LFD")
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
				desc = L["Show difficulty or call to the arms on the icon."],
				get = function(info)
					return E.db.mMT.dock.lfd.text
				end,
				set = function(info, value)
					E.db.mMT.dock.lfd.text = value
					DT:ForceUpdate_DataText("mMT_Dock_LFD")
				end,
			},
            cta = {
				order = 2,
				type = "toggle",
				name = L["Call to the arms"],
				desc = L["Show icons for call to the arms."],
				get = function(info)
					return E.db.mMT.dock.lfd.call_to_the_Arms
				end,
				set = function(info, value)
					E.db.mMT.dock.lfd.call_to_the_Arms = value
					DT:ForceUpdate_DataText("mMT_Dock_LFD")
				end,
			},
		},
	},
}
