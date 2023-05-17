local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.nameplates.args.bordercolor.args = {
		header_bordercolor = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Border and Glow"],
			args = {
				toggle_bordercolor = {
					order = 1,
					type = "toggle",
                    name = L["Auto color Border"],
                    desc = L["Class colored Nameplates Border."],
					get = function(info)
						return E.db.mMT.nameplate.bordercolor.border
					end,
					set = function(info, value)
						E.db.mMT.nameplate.bordercolor.border = value
                        mMT:mNamePlateBorderColor()
					end,
				},
                toggle_glowcolor = {
					order = 2,
					type = "toggle",
                    name = L["Auto color Glow"],
                    desc = L["Class colored Nameplates Glow."],
					get = function(info)
						return E.db.mMT.nameplate.bordercolor.glow
					end,
					set = function(info, value)
						E.db.mMT.nameplate.bordercolor.glow = value
                        mMT:mNamePlateBorderColor()
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
