local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.individual_professions.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			icon = {
				order = 1,
				type = "toggle",
				name = L["Show Icon"],
				get = function(info)
					return E.db.mMT.datatexts.individual_professions.icon
				end,
				set = function(info, value)
					E.db.mMT.datatexts.individual_professions.icon = value
					DT:ForceUpdate_DataText("mMT - Cooking")
					DT:ForceUpdate_DataText("mMT - Fishing")
					DT:ForceUpdate_DataText("mMT - Primary Professions")
					DT:ForceUpdate_DataText("mMT - Secondary Professions")
				end,
			},
			style = {
				order = 2,
				type = "select",
				name = L["Icon Style"],
				get = function(info)
					return E.db.mMT.datatexts.individual_professions.iconStyle
				end,
				set = function(info, value)
					E.db.mMT.datatexts.individual_professions.iconStyle = value
					DT:ForceUpdate_DataText("mMT - Cooking")
					DT:ForceUpdate_DataText("mMT - Fishing")
					DT:ForceUpdate_DataText("mMT - Primary Professions")
					DT:ForceUpdate_DataText("mMT - Secondary Professions")
				end,
				values = {
					default = L["Default"],
					colored = L["Colored"],
					white = L["White"],
				},
			},
		},
	},
}
