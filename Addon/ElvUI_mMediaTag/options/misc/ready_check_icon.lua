local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.options.args.unitframes.args.ready_check_icon.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.ready_check_icon.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.ready_check_icon.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.ready_check_icon.enable = value

			if value then
				mMT:UpdateModule("ReadyCheckIcon")
			else
				E:StaticPopup_Show("CONFIG_RL")
			end
		end,
	},
	icon = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Icons"],
		args = {
			ready = {
				order = 1,
				type = "select",
				name = L["Ready"],
				disabled = function()
					return not E.db.mMediaTag.ready_check_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.ready_check_icon.ready
				end,
				set = function(info, value)
					E.db.mMediaTag.ready_check_icon.ready = value
					mMT:UpdateModule("ReadyCheckIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.ready_check_icon) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
            notready = {
				order = 2,
				type = "select",
				name = L["Not Ready"],
				disabled = function()
					return not E.db.mMediaTag.ready_check_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.ready_check_icon.notready
				end,
				set = function(info, value)
					E.db.mMediaTag.ready_check_icon.notready = value
					mMT:UpdateModule("ReadyCheckIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.ready_check_icon) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
            waiting = {
				order = 3,
				type = "select",
				name = L["Waiting"],
				disabled = function()
					return not E.db.mMediaTag.ready_check_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.ready_check_icon.waiting
				end,
				set = function(info, value)
					E.db.mMediaTag.ready_check_icon.waiting = value
					mMT:UpdateModule("ReadyCheckIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.ready_check_icon) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
		},
	},
}
