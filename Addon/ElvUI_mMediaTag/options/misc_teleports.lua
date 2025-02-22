local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.misc_teleports.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			anchorCursor = {
				order = 1,
				type = "toggle",
				name = L["ToolTip anchor on cursor"],
				get = function(info)
					return E.db.mMT.datatexts.teleports.anchorCursor
				end,
				set = function(info, value)
					E.db.mMT.datatexts.teleports.anchorCursor = value
					DT:ForceUpdate_DataText("mMT - Teleports")
				end,
			},
            icon = {
				order = 1,
				type = "toggle",
				name = L["Show Icon"],
				get = function(info)
					return E.db.mMT.datatexts.teleports.icon
				end,
				set = function(info, value)
					E.db.mMT.datatexts.teleports.icon = value
					DT:ForceUpdate_DataText("mMT - Teleports")
				end,
			},
            iconTexture = {
				order = 3,
				type = "select",
				name = L["Sort method"],
				get = function(info)
					return E.db.mMT.datatexts.teleports.iconTexture
				end,
				set = function(info, value)
					E.db.mMT.datatexts.teleports.iconTexture = value
					DT:ForceUpdate_DataText("mMT - Teleports")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.teleport) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
		},
	},
}
