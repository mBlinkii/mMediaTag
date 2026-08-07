local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local function Update()
	mMT:UpdateModule("PreyHunt")
end

local function IsDisabled()
	return not E.db.mMediaTag.prey_hunt.enable
end

mMT.options.args.misc.args.prey_hunt.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.prey_hunt.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Shows the current hunt stage as text on the prey icon."],
		get = function(info)
			return E.db.mMediaTag.prey_hunt.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.prey_hunt.enable = value
			Update()
		end,
	},
	format = {
		order = 2,
		type = "select",
		name = L["Text"],
		disabled = IsDisabled,
		get = function(info)
			return E.db.mMediaTag.prey_hunt.format
		end,
		set = function(info, value)
			E.db.mMediaTag.prey_hunt.format = value
			Update()
		end,
		values = {
			stage = "1/4",
			both = "1/4 (25%)",
			percent = "25%",
		},
	},
	font = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Font"],
		args = {
			font = {
				order = 1,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				values = LSM:HashTable("font"),
				disabled = IsDisabled,
				get = function(info)
					return E.db.mMediaTag.prey_hunt.font.font
				end,
				set = function(info, value)
					E.db.mMediaTag.prey_hunt.font.font = value
					Update()
				end,
			},
			fontFlag = {
				order = 2,
				type = "select",
				name = L["Font contour"],
				disabled = IsDisabled,
				get = function(info)
					return E.db.mMediaTag.prey_hunt.font.fontFlag
				end,
				set = function(info, value)
					E.db.mMediaTag.prey_hunt.font.fontFlag = value
					Update()
				end,
				values = {
					NONE = "None",
					OUTLINE = "Outline",
					THICKOUTLINE = "Thick",
					SHADOW = "|cff888888Shadow|r",
					SHADOWOUTLINE = "|cff888888Shadow|r Outline",
					SHADOWTHICKOUTLINE = "|cff888888Shadow|r Thick",
					MONOCHROME = "|cFFAAAAAAMono|r",
					MONOCHROMEOUTLINE = "|cFFAAAAAAMono|r Outline",
					MONOCHROMETHICKOUTLINE = "|cFFAAAAAAMono|r Thick",
				},
			},
			size = {
				order = 3,
				type = "range",
				name = L["Font size"],
				min = 8,
				max = 64,
				step = 1,
				disabled = IsDisabled,
				get = function(info)
					return E.db.mMediaTag.prey_hunt.font.size
				end,
				set = function(info, value)
					E.db.mMediaTag.prey_hunt.font.size = value
					Update()
				end,
			},
			color = {
				order = 4,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = IsDisabled,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.prey_hunt.color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.prey_hunt.color = E:RGBToHex(r, g, b, "ff")
					Update()
				end,
			},
		},
	},
	position = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			point = {
				order = 1,
				type = "select",
				name = L["Anchor Point"],
				disabled = IsDisabled,
				get = function(info)
					return E.db.mMediaTag.prey_hunt.point
				end,
				set = function(info, value)
					E.db.mMediaTag.prey_hunt.point = value
					Update()
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
			},
			x = {
				order = 2,
				type = "range",
				name = L["X offset"],
				desc = L["Sets the offset according to the anchor."],
				min = -100,
				max = 100,
				step = 1,
				disabled = IsDisabled,
				get = function(info)
					return E.db.mMediaTag.prey_hunt.x
				end,
				set = function(info, value)
					E.db.mMediaTag.prey_hunt.x = value
					Update()
				end,
			},
			y = {
				order = 3,
				type = "range",
				name = L["Y offset"],
				desc = L["Sets the offset according to the anchor."],
				min = -100,
				max = 100,
				step = 1,
				disabled = IsDisabled,
				get = function(info)
					return E.db.mMediaTag.prey_hunt.y
				end,
				set = function(info, value)
					E.db.mMediaTag.prey_hunt.y = value
					Update()
				end,
			},
		},
	},
	target_list = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Target List"],
		args = {
			gossip = {
				order = 1,
				type = "toggle",
				name = L["Mark Defeated Targets"],
				desc = L["Colors prey targets you already defeated in the target list, based on the achievement criteria."],
				get = function(info)
					return E.db.mMediaTag.prey_hunt.gossip
				end,
				set = function(info, value)
					E.db.mMediaTag.prey_hunt.gossip = value
					Update()
				end,
			},
			gossip_color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMediaTag.prey_hunt.gossip
				end,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.prey_hunt.gossip_color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.prey_hunt.gossip_color = E:RGBToHex(r, g, b, "ff")
					Update()
				end,
			},
		},
	},
}
