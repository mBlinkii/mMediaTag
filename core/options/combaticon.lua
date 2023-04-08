local mMT, E, L, V, P, G = unpack((select(2, ...)))

local tinsert = tinsert

local function configTable()
	E.Options.args.mMT.args.datatexts.args.combat.args = {
		header_combaticon = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Combat Icon and Time"],
			args = {

				combaticon_ooc_icon = {
					order = 2,
					type = "select",
					name = L["Icon out of Combat"],
					get = function(info)
						return E.db.mMT.combattime.ooctexture
					end,
					set = function(info, value)
						E.db.mMT.combattime.ooctexture = value
					end,
					values = mMT.Media.CombatIcons,
				},
				combaticon_ic_icon = {
					order = 3,
					type = "select",
					name = L["Icon in Combat"],
					get = function(info)
						return E.db.mMT.combattime.ictexture
					end,
					set = function(info, value)
						E.db.mMT.combattime.ictexture = value
					end,
					values = mMT.Media.CombatIcons,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
