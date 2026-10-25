local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local function Disabled()
	return not E.db.mMediaTag.premade_filter.enable
end

local function NotCustom()
	return Disabled() or E.db.mMediaTag.premade_filter.theme ~= "custom"
end

local function Update()
	mMT:UpdateModule("PremadeFilter")
end

local function Toggle(order, key, name, desc)
	return {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
		get = function()
			return E.db.mMediaTag.premade_filter[key]
		end,
		set = function(_, value)
			E.db.mMediaTag.premade_filter[key] = value
			Update()
		end,
	}
end

local function Color(order, key, name, disabled)
	return {
		order = order,
		type = "color",
		name = name,
		hasAlpha = false,
		disabled = disabled,
		get = function()
			local r, g, b = mMT:HexToRGB(E.db.mMediaTag.premade_filter.colors[key])
			return r, g, b
		end,
		set = function(_, r, g, b)
			E.db.mMediaTag.premade_filter.colors[key] = E:RGBToHex(r, g, b, "ff")
			Update()
		end,
	}
end

mMT.options.args.group.args.premade_filter.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.premade_filter.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return E.db.mMediaTag.premade_filter.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.premade_filter.enable = value
			Update()
		end,
	},
	display = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Display"],
		disabled = Disabled,
		args = {
			leader_score = Toggle(1, "leader_score", L["Show Leader Score"], L["Shows the Mythic+ score of the group leader in the group finder list."]),
			short_difficulty = Toggle(2, "short_difficulty", L["Short Difficulty"], L["Shortens the difficulty behind the dungeon name to M+, M, HC or NHC in its difficulty color."]),
		},
	},
	layout = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Layout"],
		disabled = Disabled,
		args = {
			columns = {
				order = 1,
				type = "select",
				name = L["Dungeon Columns"],
				desc = L["The number of columns of the dungeon list."],
				values = { [2] = "2", [3] = "3", [4] = "4" },
				get = function()
					return E.db.mMediaTag.premade_filter.columns
				end,
				set = function(_, value)
					E.db.mMediaTag.premade_filter.columns = value
					Update()
				end,
			},
		},
	},
	colors = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Colors"],
		disabled = Disabled,
		args = {
			theme = {
				order = 1,
				type = "select",
				name = L["Theme"],
				values = { class = L["Class Color"], neutral = L["Neutral"], mmt = mMT.NameShort, custom = L["Custom Color"] },
				get = function()
					return E.db.mMediaTag.premade_filter.theme
				end,
				set = function(_, value)
					E.db.mMediaTag.premade_filter.theme = value
					Update()
				end,
			},
			theme_color = Color(2, "theme", L["Theme color"], NotCustom),
			bar_color = Color(3, "bar", L["Bar Color"], NotCustom),
			spacer = {
				order = 4,
				type = "description",
				name = "",
			},
			applied = Color(5, "applied", L["Applied Color"]),
			declined = Color(6, "declined", L["Declined Color"]),
			full = Color(7, "full", L["Full Color"]),
		},
	},
}
