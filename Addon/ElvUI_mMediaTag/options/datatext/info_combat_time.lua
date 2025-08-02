local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local dt_icons = MEDIA.icons.datatexts.combat

mMT.options.args.datatexts.args.info_combat_time.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			in_combat = {
				order = 1,
				type = "select",
				name = L["In Combat"],
				get = function(info)
					return E.db.mMT.datatexts.combat_time.in_combat
				end,
				set = function(info, value)
					E.db.mMT.datatexts.combat_time.in_combat = value
					DT:ForceUpdate_DataText("mMT - CombatTimer")
				end,
				values = function()
					local values = {}
					for key, icon in pairs(dt_icons) do
						values[key] = E:TextureString(icon, ":14:14")
					end

					values.none = L["None"]
					return values
				end,
			},
            out_of_combat = {
				order = 2,
				type = "select",
				name = L["Out of Combat"],
				get = function(info)
					return E.db.mMT.datatexts.combat_time.out_of_combat
				end,
				set = function(info, value)
					E.db.mMT.datatexts.combat_time.out_of_combat = value
					DT:ForceUpdate_DataText("mMT - CombatTimer")
				end,
				values = function()
					local values = {}
					for key, icon in pairs(dt_icons) do
						values[key] = E:TextureString(icon, ":14:14")
					end

					values.none = L["None"]
					return values
				end,
			},
            delay = {
				order = 3,
				name = L["Hide delay"],
				type = "range",
				min = 0,
				max = 120,
				step = 1,
				get = function(info)
					return E.db.mMT.datatexts.combat_time.hide_delay
				end,
				set = function(info, value)
					E.db.mMT.datatexts.combat_time.hide_delay = value
					DT:ForceUpdate_DataText("mMT - CombatTimer")
				end,
            },
		},
	},
}
