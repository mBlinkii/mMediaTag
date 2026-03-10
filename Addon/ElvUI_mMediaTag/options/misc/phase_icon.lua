local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local CH = E:GetModule("Chat")
local UF = E:GetModule("UnitFrames")

mMT.options.args.unitframes.args.phase_icon.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.phase_icon.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.phase_icon.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.phase_icon.enable = value

            if value then
				mMT:UpdateModule("PhaseIcon")
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
					return not E.db.mMediaTag.phase_icon.enable
				end,
				get = function(info)
					return E.db.mMediaTag.phase_icon.icon
				end,
				set = function(info, value)
					E.db.mMediaTag.phase_icon.icon = value
					mMT:UpdateModule("PhaseIcon")
				end,
				values = function()
					local icons = {}
					for key, icon in pairs(MEDIA.icons.phase_icons) do
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
			phasing = {
				type = "color",
				order = 1,
				name = L["Phasing"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.phase_icon.Phasing)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.phase_icon.Phasing = hex
					MEDIA.color.phase_icon.Phasing = CreateColorFromHexString(hex)
					mMT:UpdateModule("PhaseIcon")
				end,
			},
            sharding = {
				type = "color",
				order = 2,
				name = L["Sharding"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.phase_icon.Sharding)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.phase_icon.Sharding = hex
					MEDIA.color.phase_icon.Sharding = CreateColorFromHexString(hex)
					mMT:UpdateModule("PhaseIcon")
				end,
			},
             WarMode = {
				type = "color",
				order = 3,
				name = L["War Mode"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.phase_icon.WarMode)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.phase_icon.WarMode = hex
					MEDIA.color.phase_icon.WarMode = CreateColorFromHexString(hex)
					mMT:UpdateModule("PhaseIcon")
				end,

			},
            ChromieTime = {
				type = "color",
				order = 4,
				name = L["Chromie Time"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.phase_icon.ChromieTime)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.phase_icon.ChromieTime = hex
					MEDIA.color.phase_icon.ChromieTime = CreateColorFromHexString(hex)
					mMT:UpdateModule("PhaseIcon")
				end,
			},
            TimerunningHwt = {
				type = "color",
				order = 5,
				name = L["Timerunning World"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.phase_icon.TimerunningHwt)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.phase_icon.TimerunningHwt = hex
					MEDIA.color.phase_icon.TimerunningHwt = CreateColorFromHexString(hex)
					mMT:UpdateModule("PhaseIcon")
				end,
			},
		},
	},
}
