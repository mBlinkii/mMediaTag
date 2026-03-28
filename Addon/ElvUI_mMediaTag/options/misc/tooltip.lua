local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.misc.args.tooltip.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.tooltip.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return E.db.mMediaTag.tooltip.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.tooltip.enable = value
			mMT:UpdateModule("Tooltip")
			if not value then E:StaticPopup_Show("CONFIG_RL") end
		end,
	},

	header_settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Auto Quest"],
		args = {
			size = {
				order = 1,
				name = L["Icon Size"],
				type = "range",
				min = 2,
				max = 512,
				step = 1,
				disabled = function()
					return not E.db.mMediaTag.tooltip.enable
				end,
				get = function(info)
					return E.db.mMediaTag.tooltip.size
				end,
				set = function(info, value)
					E.db.mMediaTag.tooltip.size = value
					mMT:UpdateModule("Tooltip")
				end,
			},
			zoom = {
				order = 2,
				type = "toggle",
				name = L["Icon Zoom"],
				disabled = function()
					return not E.db.mMediaTag.tooltip.enable
				end,
				get = function()
					return E.db.mMediaTag.tooltip.zoom
				end,
				set = function(_, value)
					E.db.mMediaTag.tooltip.zoom = value
					mMT:UpdateModule("Tooltip")
				end,
			},
		},
	},
}
