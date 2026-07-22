local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.unitframes.args.resurrection_icon.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.resurrection_icon.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.resurrection_icon.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.resurrection_icon.enable = value

			if value then
				mMT:UpdateModule("ResurrectionIcon")
			else
				E:StaticPopup_Show("CONFIG_RL")
			end
		end,
	},
	icon = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Icon"],
		args = {
			icon = {
				order = 1,
				type = "select",
				name = L["Icon"],
				disabled = function()
					return not E.db.mMediaTag.resurrection_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.resurrection_icon.icon
				end,
				set = function(info, value)
					E.db.mMediaTag.resurrection_icon.icon = value
					mMT:UpdateModule("ResurrectionIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.resurrection_icon) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
		},
	},
}
