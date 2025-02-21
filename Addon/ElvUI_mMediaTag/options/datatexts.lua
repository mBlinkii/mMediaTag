local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.datatexts.args.general.args = {
	text_color = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Text Color"],
		args = {
			override_text_color = {
				order = 1,
				type = "toggle",
				name = L["Override Text Color"],
				get = function(info)
					return E.db.mMT.datatexts.text.override_color
				end,
				set = function(info, value)
					E.db.mMT.datatexts.text.override_color = value
					mMT:UpdateMedia("colors")
				end,
			},
			color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.datatexts.text.override_color
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.text.color)
                    print(r,g,b)
					return r, g, b
				end,
				set = function(info, r, g, b)
					E.db.mMT.datatexts.text.color = E:RGBToHex(r, g, b, "")
					mMT:UpdateMedia("colors")
				end,
			},
		},
	},
}
