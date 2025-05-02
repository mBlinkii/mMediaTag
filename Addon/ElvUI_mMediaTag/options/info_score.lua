local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.info_score.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			group_keystones = {
				order = 1,
				type = "toggle",
				name = L["Show Party Keystones"],
				get = function(info)
					return E.db.mMT.datatexts.score.group_keystones
				end,
				set = function(info, value)
					E.db.mMT.datatexts.score.group_keystones = value
					DT:ForceUpdate_DataText("mMT - M+ Score")
				end,
			},
            show_upgrade = {
				order = 2,
				type = "toggle",
				name = L["Show Upgrades"],
				get = function(info)
					return E.db.mMT.datatexts.score.show_upgrade
				end,
				set = function(info, value)
					E.db.mMT.datatexts.score.show_upgrade = value
					DT:ForceUpdate_DataText("mMT - M+ Score")
				end,
			},
            sort_method = {
				order = 3,
				type = "select",
				name = L["Sort method"],
				get = function(info)
					return E.db.mMT.datatexts.score.sort_method
				end,
				set = function(info, value)
					E.db.mMT.datatexts.score.sort_method = value
					DT:ForceUpdate_DataText("mMT - M+ Score")
				end,
				values = {
					KEY = L["Keystone level"],
                    SCORE = L["Score"],
				},
			},
		},
	},
}
