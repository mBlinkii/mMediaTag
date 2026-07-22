local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local function Update()
	mMT:UpdateModule("ObjectiveTracker")
end

local function GetColorDB(group, key)
	return E.db.mMediaTag.objective_tracker[group][key]
end

local function ColorOption(order, name, group, key, withClass)
	local option = {
		order = order,
		type = "group",
		inline = true,
		name = name,
		args = {
			color = {
				order = 1,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMediaTag.objective_tracker.enable or GetColorDB(group, key).class
				end,
				get = function()
					local r, g, b = mMT:HexToRGB(GetColorDB(group, key).color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					GetColorDB(group, key).color = E:RGBToHex(r, g, b, "ff")
					Update()
				end,
			},
		},
	}

	if withClass then
		option.args.class = {
			order = 0,
			type = "toggle",
			name = L["Class Color"],
			disabled = function()
				return not E.db.mMediaTag.objective_tracker.enable
			end,
			get = function()
				return GetColorDB(group, key).class
			end,
			set = function(_, value)
				GetColorDB(group, key).class = value
				Update()
			end,
		}
	end

	return option
end

mMT.options.args.misc.args.objective_tracker.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.objective_tracker.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return E.db.mMediaTag.objective_tracker.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.objective_tracker.enable = value
			Update()
			if not value then E:StaticPopup_Show("CONFIG_RL") end
		end,
	},
	info = {
		order = 2,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Some changes require a reload of the UI."]),
	},
	font = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Font"],
		disabled = function()
			return not E.db.mMediaTag.objective_tracker.enable
		end,
		args = {
			font = {
				order = 1,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				values = LSM:HashTable("font"),
				get = function()
					return E.db.mMediaTag.objective_tracker.font.font
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.font.font = value
					Update()
				end,
			},
			fontFlag = {
				order = 2,
				type = "select",
				name = L["Font contour"],
				get = function()
					return E.db.mMediaTag.objective_tracker.font.fontFlag
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.font.fontFlag = value
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
			size_header = {
				order = 3,
				type = "range",
				name = L["Font size, header"],
				min = 8,
				max = 32,
				step = 1,
				get = function()
					return E.db.mMediaTag.objective_tracker.font.size.header
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.font.size.header = value
					Update()
				end,
			},
			size_title = {
				order = 4,
				type = "range",
				name = L["Font size, title"],
				min = 8,
				max = 32,
				step = 1,
				get = function()
					return E.db.mMediaTag.objective_tracker.font.size.title
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.font.size.title = value
					Update()
				end,
			},
			size_text = {
				order = 5,
				type = "range",
				name = L["Font size, text"],
				min = 8,
				max = 32,
				step = 1,
				get = function()
					return E.db.mMediaTag.objective_tracker.font.size.text
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.font.size.text = value
					Update()
				end,
			},
		},
	},
	colors = {
		order = 4,
		type = "group",
		name = L["Colors"],
		disabled = function()
			return not E.db.mMediaTag.objective_tracker.enable
		end,
		args = {},
	},
	headerbar = {
		order = 5,
		type = "group",
		name = L["Header Bar"],
		disabled = function()
			return not E.db.mMediaTag.objective_tracker.enable
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function()
					return E.db.mMediaTag.objective_tracker.headerbar.enable
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.headerbar.enable = value
					Update()
				end,
			},
			class = {
				order = 2,
				type = "toggle",
				name = L["Class Color"],
				get = function()
					return E.db.mMediaTag.objective_tracker.headerbar.class
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.headerbar.class = value
					Update()
				end,
			},
			gradient = {
				order = 3,
				type = "toggle",
				name = L["Gradient"],
				get = function()
					return E.db.mMediaTag.objective_tracker.headerbar.gradient
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.headerbar.gradient = value
					Update()
				end,
			},
			color = {
				order = 4,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMediaTag.objective_tracker.enable or E.db.mMediaTag.objective_tracker.headerbar.class
				end,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.objective_tracker.headerbar.color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.objective_tracker.headerbar.color = E:RGBToHex(r, g, b, "ff")
					Update()
				end,
			},
			texture = {
				order = 5,
				type = "select",
				dialogControl = "LSM30_Statusbar",
				name = L["Texture"],
				values = LSM:HashTable("statusbar"),
				get = function()
					return E.db.mMediaTag.objective_tracker.headerbar.texture
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.headerbar.texture = value
					Update()
				end,
			},
		},
	},
	bg = {
		order = 6,
		type = "group",
		name = L["Background"],
		disabled = function()
			return not E.db.mMediaTag.objective_tracker.enable
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function()
					return E.db.mMediaTag.objective_tracker.bg.enable
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.bg.enable = value
					Update()
				end,
			},
			transparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
				get = function()
					return E.db.mMediaTag.objective_tracker.bg.transparent
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.bg.transparent = value
					Update()
				end,
			},
			classBorder = {
				order = 3,
				type = "toggle",
				name = L["Class Color Border"],
				get = function()
					return E.db.mMediaTag.objective_tracker.bg.classBorder
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.bg.classBorder = value
					Update()
				end,
			},
		},
	},
	progress = {
		order = 7,
		type = "group",
		name = L["Progress"],
		disabled = function()
			return not E.db.mMediaTag.objective_tracker.enable
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Colors objectives like 3/5 by progress."],
				get = function()
					return E.db.mMediaTag.objective_tracker.progress.enable
				end,
				set = function(_, value)
					E.db.mMediaTag.objective_tracker.progress.enable = value
					Update()
					if not value then E:StaticPopup_Show("CONFIG_RL") end
				end,
			},
		},
	},
}

local optionColors = mMT.options.args.misc.args.objective_tracker.args.colors.args
optionColors.header = ColorOption(1, L["Header"], "colors", "header", true)
optionColors.title = ColorOption(2, L["Title"], "colors", "title", true)
optionColors.text = ColorOption(3, L["Text"], "colors", "text", true)
optionColors.complete = ColorOption(4, L["Complete"], "colors", "complete", true)

local progressArgs = mMT.options.args.misc.args.objective_tracker.args.progress.args
progressArgs.good = ColorOption(2, L["Good"], "progress", "good")
progressArgs.transit = ColorOption(3, L["Transition"], "progress", "transit")
progressArgs.bad = ColorOption(4, L["Bad"], "progress", "bad")
