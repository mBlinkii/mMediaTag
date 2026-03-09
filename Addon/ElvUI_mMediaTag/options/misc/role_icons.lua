local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local CH = E:GetModule("Chat")
local UF = E:GetModule("UnitFrames")

mMT.options.args.unitframes.args.role_icons.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.role_icons.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.role_icons.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.role_icons.enable = value

			if value then
				mMT:UpdateModule("RoleIcons")
			else
				UF:CreateAndUpdateHeaderGroup("party")
				CH:CheckLFGRoles()
			end
		end,
	},
	tank = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Tank"],
		args = {
			icon = {
				order = 4,
				type = "select",
				name = L["Icon"],
				disabled = function()
					return not E.db.mMediaTag.role_icons.enable
				end,
				get = function(info)
					return E.db.mMediaTag.role_icons.tank
				end,
				set = function(info, value)
					E.db.mMediaTag.role_icons.tank = value
					mMT:UpdateModule("RoleIcons")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.role) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
		},
	},
	heal = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Healer"],
		args = {
			icon = {
				order = 4,
				type = "select",
				name = L["Icon"],
				disabled = function()
					return not E.db.mMediaTag.role_icons.enable
				end,
				get = function(info)
					return E.db.mMediaTag.role_icons.heal
				end,
				set = function(info, value)
					E.db.mMediaTag.role_icons.heal = value
					mMT:UpdateModule("RoleIcons")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.role) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
		},
	},
	dd = {
		order = 4,
		type = "group",
		inline = true,
		name = L["DPS"],
		args = {
			icon = {
				order = 4,
				type = "select",
				name = L["Icon"],
				disabled = function()
					return not E.db.mMediaTag.role_icons.enable
				end,
				get = function(info)
					return E.db.mMediaTag.role_icons.dd
				end,
				set = function(info, value)
					E.db.mMediaTag.role_icons.dd = value
					mMT:UpdateModule("RoleIcons")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.role) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
		},
	},
}
