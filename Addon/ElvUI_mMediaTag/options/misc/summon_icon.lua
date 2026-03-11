local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

P.summon_icon = {
	enable = true,
	available = "galaxie",
	accepted = "galaxie",
	rejected = "galaxie",
}

mMT.options.args.unitframes.args.summon_icon.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.summon_icon.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.summon_icon.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.summon_icon.enable = value

			if value then
				mMT:UpdateModule("SummonIcon")
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
			available = {
				order = 1,
				type = "select",
				name = L["Available"],
				disabled = function()
					return not E.db.mMediaTag.summon_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.summon_icon.available
				end,
				set = function(info, value)
					E.db.mMediaTag.summon_icon.available = value
					mMT:UpdateModule("SummonIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.summon_icon) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
			accepted = {
				order = 2,
				type = "select",
				name = L["Accepted"],
				disabled = function()
					return not E.db.mMediaTag.summon_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.summon_icon.accepted
				end,
				set = function(info, value)
					E.db.mMediaTag.summon_icon.accepted = value
					mMT:UpdateModule("SummonIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.summon_icon) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
			rejected = {
				order = 3,
				type = "select",
				name = L["Rejected"],
				disabled = function()
					return not E.db.mMediaTag.summon_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.summon_icon.rejected
				end,
				set = function(info, value)
					E.db.mMediaTag.summon_icon.rejected = value
					mMT:UpdateModule("SummonIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.summon_icon) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
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
			available = {
				type = "color",
				order = 1,
				name = L["Available"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.summon_icon.available)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.summon_icon.available = hex
					MEDIA.color.summon_icon.available = CreateColorFromHexString(hex)
					mMT:UpdateModule("SummonIcon")
				end,
			},
			accepted = {
				type = "color",
				order = 2,
				name = L["Accepted"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.summon_icon.accepted)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.summon_icon.accepted = hex
					MEDIA.color.summon_icon.accepted = CreateColorFromHexString(hex)
					mMT:UpdateModule("SummonIcon")
				end,
			},
			rejected = {
				type = "color",
				order = 3,
				name = L["Rejected"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.summon_icon.rejected)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.summon_icon.rejected = hex
					MEDIA.color.summon_icon.rejected = CreateColorFromHexString(hex)
					mMT:UpdateModule("SummonIcon")
				end,
			},
		},
	},
}
