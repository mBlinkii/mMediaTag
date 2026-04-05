local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local demo = false
local function UpdateImportantCasts()
	mMT:UpdateMedia("important_casts")
	mMT:UpdateModule("ImportantCasts", demo)
end

mMT.options.args.unitframes.args.important_casts.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.important_casts.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.important_casts.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.important_casts.enable = value

			if value then
				UpdateImportantCasts()
			else
				E:StaticPopup_Show("CONFIG_RL")
			end
		end,
	},
	demo = {
		order = 2,
		type = "execute",
		name = function()
			return demo and MEDIA.color.green:WrapTextInColorCode("Demo Mode: Active") or MEDIA.color.red:WrapTextInColorCode("Demo Mode: Disabled")
		end,
		func = function()
			demo = not demo
			UpdateImportantCasts()
		end,
		disabled = function()
			return not E.db.mMediaTag.important_casts.enable
		end,
	},
	settings = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			classColor = {
				order = 1,
				type = "toggle",
				name = L["Class Colors"],
				get = function(info)
					return E.db.mMediaTag.important_casts.classColor
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.classColor = value
					UpdateImportantCasts()
				end,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable
				end,
			},
			thickness = {
				order = 2,
				type = "range",
				name = L["Border"],
				min = 1,
				max = 10,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.important_casts.thickness
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.thickness = value
					UpdateImportantCasts()
				end,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable
				end,
			},
			color = {
				order = 3,
				type = "color",
				name = L["Border Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable or E.db.mMediaTag.important_casts.classColor
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.important_casts)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.important_casts = hex
					MEDIA.color.important_casts = CreateColorFromHexString(hex)
					MEDIA.color.important_casts.hex = hex
					mMT:UpdateModule("ImportantCasts")
				end,
			},
		},
	},
	icon = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Icon"],
		args = {
			showIcon = {
				order = 1,
				type = "toggle",
				name = L["Show Icon"],
				desc = L["Adds an Extra Icon to the Castbar."],
				get = function(info)
					return E.db.mMediaTag.important_casts.showIcon
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.showIcon = value
					UpdateImportantCasts()
				end,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable
				end,
			},
			icon = {
				order = 2,
				type = "select",
				name = L["Icon"],
				get = function(info)
					return E.db.mMediaTag.important_casts.icon
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.icon = value
					UpdateImportantCasts()
				end,
				values = function()
					local icons = {}

					for key, icon in pairs(MEDIA.icons.important_casts) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end

					return icons
				end,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable or not E.db.mMediaTag.important_casts.showIcon
				end,
			},
			iconSize = {
				order = 3,
				type = "range",
				name = L["Icon Size"],
				min = 8,
				max = 512,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.important_casts.iconSize
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.iconSize = value
					UpdateImportantCasts()
				end,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable or not E.db.mMediaTag.important_casts.showIcon
				end,
			},
		},
	},
	position = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Position Settings"],
		args = {
			anchor = {
				order = 1,
				type = "select",
				name = L["Anchor"],
				get = function(info)
					return E.db.mMediaTag.important_casts.anchor
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.anchor = value
					UpdateImportantCasts()
				end,
				values = {
					TOP = "TOP",
					BOTTOM = "BOTTOM",
					LEFT = "LEFT",
					RIGHT = "RIGHT",
					CENTER = L["CENTER"],
					TOPLEFT = "TOPLEFT",
					TOPRIGHT = "TOPRIGHT",
					BOTTOMLEFT = "BOTTOMLEFT",
					BOTTOMRIGHT = "BOTTOMRIGHT",
				},
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable or not E.db.mMediaTag.important_casts.showIcon
				end,
			},
			posX = {
				order = 2,
				type = "range",
				name = L["X offset"],
				desc = L["Sets the offset according to the anchor."],
				min = -100,
				max = 100,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.important_casts.posX
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.posX = value
					UpdateImportantCasts()
				end,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable or not E.db.mMediaTag.important_casts.showIcon
				end,
			},
			posY = {
				order = 3,
				type = "range",
				name = L["Y offset"],
				desc = L["Sets the offset according to the anchor."],
				min = -100,
				max = 100,
				step = 1,
				get = function(info)
					return E.db.mMediaTag.important_casts.posY
				end,
				set = function(info, value)
					E.db.mMediaTag.important_casts.posY = value
					UpdateImportantCasts()
				end,
				disabled = function()
					return not E.db.mMediaTag.important_casts.enable or not E.db.mMediaTag.important_casts.showIcon
				end,
			},
		},
	},
}
