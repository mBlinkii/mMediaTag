local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.misc_dungeon.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			icon = {
				order = 1,
				type = "select",
				name = L["Icon"],
				get = function(info)
					return E.db.mMT.datatexts.dungeon.icon
				end,
				set = function(info, value)
					E.db.mMT.datatexts.dungeon.icon = value
					DT:ForceUpdate_DataText("mMT - Dungeon")
				end,
				values = function()
					local values = {}
					for key, icon in pairs(MEDIA.icons.lfg) do
						values[key] = E:TextureString(icon, ":14:14")
					end

					values.none = L["None"]
					return values
				end,
			},
			dungeon_name = {
				order = 2,
				type = "toggle",
				name = L["Dungeon Name"],
				desc = L["Change Text to Dungeon Name."],
				get = function(info)
					return E.db.mMT.datatexts.dungeon.dungeon_name
				end,
				set = function(info, value)
					E.db.mMT.datatexts.dungeon.dungeon_name = value
					DT:ForceUpdate_DataText("mMT - Dungeon")
				end,
			},
		},
	},
	colors = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			colors = {
				order = 1,
				type = "execute",
				name = L["Colors"],
                desc = L["Change Colors"],
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "colors", "difficulty")
				end,
			},
		},
	},
}
