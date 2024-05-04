local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.CombatIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end
	E.Options.args.mMT.args.datatexts.args.combat.args = {
		header_combaticon = {
			order = 1,
			type = "group",
			inline = true,
			name = L["CIT_NAME"],
			args = {
				combaticon_ooc_icon = {
					order = 2,
					type = "select",
					name = L["CIT_ICON_OOC"],
					get = function(info)
						return E.db.mMT.combattime.ooctexture
					end,
					set = function(info, value)
						E.db.mMT.combattime.ooctexture = value
					end,
					values = icons,
				},
				combaticon_ic_icon = {
					order = 3,
					type = "select",
					name = L["CIT_ICON_IC"],
					get = function(info)
						return E.db.mMT.combattime.ictexture
					end,
					set = function(info, value)
						E.db.mMT.combattime.ictexture = value
					end,
					values = icons,
				},
				range_hide = {
					order = 4,
					name = L["CIT_HIDE"],
					desc = L["CIT_TIP_HIDE"],
					type = "range",
					min = 0,
					max = 120,
					step = 1,
					get = function(info)
						return E.db.mMT.combattime.hide
					end,
					set = function(info, value)
						E.db.mMT.combattime.hide = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
