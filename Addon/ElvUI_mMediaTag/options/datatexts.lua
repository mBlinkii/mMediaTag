local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

function mMT:UpdateAllDatatexts()
	DT:ForceUpdate_DataText("mMT - Archaeology")
	DT:ForceUpdate_DataText("mMT - Cooking")
	DT:ForceUpdate_DataText("mMT - Fishing")
	DT:ForceUpdate_DataText("mMT - Game menu")
	DT:ForceUpdate_DataText("mMT - M+ Score")
	DT:ForceUpdate_DataText("mMT - Professions")
	DT:ForceUpdate_DataText("mMT - Primary Professions")
	DT:ForceUpdate_DataText("mMT - Secondary Professions")
	DT:ForceUpdate_DataText("mMT - Teleports")
	DT:ForceUpdate_DataText("mMT - Coordinate X")
	DT:ForceUpdate_DataText("mMT - Coordinate Y")
	DT:ForceUpdate_DataText("mMT - Dungeon")
	M.Tracker:UpdateAll()
end

mMT.options.args.datatexts.args.general.args = {
	text_color = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Text Color"],
		args = {
			override_text_color = {
				order = 1,
				type = "toggle",
				name = L["Override Text Color"],
				get = function(info)
					return E.db.mMT.datatexts.text.override_text
				end,
				set = function(info, value)
					E.db.mMT.datatexts.text.override_text = value
					mMT:UpdateAllDatatexts()
				end,
			},
			text_color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.datatexts.text.override_text
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.text.text)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.datatexts.text.text = hex
					MEDIA.color.override_text = CreateColorFromHexString(hex)
					MEDIA.color.override_text.hex = hex
					mMT:UpdateAllDatatexts()
				end,
			},
			override_value = {
				order = 3,
				type = "toggle",
				name = L["Override Value Color"],
				get = function(info)
					return E.db.mMT.datatexts.text.override_value
				end,
				set = function(info, value)
					E.db.mMT.datatexts.text.override_value = value
					mMT:UpdateAllDatatexts()
				end,
			},
			value_color = {
				order = 4,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.datatexts.text.override_value
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.text.value)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.datatexts.text.value = hex
					MEDIA.color.override_value = CreateColorFromHexString(hex)
					MEDIA.color.override_value.hex = hex
					mMT:UpdateAllDatatexts()
				end,
			},
		},
	},
	colors = {
		order = 2,
		type = "group",
		inline = true,
		name = L["colors"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["These colors are used for the tooltips of the datatexts."],
			},
			colors = {
				order = 2,
				type = "execute",
				name = L["Colors"],
                desc = L["Change Colors"],
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "colors", "tip_menu")
				end,
			},
		},
	},
}
