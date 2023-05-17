local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.profession.args = {
		header_profession = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Professions"],
			args = {
				toggle_icon = {
					order = 1,
					type = "toggle",
					name = L["Show Datatext Icon"],
					get = function(info)
						return E.db.mMT.profession.icon
					end,
					set = function(info, value)
						E.db.mMT.profession.icon = value
						DT:ForceUpdate_DataText("mProfessions")
					end,
				},
				toggle_proficon = {
					order = 2,
					type = "toggle",
					name = L["Icons"],
					desc = L["Displays the icons for the professions in the menu."],
					get = function(info)
						return E.db.mMT.profession.proficon
					end,
					set = function(info, value)
						E.db.mMT.profession.proficon = value
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
