local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.unitframes.args.interrupt_on_cd.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.interrupt_on_cd.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.interrupt_on_cd.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.interrupt_on_cd.enable = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	settings_group = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			set_bg_color = {
				order = 1,
				type = "toggle",
				name = L["Change BG color"],
				desc = L["Enable to change the background color of the castbar."],
				get = function(info)
					return E.db.mMediaTag.interrupt_on_cd.set_bg_color
				end,
				set = function(info, value)
					E.db.mMediaTag.interrupt_on_cd.set_bg_color = value
					M.InterruptOnCD:Initialize()
				end,
			},
			bg_multiplier = {
				order = 2,
				name = L["Background Multiplier"],
				desc = L["Set the background color multiplier for the castbar."],
				type = "range",
				min = 0,
				max = 1,
				step = 0.01,
				disabled = function()
					return not E.db.mMediaTag.interrupt_on_cd.set_bg_color
				end,
				get = function(info)
					return E.db.mMediaTag.interrupt_on_cd.bg_multiplier
				end,
				set = function(info, value)
					E.db.mMediaTag.interrupt_on_cd.bg_multiplier = value
					M.InterruptOnCD:Initialize()
				end,
			},
		},
	},
	colors = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Colors"],
		args = {

			onCD = {
				type = "color",
				order = 1,
				name = L["On CD"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.interrupt_on_cd.onCD)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.interrupt_on_cd.onCD = hex
					MEDIA.color.interrupt_on_cd.onCD = CreateColorFromHexString(hex)
					MEDIA.color.interrupt_on_cd.onCD.hex = hex
				end,
			},

			normal = {
				type = "color",
				order = 1,
				name = L["Normal"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.interrupt_on_cd.normal)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.interrupt_on_cd.normal = hex
					MEDIA.color.interrupt_on_cd.normal = CreateColorFromHexString(hex)
					MEDIA.color.interrupt_on_cd.normal.hex = hex
				end,
			},

			marker = {
				order = 1,
				type = "color",
				name = L["Marker"],
				desc = L["The marker color for in time interrupts."],
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.interrupt_on_cd.marker)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.interrupt_on_cd.marker = hex
					MEDIA.color.interrupt_on_cd.marker = CreateColorFromHexString(hex)
					MEDIA.color.interrupt_on_cd.marker.hex = hex
				end,
			},
		},
	},
}
