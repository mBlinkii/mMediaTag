local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local ipairs = ipairs

local function Update()
	mMT:UpdateModule("ObjectiveTracker")
end

local function Settings(path)
	local settings = E.db.mMediaTag.objective_tracker
	for _, key in ipairs(path) do
		settings = settings[key]
	end
	return settings
end

local function Getter(...)
	local path = { ... }
	return function(info)
		return Settings(path)[info[#info]]
	end
end

local function Setter(...)
	local path = { ... }
	return function(info, value)
		Settings(path)[info[#info]] = value
		Update()
	end
end

local function Disabled()
	return not E.db.mMediaTag.objective_tracker.enable
end

-- options below a section toggle follow that toggle
local function DisabledBy(key)
	return function(info)
		return Disabled() or (info[#info] ~= "enable" and not E.db.mMediaTag.objective_tracker[key].enable)
	end
end

-- color options keep their own get/set, the colors category mirrors them outside of this group
local function ColorOption(order, name, path, withClass, disabled)
	disabled = disabled or Disabled

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
				disabled = function(info)
					return disabled(info) or Settings(path).class
				end,
				get = function()
					local r, g, b = mMT:HexToRGB(Settings(path).color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					Settings(path).color = E:RGBToHex(r, g, b, "ff")
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
			get = function()
				return Settings(path).class
			end,
			set = function(_, value)
				Settings(path).class = value
				Update()
			end,
		}
	end

	return option
end

local function FontSize(order, name)
	return {
		order = order,
		type = "range",
		name = name,
		min = 8,
		max = 32,
		step = 1,
	}
end

local function BarColorDisabled(info)
	return DisabledBy("bars")(info) or E.db.mMediaTag.objective_tracker.bars.progressColor
end

local function Texture(order)
	return {
		order = order,
		type = "select",
		dialogControl = "LSM30_Statusbar",
		name = L["Texture"],
		values = LSM:HashTable("statusbar"),
	}
end

mMT.options.args.quests.args.objective_tracker.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.objective_tracker.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = Getter(),
		set = function(info, value)
			Setter()(info, value)
			if not value then E:StaticPopup_Show("CONFIG_RL") end
		end,
	},
	info = {
		order = 2,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Some changes require a reload of the UI."]),
	},
	text = {
		order = 3,
		type = "group",
		name = L["Text"],
		disabled = Disabled,
		get = Getter("text"),
		set = Setter("text"),
		args = {
			font = {
				order = 1,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				values = LSM:HashTable("font"),
			},
			fontFlag = {
				order = 2,
				type = "select",
				name = L["Font contour"],
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
			justify = {
				order = 3,
				type = "select",
				name = L["Alignment"],
				values = {
					LEFT = L["LEFT"],
					CENTER = L["CENTER"],
					RIGHT = L["RIGHT"],
				},
			},
			hideDash = {
				order = 4,
				type = "toggle",
				name = L["Hide Dash"],
				desc = L["Removes the dash in front of each objective."],
			},
			size = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Font size"],
				get = Getter("text", "size"),
				set = Setter("text", "size"),
				args = {
					header = FontSize(1, L["Header"]),
					title = FontSize(2, L["Title"]),
					text = FontSize(3, L["Text"]),
				},
			},
		},
	},
	colors = {
		order = 4,
		type = "group",
		name = L["Colors"],
		disabled = Disabled,
		args = {
			header = ColorOption(1, L["Header"], { "colors", "header" }, true),
			title = ColorOption(2, L["Title"], { "colors", "title" }, true),
			text = ColorOption(3, L["Text"], { "colors", "text" }, true),
			complete = ColorOption(4, L["Complete"], { "colors", "complete" }, true),
		},
	},
	headerbar = {
		order = 5,
		type = "group",
		name = L["Header Bar"],
		disabled = DisabledBy("headerbar"),
		get = Getter("headerbar"),
		set = Setter("headerbar"),
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
			},
			mainHeader = {
				order = 2,
				type = "toggle",
				name = L["Main Header"],
				desc = L["Also shows the bar below the main header of the tracker."],
			},
			gradient = {
				order = 3,
				type = "toggle",
				name = L["Gradient"],
			},
			border = {
				order = 4,
				type = "toggle",
				name = L["Border"],
			},
			height = {
				order = 5,
				type = "range",
				name = L["Bar Height"],
				min = 1,
				max = 20,
				step = 1,
			},
			texture = Texture(6),
			color = ColorOption(7, L["Color"], { "headerbar" }, true, DisabledBy("headerbar")),
		},
	},
	bg = {
		order = 6,
		type = "group",
		name = L["Background"],
		disabled = DisabledBy("bg"),
		get = Getter("bg"),
		set = Setter("bg"),
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
			},
			transparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
			},
			classBorder = {
				order = 3,
				type = "toggle",
				name = L["Class Color Border"],
			},
		},
	},
	progress = {
		order = 7,
		type = "group",
		name = L["Progress"],
		disabled = Disabled,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Colors objectives like 3/5 by progress."],
				get = Getter("progress"),
				set = function(info, value)
					Setter("progress")(info, value)
					if not value then E:StaticPopup_Show("CONFIG_RL") end
				end,
			},
			good = ColorOption(2, L["Good"], { "progress", "good" }),
			transit = ColorOption(3, L["Transition"], { "progress", "transit" }),
			bad = ColorOption(4, L["Bad"], { "progress", "bad" }),
		},
	},
	bars = {
		order = 8,
		type = "group",
		name = L["Progress Bars"],
		disabled = DisabledBy("bars"),
		get = Getter("bars"),
		set = Setter("bars"),
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Skins the progress and timer bars of the tracker."],
				set = function(info, value)
					Setter("bars")(info, value)
					if not value then E:StaticPopup_Show("CONFIG_RL") end
				end,
			},
			progressColor = {
				order = 2,
				type = "toggle",
				name = L["Progress Color"],
				desc = L["Colors the bars by their value with the progress colors."],
			},
			texture = Texture(3),
			color = ColorOption(4, L["Color"], { "bars", "color" }, true, BarColorDisabled),
		},
	},
}

local args = mMT.options.args.quests.args.objective_tracker.args

args.colors.args.title.args.difficulty = {
	order = 2,
	type = "toggle",
	name = L["Difficulty Color"],
	desc = L["Colors quest titles by their difficulty, like the quest log."],
	get = function()
		return E.db.mMediaTag.objective_tracker.colors.title.difficulty
	end,
	set = function(_, value)
		E.db.mMediaTag.objective_tracker.colors.title.difficulty = value
		Update()
	end,
}
