local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local GetMountInfoByID = C_MountJournal.GetMountInfoByID

mMT.options.args.dock.args.durability.args = {
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
					return E.db.mMT.dock.durability.style
				end,
				set = function(info, value)
					E.db.mMT.dock.durability.style = value
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
					return E.db.mMT.dock.durability.icon
				end,
				set = function(info, value)
					E.db.mMT.dock.durability.icon = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMT.dock.durability.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMT.dock.durability.style]) do
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
					return E.db.mMT.dock.durability.custom_color
				end,
				set = function(info, value)
					E.db.mMT.dock.durability.custom_color = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
			},
			color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
				disabled = function()
					return not E.db.mMT.dock.durability.custom_color
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.color.dock.durability)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.color.dock.durability = hex
					MEDIA.color.dock.durability = CreateColorFromHexString(hex)
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
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
			style = {
				order = 1,
				type = "select",
				name = L["Style"],
				get = function(info)
					return E.db.mMT.dock.durability.text
				end,
				set = function(info, value)
					E.db.mMT.dock.durability.text = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
				values = {
                    none = L["None"],
                    durability = L["Durability"],
                    both = L["Durability / Item level"],
                    ilevel = L["Item level"],
                },
			},
            mount = {
				order = 2,
				type = "select",
				name = L["Repair Mount"],
				get = function(info)
					return E.db.mMT.dock.durability.mount
				end,
				set = function(info, value)
					E.db.mMT.dock.durability.mount = value
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
				values = function()
					local mountIDs = {}

					for _, mountID in ipairs({ 280, 284, 460, 1039, 2237 }) do
						local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
						if isUsable then mountIDs[mountID] = format("|T%s:14:14:0:0:64:64:4:60:4:60|t %s", icon, name) end
					end

					return mountIDs
				end,
			},
            percThreshold = {
				order = 3,
				name = L["Threshold"],
				type = "range",
				min = 0,
				max = 100,
				step = 1,
				get = function(info)
					return E.db.mMT.dock.durability.percThreshold
				end,
				set = function(info, value)
					E.db.mMT.dock.durability.percThreshold = value
					DT:ForceUpdate_DataText("mMT_Dock_Durability")
				end,
			},
		},
	},
}
