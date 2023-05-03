local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")
local tinsert = tinsert

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.CombatIcons) do
		icons[key] = E:TextureString(icon, ":14:14")
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
			},
		},
	}
end

tinsert(mMT.Config, configTable)
