local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

mMT.options.args.datatexts.args.misc_individual_professions.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			style = {
				order = 1,
				type = "select",
				name = L["Icon Style"],
				get = function(info)
					return E.db.mMT.datatexts.individual_professions.icon
				end,
				set = function(info, value)
					E.db.mMT.datatexts.individual_professions.icon = value
					DT:ForceUpdate_DataText("mMT - Cooking")
					DT:ForceUpdate_DataText("mMT - Fishing")
					DT:ForceUpdate_DataText("mMT - Archaeology")
					DT:ForceUpdate_DataText("mMT - Primary Professions")
					DT:ForceUpdate_DataText("mMT - Secondary Professions")
				end,
				values = {
					none = L["None"],
					default = L["Default"],
					colored = L["Colored"],
					white = L["White"],
				},
			},
		},
	},
}
