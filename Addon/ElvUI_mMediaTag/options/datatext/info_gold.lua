local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local function Get(key)
	return function()
		return E.db.mMediaTag.datatexts.gold[key]
	end
end

local function Set(key)
	return function(_, value)
		E.db.mMediaTag.datatexts.gold[key] = value
		DT:ForceUpdate_DataText("mMT - Gold")
	end
end

local function ColorGet(key)
	return function()
		return mMT:HexToRGB(E.db.mMediaTag.datatexts.gold[key])
	end
end

local function ColorSet(key)
	return function(_, r, g, b)
		E.db.mMediaTag.datatexts.gold[key] = E:RGBToHex(r, g, b, "ff")
		DT:ForceUpdate_DataText("mMT - Gold")
	end
end

local function GoalGet(kind)
	return function()
		local gold = DB.gold.goals[kind] or 0
		return gold > 0 and tostring(gold) or ""
	end
end

local function GoalSet(kind)
	return function(_, value)
		M.Gold:SetGoal(kind, floor(tonumber((value:gsub("[%s%.,]", ""))) or 0))
	end
end

local function ValidateGoal(_, value)
	return value == "" or tonumber((value:gsub("[%s%.,]", ""))) ~= nil or L["Please enter a number."]
end

local function ActionValues()
	return M.Gold.ACTION_LABELS
end

mMT.options.args.datatexts.args.info.args.info_gold.args = {
	display = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Display"],
		args = {
			text = {
				order = 1,
				type = "select",
				name = L["Text"],
				values = {
					profit_today = L["Profit today"],
					income_today = L["Income today"],
					gold = L["Gold"],
					account = L["Account gold"],
					daily_goal = L["Daily goal"],
					goal = L["Goal"],
				},
				get = Get("text"),
				set = Set("text"),
			},
			style = {
				order = 2,
				type = "select",
				name = L["Format"],
				values = {
					SMART = L["Smart"],
					FULL = L["Full"],
					SHORT = L["Short"],
					SHORTINT = L["Short (whole numbers)"],
					CONDENSED = L["Condensed"],
					BLIZZARD = "Blizzard",
				},
				get = Get("style"),
				set = Set("style"),
			},
			label = {
				order = 3,
				type = "toggle",
				name = L["Label"],
				get = Get("label"),
				set = Set("label"),
			},
			coins = {
				order = 4,
				type = "toggle",
				name = L["Coin icons"],
				get = Get("coins"),
				set = Set("coins"),
			},
		},
	},
	colors = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Colors"],
		args = {
			color_mode = {
				order = 1,
				type = "select",
				name = L["Text color"],
				values = {
					elvui = "ElvUI",
					class = L["Class"],
					custom = L["Custom"],
				},
				get = Get("color_mode"),
				set = Set("color_mode"),
			},
			text_color = {
				order = 2,
				type = "color",
				name = L["Label"],
				hasAlpha = false,
				hidden = function()
					return E.db.mMediaTag.datatexts.gold.color_mode ~= "custom"
				end,
				get = ColorGet("text_color"),
				set = ColorSet("text_color"),
			},
			value_color = {
				order = 3,
				type = "color",
				name = L["Value"],
				hasAlpha = false,
				hidden = function()
					return E.db.mMediaTag.datatexts.gold.color_mode ~= "custom"
				end,
				get = ColorGet("value_color"),
				set = ColorSet("value_color"),
			},
		},
	},
	goals = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Goals"],
		args = {
			description = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["The daily goal counts today's profit, the gold goal counts your gold without a time limit. Enter 0 or leave it empty to disable a goal. Goals are saved account wide."],
			},
			daily = {
				order = 2,
				type = "input",
				name = L["Daily goal (gold)"],
				validate = ValidateGoal,
				get = GoalGet("daily"),
				set = GoalSet("daily"),
			},
			target = {
				order = 3,
				type = "input",
				name = L["Gold goal (gold)"],
				validate = ValidateGoal,
				get = GoalGet("target"),
				set = GoalSet("target"),
			},
			goal_reference = {
				order = 4,
				type = "select",
				name = L["Goal counts"],
				values = {
					character = _G.CHARACTER,
					account = L["All characters"],
				},
				get = Get("goal_reference"),
				set = Set("goal_reference"),
			},
		},
	},
	clicks = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Clicks"],
		args = {
			left_click = {
				order = 1,
				type = "select",
				name = L["Left Click"],
				values = ActionValues,
				get = Get("left_click"),
				set = Set("left_click"),
			},
			right_click = {
				order = 2,
				type = "select",
				name = L["Right Click"],
				values = ActionValues,
				get = Get("right_click"),
				set = Set("right_click"),
			},
			shift_click = {
				order = 3,
				type = "select",
				name = L["Shift Click"],
				values = ActionValues,
				get = Get("shift_click"),
				set = Set("shift_click"),
			},
		},
	},
	tooltip = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Tooltip"],
		args = {
			tooltip_sources = {
				order = 1,
				type = "toggle",
				name = L["Sources today"],
				get = Get("tooltip_sources"),
				set = Set("tooltip_sources"),
			},
			tooltip_periods = {
				order = 2,
				type = "toggle",
				name = L["Yesterday, week and month"],
				get = Get("tooltip_periods"),
				set = Set("tooltip_periods"),
			},
			tooltip_characters = {
				order = 3,
				type = "toggle",
				name = L["Characters"],
				get = Get("tooltip_characters"),
				set = Set("tooltip_characters"),
			},
		},
	},
	data = {
		order = 6,
		type = "group",
		inline = true,
		name = L["Data"],
		args = {
			description = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Deletes the recorded gold data. Your goals are kept."],
			},
			today = {
				order = 2,
				type = "execute",
				name = L["Reset today"],
				confirm = true,
				confirmText = L["Delete today's income and expenses of this character?"],
				func = function()
					M.Gold:Reset("today")
				end,
			},
			character = {
				order = 3,
				type = "execute",
				name = L["Reset character"],
				confirm = true,
				confirmText = L["Delete the whole history of this character?"],
				func = function()
					M.Gold:Reset("character")
				end,
			},
			all = {
				order = 4,
				type = "execute",
				name = L["Reset all"],
				confirm = true,
				confirmText = L["Delete the data of all characters? Other characters show up again once you log them in."],
				func = function()
					M.Gold:Reset("all")
				end,
			},
		},
	},
}
