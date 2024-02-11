local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local tinsert = tinsert

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.TeleportIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.datatexts.args.teleports.args = {
		header_teleports = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Teleports"],
			args = {
				toggle_teleports = {
					order = 2,
					type = "toggle",
					name = L["Show Icon"],
					get = function(info)
						return E.db.mMT.teleports.icon
					end,
					set = function(info, value)
						E.db.mMT.teleports.icon = value
                        DT:ForceUpdate_DataText("mTeleports")
					end,
				},
				icon_teleports = {
					order = 2,
					type = "select",
					name = L["Icon out of Combat"],
					get = function(info)
						return E.db.mMT.teleports.customicon
					end,
					set = function(info, value)
						E.db.mMT.teleports.customicon = value
						DT:ForceUpdate_DataText("mTeleports")
					end,
					values = icons,
				},
				toggle_anchor = {
					order = 3,
					type = "toggle",
					name = L["ToolTip anchor on cursor"],
					get = function(info)
						return E.db.mMT.teleports.anchorCursor
					end,
					set = function(info, value)
						E.db.mMT.teleports.anchorCursor = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
